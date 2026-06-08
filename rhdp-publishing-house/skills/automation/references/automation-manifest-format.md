# Automation Manifest Format

The automation manifest is a structured YAML file that describes what needs to be
automated for a lab or demo environment. It is the contract between content (what
the learner experiences) and automation (what the environment needs pre-configured).

## Purpose

The manifest serves three roles:

1. **Reviewable artifact** — humans review and approve automation scope before code is written
2. **Editable input** — humans can modify, add, or remove requirements; they can also provide one from scratch
3. **Skill input** — the automation-writing skill (Ansible or GitOps) reads this to generate code

## Location

`publishing-house/spec/automation-manifest.yaml`

## When It's Created

The automation manifest is generated during phase 7a (Requirements) by analyzing:
- The design spec (`publishing-house/spec/design.md`)
- Module outlines (`publishing-house/spec/modules/`)
- Content files in `content/` (if they exist)

It can also be provided directly by the user if they already know their automation
requirements. In that case, the agent validates the format and proceeds.

## Format

```yaml
# Automation Manifest
# Describes what the lab/demo environment needs pre-configured.
# Review and approve this before automation code is written.

# How this lab should be automated
approach: ansible | gitops | both

# Infrastructure base
infrastructure:
  # For rhdp_published projects (AgnosticV catalog):
  #   ocp-cnv         — OCP on CNV (most common)
  #   ocp-aws         — OCP on AWS
  #   rhel-vms        — RHEL virtual machines
  #   sandbox-cluster — RHDP Sandbox, one cluster per user
  #   sandbox-tenant  — RHDP Sandbox, shared cluster with namespaces
  #
  # For self_published projects (Field Source CI):
  #   field-per-user-cluster  — Each student gets their own OCP cluster.
  #                             Use for admin-level labs (operator installs, cluster config).
  #                             One user provisioned per deployment (num_users=1 effectively).
  #   field-shared-cluster    — One cluster, N namespaces. num_users controls how many
  #                             copies of tenant resources are deployed. Use for
  #                             namespace-scoped labs where students don't interfere.
  type: ocp-cnv | ocp-aws | rhel-vms | sandbox-cluster | sandbox-tenant | field-per-user-cluster | field-shared-cluster
  topology: per-user-cluster | shared-cluster  # self_published only
  ocp_version: "4.17"             # If applicable
  multi_user: true                 # Does the lab support multiple concurrent users?
  users_per_deployment: 25         # If multi_user; for field-shared-cluster, set by num_users at order time

# Operators that must be installed BEFORE the lab starts.
# These are operators the learner will USE, not install.
operators:
  - name: Red Hat OpenShift Pipelines
    channel: latest
    namespace: openshift-operators
    reason: "Module 2 uses Tekton pipelines — learner configures them, doesn't install"
    source_module: module-02-pipelines

  - name: Red Hat OpenShift GitOps
    channel: latest
    namespace: openshift-operators
    reason: "ArgoCD UI used throughout modules 3-5"
    source_module: module-03-gitops

# Applications or services that must be deployed and running.
applications:
  - name: sample-app
    description: "Spring Boot application the learner will deploy updates to"
    namespace: "{{ user_namespace }}"
    image: quay.io/org/sample-app:v1.0
    resources:
      - kind: Deployment
      - kind: Service
      - kind: Route
    reason: "Module 1 starts with 'open the application at...' — must already exist"
    source_module: module-01-overview

  - name: postgresql
    description: "Database with sample data for the application"
    namespace: "{{ user_namespace }}"
    image: registry.redhat.io/rhel9/postgresql-15:latest
    resources:
      - kind: Deployment
      - kind: Service
      - kind: PersistentVolumeClaim
      - kind: Secret
    reason: "Application depends on database; learner never creates it"
    source_module: module-01-overview

# User accounts, roles, and RBAC configuration.
rbac:
  - type: namespace
    name: "{{ user_namespace }}"
    reason: "Per-user namespace for lab resources"

  - type: cluster-role-binding
    role: edit
    subjects: "{{ user }}"
    namespace: "{{ user_namespace }}"
    reason: "Learner needs edit access to deploy and modify resources"

# Sample data, git repos, or files that must exist.
seed_data:
  - type: git-repo
    name: sample-app-source
    url: https://github.com/rhpds/sample-app.git
    target: gitea  # or: none (just clone), gitlab
    reason: "Module 2 uses Tekton pipeline triggered from this repo"
    source_module: module-02-pipelines

  - type: configmap
    name: lab-config
    namespace: "{{ user_namespace }}"
    data:
      app_name: sample-app
      environment: development
    reason: "Referenced in module 3 as pre-existing config"
    source_module: module-03-gitops

# Network configuration (routes, ingress, network policies).
network: []
  # - type: route
  #   name: my-route
  #   service: my-service
  #   namespace: "{{ user_namespace }}"
  #   reason: "..."

# Intentionally broken or misconfigured resources (for troubleshooting labs).
broken_resources:
  - name: broken-pod
    namespace: "{{ user_namespace }}"
    description: "Pod with typo in nodeSelector — learner debugs with Lightspeed"
    what_is_broken: "nodeSelector uses 'wrker' instead of 'worker'"
    resources:
      - kind: Pod
    reason: "Module 4 exercise: 'Troubleshoot why the pod is in Pending state'"
    source_module: module-04-troubleshooting

# Information to return to RHDP after deployment (provision data).
provision_data:
  - key: app_url
    value: "https://sample-app-{{ user_namespace }}.{{ deployer.domain }}"
    description: "URL to the sample application"

  - key: gitea_url
    value: "https://gitea-{{ user_namespace }}.{{ deployer.domain }}"
    description: "URL to the Gitea instance with source code"

# Notes for the automation developer (free text).
notes: |
  The Pipelines operator must be installed before the GitOps operator because
  module 3 creates an ArgoCD Application that deploys a Tekton Pipeline.
```

