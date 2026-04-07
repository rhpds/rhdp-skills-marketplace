---
layout: default
title: /agnosticv:validator
---

# /agnosticv:validator

<div class="reference-badge">✅ Catalog Validator</div>

Validate AgnosticV catalog configurations against RHDP best practices before creating a PR.

---

## What You'll Need Before Starting

<div class="workflow-diagram">
  <a href="validator-workflow.svg" target="_blank">
    <img src="validator-workflow.svg" alt="validator workflow diagram" style="max-width: 100%; height: auto; border-radius: 8px; border: 1px solid #e1e4e8;" />
  </a>
  <p style="text-align: center; color: #586069; font-size: 0.875rem; margin-top: 0.5rem;">Click to view full workflow diagram</p>
</div>

### Prerequisites

<div class="category-grid">
  <div class="category-card">
    <div class="category-icon">📁</div>
    <h4>Path to Catalog Directory</h4>
    <pre><code>~/work/code/agnosticv/agd_v2/my-workshop/
# Must contain at minimum: common.yaml</code></pre>
  </div>

  <div class="category-card">
    <div class="category-icon">📋</div>
    <h4>Catalog Files</h4>
    <ul>
      <li><strong>common.yaml</strong> — required</li>
      <li>dev.yaml — optional</li>
      <li>prod.yaml — optional</li>
      <li>description.adoc — optional</li>
    </ul>
  </div>

  <div class="category-card">
    <div class="category-icon">🔐</div>
    <h4>Access Needed</h4>
    <ul>
      <li>Read access to catalog directory</li>
      <li>AgnosticV repository cloned locally</li>
      <li>Git configured</li>
    </ul>
  </div>
</div>

---

## Quick Start

<ol class="steps">
  <li><div class="step-content"><h4>Navigate to Your Catalog</h4><p>Open your AgnosticV repository</p></div></li>
  <li><div class="step-content"><h4>Run the Validator</h4><p><code>/agnosticv:validator</code></p></div></li>
  <li><div class="step-content"><h4>Confirm Path</h4><p>Skill auto-detects from CLAUDE.md or asks for catalog path</p></div></li>
  <li><div class="step-content"><h4>Review Report</h4><p>Errors → Warnings → Suggestions</p></div></li>
  <li><div class="step-content"><h4>Fix & Re-run</h4><p>Run again after fixes to confirm clean</p></div></li>
</ol>

---

## What Gets Validated

<div class="mode-tabs">
  <div class="mode-tab">
    <h4>Always Checked</h4>
    <ul>
      <li>YAML syntax (common.yaml, dev.yaml, prod.yaml)</li>
      <li>UUID format and uniqueness across catalog</li>
      <li>Required <code>__meta__</code> fields (asset_uuid, owners, deployer)</li>
      <li>Category correctness (Workshops / Demos / Sandboxes / Brand_Events)</li>
      <li>Branch naming (no <code>feature/</code> prefix)</li>
      <li>No <code>anarchy.namespace</code> defined</li>
      <li><code>catalog.reportingLabels.primaryBU</code> present</li>
    </ul>
  </div>

  <div class="mode-tab">
    <h4>OCP Cluster Catalogs</h4>
    <ul>
      <li>Component item ends with <code>/prod</code> (not <code>/dev</code>)</li>
      <li>OCP version supported (4.18 / 4.20 / 4.21)</li>
      <li>AWS cloud provider approval warning</li>
      <li>Auth workload present (<code>ocp4_workload_authentication</code>)</li>
      <li>Showroom version ≥ v1.5.3</li>
      <li>Multi-user worker scaling</li>
      <li>LiteMaaS includes if LiteLLM workload present</li>
    </ul>
  </div>

  <div class="mode-tab">
    <h4>Sandbox API Catalogs</h4>
    <ul>
      <li><code>sandboxes:</code> under <code>__meta__</code> (not top-level)</li>
      <li><code>cloud_selector</code> labels present</li>
      <li><code>quota</code> and <code>limit_range</code> format (full spec vs shorthand)</li>
      <li><code>config: namespace</code> for Tenant CI</li>
      <li><code>keycloak: "yes"</code> warning if Keycloak user role not in workloads</li>
      <li><code>sandbox_api.destroy.catch_all</code> if external resources present</li>
    </ul>
  </div>

  <div class="mode-tab">
    <h4>Cloud VMs Catalogs</h4>
    <ul>
      <li>RHEL image version</li>
      <li>VM sizing recommendations</li>
      <li>Port configuration</li>
      <li>Multi-user isolation warnings</li>
      <li>Showroom <code>vm_workload_showroom</code> config</li>
    </ul>
  </div>
</div>

---

## Output Format

The validator produces three severity levels:

