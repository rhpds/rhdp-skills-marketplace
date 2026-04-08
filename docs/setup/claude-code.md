---
layout: default
title: Claude Code & VS Code Setup
---

# Claude Code & VS Code Setup

<div class="reference-badge">Recommended Platform</div>

Native Agent Skills support with plugin marketplace - automatic updates and the best experience.

<div class="category-grid">
  <div class="category-card">
    <h3>Works With</h3>
    <ul>
      <li>Claude Code CLI</li>
      <li>VS Code with Claude extension</li>
    </ul>
  </div>
  <div class="category-card">
    <h3>Features</h3>
    <ul>
      <li>Plugin marketplace system</li>
      <li>Automatic updates</li>
      <li>Version management</li>
    </ul>
  </div>
</div>

---

## Prerequisites

<div class="callout callout-info"><span class="callout-icon">ℹ️</span><div class="callout-body">
  <h4>Step 1: Install Claude Code</h4>
  <p>Before using the marketplace, you must first install Claude Code:</p>
  <ol>
    <li>Visit <a href="https://claude.com/claude-code" target="_blank">https://claude.com/claude-code</a></li>
    <li>Download and install Claude Code for your platform</li>
    <li>Open a terminal and verify installation: <code>claude --version</code></li>
  </ol>
  <p style="margin-top: 1rem;"><strong>VS Code users:</strong> Install the Claude extension from the VS Code marketplace instead, then continue with Step 2 below.</p>
</div></div>

---

## Installation

### Complete Installation Flow

<ol class="steps">
  <li><div class="step-content"><h4>Start Claude Code</h4>
    <p>In your terminal, run:</p>
    <pre><code>claude</code></pre>
    <p class="text-muted">This opens the Claude Code interactive chat</p>
  </div></li>

  <li><div class="step-content"><h4>Add RHDP Marketplace</h4>
    <p>In Claude Code chat (not terminal), type:</p>
    <pre><code>/plugin marketplace add rhpds/rhdp-skills-marketplace</code></pre>
    <p class="text-muted"><strong>Don't have SSH keys?</strong> Use HTTPS:<br><code>/plugin marketplace add https://github.com/rhpds/rhdp-skills-marketplace</code></p>
  </div></li>

  <li><div class="step-content"><h4>Install Plugins</h4>
    <p>In Claude Code chat, install the plugins you need:</p>
    <pre><code># For workshop/demo creation (recommended)
/plugin install showroom@rhdp-marketplace

# For AgnosticV catalogs (RHDP internal)
/plugin install agnosticv@rhdp-marketplace

# For deployment health checks (RHDP internal)
/plugin install health@rhdp-marketplace
/plugin install ftl@rhdp-marketplace</code></pre>
    <p>When prompted for scope, select <strong>"Install for you (user scope)"</strong> — this installs the plugin for your user account across all projects. That's the right choice for personal use. "Project scope" installs it for all collaborators in the current repo (useful if your whole team uses Claude Code), and "local scope" is for a single session only.</p>
  </div></li>
</ol>

<div class="callout callout-tip"><span class="callout-icon">✅</span><div class="callout-body">
<strong>That's it!</strong> Skills are installed and ready to use.
</div></div>

---

## Available Skills

### Showroom Plugin (Workshop & Demo Creation)

<div class="category-grid">
  <div class="category-card">
    <div class="skill-header">
      <span class="skill-icon">📝</span>
      <code>/showroom:create-lab</code>
    </div>
    <p>Generate workshop lab modules with hands-on exercises</p>
  </div>

  <div class="category-card">
    <div class="skill-header">
      <span class="skill-icon">🎭</span>
      <code>/showroom:create-demo</code>
    </div>
    <p>Create presenter-led demo content with Know/Show structure</p>
  </div>

  <div class="category-card">
    <div class="skill-header">
      <span class="skill-icon">✓</span>
      <code>/showroom:verify-content</code>
    </div>
    <p>Validate content quality and Red Hat standards</p>
  </div>

  <div class="category-card">
    <div class="skill-header">
      <span class="skill-icon">📰</span>
      <code>/showroom:blog-generate</code>
    </div>
    <p>Transform workshops into blog posts</p>
  </div>
</div>

### AgnosticV Plugin (Catalog Automation)

<div class="category-grid">
  <div class="category-card">
    <div class="skill-header">
      <span class="skill-icon">⚙️</span>
      <code>/agnosticv:catalog-builder</code>
    </div>
    <p>Create and update RHDP catalog items</p>
  </div>

  <div class="category-card">
    <div class="skill-header">
      <span class="skill-icon">✓</span>
      <code>/agnosticv:validator</code>
    </div>
    <p>Validate catalog configurations</p>
  </div>
</div>

### Health Plugin (Deployment Validation)

<div class="category-grid">
  <div class="category-card">
    <div class="skill-header">
      <span class="skill-icon">🏥</span>
      <code>/health:deployment-validator</code>
    </div>
    <p>Create Ansible validation roles for health checks</p>
  </div>
</div>

---

## Verify Installation

Check that skills are installed:

```bash
/plugin list
```

You should see `showroom`, `agnosticv`, and/or `health` listed.

---

## Updates

The marketplace automatically checks for updates. **To update manually:**

```bash
/plugin marketplace update
```

This will:
- Check all installed plugins for updates
- Show changelog for available updates
- Prompt to install updates

---

## How to Use Skills

### In Claude Code CLI

1. Type `/` to see all available skills
2. Select a skill (e.g., `/showroom:create-lab`)
3. Follow the interactive prompts
4. Skill generates content automatically

### In VS Code with Claude Extension

1. Open Claude chat (click Claude icon in activity bar)
2. Type `/` to see slash commands menu
3. Select a skill from the list
4. Answer questions and let the skill work

---

## Troubleshooting

<details>
<summary><strong>Skills not appearing after installation</strong></summary>

1. Restart Claude Code or VS Code completely
2. Verify installation: `/plugin list`
3. Check skills directory: `ls ~/.claude/plugins/marketplaces/rhdp-marketplace/`

</details>

<details>
<summary><strong>Plugin marketplace command not found</strong></summary>

Make sure you're using:
- Claude Code (latest version), or
- VS Code with Claude extension installed

Plugin marketplace is not available in regular VS Code without the Claude extension.

</details>

<details>
<summary><strong>Permission denied errors</strong></summary>

```bash
chmod 755 ~/.claude/plugins/
```

</details>

---

<div class="links-grid">
  <a href="../skills/create-lab.html" class="link-card"><h4>Learn about /create-lab skill</h4><p>Detailed documentation for the create-lab skill</p></a>
  <a href="../reference/quick-reference.html" class="link-card"><h4>View all skills reference</h4><p>Complete skills reference guide</p></a>
  <a href="../contributing/create-your-own-skill.html" class="link-card"><h4>Create your own skill</h4><p>Guide to building custom skills</p></a>
</div>
