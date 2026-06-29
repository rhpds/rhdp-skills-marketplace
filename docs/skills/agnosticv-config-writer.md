---
layout: default
title: agnosticv:config-writer
---

# agnosticv:config-writer

<div class="reference-badge">✓ AgnosticV Subagent</div>

Catalog-builder file generation subagent. Generates `common.yaml` and `dev.yaml` from a fully-resolved `shared_context` after the catalog-builder orchestrator has gathered all user inputs. Enforces file structure order, password security rules, and infra-specific conventions before writing any file to disk.

**This agent is not invoked directly by users.** It is spawned by the `agnosticv:catalog-builder` orchestrator — not by `agnosticv:validator`. It produces files; it does not validate them.

---

## Agent Properties

| Property | Value |
|---|---|
| **Model** | claude-sonnet-4-6 |
| **Tools** | Read, Glob, Grep, Bash, Write |
| **Called by** | agnosticv:catalog-builder |
| **Returns** | Structured JSON (never prose) |

---

## Input

Receives a fully-resolved `shared_context` JSON from the catalog-builder orchestrator. All fields are pre-answered — this agent never asks questions and never re-derives values.

Key fields consumed:

| Field | Purpose |
|---|---|
| `catalog_path` | Absolute path where files will be written |
| `agv_path` | AgnosticV repo root (for reference catalog lookups) |
| `infra_type` | Determines `config:` field value and infra-specific rule set |
| `ci_type` | Determines Sandbox API blocks, deployer action gates |
| `catalog.*` | Display name, category, keywords, labels, multiuser settings |
| `infra.*` | Cloud provider, OCP version, num_users, bastion config, terminal type |
| `workloads` | Ordered workload list (fully qualified `namespace.collection.role` format) |
| `collections` | requirements_content entries with name, type, version |
| `options.*` | Showroom URL, e2e testing, LiteMaaS, ocp_console_embed, dev_mode |
| `meta.*` | asset_uuid, deployer scm_ref and EE image, action disable flags |
| `passwords` | Map of variable name → unique output_dir lookup path |
| `includes` | Ordered `#include` lines for top of common.yaml |

---

## What It Generates

### common.yaml

Generated in this exact section order (mandatory):

<ol class="steps">
<li>
<div class="step-content">
<h4>#include lines</h4>
<p>Written exactly as provided in <code>shared_context.includes</code> — no additions, removals, or reordering. The orchestrator has pre-validated this list for duplicates.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>config / cloud_provider / tag</h4>
<p>Maps <code>infra_type</code> to the correct <code>config:</code> value. <code>cloud_provider</code> and <code>tag</code> are set per infra-specific rules (see below). Omitted for <code>sandbox_tenant</code>.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>requirements_content (collections)</h4>
<p>Written within the first 200 lines. This placement is enforced — validator Check 22 blocks catalogs that bury collections deep in the file.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>workloads and remove_workloads</h4>
<p>Immediately after collections. <code>remove_workloads</code> is included only when the list is non-empty.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>Password variables</h4>
<p>Each entry in <code>shared_context.passwords</code> generates a <code>lookup('password')</code> variable using the unique output_dir path provided. Hardcoded strings, hash filters, and duplicate paths are all hard errors.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>Infra and workload variables</h4>
<p>Bastion config (when cloud_provider is not <code>none</code>), terminal type variables, Showroom content URL, E2E testing block, and LiteMaaS block. Variable names are verified against <code>defaults/main.yml</code> when locally available.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>__meta__ block</h4>
<p>Contains asset_uuid, owners, deployer (scm_url, scm_ref, EE image), sandbox_api (tenant CI only), and catalog (reportingLabels, display_name, category, keywords, labels, multiuser settings). The <code>anarchy.namespace</code> field is never written.</p>
</div>
</li>
</ol>

### dev.yaml

Intentionally minimal — overrides only what is needed for development:

```yaml
---
# -------------------------------------------------------------------
# Purpose - Cost tag. One of development, ilt, production, event
# -------------------------------------------------------------------
purpose: development
__meta__:
  deployer:
    scm_ref: main
    scm_type: git
```

No workload variables, no passwords, no include lines in dev.yaml.

---

## Infra-Specific Rules

| `infra_type` | `config:` value | `cloud_provider` | `num_users` | Special rules |
|---|---|---|---|---|
| `openshift_ocp` | `openshift-workloads` | from shared_context | included | Standard OCP workloads layout |
| `cloud_vms` | `cloud-vms-base` | from shared_context | included | VM-specific variable names (e.g., `showroom_git_repo`) |
| `sandbox_tenant` | `namespace` | omitted | omitted | Adds `sandbox_api.catch_all: false`; deployer status+update disabled; never sets `ocp4_workload_showroom_namespace` |
| `sandbox_cluster` | `openshift-workloads` | `none` | `0` | Deployer status+update disabled |

---

## Password Security Rules

All are hard errors that block file writing:

- Always use `lookup('password')` with the unique `output_dir` path from `shared_context.passwords`
- Never use `hash()`, `sha`, `md5`, `guid`, or `b64encode`
- Never use plain static strings
- Never use the same `output_dir` path for two different variables

Correct pattern:
```yaml
common_password: >-
  {{ lookup('password', output_dir ~ '/common_password', length=12, chars=['ascii_letters', 'digits']) }}
```

---

## Output Contract

Returns exactly this JSON structure. No prose, no markdown outside the JSON.

```json
{
  "agent": "config-writer",
  "files_written": ["common.yaml", "dev.yaml"],
  "asset_uuid": "5ac92190-6f0d-4c0e-a9bd-3b20dd3c816f",
  "catalog_path": "/abs/path/to/agnosticv/agd_v2/my-workshop",
  "errors": [],
  "warnings": [
    "Could not verify variable names for ocp4_workload_authentication — defaults/main.yml not found locally. Used bundled example values."
  ]
}
```

### Error Conditions (blocks file writing)

| Condition | Result |
|---|---|
| `catalog_path` directory already exists | ERROR — collision, orchestrator should have caught this |
| `meta.asset_uuid` is missing or empty | ERROR |
| `includes` list is empty | ERROR |
| Workload variable name unverifiable and no example catalog available | ERROR |

### Warning Conditions (writes files but reports issue)

| Condition | Result |
|---|---|
| `defaults/main.yml` not found for a workload (collection not cloned locally) | WARNING — uses bundled example values |
| `options.e2e_testing == true` and `e2e_runner_image` is empty | WARNING — uses default `quay.io/rhpds/zt-runner:v2.4.2` |

---

## Related

- [`/agnosticv:catalog-builder`](agnosticv-catalog-builder.html) — orchestrator that spawns this agent
- [`/agnosticv:validator`](agnosticv-validator.html) — validates the files this agent produces
- [`agnosticv:sandbox-checker`](agnosticv-sandbox-checker.html) — validates sandbox-specific config in generated files
- [`agnosticv:metadata-checker`](agnosticv-metadata-checker.html) — validates metadata and credentials in generated files

---

<div class="navigation-footer">
  <a href="agnosticv-metadata-checker.html" class="nav-button">← agnosticv:metadata-checker</a>
  <a href="agnosticv-catalog-builder.html" class="nav-button">Next: /agnosticv:catalog-builder →</a>
</div>
