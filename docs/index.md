---
layout: default
title: Home
---

# RHDP Skills Marketplace

AI-powered skills for Red Hat Demo Platform content creation and provisioning.

---

## Quick Start

Download and run the installer:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh -o /tmp/rhdp-install.sh
bash /tmp/rhdp-install.sh
```

The installer will guide you through platform and namespace selection.

**Using Claude Code or VS Code with Claude extension?** Skills work natively with `/skill-name` commands.

**Using Cursor?** [See Cursor setup guide →](setup/cursor.html) *(experimental - still testing, may not work reliably)*

---

## What's Included?

### 🎓 Showroom Namespace (Content Creation)

For external developers and content creators:

- **[/create-lab](skills/create-lab.html)** - Generate workshop lab modules
- **[/create-demo](skills/create-demo.html)** - Generate presenter-led demos
- **[/verify-content](skills/verify-content.html)** - Quality validation
- **[/blog-generate](skills/blog-generate.html)** - Transform to blog posts

[View all Showroom skills →](skills/index.html#showroom-skills-content-creation)

### ⚙️ AgnosticV Namespace (RHDP Provisioning)

For RHDP internal and advanced users:

- **[/agnosticv-catalog-builder](skills/agnosticv-catalog-builder.html)** - Create/update catalogs (unified)
- **[/agnosticv-validator](skills/agnosticv-validator.html)** - Validate configurations

[Learn more about AgnosticV skills →](setup/agnosticv.html)

### 🏥 Health Namespace (Post-Deployment Validation)

For RHDP internal and advanced users:

- **[/validation-role-builder](skills/validation-role-builder.html)** - Create validation roles
- **[/ftl](skills/ftl.html)** - Finish The Labs: Automated grader and solver generation

[Learn more about Health skills →](../health/README.html)

---

## Coming Soon

### 🤖 Automation Namespace (Intelligent Automation)

**Status:** In Development

Future skills for intelligent automation and field-sourced content integration:

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
- **Version:** v1.3.0

---

## License

Apache License 2.0 | [View on GitHub](https://github.com/rhpds/rhdp-skills-marketplace)
