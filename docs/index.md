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

## Available Skills {#available-skills}

<div class="tabs">
  <div class="tab-buttons">
    <button class="tab-button active" onclick="openTab(event, 'showroom')">📝 Showroom (4)</button>
    <button class="tab-button" onclick="openTab(event, 'agnosticv')">⚙️ AgnosticV (2)</button>
    <button class="tab-button" onclick="openTab(event, 'health')">🏥 Health (1)</button>
  </div>

  <div id="showroom" class="tab-content active">
    <h3>Showroom Skills</h3>
    <p><strong>For workshop and demo creators</strong> - Content creation and validation skills.</p>

    <table>
      <thead>
        <tr>
          <th>Skill</th>
          <th>Description</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><strong><a href="skills/create-lab.html">/showroom:create-lab</a></strong></td>
          <td>Generate workshop lab modules with Know/Show structure</td>
        </tr>
        <tr>
          <td><strong><a href="skills/create-demo.html">/showroom:create-demo</a></strong></td>
          <td>Create presenter-led demo content</td>
        </tr>
        <tr>
          <td><strong><a href="skills/verify-content.html">/showroom:verify-content</a></strong></td>
          <td>Quality validation and standards compliance</td>
        </tr>
        <tr>
          <td><strong><a href="skills/blog-generate.html">/showroom:blog-generate</a></strong></td>
          <td>Transform workshops into blog posts</td>
        </tr>
      </tbody>
    </table>

    <p><a href="setup/showroom.html">View detailed Showroom documentation →</a></p>
  </div>

  <div id="agnosticv" class="tab-content">
    <h3>AgnosticV Skills</h3>
    <p><strong>For RHDP infrastructure team</strong> - Catalog automation and validation.</p>

    <table>
      <thead>
        <tr>
          <th>Skill</th>
          <th>Description</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><strong><a href="skills/agnosticv-catalog-builder.html">/agnosticv:catalog-builder</a></strong></td>
          <td>Create/update AgnosticV catalogs and Virtual CIs</td>
        </tr>
        <tr>
          <td><strong><a href="skills/agnosticv-validator.html">/agnosticv:validator</a></strong></td>
          <td>Validate catalog configurations</td>
        </tr>
      </tbody>
    </table>

    <p><a href="setup/agnosticv.html">View detailed AgnosticV documentation →</a></p>
  </div>

  <div id="health" class="tab-content">
    <h3>Health Skills</h3>
    <p><strong>For deployment validation</strong> - Automated health checks and testing.</p>

    <table>
      <thead>
        <tr>
          <th>Skill</th>
          <th>Description</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><strong><a href="skills/deployment-health-checker.html">/health:deployment-validator</a></strong></td>
          <td>Create Ansible validation roles for deployments</td>
        </tr>
      </tbody>
    </table>
  </div>
</div>

<script>
function openTab(evt, tabName) {
  // Hide all tab contents
  var tabContents = document.getElementsByClassName("tab-content");
  for (var i = 0; i < tabContents.length; i++) {
    tabContents[i].classList.remove("active");
  }

  // Remove active class from all buttons
  var tabButtons = document.getElementsByClassName("tab-button");
  for (var i = 0; i < tabButtons.length; i++) {
    tabButtons[i].classList.remove("active");
  }

  // Show the selected tab
  document.getElementById(tabName).classList.add("active");
  evt.currentTarget.classList.add("active");
}
</script>

---

## Support {#support}

**Need help?**

- **GitHub Issues:** [Report bugs or request features](https://github.com/rhpds/rhdp-skills-marketplace/issues)
- **Slack:** [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX) - Community support
- **Documentation:** [Quick Reference](reference/quick-reference.html) | [Troubleshooting](reference/troubleshooting.html) | [Glossary](reference/glossary.html)

**Version:** v2.3.5 | **License:** Apache 2.0 | **Platform:** Claude Code, VS Code with Claude, Cursor 2.4+

---

## Quick Install

**Add marketplace (choose one):**

```bash
# If you have SSH keys configured for GitHub (shorter)
/plugin marketplace add rhpds/rhdp-skills-marketplace

# If SSH not configured, use HTTPS
/plugin marketplace add https://github.com/rhpds/rhdp-skills-marketplace
```

**Install plugins:**

```bash
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
