---
layout: default
title: Cursor Setup
---

# Cursor Setup

> **✅ Cursor 2.4+ Supported (Workaround)**
>
> Cursor 2.4+ supports the [Agent Skills open standard](https://agentskills.io) but **does not support Claude Code plugin marketplace**. This installation uses a direct install script as a workaround.
>
> **Note:** For full plugin marketplace support with automatic updates, use [Claude Code](claude-code.html) instead.

---

## Prerequisites

**Cursor Version:** 2.4 or later

Check your version:
1. Open Cursor
2. Click **Cursor** menu → **About Cursor**
3. Version should be **2.4.0** or higher

If you're on an older version, update Cursor first.

---

## Installation

**One-command install:**

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install-cursor.sh | bash
```

This script will:
- ✅ Install all 7 skills to `~/.cursor/skills/`
- ✅ Install documentation to `~/.cursor/docs/`
- ✅ Bundle prompts and templates with each skill
- ✅ Everything installed in one step

**Verify installation:**

```bash
ls ~/.cursor/skills/
```

You should see:
- showroom-create-lab
- showroom-create-demo
- showroom-blog-generate
- showroom-verify-content
- agnosticv-catalog-builder
- agnosticv-validator
- health-deployment-validator

**Restart Cursor** after installation to load the new skills.

---

## Usage

### Explicit Invocation

Type `/skill-name` in Cursor Agent chat:

```
/showroom-create-lab
/showroom-create-demo
/showroom-blog-generate
/showroom-verify-content
/agnosticv-catalog-builder
/agnosticv-validator
/health-deployment-validator
```

**Note:** Cursor skill names use **hyphens** (not colons) due to naming restrictions.

### Natural Language

The agent will apply relevant skills automatically:

```
Help me create a workshop lab module
Generate demo content for my presentation
Create an AgnosticV catalog configuration
Verify my workshop content quality
```

---

## Verification

After installation and restart, verify skills are loaded:

1. Open Cursor Agent chat (Cmd+L or Ctrl+L)
2. Type `/` to see available skills
3. You should see RHDP skills listed with their namespaces

---

## ⚠️ Important: If You Use BOTH Claude Code and Cursor

If you have **both** Claude Code and Cursor installed, you may see duplicate skills:

| Platform | Skill Names | Example |
|----------|-------------|---------|
| Claude Code (plugin) | With colons | `/showroom:create-lab` |
| Cursor (npx) | With hyphens | `/showroom-create-lab` |

**Both skills are identical** - they just have different names due to platform naming requirements.

**Recommendation:** Choose one installation method:
- **Claude Code users**: Use the plugin marketplace (automatic updates, full integration)
- **Cursor-only users**: Use npx skills (this guide)
- **Both**: Use Claude Code plugin, skip npx for Cursor

---

## Updating Skills

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/update-cursor.sh | bash
```

The update script will:
- Check for new versions
- Show changelog
- Backup current installation
- Install latest version
- Restart Cursor to load updates

**Note:** Unlike Claude Code plugin marketplace, Cursor updates are manual. Claude Code users get automatic update notifications.

---

## Troubleshooting

### Skills Not Showing After Installation

**Most common issue:** Symlinks instead of actual files.

**Fix:**
```bash
# Verify you have actual files (not symlinks)
file ~/.cursor/skills/showroom-create-lab/SKILL.md

# If it says "symbolic link", copy actual files:
cp -r ~/.agents/skills/* ~/.cursor/skills/

# Restart Cursor
```

Other checks:
1. **Restart Cursor completely** (Cmd+Q / Ctrl+Q, then reopen)
2. Verify installation: `ls ~/.cursor/skills/`
3. Check Cursor version is 2.4.0+

### Skills Show But Don't Work Properly

Missing support files (templates, prompts, docs):

```bash
# Copy .claude/ directory to your project
cd ~/your-project
git clone https://github.com/rhpds/rhdp-skills-marketplace.git /tmp/rhdp-marketplace
mkdir -p .claude
cp -r /tmp/rhdp-marketplace/showroom/.claude/* .claude/
rm -rf /tmp/rhdp-marketplace
```

### Permission Denied

Make sure you have write permissions:
```bash
ls -la ~/.cursor/
chmod 755 ~/.cursor/skills
```

---

## Additional Resources

- [Vercel Skills CLI](https://github.com/vercel-labs/skills)
- [Agent Skills Standard](https://agentskills.io)
- [RHDP Skills Documentation](https://rhpds.github.io/rhdp-skills-marketplace)
