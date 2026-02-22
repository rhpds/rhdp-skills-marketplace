---
layout: default
title: /agnosticv:validator
---

# /agnosticv:validator

<div class="skill-badge" style="background: linear-gradient(135deg, #17a2b8 0%, #117a8b 100%);">✓ Catalog Validation</div>

Validate AgnosticV catalog configurations and best practices before creating pull request.

---

## 📋 What You'll Need Before Starting

<div class="workflow-diagram">
  <a href="workflow.svg" target="_blank">
    <img src="workflow.svg" alt="validator workflow diagram" style="max-width: 100%; height: auto; border-radius: 8px; border: 1px solid #e1e4e8;" />
  </a>
  <p style="text-align: center; color: #586069; font-size: 0.875rem; margin-top: 0.5rem;">Click to view full workflow diagram</p>
</div>

### Prerequisites

<div class="prereq-grid">
  <div class="prereq-item">
    <div class="prereq-icon">📁</div>
    <h4>AgnosticV Repository</h4>
    <pre><code>cd ~/work/code/agnosticv</code></pre>
  </div>

  <div class="prereq-item">
    <div class="prereq-icon">📄</div>
    <h4>Catalog Files Created</h4>
    <pre><code>agd_v2/your-catalog-name/
├── common.yaml
├── dev.yaml
└── description.adoc</code></pre>
  </div>

  <div class="prereq-item">
    <div class="prereq-icon">🔄</div>
    <h4>Repository Up to Date</h4>
    <pre><code>git checkout main
git pull origin main</code></pre>
  </div>
</div>

### What You'll Need

- Catalog files generated (typically from `/agnosticv:catalog-builder`)
- Current directory set to agnosticv repository
- Git branch for your changes

---

## 🚀 Quick Start

<div class="quick-start-steps">
  <div class="quick-step">
    <div class="quick-step-number">1</div>
    <div class="quick-step-content">
      <h4>Navigate to Repo</h4>
      <p>AgnosticV repository</p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">2</div>
    <div class="quick-step-content">
      <h4>Run Validator</h4>
      <p><code>/agnosticv:validator</code></p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">3</div>
    <div class="quick-step-content">
      <h4>Review Results</h4>
      <p>Check validation report</p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">4</div>
    <div class="quick-step-content">
      <h4>Fix Issues</h4>
      <p>Address errors and warnings</p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">5</div>
    <div class="quick-step-content">
      <h4>Create PR</h4>
      <p>When validation is clean</p>
    </div>
  </div>
</div>

---

## ✓ What It Validates

<div class="validation-box">
  <h3>Comprehensive Validation Checks</h3>
  <p>The validator performs extensive checks across your catalog configuration, including new checks aligned to the v2.6.0 catalog-builder standards:</p>
</div>

<details open>
<summary><strong>Check 1: File Structure</strong></summary>

<ul>
  <li><strong>Required files:</strong> common.yaml must exist</li>
  <li><strong>Recommended files:</strong> dev.yaml, description.adoc, info-message-template.adoc</li>
  <li><strong>File paths:</strong> Correct directory structure</li>
  <li><strong>Naming:</strong> Follows catalog naming convention</li>
</ul>

</details>

<details>
<summary><strong>Check 2: UUID Compliance</strong></summary>

<ul>
  <li><strong>Format:</strong> RFC 4122 compliant UUID</li>
  <li><strong>Case:</strong> Lowercase only (no uppercase)</li>
  <li><strong>Uniqueness:</strong> Not used by other catalogs</li>
  <li><strong>Structure:</strong> Proper hyphenation (8-4-4-4-12)</li>
</ul>

</details>

<details>
<summary><strong>Check 3: Category Validation</strong></summary>

