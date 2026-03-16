---
layout: home
title: Home
---

<div class="hero">
  <div class="hero-eyebrow">v2.9.0 · Red Hat Demo Platform</div>
  <h1>RHDP Skills Marketplace</h1>
  <p class="hero-subtitle">AI-powered skills for Claude Code. Create workshops, demos, and catalog items — for everyone from sales engineers to platform builders.</p>
  <div class="hero-actions">
    <a href="#roles" class="btn btn-primary btn-large">Find Your Role →</a>
    <a href="https://github.com/rhpds/rhdp-skills-marketplace" class="btn btn-secondary">View on GitHub</a>
  </div>
</div>

<div class="section" id="roles">
  <div class="section-header">
    <h2>Start by Role</h2>
    <p>Not everyone uses the marketplace the same way. Pick your role to jump to the right guide.</p>
  </div>

  <div class="persona-grid">
    <a href="{{ '/contributing/for-sales.html' | relative_url }}" class="persona-card">
      <span class="persona-emoji">💼</span>
      <div class="persona-role">Sales &amp; Pre-Sales</div>
      <h3>I want to automate my demo prep</h3>
      <p>Build a skill that generates customer briefing docs, finds the right catalog item, and drafts follow-up bullets — in one command.</p>
      <span class="persona-link">Build a sales skill →</span>
    </a>

    <a href="{{ '/contributing/for-developers.html' | relative_url }}" class="persona-card">
      <span class="persona-emoji">🖥️</span>
      <div class="persona-role">Frontend Developer</div>
      <h3>I want an AI code reviewer for my UI</h3>
      <p>Create an agent that reviews every React component for accessibility, responsiveness, and PatternFly compliance — automatically.</p>
      <span class="persona-link">Set up a frontend agent →</span>
    </a>

    <a href="{{ '/setup/claude-code.html' | relative_url }}" class="persona-card">
      <span class="persona-emoji">⚙️</span>
      <div class="persona-role">RHDP / Solutions Engineer</div>
      <h3>I want to build catalog items and workshops</h3>
      <p>Install the full marketplace and use skills to generate AgnosticV catalogs, Showroom workshops, and validation roles.</p>
      <span class="persona-link">Install the marketplace →</span>
    </a>

    <a href="{{ '/contributing/create-your-own-skill.html' | relative_url }}" class="persona-card">
      <span class="persona-emoji">🛠️</span>
      <div class="persona-role">Anyone</div>
      <h3>I want to build a custom skill</h3>
      <p>Have a manual workflow you repeat? Turn it into a reusable Claude Code skill in 5 phases — no programming required.</p>
      <span class="persona-link">Start building →</span>
    </a>
  </div>
</div>

<div class="section section-primary" id="platforms">
  <div class="section-header">
    <h2>Choose Your Platform</h2>
    <p>Same skills, two IDEs. Claude Code is recommended.</p>
  </div>

  <div class="platform-grid">
    <a href="{{ '/setup/claude-code.html' | relative_url }}" class="platform-card">
      <div class="platform-icon">🚀</div>
      <h3>Claude Code</h3>
      <p>Native plugin marketplace with automatic version management and one-command installs.</p>
      <div class="platform-meta">
        <span class="badge badge-recommended">Recommended</span>
        <span class="badge badge-new">Plugin System</span>
      </div>
      <div class="platform-action">Install in 2 commands →</div>
    </a>

    <a href="{{ '/setup/cursor.html' | relative_url }}" class="platform-card">
      <div class="platform-icon">⚡</div>
      <h3>Cursor</h3>
      <p>One-command bash install script. Runs alongside your existing Cursor setup.</p>
      <div class="platform-meta">
        <span class="badge badge-new">New in v2.7</span>
      </div>
      <div class="platform-action">Install with bash →</div>
    </a>
  </div>

  <p class="platform-note">Also works with VS Code using the Claude extension — same setup as Claude Code.</p>
</div>

<div class="section" id="quick-install">
  <div class="section-header">
    <h2>Quick Install</h2>
    <p>Two commands to get started on Claude Code.</p>
  </div>

  <div class="category-grid">
    <div class="category-card">
      <div class="category-icon">🔌</div>
      <h3>Claude Code</h3>
      <p>Add the marketplace, then install the namespaces you need.</p>

