---
layout: default
title: Cursor Migration Guide
---

# Cursor Migration Guide

<div class="reference-badge">cursor-commands → install script</div>

Migrating from old cursor-commands/cursor-rules to the new install script.

---

## What Changed?

<div class="vs-grid"><div class="vs-card vs-card-skill"><span class="vs-label">Old Way</span>
    <h3>Old Approach (Deprecated)</h3>
    <ul class="feature-list">
      <li>✗ Manual file copying to <code>~/.cursor/skills/</code></li>
      <li>✗ Separate <code>cursor-commands/</code> and <code>cursor-rules/</code> directories</li>
      <li>✗ Manual updates required</li>
      <li>✗ No version management</li>
    </ul>
  </div><div class="vs-card vs-card-agent"><span class="vs-label">New Way</span>
    <h3>New Approach (Recommended)</h3>
    <ul class="feature-list">
      <li>✓ One-command installation</li>
      <li>✓ Bundled dependencies</li>
      <li>✓ Automatic installation script</li>
      <li>✓ Easy updates with update script</li>
    </ul>
  </div></div>

---

## Migration Steps

<ol class="steps">
  <li><div class="step-content">
    <h4>Remove Old Installation</h4>
    <p>Clean up old cursor-commands and cursor-rules:</p>
    <pre><code># Remove old cursor-commands skills
rm -rf ~/.cursor/skills/create-lab
rm -rf ~/.cursor/skills/create-demo
rm -rf ~/.cursor/skills/agv-generator
rm -rf ~/.cursor/skills/verify-content
rm -rf ~/.cursor/skills/blog-generate

# Remove old cursor-rules
rm -rf ~/.cursor/rules/agnosticv-catalog-builder
rm -rf ~/.cursor/rules/agnosticv-validator
rm -rf ~/.cursor/rules/showroom-standards
rm -rf ~/.cursor/rules/deployment-health-checker

# Remove old docs
rm -rf ~/.cursor/docs/SKILL-COMMON-RULES.md
rm -rf ~/.cursor/docs/AGV-COMMON-RULES.md</code></pre>
  </div></li>

  <li><div class="step-content">
    <h4>Install via Install Script</h4>
    <p>Run the one-command install script:</p>
    <pre><code>curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install-cursor.sh | bash</code></pre>
    <div class="callout callout-info" style="margin-top: 1rem;"><span class="callout-icon">ℹ️</span><div class="callout-body">
      This installs all 7 skills to <code>~/.cursor/skills/</code> with bundled dependencies
    </div></div>
  </div></li>

  <li><div class="step-content">
    <h4>Restart Cursor</h4>
    <p>Completely quit and reopen Cursor to load the new skills.</p>
  </div></li>

  <li><div class="step-content">
    <h4>Verify Installation</h4>
    <p>Check that skills are loaded:</p>
    <ol style="margin: 0.5rem 0;">
      <li>Open Cursor Agent chat (Cmd+L or Ctrl+L)</li>
      <li>Type <code>/</code> to see available skills</li>
      <li>You should see RHDP skills listed</li>
    </ol>
    <div class="callout callout-tip" style="margin-top: 1rem;"><span class="callout-icon">✅</span><div class="callout-body">
      <strong>You should see:</strong>
      <ul style="margin-top: 0.5rem;">
        <li><code>/showroom-create-lab</code></li>
        <li><code>/showroom-create-demo</code></li>
        <li><code>/showroom-blog-generate</code></li>
        <li><code>/showroom-verify-content</code></li>
        <li><code>/agnosticv-catalog-builder</code></li>
        <li><code>/agnosticv-validator</code></li>
        <li><code>/health-deployment-validator</code></li>
      </ul>
    </div></div>
  </div></li>
</ol>

---

## Skill Name Changes

<div class="callout callout-info"><span class="callout-icon">ℹ️</span><div class="callout-body">
Skills now use hyphens instead of colons (Cursor naming requirement):
</div></div>

<table class="changes-table">
  <thead>
    <tr>
      <th>Old Name (cursor-commands)</th>
      <th>New Name (install script)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>/create-lab</code></td>
      <td><code>/showroom-create-lab</code></td>
    </tr>
    <tr>
      <td><code>/create-demo</code></td>
      <td><code>/showroom-create-demo</code></td>
    </tr>
    <tr>
      <td><code>/agv-generator</code></td>
      <td><code>/agnosticv-catalog-builder</code></td>
    </tr>
    <tr>
      <td><code>/verify-content</code></td>
      <td><code>/showroom-verify-content</code></td>
    </tr>
    <tr>
      <td><code>/blog-generate</code></td>
      <td><code>/showroom-blog-generate</code></td>
    </tr>
    <tr>
      <td><code>/agnosticv-validator</code></td>
      <td><code>/agnosticv-validator</code></td>
    </tr>
    <tr>
      <td><code>/deployment-health-checker</code></td>
      <td><code>/health-deployment-validator</code></td>
    </tr>
  </tbody>
</table>

