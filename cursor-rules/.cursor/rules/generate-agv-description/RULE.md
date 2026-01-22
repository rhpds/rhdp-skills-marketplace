---
description: "AgnosticV description generator - creates catalog descriptions from workshop lab content"
alwaysApply: false
---

# AgnosticV Description Generator Skill

## Trigger Commands

When user says ANY of these phrases, invoke this skill:
- "generate agv description"
- "create catalog description"
- "description from lab"
- "agv description"
- "catalog description from content"

## Skill Execution

**Action**: Read and follow `~/.cursor/skills/generate-agv-description/SKILL.md` completely.

**OR if skills are in Claude directory**: Read and follow `~/.claude/skills/generate-agv-description/SKILL.md` completely.

## What This Skill Does

Generates AgnosticV description.adoc files from workshop content:
- Analyzes workshop lab modules
- Extracts learning objectives
- Creates catalog-appropriate descriptions
- Formats in AsciiDoc
- Maintains Red Hat standards

## Documentation

Refer to: `~/.cursor/docs/AGV-COMMON-RULES.md` for AgnosticV standards.
