---
layout: default
title: /agnosticv:catalog-builder
---

# /agnosticv:catalog-builder

<div class="skill-badge">🔧 Catalog Builder</div>

Create or update AgnosticV catalog files for RHDP deployments (unified skill).

---

## 📋 What You'll Need Before Starting

<div class="workflow-diagram">
  <a href="catalog-builder-workflow.svg" target="_blank">
    <img src="catalog-builder-workflow.svg" alt="catalog-builder workflow diagram" style="max-width: 100%; height: auto; border-radius: 8px; border: 1px solid #e1e4e8;" />
  </a>
  <p style="text-align: center; color: #586069; font-size: 0.875rem; margin-top: 0.5rem;">Click to view full workflow diagram</p>
</div>

### Prerequisites

<div class="prereq-grid">
  <div class="prereq-item">
    <div class="prereq-icon">📁</div>
    <h4>Clone AgnosticV Repository</h4>
    <pre><code>cd ~/work/code
git clone git@github.com:rhpds/agnosticv.git
cd agnosticv</code></pre>
  </div>

  <div class="prereq-item">
    <div class="prereq-icon">🔐</div>
    <h4>Verify RHDP Access</h4>
    <ul>
      <li>Write access to AgnosticV repository</li>
      <li>Test: <code>gh repo view rhpds/agnosticv</code></li>
      <li>Ability to create pull requests</li>
    </ul>
  </div>

  <div class="prereq-item">
    <div class="prereq-icon">📝</div>
    <h4>Workshop Content Ready</h4>
    <ul>
      <li>Workshop lab content (from <code>/showroom:create-lab</code>)</li>
      <li>Infrastructure requirements (CNV, AWS, etc.)</li>
      <li>Workload list (OpenShift AI, AAP, etc.)</li>
    </ul>
  </div>
</div>

### What You'll Need (By Mode)

<div class="mode-tabs">
  <div class="mode-tab">
    <h4>Mode 1: Full Catalog</h4>
    <ul>
      <li>Catalog name (e.g., "Agentic AI on OpenShift")</li>
      <li>Category (Workshops, Demos, or Sandboxes)</li>
      <li>Infrastructure type (CNV multi-node, AWS, SNO, etc.)</li>
      <li>Workloads to deploy</li>
      <li>Multi-user requirements (yes/no)</li>
    </ul>
  </div>

  <div class="mode-tab">
    <h4>Mode 2: Description Only</h4>
    <ul>
      <li>Path to Showroom repository</li>
      <li>Brief overview (2-3 sentences starting with product name)</li>
    </ul>
  </div>

  <div class="mode-tab">
    <h4>Mode 3: Info Template</h4>
    <ul>
      <li>Data keys from <code>agnosticd_user_info.data</code></li>
    </ul>
  </div>

  <div class="mode-tab">
    <h4>Mode 4: Virtual CI (published/)</h4>
    <ul>
      <li>Base component path (e.g. <code>openshift_cnv/kafka-developer-workshop-cnv</code>)</li>
      <li>Handles uniqueness check, UUID, dev restriction, prod.yaml version pinning</li>
      <li>Supports bulk processing of multiple base components</li>
    </ul>
  </div>
</div>

---

## 🚀 Quick Start

<div class="quick-start-steps">
  <div class="quick-step">
    <div class="quick-step-number">1</div>
    <div class="quick-step-content">
      <h4>Navigate to Repository</h4>
      <p>Open your AgnosticV repository directory</p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">2</div>
    <div class="quick-step-content">
      <h4>Run Catalog Builder</h4>
      <p><code>/agnosticv:catalog-builder</code></p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">3</div>
    <div class="quick-step-content">
      <h4>Choose Mode</h4>
      <p>Select: Full Catalog / Description Only / Info Template</p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">4</div>
    <div class="quick-step-content">
      <h4>Answer Questions</h4>
      <p>Follow guided prompts</p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">5</div>
    <div class="quick-step-content">
      <h4>Review & Commit</h4>
      <p>Files auto-committed to new branch</p>
    </div>
  </div></div>