## Field Reference

### Top Level

| Field | Required | Values | Description |
|-------|----------|--------|-------------|
| `approach` | Yes | `ansible`, `gitops`, `both` | How to implement the automation |
| `infrastructure` | Yes | Object | Base infrastructure details |

### Infrastructure

| Field | Required | Description |
|-------|----------|-------------|
| `type` | Yes | Infrastructure type — see taxonomy in format header |
| `topology` | self_published only | `per-user-cluster` or `shared-cluster` |
| `ocp_version` | If OCP | Target OpenShift version |
| `multi_user` | Yes | Whether the lab supports concurrent users |
| `users_per_deployment` | If multi_user | Expected user count; for `field-shared-cluster`, driven by `num_users` at order time |

### Operators, Applications, RBAC, Seed Data, Network, Broken Resources

Each entry has:

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Resource name |
| `reason` | Yes | Why this needs to be automated (traced to content) |
| `source_module` | Yes | Which module outline requires this |

The `reason` and `source_module` fields provide traceability — reviewers can check
whether each automation requirement is actually justified by the content.

### Provision Data

| Field | Required | Description |
|-------|----------|-------------|
| `key` | Yes | Variable name returned to RHDP |
| `value` | Yes | Value template (can use `{{ }}` placeholders) |
| `description` | Yes | Human-readable description |

## Reviewing the Manifest

When reviewing, check:

1. **Every operator/app has a `reason` and `source_module`** — if not, it might be unnecessary
2. **Nothing the learner should do themselves is listed** — the manifest is for pre-configuration only
3. **Provision data covers everything the learner needs to connect** — URLs, credentials, endpoints
4. **Multi-user is correct** — affects namespace naming and resource isolation
5. **Approach matches the lab's needs** — GitOps if the lab teaches GitOps, Ansible otherwise

## Providing a Manifest Directly

Users can skip the content analysis step and provide a manifest directly:

> "I already have my automation requirements. Here's my manifest."

The agent validates the format, presents it for confirmation, and proceeds to code generation.
