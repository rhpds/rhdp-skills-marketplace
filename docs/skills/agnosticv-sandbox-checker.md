---
layout: default
title: agnosticv:sandbox-checker
---

# agnosticv:sandbox-checker

<div class="reference-badge">✓ AgnosticV Subagent</div>

Sandbox API validation subagent. Owns Checks 6C–6J for the `agnosticv:validator` orchestrator. Validates Sandbox API tenant and cluster CI configurations — sandboxes block, catch_all safety, namespaced workload collections, remove_workloads teardown, and deployer action gates.

**This agent is not invoked directly by users.** It is spawned in parallel by the `agnosticv:validator` orchestrator as part of Check 6 routing.

---

## Spawning Condition

`sandbox-checker` is only spawned when `ci_type` is one of:

| `ci_type` | Checks Run |
|---|---|
| `tenant_namespace` | 6C, 6D, 6E, 6F, 6G |
| `shared_pool_cluster` | 6H, 6I, 6J |

Any other `ci_type` — this agent must not be called. If called in error, it returns a routing-error JSON and performs no validation.

---

## Agent Properties

| Property | Value |
|---|---|
| **Model** | claude-haiku-4-5-20251001 |
| **Tools** | Read, Glob, Grep, Bash |
| **Called by** | agnosticv:validator |
| **Returns** | Structured JSON (never prose) |

---

## Input

Receives `shared_context` JSON from the validator orchestrator:

```json
{
  "catalog_path": "/abs/path/to/catalog",
  "agv_path": "/abs/path/to/agnosticv",
  "ci_type": "tenant_namespace | shared_pool_cluster",
  "config_type": "namespace | openshift-workloads",
  "cloud_provider": "none",
  "num_users": 0,
  "validation_scope": "quick | standard | full"
}
```

The agent uses `ci_type` exactly as received. It does not re-derive it.

---

## Check Ownership

### Tenant CI Checks (`ci_type == tenant_namespace`)

<details open>
<summary><strong>Check 6C: sandboxes Block</strong></summary>

Validates the `__meta__.sandboxes` structure required for Sandbox API tenant catalogs.

| Condition | Severity |
|---|---|
| `__meta__.sandboxes` key is missing entirely | ERROR |
| `sandboxes` list is empty | ERROR |
| `sandboxes[0].kind` is not `OcpSandbox` | ERROR |
| `sandboxes[0].cloud_selector.cloud` is missing | ERROR |
| `cloud_selector.cloud` not `cnv-dedicated-shared` or `aws-dedicated-shared` | ERROR |
| `sandboxes[0].cloud_selector.lab` is missing or empty | ERROR |

**Fix:**
```yaml
sandboxes:
  - kind: OcpSandbox
    cloud_selector:
      cloud: cnv-dedicated-shared   # or aws-dedicated-shared
      lab: <your-lab-label>         # must match the lab: label on the Cluster CI
```

</details>

<details>
<summary><strong>Check 6D: sandbox_api catch_all</strong></summary>

Ensures `catch_all: false` is explicitly set so `remove_workloads` runs before sandbox release. Without it, tenant namespaces and RHBK users are left behind in the pool.

| Condition | Severity |
|---|---|
| `__meta__.sandbox_api.actions.destroy.catch_all` not present | ERROR |
| `catch_all` is not `false` (any other value including `true`) | ERROR |

**Fix:**
```yaml
__meta__:
  sandbox_api:
    actions:
      destroy:
        catch_all: false
```

</details>

<details>
<summary><strong>Check 6E: namespaced_workloads Collection and Tenant Workloads</strong></summary>

Validates required tenant workloads and that OCP console embed is not misplaced on the Tenant CI.

| Condition | Severity |
|---|---|
| `ocp4_workload_ocp_console_embed` present in `workloads` | ERROR |
| `namespaced_workloads` collection missing from `requirements_content.collections` | ERROR |
| `ocp4_workload_tenant_keycloak_user` not in `workloads` | ERROR |
| `ocp4_workload_tenant_namespace` not in `workloads` | ERROR |
| `ocp4_workload_tenant_namespace_username` and `ocp4_workload_tenant_keycloak_username` defined and do not match | WARNING |

Note: `ocp4_workload_ocp_console_embed` is a cluster-level OAuth operation. It belongs on the Cluster CI, not the Tenant CI.

</details>

