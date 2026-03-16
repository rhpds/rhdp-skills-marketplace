---
layout: default
title: Cursor Setup
---

# Cursor Setup

<div class="reference-badge">Experimental</div>

<div class="callout callout-warning"><span class="callout-icon">⚠️</span><div class="callout-body">
  <strong>Experimental support.</strong> Cursor does not have a native plugin marketplace, so skills are installed manually via a script. Updates require re-running the install. For the best experience with automatic updates and full skill support, use <a href="claude-code.html"><strong>Claude Code</strong></a> — the primary supported platform.
</div></div>

Cursor 2.4+ supports the [Agent Skills open standard](https://agentskills.io) but **does not support Claude Code plugin marketplace**. This installation uses a direct install script as a workaround. All Showroom skill content (templates, prompts, docs) is the same as the Claude Code version.

<div class="category-grid">
  <div class="category-card">
    <h3>Works With</h3>
    <ul>
      <li>Cursor 2.4.0 or later</li>
      <li>Agent Skills support</li>
    </ul>
  </div>
  <div class="category-card">
    <h3>What You Get</h3>
    <ul>
      <li>One-command installation</li>
      <li>All 8 skills bundled</li>
      <li>Same templates &amp; docs as Claude Code</li>
    </ul>
  </div>
</div>

---

## Prerequisites

<div class="callout callout-info"><span class="callout-icon">ℹ️</span><div class="callout-body">
  <h4>Check Your Cursor Version</h4>
  <ol>
    <li>Open Cursor</li>
    <li>Click <strong>Cursor</strong> menu → <strong>About Cursor</strong></li>
    <li>Version should be <strong>2.4.0</strong> or higher</li>
  </ol>
  <p style="margin-top: 1rem; color: #856404;">If you're on an older version, update Cursor first.</p>
</div></div>

---

## Installation

### One-Command Install

<div class="callout callout-tip"><span class="callout-icon">✅</span><div class="callout-body">
<strong>Run this in your TERMINAL</strong> (not in Cursor chat):
</div></div>

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install-cursor.sh | bash
```

<div class="callout callout-info"><span class="callout-icon">ℹ️</span><div class="callout-body">
  <h4>This script will automatically:</h4>
  <ul class="checklist">
    <li>Install all 7 skills to <code>~/.cursor/skills/</code></li>
    <li>Install documentation to <code>~/.cursor/docs/</code></li>
    <li>Bundle prompts and templates with each skill</li>
    <li>Everything configured in one step</li>
  </ul>
</div></div>

### Verify Installation

After the script completes:

```bash
ls ~/.cursor/skills/
```

<div class="callout callout-tip"><span class="callout-icon">✅</span><div class="callout-body">
<strong>You should see these 7 skills:</strong>
<ul style="margin-top: 0.5rem; margin-bottom: 0;">
<li>showroom-create-lab</li>
<li>showroom-create-demo</li>
<li>showroom-blog-generate</li>
<li>showroom-verify-content</li>
<li>agnosticv-catalog-builder</li>
<li>agnosticv-validator</li>
<li>health-deployment-validator</li>
</ul>
</div></div>

<div class="callout callout-warning"><span class="callout-icon">⚠️</span><div class="callout-body">
<strong>Important:</strong> Restart Cursor after installation to load the new skills.
</div></div>

---

## How to Use Skills

### Method 1: Explicit Invocation

Type skill names directly in Cursor Agent chat:

<div class="category-grid">
  <div class="category-card">
    <h4>Showroom Skills</h4>
    <code>/showroom-create-lab</code><br>
    <code>/showroom-create-demo</code><br>
    <code>/showroom-blog-generate</code><br>
    <code>/showroom-verify-content</code>
  </div>
  <div class="category-card">
    <h4>AgnosticV Skills</h4>
    <code>/agnosticv-catalog-builder</code><br>
    <code>/agnosticv-validator</code>
  </div>
  <div class="category-card">
    <h4>Health Skills</h4>
    <code>/health-deployment-validator</code>
  </div>
</div>

<div class="callout callout-info"><span class="callout-icon">ℹ️</span><div class="callout-body">
<strong>Note:</strong> Cursor skill names use <strong>hyphens</strong> (not colons) due to platform naming restrictions.
</div></div>

### Method 2: Natural Language

The agent will automatically apply relevant skills based on your request:

<div class="callout callout-info"><span class="callout-icon">ℹ️</span><div class="callout-body">
  <h4>Example Prompts</h4>
  <ul>
    <li><em>"Help me create a workshop lab module"</em></li>
    <li><em>"Generate demo content for my presentation"</em></li>
    <li><em>"Create an AgnosticV catalog configuration"</em></li>
    <li><em>"Verify my workshop content quality"</em></li>
  </ul>
</div></div>

---

## Verification

After installation and restart, verify skills are loaded:

1. Open Cursor Agent chat (Cmd+L or Ctrl+L)
2. Type `/` to see available skills
3. You should see RHDP skills listed

---

## Using Both Claude Code and Cursor?

<div class="callout callout-warning"><span class="callout-icon">⚠️</span><div class="callout-body">
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
</div></div>

<div class="callout callout-tip"><span class="callout-icon">✅</span><div class="callout-body">
  <h4>Recommendation</h4>
  <p>Choose one installation method:</p>
  <ul>
    <li><strong>Claude Code users:</strong> Use the plugin marketplace (automatic updates, full integration)</li>
    <li><strong>Cursor-only users:</strong> Use this install script</li>
    <li><strong>Both platforms:</strong> Use Claude Code plugin, skip this script for Cursor</li>
  </ul>
</div></div>

---

## Updating Skills

<div class="callout callout-tip"><span class="callout-icon">✅</span><div class="callout-body">
<strong>Run this in your TERMINAL</strong> (not in Cursor chat):
</div></div>

**To update to the latest version:**

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/update-cursor.sh | bash
```

<div class="callout callout-info"><span class="callout-icon">ℹ️</span><div class="callout-body">
  <h4>The update script will:</h4>
  <ul class="checklist">
    <li>Check for new versions</li>
    <li>Show changelog</li>
    <li>Backup current installation</li>
    <li>Install latest version</li>
  </ul>
</div></div>

<div class="callout callout-warning"><span class="callout-icon">⚠️</span><div class="callout-body">
<strong>Manual Updates Required:</strong> Unlike Claude Code plugin marketplace, Cursor updates are manual. Claude Code users get automatic update notifications.
</div></div>

---

## Troubleshooting

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

<div class="links-grid">
  <a href="../skills/create-lab.html" class="link-card"><h4>Learn about /create-lab skill</h4><p>Detailed documentation for the create-lab skill</p></a>
  <a href="../reference/quick-reference.html" class="link-card"><h4>View all skills reference</h4><p>Complete skills reference guide</p></a>
  <a href="../contributing/create-your-own-skill.html" class="link-card"><h4>Create your own skill</h4><p>Guide to building custom skills</p></a>
</div>

<div class="callout callout-info"><span class="callout-icon">ℹ️</span><div class="callout-body">
  <h3>Additional Resources</h3>
  <ul>
    <li><a href="https://github.com/vercel-labs/skills" target="_blank">Vercel Skills CLI</a></li>
    <li><a href="https://agentskills.io" target="_blank">Agent Skills Standard</a></li>
    <li><a href="https://rhpds.github.io/rhdp-skills-marketplace" target="_blank">RHDP Skills Documentation</a></li>
  </ul>
</div></div>
