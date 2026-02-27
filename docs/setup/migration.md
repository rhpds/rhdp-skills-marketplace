---
layout: default
title: Claude Code Migration Guide
---

# Claude Code Migration Guide

<div class="migration-badge">📦 install.sh → Plugin Marketplace</div>

This guide helps you migrate from the old `install.sh` script to the new plugin-based marketplace system.

---

## 🎯 Why Migrate?

<div class="comparison-grid">
  <div class="comparison-card old-way">
    <h3>❌ Old Way (File-Based)</h3>
    <pre><code>curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | bash</code></pre>
    <ul class="feature-list">
      <li>✗ Manual updates required</li>
      <li>✗ No version management</li>
      <li>✗ Hard to share with team</li>
      <li>✗ Skills in <code>~/.claude/skills/</code></li>
    </ul>
  </div>

  <div class="comparison-card new-way">
    <h3>✅ New Way (Plugin-Based)</h3>
    <pre><code>/plugin marketplace add rhpds/rhdp-skills-marketplace
/plugin install showroom@rhdp-marketplace</code></pre>
    <ul class="feature-list">
      <li>✓ Automatic update notifications</li>
      <li>✓ Version management and rollback</li>
      <li>✓ Easy team distribution</li>
      <li>✓ Standard package management</li>
    </ul>
  </div>
</div>

---

## ✓ Prerequisites

<div class="prereq-box">
  <h4>Before migrating, ensure you have Claude Code installed:</h4>
  <ol>
    <li>If you don't have Claude Code yet, install it from <a href="https://claude.com/claude-code" target="_blank">https://claude.com/claude-code</a></li>
    <li>Verify installation: <code>claude --version</code> in your terminal</li>
  </ol>
  <p style="margin-top: 1rem;"><strong>VS Code users:</strong> Install the Claude extension from the VS Code marketplace instead.</p>
</div>

---

## 🚀 Migration Steps

<div class="migration-steps">
  <div class="step-card">
    <div class="step-number">1</div>
    <div class="step-content">
      <h3>💾 Backup Your Installation</h3>
      <p>In your terminal, back up any customized skills:</p>
      <pre><code>cp -r ~/.claude/skills ~/.claude/skills-backup
cp -r ~/.claude/docs ~/.claude/docs-backup</code></pre>
    </div>
  </div>

  <div class="step-card">
    <div class="step-number">2</div>
    <div class="step-content">
      <h3>🗑️ Remove Old Installation</h3>
      <p>In your terminal, clean up the old file-based installation:</p>
      <pre><code>rm -rf ~/.claude/skills/create-lab
rm -rf ~/.claude/skills/create-demo
rm -rf ~/.claude/skills/blog-generate
rm -rf ~/.claude/skills/verify-content
rm -rf ~/.claude/skills/agnosticv-catalog-builder
rm -rf ~/.claude/skills/agnosticv-validator
rm -rf ~/.claude/skills/deployment-health-checker
rm -rf ~/.claude/docs</code></pre>
    </div>
  </div>

  <div class="step-card">
    <div class="step-number">3</div>
    <div class="step-content">
      <h3>🚀 Start Claude Code</h3>
      <p>In your terminal, start Claude Code:</p>
      <pre><code>claude</code></pre>
      <p style="margin-top: 0.5rem; color: #586069; font-size: 0.875rem;">This opens the Claude Code interactive chat where you'll run the next commands.</p>
    </div>
  </div>

  <div class="step-card">
    <div class="step-number">4</div>
    <div class="step-content">
      <h3>📦 Add Marketplace</h3>
      <p><strong>In Claude Code chat (NOT in terminal)</strong>, add the RHDP marketplace:</p>
      <pre><code># If you have SSH keys configured
/plugin marketplace add rhpds/rhdp-skills-marketplace

# If you don't have SSH configured
/plugin marketplace add https://github.com/rhpds/rhdp-skills-marketplace</code></pre>
    </div>
  </div>

  <div class="step-card">
    <div class="step-number">5</div>
    <div class="step-content">
      <h3>⬇️ Install Plugins</h3>
      <p><strong>In Claude Code chat</strong>, install the plugins you need:</p>
      <pre><code># For workshop/demo creation (most users)
/plugin install showroom@rhdp-marketplace

# For AgnosticV catalogs (RHDP internal)
/plugin install agnosticv@rhdp-marketplace

