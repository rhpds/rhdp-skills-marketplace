---
layout: default
title: Skills Reference
---

# Skills Reference

<div class="reference-badge">📚 Complete Skills Guide</div>

All RHDP Skills Marketplace skills in one place.

---

## Showroom Skills (Content Creation)

<div class="category-intro">
For creating Red Hat Showroom workshops and demos.
</div>

<div class="category-grid">
  <a href="create-lab.html" class="category-card showroom">
    <div class="category-icon">📝</div>
    <h3>/showroom:create-lab</h3>
    <p>Generate workshop lab modules with Know/Do/Check structure.</p>
    <div class="skill-meta">
      <div class="meta-item">
        <strong>Before:</strong> Create Showroom template repo
      </div>
      <div class="meta-item">
        <strong>Use when:</strong> Creating hands-on workshops
      </div>
    </div>
    <div class="skill-status available">✅ Available</div>
  </a>

  <a href="create-demo.html" class="category-card showroom">
    <div class="category-icon">🎭</div>
    <h3>/showroom:create-demo</h3>
    <p>Generate presenter-led demo content with Know/Show structure.</p>
    <div class="skill-meta">
      <div class="meta-item">
        <strong>Before:</strong> Create Showroom template repo
      </div>
      <div class="meta-item">
        <strong>Use when:</strong> Creating presentations
      </div>
    </div>
    <div class="skill-status available">✅ Available</div>
  </a>

  <a href="verify-content.html" class="category-card showroom">
    <div class="category-icon">✓</div>
    <h3>/showroom:verify-content</h3>
    <p>Validate content quality and Red Hat standards compliance.</p>
    <div class="skill-meta">
      <div class="meta-item">
        <strong>Before:</strong> Have workshop content ready
      </div>
      <div class="meta-item">
        <strong>Use when:</strong> Checking before publishing
      </div>
    </div>
    <div class="skill-status available">✅ Available</div>
  </a>

  <a href="blog-generate.html" class="category-card showroom">
    <div class="category-icon">📰</div>
    <h3>/showroom:blog-generate</h3>
    <p>Transform workshop content into blog post format.</p>
    <div class="skill-meta">
      <div class="meta-item">
        <strong>Before:</strong> Complete workshop content
      </div>
      <div class="meta-item">
        <strong>Use when:</strong> Publishing to RH Developer blog
      </div>
    </div>
    <div class="skill-status available">✅ Available</div>
  </a>
</div>

---

## AgnosticV Skills (RHDP Provisioning)

<div class="category-intro">
For creating and managing RHDP catalog items.
</div>

<div class="category-grid">
  <a href="agnosticv-catalog-builder.html" class="category-card agnosticv">
    <div class="category-icon">🔧</div>
    <h3>/agnosticv:catalog-builder</h3>
    <p>Create or update AgnosticV catalog files (unified skill).</p>
    <div class="skill-meta">
      <div class="meta-item">
        <strong>Before:</strong> Clone agnosticv repo, verify access
      </div>
      <div class="meta-item">
        <strong>Use when:</strong> Creating/updating catalogs
      </div>
    </div>
    <div class="skill-status available">✅ Available</div>
  </a>

  <a href="agnosticv-validator.html" class="category-card agnosticv">
    <div class="category-icon">✓</div>
    <h3>/agnosticv:validator</h3>
    <p>Validate catalog configurations and best practices.</p>
    <div class="skill-meta">
      <div class="meta-item">
        <strong>Before:</strong> Have catalog files ready
      </div>
      <div class="meta-item">
        <strong>Use when:</strong> Validating before PR
      </div>
    </div>
    <div class="skill-status available">✅ Available</div>
  </a>
</div>

---

## Health Skills (Post-Deployment Validation)

<div class="category-intro">
For creating deployment health check validation roles.
</div>

