---
layout: default
title: Setup Guide
---

# Setup Guide

Complete installation guide for RHDP Skills Marketplace.

---

## Prerequisites

Before installing, ensure you have:

- **Claude Code** or **Cursor** installed
- **Git** installed on your system
- For AgnosticV skills: RHDP access and AgnosticV repository

---

## Installation

### Option 1: Interactive Installation (Recommended)

Run the installer and follow the prompts:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | bash
```

**The installer will ask:**

1. **Which platform are you using?**
   - Claude Code
   - Cursor

2. **Which namespace would you like to install?**
   - `showroom` - Content creation skills (recommended for external developers)
   - `agnosticv` - RHDP provisioning skills (internal/advanced)
   - `all` - Install both namespaces

3. **Confirm installation**
   - Backs up existing skills
   - Installs selected namespace
   - Shows available skills

### Option 2: Non-Interactive Installation

Specify options directly:

```bash
# Install showroom for Claude Code
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | \
  bash -s -- --platform claude --namespace showroom

# Install all for Cursor
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | \
  bash -s -- --platform cursor --namespace all
```

### Option 3: Dry Run (Test Installation)

See what would be installed without making changes:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | \
  bash -s -- --dry-run
```

---

## Installation Paths

Skills are installed to platform-specific directories:

### Claude Code

```
~/.claude/
├── skills/
│   ├── create-lab/
│   ├── create-demo/
│   └── ...
└── docs/
    └── SKILL-COMMON-RULES.md
```

### Cursor

```
~/.cursor/
├── skills/
│   ├── create-lab/
│   ├── create-demo/
│   └── ...
└── docs/
    └── SKILL-COMMON-RULES.md
```

---

## Verification

After installation:

1. **Restart your editor** (Claude Code or Cursor)

2. **Check installed skills:**

   ```bash
   # For Claude Code
   ls ~/.claude/skills/

   # For Cursor
   ls ~/.cursor/skills/
   ```

3. **Try a skill:**
   - Open a project in your editor
   - Type `/create-lab` or any installed skill
   - Follow the interactive prompts

---

## Namespace-Specific Setup

### Showroom Namespace

[View Showroom Setup Guide →](showroom.html)

Skills included:
- `/create-lab`
- `/create-demo`
- `/verify-content`
- `/blog-generate`

**Prerequisites:**
- Red Hat Showroom template (optional)
- Basic understanding of AsciiDoc

### AgnosticV Namespace

[View AgnosticV Setup Guide →](agnosticv.html)

Skills included:
- `/agv-generator`
- `/agv-validator`
- `/generate-agv-description`
- `/validation-role-builder`

**Prerequisites:**
- RHDP account access
- AgnosticV repository cloned to `~/work/code/agnosticv`
- GitHub CLI (`gh`) installed

---

## Backup & Restore

### Automatic Backup

The installer automatically backs up existing skills before installation:

```
~/.claude/skills-backup-<timestamp>/
# or
~/.cursor/skills-backup-<timestamp>/
```

### Manual Restore

To restore from backup:

```bash
# For Claude Code
cp -r ~/.claude/skills-backup-<timestamp>/* ~/.claude/skills/

# For Cursor
cp -r ~/.cursor/skills-backup-<timestamp>/* ~/.cursor/skills/
```

---

## Updates

Check for and install updates:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/update.sh | bash
```

The updater will:
- Detect your current installation
- Check for newer versions
- Show changelog for new version
- Prompt to update if available

---

## Uninstallation

To remove skills:

```bash
# For Claude Code
rm -rf ~/.claude/skills/{create-lab,create-demo,verify-content,blog-generate}
rm -rf ~/.claude/skills/{agv-generator,agv-validator,generate-agv-description,validation-role-builder}
rm ~/.claude/skills/.rhdp-marketplace-version

# For Cursor
rm -rf ~/.cursor/skills/{create-lab,create-demo,verify-content,blog-generate}
rm -rf ~/.cursor/skills/{agv-generator,agv-validator,generate-agv-description,validation-role-builder}
rm ~/.cursor/skills/.rhdp-marketplace-version
```

---

## Next Steps

- [View skill documentation](../skills/)
- [Read quick reference guide](../reference/quick-reference.html)
- [Check troubleshooting guide](../reference/troubleshooting.html)

---

[← Back to Home](../) | [Showroom Setup →](showroom.html) | [AgnosticV Setup →](agnosticv.html)