---

## 📁 What It Can Generate

<div class="mode-generation-grid">
  <div class="mode-generation-card">
    <div class="mode-header">Mode 1: Full Catalog</div>
    <p>Creates complete catalog with all files:</p>
    <pre><code>agd_v2/your-catalog-name/
├── common.yaml
├── dev.yaml
├── description.adoc
└── info-message-template.adoc</code></pre>
  </div>

  <div class="mode-generation-card">
    <div class="mode-header">Mode 2: Description Only</div>
    <p>Updates just the description:</p>
    <pre><code>agd_v2/your-catalog-name/
└── description.adoc</code></pre>
  </div>

  <div class="mode-generation-card">
    <div class="mode-header">Mode 3: Info Template</div>
    <p>Creates user notification:</p>
    <pre><code>agd_v2/your-catalog-name/
└── info-message-template.adoc</code></pre>
  </div>
</div>

---

## 🔄 Common Workflows

<div class="workflow-steps">
  <div class="workflow-step">
    <div class="workflow-icon">1️⃣</div>
    <div class="workflow-content">
      <h4>Workflow 1: Create Full Catalog from Scratch</h4>
      <pre><code>/agnosticv:catalog-builder
→ Mode: 1 (Full Catalog)
→ Step 0: AgV path auto-detected, branch created
→ Step 1: Q1=type (Workshop/Demo/Sandbox), Q2=event?, Q3=tech
→ Step 2: Discovery searches agd_v2/ + openshift_cnv/
→ Step 3: Infrastructure gate (OCP cluster or VMs)
→ Step 4: Auth (unified ocp4_workload_authentication)
→ Step 5: Workloads + LiteMaaS
→ Step 6: Showroom (recommended name shown)
→ Step 7: Catalog details (name, description, maintainer)
→ Step 9: __meta__, includes, event restrictions
→ Step 10: Path auto-generated (event) or asked (no-event)
→ Generate all 4 files, auto-commit to branch</code></pre>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">2️⃣</div>
    <div class="workflow-content">
      <h4>Workflow 2: Update Description After Content Changes</h4>
      <pre><code>/agnosticv:catalog-builder
→ Mode: 2 (Description Only)
→ Point to Showroom repo
→ Auto-extracts modules and technologies
→ Generates description.adoc
→ Auto-commits to branch</code></pre>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">3️⃣</div>
    <div class="workflow-content">
      <h4>Workflow 3: Add Info Template for User Data</h4>
      <pre><code>/agnosticv:catalog-builder
→ Mode: 3 (Info Template)
→ Specify data keys from workload
→ Generates template with placeholders
→ Shows how to use agnosticd_user_info</code></pre>
    </div>
  </div>
</div>

---

## 📝 Mode Details

<details>
<summary><strong>Mode 1: Full Catalog - Detailed Workflow</strong></summary>

