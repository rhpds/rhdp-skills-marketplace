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
# If you have SSH keys configured (shorter)
/plugin marketplace add rhpds/rhdp-skills-marketplace

# If you don't have SSH configured (use this)
/plugin marketplace add https://github.com/rhpds/rhdp-skills-marketplace
```

Then install the plugins you need:

```bash
# For workshop/demo creation
/plugin install showroom@rhdp-marketplace

# For AgnosticV catalogs (RHDP internal)
/plugin install agnosticv@rhdp-marketplace

# For deployment health checks (RHDP internal)
/plugin install health@rhdp-marketplace
```

**Benefits:** Standard installation (like dnf/brew), automatic updates, version management

[See complete plugin list →](../MARKETPLACE.html)

---

## What's Included?

**New to these terms?** [Check the Glossary →](reference/glossary.html)

### 🎓 Showroom (Most Users)

- **[/showroom:create-lab](skills/create-lab.html)** - Generate workshop lab modules
- **[/showroom:create-demo](skills/create-demo.html)** - Generate presenter-led demos
- **[/showroom:verify-content](skills/verify-content.html)** - Quality validation
- **[/showroom:blog-generate](skills/blog-generate.html)** - Transform to blog posts

[View all Showroom skills →](skills/index.html#showroom-skills-content-creation)

### ⚙️ AgnosticV (RHDP Team or Advanced Users)

- **[/agnosticv:catalog-builder](skills/agnosticv-catalog-builder.html)** - Create/update catalogs & Virtual CIs
- **[/agnosticv:validator](skills/agnosticv-validator.html)** - Validate configurations

[Learn more →](setup/agnosticv.html)

### 🏥 Health (RHDP Team or Advanced Users)

- **[/health:deployment-validator](skills/deployment-health-checker.html)** - Create validation roles

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

Keep your plugins current:

```bash
/plugin marketplace update
/plugin update showroom@rhdp-marketplace
/plugin update agnosticv@rhdp-marketplace
```

---

## Support

- **GitHub:** [Issues](https://github.com/rhpds/rhdp-skills-marketplace/issues)
- **Slack:** [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX)
- **Version:** v2.2.0

---

## License

Apache License 2.0 | [View on GitHub](https://github.com/rhpds/rhdp-skills-marketplace)
