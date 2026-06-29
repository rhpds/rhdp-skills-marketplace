---
layout: default
title: agnosticv:metadata-checker
---

# agnosticv:metadata-checker

<div class="reference-badge">✓ AgnosticV Subagent</div>

Metadata and event-catalog validation subagent. Owns catalog metadata quality, stage file hygiene, AsciiDoc template presence, credential security, event-specific naming, EE image freshness, and untagged image detection. Spawned in parallel by the `agnosticv:validator` orchestrator alongside other check agents.

**This agent is not invoked directly by users.** It is spawned automatically as part of every `agnosticv:validator` run.

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

---

## Check Ownership

| Check ID | Name | Severity Range | Gate |
|---|---|---|---|
| 9 | best_practices | WARNING / SUGGESTION | all catalogs |
| 10 | stage_files | WARNING / SUGGESTION | all catalogs |
| 16 | asciidoc | WARNING | all catalogs |
| 16a | event_catalog | ERROR / WARNING | `event_context != none` only |
| 17a | event_restriction | ERROR / WARNING | `event_context != none` only |
| 19 | password_pattern | ERROR | all catalogs |
| 20 | showroom_namespace | WARNING | `ci_type == tenant_namespace` only |
| 21 | ee_image_date | WARNING | all catalogs |
| 23 | untagged_images | ERROR | prod/event stage files only |

---

## Check Detail

<details open>
<summary><strong>Check 9: Best Practices</strong></summary>

| Condition | Severity |
|---|---|
| `display_name` length > 60 characters | WARNING |
| `keywords` list is empty | SUGGESTION |
| `keywords` count > 4 | SUGGESTION |
| Any keyword in the generic set below | SUGGESTION |
| `__meta__.owners` absent | SUGGESTION |
| VS Code workload present with `auth_type: none` or auth absent | WARNING |

**Generic keyword set (any of these triggers the suggestion):**
`workshop`, `demo`, `lab`, `sandbox`, `openshift`, `ansible`, `rhel`, `tutorial`, `training`, `course`, `test`, `example`

</details>

<details>
<summary><strong>Check 10: Stage Files</strong></summary>

Checks for `dev.yaml`, `event.yaml`, and `prod.yaml` presence and `scm_ref` hygiene. The `purpose:` field is NOT required in any stage file — this agent never warns about its absence.

| File | Condition | Severity |
|---|---|---|
| `dev.yaml` | File missing | WARNING |
| `dev.yaml` | YAML syntax error | ERROR |
| `event.yaml` | `scm_ref: main` | SUGGESTION |
| `prod.yaml` | `scm_ref: main` | SUGGESTION |

All file existence checks use `ls {catalog_path}` via Bash — no assumptions from path construction alone.

</details>

<details>
<summary><strong>Check 16: AsciiDoc Templates</strong></summary>

| File | Condition | Severity |
|---|---|---|
| `description.adoc` | Missing | WARNING |
| `info-message-template.adoc` | Present but has no `{variable}` substitutions | WARNING |

`info-message-template.adoc` is optional — substitutions are only checked if the file exists. All file existence checks use Bash `ls` before flagging anything as missing.

</details>

<details>
<summary><strong>Check 16a: Event Catalog Validation</strong></summary>

**Gate:** Only runs when `event_context != "none"`.

Covers the full set of event catalog naming and labeling requirements:

| Sub-check | What it validates |
|---|---|
| **Brand_Event label** | Must match the event (`Red_Hat_Summit_2026` for `summit-2026`, `Red_Hat_One_2026` for `rh1-2026`) |
| **Event keyword** | `event_context` value must be in `keywords` (e.g., `summit-2026`) |
| **Lab ID keyword** | `lab_id` must be in `keywords` when `lab_id` is non-empty |
| **Generic keywords** | Warning if generic terms like `workshop` or `demo` appear in an event catalog |
| **Directory naming** | `catalog_slug` must start with `lab_id` (e.g., `lb2298-my-workshop-aws`) |
| **Cloud provider suffix** | Directory must end with `-aws` (AWS pools) or `-cnv` (CNV/OpenStack pools) |
| **Showroom repo naming** | Showroom repo name must end with `-showroom` (e.g., `ocp-fish-swim-showroom`) |
| **Showroom collection version** | Version must be v1.6.8 or newer |
| **Category** | Must be `Brand_Events` |

</details>

<details>
<summary><strong>Check 17a: Event Restriction Include</strong></summary>

**Gate:** Only runs when `event_context != "none"`.

Validates that the access restriction include is present — but only in one place. Including it in both `account.yaml` and `common.yaml` causes an "included more than once" error at deploy time.

| State | Severity |
|---|---|
| Found in both `account.yaml` and `common.yaml` | ERROR — causes include loop |
| Found in `account.yaml` only | PASS |
| Found in `common.yaml` only | PASS |
| Not found in either | WARNING |

