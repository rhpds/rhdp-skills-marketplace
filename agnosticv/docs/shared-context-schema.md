# AgnosticV Shared Context Schema

**Version:** 1.0.0 (Phase 2 decomposition)  
**Used by:** agnosticv:catalog-builder (orchestrator), agnosticv:validator (orchestrator), all subagents

This document is the single source of truth for the `shared_context` JSON object passed between orchestrators and subagents. No agent may define its own context schema — all must use these fields.

---

## catalog-builder shared_context

The orchestrator builds this after collecting all user answers (Steps 0-8). It is passed in full to `agnosticv:config-writer` and `agnosticv:description-writer`.

```json
{
  "agv_path": "/abs/path/to/agnosticv",
  "catalog_path": "/abs/path/to/agnosticv/agd_v2/my-workshop",

  "infra_type": "openshift_ocp | cloud_vms | sandbox_tenant | sandbox_cluster",
  "ci_type": "binder | per_user_dedicated | shared_pool_cluster | tenant_namespace | zero_touch",

  "catalog": {
    "display_name": "My Workshop",
    "short_name": "my-workshop",
    "description": "One or two sentence description.",
    "maintainer_name": "Jane Doe",
    "maintainer_email": "jdoe@redhat.com",
    "catalog_type": "workshop_multiuser | workshop_singleuser | workshop_admin | demo | sandbox",
    "category": "Labs | Demos | Brand_Events | Open_Environments | Sandboxes",
    "multiuser": true,
    "workshop_user_mode": "multi | single | none",
    "workshopLabUiRedirect": false,
    "event": "none | summit-2026 | rh1-2026",
    "lab_id": "",
    "technologies": ["openshift", "ai"],
    "primaryBU": "Hybrid_Platforms",
    "secondaryBU": null,
    "product": "Red_Hat_OpenShift_AI",
    "product_family": "Red_Hat_Cloud",
    "keywords": ["mcp", "trustyai"]
  },

  "infra": {
    "cloud_provider": "none | aws | openshift_cnv",
    "ocp_version": "4.16",
    "num_users": 20,
    "sandbox_architecture": "sno | multinode",
    "worker_count": 3,
    "gpu": false,
    "autoscale": false,
    "autoscale_min": 0,
    "autoscale_max": 0,
    "terminal_type": "wetty | showroom | none",
    "bastion_image": "rhel-9.5",
    "bastion_cores": 2,
    "bastion_memory": 4,
    "icon_include": "catalog-icon-openshift.yaml | catalog-icon-rhel.yaml | catalog-icon-aap.yaml"
  },

  "workloads": [
    "agnosticd.core_workloads.ocp4_workload_authentication"
  ],
  "remove_workloads": [],

  "collections": [
    {
      "name": "https://github.com/agnosticd/core_workloads.git",
      "type": "git",
      "version": "{{ tag }}"
    }
  ],

  "options": {
    "e2e_testing": false,
    "e2e_runner_image": "quay.io/rhpds/zt-runner:v2.4.2",
    "litemaas": false,
    "custom_collection": false,
    "custom_collection_name": null,
    "remove_workloads_on_destroy": true,
    "showroom_url": "https://github.com/rhpds/my-workshop-showroom",
    "ocp_console_embed": false,
    "dev_mode": true
  },

  "meta": {
    "asset_uuid": "auto-generated-by-orchestrator",
    "deployer_scm_ref": "main",
    "deployer_ee_image": "quay.io/agnosticd/ee-multicloud:chained-2026-02-23",
    "disable_start": false,
    "disable_stop": false,
    "disable_status": false,
    "disable_update": false,
    "sandbox_api_catch_all": true
  },

  "passwords": {
    "common_admin_password": "output_dir/common_admin_password",
    "common_user_password": "output_dir/common_user_password"
  },

  "includes": [
    "#include /includes/agd-v2-mapping.yaml",
    "#include /includes/catalog-icon-openshift.yaml",
    "#include /includes/terms-of-service.yaml",
    "#include /includes/parameters/purpose.yaml",
    "#include /includes/parameters/salesforce-id.yaml",
    "#include /includes/secrets/ocp4_token.yaml"
  ]
}
```

### Field Notes

| Field | Required | Notes |
|-------|----------|-------|
| `agv_path` | YES | Absolute path — never relative |
| `catalog_path` | YES | Must be validated (non-existent, ≤50 chars) by orchestrator before passing |
| `ci_type` | YES | Resolved by orchestrator from config+cloud_provider+name. Subagents must not re-derive it. |
| `infra_type` | YES | Drives which infra question file was used; sets routing for infra-checker |
| `meta.asset_uuid` | YES | Generated and collision-checked by orchestrator before spawning agents |
| `includes` | YES | Complete list of `#include` lines, pre-validated for duplicates by orchestrator |
| `passwords` | conditional | Keys present only if workloads require passwords |

---

## validator shared_context

