---
layout: home
title: Home
---

<div class="hero">
  <div class="hero-badge">New v2.4.0</div>
  <h1>RHDP Skills Marketplace</h1>
  <p>AI-powered skills for creating workshops, demos, and automating Red Hat Demo Platform infrastructure.</p>
  <div class="hero-actions">
    <a href="#platforms" class="btn btn-primary">Get Started</a>
    <a href="https://github.com/rhpds/rhdp-skills-marketplace" class="btn btn-secondary">View on GitHub</a>
  </div>
</div>

<div class="section" id="platforms">
  <div class="section-header">
    <h2>Choose Your Platform</h2>
    <p>Select your IDE to get started with RHDP skills</p>
    <p style="font-size: 0.875rem; color: #586069; margin-top: 0.5rem;">
      <strong>Note:</strong> Also works with VS Code using the Claude extension (same installation as Claude Code)
    </p>
  </div>

  <div class="platform-grid">
    <a href="{{ '/setup/claude-code.html' | relative_url }}" class="platform-card">
      <div class="platform-icon">🚀</div>
      <h3>Claude Code</h3>
      <p>Native plugin marketplace with automatic updates and version management</p>
      <div class="platform-meta">
        <span class="badge badge-recommended">Recommended</span>
        <span class="badge">Plugin System</span>
      </div>
    </a>

    <a href="{{ '/setup/cursor.html' | relative_url }}" class="platform-card">
      <div class="platform-icon">⚡</div>
      <h3>Cursor</h3>
      <p>One-command install script with bundled dependencies for Agent Skills 2.4+</p>
      <div class="platform-meta">
        <span class="badge badge-new">New: v2.4.0</span>
        <span class="badge">Workaround</span>
      </div>
    </a>
  </div>
</div>

<div class="section" id="quick-install">
  <div class="section-header">
    <h2>Quick Install</h2>
    <p>Get started in 30 seconds</p>
  </div>

  <div class="category-grid">
    <div class="category-card">
      <div class="category-icon">🔌</div>
      <h3>Claude Code</h3>
      <p>Plugin marketplace installation</p>
      <pre><code>/plugin marketplace add rhpds/rhdp-skills-marketplace
/plugin install showroom@rhdp-marketplace</code></pre>
      <a href="{{ '/setup/claude-code.html' | relative_url }}">Full guide →</a>
    </div>

    <div class="category-card">
      <div class="category-icon">⚡</div>
      <h3>Cursor</h3>
      <p>Install script (workaround)</p>
      <pre><code>curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install-cursor.sh | bash</code></pre>
      <a href="{{ '/setup/cursor.html' | relative_url }}">Full guide →</a>
    </div>
  </div>
</div>

<div class="section" id="skills">
  <div class="section-header">
    <h2>Available Skills</h2>
    <p>7 skills across 3 categories</p>
  </div>

  <div class="category-grid">
    <div class="category-card">
      <div class="category-icon">📝</div>
      <h3>Showroom (4 skills)</h3>
      <p>Workshop and demo creation</p>
      <ul style="margin-top: 1rem; margin-left: 1.5rem; color: #586069;">
        <li>create-lab - Generate workshop modules</li>
        <li>create-demo - Presenter-led demos</li>
        <li>verify-content - Quality validation</li>
        <li>blog-generate - Transform to blog posts</li>
      </ul>
      <a href="{{ '/skills/create-lab.html' | relative_url }}">Learn more →</a>
    </div>

    <div class="category-card">
      <div class="category-icon">⚙️</div>
      <h3>AgnosticV (2 skills)</h3>
      <p>Catalog automation (RHDP internal)</p>
      <ul style="margin-top: 1rem; margin-left: 1.5rem; color: #586069;">
        <li>catalog-builder - Create/update catalogs</li>
        <li>validator - Validate configurations</li>
      </ul>
      <a href="{{ '/skills/agnosticv-catalog-builder.html' | relative_url }}">Learn more →</a>
    </div>

    <div class="category-card">
      <div class="category-icon">🏥</div>
      <h3>Health (1 skill)</h3>
      <p>Deployment validation (RHDP internal)</p>
      <ul style="margin-top: 1rem; margin-left: 1.5rem; color: #586069;">
        <li>deployment-validator - Create Ansible validation roles</li>
      </ul>
      <a href="{{ '/skills/deployment-health-checker.html' | relative_url }}">Learn more →</a>
    </div>
  </div>
</div>

<div class="section">
  <div class="section-header">
    <h2>Need Help?</h2>
  </div>

  <div class="category-grid">
    <div class="category-card">
      <div class="category-icon">🔄</div>
      <h3>Migration Guides</h3>
      <p>Upgrading from older versions</p>
      <a href="{{ '/setup/migration.html' | relative_url }}">Claude Code migration →</a><br>
      <a href="{{ '/setup/cursor-migration.html' | relative_url }}">Cursor migration →</a>
    </div>

    <div class="category-card">
      <div class="category-icon">📚</div>
      <h3>Documentation</h3>
      <p>Complete guides and references</p>
      <a href="{{ '/reference/quick-reference.html' | relative_url }}">Quick reference →</a><br>
      <a href="{{ '/reference/troubleshooting.html' | relative_url }}">Troubleshooting →</a>
    </div>

    <div class="category-card">
      <div class="category-icon">🎓</div>
      <h3>Create Your Own</h3>
      <p>Build custom skills for your workflows</p>
      <a href="{{ '/contributing/create-your-own-skill.html' | relative_url }}">Start workshop →</a>
    </div>
  </div>
</div>

<style>
pre {
  background: #f6f8fa;
  padding: 1rem;
  border-radius: 6px;
  overflow-x: auto;
  margin: 1rem 0;
}

code {
  font-family: "SFMono-Regular", Consolas, "Liberation Mono", Menlo, monospace;
  font-size: 0.875rem;
  color: #24292e;
}
</style>
