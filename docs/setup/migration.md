---
layout: default
title: Claude Code Migration Guide
---

# Claude Code Migration Guide

<div class="reference-badge">install.sh → Plugin Marketplace</div>

This guide helps you migrate from the old `install.sh` script to the new plugin-based marketplace system.

---

## Why Migrate?

<div class="vs-grid"><div class="vs-card vs-card-skill"><span class="vs-label">Old Way</span>
    <h3>Old Way (File-Based)</h3>
    <pre><code>curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | bash</code></pre>
    <ul class="feature-list">
      <li>✗ Manual updates required</li>
      <li>✗ No version management</li>
      <li>✗ Hard to share with team</li>
      <li>✗ Skills in <code>~/.claude/skills/</code></li>
    </ul>
  </div><div class="vs-card vs-card-agent"><span class="vs-label">New Way</span>
    <h3>New Way (Plugin-Based)</h3>
    <pre><code>/plugin marketplace add rhpds/rhdp-skills-marketplace
/plugin install showroom@rhdp-marketplace</code></pre>
    <ul class="feature-list">
      <li>✓ Automatic update notifications</li>
      <li>✓ Version management and rollback</li>
      <li>✓ Easy team distribution</li>
      <li>✓ Standard package management</li>
    </ul>
  </div></div>

---

## Prerequisites

<div class="callout callout-info"><span class="callout-icon">ℹ️</span><div class="callout-body">
  <h4>Before migrating, ensure you have Claude Code installed:</h4>
  <ol>
    <li>If you don't have Claude Code yet, install it from <a href="https://claude.com/claude-code" target="_blank">https://claude.com/claude-code</a></li>
    <li>Verify installation: <code>claude --version</code> in your terminal</li>
  </ol>
  <p style="margin-top: 1rem;"><strong>VS Code users:</strong> Install the Claude extension from the VS Code marketplace instead.</p>
</div></div>

---

## Migration Steps

<ol class="steps">
  <li><div class="step-content">
    <h4>Backup Your Installation</h4>
    <p>In your terminal, back up any customized skills:</p>
    <pre><code>cp -r ~/.claude/skills ~/.claude/skills-backup
cp -r ~/.claude/docs ~/.claude/docs-backup</code></pre>
  </div></li>

  <li><div class="step-content">
    <h4>Remove Old Installation</h4>
    <p>In your terminal, clean up the old file-based installation:</p>
    <pre><code>rm -rf ~/.claude/skills/create-lab
rm -rf ~/.claude/skills/create-demo
rm -rf ~/.claude/skills/blog-generate
rm -rf ~/.claude/skills/verify-content
rm -rf ~/.claude/skills/agnosticv-catalog-builder
rm -rf ~/.claude/skills/agnosticv-validator
rm -rf ~/.claude/skills/deployment-health-checker
rm -rf ~/.claude/docs</code></pre>
  </div></li>

  <li><div class="step-content">
    <h4>Start Claude Code</h4>
    <p>In your terminal, start Claude Code:</p>
    <pre><code>claude</code></pre>
    <p style="margin-top: 0.5rem; color: #586069; font-size: 0.875rem;">This opens the Claude Code interactive chat where you'll run the next commands.</p>
  </div></li>

  <li><div class="step-content">
    <h4>Add Marketplace</h4>
    <p><strong>In Claude Code chat (NOT in terminal)</strong>, add the RHDP marketplace:</p>
    <pre><code># If you have SSH keys configured
/plugin marketplace add rhpds/rhdp-skills-marketplace

# If you don't have SSH configured
/plugin marketplace add https://github.com/rhpds/rhdp-skills-marketplace</code></pre>
  </div></li>

  <li><div class="step-content">
    <h4>Install Plugins</h4>
    <p><strong>In Claude Code chat</strong>, install the plugins you need:</p>
    <pre><code># For workshop/demo creation (most users)
/plugin install showroom@rhdp-marketplace

# For AgnosticV catalogs (RHDP internal)
/plugin install agnosticv@rhdp-marketplace

# For deployment health checks (RHDP internal)
/plugin install health@rhdp-marketplace
/plugin install ftl@rhdp-marketplace
/plugin install ftl@rhdp-marketplace</code></pre>
  </div></li>

  <li><div class="step-content">
    <h4>Restart Claude Code</h4>
    <p>Exit Claude Code completely and restart it to load the new plugins.</p>
  </div></li>

  <li><div class="step-content">
    <h4>Verify Installation</h4>
    <p><strong>In Claude Code chat</strong>, check that skills are available:</p>
    <pre><code>/skills</code></pre>
    <div class="callout callout-tip" style="margin-top: 1rem;"><span class="callout-icon">✅</span><div class="callout-body">
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
    </div></div>
  </div></li>
</ol>

---

## What Changed?

### Skill Names

<div class="callout callout-info"><span class="callout-icon">ℹ️</span><div class="callout-body">
Skills now include namespace prefixes to show which plugin provides them:
</div></div>

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

## Updating Plugins

<div class="callout callout-info"><span class="callout-icon">ℹ️</span><div class="callout-body">
  <div class="update-step">
    <h4>Step 1: Update Marketplace</h4>
    <pre><code>/plugin marketplace update</code></pre>
    <p>This opens an interactive UI:</p>
    <ol>
      <li>Select the marketplace</li>
      <li>Press <code>u</code> to update it</li>
      <li>Press <code>Esc</code> to go back</li>
    </ol>
    <p class="text-muted">This refreshes the marketplace cache with the latest plugin versions.</p>
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
</div></div>

<div class="callout callout-info"><span class="callout-icon">ℹ️</span><div class="callout-body">
<strong>Note:</strong> Both commands are interactive - you must use the UI to perform updates. After updating, <strong>restart Claude Code</strong> to load the new versions.
</div></div>

---

## Troubleshooting

<div class="callout callout-warning"><span class="callout-icon">⚠️</span><div class="callout-body">
  <p>See the <a href="../reference/troubleshooting.html#migration-issues">Troubleshooting Guide</a> for common migration issues.</p>
</div></div>

---

## Rollback (If Needed)

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

<div class="links-grid">
  <a href="claude-code.html" class="link-card"><h4>Claude Code Setup Guide</h4><p>Full setup guide for Claude Code</p></a>
  <a href="../reference/troubleshooting.html" class="link-card"><h4>Troubleshooting</h4><p>Common issues and solutions</p></a>
  <a href="../reference/quick-reference.html" class="link-card"><h4>Quick Reference</h4><p>Commands at a glance</p></a>
</div>
