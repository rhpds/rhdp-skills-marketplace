---
description: "AgnosticV catalog validator - validates RHDP catalog YAML configurations and best practices"
alwaysApply: false
---

# AgnosticV Catalog Validator Skill

## Trigger Commands

When user says ANY of these phrases, invoke this skill:
- "validate agv"
- "validate catalog"
- "check agv catalog"
- "verify catalog"
- "agv validator"
- "validate agnosticv"

## Skill Execution

**Action**: Read and follow `~/.cursor/skills/agv-validator/SKILL.md` completely.

**OR if skills are in Claude directory**: Read and follow `~/.claude/skills/agv-validator/SKILL.md` completely.

## What This Skill Does

Validates RHDP AgnosticV catalog items for:
- YAML syntax correctness
- UUID format and uniqueness (RFC 4122)
- Category exactness (Workshops, Demos, Sandboxes only)
- Workload dependencies and compatibility
- Infrastructure configuration best practices
- Required fields completeness

## Documentation

Refer to: `~/.cursor/docs/AGV-COMMON-RULES.md` or `~/.claude/docs/AGV-COMMON-RULES.md` for AgnosticV standards.