<div class="check-content">
  <h4>Valid values (must be exactly one):</h4>
  <ul>
    <li><code>Workshops</code> - Multi-user hands-on learning</li>
    <li><code>Demos</code> - Single-user presenter-led (MUST NOT be multi-user)</li>
    <li><code>Labs</code> - General learning environments</li>
    <li><code>Sandboxes</code> - Self-service playgrounds</li>
    <li><code>Brand_Events</code> - Events like Red Hat Summit, Red Hat One</li>
  </ul>

  <h4>Important Rules:</h4>
  <ul>
    <li><strong>Case-sensitive:</strong> Must match exactly (plural)</li>
    <li><strong>Required:</strong> Cannot be empty</li>
    <li><strong>Demo rules:</strong>
      <ul>
        <li>Demos MUST be single-user (ERROR if multiuser: true)</li>
        <li>Demos MUST NOT have workshopLabUiRedirect enabled (ERROR)</li>
      </ul>
    </li>
  </ul>
</div>

</details>

<details>
<summary><strong>Checks 4-5: Workloads and YAML</strong></summary>

<ul>
  <li><strong>Check 4: Workloads</strong> - Collection format, existence, dependencies, naming (full <code>namespace.collection.role</code> format required)</li>
  <li><strong>Check 5: YAML Syntax</strong> - Valid YAML, required fields, data types</li>
</ul>

</details>

<details>
<summary><strong>Check 6: Infrastructure (UPDATED)</strong></summary>

<div class="check-content">
  <p>Check 6 detects <code>config:</code> type and routes to the appropriate check file:</p>
  <h4>cloud-vms-base → <code>cloud-vms-base-validator-checks.md</code>:</h4>
  <ul>
    <li>Instances block defined with bastion VM and correct tags</li>
    <li>Bastion image is supported RHEL version (9.4+)</li>
    <li>CNV: <code>services:/routes:</code> present; AWS: <code>security_groups:</code> present</li>
    <li>Multi-user isolation warning (no per-user namespace on VMs)</li>
  </ul>

  <h4>OCP → <code>ocp-validator-checks.md</code>:</h4>
  <ul>
    <li><strong>Pool suffix:</strong> ERROR if pool does not end in <code>/prod</code></li>
    <li><strong>OCP version:</strong> Must be 4.18, 4.20, or 4.21 (known pool versions)</li>
    <li><strong>AWS OCP:</strong> WARNING — confirm RHDP team approval</li>
    <li><strong>SNO + multiuser:</strong> ERROR — SNO cannot support concurrent users</li>
  </ul>
</div>

</details>

<details>
<summary><strong>Check 7: Authentication (UPDATED)</strong></summary>

<div class="check-content">
  <ul>
    <li><strong>cloud-vms-base:</strong> Auth check skipped — VM catalogs use OS-level auth, no OCP cluster. Warns if <code>ocp4_workload_authentication</code> accidentally added.</li>
    <li><strong>OCP:</strong> ERROR if deprecated <code>ocp4_workload_authentication_htpasswd</code> or <code>ocp4_workload_authentication_keycloak</code> roles found</li>
    <li><strong>OCP:</strong> ERROR if RHSSO detected (use Keycloak/RHBK instead)</li>
    <li><strong>OCP:</strong> PASS requires unified <code>ocp4_workload_authentication</code> with valid <code>ocp4_workload_authentication_provider</code> value (<code>htpasswd</code> or <code>keycloak</code>)</li>
  </ul>
</div>

</details>

<details>
<summary><strong>Check 8: Showroom (UPDATED)</strong></summary>

<div class="check-content">
  <ul>
    <li><strong>OCP:</strong> Both <code>ocp4_workload_ocp_console_embed</code> AND <code>ocp4_workload_showroom</code> required together. ERROR if <code>ocp_console_embed</code> missing.</li>
    <li><strong>OCP:</strong> <code>ocp4_workload_showroom_antora_enable_dev_mode: "false"</code> in common.yaml; <code>"true"</code> in dev.yaml</li>
    <li><strong>cloud-vms-base:</strong> Uses <code>vm_workload_showroom</code> with <code>showroom_git_repo</code> and <code>showroom_git_ref</code>. ERROR if <code>ocp_console_embed</code> present (requires OCP cluster).</li>
    <li><strong>cloud-vms-base:</strong> No dev mode variable — <code>vm_workload_showroom</code> does not have Antora dev mode.</li>
  </ul>
</div>

</details>