<div class="detail-content">
  <h4>What it creates:</h4>
  <ul>
    <li><strong>common.yaml</strong> - Main configuration (infrastructure, auth, workloads, includes)</li>
    <li><strong>dev.yaml</strong> - Development environment overrides</li>
    <li><strong>description.adoc</strong> - UI description following RHDP structure</li>
    <li><strong>info-message-template.adoc</strong> - User notification template</li>
  </ul>

  <h4>Step-by-step process:</h4>
  <ol>
    <li><strong>Step 0 — Setup:</strong> AgV path auto-detected; branch created from main (no feature/ prefix)</li>
    <li><strong>Step 1 — Context:</strong> 3 questions: Q1=Workshop/Demo/Sandbox, Q2=Is this for an event? (Summit 2026 / RH One 2026 / Other), Q3=Technologies. Event selection overrides category to Brand_Events and asks for Lab ID.</li>
    <li><strong>Step 2 — Discovery:</strong> Searches <code>agd_v2/</code> and <code>openshift_cnv/</code>; shows reference catalogs with <code>[OCP cluster]</code> or <code>[RHEL/AAP VMs]</code> labels</li>
    <li><strong>Step 3 — Infrastructure gate:</strong> Asks OCP or RHEL/AAP VMs, then routes to a separate @reference file per infra type:
      <ul>
        <li><strong>OCP path (<code>ocp-catalog-questions.md</code>):</strong> SNO or multinode, OCP version (4.18/4.20/4.21), pool with <code>/prod</code> suffix, autoscale, AWS gate; auth (unified <code>ocp4_workload_authentication</code> + provider); OCP workloads + LiteMaaS; Showroom with <code>ocp4_workload_ocp_console_embed</code>; multi-user with worker scaling</li>
        <li><strong>VM path (<code>cloud-vms-base-catalog-questions.md</code>):</strong> CNV or AWS, RHEL image, sizing, ports; auth skipped (OS-level only); VM workloads; <code>vm_workload_showroom</code> with <code>showroom_git_repo</code>/<code>showroom_git_ref</code>; multi-user isolation warning</li>
      </ul>
    </li>
    <li><strong>Step 7 — Catalog details:</strong> Display name, short name, description (starts with product name), maintainer name and email</li>
    <li><strong>Step 9 — __meta__:</strong> Deployer actions (start/stop only); <code>remove_workloads</code> via <code>sandbox_api.actions.destroy.catch_all</code>; product label + family; keywords</li>
    <li><strong>Step 9.1 — Includes:</strong> Event restriction in <code>common.yaml</code> (summit-devs or rh1-2026-devs); AWS extras; LiteMaaS (<code>litemaas-master_api</code> + <code>litellm_metadata</code>); workload-specific TODO</li>
    <li><strong>Step 10 — Path:</strong> Event catalogs → auto-generated path (e.g. <code>summit-2026/lb2298-short-cnv</code>); no-event → asks subdirectory</li>
    <li>UUID auto-generated and validated for uniqueness; files committed to branch</li>
  </ol>

  <h4>Naming Standards (Developer Guidelines):</h4>
  <ul>
    <li>AgV config: <code>summit-2026/lbXXXX-short-name-cnv</code></li>
    <li>Showroom repo: <code>short-name-showroom</code></li>
    <li>OCP pool: <code>cnv-cluster-4.18/prod</code> (always <code>/prod</code> suffix)</li>
    <li>Collections: <code>tag: "{{ tag }}"</code> for standard; fixed tag <code>≥ v1.5.3</code> for showroom</li>
  </ul>

  <h4>Event branding (mandatory — Question 2 never skipped):</h4>
  <ul>
    <li>Event catalogs: <code>category: Brand_Events</code>, <code>Brand_Event: Red_Hat_Summit_2026</code> label, Lab ID keyword, event access restriction include</li>
    <li><code>anarchy.namespace</code> — NEVER define</li>
    <li><code>catalog.reportingLabels.primaryBU</code> — ALWAYS define</li>
  </ul>

  <h4>Bundled real examples (no network needed):</h4>
  <ul>
    <li><strong>ocp-demo/</strong> — OCP with CNV pool</li>
    <li><strong>ocp-aws/</strong> — OCP with AWS pool</li>
    <li><strong>ocp-cnv/</strong> — openshift_cnv pool</li>
    <li><strong>cloud-vms-base/</strong> — RHEL VMs on AWS</li>
    <li><strong>published-virtual-ci/</strong> — Virtual CI structure</li>
  </ul>
</div>

</details>

<details>
<summary><strong>Mode 2: Description Only - RHDP Official Structure</strong></summary>

