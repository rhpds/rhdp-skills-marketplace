# Sandbox API — Cluster CI Questions

This file is referenced from `SKILL.md` Step 3 Branch 3A.

A **Cluster CI** provisions a shared OCP cluster that multiple tenants will deploy workloads onto.
It does NOT provision per-user workloads — those come from a companion Tenant CI.

**Reference examples (read before generating):**
- `@agnosticv/skills/catalog-builder/examples/sandbox-cluster/` — canonical cluster CI example
- `~/work/code/agnosticv/tests/ex-multi-user-ocp-cluster/` (in your agnosticv repo) — official agnosticv test example (Nate Stephany / Judd Maltin)

---

## Auto-set (no questions needed)

These are always written exactly as shown for every Cluster CI:

```yaml
config: openshift-workloads
cloud_provider: none
num_users: 0

clusters:
- default:
    api_url: "{{ openshift_api_url }}"
    api_token: "{{ openshift_cluster_admin_token }}"
```

Includes — always add both:
```
#include /includes/sandbox-api.yaml
#include /includes/access-restriction-admins-only.yaml
```

`propagate_provision_data` — always include the full standard set:
```yaml
  components:
  - name: openshift
    display_name: OpenShift Cluster
    item: agd-v2/ocp-cluster-cnv-pools   # or ocp-cluster-aws-pools
    propagate_provision_data:
    - name: openshift_api_ca_cert
      var: openshift_api_ca_cert
    - name: openshift_api_url
      var: openshift_api_url
    - name: openshift_cluster_admin_token
      var: openshift_api_key
    - name: openshift_cluster_admin_token
      var: openshift_cluster_admin_token
    - name: bastion_public_hostname
      var: bastion_ansible_host
    - name: bastion_ssh_user_name
      var: bastion_ansible_user
    - name: bastion_ssh_password
      var: bastion_ansible_ssh_pass
    - name: bastion_ssh_port
      var: bastion_ansible_port
    - name: sandbox_openshift_api_key
      var: sandbox_openshift_api_key
    - name: sandbox_openshift_api_url
      var: sandbox_openshift_api_url
    - name: sandbox_openshift_namespace
      var: sandbox_openshift_namespace
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

---

## Questions — ask in order

### Q-C1: Cloud provider for cluster pool

```
Which cluster pool type?

  A) CNV  — OpenShift Virtualization (recommended)
  B) AWS  — AWS-hosted cluster

Choice [A/B]:
```

- CNV → `item: agd-v2/ocp-cluster-cnv-pools`
- AWS → `item: agd-v2/ocp-cluster-aws-pools`

---

### Q-C2: OCP Version

```
Which OCP version for this cluster?
  4.18 / 4.20 / 4.21

OCP version:
```

→ Sets `parameter_values.host_ocp4_installer_version: '4.20'` (or chosen version)

---

### Q-C3: Lab label

```
What label identifier will tenants use to target this cluster?

This value goes into cloud_selector.lab on both this Cluster CI and
every Tenant CI that uses it. Choose something unique and descriptive.

Examples: ex-multi-user-ocp, summit-2026-mcp, rh1-2026-rhads

Lab label:
```

→ Document this value prominently — Tenant CIs must match it exactly.
→ Does NOT go into common.yaml directly, but note it in a comment at the top.

---

### Q-C4: Worker sizing

```
How many concurrent tenant placements will this cluster support?

Sizing guide (each worker node: 8 cores / 16Gi):
  - Light tenants  (~2 CPU / 4Gi each)  → placements × 0.25 = worker_instance_count
  - Medium tenants (~4 CPU / 8Gi each)  → placements × 0.5  = worker_instance_count
  - Heavy tenants  (~8 CPU / 16Gi each) → placements = worker_instance_count

How many concurrent tenants?
Tenant workload weight (light / medium / heavy)?
```

→ Calculate and set:
```yaml
openshift_cnv_scale_cluster: true
worker_instance_count: <calculated>
ai_workers_cores: 8
ai_workers_memory: 16Gi
```

Add a comment showing the math:
```yaml
# Sizing: <N> tenants × <weight> = <worker_instance_count> workers
# Worker spec: 8 cores / 16Gi each
```

---

### Q-C5: Cluster-level workloads

```
Which cluster-level workloads to deploy?
(These run once on the shared cluster — not per-tenant)

  ✓ ocp4_workload_authentication    (keycloak — required for tenant user creation)
  + ocp4_workload_ocp_console_embed (required if tenants use Showroom with OCP console embed)
  + ocp4_workload_openshift_gitops  (cluster-level GitOps — optional)
  + other?

Include OCP console embed (needed for Showroom)? [Y/n]
Include GitOps? [Y/n]
Any other cluster workloads?
```

Always include authentication:
```yaml
workloads:
- agnosticd.core_workloads.ocp4_workload_authentication
```

If tenants use Showroom with OCP console embed, add to Cluster CI (not Tenant CI — this is a one-time cluster operation):
```yaml
- agnosticd.showroom.ocp4_workload_ocp_console_embed
```

Add the showroom collection to `requirements_content.collections` if not already present:
```yaml
  - name: https://github.com/agnosticd/showroom.git
    type: git
    version: v1.6.0
```

Authentication vars (always keycloak for Cluster CI):
```yaml
ocp4_workload_authentication_provider: keycloak
ocp4_workload_authentication_keycloak_channel: stable-v26.4
```

If GitOps selected, add:
```yaml
- agnosticd.core_workloads.ocp4_workload_openshift_gitops
```

With standard GitOps vars:
```yaml
ocp4_workload_openshift_gitops_channel: latest
ocp4_workload_openshift_gitops_setup_cluster_admin: true
ocp4_workload_openshift_gitops_update_route_tls: true
ocp4_workload_openshift_gitops_rbac_update: true
ocp4_workload_openshift_gitops_rbac_policy: |
  g, system:cluster-admins, role:admin
  g, admin, role:admin
ocp4_workload_openshift_gitops_rbac_scopes: '[name,groups]'
ocp4_workload_openshift_gitops_resource_tracking_method: annotation
```

---

## collections

Always include:
```yaml
tag: main
requirements_content:
  collections:
  - name: https://github.com/rhpds/assisted_installer.git
    type: git
    version: v0.0.9
  - name: https://github.com/agnosticd/core_workloads.git
    type: git
    version: "{{ tag }}"
```

---

↩ Return to SKILL.md — continue from Step 7 (catalog details).

Note: `catalog.parameters` should be `[]` (empty) — Cluster CI takes no user parameters.
`catalog.multiuser: false` — the cluster itself is single, tenants come from the Tenant CI.
