---
layout: default
title: Claude Code & VS Code Setup
---

# Claude Code & VS Code Setup

<div class="setup-badge">✅ Recommended Platform</div>

Native Agent Skills support with plugin marketplace - automatic updates and the best experience.

<div class="platform-info">
  <div class="info-card">
    <h3>🚀 Works With</h3>
    <ul>
      <li>Claude Code CLI</li>
      <li>VS Code with Claude extension</li>
    </ul>
  </div>
  <div class="info-card">
    <h3>✨ Features</h3>
    <ul>
      <li>Plugin marketplace system</li>
      <li>Automatic updates</li>
      <li>Version management</li>
    </ul>
  </div>
</div>

---

## ✓ Prerequisites

<div class="prereq-box">
  <h4>📥 Step 1: Install Claude Code</h4>
  <p>Before using the marketplace, you must first install Claude Code:</p>
  <ol>
    <li>Visit <a href="https://claude.com/claude-code" target="_blank">https://claude.com/claude-code</a></li>
    <li>Download and install Claude Code for your platform</li>
    <li>Open a terminal and verify installation: <code>claude --version</code></li>
  </ol>
  <p style="margin-top: 1rem;"><strong>VS Code users:</strong> Install the Claude extension from the VS Code marketplace instead, then continue with Step 2 below.</p>
</div>

---

## 📦 Installation

### Complete Installation Flow

<div class="install-flow">
  <div class="flow-step">
    <div class="flow-number">1</div>
    <div class="flow-content">
      <h4>Start Claude Code</h4>
      <p>In your terminal, run:</p>
      <pre><code>claude</code></pre>
      <p class="flow-note">This opens the Claude Code interactive chat</p>
    </div>
  </div>

  <div class="flow-step">
    <div class="flow-number">2</div>
    <div class="flow-content">
      <h4>Add RHDP Marketplace</h4>
      <p>In Claude Code chat (not terminal), type:</p>
      <pre><code>/plugin marketplace add rhpds/rhdp-skills-marketplace</code></pre>
      <p class="flow-note"><strong>Don't have SSH keys?</strong> Use HTTPS:<br><code>/plugin marketplace add https://github.com/rhpds/rhdp-skills-marketplace</code></p>
    </div>
  </div>

  <div class="flow-step">
    <div class="flow-number">3</div>
    <div class="flow-content">
      <h4>Install Plugins</h4>
      <p>In Claude Code chat, install the plugins you need:</p>
      <pre><code># For workshop/demo creation (recommended)
/plugin install showroom@rhdp-marketplace

# For AgnosticV catalogs (RHDP internal)
/plugin install agnosticv@rhdp-marketplace

# For deployment health checks (RHDP internal)
/plugin install health@rhdp-marketplace
/plugin install ftl@rhdp-marketplace</code></pre>
    </div>
  </div>
</div>

<div class="success-box">
✅ <strong>That's it!</strong> Skills are installed and ready to use.
</div>

---

## 🎯 Available Skills

### Showroom Plugin (Workshop & Demo Creation)

<div class="skills-grid">
  <div class="skill-card">
    <div class="skill-header">
      <span class="skill-icon">📝</span>
      <code>/showroom:create-lab</code>
    </div>
    <p>Generate workshop lab modules with hands-on exercises</p>
  </div>

  <div class="skill-card">
    <div class="skill-header">
      <span class="skill-icon">🎭</span>
      <code>/showroom:create-demo</code>
    </div>
    <p>Create presenter-led demo content with Know/Show structure</p>
  </div>

  <div class="skill-card">
    <div class="skill-header">
      <span class="skill-icon">✓</span>
      <code>/showroom:verify-content</code>
    </div>
    <p>Validate content quality and Red Hat standards</p>
  </div>

  <div class="skill-card">
    <div class="skill-header">
      <span class="skill-icon">📰</span>
      <code>/showroom:blog-generate</code>
    </div>
    <p>Transform workshops into blog posts</p>
  </div>
</div>

### AgnosticV Plugin (Catalog Automation)

<div class="skills-grid">
  <div class="skill-card">
    <div class="skill-header">
      <span class="skill-icon">⚙️</span>
      <code>/agnosticv:catalog-builder</code>
    </div>
    <p>Create and update RHDP catalog items</p>
  </div>

  <div class="skill-card">
    <div class="skill-header">
      <span class="skill-icon">✓</span>
      <code>/agnosticv:validator</code>
    </div>
    <p>Validate catalog configurations</p>
  </div>
</div>

### Health Plugin (Deployment Validation)

<div class="skills-grid">
  <div class="skill-card">
    <div class="skill-header">
      <span class="skill-icon">🏥</span>
      <code>/health:deployment-validator</code>
    </div>
    <p>Create Ansible validation roles for health checks</p>
  </div>
</div>

---

## ✓ Verify Installation

Check that skills are installed:

```bash
/plugin list
```

You should see `showroom`, `agnosticv`, and/or `health` listed.

---

## 🔄 Updates

The marketplace automatically checks for updates. **To update manually:**

```bash
/plugin marketplace update
```

This will:
- Check all installed plugins for updates
- Show changelog for available updates
- Prompt to install updates

---

## 💡 How to Use Skills

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

## 🆘 Troubleshooting

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

<div class="next-steps">
  <h3>📚 Next Steps</h3>
  <ul>
    <li><a href="../skills/create-lab.html">Learn about /create-lab skill →</a></li>
    <li><a href="../reference/quick-reference.html">View all skills reference →</a></li>
    <li><a href="../contributing/create-your-own-skill.html">Create your own skill →</a></li>
  </ul>
</div>

<style>
.setup-badge {
  display: inline-block;
  background: #d4edda;
  color: #155724;
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

.success-box {
  background: #d4edda;
  border-left: 4px solid #28a745;
  padding: 1rem;
  margin: 1rem 0;
  border-radius: 4px;
  color: #155724;
}

.skills-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1rem;
  margin: 1.5rem 0;
}

.skill-card {
  background: white;
  border: 2px solid #e1e4e8;
  border-radius: 8px;
  padding: 1rem;
  transition: all 0.2s ease;
}

.skill-card:hover {
  border-color: #EE0000;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.skill-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 0.5rem;
}

.skill-icon {
  font-size: 1.5rem;
}

.skill-header code {
  background: #f6f8fa;
  color: #EE0000;
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  font-size: 0.875rem;
  font-weight: 600;
}

.skill-card p {
  margin: 0;
  color: #586069;
  font-size: 0.875rem;
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

.prereq-box a {
  color: #0969da;
  text-decoration: underline;
}

.prereq-box a:hover {
  text-decoration: none;
}

.install-flow {
  margin: 2rem 0;
}

.flow-step {
  display: flex;
  gap: 1.5rem;
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 12px;
  padding: 1.5rem;
  margin-bottom: 1.5rem;
}

.flow-number {
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

.flow-content {
  flex: 1;
}

.flow-content h4 {
  margin-top: 0;
  margin-bottom: 0.5rem;
  color: #24292e;
}

.flow-content p {
  margin: 0.5rem 0;
  color: #586069;
}

.flow-content pre {
  background: #f6f8fa;
  padding: 1rem;
  border-radius: 6px;
  margin: 0.5rem 0;
}

.flow-note {
  font-size: 0.875rem;
  font-style: italic;
  color: #586069;
  margin-top: 0.5rem;
}

.flow-note strong {
  color: #24292e;
  font-style: normal;
}

.flow-note code {
  background: #f6f8fa;
  padding: 0.2rem 0.4rem;
  border-radius: 3px;
  font-style: normal;
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