<div class="detail-content">
  <h4>v1.8.0: Enhanced with full module analysis</h4>
  
  <p><strong>With Showroom content:</strong></p>
  <ul>
    <li>Reads ALL modules (not just index.adoc)</li>
    <li>Extracts overview from index.adoc</li>
    <li>Detects Red Hat products across all modules</li>
    <li>Extracts version numbers</li>
    <li>Identifies technical topics</li>
    <li>Shows extracted data for review before generating</li>
  </ul>

  <p><strong>Without Showroom content:</strong></p>
  <ul>
    <li>Guided questions for RHDP structure</li>
    <li>Brief overview (3-4 sentences)</li>
    <li>Warnings (optional)</li>
    <li>Guide link</li>
    <li>Featured products (max 3-4)</li>
    <li>Module details (title + 2-3 bullets per module)</li>
  </ul>

  <h4>Generated description.adoc follows RHDP structure:</h4>
  <ol>
    <li>Brief Overview (3-4 sentences max, starts with product name)</li>
    <li>Warnings (optional, after overview)</li>
    <li>Lab/Demo Guide (link to Showroom)</li>
    <li>Featured Technology and Products (max 3-4)</li>
    <li>Detailed Overview (each module + 2-3 bullets)</li>
    <li>Authors (from __meta__.owners)</li>
    <li>Support (Content + Environment)</li>
  </ol>
</div>

</details>

<details>
<summary><strong>Mode 3: Info Template - User Data Sharing</strong></summary>

<div class="detail-content">
  <h4>Documents how to share data with users:</h4>
  
  <pre><code># In your workload:
- name: Save user data
  agnosticd.core.agnosticd_user_info:
    data:
      api_url: "{{ my_api_url }}"
      api_key: "{{ my_api_key }}"</code></pre>

  <p>Template uses: <code>{api_url}</code> and <code>{api_key}</code></p>

  <h4>Steps:</h4>
  <ol>
    <li>Select Info Template mode</li>
    <li>Git workflow (automatic)</li>
    <li>Specify data keys from agnosticd_user_info.data</li>
    <li>Optional: add lab code (e.g., LB1234)</li>
    <li>Template generated with proper placeholders</li>
  </ol>
</div>

</details>

---

## 💡 Tips & Best Practices

<div class="tips-grid">
  <div class="tip-card">
    <h4>🏷️ Start with Product Name</h4>
    <p>Description overview must start with product, not "This workshop"</p>
  </div>
  <div class="tip-card">
    <h4>📚 Use Real Examples</h4>
    <p>Reference existing catalogs for patterns</p>
  </div>
  <div class="tip-card">
    <h4>✓ Validate Before PR</h4>
    <p>Always run <code>/agnosticv:validator</code></p>
  </div>
  <div class="tip-card">
    <h4>🧪 Test in Dev First</h4>
    <p>Use dev.yaml for testing</p>
  </div>
  <div class="tip-card">
    <h4>🌿 No feature/ Prefix</h4>
    <p>Branch names should be descriptive without feature/</p>
  </div>
  <div class="tip-card">
    <h4>📝 Convert Lists to Strings</h4>
    <p>For info templates: <code>{{ my_list | join(', ') }}</code></p>
  </div>
</div>

---

## 🆘 Troubleshooting

<details>
<summary><strong>Skill not found?</strong></summary>

<ul>
  <li>Restart Claude Code or VS Code</li>
  <li>Verify installation: <code>ls ~/.claude/skills/agnosticv-catalog-builder</code></li>
  <li>Check the <a href="../reference/troubleshooting.html">Troubleshooting Guide</a></li>
</ul>

</details>

<details>
<summary><strong>Branch already exists?</strong></summary>

<pre><code>git branch -D old-branch
# Or use different name</code></pre>

</details>

<details>
<summary><strong>UUID collision?</strong></summary>

<ul>
  <li>Skill auto-regenerates unique UUID</li>
  <li>Check against existing catalogs automatically</li>
</ul>

</details>

<details>
<summary><strong>Showroom content not found?</strong></summary>

<pre><code># Verify structure
ls ~/path/to/showroom/content/modules/ROOT/pages/
# Should contain .adoc files</code></pre>

</details>

<details>
<summary><strong>Description starts with "This workshop"?</strong></summary>

<div class="priority-box">
  <h4>RHDP Requirement:</h4>
  <p>Description overview must start with the product name, not "This workshop teaches..."</p>
  <p><strong>Example:</strong> "OpenShift Pipelines enables..." NOT "This workshop teaches OpenShift Pipelines..."</p>
