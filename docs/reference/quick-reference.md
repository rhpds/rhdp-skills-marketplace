---
layout: default
title: Quick Reference
---

# Quick Reference

<div class="reference-badge">📚 Common Commands & Workflows</div>

Your go-to guide for RHDP Skills Marketplace commands and workflows.

---

## 🔧 Installation Commands

<div class="install-note" style="background: #e7f3ff; border-left: 4px solid #0969da; padding: 1rem; margin: 1rem 0; border-radius: 4px;">
ℹ️ <strong>For Claude Code & VS Code users only.</strong> These commands run in Claude Code chat after Claude Code is installed.<br>
<strong>Cursor users:</strong> Use the terminal install script instead (see <a href="../setup/cursor.html">Cursor setup</a>).
</div>

<div class="command-section">
  <h3>Add Marketplace</h3>
  <div class="command-options">
    <div class="command-option">
      <h4>With SSH Keys</h4>
      <pre><code>/plugin marketplace add rhpds/rhdp-skills-marketplace</code></pre>
    </div>
    <div class="command-option">
      <h4>Without SSH (HTTPS)</h4>
      <pre><code>/plugin marketplace add https://github.com/rhpds/rhdp-skills-marketplace</code></pre>
    </div>
  </div>
</div>

<div class="command-section">
  <h3>Install Plugins</h3>
  <pre><code>/plugin install showroom@rhdp-marketplace
/plugin install agnosticv@rhdp-marketplace
/plugin install health@rhdp-marketplace</code></pre>
</div>

<div class="command-section">
  <h3>Update Commands</h3>
  <div class="update-grid">
    <div class="update-card">
      <h4>Update Marketplace</h4>
      <pre><code>/plugin marketplace update</code></pre>
      <p class="command-note">Interactive: select marketplace, press 'u'</p>
    </div>
    <div class="update-card">
      <h4>Update Plugins</h4>
      <pre><code>/plugin update showroom@rhdp-marketplace
/plugin update agnosticv@rhdp-marketplace
/plugin update health@rhdp-marketplace</code></pre>
      <p class="command-note">Interactive: navigate to "Update now", press Enter</p>
    </div>
  </div>
</div>

---

## 📝 Showroom Workflows

<div class="workflow-cards">
  <div class="workflow-card">
    <div class="workflow-header">
      <span class="workflow-icon">🎓</span>
      <h3>Creating a Workshop Lab</h3>
    </div>
    <div class="workflow-steps-list">
      <div class="workflow-step-item">
        <span class="step-num">1</span>
        <code>/showroom:create-lab</code>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">2</span>
        <span>Answer prompts (name, abstract, technologies, module count)</span>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">3</span>
        <span>Step 2.5: Provide path to RHDP-provisioned Showroom repo</span>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">4</span>
        <span>Step 3.1: Showroom 1.5.1 scaffold written (default-site.yml, ui-config.yml, etc.)</span>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">5</span>
        <span>Review generated module content</span>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">6</span>
        <code>/showroom:verify-content</code>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">7</span>
        <span>Fix any issues</span>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">8</span>
        <code>/showroom:blog-generate</code> <span class="optional">(optional)</span>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">9</span>
        <span>Publish</span>
      </div>
    </div>
  </div>

  <div class="workflow-card">
    <div class="workflow-header">
      <span class="workflow-icon">🎭</span>
      <h3>Creating a Demo</h3>
    </div>
    <div class="workflow-steps-list">
      <div class="workflow-step-item">
        <span class="step-num">1</span>
        <code>/showroom:create-demo</code>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">2</span>
        <span>Answer prompts (name, abstract, technologies, audience level)</span>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">3</span>
        <span>Step 2.5: Provide path to RHDP-provisioned Showroom repo</span>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">4</span>
        <span>Step 3.1: Showroom 1.5.1 scaffold written (default-site.yml, ui-config.yml, etc.)</span>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">5</span>
        <span>Review generated section content</span>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">6</span>
        <code>/showroom:verify-content</code>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">7</span>
        <span>Present or publish</span>
      </div>
    </div>
  </div>
</div>

---

## ⚙️ AgnosticV Workflows

