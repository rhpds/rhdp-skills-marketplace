---
layout: default
title: /health:deployment-validator
---

# /health:deployment-validator

<div class="reference-badge">🏥 Deployment Health Validation</div>

Create Ansible validation roles that verify every component of your RHDP deployment is healthy — pods running, routes accessible, operators installed, per-user resources correctly provisioned.

---

## What You'll Need Before Starting

<div class="workflow-diagram">
  <a href="deployment-validator-workflow.svg" target="_blank">
    <img src="deployment-validator-workflow.svg" alt="deployment-validator workflow diagram" style="max-width: 100%; height: auto; border-radius: 8px; border: 1px solid #e1e4e8;" />
  </a>
  <p style="text-align: center; color: #586069; font-size: 0.875rem; margin-top: 0.5rem;">Click to view full workflow diagram</p>
</div>

### Prerequisites

<div class="category-grid">
  <div class="category-card">
    <div class="category-icon">✓</div>
    <h4>Know What to Validate</h4>
    <ul>
      <li>List of packages to verify</li>
      <li>Services that should be running</li>
      <li>Configuration files to check</li>
      <li>Expected OpenShift resources</li>
      <li>API endpoints to test</li>
    </ul>
  </div>

  <div class="category-card">
    <div class="category-icon">🚀</div>
    <h4>Have Workload Deployed</h4>
    <pre><code># Know your deployment details:
- OpenShift namespace
- Deployed applications
- Required resources</code></pre>
  </div>

  <div class="category-card">
    <div class="category-icon">📁</div>
    <h4>AgnosticD Repository Access</h4>
    <pre><code>cd ~/work/code/agnosticd</code></pre>
  </div>
</div>

### What You'll Need

<div class="category-grid">
  <div class="category-card">
    <div class="category-icon">🏷️</div>
    <h4>Workload Name</h4>
    <p>Matches your deployment workload</p>
  </div>
  <div class="category-card">
    <div class="category-icon">📋</div>
    <h4>Validation Checks</h4>
    <p>List of checks to perform</p>
  </div>
  <div class="category-card">
    <div class="category-icon">✅</div>
    <h4>Expected State</h4>
    <p>Expected state for each check</p>
  </div>
  <div class="category-card">
    <div class="category-icon">❌</div>
    <h4>Failure Conditions</h4>
    <p>Failure conditions and error messages</p>
  </div>
</div>

---

## Quick Start

<ol class="steps">
  <li><div class="step-content"><h4>Navigate to Repository</h4><p>Open your AgnosticD repository directory</p></div></li>
  <li><div class="step-content"><h4>Run Validator</h4><p><code>/health:deployment-validator</code></p></div></li>
  <li><div class="step-content"><h4>Answer Questions</h4><p>Provide validation requirements</p></div></li>
  <li><div class="step-content"><h4>Review & Test</h4><p>Review generated role and test it</p></div></li>
</ol>

---

## What It Creates

<h4>Generated role in your Ansible collection:</h4>

<pre><code>{collection}/roles/ocp4_workload_{workshop}_validation/
├── defaults/main.yml              # Component toggles + settings
├── tasks/
│   ├── main.yml                   # Orchestrates all checks
│   ├── check_keycloak.yml         # Shared Keycloak namespace
│   ├── check_aap_instances.yml    # Per-user loop
│   ├── check_single_aap_instance.yml
│   ├── check_showroom_instances.yml
│   ├── check_single_showroom.yml
│   └── generate_report.yml        # Results to agnosticd_user_info
└── playbooks/
    └── validate_{workshop}.yml    # Bastion test playbook</code></pre>

---

## Common Validation Types

<div class="category-grid">
  <div class="category-card">
    <h3>Package Validation</h3>
    <p>Verify RPM packages are installed:</p>
    <pre><code>- name: Verify package is installed
  package:
    name: "{{ package_name }}"
    state: present
  check_mode: yes</code></pre>
  </div>

  <div class="category-card">
    <h3>Service Validation</h3>
    <p>Check systemd services are running:</p>
    <pre><code>- name: Verify service is running
  systemd:
    name: "{{ service_name }}"
    state: started
    enabled: yes</code></pre>
  </div>

  <div class="category-card">
    <h3>OpenShift Resource Validation</h3>
    <p>Verify pods, deployments, routes:</p>
    <pre><code>- name: Verify deployment is ready
  kubernetes.core.k8s_info:
    kind: Deployment
    name: "{{ deployment_name }}"
    namespace: "{{ namespace }}"</code></pre>
  </div>
</div>

---

## Tips & Best Practices

<div class="category-grid">
  <div class="category-card">
    <h4>🎯 Start Simple</h4>
    <p>Begin with basic checks first</p>
  </div>
  <div class="category-card">
    <h4>💬 Clear Messages</h4>
    <p>Use clear error messages</p>
  </div>
  <div class="category-card">
    <h4>🧪 Test Thoroughly</h4>
    <p>Test on clean deployment</p>
  </div>
  <div class="category-card">
    <h4>📝 Document Checks</h4>
    <p>Document what each check verifies</p>
  </div>
  <div class="category-card">
    <h4>🔒 Read-Only</h4>
    <p>Validation should not modify state</p>
  </div>
  <div class="category-card">
    <h4>⏱️ Add Retries</h4>
    <p>Resources take time to be ready</p>
  </div>
</div>

---

## Troubleshooting

<details>
<summary><strong>Skill not found?</strong></summary>

<ul>
  <li>Restart Claude Code or VS Code</li>
  <li>Verify installation: <code>ls ~/.claude/skills/deployment-health-checker</code></li>
  <li>Check the <a href="../reference/troubleshooting.html">Troubleshooting Guide</a></li>
</ul>

</details>

<details>
<summary><strong>Validation fails on working deployment?</strong></summary>

<ul>
  <li>Check timing - resources take time to be ready</li>
  <li>Add retries with delays</li>
  <li>Verify variable values are correct</li>
  <li>Use debug mode to inspect actual vs expected state</li>
</ul>

</details>

---

## Related Skills

<div class="links-grid">
  <a href="agnosticv-catalog-builder.html" class="link-card">
    <h4>/agnosticv:catalog-builder</h4>
    <p>Create catalog with validation enabled</p>
  </a>

  <a href="agnosticv-validator.html" class="link-card">
    <h4>/agnosticv:validator</h4>
    <p>Validate catalog configuration</p>
  </a>

  <a href="ftl.html" class="link-card">
    <h4>/ftl:lab-validator</h4>
    <p>Generate automated graders</p>
  </a>
</div>

---

<div class="navigation-footer">
  <a href="index.html" class="nav-button">← Back to Skills</a>
  <a href="ftl.html" class="nav-button">Next: /ftl:lab-validator →</a>
</div>
