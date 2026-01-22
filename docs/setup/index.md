---
layout: default
title: Setup Guide
---

# Setup Guide

Quick start for installing RHDP Skills Marketplace.

---

## Choose Your Platform

<div class="grid">
  <div class="card">
    <h3>🎯 Claude Code (Recommended)</h3>
    <p>Native Agent Skills support</p>
    <a href="claude-code.html">Claude Code Setup →</a>
  </div>

  <div class="card">
    <h3>💻 VS Code with Claude</h3>
    <p>Native Agent Skills support</p>
    <a href="claude-code.html">Same as Claude Code →</a>
  </div>

  <div class="card">
    <h3>🧪 Cursor (Experimental)</h3>
    <p>Still testing - may not work reliably</p>
    <a href="cursor.html">Cursor Setup →</a>
  </div>
</div>

---

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh -o /tmp/rhdp-install.sh
bash /tmp/rhdp-install.sh
```

The installer will ask:
1. Platform (Claude Code or Cursor)
2. Namespace (showroom, agnosticv, health, or all)

---

## Choose Your Namespace

### 🎓 Showroom (Content Creation)

For workshop and demo creators.

**Skills:** create-lab, create-demo, verify-content, blog-generate

[Showroom Guide →](showroom.html)

### ⚙️ AgnosticV (RHDP Provisioning)

For RHDP catalog creators.

**Skills:** agnosticv-catalog-builder (unified), agv-validator

**Prerequisites:** RHDP access, AgnosticV repo at `~/work/code/agnosticv`

[AgnosticV Guide →](agnosticv.html)

### 🏥 Health (Post-Deployment)

For RHDP validation roles.

**Skills:** validation-role-builder

---

## Verify Installation

**Claude Code:**
```bash
ls ~/.claude/skills/
```

**Cursor:**
```bash
ls ~/.cursor/skills/
ls .cursor/rules/
```

---

## Need Help?

- [Troubleshooting Guide](../reference/troubleshooting.html)
- [GitHub Issues](https://github.com/rhpds/rhdp-skills-marketplace/issues)
- Slack: #forum-rhdp

---

[← Back to Home](../)
