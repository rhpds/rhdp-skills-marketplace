# GitOps Automation Guide

How to create GitOps automation for RHDP lab/demo environments using
Helm + ArgoCD. Follows the patterns in `https://github.com/rhpds/ci-template-gitops`.

## When to Use GitOps vs Ansible

| Use GitOps When | Use Ansible When |
|----------------|------------------|
| Environment is fully declarative (K8s manifests) | Tasks require imperative logic (wait loops, conditionals) |
| Changes should be continuously reconciled | One-time setup is sufficient |
| Lab teaches GitOps concepts (ArgoCD is the point) | Lab doesn't involve GitOps |
| `self_published` deployment mode | `rhdp_published` with complex ordering needs |

Many `rhdp_published` labs use both — Ansible for initial cluster setup (operators, auth)
and GitOps for application workloads that benefit from continuous reconciliation.

## Architecture: Three Layers

```
cluster/infra/       → Operators and cluster infrastructure (deployed once per cluster)
         ↓ spawns (rhdp_published only)
cluster/platform/    → Shared services for all users (deployed once per cluster)

tenant/              → Per-user lab workloads (deployed per user)
```

**For `self_published`:** Only `cluster/infra/` and `tenant/` are relevant. Platform
layer is skipped. The two layers are deployed simultaneously by separate Field Source
CI workloads — ArgoCD eventual consistency handles any ordering (operators install,
then tenant resources sync automatically on retry).

**For `rhdp_published`:** All three layers are available. Platform is spawned by the
infra bootstrap. Two separate AgnosticV CIs (cluster + tenant) invoke the role in order.

## Repo Structure

Generate these directories in `automation/`:

```
automation/
├── cluster/
│   └── infra/
│       ├── Chart.yaml              # "bootstrap-infra" umbrella chart
│       ├── values.yaml             # All workload config; deployer.* injected at deploy time
│       └── templates/
│           ├── application-<operator>.yaml   # One ArgoCD Application per operator
│           └── configmap-provisiondata.yaml  # Cluster-level provision data (if needed)
├── tenant/
│   ├── bootstrap/
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   └── templates/
│   │       ├── application-<lab>.yaml        # ArgoCD Application per workload
│   │       └── configmap-provisiondata.yaml  # Tenant-level provision data
│   └── labs/
│       └── <project-id>/           # The lab's own Helm chart
│           ├── Chart.yaml
│           ├── values.yaml
│           └── templates/
│               ├── namespace.yaml
│               ├── rbac.yaml
│               ├── deployment.yaml
│               ├── service.yaml
│               ├── route.yaml
│               └── configmap-provisiondata.yaml
```

## Values Structure

```yaml
# values.yaml pattern (both cluster/infra and tenant/bootstrap)

# Deployer values — injected by the Ansible role at deploy time from live cluster
# Never set these in the catalog or commit them with real values
deployer:
  domain: ""      # apps.cluster-guid.example.com
  apiUrl: ""      # https://api.cluster-guid.example.com:6443
  guid: ""

# Per-workload config — all disabled by default
myWorkload:
  enabled: false
  namespace: "NAMESPACE-MUST-BE-SET"   # Fails loud if catalog doesn't override
```

## Enable/Disable Pattern

Every workload has `enabled: false` by default. The Field Source CI catalog enables
specific workloads by passing values at deploy time.

```yaml
# In ArgoCD Application template
{{- if .Values.myWorkload.enabled }}
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-workload
  namespace: openshift-gitops
  labels:
    demo.redhat.com/application: "field-content"
spec:
  project: tenants
  source:
    repoURL: https://github.com/<org>/<repo>.git
    targetRevision: main
    path: tenant/labs/my-workload
    helm:
      values: |
        deployer: {{ .Values.deployer | toYaml | nindent 10 }}
        myWorkload: {{ .Values.myWorkload | toYaml | nindent 10 }}
  destination:
    server: https://kubernetes.default.svc
    namespace: {{ .Values.myWorkload.namespace }}
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
      - SkipDryRunOnMissingResource=true   # Handles CRDs appearing after operator install
      - RespectIgnoreDifferences=true      # Operators mutate their own fields
    retry:
      limit: 10
      backoff:
        duration: 5s
        factor: 2
        maxDuration: 3m
{{- end }}
```

**`SkipDryRunOnMissingResource: true` is essential** for self_published projects.
When the cluster and tenant layers deploy simultaneously, the operator CRDs don't
exist yet when the tenant Application first syncs. This flag lets ArgoCD apply what
it can and skip what it can't — on retry (once the operator is ready), everything syncs.

## Three Tenant Deployment Patterns

### Pattern 1: Inline Resources (Simplest)

Resources rendered directly in `tenant/bootstrap/templates/`. No sub-chart needed.

```yaml
# tenant/bootstrap/templates/namespace.yaml
{{- if .Values.myLab.enabled }}
apiVersion: v1
kind: Namespace
metadata:
  name: {{ .Values.myLab.namespace }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: lab-user-edit
  namespace: {{ .Values.myLab.namespace }}
spec:
  roleRef:
    kind: ClusterRole
    name: edit
  subjects:
    - kind: User
      name: {{ .Values.myLab.username }}
{{- end }}
```

**Use when:** A few RBAC or namespace resources. No independent sync status needed.

**Critical:** Always set explicit `namespace` on every resource — without it, resources
deploy to `openshift-gitops`.

