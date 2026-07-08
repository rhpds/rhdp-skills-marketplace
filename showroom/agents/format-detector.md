---
name: showroom:format-detector
description: Detects whether a Showroom repo is a classic (AsciiDoc/nookbag) or zero-touch (Project Zero) lab by inspecting repo structure. Used ONLY for standalone invocations — when called via ph_payload, format is derived from manifest.project.showroom_type instead.
model: claude-haiku-4-5-20251001
---

# Format Detector

> **Note:** This agent is only spawned when `showroom:lab-review-helper` is called standalone (no `ph_payload`).
> When called via Publishing House, the format comes from `manifest.project.showroom_type` — this agent is not used.

## Input

```
REPO_PATH: <absolute path to showroom repo root>
```

## Task

Inspect the repo at REPO_PATH and determine whether it is a classic or zero-touch lab.

## Detection Logic

Check in this order:

**Step 1:** Does `setup-automation/` directory exist at `REPO_PATH/setup-automation/`?
- Yes → `project_zero` (setup-automation is the strongest ZT indicator — not present in any classic lab)

**Step 2:** Does `runtime-automation/main.yml` exist at `REPO_PATH/runtime-automation/main.yml`?
- Yes → `project_zero` (root-level main.yml orchestrator is ZT-specific; classic labs don't have this)

**Step 3:** Does `runtime-automation/` directory exist but without `main.yml`?
- If the directory exists but no `main.yml` → still `project_zero` (partial ZT setup)

**Step 4:** None of the above found → `classic`

## Real ZT Lab Structure (reference: rhpds/zt-ans-bu-hashi-aap)

A zero-touch lab has these additional directories not present in classic labs:
```
setup-automation/          ← environment setup scripts (Terraform, vault, control plane)
  main.yml
  setup-control.sh
  setup-terraform.sh
  setup-vault.sh
runtime-automation/        ← per-module solve/validation automation
  main.yml                 ← root orchestrator (includes module tasks)
  ansible.cfg
  inventory
  secrets.yaml
  module-01/
    solve.yml
    validation.yml         ← NOTE: validation.yml, not validate.yml
    solve-control.sh
    validation-control.sh
config/                    ← infrastructure config (instances, networks, firewall)
  instances.yaml
  networks.yaml
  firewall.yaml
```

Classic labs (site.yml, ui-config.yml, antora.yml, content/) are present in BOTH formats — they are not discriminating.

## Return Value

Return JSON only. No prose. No explanation.

```json
{"format": "classic"}
```

or

```json
{"format": "project_zero"}
```