<details>
<summary><strong>Check 9: Best Practices</strong></summary>

<ul>
  <li>Naming conventions followed</li>
  <li>Documentation completeness</li>
  <li>dev.yaml has <code>purpose: development</code></li>
</ul>

</details>

<details>
<summary><strong>Check 10: Stage Files Validation</strong></summary>

<ul>
  <li><strong>dev.yaml:</strong> Must have <code>purpose: development</code></li>
  <li><strong>event.yaml:</strong> Should have <code>purpose: events</code> (if exists)</li>
  <li><strong>prod.yaml:</strong> Should have <code>purpose: production</code> (if exists)</li>
  <li><strong>scm_ref:</strong> Validates deployment repository references</li>
</ul>

</details>

<details>
<summary><strong>Check 11: Multi-User Configuration (CRITICAL)</strong></summary>

<ul>
  <li><strong>num_users parameter:</strong> Required for multi-user catalogs</li>
  <li><strong>worker_instance_count:</strong> Must scale with num_users</li>
  <li><strong>workshopLabUiRedirect:</strong>
    <ul>
      <li><strong>WARNING</strong> if not enabled for multi-user workshops</li>
      <li>Multi-user workshops SHOULD enable this for per-user lab UI routing</li>
    </ul>
  </li>
  <li><strong>Category compliance:</strong> Workshops/Brand_Events must be multi-user</li>
</ul>

</details>

<details>
<summary><strong>Check 12: Bastion Configuration</strong></summary>

<ul>
  <li><strong>Image version:</strong> RHEL 9.4-10.0 recommended</li>
  <li><strong>Resources:</strong> Minimum 2 cores, 4Gi memory</li>
  <li><strong>Configuration:</strong> Proper bastion setup for CNV pools</li>
</ul>

</details>

<details>
<summary><strong>Check 13: Collection Versions (UPDATED)</strong></summary>

<div class="check-content">
  <ul>
    <li><strong>tag: defined:</strong> ERROR if <code>tag:</code> variable is not set in <code>common.yaml</code></li>
    <li><strong>Standard collections:</strong> Should use <code>{{ tag }}</code> — WARNING if hardcoded version found on standard collections</li>
    <li><strong>Showroom collection:</strong> Must use a fixed version (not <code>{{ tag }}</code>) pinned to <code>≥ v1.5.1</code> — ERROR if version is older or missing</li>
    <li><strong>Galaxy collections:</strong> Version validation</li>
    <li><strong>Format:</strong> Proper requirements_content structure</li>
  </ul>
</div>

</details>

<details>
<summary><strong>Check 14: Deployer Configuration</strong></summary>

<ul>
  <li><strong>scm_url:</strong> Must point to agnosticd-v2 repository</li>
  <li><strong>scm_ref:</strong> Deployment reference (main, tag, branch)</li>
  <li><strong>execution_environment:</strong> Container image for deployment</li>
</ul>

</details>

<details>
<summary><strong>Check 14a: Reporting Labels (CRITICAL - ERROR if missing)</strong></summary>

<div class="critical-box">
  <h4>⚠️ primaryBU: REQUIRED for business unit tracking</h4>
  <p>Examples: <code>Hybrid_Platforms</code>, <code>Application_Services</code>, <code>Ansible</code>, <code>RHEL</code></p>
  <p>Used for tracking and reporting across RHDP</p>
  <p><strong>ERROR severity</strong> if missing</p>
</div>

</details>

<details>
<summary><strong>Check 15: Component Propagation</strong></summary>

<ul>
  <li><strong>Multi-stage catalogs:</strong> Validates data flow between stages</li>
  <li><strong>propagate_provision_data:</strong> Ensures proper variable passing</li>
  <li><strong>Component structure:</strong> Validates __meta__.components configuration</li>
</ul>

</details>



<details>
<summary><strong>Check 15a: Anarchy Namespace (NEW)</strong></summary>

<div class="check-content">
  <ul>
    <li><strong>ERROR</strong> if <code>anarchy.namespace</code> is defined anywhere in the catalog item</li>
    <li>The <code>anarchy.namespace</code> field is managed by the platform and must never be set by catalog items</li>
  </ul>
