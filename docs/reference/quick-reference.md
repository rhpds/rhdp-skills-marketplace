---
layout: default
title: Quick Reference
---

# Quick Reference

<div class="reference-badge">Common Commands &amp; Workflows</div>

Your go-to guide for RHDP Skills Marketplace commands and workflows.

---

## Installation Commands

<div class="callout callout-info">
<span class="callout-icon">ℹ️</span>
<div class="callout-body">
<strong>For Claude Code &amp; VS Code users only.</strong> These commands run in Claude Code chat after Claude Code is installed.<br>
<strong>Cursor users:</strong> Use the terminal install script instead (see <a href="../setup/cursor.html">Cursor setup</a>).
</div>
</div>

<div class="category-grid">
<div class="category-card">
<span class="category-icon">📦</span>
<h3>Add Marketplace</h3>

**With SSH Keys:**
```
/plugin marketplace add rhpds/rhdp-skills-marketplace
```

**Without SSH (HTTPS):**
```
/plugin marketplace add https://github.com/rhpds/rhdp-skills-marketplace
```

</div>
<div class="category-card">
<span class="category-icon">🔌</span>
<h3>Install Plugins</h3>

```
/plugin install showroom@rhdp-marketplace
/plugin install agnosticv@rhdp-marketplace
/plugin install health@rhdp-marketplace
```

</div>
<div class="category-card">
<span class="category-icon">🔄</span>
<h3>Update Marketplace</h3>

```
/plugin marketplace update
```

<p class="text-muted">Interactive: select marketplace, press 'u'</p>
</div>
<div class="category-card">
<span class="category-icon">⬆️</span>
<h3>Update Plugins</h3>

```
/plugin update showroom@rhdp-marketplace
/plugin update agnosticv@rhdp-marketplace
/plugin update health@rhdp-marketplace
```

</div>
</div>

---

## Showroom Workflows

<div class="category-grid">
<div class="category-card">
<span class="category-icon">🎓</span>
<h3>Creating a Workshop Lab</h3>
<ol class="steps">
<li><div class="step-content"><h4>Invoke</h4><p><code>/showroom:create-lab</code></p></div></li>
<li><div class="step-content"><h4>Answer prompts</h4><p>Name, abstract, technologies, module count</p></div></li>
<li><div class="step-content"><h4>Provide repo path</h4><p>Path to RHDP-provisioned Showroom repo</p></div></li>
<li><div class="step-content"><h4>Scaffold configured</h4><p>site.yml, ui-config.yml, Showroom 1.5.3</p></div></li>
<li><div class="step-content"><h4>Review content</h4><p>Review generated module content</p></div></li>
<li><div class="step-content"><h4>Verify</h4><p><code>/showroom:verify-content</code></p></div></li>
<li><div class="step-content"><h4>Fix &amp; publish</h4><p>Fix any issues, then publish</p></div></li>
</ol>
</div>

<div class="category-card">
<span class="category-icon">🎬</span>
<h3>Creating a Demo</h3>
<ol class="steps">
<li><div class="step-content"><h4>Invoke</h4><p><code>/showroom:create-demo</code></p></div></li>
<li><div class="step-content"><h4>Answer prompts</h4><p>Name, abstract, technologies, audience level</p></div></li>
<li><div class="step-content"><h4>Provide repo path</h4><p>Path to RHDP-provisioned Showroom repo</p></div></li>
<li><div class="step-content"><h4>Scaffold configured</h4><p>site.yml, ui-config.yml, Showroom 1.5.3</p></div></li>
<li><div class="step-content"><h4>Review &amp; verify</h4><p><code>/showroom:verify-content</code></p></div></li>
<li><div class="step-content"><h4>Present or publish</h4><p>Demo is ready</p></div></li>
</ol>
</div>
</div>

---

## AgnosticV Workflows

<div class="category-grid">
<div class="category-card">
<span class="category-icon">📦</span>
<h3>Creating a New Catalog</h3>
<ol class="steps">
<li><div class="step-content"><h4>Navigate</h4><p><code>cd ~/work/code/agnosticv</code></p></div></li>
<li><div class="step-content"><h4>Invoke</h4><p><code>/agnosticv:catalog-builder</code></p></div></li>
<li><div class="step-content"><h4>Choose mode</h4><p>1 (Full Catalog)</p></div></li>
<li><div class="step-content"><h4>AgV path auto-detected</h4><p>Branch created from main</p></div></li>
<li><div class="step-content"><h4>Context question</h4><p>Single [1-7] question: event type + lab ID + tech</p></div></li>
<li><div class="step-content"><h4>Discovery steps 2–9</h4><p>Infra gate, auth, workloads, Showroom, __meta__</p></div></li>
<li><div class="step-content"><h4>Files generated</h4><p>Auto-committed to branch</p></div></li>
<li><div class="step-content"><h4>Validate</h4><p><code>/agnosticv:validator</code></p></div></li>
<li><div class="step-content"><h4>Push &amp; PR</h4><p><code>git push origin &lt;branch-name&gt;</code> then <code>gh pr create --fill</code></p></div></li>
</ol>
</div>

