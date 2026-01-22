---
layout: default
title: Home
---

# RHDP Skills Marketplace

AI-powered skills for Red Hat Demo Platform content creation and provisioning.

**Supports:** Claude Code (Recommended) | Cursor (Experimental)

> **⚠️ Important - Cursor Support is Experimental**
>
> Agent Skills in Cursor are **not fully supported yet** but will be supported in the future. We're using the `.cursor/rules/` approach to reuse Claude Code skills as a temporary workaround.
>
> **Claude Code is the recommended platform** for the best experience.
>
> [Learn more about Cursor support →](https://github.com/rhpds/rhdp-skills-marketplace/blob/main/cursor-rules/README.md) | [Cursor Forum Discussion →](https://forum.cursor.com/t/support-for-claude-skills/148267)

---

## Quick Start

### Installation

Download and run the installer:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh -o /tmp/rhdp-install.sh
bash /tmp/rhdp-install.sh
```

The installer will guide you through:
1. Platform selection (Claude Code or Cursor)
2. Namespace selection (showroom, agnosticv, health, or all)
3. Automatic backup and installation

**For Claude Code users:**
- Skills installed to `~/.claude/skills/`
- Ready to use with `/skill-name` commands
- Native Agent Skills support

**For Cursor users:**
- Skills installed to `~/.cursor/skills/`
- Rules installed to `.cursor/rules/` in current directory
- Use trigger phrases like "create lab" or "validate agv"
- ⚠️ Experimental - Claude Code is recommended

---

## What's Included?

### 🎓 Showroom Namespace (Content Creation)

For external developers and content creators:

- **[/create-lab](skills/create-lab.html)** - Generate workshop lab modules
- **[/create-demo](skills/create-demo.html)** - Generate presenter-led demos
- **[/verify-content](skills/verify-content.html)** - Quality validation
- **[/blog-generate](skills/blog-generate.html)** - Transform to blog posts

[Learn more about Showroom skills →](setup/showroom.html)

### ⚙️ AgnosticV Namespace (RHDP Provisioning)

For RHDP internal and advanced users:

- **[/agv-generator](skills/agv-generator.html)** - Create catalog items
- **[/agv-validator](skills/agv-validator.html)** - Validate configurations
- **[/generate-agv-description](skills/generate-agv-description.html)** - Generate descriptions

[Learn more about AgnosticV skills →](setup/agnosticv.html)

### 🏥 Health Namespace (Post-Deployment Validation)

For RHDP internal and advanced users:

- **[/validation-role-builder](skills/validation-role-builder.html)** - Create validation roles

[Learn more about Health skills →](../health/README.html)

---

## Coming Soon

### 🤖 Automation Namespace (Intelligent Automation)

**Status:** In Development

Future skills for intelligent automation, lab validation, and field-sourced content integration:

- **[/ftl](https://github.com/rhpds/rhdp-skills-marketplace/blob/main/automation/README.md)** - Finish The Labs: Automated grader and solver generation for workshop testing (based on [FTL grading system](https://github.com/redhat-gpte-devopsautomation/FTL))
- **[/field-automation-builder](https://github.com/rhpds/field-sourced-content)** - Integration with field-sourced content repository for automated catalog generation

[Learn more about Automation vision →](../automation/README.html)

---

## Getting Started

<div class="grid">
  <div class="card">
    <h3>📚 Setup Guide</h3>
    <p>Install skills for Claude Code or Cursor</p>
    <a href="setup/">Get Started →</a>
  </div>

  <div class="card">
    <h3>🎯 Quick Reference</h3>
    <p>Common workflows and examples</p>
    <a href="reference/quick-reference.html">View Reference →</a>
  </div>

  <div class="card">
    <h3>🔧 Troubleshooting</h3>
    <p>Common issues and solutions</p>
    <a href="reference/troubleshooting.html">Get Help →</a>
  </div>
</div>

---

## Updates

Keep your skills current:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/update.sh -o /tmp/rhdp-update.sh
bash /tmp/rhdp-update.sh
```

---

## Support

- **GitHub:** [Issues](https://github.com/rhpds/rhdp-skills-marketplace/issues)
- **Slack:** #forum-rhdp or #forum-rhdp-content
- **Version:** v1.0.0

---

## License

Apache License 2.0 | [View on GitHub](https://github.com/rhpds/rhdp-skills-marketplace)