# For deployment health checks (RHDP internal)
/plugin install health@rhdp-marketplace
/plugin install ftl@rhdp-marketplace
/plugin install ftl@rhdp-marketplace</code></pre>
    </div>
  </div>

  <div class="step-card">
    <div class="step-number">6</div>
    <div class="step-content">
      <h3>🔄 Restart Claude Code</h3>
      <p>Exit Claude Code completely and restart it to load the new plugins.</p>
    </div>
  </div>

  <div class="step-card">
    <div class="step-number">7</div>
    <div class="step-content">
      <h3>✓ Verify Installation</h3>
      <p><strong>In Claude Code chat</strong>, check that skills are available:</p>
      <pre><code>/skills</code></pre>
      <div class="success-box" style="margin-top: 1rem;">
        <strong>You should see:</strong>
        <ul style="margin-top: 0.5rem;">
          <li><code>/showroom:create-lab</code></li>
          <li><code>/showroom:create-demo</code></li>
          <li><code>/showroom:blog-generate</code></li>
          <li><code>/showroom:verify-content</code></li>
          <li><code>/agnosticv:catalog-builder</code></li>
          <li><code>/agnosticv:validator</code></li>
          <li><code>/health:deployment-validator</code></li>
        </ul>
      </div>
    </div>
  </div>
</div>

---

## 📋 What Changed?

### Skill Names

<div class="info-box">
Skills now include namespace prefixes to show which plugin provides them:
</div>

<table class="changes-table">
  <thead>
    <tr>
      <th>Old Name</th>
      <th>New Name</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>/create-lab</code></td>
      <td><code>/showroom:create-lab</code></td>
    </tr>
    <tr>
      <td><code>/create-demo</code></td>
      <td><code>/showroom:create-demo</code></td>
    </tr>
    <tr>
      <td><code>/blog-generate</code></td>
      <td><code>/showroom:blog-generate</code></td>
    </tr>
    <tr>
      <td><code>/verify-content</code></td>
      <td><code>/showroom:verify-content</code></td>
    </tr>
    <tr>
      <td><code>/agnosticv-catalog-builder</code></td>
      <td><code>/agnosticv:catalog-builder</code></td>
    </tr>
    <tr>
      <td><code>/agnosticv-validator</code></td>
      <td><code>/agnosticv:validator</code></td>
    </tr>
    <tr>
      <td><code>/deployment-health-checker</code></td>
      <td><code>/health:deployment-validator</code></td>
    </tr>
  </tbody>
</table>

### Directory Structure

<details>
<summary><strong>Click to see directory structure comparison</strong></summary>

<h4>Old file-based installation:</h4>
<pre><code>~/.claude/
├── skills/
│   ├── create-lab/
│   │   └── SKILL.md
│   ├── create-demo/
│   │   └── SKILL.md
│   ├── agnosticv-catalog-builder/
│   │   └── SKILL.md
│   └── ...
├── docs/
│   └── (documentation files)
└── skills/.rhdp-marketplace-version</code></pre>

<h4>New plugin-based installation:</h4>
<pre><code>~/.claude/
└── plugins/
    ├── cache/
    │   └── rhdp-marketplace/
    │       ├── showroom/
    │       │   └── 1.0.0/
    │       │       └── skills/
    │       │           ├── create-lab/SKILL.md
    │       │           ├── create-demo/SKILL.md
    │       │           ├── blog-generate/SKILL.md
    │       │           └── verify-content/SKILL.md
    │       ├── agnosticv/
    │       │   └── 2.2.0/
    │       │       └── skills/
    │       │           ├── catalog-builder/SKILL.md
    │       │           └── validator/SKILL.md
    │       └── health/
    │           └── 1.0.0/
    │               └── skills/
    │                   └── deployment-validator/SKILL.md
    ├── marketplaces/
    │   └── rhdp-marketplace/
    │       └── (full marketplace repo)
    ├── installed_plugins.json
    └── known_marketplaces.json</code></pre>

<h4>Key Differences:</h4>
<table class="differences-table">
  <thead>
    <tr>
      <th>Aspect</th>
      <th>Old Location</th>
      <th>New Location</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Skills</strong></td>
      <td><code>~/.claude/skills/create-lab/</code></td>
      <td><code>~/.claude/plugins/cache/rhdp-marketplace/showroom/1.0.0/skills/create-lab/</code></td>
    </tr>
    <tr>
      <td><strong>Documentation</strong></td>
      <td><code>~/.claude/docs/</code></td>
      <td>Embedded in plugin directories</td>
    </tr>
    <tr>
      <td><strong>Version tracking</strong></td>
      <td><code>.rhdp-marketplace-version</code></td>
      <td>Built into plugin system with versioned directories</td>
    </tr>
    <tr>
      <td><strong>Updates</strong></td>
      <td>Manual (run update.sh)</td>
      <td>Automatic (<code>/plugin update</code>)</td>
    </tr>
    <tr>
      <td><strong>Management</strong></td>
      <td>Manual file copies</td>
      <td>Plugin system</td>
    </tr>
  </tbody>