<div class="callout callout-info"><span class="callout-icon">ℹ️</span><div class="callout-body">
<strong>Note:</strong> Hyphens (not colons) are used due to Cursor platform naming restrictions.
</div></div>

---

## Configuration Files

<div class="callout callout-tip"><span class="callout-icon">✅</span><div class="callout-body">
  <h4>No Changes Required</h4>
  <p>Your existing configuration files (e.g., <code>~/CLAUDE.md</code>) work without changes:</p>
  <pre><code># AgnosticV Configuration
agnosticv: ~/devel/git/agnosticv
base_path: ~/work/code</code></pre>
  <p style="margin-bottom: 0;">Skills will automatically detect these paths.</p>
</div></div>

---

## Benefits of Migration

<div class="category-grid">
  <div class="category-card">
    <div class="benefit-icon">📦</div>
    <h4>One-Command Install</h4>
    <p>Single script installs everything</p>
  </div>
  <div class="category-card">
    <div class="benefit-icon">🔄</div>
    <h4>Easy Updates</h4>
    <p>Run update script to get latest versions</p>
  </div>
  <div class="category-card">
    <div class="benefit-icon">📚</div>
    <h4>Bundled Dependencies</h4>
    <p>All prompts and templates included</p>
  </div>
  <div class="category-card">
    <div class="benefit-icon">✓</div>
    <h4>Better Reliability</h4>
    <p>Actual files (not symlinks)</p>
  </div>
</div>

---

## Troubleshooting

<details>
<summary><strong>Skills not showing after installation</strong></summary>

<ol>
  <li><strong>Restart Cursor completely</strong> (quit and reopen, not just reload)</li>
  <li>Check installation: <code>ls ~/.cursor/skills/</code></li>
  <li>Verify Cursor version is 2.4.0+</li>
</ol>

</details>

<details>
<summary><strong>Old skills still showing</strong></summary>

<p>Remove old installations:</p>

<pre><code># List all skills in ~/.cursor/skills/
ls -la ~/.cursor/skills/

# Remove specific old skills
rm -rf ~/.cursor/skills/old-skill-name</code></pre>

<p>Restart Cursor.</p>

</details>

<details>
<summary><strong>Permission denied errors</strong></summary>

<p>Make sure you have write permissions:</p>

<pre><code>ls -la ~/.cursor/
mkdir -p ~/.cursor/skills  # Create if doesn't exist
chmod 755 ~/.cursor/skills</code></pre>

</details>

<details>
<summary><strong>Skill names don't work with hyphens</strong></summary>

<p>Old cursor-commands used slashes. The new format uses hyphens:</p>

<pre><code>/showroom-create-lab         (not /create-lab)
/agnosticv-catalog-builder   (not /agv-generator)</code></pre>

<p>This is a Cursor platform naming requirement.</p>

</details>

---

## Updating Skills

<div class="callout callout-info"><span class="callout-icon">ℹ️</span><div class="callout-body">
  <h4>Run the Update Script</h4>
  <pre><code>curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/update-cursor.sh | bash</code></pre>
  <p>The script will:</p>
  <ul>
    <li>Check for new versions</li>
    <li>Show changelog</li>
    <li>Backup current installation</li>
    <li>Install latest version</li>
  </ul>
</div></div>

---

## Rollback (If Needed)

<details>
<summary><strong>Click to see rollback instructions</strong></summary>

<p>If you need to rollback to old approach:</p>

<pre><code># Remove current installation
rm -rf ~/.cursor/skills/showroom-*
rm -rf ~/.cursor/skills/agnosticv-*
rm -rf ~/.cursor/skills/health-*

# Note: Old cursor-commands/cursor-rules are deprecated
# Contact #forum-demo-developers for help if needed</code></pre>

<div class="callout callout-warning" style="margin-top: 1rem;"><span class="callout-icon">⚠️</span><div class="callout-body">
<strong>Warning:</strong> Old cursor-commands/cursor-rules are deprecated and no longer maintained.
</div></div>

</details>

---

<div class="links-grid">
  <a href="cursor.html" class="link-card"><h4>Cursor Setup Guide</h4><p>Full setup guide for Cursor</p></a>
  <a href="../reference/quick-reference.html" class="link-card"><h4>Quick Reference</h4><p>Commands at a glance</p></a>
  <a href="../reference/troubleshooting.html" class="link-card"><h4>Troubleshooting</h4><p>Common issues and solutions</p></a>
</div>

<div class="callout callout-info"><span class="callout-icon">ℹ️</span><div class="callout-body">
  <h3>Migration Timeline</h3>
  <ul>
    <li><strong>v2.3.x and earlier:</strong> cursor-commands/cursor-rules approach</li>
    <li><strong>v2.4.0+:</strong> Install script approach (current)</li>
    <li><strong>Future:</strong> Old approach will be completely removed</li>
  </ul>
  <p style="margin-top: 1rem; margin-bottom: 0;"><strong>Migrate now to stay up-to-date!</strong></p>
</div></div>