<div class="category-grid">
  <a href="deployment-health-checker.html" class="category-card health">
    <div class="category-icon">🏥</div>
    <h3>/health:deployment-validator</h3>
    <p>Create Ansible validation roles for post-deployment checks.</p>
    <div class="skill-meta">
      <div class="meta-item">
        <strong>Before:</strong> Know what to validate
      </div>
      <div class="meta-item">
        <strong>Use when:</strong> Building health checks
      </div>
    </div>
    <div class="skill-status available">✅ Available</div>
  </a>
</div>

---

## FTL Skills (Full Test Lifecycle)

<div class="category-intro">
For generating automated grader and solver playbooks for Showroom workshop labs.
</div>

<div class="category-grid">
  <a href="ftl.html" class="category-card health">
    <div class="category-icon">🧪</div>
    <h3>/ftl:lab-validator</h3>
    <p>Generate grade_module and solve_module playbooks by reading your Showroom .adoc modules.</p>
    <div class="skill-meta">
      <div class="meta-item">
        <strong>Before:</strong> Showroom content with student exercises
      </div>
      <div class="meta-item">
        <strong>Use when:</strong> Adding automated grading to your lab
      </div>
    </div>
    <div class="skill-status available">✅ Available</div>
  </a>
</div>

---

## Quick Reference Table

<div class="table-container">
  <table class="skills-table">
    <thead>
      <tr>
        <th>Skill</th>
        <th>Namespace</th>
        <th>Prerequisites</th>
        <th>Status</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><code>/showroom:create-lab</code></td>
        <td>Showroom</td>
        <td>Showroom template repo</td>
        <td><span class="status-badge available">✅ Available</span></td>
      </tr>
      <tr>
        <td><code>/showroom:create-demo</code></td>
        <td>Showroom</td>
        <td>Showroom template repo</td>
        <td><span class="status-badge available">✅ Available</span></td>
      </tr>
      <tr>
        <td><code>/showroom:verify-content</code></td>
        <td>Showroom</td>
        <td>Workshop content</td>
        <td><span class="status-badge available">✅ Available</span></td>
      </tr>
      <tr>
        <td><code>/showroom:blog-generate</code></td>
        <td>Showroom</td>
        <td>Complete workshop</td>
        <td><span class="status-badge available">✅ Available</span></td>
      </tr>
      <tr>
        <td><code>/agnosticv:catalog-builder</code></td>
        <td>AgnosticV</td>
        <td>AgnosticV repo + access</td>
        <td><span class="status-badge available">✅ Available</span></td>
      </tr>
      <tr>
        <td><code>/agnosticv:validator</code></td>
        <td>AgnosticV</td>
        <td>Catalog files</td>
        <td><span class="status-badge available">✅ Available</span></td>
      </tr>
      <tr>
        <td><code>/health:deployment-validator</code></td>
        <td>Health</td>
        <td>Validation requirements</td>
        <td><span class="status-badge available">✅ Available</span></td>
      </tr>
      <tr>
        <td><code>/ftl:lab-validator</code></td>
        <td>FTL</td>
        <td>Showroom .adoc modules</td>
        <td><span class="status-badge available">✅ Available</span></td>
      </tr>
    </tbody>
  </table>
</div>

---

## Getting Help

<div class="category-grid">
  <a href="../reference/troubleshooting.html" class="category-card">
    <div class="category-icon">🔧</div>
    <h4>Troubleshooting Guide</h4>
    <p>Common issues and solutions</p>
  </a>

  <a href="https://github.com/rhpds/rhdp-skills-marketplace/issues" target="_blank" class="category-card">
    <div class="category-icon">🐛</div>
    <h4>GitHub Issues</h4>
    <p>Report bugs and request features</p>
  </a>

  <a href="https://redhat.enterprise.slack.com/archives/C04MLMA15MX" target="_blank" class="category-card">
    <div class="category-icon">💬</div>
    <h4>#forum-demo-developers</h4>
    <p>Get help from the community</p>
  </a>
</div>

---

<div class="navigation-footer">
  <a href="../index.html" class="nav-button">← Back to Home</a>
  <a href="../setup/" class="nav-button">Setup Guide →</a>
</div>
