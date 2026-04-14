---
layout: home
title: Home
---

<div class="hero">
  <div class="hero-eyebrow">v2.11.1 · Red Hat Demo Platform</div>
  <h1>RHDP Skills Marketplace</h1>
  <p class="hero-subtitle">AI-powered skills for Claude Code. Create workshops, demos, and catalog items faster — with built-in Red Hat standards and quality checks.</p>
  <div class="hero-actions">
    <a href="#skills" class="btn btn-primary btn-large">Browse Skills</a>
    <a href="#platforms" class="btn btn-secondary">Get Started</a>
  </div>
</div>

<div class="section" id="skills">
  <div class="section-header">
    <h2>Available Skills</h2>
    <p>8 skills across 4 namespaces — install only what you need</p>
  </div>

  <div class="category-grid">
    <div class="category-card">
      <span class="category-icon">📝</span>
      <h3>Showroom — Workshop &amp; Demo Creation</h3>
      <p>Create labs, demos, and blog posts for Red Hat Showroom. Handles AsciiDoc, navigation, quality validation, and Red Hat style standards.</p>
      <ul style="margin: 0.875rem 0; color: var(--color-text-3); font-size: 0.875rem;">
        <li><code>/showroom:create-lab</code> — Hands-on workshop modules (Know/Do/Check)</li>
        <li><code>/showroom:create-demo</code> — Presenter-led demos (Know/Show)</li>
        <li><code>/showroom:verify-content</code> — Quality &amp; standards validation</li>
        <li><code>/showroom:blog-generate</code> — Workshop → blog post</li>
      </ul>
      <a href="{{ '/skills/create-lab.html' | relative_url }}">Learn more →</a>
    </div>

    <div class="category-card">
      <span class="category-icon">⚙️</span>
      <h3>AgnosticV — Catalog Automation</h3>
      <p>Build and validate RHDP catalog items — common.yaml, dev.yaml, description.adoc, info messages — with guided questions covering all infrastructure types.</p>
      <ul style="margin: 0.875rem 0; color: var(--color-text-3); font-size: 0.875rem;">
        <li><code>/agnosticv:catalog-builder</code> — Create or update catalog items</li>
        <li><code>/agnosticv:validator</code> — Validate before submitting PR</li>
      </ul>
      <a href="{{ '/skills/agnosticv-catalog-builder.html' | relative_url }}">Learn more →</a>
    </div>

    <div class="category-card">
      <span class="category-icon">🏥</span>
      <h3>Health — Deployment Validation</h3>
      <p>Generate Ansible validation roles that verify a deployed lab environment is healthy before students start.</p>
      <ul style="margin: 0.875rem 0; color: var(--color-text-3); font-size: 0.875rem;">
        <li><code>/health:deployment-validator</code> — Create Ansible health check roles</li>
      </ul>
      <a href="{{ '/skills/deployment-health-checker.html' | relative_url }}">Learn more →</a>
    </div>

    <div class="category-card">
      <span class="category-icon">🧪</span>
      <h3>FTL — Full Test Lifecycle</h3>
      <p>Generate grader and solver playbooks for Showroom workshop labs. Reads your .adoc modules and produces production-quality Ansible automation.</p>
      <ul style="margin: 0.875rem 0; color: var(--color-text-3); font-size: 0.875rem;">
        <li><code>/ftl:lab-validator</code> — Generate grade/solve playbooks</li>
      </ul>
      <a href="{{ '/skills/rhdp-lab-validator.html' | relative_url }}">Learn more →</a>
    </div>
  </div>
</div>

<div class="section section-primary" id="platforms">
  <div class="section-header">
    <h2>Quick Install</h2>
    <p>Two commands to get started on Claude Code</p>
  </div>

  <div class="category-grid">
    <div class="category-card">
      <span class="category-icon">🚀</span>
      <h3>Claude Code <span class="badge badge-recommended" style="vertical-align:middle;">Recommended</span></h3>
      <p>Native plugin marketplace — automatic updates, version management.</p>

```
/plugin marketplace add rhpds/rhdp-skills-marketplace
/plugin install showroom@rhdp-marketplace
```

      <a href="{{ '/setup/claude-code.html' | relative_url }}">Full setup guide →</a>
    </div>

    <div class="category-card">
      <span class="category-icon">⚡</span>
      <h3>Cursor</h3>
      <p>One-command bash install. Works alongside your existing Cursor setup.</p>

