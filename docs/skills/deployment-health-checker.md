---
layout: default
title: /health:deployment-validator
---

# /health:deployment-validator

<div class="skill-badge">🏥 Deployment Health Validation</div>

Create Ansible validation roles for post-deployment health checks and verification.

---

## 📋 What You'll Need Before Starting

<div class="workflow-diagram">
  <a href="deployment-validator-workflow.svg" target="_blank">
    <img src="deployment-validator-workflow.svg" alt="deployment-validator workflow diagram" style="max-width: 100%; height: auto; border-radius: 8px; border: 1px solid #e1e4e8;" />
  </a>
  <p style="text-align: center; color: #586069; font-size: 0.875rem; margin-top: 0.5rem;">Click to view full workflow diagram</p>
</div>

### Prerequisites

<div class="prereq-grid">
  <div class="prereq-item">
    <div class="prereq-icon">✓</div>
    <h4>Know What to Validate</h4>
    <ul>
      <li>List of packages to verify</li>
      <li>Services that should be running</li>
      <li>Configuration files to check</li>
      <li>Expected OpenShift resources</li>
      <li>API endpoints to test</li>
    </ul>
  </div>

  <div class="prereq-item">
    <div class="prereq-icon">🚀</div>
    <h4>Have Workload Deployed</h4>
    <pre><code># Know your deployment details:
- OpenShift namespace
- Deployed applications
- Required resources</code></pre>
  </div>

  <div class="prereq-item">
    <div class="prereq-icon">📁</div>
    <h4>AgnosticD Repository Access</h4>
    <pre><code>cd ~/work/code/agnosticd</code></pre>
  </div>
</div>

### What You'll Need

<div class="inputs-grid">
  <div class="input-card">
    <div class="input-icon">🏷️</div>
    <h4>Workload Name</h4>
    <p>Matches your deployment workload</p>
  </div>
  <div class="input-card">
    <div class="input-icon">📋</div>
    <h4>Validation Checks</h4>
    <p>List of checks to perform</p>
  </div>
  <div class="input-card">
    <div class="input-icon">✅</div>
    <h4>Expected State</h4>
    <p>Expected state for each check</p>
  </div>
  <div class="input-card">
    <div class="input-icon">❌</div>
    <h4>Failure Conditions</h4>
    <p>Failure conditions and error messages</p>
  </div>
</div>

---

## 🚀 Quick Start

<div class="quick-start-steps">
  <div class="quick-step">
    <div class="quick-step-number">1</div>
    <div class="quick-step-content">
      <h4>Navigate to Repository</h4>
      <p>Open your AgnosticD repository directory</p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">2</div>
    <div class="quick-step-content">
      <h4>Run Validator</h4>
      <p><code>/health:deployment-validator</code></p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">3</div>
    <div class="quick-step-content">
      <h4>Answer Questions</h4>
      <p>Provide validation requirements</p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">4</div>
    <div class="quick-step-content">
      <h4>Review & Test</h4>
      <p>Review generated role and test it</p>
    </div>
  </div>
</div>

---

## 📁 What It Creates

<div class="file-structure">
  <h4>Generated Directory Structure:</h4>
  <pre><code>~/work/code/agnosticd/roles/ocp4_workload_<name>_validation/
├── defaults/main.yml          # Default variables
├── tasks/
│   ├── main.yml              # Main validation tasks
│   ├── pre_workload.yml      # Pre-checks
│   ├── workload.yml          # Core validation
│   └── post_workload.yml     # Post-checks
└── README.md                  # Documentation</code></pre>
</div>

---

## 🔍 Common Validation Types

