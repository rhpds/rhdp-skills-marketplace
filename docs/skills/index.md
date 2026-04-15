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
  <a href="rhdp-lab-validator.html" class="category-card health">
    <div class="category-icon">🚀</div>
    <h3>/ftl:rhdp-lab-validator</h3>
    <p>Generate E2E runtime-automation playbooks for RHDP showroom labs — Solve/Validate buttons for OCP, RHEL VM, and AAP labs.</p>
    <div class="skill-meta">
      <div class="meta-item"><strong>Before:</strong> AgV catalog + showroom repo</div>
      <div class="meta-item"><strong>Use when:</strong> Adding E2E testing to summit/RHDP labs</div>
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
</div>

---

## AIOps Skills (Incident Investigation)

<div class="category-intro">
For investigating failed Ansible/AAP jobs by correlating logs, Splunk data, and GitHub configuration.
</div>

<div class="category-grid">
  <a href="root-cause-analysis.html" class="category-card aiops">
    <div class="category-icon">🔎</div>
    <h3>/aiops-skill:root-cause-analysis</h3>
    <p>Investigate failed jobs by correlating Ansible/AAP logs with Splunk OCP pod logs and GitHub configuration.</p>
    <div class="skill-meta">
      <div class="meta-item">
        <strong>Before:</strong> SSH access + Splunk credentials
      </div>
      <div class="meta-item">
        <strong>Use when:</strong> Diagnosing infrastructure failures
      </div>
    </div>
    <div class="skill-status available">✅ Available</div>
  </a>

  <a href="logs-fetcher.html" class="category-card aiops">
    <div class="category-icon">📋</div>
    <h3>/aiops-skill:logs-fetcher</h3>
    <p>Fetch Ansible/AAP logs from remote servers via SSH with time-based or job-number filtering.</p>
    <div class="skill-meta">
      <div class="meta-item">
        <strong>Before:</strong> SSH access to log server
      </div>
      <div class="meta-item">
        <strong>Use when:</strong> Retrieving logs for investigation
      </div>
    </div>
    <div class="skill-status available">✅ Available</div>
  </a>

  <a href="context-fetcher.html" class="category-card aiops">
    <div class="category-icon">🗂️</div>
    <h3>/aiops-skill:context-fetcher</h3>
    <p>Retrieve job configurations and runbooks via GitHub and Confluence MCP servers during investigations.</p>
    <div class="skill-meta">
      <div class="meta-item">
        <strong>Before:</strong> GitHub + Confluence MCP configured
      </div>
      <div class="meta-item">
        <strong>Use when:</strong> Fetching config context
      </div>
    </div>
    <div class="skill-status available">✅ Available</div>
  </a>

  <a href="feedback-capture.html" class="category-card aiops">
    <div class="category-icon">💬</div>
    <h3>/aiops-skill:feedback-capture</h3>
    <p>Capture and store structured user feedback at the end of skill invocations with categorization and session tracking.</p>
    <div class="skill-meta">
      <div class="meta-item">
        <strong>Before:</strong> None
      </div>
      <div class="meta-item">
        <strong>Use when:</strong> End of RCA session
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
        <td><code>/aiops-skill:root-cause-analysis</code></td>
        <td>AIOps</td>
        <td>SSH, Splunk credentials</td>
        <td><span class="status-badge available">✅ Available</span></td>
      </tr>
      <tr>
        <td><code>/aiops-skill:logs-fetcher</code></td>
        <td>AIOps</td>
        <td>SSH access to log server</td>
        <td><span class="status-badge available">✅ Available</span></td>
      </tr>
      <tr>
        <td><code>/aiops-skill:context-fetcher</code></td>
        <td>AIOps</td>
        <td>GitHub + Confluence MCP</td>
        <td><span class="status-badge available">✅ Available</span></td>
      </tr>
      <tr>
        <td><code>/aiops-skill:feedback-capture</code></td>
        <td>AIOps</td>
        <td>None</td>
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