</div>

</details>

<details>
<summary><strong>Check 16: AsciiDoc Templates</strong></summary>

<ul>
  <li><strong>description.adoc:</strong> Required catalog description</li>
  <li><strong>info-message-template.adoc:</strong> Required user notification template</li>
  <li><strong>Variable substitutions:</strong> Validates {variable} syntax usage</li>
  <li><strong>Content quality:</strong> Checks for proper structure</li>
</ul>

</details>

<details>
<summary><strong>Check 16a: Event Catalog Validation (NEW)</strong></summary>

<div class="check-content">
  <ul>
    <li><strong>Category:</strong> Event catalogs must use <code>Brand_Events</code> category</li>
    <li><strong>Keywords:</strong> Event-specific keywords required (e.g. <code>summit-2026</code>)</li>
    <li><strong>Directory naming:</strong> Must follow <code>summit-2026/lb####-short-name-cloud</code> convention</li>
    <li><strong>Showroom naming:</strong> Showroom repo name must match lab ID pattern</li>
    <li><strong>Console embed:</strong> <code>ocp_console_embed</code> workload presence validated for OCP-based event labs</li>
  </ul>
</div>

</details>

<details>
<summary><strong>Check 17: LiteMaaS Validation (NEW)</strong></summary>

<div class="check-content">
  <ul>
    <li>Triggered when <code>ocp4_workload_litemaas</code> workload is detected</li>
    <li><strong>Models list:</strong> ERROR if no models defined or models list is empty</li>
    <li><strong>Duration:</strong> ERROR if <code>litemaas_duration</code> is not set</li>
    <li><strong>Includes:</strong> Both <code>litemaas-master_api.yaml</code> and <code>litellm_metadata.yaml</code> must be present in includes list</li>
  </ul>
</div>

</details>

<details>
<summary><strong>Check 17a: Event Restriction Include (NEW)</strong></summary>

<div class="check-content">
  <ul>
    <li>Triggered when catalog is in an event directory (e.g. <code>summit-2026/</code> or <code>rh1-2026/</code>)</li>
    <li><strong>WARNING</strong> if event restriction include is missing from <code>common.yaml</code></li>
    <li>Expected includes: <code>summit-devs.yaml</code> (for Summit) or <code>rh1-2026-devs.yaml</code> (for RH1)</li>
    <li>These restrict catalog access to event participants until the event <code>event.yaml</code> file is created</li>
  </ul>
</div>

</details>

---

## 🔄 Common Workflow

<div class="workflow-steps">
  <div class="workflow-step">
    <div class="workflow-icon">1️⃣</div>
    <div class="workflow-content">
      <h4>Generate Catalog</h4>
      <pre><code>/agnosticv:catalog-builder
→ Create catalog files</code></pre>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">2️⃣</div>
    <div class="workflow-content">
      <h4>Validate Configuration</h4>
      <pre><code>/agnosticv:validator
→ Check for issues
→ Get validation report</code></pre>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">3️⃣</div>
    <div class="workflow-content">
      <h4>Fix Issues</h4>
      <p>Fix reported issues in:</p>
      <ul style="margin: 0.5rem 0 0 0; padding-left: 1.25rem;">
        <li>common.yaml</li>
        <li>dev.yaml</li>
        <li>description.adoc</li>
      </ul>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">4️⃣</div>
    <div class="workflow-content">
      <h4>Re-validate</h4>
      <pre><code>/agnosticv:validator
→ Confirm all issues resolved</code></pre>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">5️⃣</div>
    <div class="workflow-content">
      <h4>Create Pull Request</h4>
      <pre><code>git checkout -b add-your-catalog
git add agd_v2/your-catalog-name/
git commit -m "Add your-catalog catalog"
git push origin add-your-catalog
gh pr create --fill</code></pre>
    </div>
  </div>
</div>

---

## 📊 Example Validation Report

