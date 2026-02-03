---
layout: default
title: Migration Guide
---

# Migration Guide: install.sh → Plugin Marketplace

This guide helps you migrate from the old `install.sh` script to the new plugin-based marketplace system.

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

**Old file-based installation:**
```
~/.claude/
├── skills/
│   ├── create-lab/
│   │   └── SKILL.md
│   ├── create-demo/
│   │   └── SKILL.md
│   ├── agnosticv-catalog-builder/
│   │   └── SKILL.md
│   └── ...
├── docs/
│   └── (documentation files)
└── skills/.rhdp-marketplace-version
```

**New plugin-based installation:**
```
~/.claude/
└── plugins/
    ├── cache/
    │   └── rhdp-marketplace/
    │       ├── showroom/
    │       │   └── 1.0.0/
    │       │       └── skills/
    │       │           ├── create-lab/SKILL.md
    │       │           ├── create-demo/SKILL.md
    │       │           ├── blog-generate/SKILL.md
    │       │           └── verify-content/SKILL.md
    │       ├── agnosticv/
    │       │   └── 2.2.0/
    │       │       └── skills/
    │       │           ├── catalog-builder/SKILL.md
    │       │           └── validator/SKILL.md
    │       └── health/
    │           └── 1.0.0/
    │               └── skills/
    │                   └── deployment-validator/SKILL.md
    ├── marketplaces/
    │   └── rhdp-marketplace/
    │       └── (full marketplace repo)
    ├── installed_plugins.json
    └── known_marketplaces.json
```

**Key Differences:**

| Aspect | Old Location | New Location |
|--------|-------------|--------------|
| **Skills** | `~/.claude/skills/create-lab/` | `~/.claude/plugins/cache/rhdp-marketplace/showroom/1.0.0/skills/create-lab/` |
| **Documentation** | `~/.claude/docs/` | Embedded in plugin directories |
| **Version tracking** | `.rhdp-marketplace-version` | Built into plugin system with versioned directories |
| **Updates** | Manual (run update.sh) | Automatic (`/plugin update`) |
| **Management** | Manual file copies | Plugin system |

---

## Updating Plugins

### Step 1: Update Marketplace

```bash
/plugin marketplace update
```

This opens an interactive UI:
1. Select the marketplace
2. Press `u` to update it
3. Press `Esc` to go back

This refreshes the marketplace cache with the latest plugin versions.

### Step 2: Update Plugins

```bash
/plugin update showroom@rhdp-marketplace
```

This opens an interactive UI:
1. Navigate with `ctrl+p` or arrow keys
2. Select "Update now" and press `Enter`
3. Press `Esc` to go back

**Note:** Both commands are interactive - you must use the UI to perform updates.

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
