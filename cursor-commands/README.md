# Cursor Commands for RHDP Skills

Alternative installation method for **Cursor IDE stable version** users who cannot access Agent Skills (Enterprise users or those not on Nightly channel).

---

## What are Cursor Commands?

Cursor Commands are reusable AI prompts stored as Markdown files in `.cursor/commands/`. When you type `/command-name` in Cursor's AI chat, it inserts the prompt automatically.

**Differences from Skills:**
- ✅ Work in Cursor stable version (no Nightly needed)
- ✅ Simpler and lighter weight
- ❌ Less automated (you guide the conversation)
- ❌ Don't auto-load based on context

---

## Installation

### Option 1: Manual Installation (Recommended)

Copy commands to your Cursor global commands directory:

```bash
# For Cursor
mkdir -p ~/.cursor/commands
cp ~/work/code/rhdp-skills-marketplace/cursor-commands/*.md ~/.cursor/commands/

# Also copy docs for reference
mkdir -p ~/.cursor/docs
cp ~/work/code/rhdp-skills-marketplace/showroom/docs/SKILL-COMMON-RULES.md ~/.cursor/docs/
cp ~/work/code/rhdp-skills-marketplace/agnosticv/docs/AGV-COMMON-RULES.md ~/.cursor/docs/
```

### Option 2: Project-Level Installation

For project-specific commands:

```bash
# In your workshop/project directory
mkdir -p .cursor/commands
cp ~/work/code/rhdp-skills-marketplace/cursor-commands/*.md .cursor/commands/
```

---

## Available Commands

### Showroom (Content Creation)

- **`/create-lab`** - Generate workshop lab modules
- **`/create-demo`** - Generate presenter-led demos
- **`/verify-content`** - Quality validation
- **`/blog-generate`** - Transform to blog posts

### AgnosticV (RHDP Provisioning)

- **`/agnosticv-catalog-builder`** - Create/update catalog items (unified skill with 3 modes)

---

## Usage

1. **Restart Cursor** after installing commands

2. **Open Cursor AI chat** (Cmd+L or Ctrl+L)

3. **Type `/` to see available commands**

4. **Select a command** (e.g., `/create-lab`)

5. **The command prompt is inserted** - press Enter to start

6. **Follow the AI's questions** to complete the task

---

## Example Workflow

```
You: /create-lab

AI: I'll help you create a Red Hat Showroom workshop lab module.

What is the lab about? (topic, technologies)

You: I want to create a lab about CI/CD with OpenShift Pipelines

AI: Great! Do you have reference materials? (URLs, docs, files)

You: Yes, here's the documentation: https://docs.openshift.com/pipelines/...

[AI continues to guide you through creating the lab]
```

---

## Verification

Check if commands are installed:

```bash
# For Cursor
ls -la ~/.cursor/commands/

# Should show:
# create-lab.md
# create-demo.md
# verify-content.md
# blog-generate.md
# agnosticv-catalog-builder.md
```

Test in Cursor:
1. Open Cursor
2. Press Cmd+L (AI chat)
3. Type `/`
4. You should see: create-lab, create-demo, etc.

---

## Updating Commands

To update to latest version:

```bash
cd ~/work/code/rhdp-skills-marketplace
git pull origin main

# Reinstall
cp cursor-commands/*.md ~/.cursor/commands/
```

---

## Comparison: Skills vs Commands

| Feature | Agent Skills (Nightly) | Cursor Commands (Stable) |
|---------|----------------------|-------------------------|
| **Availability** | Nightly channel only | Stable version ✅ |
| **Installation** | `~/.cursor/skills/` | `~/.cursor/commands/` |
| **Invocation** | `/skill-name` | `/command-name` |
| **Auto-loading** | Yes (context-aware) | No (manual trigger) |
| **Complexity** | Full SKILL.md with hooks | Simple Markdown prompts |
| **Enterprise Support** | No ❌ | Yes ✅ |

---

## Troubleshooting

### Commands not showing up

1. **Restart Cursor** (required after installation)
2. **Check file location**: `ls ~/.cursor/commands/`
3. **Verify file extension**: Must be `.md` files
4. **Check permissions**: `chmod 644 ~/.cursor/commands/*.md`

### Commands appear but don't work well

Commands are simpler than full Skills - they work best when:
- You provide clear context in the conversation
- You reference the docs files manually when needed
- You guide the AI through the workflow

---

## For Claude Code Users

If you're using Claude Code (not Cursor), use the full Skills installation instead:

```bash
cd ~/work/code/rhdp-skills-marketplace
bash install.sh --platform claude --namespace all
```

Skills in Claude Code are more powerful and fully automated.

---

## Support

- **Repository:** https://github.com/rhpds/rhdp-skills-marketplace
- **Issues:** https://github.com/rhpds/rhdp-skills-marketplace/issues
- **Slack:** [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX) or [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX)

---

**Version:** v1.0.0
**Last Updated:** 2026-01-22
**For:** Cursor IDE stable version (Enterprise compatible)
