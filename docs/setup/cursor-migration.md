---
layout: default
title: Cursor Migration Guide
---

# Cursor Migration Guide

Migrating from old cursor-commands/cursor-rules to npx skills.

---

## What Changed?

**Old Approach (Deprecated):**
- Manual file copying to `~/.cursor/skills/`
- Separate `cursor-commands/` and `cursor-rules/` directories
- Manual updates required

**New Approach (Recommended):**
- Standard `npx skills` CLI
- One-command installation
- Automatic updates
- Industry standard approach

---

## Migration Steps

### Step 1: Remove Old Installation

```bash
# Remove old cursor-commands skills (if installed)
rm -rf ~/.cursor/skills/create-lab
rm -rf ~/.cursor/skills/create-demo
rm -rf ~/.cursor/skills/agv-generator
rm -rf ~/.cursor/skills/verify-content
rm -rf ~/.cursor/skills/blog-generate

# Remove old cursor-rules (if installed)
rm -rf ~/.cursor/rules/agnosticv-catalog-builder
rm -rf ~/.cursor/rules/agnosticv-validator
rm -rf ~/.cursor/rules/showroom-standards
rm -rf ~/.cursor/rules/deployment-health-checker

# Remove old docs (if installed)
rm -rf ~/.cursor/docs/SKILL-COMMON-RULES.md
rm -rf ~/.cursor/docs/AGV-COMMON-RULES.md
```

### Step 2: Install via npx skills

```bash
# Install all skills interactively
npx skills add rhpds/rhdp-skills-marketplace
```

Or install specific skills:

```bash
# Workshop/demo creation
npx skills add rhpds/rhdp-skills-marketplace/skills/showroom-create-lab
npx skills add rhpds/rhdp-skills-marketplace/skills/showroom-create-demo

# AgnosticV (RHDP internal)
npx skills add rhpds/rhdp-skills-marketplace/skills/agnosticv-catalog-builder
npx skills add rhpds/rhdp-skills-marketplace/skills/agnosticv-validator
```

### Step 3: Restart Cursor

Completely quit and reopen Cursor to load the new skills.

### Step 4: Verify Installation

1. Open Cursor Agent chat (Cmd+L or Ctrl+L)
2. Type `/` to see available skills
3. You should see skills with namespace prefixes:
   - `/showroom:create-lab`
   - `/showroom:create-demo`
   - `/agnosticv:catalog-builder`

---

## Skill Name Changes

| Old Name (cursor-commands) | New Name (npx skills) |
|----------------------------|------------------------|
| `/create-lab` | `/showroom:create-lab` |
| `/create-demo` | `/showroom:create-demo` |
| `/agv-generator` | `/agnosticv:catalog-builder` |
| `/verify-content` | `/showroom:verify-content` |
| `/blog-generate` | `/showroom:blog-generate` |
| `/agnosticv-validator` | `/agnosticv:validator` |
| `/deployment-health-checker` | `/health:deployment-validator` |

**Note:** Namespace prefixes (`showroom:`, `agnosticv:`, `health:`) are now required.

---

## Configuration Files

Your existing configuration files (e.g., `~/CLAUDE.md`) work without changes:

```markdown
# AgnosticV Configuration
agnosticv: ~/devel/git/agnosticv
base_path: ~/work/code
```

Skills will automatically detect these paths.

---

## Benefits of Migration

✅ **Standard Installation** - Uses npx skills (industry standard)
✅ **Easy Updates** - `npx skills update` to get latest versions
✅ **Version Management** - See installed versions with `npx skills list`
✅ **Better Discovery** - Listed on [skills.sh](https://skills.sh) directory
✅ **Cross-Platform** - Same skills work in Claude Code, Cursor, Windsurf

---

## Troubleshooting

### Skills Not Showing After Installation

1. **Restart Cursor completely** (quit and reopen, not just reload)
2. Check installation: `ls ~/.cursor/skills/`
3. Verify Cursor version is 2.4.0+

### Old Skills Still Showing

Remove old installations:
```bash
# List all skills in ~/.cursor/skills/
ls -la ~/.cursor/skills/

# Remove specific old skills
rm -rf ~/.cursor/skills/old-skill-name
```

Restart Cursor.

### Permission Denied During npx

Make sure you have write permissions:
```bash
ls -la ~/.cursor/
mkdir -p ~/.cursor/skills  # Create if doesn't exist
```

### Namespace Prefix Not Working

Old cursor-commands didn't use namespace prefixes. The new format is:
```
/showroom:create-lab   (not /create-lab)
/agnosticv:catalog-builder   (not /agv-generator)
```

---

## Rollback (If Needed)

If you need to rollback to old approach:

```bash
# Remove npx skills installation
npx skills remove rhpds/rhdp-skills-marketplace

# Reinstall old way (not recommended)
# Contact #forum-demo-developers for help
```

**Note:** Old cursor-commands/cursor-rules are deprecated and no longer maintained.

---

## Getting Help

- **Documentation:** [Cursor Setup Guide](cursor.html)
- **GitHub Issues:** [Report a problem](https://github.com/rhpds/rhdp-skills-marketplace/issues)
- **Slack:** [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX)

---

## Timeline

- **v2.3.x and earlier:** cursor-commands/cursor-rules approach
- **v2.4.0+:** npx skills approach (current)
- **Future:** Old approach will be completely removed

Migrate now to stay up-to-date!
