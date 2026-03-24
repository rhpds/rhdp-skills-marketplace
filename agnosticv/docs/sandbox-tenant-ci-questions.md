# Sandbox API — Tenant CI Questions

This file is referenced from `SKILL.md` Step 3 Branch 3B.

A **Tenant CI** deploys per-user workloads on a pre-configured OCP cluster selected
via sandbox labels. It requires a companion Cluster CI to be provisioned first.

**Reference examples (read before generating):**
- `@agnosticv/skills/catalog-builder/examples/sandbox-tenant/` — canonical tenant CI example
- `~/work/code/agnosticv/tests/ex-multi-user-ocp-tenant/` (in your agnosticv repo) — official agnosticv test example (Nate Stephany)

---

## Auto-set (no questions needed)

```yaml
config: namespace
cloud_provider: none

clusters:
- default:
    api_url: "{{ sandbox_openshift_api_url }}"
    api_token: "{{ cluster_admin_agnosticd_sa_token }}"

common_password: "{{ common_password | default('redhat') }}"

tag: main
```

Username pattern (always):
```yaml
ocp4_workload_tenant_keycloak_username: "user-{{ guid }}"
ocp4_workload_tenant_keycloak_user_password: "{{ common_password }}"
ocp4_workload_tenant_namespace_username: "user-{{ guid }}"
```

`sandbox_api` — always set:
```yaml
  sandbox_api:
    actions:
      destroy:
        catch_all: false
```

`deployer.actions` — always disable status and update:
```yaml
    actions:
      destroy:
        disable: false
      start:
        disable: false
      status:
        disable: true
      stop:
        disable: false
      update:
        disable: true
```

Base workloads — always included (in this order):
```yaml
workloads:
  - agnosticd.namespaced_workloads.ocp4_workload_tenant_keycloak_user
  - agnosticd.namespaced_workloads.ocp4_workload_tenant_namespace
  # gitops_bootstrap added here if Q-T3 = yes
  # ocp4_workload_ocp_console_embed + ocp4_workload_showroom added if Q-T4 = yes
```

`remove_workloads` — reverse order, always:
```yaml
remove_workloads:
  # ocp4_workload_showroom added here if Q-T4 = yes
  # ocp4_workload_gitops_bootstrap added here if Q-T3 = yes
  - agnosticd.namespaced_workloads.ocp4_workload_tenant_namespace
  - agnosticd.namespaced_workloads.ocp4_workload_tenant_keycloak_user
```

---

## Questions — ask in order

### Q-T1: Cluster target (cloud_selector)

```
Which cluster does this Tenant CI target?

  Cloud provider:
    A) cnv-dedicated-shared  (CNV cluster)
    B) aws-dedicated-shared  (AWS cluster)

  Lab label (must match the Cluster CI's label exactly):
    Lab label:
```

→ Generates `__meta__.sandboxes`:
```yaml
  sandboxes:
    - kind: OcpSandbox
      cloud_selector:
        cloud: cnv-dedicated-shared   # or aws-dedicated-shared
        lab: <lab-label>
        # purpose: prod              # uncomment for production
```

---

### Q-T2: Tenant namespaces

```
What namespaces does each tenant need?

Each namespace is created as: {suffix}-user-{guid}

Provide suffix names and optional CPU/memory quotas.

Example:
  - suffix: myapp
    quota:
      limits.cpu: "2"
      limits.memory: 4Gi
  - suffix: mydb
    quota:
      limits.cpu: "1"
      limits.memory: 2Gi

Namespace suffixes (add as many as needed):
```

→ Sets:
```yaml
ocp4_workload_tenant_namespace_namespaces:
  - suffix: <suffix>
    quota:
      limits.cpu: "<N>"
      limits.memory: <N>Gi
```

If no specific quotas needed, use:
```yaml
ocp4_workload_tenant_namespace_suffixes:
  - <suffix>
  - <suffix>
```

---

### Q-T3: GitOps bootstrap?

```
Does this tenant deploy workloads via ArgoCD / GitOps? [Y/n]

If YES:
  GitOps repo URL:
  GitOps repo branch/ref (default: main):
  Bootstrap application name (default: bootstrap-tenant):
```

If YES — add to workloads (after tenant_namespace, before Showroom):
```yaml
  - agnosticd.core_workloads.ocp4_workload_gitops_bootstrap
```

Add to remove_workloads (after Showroom, before tenant_namespace):
```yaml
  - agnosticd.core_workloads.ocp4_workload_gitops_bootstrap
```

And set vars:
```yaml
ocp4_workload_gitops_bootstrap_repo_url: <repo-url>
ocp4_workload_gitops_bootstrap_repo_revision: main
ocp4_workload_gitops_bootstrap_application_name: "bootstrap-tenant"

ocp4_workload_gitops_bootstrap_helm_values:
  tenant:
    name: "{{ guid }}"
    user:
      name: "{{ ocp4_workload_tenant_keycloak_username }}"
  # add app-specific namespace mappings here, e.g.:
  # myapp:
  #   namespace: "myapp-{{ ocp4_workload_tenant_keycloak_username }}"
```

---

### Q-T4: Showroom?

```
Does this tenant need a Showroom lab UI? [Y/n]

If YES:
  Showroom content repo URL:
  Showroom version (default: v1.5.6):
```

If YES — add to collections:
```yaml
  - name: https://github.com/agnosticd/showroom.git
    type: git
    version: v1.5.6
```

Add to workloads:
```yaml
  - agnosticd.showroom.ocp4_workload_showroom
```

**Do NOT add `ocp4_workload_ocp_console_embed` here.** It configures cluster-level OAuth and CORS for the OCP console embed — a one-time cluster operation. It belongs in the **Cluster CI** catalog, not in the Tenant CI (which runs per-user).

Add to remove_workloads (first item):
```yaml
  - agnosticd.showroom.ocp4_workload_showroom
```

Set vars — note: Showroom needs explicit OCP vars since it doesn't read sandbox data natively:
```yaml
openshift_api_url: "{{ sandbox_openshift_api_url }}"
openshift_cluster_admin_token: "{{ cluster_admin_agnosticd_sa_token }}"

ocp4_workload_showroom_namespace: "{{ ocp4_workload_tenant_keycloak_username }}-showroom"
ocp4_workload_showroom_content_git_repo: <repo-url>
ocp4_workload_showroom_terminal_type: ""
ocp4_workload_showroom_content_ui_config: |
  type: showroom
  default_width: 40
  persist_url_state: true
  view_switcher:
    enabled: true
    default_mode: split
  tabs:
  - name: Terminal
    path: /wetty
    port: 443
  - name: OpenShift Console
    url: 'https://console-openshift-console.{{ openshift_cluster_ingress_domain }}'
```

---

## collections

Always include (base):
```yaml
requirements_content:
  collections:
  - name: https://github.com/agnosticd/namespaced_workloads.git
    type: git
    version: "{{ tag }}"
  - name: https://github.com/agnosticd/core_workloads.git
    type: git
    version: "{{ tag }}"
```

Add Showroom if Q-T4 = yes:
```yaml
  - name: https://github.com/agnosticd/showroom.git
    type: git
    version: v1.5.6
```

---

↩ Return to SKILL.md — continue from Step 7 (catalog details).

Note: `catalog.parameters` should be `[]` — tenant config comes from the cluster,
not from user-selectable parameters.
`catalog.multiuser: false` — each tenant gets one environment, no shared cluster at this level.
