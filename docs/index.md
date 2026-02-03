---
layout: default
title: Home
---

# RHDP Skills Marketplace

AI-powered skills for Red Hat Demo Platform content creation and provisioning.

---

## Quick Start

### 🔄 Upgrading from v2.2.0 or Earlier?

**If you used the old file-based installation (`install.sh`) or have skills in `~/.claude/skills/`:**

You need to migrate to the new plugin-based system. It's simple and takes 5 minutes.

**[Migration Guide: File-Based → Plugin-Based →](setup/migration.html)**

Shows you exactly how to:
- Remove old installation
- Install marketplace plugins
- Update to namespace prefixes (`/showroom:create-lab` format)
- Troubleshoot common issues

---

### Installation

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

**Restart Claude Code** after installation to load the new skills.

**Benefits:** Standard installation (like dnf/brew), automatic updates, version management

### Understanding Plugin Scopes

Plugins can be installed at different scopes:

- **User-scoped** (default): Available in all your Claude Code sessions across all projects
  - Installed with: `/plugin install showroom@rhdp-marketplace`
  - Stored in: `~/.claude/plugins/`

- **Project-scoped**: Only available in a specific project directory
  - Enable by adding to `.claude/settings.json` in your project
  - Useful for team-shared configurations
  - See [Team Setup Guide](setup/index.html#project-scoped-plugins)

[See complete plugin list →](../MARKETPLACE.html)

---

## 🎓 Create Your Own Skills & Plugins

**Want to build custom skills for your team or contribute to the marketplace?**

Our hands-on workshop teaches you how to create Claude Code skills and plugins from scratch:

- 📖 Learn from real RHDP skills (showroom, agnosticv)
- 🛠️ Build a complete skill step-by-step
- 📦 Package skills into distributable plugins
- 🚀 Publish to your own marketplace or contribute to RHDP

**[Start the Workshop →](contributing/create-your-own-skill.html)**

**Time:** 60-90 minutes | **Level:** Beginner-friendly

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
# Update marketplace (interactive: press 'u')
/plugin marketplace update

# Update plugins (interactive: select "Update now" and press Enter)
/plugin update showroom@rhdp-marketplace
/plugin update agnosticv@rhdp-marketplace
```

Both commands open interactive UIs. Restart Claude Code after updates.

---

## Support

- **GitHub:** [Issues](https://github.com/rhpds/rhdp-skills-marketplace/issues)
- **Slack:** [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX)
- **Version:** v2.3.0

---

## License

Apache License 2.0 | [View on GitHub](https://github.com/rhpds/rhdp-skills-marketplace)
