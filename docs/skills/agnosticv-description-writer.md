---
layout: default
title: /agnosticv:description-writer
---

# agnosticv:description-writer

<div class="reference-badge">⚙️ Agent</div>

File generation subagent that writes `description.adoc` and optionally `info-message-template.adoc` from a fully-resolved `shared_context` JSON. Spawned by the `agnosticv:catalog-builder` orchestrator — never runs interactively or asks questions.

**Called by:** `/agnosticv:catalog-builder` (MODE 1 orchestrator, Step O-4; also invoked for MODE 2 and MODE 3 standalone runs)
**Model:** claude-sonnet-4-6
**Tools:** Bash (git clone), Write

---

## When It Is Spawned

| Trigger | What happens |
|---|---|
| **MODE 1 — Full Catalog** | Spawned in parallel with `agnosticv:config-writer` at Step O-4. Receives the complete `shared_context` JSON resolved from the batched planning form. Generates both `description.adoc` and, if `user_data_keys` is present, `info-message-template.adoc`. |
| **MODE 2 — Description Only** | Catalog-builder routes directly to this agent. Receives `shared_context` built from the Showroom URL and catalog metadata. Generates `description.adoc` only. |
| **MODE 3 — Info Template** | Catalog-builder routes directly to this agent. Receives `shared_context` with `user_data_keys` filled in. Generates `info-message-template.adoc` only. |

---

## What It Generates

### description.adoc

The catalog description displayed in the RHDP UI. Structure follows Nate's RHDP format exactly:

1. `= {catalog.display_name}` — document title
2. Brief description (1-2 sentences, starts with product name — never "This workshop...")
3. `== Overview` — 2-4 sentences on what the lab covers
4. One `==` section per module or feature (extracted from Showroom content, or synthesized from metadata)
5. `== Environment` — infrastructure details, versions, access mode

**Content source — two paths:**

- **Showroom URL present:** Clones the repo with `git clone --depth=1`, reads all `.adoc` files in `content/modules/ROOT/pages/` (excluding `nav.adoc`, `index.adoc`, and `_partials`), extracts level-1 headings and opening paragraphs. Modules are listed in alphabetical sort order (which reflects the intended sequence for numbered prefixes like `01-intro.adoc`).
- **No Showroom URL (or clone fails):** Generates description from `catalog.display_name`, `catalog.description`, `catalog.technologies`, `catalog.category`, and `catalog.catalog_type`. Falls back silently and adds a warning to the output JSON.

**Writing style rules enforced:**

| Correct | Wrong |
|---------|-------|
| Starts with product name: "Red Hat OpenShift AI provides..." | "This lab teaches you..." |
| Present tense: "Students provision..." | "Students will provision..." |
| Concrete details: "OpenShift 4.18 cluster with 3 worker nodes" | "an OpenShift cluster" |
| Technologies named: "Tekton, Argo CD, and Quay" | "various CI/CD tools" |
| No marketing language | "explore powerful AI capabilities" |

### info-message-template.adoc

The user notification displayed after provisioning completes. Only generated when `shared_context.user_data_keys` is present and non-empty.

Displays a connection details table with one row per key from `agnosticd_user_info.data`. Uses `{user_data['key']}` double-brace substitution syntax — the RHDP portal replaces these at display time with actual provisioned values.

**Human-readable label mapping (built-in):**

| user_data_key | Label |
|---|---|
| `litellm_api_base_url` | LiteLLM API Base URL |
| `litellm_virtual_key` | LiteLLM Virtual Key |
| `grafana_admin_password` | Grafana Admin Password |
| `bastion_public_hostname` | Bastion Hostname |
| `ocp_api_url` | OpenShift API URL |
| `ocp_console_url` | OpenShift Console URL |
| Any other key | `snake_case` converted to Title Case |

---

## Input

Receives the fully-resolved `shared_context` JSON from the catalog-builder orchestrator. All fields are already resolved — the agent never asks questions.

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
    "catalog_type": "workshop_multiuser | workshop_singleuser | demo | sandbox",
    "category": "Labs | Demos | Brand_Events | Open_Environments | Sandboxes",
    "multiuser": true,
    "event": "none | summit-2026 | rh1-2026",
    "lab_id": "",
    "technologies": ["openshift", "ai"],
    "keywords": ["mcp", "trustyai"]
  },

  "options": {
    "showroom_url": "https://github.com/rhpds/my-workshop-showroom",
    "e2e_testing": false
  },

  "user_data_keys": ["litellm_api_base_url", "litellm_virtual_key"]
}
```

`user_data_keys` is optional. If absent or empty, `info-message-template.adoc` is not generated.

---

## Output

Returns structured JSON only. No prose.

```json
{
  "agent": "description-writer",
  "files_written": ["description.adoc", "info-message-template.adoc"],
  "catalog_path": "/abs/path/to/agnosticv/agd_v2/my-workshop",
  "errors": [],
  "warnings": []
}
```

**Error conditions** (agent stops, no files written):
- `catalog.display_name` is empty
- `catalog_path` directory does not exist

**Warning conditions** (files written, warning reported):
- Showroom repo clone failed — fell back to metadata-based description
- Fewer than 2 modules found in Showroom repo
- Format reference files not accessible at `agv_path` — used marketplace copies

---

## Format References

The agent reads these files before generating content (from the AgV repo or marketplace fallback):

- `{agv_path}/.claude/skills/catalog-builder/references/mode-2-description.md` — AsciiDoc structure, RHDP conventions, real examples
- `{agv_path}/.claude/skills/catalog-builder/references/mode-3-info-message.md` — info-message format, variable substitution syntax

---

## Related

- [`/agnosticv:catalog-builder`](agnosticv-catalog-builder.html) — orchestrator that spawns this agent
- [`/agnosticv:validator`](agnosticv-validator.html) — validates `description.adoc` as part of Check 16

---

<div class="navigation-footer">
  <a href="index.html" class="nav-button">← Back to Skills</a>
  <a href="agnosticv-catalog-builder.html" class="nav-button">Next: /agnosticv:catalog-builder →</a>
</div>
