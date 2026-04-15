---
layout: default
title: /agnosticv:catalog-builder
---

# /agnosticv:catalog-builder

<div class="reference-badge">🔧 Catalog Builder</div>

Create or update AgnosticV catalog files for RHDP deployments (unified skill).

---

## What You'll Need Before Starting

<div class="workflow-diagram">
  <a href="catalog-builder-workflow.svg" target="_blank">
    <img src="catalog-builder-workflow.svg" alt="catalog-builder workflow diagram" style="max-width: 100%; height: auto; border-radius: 8px; border: 1px solid #e1e4e8;" />
  </a>
  <p style="text-align: center; color: #586069; font-size: 0.875rem; margin-top: 0.5rem;">Click to view full workflow diagram</p>
</div>

### Prerequisites

<div class="category-grid">
  <div class="category-card">
    <div class="category-icon">📁</div>
    <h4>Clone AgnosticV Repository</h4>
    <pre><code>cd ~/work/code
git clone git@github.com:rhpds/agnosticv.git
cd agnosticv</code></pre>
  </div>

  <div class="category-card">
    <div class="category-icon">🔐</div>
    <h4>Verify RHDP Access</h4>
    <ul>
      <li>Write access to AgnosticV repository</li>
      <li>Test: <code>gh repo view rhpds/agnosticv</code></li>
      <li>Ability to create pull requests</li>
    </ul>
  </div>

  <div class="category-card">
    <div class="category-icon">📝</div>
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
      <li>Infrastructure type: OCP cluster / RHEL+AAP VMs / Sandbox API CI</li>
      <li>For Sandbox API CI: Cluster CI (provision shared cluster) or Tenant CI (deploy on pre-configured cluster)</li>
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
      <li>Supports bulk processing of multiple base components in one run</li>
    </ul>
  </div>
</div>

---

## Quick Start

<ol class="steps">
  <li><div class="step-content"><h4>Navigate to Repository</h4><p>Open your AgnosticV repository directory</p></div></li>
  <li><div class="step-content"><h4>Run Catalog Builder</h4><p><code>/agnosticv:catalog-builder</code></p></div></li>
  <li><div class="step-content"><h4>Choose Mode</h4><p>Select: Full Catalog / Description Only / Info Template</p></div></li>
  <li><div class="step-content"><h4>Answer Questions</h4><p>Follow guided prompts</p></div></li>
  <li><div class="step-content"><h4>Review & Commit</h4><p>Files auto-committed to new branch</p></div></li>
</ol>

---

## What It Can Generate

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

## Common Workflows

<ol class="steps">
  <li>
    <div class="step-content">
      <h4>Workflow 1: Create Full Catalog from Scratch</h4>
      <pre><code>/agnosticv:catalog-builder
→ Mode: 1 (Full Catalog)
→ Step 0: AgV path auto-detected, branch created
→ Step 1: Q1=type (Workshop/Demo/Sandbox), Q2=event?, Q3=tech
→ Step 2: Discovery searches all agDv2 directories (agd_v2/, openshift_cnv/, ai-quickstarts/, etc.)
→ Step 3: Infrastructure gate (OCP cluster / RHEL+AAP VMs / Sandbox API CI)
→ Step 4: Auth (unified ocp4_workload_authentication)
→ Step 5: Workloads + LiteMaaS
→ Step 6: Showroom (recommended name shown)
→ Step 7: Catalog details (name, description, maintainer)
→ Step 9: __meta__, includes, event restrictions
→ Step 10: Path auto-generated (event) or asked (no-event)
→ Generate all 4 files, auto-commit to branch</code></pre>
    </div>
  </li>

  <li>
    <div class="step-content">
      <h4>Workflow 2: Update Description After Content Changes</h4>
      <pre><code>/agnosticv:catalog-builder
→ Mode: 2 (Description Only)
→ Point to Showroom repo
→ Auto-extracts modules and technologies
→ Generates description.adoc
→ Auto-commits to branch</code></pre>
    </div>
  </li>

  <li>
    <div class="step-content">
      <h4>Workflow 3: Add Info Template for User Data</h4>
      <pre><code>/agnosticv:catalog-builder
→ Mode: 3 (Info Template)
→ Specify data keys from workload
→ Generates template with placeholders
→ Shows how to use agnosticd_user_info</code></pre>
    </div>
  </li>
</ol>

---

