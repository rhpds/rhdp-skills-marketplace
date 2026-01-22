---
layout: default
title: Claude Code Setup
---

# Claude Code Setup (Recommended)

Native Agent Skills support - the best experience.

---

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh -o /tmp/rhdp-install.sh
bash /tmp/rhdp-install.sh
```

When prompted:
1. Select **1 (Claude Code)**
2. Choose your namespace

Restart Claude Code after installation.

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