<div class="category-grid">
  <div class="category-card">
    <div class="category-icon">🔴</div>
    <h4>Errors — Must Fix</h4>
    <p>Will cause deployment failure or catalog rejection. PR should not be created until resolved.</p>
    <ul>
      <li>Invalid UUID or duplicate UUID</li>
      <li>YAML syntax errors</li>
      <li>Component item pointing to <code>/dev</code></li>
      <li>Missing required <code>__meta__</code> fields</li>
    </ul>
  </div>

  <div class="category-card">
    <div class="category-icon">🟡</div>
    <h4>Warnings — Should Fix</h4>
    <p>May cause issues or violate RHDP standards. Fix before merging.</p>
    <ul>
      <li>AWS cloud provider without approval note</li>
      <li>Showroom version below minimum</li>
      <li>Missing <code>reportingLabels.primaryBU</code></li>
      <li>Sandbox quota using shorthand format</li>
    </ul>
  </div>

  <div class="category-card">
    <div class="category-icon">🔵</div>
    <h4>Suggestions — Nice to Have</h4>
    <p>Best practices that improve quality but are not blocking.</p>
    <ul>
      <li>Description starts with product name</li>
      <li>Keywords include relevant technology</li>
      <li>dev.yaml overrides for fast iteration</li>
    </ul>
  </div>
</div>

---

## Common Workflows

<ol class="steps">
  <li>
    <div class="step-content">
      <h4>Workflow 1: Validate Before PR (Most Common)</h4>
      <pre><code>/agnosticv:validator
→ Path auto-detected from CLAUDE.md
→ Runs all checks for your config type
→ Report: 0 errors, 2 warnings, 1 suggestion
→ Fix warnings → re-run → create PR</code></pre>
    </div>
  </li>

  <li>
    <div class="step-content">
      <h4>Workflow 2: Validate After catalog-builder</h4>
      <pre><code>/agnosticv:catalog-builder   # generates files
→ review generated files
/agnosticv:validator         # catches any issues
→ fix before committing</code></pre>
    </div>
  </li>

  <li>
    <div class="step-content">
      <h4>Workflow 3: Debug Deployment Failure</h4>
      <pre><code>/agnosticv:validator
→ Point to failing catalog
→ Check for errors missed in PR review
→ Fix → re-deploy</code></pre>
    </div>
  </li>
</ol>

---

## Troubleshooting

<details>
<summary><strong>Skill not found?</strong></summary>

<ul>
  <li>Restart Claude Code</li>
  <li>Check installation: <code>ls ~/.claude/skills/agnosticv-validator</code></li>
  <li>See <a href="../reference/troubleshooting.html">Troubleshooting Guide</a></li>
</ul>

</details>

<details>
<summary><strong>UUID collision error?</strong></summary>

<pre><code># Generate a new UUID
python3 -c "import uuid; print(uuid.uuid4())"
# Update asset_uuid in common.yaml</code></pre>

</details>

<details>
<summary><strong>sandboxes: placement error?</strong></summary>

<div class="priority-box">
  <h4>Common Sandbox API mistake:</h4>
  <p><code>sandboxes:</code> must be under <code>__meta__:</code>, not at the top level of common.yaml.</p>
  <pre><code># ✅ Correct
__meta__:
  sandboxes:
  - kind: OcpSandbox

# ❌ Wrong — sandbox API won't pick it up
sandboxes:
- kind: OcpSandbox</code></pre>
</div>

</details>

<details>
<summary><strong>limit_range format warning?</strong></summary>

<p>The sandbox API requires full Kubernetes spec format — shorthand is not yet supported:</p>
<pre><code># ✅ Full spec (works today)
limit_range:
  spec:
    limits:
    - type: Container
      default:
        cpu: 500m
        memory: 512Mi
      defaultRequest:
        cpu: 50m
        memory: 128Mi

# ⚠️ Shorthand (sandbox API fix pending)
limit_range:
  default:
    cpu: 500m</code></pre>

</details>

---

## Related Skills

<div class="links-grid">
  <a href="agnosticv-catalog-builder.html" class="link-card">
    <h4>/agnosticv:catalog-builder</h4>
    <p>Create catalog items — run validator after</p>
  </a>

  <a href="deployment-health-checker.html" class="link-card">
    <h4>/health:deployment-validator</h4>
    <p>Validate deployed environment health</p>
  </a>

  <a href="create-lab.html" class="link-card">
    <h4>/showroom:create-lab</h4>
    <p>Create Showroom workshop content</p>
  </a>
</div>

---

<div class="navigation-footer">
  <a href="agnosticv-catalog-builder.html" class="nav-button">← /agnosticv:catalog-builder</a>
  <a href="index.html" class="nav-button">Back to Skills →</a>
</div>