## Mode Details

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
    <li>
      <strong>Step 2 — Discovery:</strong> Searches all AgDv2 directories for <code>common.yaml</code> files containing the specified technologies, then filters results by presence of a <code>config:</code> field (excludes legacy AgDv1 catalogs that lack this field). Directories searched:
      <ul>
        <li><code>agd_v2/</code> — standard OCP and VM catalogs</li>
        <li><code>openshift_cnv/</code> — CNV-pool-specific catalogs</li>
        <li><code>ai-quickstarts/</code> — AI/ML quickstart labs</li>
        <li><code>enterprise/</code> — enterprise customer catalogs</li>
        <li><code>summit-2026/</code> — Red Hat Summit 2026 event catalogs</li>
        <li><code>sandboxes-gpte/</code> — GPTE sandbox catalogs</li>
        <li><code>zt_rhel/</code> — zero-touch RHEL labs</li>
        <li><code>rhdp/</code> — RHDP platform catalogs</li>
      </ul>
      Results are shown with <code>[OCP cluster]</code> or <code>[RHEL/AAP VMs]</code> labels drawn from the <code>config:</code> field.
    </li>
    <li>
      <strong>Step 3 — Infrastructure gate:</strong> Three options — OCP cluster, RHEL/AAP VMs, or Sandbox API CI. Routes to a separate @reference file per type:
      <ul>
        <li><strong>OCP path (<code>ocp-catalog-questions.md</code>):</strong> SNO or multinode, OCP version (4.18/4.20/4.21), pool with <code>/prod</code> suffix, autoscale, AWS gate; auth (unified <code>ocp4_workload_authentication</code> + provider); OCP workloads + LiteMaaS; Showroom with <code>ocp4_workload_ocp_console_embed</code>; multi-user with worker scaling</li>
        <li><strong>VM path (<code>cloud-vms-base-catalog-questions.md</code>):</strong> CNV or AWS, RHEL image, sizing, ports; auth skipped (OS-level only); VM workloads; <code>vm_workload_showroom</code> with <code>showroom_git_repo</code>/<code>showroom_git_ref</code>; multi-user isolation warning</li>
        <li>
          <strong>Sandbox API CI path:</strong> After choosing this option, the skill asks which half of the CI pair is being created:
          <ul>
            <li><strong>Cluster CI (<code>sandbox-cluster-ci-questions.md</code>):</strong> Provisions a shared OCP cluster sized for N tenant placements. Sets <code>config: openshift-workloads</code>, <code>cloud_provider: none</code>, <code>num_users: 0</code>. Asks pool type (CNV/AWS), OCP version, lab label (tenants target the cluster using this label), and worker sizing. Auto-adds required includes (<code>sandbox-api.yaml</code>, <code>access-restriction-admins-only.yaml</code>) and the full <code>propagate_provision_data</code> block. Deployer actions <code>status</code> and <code>update</code> are disabled; <code>sandbox_api</code> is omitted (Cluster CI does not run <code>remove_workloads</code>).</li>
            <li><strong>Tenant CI (<code>sandbox-tenant-ci-questions.md</code>):</strong> Deploys per-user workloads on a pre-configured cluster via <code>__meta__.sandboxes.cloud_selector</code> labels. Sets <code>config: namespace</code>, <code>cloud_provider: none</code>, username pattern <code>user-{{ guid }}</code>. Asks cloud (cnv/aws-dedicated-shared), lab label, namespace suffixes and quotas, optional GitOps bootstrap, and optional Showroom. Auto-sets <code>sandbox_api.actions.destroy.catch_all: false</code> so <code>remove_workloads</code> runs before the sandbox is released. Deployer actions <code>status</code> and <code>update</code> are disabled.</li>
          </ul>
        </li>
      </ul>
    </li>
    <li>
      <strong>Step 7a — Terminal type:</strong> After confirming the Showroom repository, the skill asks which terminal type the lab uses:
      <ul>
        <li><strong>wetty</strong> — OCP tenant (namespace) or multi-user labs. Students connect via browser WeTTY. Sets <code>ocp4_workload_showroom_terminal_type: wetty</code>.</li>
        <li><strong>showroom</strong> — Dedicated OCP cluster with a bastion. Students SSH-tunnel through the bastion. Sets <code>ocp4_workload_showroom_terminal_type: showroom</code> and <code>ocp4_workload_showroom_wetty_ssh_bastion_login: true</code>.</li>
        <li><strong>none</strong> — UI-only lab with no terminal tab needed. The terminal type variable is omitted.</li>
      </ul>
    </li>
    <li>
      <strong>Step 7b — E2E / Runtime Automation:</strong> The skill asks whether the lab needs Solve and Validate buttons in the Showroom guide. If yes, it enables the full runtime automation block in <code>common.yaml</code>:
      <ul>
        <li>Adds <code>rhpds.ftl.ocp4_workload_runtime_automation_k8s</code> to the workloads list</li>
        <li>Sets <code>ocp4_workload_showroom_runtime_automation_enable: true</code></li>
        <li>Sets <code>ocp4_workload_showroom_runtime_automation_image: "quay.io/rhpds/zt-runner:v2.4.2"</code></li>
        <li>Ensures <code>rhpds-ftl</code> collection is present in <code>requirements_content</code></li>
        <li>For summit/event catalogs: adds a comment in the generated YAML reminding developers to remove solve/validate button placeholders from Showroom adoc files before the prod tag is cut</li>
        <li>Pairs with the <code>/ftl:rhdp-lab-validator</code> skill for authoring the runtime-automation playbooks</li>
      </ul>
    </li>
    <li>
      <strong>Step 9 — common.yaml generation rules:</strong>
      <ul>
        <li><code>requirements_content</code> (collections list) must appear within the first 200 lines of <code>common.yaml</code>, immediately after the mandatory vars section and before passwords, bastion config, and workload-specific variables. This is enforced by the platform validator (Check 22).</li>
        <li>Passwords always use <code>lookup('password', output_dir ~ '/unique_filename', ...)</code> with a unique file path per variable. Static strings and hash/GUID patterns are errors (validator Check 19).</li>
        <li>Container image references use pinned version tags. <code>:latest</code>, <code>:main</code>, and untagged images are rejected in prod/event catalogs (validator Check 23).</li>
      </ul>
    </li>
    <li><strong>Step 9 — __meta__:</strong> See the <em>__meta__ Block Details</em> section below for the full breakdown.</li>
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
    <li><strong>sandbox-tenant/</strong> — Sandbox API Tenant CI (<code>config: namespace</code>)</li>
    <li><strong>sandbox-cluster/</strong> — Sandbox API Cluster CI (<code>config: openshift-workloads</code>, <code>cloud_provider: none</code>)</li>
  </ul>