<div class="report-box">
  <h3>Sample Validation Output</h3>
  <div class="report-items">
    <div class="report-item success">
      <span class="report-icon">✅</span>
      <div class="report-content">
        <strong>UUID:</strong> Valid and unique (a1b2c3d4-e5f6-7890-abcd-ef1234567890)
      </div>
    </div>

    <div class="report-item success">
      <span class="report-icon">✅</span>
      <div class="report-content">
        <strong>Category:</strong> Valid value (Workshops)
      </div>
    </div>

    <div class="report-item success">
      <span class="report-icon">✅</span>
      <div class="report-content">
        <strong>Workloads:</strong> All collections found
      </div>
    </div>

    <div class="report-item warning">
      <span class="report-icon">⚠️</span>
      <div class="report-content">
        <strong>Description:</strong> Missing estimated time
      </div>
    </div>

    <div class="report-item error">
      <span class="report-icon">❌</span>
      <div class="report-content">
        <strong>common.yaml:</strong> Invalid cloud_provider value
      </div>
    </div>
  </div>
</div>

---

## 🔧 Common Issues and Fixes

<div class="issues-grid">
  <div class="issue-card">
    <h3>UUID Issues</h3>
    <div class="code-comparison">
      <div class="code-wrong">
        <h4>❌ Wrong:</h4>
        <pre><code>asset_uuid: A1B2C3D4-E5F6-7890-ABCD-EF1234567890</code></pre>
        <p>UUID contains uppercase letters</p>
      </div>
      <div class="code-right">
        <h4>✅ Correct:</h4>
        <pre><code>asset_uuid: a1b2c3d4-e5f6-7890-abcd-ef1234567890</code></pre>
        <p>Convert to lowercase</p>
      </div>
    </div>
  </div>

  <div class="issue-card">
    <h3>Category Issues</h3>
    <div class="code-comparison">
      <div class="code-wrong">
        <h4>❌ Wrong:</h4>
        <pre><code>category: Workshop  # Singular or wrong case</code></pre>
        <p>Wrong category name</p>
      </div>
      <div class="code-right">
        <h4>✅ Correct:</h4>
        <pre><code>category: Workshops  # Must be: Workshops, Demos, or Sandboxes</code></pre>
        <p>Use exact plural form</p>
      </div>
    </div>
  </div>

  <div class="issue-card">
    <h3>Workload Issues</h3>
    <div class="code-comparison">
      <div class="code-wrong">
        <h4>❌ Wrong:</h4>
        <pre><code>workloads:
  - showroom  # Missing collection namespace</code></pre>
        <p>Incorrect workload format</p>
      </div>
      <div class="code-right">
        <h4>✅ Correct:</h4>
        <pre><code>workloads:
  - rhpds.showroom.ocp4_workload_showroom</code></pre>
        <p>Use full collection path</p>
      </div>
    </div>
  </div>
</div>

---

## 💡 Tips & Best Practices

<div class="tips-grid">
  <div class="tip-card">
    <h4>✓ Always Validate</h4>
    <p>Before creating PR</p>
  </div>
  <div class="tip-card">
    <h4>❌ Fix Critical First</h4>
    <p>Errors before warnings</p>
  </div>
  <div class="tip-card">
    <h4>🔄 Run Multiple Times</h4>
    <p>As you fix issues</p>
  </div>
  <div class="tip-card">
    <h4>📋 Check Examples</h4>
    <p>Similar catalogs for patterns</p>
  </div>
  <div class="tip-card">
    <h4>⚖️ Keep in Sync</h4>
    <p>common.yaml and dev.yaml</p>
  </div>
</div>

---

## 🆘 Troubleshooting

<details>
<summary><strong>Skill not found?</strong></summary>

<ul>
  <li>Restart Claude Code or VS Code</li>
  <li>Verify installation: <code>ls ~/.claude/skills/agnosticv-validator</code> (Claude Code) or <code>ls ~/.cursor/skills/agnosticv-validator</code> (Cursor)</li>
  <li>Check the <a href="../reference/troubleshooting.html">Troubleshooting Guide</a></li>
</ul>

</details>

<details>
<summary><strong>Validation fails but looks correct?</strong></summary>

