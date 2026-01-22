---
layout: default
title: Claude Code & VS Code Setup
---

# Claude Code & VS Code Setup (Recommended)

Native Agent Skills support - the best experience.

**Works with:**
- Claude Code CLI
- VS Code with Claude extension

---

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh -o /tmp/rhdp-install.sh
bash /tmp/rhdp-install.sh
```

When prompted:
1. Select **1 (Claude Code or VS Code with Claude extension)**
2. Choose your namespace

Restart Claude Code or VS Code after installation.

---

## Usage

Skills work natively with `/` commands:

**Showroom:**
- `/create-lab` - Generate workshop module
- `/create-demo` - Generate demo content
- `/verify-content` - Validate quality
- `/blog-generate` - Create blog post

**AgnosticV:**
- `/agv-generator` - Create catalog item
- `/agv-validator` - Validate configuration
- `/generate-agv-description` - Generate description

**Health:**
- `/validation-role-builder` - Create validation role

---

## Verify Installation

```bash
ls ~/.claude/skills/
```

You should see: create-lab, create-demo, agv-generator, etc.

---

## Updates

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/update.sh -o /tmp/rhdp-update.sh
bash /tmp/rhdp-update.sh
```

---

[← Back to Home](../index.html)