</div>

</details>

<details>
<summary><strong>__meta__ Block Details</strong></summary>

<div class="detail-content">
  <p>The <code>__meta__</code> block is generated into <code>common.yaml</code> and controls how the RHDP platform manages the catalog item. The skill assembles it from answers collected throughout the workflow — no single dedicated step.</p>

  <h4>deployer actions (start / stop)</h4>
  <p>The skill asks whether any workload deploys or configures something <em>outside</em> the provisioned environment (external DNS, cloud resources, shared services, etc.). If yes, the relevant lifecycle actions are disabled so the platform does not attempt to start or stop those external resources independently:</p>
  <pre><code>__meta__:
  deployer:
    actions:
      stop:
        disable: true   # only when workload touches external resources
      start:
        disable: true   # only when workload touches external resources</code></pre>
  <p>If no external resources are involved, <code>deployer.actions</code> is omitted entirely.</p>

  <h4>sandbox_api.actions.destroy.catch_all</h4>
  <p>Controls whether <code>remove_workloads</code> runs before the sandbox is released on destroy.</p>
  <ul>
    <li><strong>Standard OCP / RHEL+AAP catalogs:</strong> Omitted by default (platform catch_all defaults to true, so remove_workloads runs). Set to <code>false</code> only if a workload deploys something that should persist after destroy.</li>
    <li><strong>Sandbox API Tenant CI:</strong> Always set to <code>false</code> — the tenant CI must run <code>remove_workloads</code> to clean up per-user namespace resources before the sandbox slot is released back to the pool.</li>
    <li><strong>Sandbox API Cluster CI:</strong> <code>sandbox_api</code> is omitted entirely — Cluster CI does not run <code>remove_workloads</code>.</li>
  </ul>
  <pre><code>  sandbox_api:
    actions:
      destroy:
        catch_all: false   # Tenant CI always; standard only when skip-cleanup needed</code></pre>

  <h4>catalog.reportingLabels</h4>
  <p>Required for all catalog items. The skill always asks for <code>primaryBU</code> and optionally <code>secondaryBU</code>:</p>
  <pre><code>  catalog:
    reportingLabels:
      primaryBU: Hybrid_Platforms   # e.g. Artificial_Intelligence, Automation, RHEL, Edge
      secondaryBU: Automation       # optional</code></pre>

  <h4>catalog.keywords</h4>
  <p>The skill enforces 3–4 specific technology keywords. Generic terms such as <em>workshop</em>, <em>demo</em>, <em>openshift</em>, and <em>ansible</em> are rejected. Event keywords are added automatically and should not be entered manually:</p>
  <ul>
    <li>Summit 2026 catalogs: <code>summit-2026</code> and the lab ID (e.g. <code>lb2298</code>) are auto-added</li>
    <li>RH One 2026 catalogs: <code>rh1-2026</code> and the lab ID are auto-added</li>
    <li>Non-event catalogs: only the user-supplied specific technology keywords are written</li>
  </ul>

  <h4>catalog.labels.Brand_Event</h4>
  <p>Auto-set from the event selected in Step 1. Omitted entirely for non-event catalogs.</p>
  <table>
    <thead><tr><th>Event</th><th>Brand_Event value</th></tr></thead>
    <tbody>
      <tr><td>Summit 2026</td><td><code>Red_Hat_Summit_2026</code></td></tr>
      <tr><td>RH One 2026</td><td><code>Red_Hat_One_2026</code></td></tr>
      <tr><td>No event</td><td><em>omitted</em></td></tr>
    </tbody>
  </table>

  <h4>catalog.workshopLabUiRedirect</h4>
  <p>Set automatically by the infra reference file, not asked separately. OCP multi-user workshops get <code>workshopLabUiRedirect: true</code>; demos and VM catalogs omit it.</p>

  <h4>Full __meta__ structure</h4>
  <pre><code>__meta__:
  asset_uuid: &lt;auto-generated, collision-checked&gt;
  owners:
    maintainer:
    - name: &lt;maintainer name&gt;
      email: &lt;maintainer email&gt;
    instructions:
    - name: TBD
      email: tbd@redhat.com

  deployer:
    scm_url: https://github.com/agnosticd/agnosticd-v2
    scm_ref: main
    execution_environment:
      image: quay.io/agnosticd/ee-multicloud:chained-2026-02-23
      pull: missing
    # actions:           # only when workload touches external resources
    #   stop:
    #     disable: true
    #   start:
    #     disable: true

  # sandbox_api:         # Tenant CI: always; standard: only to skip cleanup
  #   actions:
  #     destroy:
  #       catch_all: false

  catalog:
    reportingLabels:
      primaryBU: &lt;e.g. Hybrid_Platforms&gt;
      # secondaryBU: &lt;optional&gt;
    namespace: babylon-catalog-{{ stage | default('?') }}
    display_name: "&lt;display name&gt;"
    category: &lt;Brand_Events | Labs | Demos | Sandboxes&gt;
    keywords:
    - &lt;summit-2026&gt;      # auto-added for event catalogs
    - &lt;lb2298&gt;           # auto-added for event catalogs
    - &lt;specific-tech-1&gt;
    - &lt;specific-tech-2&gt;
    labels:
      Product: &lt;e.g. Red_Hat_OpenShift_Container_Platform&gt;
      Product_Family: &lt;e.g. Red_Hat_Cloud&gt;
      Provider: RHDP
      # Brand_Event: Red_Hat_Summit_2026   # auto-set for event catalogs
    multiuser: &lt;true | false&gt;
    workshop_user_mode: &lt;multi | single | none&gt;
    # workshopLabUiRedirect: true           # auto-set for multi-user OCP labs</code></pre>

  <p><strong>Note:</strong> <code>anarchy.namespace</code> must never be defined — it is set at the AgV top level.</p>
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

