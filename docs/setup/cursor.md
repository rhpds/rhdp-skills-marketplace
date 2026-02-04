---
layout: default
title: Cursor Setup
---

# Cursor Setup

<div class="setup-badge" style="background: #e7f3ff; color: #0969da;">⚡ Cursor 2.4+ Workaround</div>

Cursor 2.4+ supports the [Agent Skills open standard](https://agentskills.io) but **does not support Claude Code plugin marketplace**. This installation uses a direct install script as a workaround.

<div class="platform-info">
  <div class="info-card">
    <h3>✅ Works With</h3>
    <ul>
      <li>Cursor 2.4.0 or later</li>
      <li>Agent Skills support</li>
    </ul>
  </div>
  <div class="info-card">
    <h3>📦 What You Get</h3>
    <ul>
      <li>One-command installation</li>
      <li>All 7 skills bundled</li>
      <li>Templates & docs included</li>
    </ul>
  </div>
</div>

<div class="install-note" style="background: #fff3cd; border-left: 4px solid #ffc107;">
💡 <strong>Want automatic updates?</strong> For full plugin marketplace support with automatic updates, use <a href="claude-code.html">Claude Code</a> instead.
</div>

---

## ✓ Prerequisites

<div class="prereq-box">
  <h4>Check Your Cursor Version</h4>
  <ol>
    <li>Open Cursor</li>
    <li>Click <strong>Cursor</strong> menu → <strong>About Cursor</strong></li>
    <li>Version should be <strong>2.4.0</strong> or higher</li>
  </ol>
  <p style="margin-top: 1rem; color: #856404;">⚠️ If you're on an older version, update Cursor first.</p>
</div>

---

## 📦 Installation

### One-Command Install

<div class="install-note" style="background: #d4edda; border-left: 4px solid #28a745;">
💻 <strong>Run this in your TERMINAL</strong> (not in Cursor chat):
</div>

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install-cursor.sh | bash
```

<div class="install-process">
  <h4>This script will automatically:</h4>
  <ul class="checklist">
    <li>✅ Install all 7 skills to <code>~/.cursor/skills/</code></li>
    <li>✅ Install documentation to <code>~/.cursor/docs/</code></li>
    <li>✅ Bundle prompts and templates with each skill</li>
    <li>✅ Everything configured in one step</li>
  </ul>
</div>

### Verify Installation

After the script completes:

```bash
ls ~/.cursor/skills/
```

<div class="success-box">
✅ <strong>You should see these 7 skills:</strong>
<ul style="margin-top: 0.5rem; margin-bottom: 0;">
<li>showroom-create-lab</li>
<li>showroom-create-demo</li>
<li>showroom-blog-generate</li>
<li>showroom-verify-content</li>
<li>agnosticv-catalog-builder</li>
<li>agnosticv-validator</li>
<li>health-deployment-validator</li>
</ul>
</div>

<div class="install-note">
🔄 <strong>Important:</strong> Restart Cursor after installation to load the new skills.
</div>

---

## 🎯 How to Use Skills

### Method 1: Explicit Invocation

Type skill names directly in Cursor Agent chat:

<div class="skills-usage">
  <div class="usage-category">
    <h4>📝 Showroom Skills</h4>
    <code>/showroom-create-lab</code><br>
    <code>/showroom-create-demo</code><br>
    <code>/showroom-blog-generate</code><br>
    <code>/showroom-verify-content</code>
  </div>
  <div class="usage-category">
    <h4>⚙️ AgnosticV Skills</h4>
    <code>/agnosticv-catalog-builder</code><br>
    <code>/agnosticv-validator</code>
  </div>
  <div class="usage-category">
    <h4>🏥 Health Skills</h4>
    <code>/health-deployment-validator</code>
  </div>
</div>

<div class="install-note">
ℹ️ <strong>Note:</strong> Cursor skill names use <strong>hyphens</strong> (not colons) due to platform naming restrictions.
</div>

### Method 2: Natural Language

The agent will automatically apply relevant skills based on your request:

<div class="examples-box">
  <h4>Example Prompts</h4>
  <ul>
    <li><em>"Help me create a workshop lab module"</em></li>
    <li><em>"Generate demo content for my presentation"</em></li>
    <li><em>"Create an AgnosticV catalog configuration"</em></li>
    <li><em>"Verify my workshop content quality"</em></li>
  </ul>
</div>

---

## ✓ Verification

After installation and restart, verify skills are loaded:

1. Open Cursor Agent chat (Cmd+L or Ctrl+L)
2. Type `/` to see available skills
3. You should see RHDP skills listed

---

## ⚠️ Using Both Claude Code and Cursor?

<div class="warning-box">
  <h4>Duplicate Skills Warning</h4>
  <p>If you have <strong>both</strong> Claude Code and Cursor installed, you may see duplicate skills with different names:</p>

  <table style="width: 100%; margin: 1rem 0; border-collapse: collapse;">
    <thead>
      <tr style="background: #f6f8fa; border-bottom: 2px solid #e1e4e8;">
        <th style="padding: 0.5rem; text-align: left;">Platform</th>
        <th style="padding: 0.5rem; text-align: left;">Skill Names</th>
        <th style="padding: 0.5rem; text-align: left;">Example</th>
      </tr>
    </thead>
    <tbody>
      <tr style="border-bottom: 1px solid #e1e4e8;">
        <td style="padding: 0.5rem;">Claude Code (plugin)</td>
        <td style="padding: 0.5rem;">With colons</td>
        <td style="padding: 0.5rem;"><code>/showroom:create-lab</code></td>
      </tr>
      <tr>
        <td style="padding: 0.5rem;">Cursor (script)</td>
        <td style="padding: 0.5rem;">With hyphens</td>
        <td style="padding: 0.5rem;"><code>/showroom-create-lab</code></td>
      </tr>
    </tbody>
  </table>

  <p><strong>Both skills are identical</strong> - they just have different names due to platform naming requirements.</p>
</div>

<div class="recommendation-box">
  <h4>💡 Recommendation</h4>
  <p>Choose one installation method:</p>
  <ul>
    <li><strong>Claude Code users:</strong> Use the plugin marketplace (automatic updates, full integration)</li>
    <li><strong>Cursor-only users:</strong> Use this install script</li>
    <li><strong>Both platforms:</strong> Use Claude Code plugin, skip this script for Cursor</li>
  </ul>
</div>

---

## 🔄 Updating Skills

<div class="install-note" style="background: #d4edda; border-left: 4px solid #28a745;">
💻 <strong>Run this in your TERMINAL</strong> (not in Cursor chat):
</div>

**To update to the latest version:**

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/update-cursor.sh | bash
```

<div class="install-process">
  <h4>The update script will:</h4>
  <ul class="checklist">
    <li>✅ Check for new versions</li>
    <li>✅ Show changelog</li>
    <li>✅ Backup current installation</li>
    <li>✅ Install latest version</li>
  </ul>
</div>

<div class="install-note" style="background: #fff3cd; border-left: 4px solid #ffc107;">
⚠️ <strong>Manual Updates Required:</strong> Unlike Claude Code plugin marketplace, Cursor updates are manual. Claude Code users get automatic update notifications.
</div>

---

## 🆘 Troubleshooting

<details>
<summary><strong>Skills not showing after installation</strong></summary>

<h4>Most common issue: Symlinks instead of actual files</h4>

<p>Fix:</p>
<pre><code># Verify you have actual files (not symlinks)
file ~/.cursor/skills/showroom-create-lab/SKILL.md

# If it says "symbolic link", copy actual files:
cp -r ~/.agents/skills/* ~/.cursor/skills/

# Restart Cursor
</code></pre>

<h4>Other checks:</h4>
<ol>
<li><strong>Restart Cursor completely</strong> (Cmd+Q / Ctrl+Q, then reopen)</li>
<li>Verify installation: <code>ls ~/.cursor/skills/</code></li>
<li>Check Cursor version is 2.4.0+</li>
</ol>

</details>

<details>
<summary><strong>Skills show but don't work properly</strong></summary>

<p>Missing support files (templates, prompts, docs):</p>

<pre><code># Copy .claude/ directory to your project
cd ~/your-project
git clone https://github.com/rhpds/rhdp-skills-marketplace.git /tmp/rhdp-marketplace
mkdir -p .claude
cp -r /tmp/rhdp-marketplace/showroom/.claude/* .claude/
rm -rf /tmp/rhdp-marketplace
</code></pre>

</details>

<details>
<summary><strong>Permission denied errors</strong></summary>

<p>Make sure you have write permissions:</p>

<pre><code>ls -la ~/.cursor/
chmod 755 ~/.cursor/skills
</code></pre>

</details>

---

<div class="next-steps">
  <h3>📚 Next Steps</h3>
  <ul>
    <li><a href="../skills/create-lab.html">Learn about /create-lab skill →</a></li>
    <li><a href="../reference/quick-reference.html">View all skills reference →</a></li>
    <li><a href="../contributing/create-your-own-skill.html">Create your own skill →</a></li>
  </ul>
</div>

<div class="resources-box">
  <h3>🔗 Additional Resources</h3>
  <ul>
    <li><a href="https://github.com/vercel-labs/skills" target="_blank">Vercel Skills CLI</a></li>
    <li><a href="https://agentskills.io" target="_blank">Agent Skills Standard</a></li>
    <li><a href="https://rhpds.github.io/rhdp-skills-marketplace" target="_blank">RHDP Skills Documentation</a></li>
  </ul>
</div>

<style>
.setup-badge {
  display: inline-block;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  font-weight: 600;
  margin: 1rem 0;
}

.platform-info {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.info-card {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 1px solid #e1e4e8;
  border-radius: 12px;
  padding: 1.5rem;
}

.info-card h3 {
  margin-top: 0;
  margin-bottom: 1rem;
  color: #24292e;
}

.info-card ul {
  margin: 0;
  padding-left: 1.25rem;
}

.install-note {
  background: #e7f3ff;
  border-left: 4px solid #0969da;
  padding: 1rem;
  margin: 1rem 0;
  border-radius: 4px;
}

.install-note code {
  background: white;
  padding: 0.2rem 0.4rem;
  border-radius: 3px;
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

.install-process {
  background: #f6f8fa;
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
  margin: 1rem 0;
}

.install-process h4 {
  margin-top: 0;
  color: #24292e;
}

.checklist {
  list-style: none;
  padding-left: 0;
}

.checklist li {
  padding: 0.25rem 0;
}

.success-box {
  background: #d4edda;
  border-left: 4px solid #28a745;
  padding: 1rem;
  margin: 1rem 0;
  border-radius: 4px;
  color: #155724;
}

.success-box ul {
  margin-left: 1.5rem;
}

.skills-usage {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1rem;
  margin: 1.5rem 0;
}

.usage-category {
  background: #f6f8fa;
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 1rem;
}

.usage-category h4 {
  margin-top: 0;
  margin-bottom: 0.75rem;
  color: #24292e;
}

.usage-category code {
  display: block;
  background: white;
  padding: 0.4rem 0.6rem;
  margin: 0.25rem 0;
  border-radius: 4px;
  font-size: 0.875rem;
  color: #EE0000;
}

.examples-box {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
  margin: 1rem 0;
}

.examples-box h4 {
  margin-top: 0;
  color: #24292e;
}

.examples-box ul {
  margin-bottom: 0;
}

.examples-box em {
  color: #586069;
}

.warning-box {
  background: #fff3cd;
  border: 2px solid #ffc107;
  border-radius: 12px;
  padding: 1.5rem;
  margin: 1rem 0;
}

.warning-box h4 {
  margin-top: 0;
  color: #856404;
}

.recommendation-box {
  background: linear-gradient(135deg, #EE0000 0%, #CC0000 100%);
  color: white;
  border-radius: 12px;
  padding: 1.5rem;
  margin: 1rem 0;
}

.recommendation-box h4 {
  margin-top: 0;
  color: white;
}

.recommendation-box strong {
  color: white;
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

.resources-box {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 1px solid #e1e4e8;
  border-radius: 12px;
  padding: 1.5rem;
  margin: 1rem 0;
}

.resources-box h3 {
  margin-top: 0;
  color: #24292e;
}

.resources-box a {
  color: #0969da;
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
