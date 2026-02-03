---
layout: default
title: Home
---

# Welcome to RHDP Skills Marketplace

AI-powered skills for creating workshops, demos, and automating Red Hat Demo Platform infrastructure.

**Install once, automate forever.** Browse skills below or create your own.

---

<div class="tiles-container">

<div class="tile">
  <h3>🚀 Quick Start</h3>
  <p>New to the marketplace? Get up and running in 5 minutes.</p>
  <a href="setup/index.html" class="tile-link">Install & Setup →</a>
</div>

<div class="tile">
  <h3>🔄 Migration Guide</h3>
  <p>Used install.sh script? Migrate to plugin-based marketplace.</p>
  <a href="setup/migration.html" class="tile-link">Migration Steps →</a>
</div>

<div class="tile">
  <h3>🎓 Create Your Own Skills</h3>
  <p>Build custom skills for your workflows with Claude's help.</p>
  <a href="contributing/create-your-own-skill.html" class="tile-link">Start Workshop →</a>
</div>

<div class="tile">
  <h3>📝 Showroom Skills</h3>
  <p>Create workshops, demos, and content for Red Hat Showroom.</p>
  <a href="#showroom-skills" class="tile-link">4 Skills Available →</a>
</div>

<div class="tile">
  <h3>⚙️ AgnosticV Skills</h3>
  <p>Automate infrastructure catalogs and validation (RHDP internal).</p>
  <a href="#agnosticv-skills" class="tile-link">2 Skills Available →</a>
</div>

<div class="tile">
  <h3>🏥 Health Skills</h3>
  <p>Deployment validation and health checks.</p>
  <a href="#health-skills" class="tile-link">1 Skill Available →</a>
</div>

<div class="tile">
  <h3>📚 Documentation</h3>
  <p>Guides, references, and troubleshooting.</p>
  <a href="reference/quick-reference.html" class="tile-link">Browse Docs →</a>
</div>

<div class="tile">
  <h3>💬 Get Support</h3>
  <p>Questions? Join our community or open an issue.</p>
  <a href="#support" class="tile-link">Get Help →</a>
</div>

</div>

<style>
.tiles-container {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.tile {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
  transition: all 0.3s ease;
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}

.tile:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(238, 0, 0, 0.1);
  border-color: #EE0000;
}

.tile h3 {
  margin-top: 0;
  color: #24292e;
  font-size: 1.25rem;
  margin-bottom: 0.5rem;
}

.tile p {
  color: #586069;
  font-size: 0.95rem;
  margin-bottom: 1rem;
  line-height: 1.5;
}

.tile-link {
  display: inline-block;
  color: #EE0000;
  text-decoration: none;
  font-weight: 600;
  font-size: 0.9rem;
  border-bottom: 2px solid transparent;
  transition: border-color 0.2s ease;
}

.tile-link:hover {
  border-bottom-color: #EE0000;
}

@media (max-width: 768px) {
  .tiles-container {
    grid-template-columns: 1fr;
  }
}
</style>

---

## Showroom Skills {#showroom-skills}

**For workshop and demo creators** - Content creation and validation skills.

| Skill | Description |
|-------|-------------|
| **[/showroom:create-lab](skills/create-lab.html)** | Generate workshop lab modules with Know/Show structure |
| **[/showroom:create-demo](skills/create-demo.html)** | Create presenter-led demo content |
| **[/showroom:verify-content](skills/verify-content.html)** | Quality validation and standards compliance |
| **[/showroom:blog-generate](skills/blog-generate.html)** | Transform workshops into blog posts |

[View detailed Showroom documentation →](setup/showroom.html)

---

## AgnosticV Skills {#agnosticv-skills}

**For RHDP infrastructure team** - Catalog automation and validation.

| Skill | Description |
|-------|-------------|
| **[/agnosticv:catalog-builder](skills/agnosticv-catalog-builder.html)** | Create/update AgnosticV catalogs and Virtual CIs |
| **[/agnosticv:validator](skills/agnosticv-validator.html)** | Validate catalog configurations |

[View detailed AgnosticV documentation →](setup/agnosticv.html)

---

## Health Skills {#health-skills}

**For deployment validation** - Automated health checks and testing.

| Skill | Description |
|-------|-------------|
| **[/health:deployment-validator](skills/deployment-health-checker.html)** | Create Ansible validation roles for deployments |

---

## Support {#support}

**Need help?**

- **GitHub Issues:** [Report bugs or request features](https://github.com/rhpds/rhdp-skills-marketplace/issues)
- **Slack:** [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX) - Community support
- **Documentation:** [Quick Reference](reference/quick-reference.html) | [Troubleshooting](reference/troubleshooting.html) | [Glossary](reference/glossary.html)

**Version:** v2.3.0 | **License:** Apache 2.0 | **Platform:** Claude Code, VS Code with Claude, Cursor 2.4+

---

## Quick Install

```bash
# Add marketplace
/plugin marketplace add https://github.com/rhpds/rhdp-skills-marketplace

# Install plugins
/plugin install showroom@rhdp-marketplace
/plugin install agnosticv@rhdp-marketplace
/plugin install health@rhdp-marketplace
```

**Then restart Claude Code to load the new skills.**

**To update later:**
```bash
/plugin marketplace update
# Interactive: select marketplace, press 'u'

/plugin update showroom@rhdp-marketplace
# Interactive: navigate to "Update now", press Enter
```

[Complete installation and update guide →](setup/index.html)