<div class="workflow-cards">
  <div class="workflow-card agv">
    <div class="workflow-header">
      <span class="workflow-icon">📦</span>
      <h3>Creating a New Catalog</h3>
    </div>
    <div class="workflow-steps-list">
      <div class="workflow-step-item">
        <span class="step-num">1</span>
        <code>cd ~/work/code/agnosticv</code>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">2</span>
        <code>/agnosticv:catalog-builder</code>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">3</span>
        <span>Choose mode: 1 (Full Catalog)</span>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">4</span>
        <span>Step 0: AgV path auto-detected, branch created from main</span>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">5</span>
        <span>Step 1: Single [1-7] context question (event type + lab ID + tech)</span>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">6</span>
        <span>Steps 2-9: Discovery, infra gate, auth, workloads, Showroom, __meta__</span>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">7</span>
        <span>Step 10: Path auto-generated (event) or asked (no-event)</span>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">8</span>
        <span>Files generated and auto-committed to branch</span>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">9</span>
        <code>/agnosticv:validator</code>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">10</span>
        <code>git push origin &lt;branch-name&gt;</code>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">11</span>
        <code>gh pr create --fill</code>
      </div>
    </div>
  </div>

  <div class="workflow-card agv">
    <div class="workflow-header">
      <span class="workflow-icon">✓</span>
      <h3>Validating a Catalog</h3>
    </div>
    <div class="workflow-steps-list">
      <div class="workflow-step-item">
        <span class="step-num">1</span>
        <code>cd ~/work/code/agnosticv/&lt;directory&gt;/&lt;catalog-name&gt;</code>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">2</span>
        <code>/agnosticv:validator</code>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">3</span>
        <span>Review validation report</span>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">4</span>
        <span>Fix errors and warnings</span>
      </div>
      <div class="workflow-step-item">
        <span class="step-num">5</span>
        <span>Re-validate</span>
      </div>
    </div>
  </div>
</div>

---

## 📁 Common File Locations

<div class="locations-grid">
  <div class="location-card">
    <h3>Claude Code / VS Code</h3>
    <pre><code>~/.claude/
├── plugins/
│   ├── installed/
│   │   ├── showroom@rhdp-marketplace/
│   │   ├── agnosticv@rhdp-marketplace/
│   │   └── health@rhdp-marketplace/
│   └── marketplaces/
│       └── rhdp-marketplace/
└── skills/  # Legacy (if migrating)</code></pre>
  </div>

  <div class="location-card">
    <h3>Cursor</h3>
    <pre><code>~/.cursor/
├── plugins/
└── skills/  # Legacy</code></pre>
  </div>

  <div class="location-card">
    <h3>AgnosticV Repository</h3>
    <pre><code>~/work/code/agnosticv/
├── agd_v2/         # Standard catalogs
│   └── &lt;catalog-name&gt;/
│       ├── common.yaml
│       ├── description.adoc
│       └── dev.yaml
├── openshift_cnv/  # CNV cluster catalogs
├── enterprise/     # Enterprise catalogs
└── summit-2026/    # Event catalogs
    └── lb####-short-name-cnv/</code></pre>
  </div>

  <div class="location-card">
    <h3>Showroom Content</h3>
    <pre><code>showroom-repo/
├── content/
│   └── modules/
│       └── ROOT/
│           ├── pages/
│           │   ├── index.adoc
│           │   ├── module-01.adoc
│           │   ├── module-02.adoc
│           │   └── module-03.adoc
│           ├── partials/
│           │   └── _attributes.adoc
│           └── nav.adoc
└── antora.yml</code></pre>
  </div>
</div>

---

## 🔍 Verification Commands

<div class="verification-box">
  <h3>Quick Checks</h3>
  <div class="verification-commands">
    <div class="verify-item">
      <h4>Check installed plugins</h4>
      <pre><code>/plugin list</code></pre>
    </div>
    <div class="verify-item">
      <h4>Check marketplace</h4>
      <pre><code>/plugin marketplace list</code></pre>
    </div>
    <div class="verify-item">
      <h4>Check AgnosticV repo</h4>
      <pre><code>cd ~/work/code/agnosticv && git status</code></pre>
    </div>
    <div class="verify-item">
      <h4>Validate YAML syntax</h4>
      <pre><code>yamllint common.yaml</code></pre>
    </div>
    <div class="verify-item">
      <h4>Test Showroom locally</h4>
      <pre><code>npm run dev</code></pre>
    </div>
  </div>
</div>

---

## 🆘 Troubleshooting Quick Fixes

<details>
<summary><strong>Skills not showing</strong></summary>

<pre><code># Restart Claude Code
# Then verify installation:
/plugin list</code></pre>

</details>

<details>
<summary><strong>Need to reinstall</strong></summary>

<pre><code># Uninstall plugins
/plugin uninstall showroom@rhdp-marketplace
/plugin uninstall agnosticv@rhdp-marketplace
/plugin uninstall health@rhdp-marketplace

# Reinstall
/plugin install showroom@rhdp-marketplace
/plugin install agnosticv@rhdp-marketplace
/plugin install health@rhdp-marketplace</code></pre>

</details>

<details>
<summary><strong>AgnosticV repo not found</strong></summary>

<pre><code>cd ~/work/code
git clone git@github.com:rhpds/agnosticv.git</code></pre>

</details>

<details>
<summary><strong>UUID collision</strong></summary>