```
/plugin marketplace add rhpds/rhdp-skills-marketplace
/plugin install showroom@rhdp-marketplace
```

      <a href="{{ '/setup/claude-code.html' | relative_url }}">Full setup guide →</a>
    </div>

    <div class="category-card">
      <div class="category-icon">⚡</div>
      <h3>Cursor</h3>
      <p>One-line bash install. Installs all namespaces automatically.</p>

```
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install-cursor.sh | bash
```

      <a href="{{ '/setup/cursor.html' | relative_url }}">Full setup guide →</a>
    </div>
  </div>
</div>

<div class="section" id="skills">
  <div class="section-header">
    <h2>Available Skills</h2>
    <p>8 skills across 4 namespaces.</p>
  </div>

  <div class="category-grid">
    <div class="category-card">
      <div class="category-icon">📝</div>
      <h3>Showroom — 4 skills</h3>
      <p>Workshop and demo content creation.</p>
      <ul style="margin-top:0.875rem; color: var(--color-text-3); font-size:0.875rem;">
        <li><code>/showroom:create-lab</code> — Workshop modules</li>
        <li><code>/showroom:create-demo</code> — Presenter demos</li>
        <li><code>/showroom:verify-content</code> — Quality checks</li>
        <li><code>/showroom:blog-generate</code> — Blog posts</li>
      </ul>
      <a href="{{ '/skills/create-lab.html' | relative_url }}">Learn more →</a>
    </div>

    <div class="category-card">
      <div class="category-icon">⚙️</div>
      <h3>AgnosticV — 2 skills</h3>
      <p>RHDP catalog automation.</p>
      <ul style="margin-top:0.875rem; color: var(--color-text-3); font-size:0.875rem;">
        <li><code>/agnosticv:catalog-builder</code> — Create catalogs</li>
        <li><code>/agnosticv:validator</code> — Validate configs</li>
      </ul>
      <a href="{{ '/skills/agnosticv-catalog-builder.html' | relative_url }}">Learn more →</a>
    </div>

    <div class="category-card">
      <div class="category-icon">🏥</div>
      <h3>Health — 1 skill</h3>
      <p>Post-deployment validation.</p>
      <ul style="margin-top:0.875rem; color: var(--color-text-3); font-size:0.875rem;">
        <li><code>/health:deployment-validator</code> — Ansible roles</li>
      </ul>
      <a href="{{ '/skills/deployment-health-checker.html' | relative_url }}">Learn more →</a>
    </div>

    <div class="category-card">
      <div class="category-icon">🧪</div>
      <h3>FTL — 1 skill</h3>
      <p>Automated lab grading.</p>
      <ul style="margin-top:0.875rem; color: var(--color-text-3); font-size:0.875rem;">
        <li><code>/ftl:lab-validator</code> — Grade/solve playbooks</li>
      </ul>
      <a href="{{ '/skills/ftl.html' | relative_url }}">Learn more →</a>
    </div>
  </div>
</div>

<div class="section">
  <div class="section-header">
    <h2>Resources</h2>
  </div>

  <div class="category-grid">
    <div class="category-card category-card-highlight">
      <div class="category-icon">💡</div>
      <h3>Best Practices</h3>
      <p>Context management, CLAUDE.md setup, git rules, and real pitfalls from AgV, AgD, and Showroom work.</p>
      <a href="{{ '/reference/best-practices.html' | relative_url }}" class="category-cta">Read before you start →</a>
    </div>

    <div class="category-card">
      <div class="category-icon">⚖️</div>
      <h3>Skills vs Agents</h3>
      <p>What's the difference? When do you use each? Real Red Hat examples for every role.</p>
      <a href="{{ '/reference/skills-vs-agents.html' | relative_url }}">Understand the difference →</a>
    </div>

    <div class="category-card">
      <div class="category-icon">🛠️</div>
      <h3>Build Your Own Skill</h3>
      <p>Turn any manual workflow into a reusable Claude Code skill. 5-phase guide — no code required.</p>
      <a href="{{ '/contributing/create-your-own-skill.html' | relative_url }}">Start the workshop →</a>
    </div>

    <div class="category-card">
      <div class="category-icon">🔌</div>
      <h3>Plugin Dev Toolkit</h3>
      <p>Anthropic's official toolkit for building skills and plugins. Includes 7 skills and guided creation workflow.</p>
      <a href="{{ '/contributing/plugin-dev-plugin.html' | relative_url }}">Explore the toolkit →</a>
    </div>
  </div>
</div>