<div class="category-card">
<span class="category-icon">✓</span>
<h3>Validating a Catalog</h3>
<ol class="steps">
<li><div class="step-content"><h4>Navigate</h4><p><code>cd ~/work/code/agnosticv/&lt;directory&gt;/&lt;catalog-name&gt;</code></p></div></li>
<li><div class="step-content"><h4>Validate</h4><p><code>/agnosticv:validator</code></p></div></li>
<li><div class="step-content"><h4>Review report</h4><p>Check errors and warnings</p></div></li>
<li><div class="step-content"><h4>Fix &amp; re-validate</h4><p>Address issues, run again</p></div></li>
</ol>
</div>
</div>

---

## Common File Locations

<div class="category-grid">
<div class="category-card">
<span class="category-icon">🚀</span>
<h3>Claude Code / VS Code</h3>

```
~/.claude/
├── plugins/
│   ├── installed/
│   │   ├── showroom@rhdp-marketplace/
│   │   ├── agnosticv@rhdp-marketplace/
│   │   └── health@rhdp-marketplace/
│   └── marketplaces/
│       └── rhdp-marketplace/
└── skills/  # Legacy (if migrating)
```

</div>
<div class="category-card">
<span class="category-icon">⚡</span>
<h3>Cursor</h3>

```
~/.cursor/
├── plugins/
└── skills/  # Legacy
```

</div>
<div class="category-card">
<span class="category-icon">⚙️</span>
<h3>AgnosticV Repository</h3>

```
~/work/code/agnosticv/
├── agd_v2/         # Standard catalogs
│   └── <catalog-name>/
│       ├── common.yaml
│       ├── description.adoc
│       └── dev.yaml
├── openshift_cnv/  # CNV cluster catalogs
├── enterprise/     # Enterprise catalogs
└── summit-2026/    # Event catalogs
    └── lb####-short-name-cnv/
```

</div>
<div class="category-card">
<span class="category-icon">📝</span>
<h3>Showroom Content</h3>

```
showroom-repo/
├── content/
│   └── modules/
│       └── ROOT/
│           ├── pages/
│           │   ├── index.adoc
│           │   ├── module-01.adoc
│           │   └── module-02.adoc
│           ├── partials/
│           │   └── _attributes.adoc
│           └── nav.adoc
└── antora.yml
```

</div>
</div>

---

## Verification Commands

<div class="category-grid">
<div class="category-card">
<span class="category-icon">🔌</span>
<h3>Check installed plugins</h3>

```
/plugin list
```

</div>
<div class="category-card">
<span class="category-icon">🔍</span>
<h3>Check marketplace</h3>

```
/plugin marketplace list
```

</div>
<div class="category-card">
<span class="category-icon">📁</span>
<h3>Check AgnosticV repo</h3>

```
cd ~/work/code/agnosticv && git status
```

</div>
<div class="category-card">
<span class="category-icon">✓</span>
<h3>Validate YAML syntax</h3>

```
yamllint common.yaml
```

</div>
<div class="category-card">
<span class="category-icon">🖥️</span>
<h3>Test Showroom locally</h3>

```
npm run dev
```

</div>
</div>

---

## Troubleshooting Quick Fixes

<details>
<summary>Skills not showing</summary>

```
# Restart Claude Code
# Then verify installation:
/plugin list
```

</details>

<details>
<summary>Need to reinstall</summary>

```
# Uninstall plugins
/plugin uninstall showroom@rhdp-marketplace
/plugin uninstall agnosticv@rhdp-marketplace
/plugin uninstall health@rhdp-marketplace

# Reinstall
/plugin install showroom@rhdp-marketplace
/plugin install agnosticv@rhdp-marketplace
/plugin install health@rhdp-marketplace
```

</details>

<details>
<summary>AgnosticV repo not found</summary>

```
cd ~/work/code
git clone git@github.com:rhpds/agnosticv.git
```

</details>

<details>
<summary>UUID collision</summary>

```
# Generate new UUID
uuidgen
# Update common.yaml:__meta__:asset_uuid
```

</details>

---

## Support Resources

<div class="links-grid">
  <a href="https://github.com/rhpds/rhdp-skills-marketplace/issues" target="_blank" class="link-card">
    <h4>GitHub Issues</h4>
    <p>Report bugs and request features</p>
  </a>
  <a href="https://redhat.enterprise.slack.com/archives/C04MLMA15MX" target="_blank" class="link-card">
    <h4>#forum-demo-developers</h4>
    <p>Get help from the community</p>
  </a>
  <a href="https://rhpds.github.io/rhdp-skills-marketplace" target="_blank" class="link-card">
    <h4>Documentation</h4>
    <p>Full guides and references</p>
  </a>
  <a href="https://github.com/rhpds/rhdp-skills-marketplace/blob/main/CHANGELOG.md" target="_blank" class="link-card">
    <h4>Changelog</h4>
    <p>Version history and updates</p>
  </a>
</div>

<div class="navigation-footer">
  <a href="../index.html" class="nav-button">← Back to Home</a>
</div>