<details>
<summary><strong>Check 6F: remove_workloads</strong></summary>

Validates teardown configuration so tenant resources are cleaned up in the correct order.

| Condition | Severity |
|---|---|
| `remove_workloads` key missing from config | WARNING |
| `remove_workloads` defined but `ocp4_workload_tenant_namespace` absent | WARNING |
| `remove_workloads` defined but `ocp4_workload_tenant_keycloak_user` absent | WARNING |

**Fix:**
```yaml
remove_workloads:
  - agnosticd.namespaced_workloads.ocp4_workload_tenant_namespace
  - agnosticd.namespaced_workloads.ocp4_workload_tenant_keycloak_user
```

`remove_workloads` order should be the reverse of `workloads` for proper teardown sequencing.

</details>

<details>
<summary><strong>Check 6G: Deployer Actions for Tenant CI</strong></summary>

Status and update actions are not supported for `config: namespace` Tenant CIs.

| Condition | Severity |
|---|---|
| `__meta__.deployer.actions.status.disable` is not `true` | WARNING |
| `__meta__.deployer.actions.update.disable` is not `true` | WARNING |

</details>

---

### Cluster CI Checks (`ci_type == shared_pool_cluster`)

<details>
<summary><strong>Check 6H: Required Includes</strong></summary>

Shared pool cluster CIs must include the sandbox API config and access restriction to remain admin-only.

| Condition | Severity |
|---|---|
| `#include /includes/sandbox-api.yaml` not found in any catalog file | ERROR |
| `#include /includes/access-restriction-admins-only.yaml` not found in any catalog file | ERROR |

Detection uses `grep -r '#include' {catalog_path}/` across all catalog files.

</details>

<details>
<summary><strong>Check 6I: propagate_provision_data</strong></summary>

Tenant CIs depend on cluster connection variables. Without them, tenant provisioning fails with missing variable errors.

| Missing Key | Severity |
|---|---|
| `propagate_provision_data` missing from the component entirely | WARNING |
| `openshift_api_url` not present | WARNING |
| `openshift_cluster_admin_token` not present | WARNING |
| `sandbox_openshift_api_url` not present | WARNING |
| `sandbox_openshift_namespace` not present | WARNING |

Each entry may be a dict `{name: openshift_api_url}` or a plain string `openshift_api_url` — both forms are accepted.

</details>

<details>
<summary><strong>Check 6J: Deployer Actions for Cluster CI</strong></summary>

Same gate as 6G — status and update actions must be disabled on Cluster CIs.

| Condition | Severity |
|---|---|
| `__meta__.deployer.actions.status.disable` is not `true` | WARNING |
| `__meta__.deployer.actions.update.disable` is not `true` | WARNING |

</details>

---

## Output Contract

Returns exactly this JSON structure. No prose, no markdown outside the JSON.

```json
{
  "agent": "sandbox-checker",
  "errors": [
    {
      "check": "sandboxes_block",
      "check_id": 6,
      "severity": "ERROR",
      "message": "__meta__.sandboxes is missing",
      "location": "common.yaml:__meta__.sandboxes",
      "fix": "Add sandboxes block with kind: OcpSandbox and cloud_selector",
      "current": null,
      "example": null
    }
  ],
  "warnings": [
    {
      "check": "remove_workloads",
      "check_id": 6,
      "severity": "WARNING",
      "message": "remove_workloads key missing",
      "location": "common.yaml:remove_workloads",
      "recommendation": "Add remove_workloads with tenant_namespace and tenant_keycloak_user"
    }
  ],
  "suggestions": [],
  "passed_checks": [
    "✓ sandboxes block present",
    "✓ sandbox_api.actions.destroy.catch_all: false"
  ]
}
```

All checks in this agent map to `check_id: 6`. Only checks for the active `ci_type` are run — no cross-routing between tenant and cluster check sets.

---

## Related

- [`/agnosticv:validator`](agnosticv-validator.html) — orchestrator that spawns this agent
- [`agnosticv:metadata-checker`](agnosticv-metadata-checker.html) — parallel subagent for metadata and event checks
- [Agent Architecture](../reference/agent-architecture.html) — how orchestration works

---

<div class="navigation-footer">
  <a href="agnosticv-validator.html" class="nav-button">← Back to agnosticv:validator</a>
  <a href="agnosticv-metadata-checker.html" class="nav-button">Next: agnosticv:metadata-checker →</a>
</div>
