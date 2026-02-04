---
layout: default
title: Cursor Migration Guide
---

# Cursor Migration Guide

<div class="migration-badge" style="background: #0969da; color: white;">🔄 cursor-commands → install script</div>

Migrating from old cursor-commands/cursor-rules to the new install script.

---

## 🎯 What Changed?

<div class="comparison-grid">
  <div class="comparison-card old-way">
    <h3>❌ Old Approach (Deprecated)</h3>
    <ul class="feature-list">
      <li>✗ Manual file copying to <code>~/.cursor/skills/</code></li>
      <li>✗ Separate <code>cursor-commands/</code> and <code>cursor-rules/</code> directories</li>
      <li>✗ Manual updates required</li>
      <li>✗ No version management</li>
    </ul>
  </div>

  <div class="comparison-card new-way">
    <h3>✅ New Approach (Recommended)</h3>
    <ul class="feature-list">
      <li>✓ One-command installation</li>
      <li>✓ Bundled dependencies</li>
      <li>✓ Automatic installation script</li>
      <li>✓ Easy updates with update script</li>
    </ul>
  </div>
</div>

---

## 🚀 Migration Steps

<div class="migration-steps">
  <div class="step-card">
    <div class="step-number">1</div>
    <div class="step-content">
      <h3>🗑️ Remove Old Installation</h3>
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
    </div>
  </div>

  <div class="step-card">
    <div class="step-number">2</div>
    <div class="step-content">
      <h3>⬇️ Install via Install Script</h3>
      <p>Run the one-command install script:</p>
      <pre><code>curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install-cursor.sh | bash</code></pre>
      <div class="install-note" style="margin-top: 1rem;">
        ℹ️ This installs all 7 skills to <code>~/.cursor/skills/</code> with bundled dependencies
      </div>
    </div>
  </div>

  <div class="step-card">
    <div class="step-number">3</div>
    <div class="step-content">
      <h3>🔄 Restart Cursor</h3>
      <p>Completely quit and reopen Cursor to load the new skills.</p>
    </div>
  </div>

  <div class="step-card">
    <div class="step-number">4</div>
    <div class="step-content">
      <h3>✓ Verify Installation</h3>
      <p>Check that skills are loaded:</p>
      <ol style="margin: 0.5rem 0;">
        <li>Open Cursor Agent chat (Cmd+L or Ctrl+L)</li>
        <li>Type <code>/</code> to see available skills</li>
        <li>You should see RHDP skills listed</li>
      </ol>
      <div class="success-box" style="margin-top: 1rem;">
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
      </div>
    </div>
  </div>
</div>

---

## 📋 Skill Name Changes

<div class="info-box">
Skills now use hyphens instead of colons (Cursor naming requirement):
</div>

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

<div class="install-note">
ℹ️ <strong>Note:</strong> Hyphens (not colons) are used due to Cursor platform naming restrictions.
</div>

---

## ⚙️ Configuration Files

<div class="config-box">
  <h4>✅ No Changes Required</h4>
  <p>Your existing configuration files (e.g., <code>~/CLAUDE.md</code>) work without changes:</p>
  <pre><code># AgnosticV Configuration
agnosticv: ~/devel/git/agnosticv
base_path: ~/work/code</code></pre>
  <p style="margin-bottom: 0;">Skills will automatically detect these paths.</p>
</div>

---

## ✨ Benefits of Migration

<div class="benefits-grid">
  <div class="benefit-card">
    <div class="benefit-icon">📦</div>
    <h4>One-Command Install</h4>
    <p>Single script installs everything</p>
  </div>
  <div class="benefit-card">
    <div class="benefit-icon">🔄</div>
    <h4>Easy Updates</h4>
    <p>Run update script to get latest versions</p>
  </div>
  <div class="benefit-card">
    <div class="benefit-icon">📚</div>
    <h4>Bundled Dependencies</h4>
    <p>All prompts and templates included</p>
  </div>
  <div class="benefit-card">
    <div class="benefit-icon">✓</div>
    <h4>Better Reliability</h4>
    <p>Actual files (not symlinks)</p>
  </div>
