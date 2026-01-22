---
description: "Deployment health checker - creates Ansible roles for post-deployment health validation"
alwaysApply: false
---

# Deployment Health Checker Skill

## Trigger Commands

When user says ANY of these phrases, invoke this skill:
- "check deployment health"
- "create validation role"
- "build validation role"
- "generate health check"
- "create health check role"
- "deployment health"
- "validate deployment"

## Skill Execution

**Action**: Read and follow `~/.cursor/skills/deployment-health-checker/SKILL.md` completely.

**OR if skills are in Claude directory**: Read and follow `~/.claude/skills/deployment-health-checker/SKILL.md` completely.

## What This Skill Does

Creates Ansible validation roles for RHDP post-deployment checks:
- Package installation verification
- Service status validation
- File existence and content checks
- User and group validation
- Network connectivity tests
- Application health checks

## Use Case

Post-deployment validation of RHDP catalog items to ensure infrastructure readiness.