<ul>
  <li>Check for hidden characters or extra spaces</li>
  <li>Verify YAML indentation (use spaces, not tabs)</li>
  <li>Compare with working catalog examples</li>
</ul>

</details>

<details>
<summary><strong>Workload not found error?</strong></summary>

<ul>
  <li>Check <code>~/.claude/docs/workload-mappings.md</code></li>
  <li>Verify collection is published</li>
  <li>Ensure namespace.collection.role format</li>
</ul>

</details>

---

## 🔗 Related Skills

<div class="related-skills">
  <a href="agnosticv-catalog-builder.html" class="related-skill-card">
    <div class="related-skill-icon">🔧</div>
    <div class="related-skill-content">
      <h4>/agnosticv:catalog-builder</h4>
      <p>Create/update catalog (unified skill)</p>
    </div>
  </a>

  <a href="create-lab.html" class="related-skill-card">
    <div class="related-skill-icon">📝</div>
    <div class="related-skill-content">
      <h4>/showroom:create-lab</h4>
      <p>Create workshop content</p>
    </div>
  </a>
</div>

---

<div class="navigation-footer">
  <a href="index.html" class="nav-button">← Back to Skills</a>
  <a href="agnosticv-catalog-builder.html" class="nav-button">Next: /agnosticv:catalog-builder →</a>
</div>

<style>
.skill-badge {
  display: inline-block;
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

.quick-start-steps {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
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
  background: linear-gradient(135deg, #17a2b8 0%, #117a8b 100%);
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

.validation-box {
  background: linear-gradient(135deg, #e7f3ff 0%, #ffffff 100%);
  border: 2px solid #0969da;
  border-radius: 12px;
  padding: 2rem;
  margin: 2rem 0;
  text-align: center;
}

.validation-box h3 {
  margin-top: 0;
  color: #0969da;
}

.check-content {
  margin-top: 1rem;
}

.check-content h4 {
  margin-top: 1rem;
  margin-bottom: 0.5rem;
  color: #24292e;
}

.critical-box {
  background: #fff3cd;
  border: 2px solid #ffc107;
  border-radius: 6px;
  padding: 1rem;
  margin-top: 0.5rem;
}

.critical-box h4 {
  margin-top: 0;
  color: #856404;
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

.report-box {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 12px;
  padding: 2rem;
  margin: 2rem 0;
}

.report-box h3 {
  margin-top: 0;
  margin-bottom: 1.5rem;
  color: #24292e;
}

.report-items {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.report-item {
  display: flex;
  align-items: flex-start;
  gap: 1rem;
  padding: 1rem;
  border-radius: 6px;
  border: 1px solid;
}

.report-item.success {
  background: #d4edda;
  border-color: #28a745;
}

.report-item.warning {
  background: #fff3cd;
  border-color: #ffc107;
}

.report-item.error {
  background: #f8d7da;
  border-color: #dc3545;
}

.report-icon {
  font-size: 1.25rem;
  flex-shrink: 0;
}

.report-content {
  flex: 1;
  font-size: 0.875rem;
}

.issues-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.issue-card {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 12px;
  padding: 1.5rem;
}

.issue-card h3 {
  margin-top: 0;
  margin-bottom: 1rem;
  color: #24292e;
}

.code-comparison {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.code-wrong,
.code-right {
  padding: 1rem;
  border-radius: 6px;
}

.code-wrong {
  background: #f8d7da;
  border: 1px solid #dc3545;
}

.code-right {
  background: #d4edda;
  border: 1px solid #28a745;
}

.code-wrong h4 {
  margin-top: 0;
  color: #721c24;
}

.code-right h4 {
  margin-top: 0;
  color: #155724;
}

.code-wrong pre,
.code-right pre {
  margin: 0.5rem 0;
  background: rgba(255, 255, 255, 0.5);
  padding: 0.5rem;
  border-radius: 4px;
}

.code-wrong p,
.code-right p {
  margin: 0.5rem 0 0 0;
  font-size: 0.875rem;
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
  border-color: #17a2b8;
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
  border-color: #17a2b8;
  color: #17a2b8;
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
  color: #17a2b8;
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