Expected include filenames:
- `summit-2026` → `access-restriction-summit-devs.yaml`
- `rh1-2026` → `access-restriction-rh1-2026-devs.yaml`

</details>

<details>
<summary><strong>Check 19: Credential Pattern</strong></summary>

Applies to any variable whose key contains `password`, `passwd`, `secret`, `token`, `access_key`, `api_key`, or `credential` — excluding benign suffixes (`_length`, `_policy`, `_type`, `_format`, `_expires`, `_name`, `_url`, `_path`, `_label`).

| Condition | Severity |
|---|---|
| Credential variable uses `hash()`, `sha`, `md5`, `guid`, `b64encode`, `sha256`, `sha1` | ERROR |
| Credential variable is a hardcoded static string | ERROR |
| Two credential variables share the same `output_dir ~` lookup path | ERROR |
| Plain-text credential in `dev.yaml` or `test.yaml` | ERROR |

Empty strings (`""` or `''`) are exempt — they indicate workload auto-generation.

**Correct pattern:**
```yaml
common_password: >-
  {{ lookup('password', output_dir ~ '/common_password', length=12, chars=['ascii_letters', 'digits']) }}
```

</details>

<details>
<summary><strong>Check 20: Showroom Namespace Override</strong></summary>

**Gate:** Only runs when `ci_type == "tenant_namespace"`.

The Showroom workload creates and manages its own namespace. Tenant catalogs must not override this.

| Condition | Severity |
|---|---|
| `ocp4_workload_showroom_namespace` set in `common.yaml` | WARNING |
| `ocp4_workload_tenant_namespace_namespaces` contains a `suffix: showroom` entry | WARNING |

</details>

<details>
<summary><strong>Check 21: Execution Environment Image Date</strong></summary>

| Condition | Severity |
|---|---|
| EE image tag matches `chained-YYYY-MM-DD` AND date is more than 90 days old | WARNING |

Recommended current image: `quay.io/agnosticd/ee-multicloud:chained-2026-02-23`

Tags that do not match the `chained-YYYY-MM-DD` pattern are skipped.

</details>

<details>
<summary><strong>Check 23: Untagged External Images</strong></summary>

**Gate:** Only runs when validating against `prod.yaml` or `event.yaml` stage files.

Unacceptable tags: `latest`, `main`, `master`, `stable`, `edge`, `nightly` (or no tag at all). Jinja2 template values (`{{ ... }}`) are skipped.

| Condition | Severity |
|---|---|
| Image variable has no `:tag` | ERROR |
| Image variable tag is in unacceptable set | ERROR |

Untagged images cause non-reproducible deployments. All images in production and event catalogs must be pinned to an explicit version.

</details>

---

## Output Contract

Returns exactly this JSON structure. No prose, no markdown outside the JSON.

```json
{
  "agent": "metadata-checker",
  "errors": [
    {
      "check": "password_pattern",
      "check_id": 19,
      "severity": "ERROR",
      "message": "common_password is a hardcoded static password — not allowed",
      "location": "common.yaml:common_password",
      "fix": "Use lookup('password', output_dir ~ '/common_password', length=12, chars=['ascii_letters', 'digits'])",
      "current": "ansible123!",
      "example": null
    }
  ],
  "warnings": [
    {
      "check": "ee_image_date",
      "check_id": 21,
      "severity": "WARNING",
      "message": "Execution environment image is 120 days old",
      "location": "common.yaml:__meta__.deployer.execution_environment.image",
      "recommendation": "Update to: quay.io/agnosticd/ee-multicloud:chained-2026-02-23"
    }
  ],
  "suggestions": [
    {
      "check": "best_practices",
      "check_id": 9,
      "message": "No keywords defined",
      "recommendation": "Add 3-4 specific technology keywords (e.g., 'mcp', 'leapp', 'tekton', 'cnpg')"
    }
  ],
  "passed_checks": [
    "✓ Display name length OK (42 chars)",
    "✓ dev.yaml present",
    "✓ description.adoc present",
    "✓ ocp4_workload_showroom_namespace not set (correct for tenant catalog)",
    "✓ EE image date is recent: 2026-02-23 (126 days old)"
  ]
}
```

---

## Related

- [`/agnosticv:validator`](agnosticv-validator.html) — orchestrator that spawns this agent
- [`agnosticv:sandbox-checker`](agnosticv-sandbox-checker.html) — parallel subagent for Sandbox API checks
- [Agent Architecture](../reference/agent-architecture.html) — how orchestration works

---

<div class="navigation-footer">
  <a href="agnosticv-sandbox-checker.html" class="nav-button">← agnosticv:sandbox-checker</a>
  <a href="agnosticv-config-writer.html" class="nav-button">Next: agnosticv:config-writer →</a>
</div>