</div>

</details>

---

## 📊 Git Workflow

<div class="git-workflow-box">
  <h3>Always follows this pattern:</h3>
  
  <div class="git-step">
    <h4>1. Pull latest main</h4>
    <pre><code>git checkout main
git pull origin main</code></pre>
  </div>

  <div class="git-step">
    <h4>2. Create descriptive branch (NO feature/ prefix)</h4>
    <div class="example-grid">
      <div class="example good">
        <div class="example-header">✅ Good</div>
        <code>add-ansible-ai-workshop</code><br>
        <code>update-ocp-pipelines-description</code>
      </div>
      <div class="example bad">
        <div class="example-header">❌ Bad</div>
        <code>feature/add-workshop</code>
      </div>
    </div>
  </div>

  <div class="git-step">
    <h4>3. Auto-commit changes</h4>
    <pre><code>git add agd_v2/your-catalog/
git commit -m "Add your-catalog catalog"</code></pre>
  </div>

  <div class="git-step">
    <h4>4. Push and create PR</h4>
    <pre><code>git push origin your-branch
# Open GitHub → create PR from your branch to main</code></pre>
  </div>
</div>

---

## 🔗 Related Skills

<div class="related-skills">
  <a href="agnosticv-validator.html" class="related-skill-card">
    <div class="related-skill-icon">✓</div>
    <div class="related-skill-content">
      <h4>/agnosticv:validator</h4>
      <p>Validate catalog before PR</p>
    </div>
  </a>

  <a href="create-lab.html" class="related-skill-card">
    <div class="related-skill-icon">📝</div>
    <div class="related-skill-content">
      <h4>/showroom:create-lab</h4>
      <p>Create Showroom workshop first</p>
    </div>
  </a>

  <a href="deployment-health-checker.html" class="related-skill-card">
    <div class="related-skill-icon">🏥</div>
    <div class="related-skill-content">
      <h4>/health:deployment-validator</h4>
      <p>Create automated health checks</p>
    </div>
  </a>
</div>

---

<div class="navigation-footer">
  <a href="index.html" class="nav-button">← Back to Skills</a>
  <a href="agnosticv-validator.html" class="nav-button">Next: /agnosticv:validator →</a>
</div>

