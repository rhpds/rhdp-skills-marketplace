---
layout: default
title: Changelog
nav_order: 10
parent: Reference
---

# Changelog

All notable changes to the RHDP Skills Marketplace.

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