<div class="validation-types">
  <div class="validation-card">
    <h3>📦 Package Validation</h3>
    <p>Verify RPM packages are installed:</p>
    <pre><code>- name: Verify package is installed
  package:
    name: "{{ package_name }}"
    state: present
  check_mode: yes</code></pre>
  </div>

  <div class="validation-card">
    <h3>⚙️ Service Validation</h3>
    <p>Check systemd services are running:</p>
    <pre><code>- name: Verify service is running
  systemd:
    name: "{{ service_name }}"
    state: started
    enabled: yes</code></pre>
  </div>

  <div class="validation-card">
    <h3>☸️ OpenShift Resource Validation</h3>
    <p>Verify pods, deployments, routes:</p>
    <pre><code>- name: Verify deployment is ready
  kubernetes.core.k8s_info:
    kind: Deployment
    name: "{{ deployment_name }}"
    namespace: "{{ namespace }}"</code></pre>
  </div>
</div>

---

## 💡 Tips & Best Practices

<div class="tips-grid">
  <div class="tip-card">
    <h4>🎯 Start Simple</h4>
    <p>Begin with basic checks first</p>
  </div>
  <div class="tip-card">
    <h4>💬 Clear Messages</h4>
    <p>Use clear error messages</p>
  </div>
  <div class="tip-card">
    <h4>🧪 Test Thoroughly</h4>
    <p>Test on clean deployment</p>
  </div>
  <div class="tip-card">
    <h4>📝 Document Checks</h4>
    <p>Document what each check verifies</p>
  </div>
  <div class="tip-card">
    <h4>🔒 Read-Only</h4>
    <p>Validation should not modify state</p>
  </div>
  <div class="tip-card">
    <h4>⏱️ Add Retries</h4>
    <p>Resources take time to be ready</p>
  </div>
</div>

---

## 🆘 Troubleshooting

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

## 🔗 Related Skills

<div class="related-skills">
  <a href="agnosticv-catalog-builder.html" class="related-skill-card">
    <div class="related-skill-icon">🔧</div>
    <div class="related-skill-content">
      <h4>/agnosticv:catalog-builder</h4>
      <p>Create catalog with validation enabled</p>
    </div>
  </a>

  <a href="agnosticv-validator.html" class="related-skill-card">
    <div class="related-skill-icon">✓</div>
    <div class="related-skill-content">
      <h4>/agnosticv:validator</h4>
      <p>Validate catalog configuration</p>
    </div>
  </a>

  <a href="ftl.html" class="related-skill-card">
    <div class="related-skill-icon">🎯</div>
    <div class="related-skill-content">
      <h4>/ftl</h4>
      <p>Generate automated graders</p>
    </div>
  </a>
</div>

---

<div class="navigation-footer">
  <a href="index.html" class="nav-button">← Back to Skills</a>
  <a href="ftl.html" class="nav-button">Next: /ftl →</a>
</div>

<style>
.skill-badge {
  display: inline-block;
  background: linear-gradient(135deg, #28a745 0%, #20893a 100%);
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

.inputs-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin: 1.5rem 0;
}

.input-card {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
  text-align: center;
}

.input-icon {
  font-size: 2rem;
  margin-bottom: 0.5rem;
}

.input-card h4 {
  margin: 0.5rem 0;
  color: #24292e;
  font-size: 1rem;
}

.input-card p {
  margin: 0;
  color: #586069;
  font-size: 0.875rem;
}

.quick-start-steps {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
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
  background: linear-gradient(135deg, #28a745 0%, #20893a 100%);
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

.file-structure {
  background: #f6f8fa;
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
  margin: 1rem 0;
}

.file-structure h4 {
  margin-top: 0;
  color: #24292e;
}

.file-structure pre {
  background: white;
  padding: 1rem;
  border-radius: 6px;
  margin: 0.5rem 0 0 0;
}

.validation-types {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.validation-card {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 12px;
  padding: 1.5rem;
}

.validation-card h3 {
  margin-top: 0;
  color: #28a745;
  font-size: 1.125rem;
}

.validation-card p {
  color: #586069;
  margin: 0.5rem 0;
}

.validation-card pre {
  background: white;
  padding: 1rem;
  border-radius: 6px;
  margin: 0.75rem 0 0 0;
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
  border-color: #28a745;
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
  border-color: #28a745;
  color: #28a745;
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
  color: #28a745;
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
