---
description: "AgnosticV catalog generator - creates RHDP catalog items with YAML configuration"
alwaysApply: false
---

# AgnosticV Catalog Generator Skill

## Trigger Commands

When user says ANY of these phrases, invoke this skill:
- "create agv catalog"
- "generate agnosticv"
- "create catalog item"
- "generate catalog"
- "create rhdp catalog"
- "new agv catalog"
- "agv generator"

## Skill Execution

**Action**: Read and follow `~/.cursor/skills/agv-generator/SKILL.md` completely.

**OR if skills are in Claude directory**: Read and follow `~/.claude/skills/agv-generator/SKILL.md` completely.

## What This Skill Does

Creates RHDP AgnosticV catalog items with:
- Interactive guided workflow
- common.yaml configuration
- dev.yaml configuration
- description.adoc file
- UUID generation and validation
- Category validation (Workshops, Demos, Sandboxes)
- Workload and infrastructure recommendations

## Documentation

Refer to: `~/.cursor/docs/AGV-COMMON-RULES.md` for AgnosticV standards.
