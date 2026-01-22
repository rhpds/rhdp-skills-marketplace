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

**New to these terms?** [Check the Glossary →](reference/glossary.html)

### 🎓 Showroom (Most Users)

- **[/create-lab](skills/create-lab.html)** - Generate workshop lab modules
- **[/create-demo](skills/create-demo.html)** - Generate presenter-led demos
- **[/verify-content](skills/verify-content.html)** - Quality validation
- **[/blog-generate](skills/blog-generate.html)** - Transform to blog posts

[View all Showroom skills →](skills/index.html#showroom-skills-content-creation)

### ⚙️ AgnosticV (RHDP Team)

- **[/agnosticv-catalog-builder](skills/agnosticv-catalog-builder.html)** - Create/update catalogs
- **[/agnosticv-validator](skills/agnosticv-validator.html)** - Validate configurations

[Learn more →](setup/agnosticv.html)

### 🏥 Health (RHDP Team)

- **[/deployment-health-checker](skills/deployment-health-checker.html)** - Create validation roles

[Learn more →](../health/README.html)

---

## Coming Soon

### 🏥 Health (In Development)

- **[/ftl](skills/ftl.html)** - Automated grader/solver generation for workshop testing

### 🤖 Automation (In Development)

- **[/field-automation-builder](https://github.com/rhpds/field-sourced-content)** - Field content integration

[Learn more →](../automation/README.html)

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
- **Version:** v1.5.2

---

## License

Apache License 2.0 | [View on GitHub](https://github.com/rhpds/rhdp-skills-marketplace)