### Pattern 2: Helm Sub-chart (Standard Lab Workload)

Bootstrap creates a child ArgoCD Application pointing at `tenant/labs/<project-id>/`.

```yaml
# tenant/bootstrap/templates/application-my-lab.yaml
{{- if .Values.labs.myLab.enabled }}
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-lab-{{ .Values.deployer.guid }}
  namespace: openshift-gitops
spec:
  project: tenants
  source:
    path: tenant/labs/my-lab
    helm:
      values: |
        namespace: {{ .Values.labs.myLab.namespace | quote }}
        deployer: {{ .Values.deployer | toYaml | nindent 10 }}
{{- end }}
```

**Use when:** Multi-resource lab workload. This is the standard pattern for most labs.

### Pattern 3: Parameterized Sub-chart (Catalog-Driven)

Like Pattern 2, but all meaningful values come from the Field Source CI catalog at order time.
The namespace is intentionally `NAMESPACE-MUST-BE-SET` in defaults to fail loud if not provided.

**Use when:** Lab has configurable parameters (e.g., `num_users`, feature flags).

## Provision Data

Surface per-user connection info to RHDP via labeled ConfigMaps:

```yaml
# tenant/labs/<project-id>/templates/configmap-provisiondata.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: provisiondata-{{ .Values.deployer.guid }}
  namespace: {{ .Values.namespace }}
  labels:
    demo.redhat.com/tenant-{{ .Values.deployer.guid }}: "true"   # Required for RHDP pickup
data:
  # Showroom URL — always include
  showroom_url: "https://showroom-{{ .Values.namespace }}.{{ .Values.deployer.domain }}"

  # Per-user app URLs
  app_url: "https://my-app-{{ .Values.namespace }}.{{ .Values.deployer.domain }}"
  namespace: "{{ .Values.namespace }}"
  cluster_domain: "{{ .Values.deployer.domain }}"
```

The `demo.redhat.com/tenant-<guid>: "true"` label tells RHDP to pick up this ConfigMap's
data and surface it to the user. Every key becomes an `{attribute}` variable in Showroom.

**Always include `showroom_url`** — Showroom is the default delivery vehicle for lab guides.

## Field Source CI Integration (`self_published`)

Self-published labs use two roles deployed simultaneously. ArgoCD eventual consistency
handles any operator → CR ordering automatically:

```yaml
# common.yaml (cluster workload — runs once per cluster)
workloads:
  - agnosticd.core_workloads.ocp4_workload_field_content_cluster

ocp4_workload_field_content_cluster_repo_url: https://github.com/<org>/<repo>.git
ocp4_workload_field_content_cluster_repo_revision: main
ocp4_workload_field_content_cluster_repo_path: cluster/infra

# Values passed to the cluster Helm chart
ocp4_workload_field_content_cluster_helm_values:
  rhbkOperator:
    enabled: true
    namespace: openshift-operators
    channel: stable-v26
```

```yaml
# common.yaml (tenant workload — runs once per user/namespace)
workloads:
  - agnosticd.core_workloads.ocp4_workload_field_content_tenant

ocp4_workload_field_content_tenant_repo_url: https://github.com/<org>/<repo>.git
ocp4_workload_field_content_tenant_repo_revision: main
ocp4_workload_field_content_tenant_repo_path: tenant/bootstrap

# Values passed to the tenant Helm chart
ocp4_workload_field_content_tenant_helm_values:
  labs:
    myLab:
      enabled: true
      namespace: "lab-{{ guid }}"
  deployer:
    guid: "{{ guid }}"
```

**Note:** Both roles deploy ArgoCD Applications and return immediately — no health
waiting. The Field Source CI owns the overall lifecycle; RHDP is not responsible for
whether the ArgoCD apps eventually converge.

## AgnosticV Integration (`rhdp_published`)

```yaml
# Cluster CI common.yaml
workloads:
  - agnosticd.core_workloads.ocp4_workload_gitops_bootstrap

ocp4_workload_gitops_bootstrap_repo_url: https://github.com/<org>/<repo>.git
ocp4_workload_gitops_bootstrap_repo_revision: main
ocp4_workload_gitops_bootstrap_repo_path: cluster/infra/bootstrap
ocp4_workload_gitops_bootstrap_application_name: bootstrap-infra
ocp4_workload_gitops_bootstrap_application_project: infra

ocp4_workload_gitops_bootstrap_helm_values:
  myOperator:
    enabled: true
```

```yaml
# Tenant CI common.yaml
workloads:
  - agnosticd.core_workloads.ocp4_workload_gitops_bootstrap

ocp4_workload_gitops_bootstrap_repo_url: https://github.com/<org>/<repo>.git
ocp4_workload_gitops_bootstrap_repo_revision: main
ocp4_workload_gitops_bootstrap_repo_path: tenant/bootstrap
ocp4_workload_gitops_bootstrap_application_name: "bootstrap-{{ guid }}"
ocp4_workload_gitops_bootstrap_application_project: tenants

ocp4_workload_gitops_bootstrap_helm_values:
  tenant:
    name: "{{ guid }}"
  labs:
    myLab:
      enabled: true
      namespace: "user-{{ guid }}-my-lab"
```

## What to Automate vs What the Learner Does

See the automation manifest format for the full decision framework. Key rule:
if the lab says "open the application at..." or "navigate to the console and observe...",
those resources must be pre-deployed. If the lab says "run oc apply -f...", the learner
does that themselves.
