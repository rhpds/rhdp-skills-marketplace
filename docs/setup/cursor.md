---
layout: default
title: Cursor Setup
---

# Cursor Setup

> **⚠️ Experimental Support - Still Testing**
>
> Agent Skills are not fully supported in Cursor yet and we're still testing the `.cursor/rules/` workaround. **Skills may not work reliably in Cursor.**
>
> We recommend **Claude Code** for the best experience.
>
> [Why Cursor support is experimental →](https://forum.cursor.com/t/support-for-claude-skills/148267)

---

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh -o /tmp/rhdp-install.sh
bash /tmp/rhdp-install.sh
```

When prompted:
1. Select **2 (Cursor)**
2. Choose your namespace

Restart Cursor after installation.

---

## Usage

Use trigger phrases instead of `/commands`:

**Showroom:**
- "create lab" → Generates workshop module
- "create demo" → Generates demo content
- "verify content" → Validates quality

**AgnosticV:**
- "create agv catalog" → Creates catalog item
- "validate agv" → Validates configuration

---

## Troubleshooting

**Skills don't work?**
1. Check `.cursor/rules/` exists: `ls -la .cursor/rules/`
2. Restart Cursor completely
3. Reinstall if needed

**New project?**
```bash
cp -r /previous/project/.cursor/rules .cursor/
```

---

## Better Alternative

Use **Claude Code** for native support:
- No workarounds needed
- Use `/skill-name` commands
- More stable

[Claude Code setup →](claude-code.html)

---

**Need more details?** [Full Cursor documentation on GitHub →](https://github.com/rhpds/rhdp-skills-marketplace/blob/main/cursor-rules/README.md)

[← Back to Home](../index.html)