## Tips & Best Practices

<div class="category-grid">
  <div class="category-card">
    <h4>🏷️ Start with Product Name</h4>
    <p>Description overview must start with product, not "This workshop"</p>
  </div>
  <div class="category-card">
    <h4>📚 Use Real Examples</h4>
    <p>Reference existing catalogs for patterns</p>
  </div>
  <div class="category-card">
    <h4>✓ Validate Before PR</h4>
    <p>Always run <code>/agnosticv:validator</code></p>
  </div>
  <div class="category-card">
    <h4>🧪 Test in Dev First</h4>
    <p>Use dev.yaml for testing</p>
  </div>
  <div class="category-card">
    <h4>🌿 No feature/ Prefix</h4>
    <p>Branch names should be descriptive without feature/</p>
  </div>
  <div class="category-card">
    <h4>📝 Convert Lists to Strings</h4>
    <p>For info templates: <code>{{ my_list | join(', ') }}</code></p>
  </div>
</div>

---

## Troubleshooting

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

## Git Workflow

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

## Related Skills

<div class="links-grid">
  <a href="agnosticv-validator.html" class="link-card">
    <h4>/agnosticv:validator</h4>
    <p>Validate catalog before PR</p>
  </a>

  <a href="create-lab.html" class="link-card">
    <h4>/showroom:create-lab</h4>
    <p>Create Showroom workshop first</p>
  </a>

  <a href="deployment-health-checker.html" class="link-card">
    <h4>/health:deployment-validator</h4>
    <p>Create automated health checks</p>
  </a>
</div>

---

<div class="navigation-footer">
  <a href="index.html" class="nav-button">← Back to Skills</a>
  <a href="agnosticv-validator.html" class="nav-button">Next: /agnosticv:validator →</a>
</div>