</div>

---

## 🆘 Troubleshooting

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

## 🔄 Updating Skills

<div class="update-box">
  <h4>Run the Update Script</h4>
  <pre><code>curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/update-cursor.sh | bash</code></pre>
  <p>The script will:</p>
  <ul>
    <li>Check for new versions</li>
    <li>Show changelog</li>
    <li>Backup current installation</li>
    <li>Install latest version</li>
  </ul>
</div>

---

## ↩️ Rollback (If Needed)

<details>
<summary><strong>Click to see rollback instructions</strong></summary>

<p>If you need to rollback to old approach:</p>

<pre><code># Remove current installation
rm -rf ~/.cursor/skills/showroom-*
rm -rf ~/.cursor/skills/agnosticv-*
rm -rf ~/.cursor/skills/health-*

# Note: Old cursor-commands/cursor-rules are deprecated
# Contact #forum-demo-developers for help if needed</code></pre>

<div class="install-note" style="background: #fff3cd; border-color: #ffc107; margin-top: 1rem;">
⚠️ <strong>Warning:</strong> Old cursor-commands/cursor-rules are deprecated and no longer maintained.
</div>

</details>

---

<div class="next-steps">
  <h3>📚 Next Steps</h3>
  <ul>
    <li><a href="cursor.html">Cursor Setup Guide →</a></li>
    <li><a href="../reference/quick-reference.html">Quick Reference →</a></li>
    <li><a href="../reference/troubleshooting.html">Troubleshooting →</a></li>
  </ul>
</div>

<div class="timeline-box">
  <h3>⏱️ Migration Timeline</h3>
  <ul>
    <li><strong>v2.3.x and earlier:</strong> cursor-commands/cursor-rules approach</li>
    <li><strong>v2.4.0+:</strong> Install script approach (current)</li>
    <li><strong>Future:</strong> Old approach will be completely removed</li>
  </ul>
  <p style="margin-top: 1rem; margin-bottom: 0;"><strong>Migrate now to stay up-to-date!</strong></p>
</div>

<style>
.migration-badge {
  display: inline-block;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  font-weight: 600;
  margin: 1rem 0;
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
  background: linear-gradient(135deg, #0969da 0%, #0550ae 100%);
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

.install-note {
  background: #e7f3ff;
  border-left: 4px solid #0969da;
  padding: 1rem;
  margin: 1rem 0;
  border-radius: 4px;
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
  color: #0969da;
}

.config-box {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #28a745;
  border-radius: 12px;
  padding: 1.5rem;
  margin: 1rem 0;
}

.config-box h4 {
  margin-top: 0;
  color: #155724;
}

.config-box pre {
  background: #f6f8fa;
  padding: 1rem;
  border-radius: 6px;
  margin: 1rem 0;
}

.benefits-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin: 1.5rem 0;
}

.benefit-card {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
  text-align: center;
}

.benefit-icon {
  font-size: 2rem;
  margin-bottom: 0.5rem;
}

.benefit-card h4 {
  margin: 0.5rem 0;
  color: #24292e;
  font-size: 1rem;
}

.benefit-card p {
  margin: 0;
  color: #586069;
  font-size: 0.875rem;
}

.update-box {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #0969da;
  border-radius: 12px;
  padding: 1.5rem;
  margin: 1rem 0;
}

.update-box h4 {
  margin-top: 0;
  color: #24292e;
}

.update-box pre {
  background: #f6f8fa;
  padding: 1rem;
  border-radius: 6px;
  margin: 1rem 0;
}

.update-box ul {
  margin-bottom: 0;
}

.next-steps {
  background: linear-gradient(135deg, #0969da 0%, #0550ae 100%);
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

.timeline-box {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 1px solid #e1e4e8;
  border-radius: 12px;
  padding: 1.5rem;
  margin: 1rem 0;
}

.timeline-box h3 {
  margin-top: 0;
  color: #24292e;
}

.timeline-box ul {
  margin: 0.5rem 0;
}

.timeline-box strong {
  color: #EE0000;
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
  color: #0969da;
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