<style>
.skill-badge {
  display: inline-block;
  background: linear-gradient(135deg, #3B82F6 0%, #2563EB 100%);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  font-weight: 600;
  margin: 1rem 0;
}

.workflow-diagram {
  margin: 2rem 0;
  text-align: center;
}

.prereq-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.prereq-item {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
}

.prereq-icon {
  font-size: 2rem;
  margin-bottom: 0.5rem;
}

.prereq-item h4 {
  margin: 0.5rem 0;
  color: #24292e;
}

.prereq-item pre {
  background: #f6f8fa;
  padding: 0.75rem;
  border-radius: 4px;
  margin: 0.5rem 0 0 0;
}

.prereq-item ul {
  margin: 0.5rem 0 0 0;
  padding-left: 1.25rem;
  color: #586069;
  font-size: 0.875rem;
}

.mode-tabs {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1rem;
  margin: 2rem 0;
}

.mode-tab {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
}

.mode-tab h4 {
  margin-top: 0;
  color: #3B82F6;
  font-size: 1rem;
  margin-bottom: 1rem;
}

.mode-tab ul {
  margin: 0;
  padding-left: 1.25rem;
  color: #586069;
  font-size: 0.875rem;
}

.quick-start-steps {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 1rem;
  margin: 2rem 0;
}

.quick-step {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
  text-align: center;
}

.quick-step-number {
  width: 48px;
  height: 48px;
  background: linear-gradient(135deg, #3B82F6 0%, #2563EB 100%);
  color: white;
  border-radius: 50%;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  font-weight: 700;
  margin-bottom: 1rem;
}

.quick-step-content h4 {
  margin: 0.5rem 0;
  color: #24292e;
}

.quick-step-content p {
  margin: 0;
  color: #586069;
  font-size: 0.875rem;
}

.mode-generation-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.mode-generation-card {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 12px;
  padding: 1.5rem;
}

.mode-header {
  font-weight: 700;
  color: #3B82F6;
  margin-bottom: 0.75rem;
  font-size: 1.1rem;
}

.mode-generation-card p {
  color: #586069;
  margin: 0.5rem 0;
  font-size: 0.875rem;
}

.mode-generation-card pre {
  background: white;
  padding: 1rem;
  border-radius: 6px;
  margin: 0.75rem 0 0 0;
}

.workflow-steps {
  margin: 2rem 0;
}

.workflow-step {
  display: flex;
  gap: 1.5rem;
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 1px solid #e1e4e8;
  border-radius: 12px;
  padding: 1.5rem;
  margin-bottom: 1.5rem;
}

.workflow-icon {
  font-size: 2rem;
  flex-shrink: 0;
}

.workflow-content {
  flex: 1;
}

.workflow-content h4 {
  margin-top: 0;
  margin-bottom: 0.5rem;
  color: #24292e;
}

.workflow-content pre {
  background: #f6f8fa;
  padding: 1rem;
  border-radius: 6px;
  margin: 0.5rem 0 0 0;
}

.detail-content {
  padding: 1rem 0;
}

.detail-content h4 {
  color: #24292e;
  margin-top: 1rem;
  margin-bottom: 0.5rem;
}

.detail-content ul,
.detail-content ol {
  color: #586069;
  font-size: 0.875rem;
}

.detail-content pre {
  background: #f6f8fa;
  padding: 1rem;
  border-radius: 6px;
  margin: 0.5rem 0;
}

.tips-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin: 1.5rem 0;
}

.tip-card {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
}

.tip-card h4 {
  margin-top: 0;
  margin-bottom: 0.5rem;
  color: #24292e;
  font-size: 0.875rem;
}

.tip-card p {
  margin: 0;
  color: #586069;
  font-size: 0.875rem;
}

.priority-box {
  background: #f6f8fa;
  border: 1px solid #e1e4e8;
  border-radius: 6px;
  padding: 1rem;
  margin-top: 1rem;
}

.priority-box h4 {
  margin-top: 0;
  color: #24292e;
}

.priority-box p {
  margin: 0.5rem 0;
}

.git-workflow-box {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 12px;
  padding: 2rem;
  margin: 2rem 0;
}

.git-workflow-box h3 {
  margin-top: 0;
  margin-bottom: 1.5rem;
  color: #24292e;
}

.git-step {
  margin-bottom: 1.5rem;
}

.git-step h4 {
  color: #3B82F6;
  margin-bottom: 0.5rem;
}

.git-step pre {
  background: white;
  padding: 1rem;
  border-radius: 6px;
  margin: 0.5rem 0 0 0;
}

.example-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
  margin-top: 0.5rem;
}

.example {
  padding: 0.75rem;
  border-radius: 6px;
  border: 1px solid;
}

.example.good {
  background: #d4edda;
  border-color: #28a745;
}

.example.bad {
  background: #f8d7da;
  border-color: #dc3545;
}

.example-header {
  font-weight: 600;
  margin-bottom: 0.5rem;
  font-size: 0.875rem;
}

.example code {
  display: block;
  margin: 0.25rem 0;
  font-size: 0.875rem;
}

.related-skills {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1rem;
  margin: 1.5rem 0;
}

.related-skill-card {
  display: flex;
  gap: 1rem;
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
  text-decoration: none;
  color: inherit;
  transition: all 0.2s ease;
}

.related-skill-card:hover {
  border-color: #3B82F6;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.related-skill-icon {
  font-size: 2rem;
  flex-shrink: 0;
}

.related-skill-content h4 {
  margin: 0 0 0.25rem 0;
  color: #24292e;
  font-size: 1rem;
}

.related-skill-content p {
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
  border-color: #3B82F6;
  color: #3B82F6;
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
  color: #3B82F6;
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