</table>

</details>

---

## 🔄 Updating Plugins

<div class="update-process">
  <div class="update-step">
    <h4>Step 1: Update Marketplace</h4>
    <pre><code>/plugin marketplace update</code></pre>
    <p>This opens an interactive UI:</p>
    <ol>
      <li>Select the marketplace</li>
      <li>Press <code>u</code> to update it</li>
      <li>Press <code>Esc</code> to go back</li>
    </ol>
    <p class="note">This refreshes the marketplace cache with the latest plugin versions.</p>
  </div>

  <div class="update-step">
    <h4>Step 2: Update Plugins</h4>
    <pre><code>/plugin update showroom@rhdp-marketplace</code></pre>
    <p>This opens an interactive UI:</p>
    <ol>
      <li>Navigate with <code>ctrl+p</code> or arrow keys</li>
      <li>Select "Update now" and press <code>Enter</code></li>
      <li>Press <code>Esc</code> to go back</li>
    </ol>
  </div>
</div>

<div class="install-note">
ℹ️ <strong>Note:</strong> Both commands are interactive - you must use the UI to perform updates. After updating, <strong>restart Claude Code</strong> to load the new versions.
</div>

---

## 🆘 Troubleshooting

<div class="troubleshooting-box">
  <p>See the <a href="../reference/troubleshooting.html#migration-issues">Troubleshooting Guide</a> for common migration issues.</p>
</div>

---

## ↩️ Rollback (If Needed)

<details>
<summary><strong>Click to see rollback instructions</strong></summary>

<p>If you need to rollback to the old file-based installation:</p>

<pre><code># Restore from backup
cp -r ~/.claude/skills-backup ~/.claude/skills
cp -r ~/.claude/docs-backup ~/.claude/docs

# Remove plugins
/plugin uninstall showroom@rhdp-marketplace
/plugin uninstall agnosticv@rhdp-marketplace
/plugin uninstall health@rhdp-marketplace
/plugin marketplace remove rhdp-marketplace</code></pre>

</details>

---

<div class="next-steps">
  <h3>📚 Next Steps</h3>
  <ul>
    <li><a href="claude-code.html">Claude Code Setup Guide →</a></li>
    <li><a href="../reference/troubleshooting.html">Troubleshooting →</a></li>
    <li><a href="../reference/quick-reference.html">Quick Reference →</a></li>
  </ul>
</div>

