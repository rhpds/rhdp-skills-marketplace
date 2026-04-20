---
layout: default
title: Changelog
nav_order: 10
parent: Reference
---

# Changelog

All notable changes to the RHDP Skills Marketplace.

---

## v2.13.4 — 2026-04-20

### Fixed

- **agnosticv + showroom plugins**: versions were stuck at 2.12.4 while health and ftl had moved to 2.13.3 — all four plugins now consistently report v2.13.4
- **FTL sub-tool skills removed**: content-reader, solve-writer, validate-writer, env-connector were exposed as both slash commands and agents — they are now agents only. Only `/ftl:rhdp-lab-validator` is the user entry point
- **env-connector**: `oc cp` was pushing `validation.yml` but validate-writer produces `validate.yml` — would have caused runner pod to never receive the validate playbook
- **rhdp-lab-validator**: `name: ftl:lab-validator` corrected to `name: ftl:rhdp-lab-validator` to match directory and invocation path

---

## v2.13.3 — 2026-04-16

### FTL Skills — Sub-agents now callable via Task tool

Added `ftl/agents/` directory with 4 proper agent definitions. Previously the 4 sub-skills (content-reader, solve-writer, validate-writer, env-connector) were only registered as skills, causing the orchestrator to fail when spawning them via the Task tool.

- **`ftl/agents/content-reader.md`** — AsciiDoc parser agent, `subagent_type: ftl:content-reader`
- **`ftl/agents/solve-writer.md`** — solve.yml generator agent, `subagent_type: ftl:solve-writer`
- **`ftl/agents/validate-writer.md`** — validate.yml generator agent, `subagent_type: ftl:validate-writer`
- **`ftl/agents/env-connector.md`** — live test runner agent, `subagent_type: ftl:env-connector`
- **Orchestrator updated** — `rhdp-lab-validator/SKILL.md` now explicitly uses Task tool with correct `subagent_type` for each step

---

## v2.13.2 — 2026-04-16

### FTL Skills — Orchestrator Quality Fixes (8 issues)

Automated skill-reviewer audit found and fixed 8 issues in the FTL orchestrator and sub-agent skills:

- **Archived shadow `agents/` directory** — old contradictory versions of all 4 sub-agents
- **"Existing files?" gate** added to orchestrator Step 0 — uses existing solve/validate as baseline
- **`rhpds.ftl.validation_check` FQCN** enforced — bare `validation_check` fails without collection routing
- **Self-healing wired into orchestrator** — Playwright failures route to vision recovery, not solve-writer
- **SOLVE_ACTIONS structured format** — `task-N: {action, check, async}` for direct validate-writer use
- **Numbering and labeling fixes** in env-connector (Step 8) and content-reader (Section C)
- **Merged split frontmatter** in all 4 sub-agent SKILL.md files

---

## v2.13.1 — 2026-04-16

### FTL Skills — Self-Healing Vision Pattern

When UI versions change, Playwright selectors break. Solution: intent-based automation + live vision recovery.

- **`ftl:content-reader`** — Vision analysis of `image::` screenshots from `.adoc` assets. Stores intent descriptions, not CSS selectors.
- **`ftl:solve-writer`** — Playwright scripts use `INTENT` constants. Saves before/after/debug screenshots.
- **`ftl:env-connector`** — Screenshot evidence collection. Self-healing: failure → vision → new selector → retry. `ui-versions.json` per test run.

---

## v2.13.0 — 2026-04-16

### FTL Skills — 4 Agent SKILL.md Files

Added separate, standalone SKILL.md files for each of the 4 agents orchestrated by `ftl:rhdp-lab-validator`:

- **`ftl:content-reader`** — AsciiDoc reader. Extracts `role="execute"` blocks, vision analysis, GUI step decision tree.
- **`ftl:solve-writer`** — Writes solve.yml with all automation patterns.
- **`ftl:validate-writer`** — Writes validate.yml using `rhpds.ftl.validation_check`.
- **`ftl:env-connector`** — Live test runner: push → restart → test cycle → report.

---

## v2.12.4 — 2026-04-15

### FTL Skills

#### `ftl:lab-validator` — full rewrite

Rewritten from scratch. No longer scaffolds AgV or Showroom — focuses on writing and testing `solve.yml` / `validate.yml` playbooks. Pre-flight message updated with all required files and AgV config. Key field learnings from LB2860/LB2010/LB2865 incorporated: k8s_exec string rule, kubeconfig requirement, namespace probing, idempotency, async patterns, dev.yaml warning, specific error messages.

---

## v2.12.3 — 2026-04-15

### AgnosticV Skills

#### `agnosticv:catalog-builder` + `agnosticv:validator` — dev_mode common.yaml check removed

`ocp4_workload_showroom_antora_enable_dev_mode: "false"` is no longer generated in `common.yaml` and no longer checked by the validator. The only enforcement is that dev.yaml has it set to `"true"`. cloud-vms-base is unaffected — `vm_workload_showroom` has no dev_mode toggle.

---

## v2.12.2 — 2026-04-15

### AgnosticV Skills

#### `agnosticv:validator` — Check 25b VM E2E severity to WARNING

`showroom_ansible_runner_image` / `_tag` both missing on cloud-vms-base CIs was a SUGGESTION. Now WARNING, consistent with the OCP/tenant Check 25a change in v2.12.1.

---