```
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install-cursor.sh | bash
```

      <a href="{{ '/setup/cursor.html' | relative_url }}">Full setup guide →</a>
    </div>
  </div>
  <p class="platform-note">Also works with VS Code using the Claude extension — same setup as Claude Code.</p>
</div>

<div class="section">
  <div class="section-header">
    <h2>What's New — v2.11.1</h2>
    <p>Latest updates to the RHDP Skills Marketplace · <a href="{{ '/reference/changelog.html' | relative_url }}">Full changelog →</a></p>
  </div>

  <div class="category-grid">
    <div class="category-card">
      <span class="category-icon">✅</span>
      <h3>AgnosticV Validator — 2 New Checks</h3>
      <p><strong>Check 25:</strong> Runtime automation consistency — flags missing image or FTL workload when <code>runtime_automation_enable: true</code>. <strong>Check 26:</strong> LiteLLM virtual keys placement — errors if found in a cluster provisioner CI instead of the tenant CI.</p>
    </div>

    <div class="category-card">
      <span class="category-icon">🏗️</span>
      <h3>AgnosticV Catalog Builder — E2E Testing + Terminal Type</h3>
      <p>New questions for terminal type (wetty / showroom / none) and E2E testing (solve + validate buttons). Full dependency checklist — errors on partial config. Deployer chart vars now in the generated <code>common.yaml</code> template.</p>
    </div>

    <div class="category-card">
      <span class="category-icon">🔍</span>
      <h3>Showroom Verify-Content — E.3a Fix + E2E Checks</h3>
      <p>E.3a false positives fixed — <code>[source,text]</code>, <code>[source,yaml]</code> and other non-shell blocks no longer trigger. Executable: <code>bash</code>, <code>sh</code>, <code>shell</code>, <code>console</code>, <code>terminal</code>, <code>tty</code>, <code>wetty</code>. New checks S.5a and S.5b for <code>buttons.js</code> and <code>runtime-automation/</code>.</p>
    </div>

    <div class="category-card">
      <span class="category-icon">📝</span>
      <h3>Showroom Create-Lab — Send-to &amp; E2E Docs</h3>
      <p>Documented <code>role="send-to-wetty"</code> and <code>role="send-to-terminal"</code> combined roles, solve/validate button placeholder syntax, and fixed wrong nookbag template URL (<code>showroom_template_nookbag</code>).</p>
    </div>
  </div>
</div>

<div class="section">
  <div class="section-header">
    <h2>Resources</h2>
  </div>

  <div class="category-grid">
    <div class="category-card category-card-highlight">
      <span class="category-icon">💡</span>
      <h3>Best Practices</h3>
      <p>Context management, CLAUDE.md setup, git rules, and real pitfalls from daily RHDP work.</p>
      <a href="{{ '/reference/best-practices.html' | relative_url }}" class="category-cta">Read before you start →</a>
    </div>

    <div class="category-card">
      <span class="category-icon">⚡</span>
      <h3>Quick Reference</h3>
      <p>All install commands, skill commands, and common workflows in one place.</p>
      <a href="{{ '/reference/quick-reference.html' | relative_url }}">Open quick reference →</a>
    </div>

    <div class="category-card">
      <span class="category-icon">🔧</span>
      <h3>Troubleshooting</h3>
      <p>Skills not showing, plugin errors, common fixes.</p>
      <a href="{{ '/reference/troubleshooting.html' | relative_url }}">Fix common issues →</a>
    </div>

    <div class="category-card">
      <span class="category-icon">🛠️</span>
      <h3>Build Your Own Skill</h3>
      <p>Have a repetitive workflow? Turn it into a reusable Claude Code skill. Walkthrough guides for different roles.</p>
      <a href="{{ '/contributing/create-your-own-skill.html' | relative_url }}">Start building →</a><br>
      <a href="{{ '/reference/skills-vs-agents.html' | relative_url }}" style="font-size:0.8125rem; color: var(--color-text-3);">Skills vs Agents explainer →</a>
    </div>
  </div>
</div>
