# Sandbox API Validator Checks

This file is referenced from `validator/SKILL.md` Check 6 for two CI types:
- **Tenant CI** — `config: namespace`, `cloud_provider: none`
- **Cluster CI** — `config: openshift-workloads`, `cloud_provider: none`, `num_users: 0`

Detect which type first, then run the appropriate checks.

---

## Tenant CI Checks (config: namespace)

### Check 6C: sandboxes block

**ERROR** if `__meta__.sandboxes` is missing:
```
ERROR: Tenant CI requires __meta__.sandboxes to select the target cluster.
Add:
  sandboxes:
    - kind: OcpSandbox
      cloud_selector:
        cloud: cnv-dedicated-shared   # or aws-dedicated-shared
        lab: <your-lab-label>
```

**ERROR** if `sandboxes[0].kind` is not `OcpSandbox`:
```
ERROR: sandboxes[0].kind must be 'OcpSandbox' for OCP-based Tenant CIs.
Found: <actual value>
```

**ERROR** if `cloud_selector.cloud` is missing or not one of `cnv-dedicated-shared`, `aws-dedicated-shared`:
```
ERROR: cloud_selector.cloud must be 'cnv-dedicated-shared' or 'aws-dedicated-shared'.
Found: <actual value>
```

**ERROR** if `cloud_selector.lab` is missing or empty:
```
ERROR: cloud_selector.lab is required — it must match the lab label set on the Cluster CI.
Without it, the Sandbox API cannot select the correct cluster for this tenant.
```

---

### Check 6D: sandbox_api

**ERROR** if `sandbox_api.actions.destroy.catch_all` is not explicitly `false`:
```
ERROR: Tenant CI must set sandbox_api.actions.destroy.catch_all: false
This ensures remove_workloads runs to clean up tenant resources before
the sandbox is released back to the pool.

Add to __meta__:
  sandbox_api:
    actions:
      destroy:
        catch_all: false
```

---

### Check 6E: namespaced_workloads collection and tenant workloads

**ERROR** if `namespaced_workloads` collection not present in `requirements_content.collections`:
```
ERROR: Tenant CI requires the namespaced_workloads collection.
Add to requirements_content.collections:
  - name: https://github.com/agnosticd/namespaced_workloads.git
    type: git
    version: "{{ tag }}"
```

**ERROR** if `ocp4_workload_tenant_keycloak_user` not in `workloads`:
```
ERROR: Tenant CI must include ocp4_workload_tenant_keycloak_user workload.
This creates the RHBK user on the shared cluster for this tenant.
```

**ERROR** if `ocp4_workload_tenant_namespace` not in `workloads`:
```
ERROR: Tenant CI must include ocp4_workload_tenant_namespace workload.
This creates the required namespaces for this tenant's workloads.
```

**WARNING** if `ocp4_workload_tenant_namespace_username` is defined but does not match `ocp4_workload_tenant_keycloak_username`:
```
WARNING: ocp4_workload_tenant_namespace_username and ocp4_workload_tenant_keycloak_username
must use the same value — both should be "user-{{ guid }}".
Mismatch will cause namespace access permission failures.
```

---

### Check 6F: remove_workloads

**WARNING** if `remove_workloads` is missing:
```
WARNING: Tenant CI should define remove_workloads to clean up tenant resources on destroy.
Add (in reverse workload order):
  remove_workloads:
    - agnosticd.namespaced_workloads.ocp4_workload_tenant_namespace
    - agnosticd.namespaced_workloads.ocp4_workload_tenant_keycloak_user
```

**WARNING** if `remove_workloads` is defined but missing `ocp4_workload_tenant_namespace` or `ocp4_workload_tenant_keycloak_user`:
```
WARNING: remove_workloads should include both ocp4_workload_tenant_namespace
and ocp4_workload_tenant_keycloak_user to fully clean up the tenant on destroy.
```

---

### Check 6G: deployer actions

**WARNING** if `deployer.actions.status.disable` is not `true`:
```
WARNING: Tenant CI should set deployer.actions.status.disable: true.
Status action is not supported for namespace-config Tenant CIs.
```

**WARNING** if `deployer.actions.update.disable` is not `true`:
```
WARNING: Tenant CI should set deployer.actions.update.disable: true.
Update action is not supported for namespace-config Tenant CIs.
```

---

## Cluster CI Checks (config: openshift-workloads, cloud_provider: none, num_users: 0)

### Check 6H: Required includes

**ERROR** if `#include /includes/sandbox-api.yaml` is not present in any of the catalog files:
```
ERROR: Cluster CI requires #include /includes/sandbox-api.yaml
Add to common.yaml includes section.
```

**ERROR** if `#include /includes/access-restriction-admins-only.yaml` is not present:
```
ERROR: Cluster CI requires #include /includes/access-restriction-admins-only.yaml
Cluster CIs must be admin-only — they provision shared infrastructure,
not user-facing catalog items.
```

---

### Check 6I: propagate_provision_data

Check the component entry for `propagate_provision_data`.

**WARNING** if `propagate_provision_data` is missing from the component:
```
WARNING: Cluster CI component is missing propagate_provision_data.
Tenant CIs will not receive cluster credentials (API URL, token, bastion).
```

**WARNING** for each of these missing from `propagate_provision_data`:
- `openshift_api_url`
- `openshift_cluster_admin_token`
- `sandbox_openshift_api_url`
- `sandbox_openshift_namespace`

```
WARNING: propagate_provision_data is missing <key>.
Tenant CIs depend on this value to connect to the cluster.
```

---

### Check 6J: deployer actions

**WARNING** if `deployer.actions.status.disable` is not `true`:
```
WARNING: Cluster CI should set deployer.actions.status.disable: true.
```

**WARNING** if `deployer.actions.update.disable` is not `true`:
```
WARNING: Cluster CI should set deployer.actions.update.disable: true.
```

---

↩ Return to validator SKILL.md — continue with shared checks (Check 9 onward).