## v2.12.1 — 2026-04-15

### AgnosticV Skills

#### `agnosticv:validator` — Check 27: showroom in cluster CI (new)

`ocp4_workload_showroom` and `vm_workload_showroom` must not appear in any CI with "cluster" in the display name, or that has `__meta__.components`. These are per-user workloads — cluster CIs provision shared infrastructure only. → ERROR

#### `agnosticv:validator` — Check 26: litellm placement extended

Previously only detected cluster CIs via `__meta__.components`. Now also checks display name for "cluster" — consistent with the pattern used in Check 25 and Check 27.

#### `agnosticv:validator` — Check 25: E2E severity to WARNING

"E2E not configured" demoted from SUGGESTION → WARNING. Partial E2E config (enabled but image or FTL workload missing) demoted from ERROR → WARNING. Cluster CIs are excluded entirely (no change).

#### `agnosticv:catalog-builder` — pool references without /prod

Generated `item:` values in `__meta__.components` no longer include the `/prod` suffix (`agd-v2/ocp-cluster-cnv-pools` not `agd-v2/ocp-cluster-cnv-pools/prod`). The ordering system selects the appropriate pool — hardcoding `/prod` bypasses dev-mode ordering.

---

## v2.12.0 — 2026-04-15

### AgnosticV Skills

#### `agnosticv:validator` — Private validator delegation (issue #12)

The public validator now has a **Step 0** that detects the `commitv` skill in the private AgV repo before running any checks. If found, it loads and uses it for internal RHDP-specific validation. If not found, it falls back to built-in checks and tells the user. Keeps sensitive internal check logic private without losing the public entry point.

#### `agnosticv:catalog-builder` — Expanded reference catalog discovery (issue #14)

Step 2 discovery now searches beyond `agd_v2/` and `openshift_cnv/`. Added: `ai-quickstarts/`, `enterprise/`, `summit-2026/`, `sandboxes-gpte/`, `zt_rhel/`, `rhdp/`. Results filtered by `config:` field to exclude agDv1 catalogs automatically.

#### `agnosticv:catalog-builder` — Tenant CI console_embed fix (issue #15)

The auto-set block in `sandbox-tenant-ci-questions.md` listed `ocp4_workload_ocp_console_embed` alongside Showroom as things that get added for Q-T4. This contradicted the correct "Do NOT add" note and caused the builder to put console_embed in tenant CIs. Removed from the auto-set comment — console_embed belongs in the Cluster CI only.

### Documentation

#### `best-practices.md` — Remove AI attribution suppression (issue #17)

Removed "No AI attribution" from 4 locations: the global CLAUDE.md example, the AgnosticV CLAUDE.md example, a prompt workflow example, and the git rules table. When writing with Claude as a co-author, attribution should be included.

---

## v2.10.10 — 2026-04-13

### AgnosticV Skills

#### `/agnosticv:validator` — Password security improvements

Addresses password issues flagged in Nate Stencell's review of Summit 2026 catalog items.

**What changed:**
- Validator now **deep-scans the full YAML tree** (dicts + lists at any depth). Previously only top-level keys were checked — nested passwords inside AAP credential inputs, workload configs, and list items were invisible.
- Added `b64encode`, `sha256`, `sha1` to bad patterns — catches the `guid|md5|int(base=16)|b64encode` chain.
- Applies to **all agnosticv directories** (`catalog/`, `summit-2026/`, `agd_v2/`, `tests/`).

**Now caught (examples):**
- `vault_password: MzIzNTE0OTEw` — hardcoded base64 AAP vault credential (nested)
- `"{{ (guid | hash('sha256'))[:8] }}"` — GUID hash-based password
- `"{{ (guid[:5] | hash('md5') | int(base=16) | b64encode)[:8] }}"` — md5 + b64encode chain
- `"band-on-the-run"` — literal static password
- `"redhat"` — literal cosign password

---

## v2.11.3 — 2026-04-01

### FTL Plugin

#### New skill: `/ftl:rhdp-lab-validator`

Zero Touch grading for RHDP Showroom labs. Generates grader and solver playbooks.

- Covers 4 lab types: OCP tenant, OCP dedicated+bastion, RHEL VM+bastion, AAP
- Wraps existing bash scripts — no rewrite needed
- Generates multi-task ✅/❌ validation (mandatory for all modules)
- curl test commands after each module

---

## v2.10.9 — 2026-04-08

### AgnosticV Skills

#### `/agnosticv:validator` — False positive fixes (Nate Stencell, issue #11)
- Removed `purpose:` field check — no longer required
- Removed `/prod` pool suffix check — ordering system determines pool environment

### Docs
- `docs/setup/claude-code.md`: clarified `/plugin install` scope selection
- Security guidelines merged from Guillaume Coré (PR #13)

---

## v2.10.8 — 2026-03-26

### Showroom Skills

#### `/showroom:create-lab` and `/showroom:create-demo` — scaffold fix
- Step 3.1 now lists all three scaffold questions: Q0 (catalog type), Q1 (tabs), Q2 (theme)
- Previously Q2 (ui-bundle theme) was skipped — wrong theme URL written to `site.yml`
- Showroom collection version updated to `v1.6.0` in reference files

---

[View full CHANGELOG on GitHub](https://github.com/rhpds/rhdp-skills-marketplace/blob/main/CHANGELOG.md){: .btn }