<pre><code># Generate new UUID
uuidgen
# Update common.yaml:__meta__:asset_uuid</code></pre>

</details>

---

## 🔗 Support Resources

<div class="support-grid">
  <a href="https://github.com/rhpds/rhdp-skills-marketplace/issues" target="_blank" class="support-card">
    <div class="support-icon">🐛</div>
    <h4>GitHub Issues</h4>
    <p>Report bugs and request features</p>
  </a>

  <a href="https://redhat.enterprise.slack.com/archives/C04MLMA15MX" target="_blank" class="support-card">
    <div class="support-icon">💬</div>
    <h4>#forum-demo-developers</h4>
    <p>Get help from the community</p>
  </a>

  <a href="https://rhpds.github.io/rhdp-skills-marketplace" target="_blank" class="support-card">
    <div class="support-icon">📖</div>
    <h4>Documentation</h4>
    <p>Full guides and references</p>
  </a>

  <a href="https://github.com/rhpds/rhdp-skills-marketplace/blob/main/CHANGELOG.md" target="_blank" class="support-card">
    <div class="support-icon">📋</div>
    <h4>Changelog</h4>
    <p>Version history and updates</p>
  </a>
</div>

---

<div class="navigation-footer">
  <a href="../index.html" class="nav-button">← Back to Home</a>
</div>

<style>
.reference-badge {
  display: inline-block;
  background: linear-gradient(135deg, #0969da 0%, #0550ae 100%);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  font-weight: 600;
  margin: 1rem 0;
}

.command-section {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 1px solid #e1e4e8;
  border-radius: 12px;
  padding: 1.5rem;
  margin: 1.5rem 0;
}

.command-section h3 {
  margin-top: 0;
  color: #24292e;
}

.command-options {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1rem;
  margin-top: 1rem;
}

.command-option h4 {
  margin: 0 0 0.5rem 0;
  color: #586069;
  font-size: 0.875rem;
}

.command-option pre {
  margin: 0;
}

.command-section pre {
  background: #f6f8fa;
  padding: 1rem;
  border-radius: 6px;
  margin: 0.5rem 0 0 0;
  overflow-x: auto;
}

.update-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1rem;
  margin-top: 1rem;
}

.update-card h4 {
  margin: 0 0 0.5rem 0;
  color: #24292e;
}

.update-card pre {
  margin: 0.5rem 0;
}

.command-note {
  margin: 0.5rem 0 0 0;
  color: #586069;
  font-size: 0.875rem;
  font-style: italic;
}

.workflow-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.workflow-card {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 12px;
  padding: 1.5rem;
}

.workflow-card.agv {
  border-color: #0969da;
}

.workflow-header {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-bottom: 1.5rem;
  padding-bottom: 1rem;
  border-bottom: 1px solid #e1e4e8;
}

.workflow-icon {
  font-size: 2rem;
}

.workflow-header h3 {
  margin: 0;
  color: #24292e;
  font-size: 1.125rem;
}

.workflow-steps-list {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.workflow-step-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  font-size: 0.875rem;
}

.step-num {
  flex-shrink: 0;
  width: 24px;
  height: 24px;
  background: #EE0000;
  color: white;
  border-radius: 50%;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  font-size: 0.75rem;
}

.workflow-step-item code {
  background: #f6f8fa;
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  color: #EE0000;
  font-size: 0.8rem;
}

.optional {
  color: #586069;
  font-style: italic;
}

.locations-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.location-card {
  background: #f6f8fa;
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
}

.location-card h3 {
  margin-top: 0;
  margin-bottom: 1rem;
  color: #24292e;
  font-size: 1rem;
}

.location-card pre {
  background: white;
  padding: 1rem;
  border-radius: 6px;
  margin: 0;
  overflow-x: auto;
}

.verification-box {
  background: linear-gradient(135deg, #d4edda 0%, #ffffff 100%);
  border: 2px solid #28a745;
  border-radius: 12px;
  padding: 2rem;
  margin: 2rem 0;
}

.verification-box h3 {
  margin-top: 0;
  color: #155724;
}

.verification-commands {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1rem;
  margin-top: 1rem;
}

.verify-item h4 {
  margin: 0 0 0.5rem 0;
  color: #155724;
  font-size: 0.875rem;
}

.verify-item pre {
  background: white;
  padding: 0.75rem;
  border-radius: 6px;
  margin: 0;
}

.support-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin: 2rem 0;
}

.support-card {
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

.support-card:hover {
  border-color: #EE0000;
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
}

.support-icon {
  font-size: 2.5rem;
  margin-bottom: 0.5rem;
}

.support-card h4 {
  margin: 0.5rem 0;
  color: #24292e;
}

.support-card p {
  margin: 0;
  color: #586069;
  font-size: 0.875rem;
}

.navigation-footer {
  display: flex;
  justify-content: center;
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