The orchestrator builds this after Step 0 (schema + commitv detection) and a lightweight YAML parse. Passed in full to all subagents.

```json
{
  "catalog_path": "/abs/path/to/agnosticv/agd_v2/my-workshop",
  "agv_path": "/abs/path/to/agnosticv",
  "validation_scope": "quick | standard | full",

  "event_context": "none | summit-2026 | rh1-2026",
  "lab_id": "",

  "ci_type": "binder | per_user_dedicated | shared_pool_cluster | tenant_namespace | zero_touch",
  "config_type": "openshift-workloads | cloud-vms-base | namespace | openshift-cluster",
  "cloud_provider": "none | aws | openshift_cnv",
  "num_users": 0,

  "has_yaml_parse_error": false,

  "commitv_available": false,
  "schema_loaded": false,

  "catalog_slug": "lb2298-my-workshop-aws"
}
```

### Orchestrator Pre-Flight (before spawning ANY subagent)

The orchestrator MUST complete these steps in order before spawning subagents:

1. **Parse `common.yaml`** with `yaml.safe_load`. If parse fails → set `has_yaml_parse_error: true`, return error JSON immediately. Do NOT spawn any subagent.
2. **Detect CI type** from `config:`, `cloud_provider:`, `num_users:`, `__meta__.components`, and catalog directory name:

   | Condition | ci_type |
   |-----------|---------|
   | `config: namespace` | `tenant_namespace` |
   | `config: openshift-cluster` + `cloud_provider: openshift_cnv` | `shared_pool_cluster` |
   | `config: openshift-cluster` + real cloud_provider (aws/azure/gcp) + no `-tenant` pair | `per_user_dedicated` |
   | `config: openshift-workloads` + `cloud_provider: none` + `__meta__.components` present | `binder` |
   | `config: zero-touch-base-rhel` OR in zt-* repo | `zero_touch` |
   | All others | `per_user_dedicated` |

3. **Check for commitv** at `$agv_path/.claude/skills/commitv/SKILL.md`. Set `commitv_available`.
4. **Check for babylon schema** at `$agv_path/.schemas/babylon.yaml`. Set `schema_loaded`.
5. **Extract catalog_slug** from basename of `catalog_path`.
6. **Set validation_scope** (from ph_payload or user choice).

Only after all 6 steps → spawn subagents in parallel (with the gate below).

### Subagent Dispatch Rules

```
Step 0: YAML parse gate
  → if has_yaml_parse_error: return error, STOP

Step 1: Parallel dispatch (all scopes)
  → schema-checker (always)
  → metadata-checker (always)

Step 2: If scope != "quick" AND has_yaml_parse_error == false:
  → workload-checker (parallel)
  → IF ci_type == tenant_namespace OR shared_pool_cluster → sandbox-checker
     ELSE → ocp-infra-checker

Step 3: Merge results, apply cross-agent suppression, generate report
```

---

## Agent Output Contract

Every subagent returns exactly this structure:

```json
{
  "agent": "<agent-name>",
  "errors": [
    {
      "check": "check_name",
      "check_id": 2,
      "severity": "ERROR",
      "message": "...",
      "location": "common.yaml:field",
      "fix": "...",
      "current": null,
      "example": null
    }
  ],
  "warnings": [
    {
      "check": "check_name",
      "check_id": 9,
      "severity": "WARNING",
      "message": "...",
      "location": "...",
      "recommendation": "..."
    }
  ],
  "suggestions": [],
  "passed_checks": ["✓ UUID format valid: abc-123", "✓ Category valid: Labs"]
}
```

The `check_id` field maps to the ownership table in this spec. The orchestrator uses it for deduplication and cross-agent suppression.

---

## CI Type Classification — Reference

The classification logic is owned exclusively by the **validator orchestrator**. All subagents receive `ci_type` as a resolved string — they NEVER re-derive it.

```
Zero-touch: config == 'zero-touch-base-rhel' OR catalog in zt-* agnosticv repo
  → SKIP: deployer completeness, workloads presence, collections, tag variable,
           password_pattern for common_password, anarchy_namespace

Tenant namespace: config == 'namespace'
  → Run: sandbox-checker (Checks 6C-6J)
  → Skip: ocp-infra-checker

Sandbox API cluster: config == 'openshift-cluster' AND cloud_provider == 'openshift_cnv'
  → Run: sandbox-checker (cluster subset of 6C-6J)
  → Skip: ocp-infra-checker

Per-user dedicated cluster: config == 'openshift-cluster' AND cloud_provider in (aws, azure, gcp)
  → Run: ocp-infra-checker
  → Showroom, auth, workshopLabUiRedirect ALL belong here — do NOT flag as misplaced

Binder CI: config == 'openshift-workloads' AND cloud_provider == 'none' AND __meta__.components present
  → Run: ocp-infra-checker
  → Showroom, auth BELONG here — do NOT flag as misplaced
  → sandbox_api.actions.destroy.catch_all: false is CORRECT for binders

All others: ocp-infra-checker
```
