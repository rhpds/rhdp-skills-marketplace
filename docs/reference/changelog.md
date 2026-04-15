---
layout: default
title: Changelog
nav_order: 10
parent: Reference
---

# Changelog

All notable changes to the RHDP Skills Marketplace.

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
