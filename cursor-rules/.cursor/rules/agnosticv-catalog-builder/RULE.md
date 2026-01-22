---
description: "AgnosticV catalog builder skill - creates or updates RHDP catalog items (unified skill)"
alwaysApply: false
---

# AgnosticV Catalog Builder Skill

## Trigger Commands

When user says ANY of these phrases, invoke this skill:
- "create agv catalog"
- "generate agnosticv"
- "create catalog item"
- "update catalog"
- "generate catalog"
- "generate agv description"
- "create catalog description"
- "update agv description"

## Skill Execution

**Action**: Read and follow `~/.cursor/skills/agnosticv-catalog-builder/SKILL.md` completely.

**OR if skills are in Claude directory**: Read and follow `~/.claude/skills/agnosticv-catalog-builder/SKILL.md` completely.

## What This Skill Does

Creates or updates AgnosticV catalog files with three modes:

**Mode 1: Full Catalog**
- Generates: common.yaml, dev.yaml, description.adoc, info-message-template.adoc
- Built-in git workflow (pull main, create branch)
- Auto-commits to new branch

**Mode 2: Description Only**
- Extracts from Showroom content
- Generates: description.adoc

**Mode 3: Info Template**
- Documents agnosticd_user_info usage
- Generates: info-message-template.adoc

## Features

- Interactive catalog creation workflow
- Built-in git workflow (pull main, create branch without feature/ prefix)
- Reference catalog search by name or keywords
- Workload recommendations based on technology
- UUID generation and validation
- Showroom content extraction
- Auto-commit functionality

## Documentation

Refer to: `~/.cursor/docs/AGV-COMMON-RULES.md` for AgnosticV standards.
