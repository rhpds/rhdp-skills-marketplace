---
layout: default
title: Migration Guide
---

# Migration Guide: File-Based to Plugin-Based Installation

This guide helps you migrate from the old file-based installation (copying files to `~/.claude/skills/`) to the new plugin-based marketplace system.

---

## Why Migrate?

**Old way (file-based):**
```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | bash
```
- Manual updates required
- No version management
- Hard to share with team
- Skills in `~/.claude/skills/`

**New way (plugin-based):**
```bash
/plugin marketplace add rhpds/rhdp-skills-marketplace
/plugin install showroom@rhdp-marketplace
```
- Automatic updates with `/plugin marketplace update`
- Version management and rollback
- Easy team distribution
- Standard package management (like dnf/brew)

---

## Migration Steps

### Step 1: Backup Your Old Installation

If you have customized any skills, back them up first:

```bash
cp -r ~/.claude/skills ~/.claude/skills-backup
cp -r ~/.claude/docs ~/.claude/docs-backup
```

### Step 2: Remove Old File-Based Installation

Clean up the old installation:

```bash
rm -rf ~/.claude/skills/create-lab
rm -rf ~/.claude/skills/create-demo
rm -rf ~/.claude/skills/blog-generate
rm -rf ~/.claude/skills/verify-content
rm -rf ~/.claude/skills/agnosticv-catalog-builder
rm -rf ~/.claude/skills/agnosticv-validator
rm -rf ~/.claude/skills/deployment-health-checker
rm -rf ~/.claude/docs
```

### Step 3: Install Plugin-Based Marketplace

Add the marketplace:

```bash
# If you have SSH keys configured
/plugin marketplace add rhpds/rhdp-skills-marketplace

# If you don't have SSH configured
/plugin marketplace add https://github.com/rhpds/rhdp-skills-marketplace
```

### Step 4: Install Plugins

Install the plugins you need:

```bash
# For workshop/demo creation (most users)
/plugin install showroom@rhdp-marketplace

# For AgnosticV catalogs (RHDP internal)
/plugin install agnosticv@rhdp-marketplace

# For deployment health checks (RHDP internal)
/plugin install health@rhdp-marketplace
```

### Step 5: Restart Claude Code

Exit Claude Code completely and restart it to load the new plugins.

### Step 6: Verify Installation

Check that skills are available:

```bash
/skills
```

You should see:
- `/showroom:create-lab`
- `/showroom:create-demo`
- `/showroom:blog-generate`
- `/showroom:verify-content`
- `/agnosticv:catalog-builder`
- `/agnosticv:validator`
- `/health:deployment-validator`

---

## What Changed?

### Skill Names

Skills now include namespace prefixes to show which plugin provides them:

| Old Name                  | New Name                      |
|---------------------------|-------------------------------|
| `/create-lab`             | `/showroom:create-lab`        |
| `/create-demo`            | `/showroom:create-demo`       |
| `/blog-generate`          | `/showroom:blog-generate`     |
| `/verify-content`         | `/showroom:verify-content`    |
| `/agnosticv-catalog-builder` | `/agnosticv:catalog-builder` |
| `/agnosticv-validator`    | `/agnosticv:validator`        |
| `/deployment-health-checker` | `/health:deployment-validator` |

### Directory Structure

| Old Location                          | New Location                                |
|---------------------------------------|---------------------------------------------|
| `~/.claude/skills/create-lab/`        | Managed by plugin system (auto-updated)     |
| `~/.claude/docs/`                     | Managed by plugin system (auto-updated)     |

---

## Updating Plugins

### Check for Updates

```bash
/plugin marketplace update
```

### Update Specific Plugin

```bash
/plugin update showroom@rhdp-marketplace
```

### Update All Plugins

```bash
/plugin update showroom@rhdp-marketplace
/plugin update agnosticv@rhdp-marketplace
/plugin update health@rhdp-marketplace
```

After updating, **restart Claude Code** to load the new versions.

---

## Troubleshooting

See the [Troubleshooting Guide](../reference/troubleshooting.html#migration-issues) for common migration issues.

---

## Rollback (If Needed)

If you need to rollback to the old file-based installation:

```bash
# Restore from backup
cp -r ~/.claude/skills-backup ~/.claude/skills
cp -r ~/.claude/docs-backup ~/.claude/docs

# Remove plugins
/plugin uninstall showroom@rhdp-marketplace
/plugin uninstall agnosticv@rhdp-marketplace
/plugin uninstall health@rhdp-marketplace
/plugin marketplace remove rhdp-marketplace
```

---

## Next Steps

- [Setup Guide](index.html) - Team configuration and advanced setup
- [Troubleshooting](../reference/troubleshooting.html) - Common issues and solutions
- [Quick Reference](../reference/quick-reference.html) - Common workflows
