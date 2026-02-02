---
layout: default
title: Home
---

# RHDP Skills Marketplace

AI-powered skills for Red Hat Demo Platform content creation and provisioning.

---

## Quick Start

Add the RHDP marketplace to Claude Code:

```bash
/plugin marketplace add rhpds/rhdp-skills-marketplace
```

Then install the plugins you need:

```bash
# For workshop/demo creation
/plugin install showroom-create-lab@rhdp-marketplace
/plugin install showroom-create-demo@rhdp-marketplace

# For AgnosticV catalogs (RHDP internal)
/plugin install agnosticv-catalog-builder@rhdp-marketplace
```

**Benefits:** Standard installation (like dnf/brew), automatic updates, version management

[See complete plugin list →](../MARKETPLACE.html)

---

## What's Included?

**New to these terms?** [Check the Glossary →](reference/glossary.html)

### 🎓 Showroom (Most Users)

- **[/showroom-create-lab](skills/create-lab.html)** - Generate workshop lab modules
- **[/showroom-create-demo](skills/create-demo.html)** - Generate presenter-led demos
- **[/showroom-verify-content](skills/verify-content.html)** - Quality validation
- **[/showroom-blog-generate](skills/blog-generate.html)** - Transform to blog posts

[View all Showroom skills →](skills/index.html#showroom-skills-content-creation)

### ⚙️ AgnosticV (RHDP Team or Advanced Users)

- **[/agnosticv-catalog-builder](skills/agnosticv-catalog-builder.html)** - Create/update catalogs
- **[/agnosticv-validator](skills/agnosticv-validator.html)** - Validate configurations

[Learn more →](setup/agnosticv.html)

### 🏥 Health (RHDP Team or Advanced Users)

- **[/health-deployment-validator](skills/deployment-health-checker.html)** - Create validation roles

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
- **Slack:** [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX)
- **Version:** v1.8.0

---

## License

Apache License 2.0 | [View on GitHub](https://github.com/rhpds/rhdp-skills-marketplace)
