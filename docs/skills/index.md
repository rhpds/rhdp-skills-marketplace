---
layout: default
title: Skills Reference
---

# Skills Reference

<div class="page-badge">📚 Complete Skills Guide</div>

All RHDP Skills Marketplace skills in one place.

---

## 📝 Showroom Skills (Content Creation)

<div class="category-intro">
For creating Red Hat Showroom workshops and demos.
</div>

<div class="skills-grid">
  <a href="create-lab.html" class="skill-card showroom">
    <div class="skill-icon">📝</div>
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

  <a href="create-demo.html" class="skill-card showroom">
    <div class="skill-icon">🎭</div>
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

  <a href="verify-content.html" class="skill-card showroom">
    <div class="skill-icon">✓</div>
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

  <a href="blog-generate.html" class="skill-card showroom">
    <div class="skill-icon">📰</div>
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

## ⚙️ AgnosticV Skills (RHDP Provisioning)

<div class="category-intro">
For creating and managing RHDP catalog items.
</div>

<div class="skills-grid">
  <a href="agnosticv-catalog-builder.html" class="skill-card agnosticv">
    <div class="skill-icon">🔧</div>
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

  <a href="agnosticv-validator.html" class="skill-card agnosticv">
    <div class="skill-icon">✓</div>
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

## 🏥 Health Skills (Post-Deployment Validation)

<div class="category-intro">
For creating validation and health check roles.
</div>

<div class="skills-grid">
  <a href="deployment-health-checker.html" class="skill-card health">
    <div class="skill-icon">🏥</div>
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

  <a href="ftl.html" class="skill-card health coming-soon">
    <div class="skill-icon">🎯</div>
    <h3>/ftl</h3>
    <p>Generate automated graders and solvers for workshop testing.</p>
    <div class="skill-meta">
      <div class="meta-item">
        <strong>Before:</strong> Have success criteria defined
      </div>
      <div class="meta-item">
        <strong>Use when:</strong> Creating automated validation
      </div>
    </div>
    <div class="skill-status coming-soon">🚧 Coming Soon</div>
  </a>
</div>

---

## 📊 Quick Reference Table

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
        <td><code>/ftl</code></td>
        <td>Health</td>
        <td>Success criteria</td>
        <td><span class="status-badge coming-soon">🚧 Coming Soon</span></td>
      </tr>
    </tbody>
  </table>
</div>

---

## 🆘 Getting Help

<div class="help-grid">
  <a href="../reference/troubleshooting.html" class="help-card">
    <div class="help-icon">🔧</div>
    <h4>Troubleshooting Guide</h4>
    <p>Common issues and solutions</p>
  </a>

  <a href="https://github.com/rhpds/rhdp-skills-marketplace/issues" target="_blank" class="help-card">
    <div class="help-icon">🐛</div>
    <h4>GitHub Issues</h4>
    <p>Report bugs and request features</p>
  </a>

  <a href="https://redhat.enterprise.slack.com/archives/C04MLMA15MX" target="_blank" class="help-card">
    <div class="help-icon">💬</div>
    <h4>#forum-demo-developers</h4>
    <p>Get help from the community</p>
  </a>
</div>

---

<div class="navigation-footer">
  <a href="../index.html" class="nav-button">← Back to Home</a>
  <a href="../setup/" class="nav-button">Setup Guide →</a>
</div>

<style>
.page-badge {
  display: inline-block;
  background: linear-gradient(135deg, #0969da 0%, #0550ae 100%);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  font-weight: 600;
  margin: 1rem 0;
}

.category-intro {
  color: #586069;
  font-size: 1.125rem;
  margin-bottom: 2rem;
}

.skills-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.skill-card {
  display: block;
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 12px;
  padding: 2rem;
  text-decoration: none;
  color: inherit;
  transition: all 0.3s ease;
}

.skill-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
}

.skill-card.showroom:hover {
  border-color: #EE0000;
}

.skill-card.agnosticv:hover {
  border-color: #0969da;
}

.skill-card.health:hover {
  border-color: #28a745;
}

.skill-card.coming-soon {
  opacity: 0.7;
}

.skill-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.skill-card h3 {
  margin: 0 0 0.5rem 0;
  color: #24292e;
  font-size: 1.25rem;
}

.skill-card p {
  color: #586069;
  margin-bottom: 1.5rem;
  line-height: 1.5;
}

.skill-meta {
  margin-bottom: 1rem;
}

.meta-item {
  padding: 0.5rem 0;
  font-size: 0.875rem;
  color: #586069;
  border-top: 1px solid #e1e4e8;
}

.meta-item strong {
  color: #24292e;
}

.skill-status {
  display: inline-block;
  padding: 0.5rem 1rem;
  border-radius: 6px;
  font-size: 0.875rem;
  font-weight: 600;
}

.skill-status.available {
  background: #d4edda;
  color: #155724;
}

.skill-status.coming-soon {
  background: #fff3cd;
  color: #856404;
}

.table-container {
  overflow-x: auto;
  margin: 2rem 0;
}

.skills-table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  border-radius: 8px;
  overflow: hidden;
}

.skills-table thead {
  background: #f6f8fa;
}

.skills-table th {
  padding: 1rem;
  text-align: left;
  font-weight: 600;
  border-bottom: 2px solid #e1e4e8;
}

.skills-table td {
  padding: 1rem;
  border-bottom: 1px solid #e1e4e8;
}

.skills-table tbody tr:last-child td {
  border-bottom: none;
}

.skills-table code {
  background: #f6f8fa;
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  color: #EE0000;
  font-size: 0.875rem;
}

.status-badge {
  display: inline-block;
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-size: 0.75rem;
  font-weight: 600;
}

.status-badge.available {
  background: #d4edda;
  color: #155724;
}

.status-badge.coming-soon {
  background: #fff3cd;
  color: #856404;
}

.help-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1rem;
  margin: 2rem 0;
}

.help-card {
  display: block;
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
  text-align: center;
  text-decoration: none;
  color: inherit;
  transition: all 0.2s ease;
}

.help-card:hover {
  border-color: #EE0000;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.help-icon {
  font-size: 2.5rem;
  margin-bottom: 0.5rem;
}

.help-card h4 {
  margin: 0.5rem 0;
  color: #24292e;
}

.help-card p {
  margin: 0;
  color: #586069;
  font-size: 0.875rem;
}

.navigation-footer {
  display: flex;
  justify-content: space-between;
  gap: 1rem;
  margin: 2rem 0;
  padding-top: 2rem;
  border-top: 1px solid #e1e4e8;
}

.nav-button {
  padding: 0.75rem 1.5rem;
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 8px;
  text-decoration: none;
  color: #24292e;
  font-weight: 600;
  transition: all 0.2s ease;
}

.nav-button:hover {
  border-color: #EE0000;
  color: #EE0000;
  transform: translateY(-2px);
}
</style>
