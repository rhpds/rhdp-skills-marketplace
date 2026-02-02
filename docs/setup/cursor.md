---
layout: default
title: Cursor Setup
---

# Cursor Setup

> **✅ Cursor 2.4+ Supported**
>
> Cursor 2.4+ supports the [Agent Skills open standard](https://agentskills.io). RHDP skills work natively in Cursor with auto-discovery from `~/.cursor/skills/`.

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

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh -o /tmp/rhdp-install.sh
bash /tmp/rhdp-install.sh
```

When prompted:
1. Select **2 (Cursor 2.4+)**
2. Choose your namespace:
   - **showroom** - Create demos/workshops (most users)
   - **agnosticv** - RHDP catalog work (internal)
   - **health** - Deployment validation (internal)
   - **all** - Install everything

The installer will:
- ✅ Install skills to `~/.cursor/skills/`
- ✅ Install documentation to `~/.cursor/docs/`
- ✅ Create version tracking file

**Restart Cursor** after installation to load the new skills.

---

## Verify Installation

### Option 1: View in Settings

1. Open Cursor Settings: `Cmd+Shift+J` (Mac) or `Ctrl+Shift+J` (Windows/Linux)
2. Navigate to **Rules**
3. Look in the **"Agent Decides"** section
4. You should see your installed skills listed

### Option 2: Use in Chat

1. Open Agent chat
2. Type `/` to see available skills
3. Search for installed skills:
   - `/showroom:create-lab`
   - `/showroom:create-demo`
   - `/showroom:verify-content`
   - etc.

---

## Usage

### Method 1: Explicit Invocation

Type `/` in Agent chat and select a skill:

```
/showroom:create-lab
/showroom:create-demo
/showroom:verify-content
/agnosticv:catalog-builder
```

### Method 2: Natural Language

The agent will automatically apply relevant skills based on context:

**Showroom:**
- "Help me create a workshop lab module"
- "Generate demo content for AAP"
- "Verify this content for quality"

**AgnosticV:**
- "Create an AgnosticV catalog item"
- "Validate this catalog configuration"

---

## How It Works

Cursor 2.4+ implements the **Agent Skills open standard** (agentskills.io):

1. **Auto-discovery**: Skills are automatically loaded from:
   - `~/.cursor/skills/` (user-level, global)
   - `.cursor/skills/` (project-level, optional)

2. **Agent decides**: The agent sees available skills and determines when they're relevant

3. **Progressive loading**: Skills load resources on demand to keep context efficient

---

## Updating Skills

Run the update script:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/update.sh | bash
```

Or manually download and run:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/update.sh -o /tmp/rhdp-update.sh
bash /tmp/rhdp-update.sh
```

Restart Cursor after updating.

---

## Troubleshooting

### Skills don't appear in settings

1. Check installation:
   ```bash
   ls -la ~/.cursor/skills/
   ```

2. Verify SKILL.md files exist:
   ```bash
   cat ~/.cursor/skills/create-lab/SKILL.md
   ```

3. Restart Cursor completely (Quit and reopen)

### Skills don't trigger automatically

- Use explicit invocation: Type `/skill-name`
- Check Cursor version is 2.4+
- Verify skill frontmatter has proper `name` and `description` fields

### Need fresh install

```bash
# Remove existing skills
rm -rf ~/.cursor/skills
rm -rf ~/.cursor/docs

# Reinstall
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | bash
```

---

## Platform Comparison

| Feature | Claude Code | Cursor 2.4+ |
|---------|-------------|-------------|
| Agent Skills Standard | ✅ Supported | ✅ Supported |
| Auto-discovery | ✅ `~/.claude/skills/` | ✅ `~/.cursor/skills/` |
| Skill invocation | `/skill-name` | `/skill-name` |
| Natural language | ✅ Agent decides | ✅ Agent decides |
| Installation | One command | One command |

**Both platforms fully support RHDP skills.** Choose based on your preferred IDE.

---

## Additional Resources

- **Agent Skills Standard**: [agentskills.io](https://agentskills.io)
- **Cursor Documentation**: [cursor.com/docs](https://cursor.com/docs)
- **RHDP Skills GitHub**: [github.com/rhpds/rhdp-skills-marketplace](https://github.com/rhpds/rhdp-skills-marketplace)

---

[← Back to Setup](index.html) | [Home](../index.html)