<style>
.migration-badge {
  display: inline-block;
  background: linear-gradient(135deg, #EE0000 0%, #CC0000 100%);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  font-weight: 600;
  margin: 1rem 0;
}

.prereq-box {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 12px;
  padding: 1.5rem;
  margin: 1rem 0;
}

.prereq-box h4 {
  margin-top: 0;
  color: #24292e;
}

.prereq-box ol {
  margin: 0.5rem 0;
  padding-left: 1.25rem;
}

.prereq-box code {
  background: #f6f8fa;
  padding: 0.2rem 0.4rem;
  border-radius: 3px;
  color: #EE0000;
}

.comparison-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.comparison-card {
  border-radius: 12px;
  padding: 1.5rem;
  border: 2px solid;
}

.comparison-card h3 {
  margin-top: 0;
  margin-bottom: 1rem;
}

.comparison-card pre {
  background: rgba(0, 0, 0, 0.05);
  padding: 1rem;
  border-radius: 6px;
  overflow-x: auto;
  margin: 1rem 0;
}

.old-way {
  background: #fff3cd;
  border-color: #ffc107;
}

.old-way h3 {
  color: #856404;
}

.new-way {
  background: #d4edda;
  border-color: #28a745;
}

.new-way h3 {
  color: #155724;
}

.feature-list {
  list-style: none;
  padding-left: 0;
  margin: 0;
}

.feature-list li {
  padding: 0.25rem 0;
}

.migration-steps {
  margin: 2rem 0;
}

.step-card {
  display: flex;
  gap: 1.5rem;
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 1px solid #e1e4e8;
  border-radius: 12px;
  padding: 1.5rem;
  margin-bottom: 1.5rem;
}

.step-number {
  flex-shrink: 0;
  width: 48px;
  height: 48px;
  background: linear-gradient(135deg, #EE0000 0%, #CC0000 100%);
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  font-weight: 700;
}

.step-content {
  flex: 1;
}

.step-content h3 {
  margin-top: 0;
  margin-bottom: 0.5rem;
  color: #24292e;
}

.step-content p {
  margin-bottom: 0.75rem;
  color: #586069;
}

.step-content pre {
  background: #f6f8fa;
  padding: 1rem;
  border-radius: 6px;
  overflow-x: auto;
  margin: 0.5rem 0;
}

.success-box {
  background: #d4edda;
  border-left: 4px solid #28a745;
  padding: 1rem;
  border-radius: 4px;
  color: #155724;
}

.success-box ul {
  margin: 0;
  padding-left: 1.5rem;
}

.success-box code {
  background: rgba(0, 0, 0, 0.05);
  padding: 0.2rem 0.4rem;
  border-radius: 3px;
}

.info-box {
  background: #e7f3ff;
  border-left: 4px solid #0969da;
  padding: 1rem;
  margin: 1rem 0;
  border-radius: 4px;
}

.changes-table {
  width: 100%;
  border-collapse: collapse;
  margin: 1rem 0;
  background: white;
  border-radius: 8px;
  overflow: hidden;
}

.changes-table thead {
  background: #f6f8fa;
}

.changes-table th {
  padding: 0.75rem;
  text-align: left;
  font-weight: 600;
  border-bottom: 2px solid #e1e4e8;
}

.changes-table td {
  padding: 0.75rem;
  border-bottom: 1px solid #e1e4e8;
}

.changes-table tbody tr:last-child td {
  border-bottom: none;
}

.changes-table code {
  background: #f6f8fa;
  padding: 0.2rem 0.4rem;
  border-radius: 3px;
  color: #EE0000;
}

.differences-table {
  width: 100%;
  border-collapse: collapse;
  margin: 1rem 0;
}

.differences-table th,
.differences-table td {
  padding: 0.75rem;
  text-align: left;
  border-bottom: 1px solid #e1e4e8;
}

.differences-table thead {
  background: #f6f8fa;
}

.differences-table code {
  background: #f6f8fa;
  padding: 0.2rem 0.4rem;
  border-radius: 3px;
  font-size: 0.875rem;
}

.update-process {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 1px solid #e1e4e8;
  border-radius: 12px;
  padding: 1.5rem;
  margin: 1rem 0;
}

.update-step {
  margin-bottom: 1.5rem;
}

.update-step:last-child {
  margin-bottom: 0;
}

.update-step h4 {
  margin-top: 0;
  color: #24292e;
}

.update-step pre {
  background: #f6f8fa;
  padding: 1rem;
  border-radius: 6px;
  margin: 0.5rem 0;
}

.update-step ol {
  margin: 0.5rem 0;
}

.update-step .note {
  font-style: italic;
  color: #586069;
  font-size: 0.875rem;
}

.install-note {
  background: #e7f3ff;
  border-left: 4px solid #0969da;
  padding: 1rem;
  margin: 1rem 0;
  border-radius: 4px;
}

.troubleshooting-box {
  background: #fff3cd;
  border: 2px solid #ffc107;
  border-radius: 8px;
  padding: 1.5rem;
  text-align: center;
}

.troubleshooting-box a {
  color: #856404;
  font-weight: 600;
  text-decoration: underline;
}

.troubleshooting-box a:hover {
  text-decoration: none;
}

.next-steps {
  background: linear-gradient(135deg, #EE0000 0%, #CC0000 100%);
  color: white;
  padding: 2rem;
  border-radius: 12px;
  margin: 2rem 0;
}

.next-steps h3 {
  margin-top: 0;
  color: white;
}

.next-steps a {
  color: white;
  text-decoration: underline;
}

.next-steps a:hover {
  text-decoration: none;
}

details {
  background: #f6f8fa;
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 1rem;
  margin: 1rem 0;
}

summary {
  cursor: pointer;
  font-weight: 600;
  color: #24292e;
}

summary:hover {
  color: #EE0000;
}

details[open] {
  padding-bottom: 1rem;
}

details[open] summary {
  margin-bottom: 1rem;
  padding-bottom: 0.5rem;
  border-bottom: 1px solid #e1e4e8;
}
</style>
