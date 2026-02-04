---
layout: default
title: /ftl
---

# /ftl

<div class="skill-badge coming-soon">🎯 FTL - Automated Grading</div>

Finish The Labs - Automated grader and solver generation for workshop testing and validation.

<div class="coming-soon-notice">
  <h3>🚧 Coming Soon</h3>
  <p>This skill is currently in development. The documentation below is a preview of planned functionality.</p>
  <p>Interested in this skill? Share your feedback in Slack: <a href="https://redhat.enterprise.slack.com/archives/C04MLMA15MX" target="_blank">#forum-demo-developers</a></p>
</div>

---

## 📋 What You'll Need Before Starting

### Prerequisites

<div class="prereq-grid">
  <div class="prereq-item">
    <div class="prereq-icon">📚</div>
    <h4>Workshop Content Ready</h4>
    <pre><code># Your Showroom workshop repository with modules:
content/modules/ROOT/pages/
├── module-01.adoc
├── module-02.adoc
└── module-03.adoc</code></pre>
  </div>

  <div class="prereq-item">
    <div class="prereq-icon">📖</div>
    <h4>Understand FTL Grading System</h4>
    <ul>
      <li>Review <a href="https://github.com/redhat-gpte-devopsautomation/FTL" target="_blank">FTL documentation</a></li>
      <li>Know what actions need validation</li>
      <li>Identify success criteria for each module</li>
    </ul>
  </div>

  <div class="prereq-item">
    <div class="prereq-icon">☸️</div>
    <h4>Test Environment Access</h4>
    <pre><code># Access to OpenShift cluster for testing
oc whoami
oc project <test-namespace></code></pre>
  </div>
</div>

### What You'll Need

<div class="inputs-grid">
  <div class="input-card">
    <div class="input-icon">📝</div>
    <h4>Module Files</h4>
    <p>Workshop modules with clear Do/Check sections</p>
  </div>
  <div class="input-card">
    <div class="input-icon">✅</div>
    <h4>Student Actions</h4>
    <p>List of expected actions per module</p>
  </div>
  <div class="input-card">
    <div class="input-icon">🎯</div>
    <h4>Success Criteria</h4>
    <p>Success criteria for each validation</p>
  </div>
  <div class="input-card">
    <div class="input-icon">🧪</div>
    <h4>Test Data</h4>
    <p>Test data or fixtures (if needed)</p>
  </div>
</div>

---

## 🚀 Quick Start

<div class="quick-start-steps">
  <div class="quick-step">
    <div class="quick-step-number">1</div>
    <div class="quick-step-content">
      <h4>Navigate to Repository</h4>
      <p>Open your workshop repository</p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">2</div>
    <div class="quick-step-content">
      <h4>Run FTL</h4>
      <p><code>/ftl</code></p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">3</div>
    <div class="quick-step-content">
      <h4>Specify Modules</h4>
      <p>Choose modules to generate graders for</p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">4</div>
    <div class="quick-step-content">
      <h4>Review & Test</h4>
      <p>Test validation logic</p>
    </div>
  </div>
</div>

---

## 📁 What It Creates

<div class="file-structure">
  <h4>Generated Directory Structure:</h4>
  <pre><code>ftl/
├── graders/
│   ├── grade_module_01.yml     # Grader for module 1
│   ├── grade_module_02.yml     # Grader for module 2
│   └── grade_module_03.yml     # Grader for module 3
├── solvers/
│   ├── solve_module_01.yml     # Solver for module 1
│   ├── solve_module_02.yml     # Solver for module 2
│   └── solve_module_03.yml     # Solver for module 3
└── tests/
    └── integration_test.yml    # Full workshop test</code></pre>
</div>

---

## 🔧 How It Works

<div class="how-it-works-grid">
  <div class="how-card">
    <h3>✓ Graders</h3>
    <p>Graders validate that students completed tasks correctly:</p>
    <ul>
      <li>Check for created resources (pods, routes, etc.)</li>
      <li>Verify configuration values</li>
      <li>Test application functionality</li>
      <li>Award points for correct completion</li>
    </ul>
  </div>

  <div class="how-card">
    <h3>🤖 Solvers</h3>
    <p>Solvers automatically complete workshop modules:</p>
    <ul>
      <li>Execute all student tasks programmatically</li>
      <li>Verify each step succeeds</li>
      <li>Used for testing grader accuracy</li>
      <li>Ensure workshop is technically sound</li>
    </ul>
  </div>
</div>

---

## 🔄 Common Workflow

<div class="workflow-steps">
  <div class="workflow-step">
    <div class="workflow-icon">1️⃣</div>
    <div class="workflow-content">
      <h4>Create Workshop Content</h4>
      <pre><code>/showroom:create-lab
→ Generate workshop modules
→ Define clear success criteria</code></pre>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">2️⃣</div>
    <div class="workflow-content">
      <h4>Generate FTL Graders and Solvers</h4>
      <pre><code>/ftl
→ Analyze module tasks
→ Generate validation logic
→ Create solver automation</code></pre>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">3️⃣</div>
    <div class="workflow-content">
      <h4>Test with Solver</h4>
      <pre><code># Run solver to complete workshop automatically:
ansible-playbook ftl/solvers/solve_module_01.yml</code></pre>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">4️⃣</div>
    <div class="workflow-content">
      <h4>Validate with Grader</h4>
      <pre><code># Run grader to check if tasks completed correctly:
ansible-playbook ftl/graders/grade_module_01.yml</code></pre>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">5️⃣</div>
    <div class="workflow-content">
      <h4>Integrate with Workshop</h4>
      <pre><code># Add grading to workshop deployment:
ftl_grading_enabled: true
ftl_graders_path: "{{ workshop_path }}/ftl/graders"</code></pre>
    </div>
  </div>
</div>

---

## 📝 Example Grader

<div class="example-box">
  <h4>For a module that deploys a pod:</h4>
  <pre><code>---
# ftl/graders/grade_module_01.yml
- name: Grade Module 01 - Deploy Application
  hosts: localhost
  gather_facts: false
  tasks:
    - name: Check if namespace exists
      kubernetes.core.k8s_info:
        kind: Namespace
        name: student-app
      register: ns_check

    - name: Award points for namespace
      set_fact:
        points: "{{ points | default(0) | int + 10 }}"
      when: ns_check.resources | length > 0

    - name: Check if deployment exists
      kubernetes.core.k8s_info:
        kind: Deployment
        name: myapp
        namespace: student-app
      register: deploy_check

    - name: Award points for deployment
      set_fact:
        points: "{{ points | default(0) | int + 20 }}"
      when:
        - deploy_check.resources | length > 0
        - deploy_check.resources[0].status.readyReplicas > 0

    - name: Display final score
      debug:
        msg: "Module 01 Score: {{ points | default(0) }}/30"</code></pre>
</div>

---

## 🤖 Example Solver

<div class="example-box">
  <h4>Corresponding solver for the same module:</h4>
  <pre><code>---
# ftl/solvers/solve_module_01.yml
- name: Solve Module 01 - Deploy Application
  hosts: localhost
  gather_facts: false
  tasks:
    - name: Create namespace
      kubernetes.core.k8s:
        kind: Namespace
        name: student-app
        state: present

    - name: Create deployment
      kubernetes.core.k8s:
        state: present
        definition:
          apiVersion: apps/v1
          kind: Deployment
          metadata:
            name: myapp
            namespace: student-app
          spec:
            replicas: 1
            selector:
              matchLabels:
                app: myapp
            template:
              metadata:
                labels:
                  app: myapp
              spec:
                containers:
                - name: myapp
                  image: registry.redhat.io/ubi9/httpd-24:latest

    - name: Wait for deployment to be ready
      kubernetes.core.k8s_info:
        kind: Deployment
        name: myapp
        namespace: student-app
      register: deploy_status
      until: deploy_status.resources[0].status.readyReplicas | default(0) > 0
      retries: 30
      delay: 10</code></pre>
</div>

---

## 💡 Tips & Best Practices

<div class="tips-grid">
  <div class="tip-card">
    <h4>🎯 Start Simple</h4>
    <p>Basic validation before complex checks</p>
  </div>
  <div class="tip-card">
    <h4>🧪 Test Solver First</h4>
    <p>Ensure workshop tasks actually work</p>
  </div>
  <div class="tip-card">
    <h4>✅ Clear Success Criteria</h4>
    <p>Each task needs measurable outcome</p>
  </div>
  <div class="tip-card">
    <h4>📊 Partial Credit</h4>
    <p>Award points for partial completion</p>
  </div>
  <div class="tip-card">
    <h4>💬 Helpful Feedback</h4>
    <p>Graders should explain what's missing</p>
  </div>
  <div class="tip-card">
    <h4>🔄 Idempotent Solvers</h4>
    <p>Should be safe to run multiple times</p>
  </div>
</div>

---

## 🔗 Integration with Health Namespace

<div class="integration-box">
  <h4>FTL graders integrate with RHDP Health validation:</h4>
  <pre><code># In AgnosticV catalog:
health_ftl:
  enabled: true
  graders_path: "{{ workshop_ftl_path }}/graders"
  schedule: "*/15 * * * *"  # Run every 15 minutes
  alert_on_failure: true
  min_score_threshold: 80  # Alert if score < 80%</code></pre>

  <h4 style="margin-top: 1.5rem;">This enables:</h4>
  <ul>
    <li>Continuous workshop validation</li>
    <li>Automated testing of workshop functionality</li>
    <li>Early detection of broken labs</li>
    <li>Student progress tracking</li>
  </ul>
</div>

---

## 🆘 Troubleshooting

<details>
<summary><strong>Skill not found?</strong></summary>

<ul>
  <li>Restart Claude Code or VS Code</li>
  <li>Verify installation: <code>ls ~/.claude/skills/ftl</code></li>
  <li>Check the <a href="../reference/troubleshooting.html">Troubleshooting Guide</a></li>
</ul>

</details>

<details>
<summary><strong>Grader fails but solver works?</strong></summary>

<ul>
  <li>Check grader logic matches solver actions</li>
  <li>Verify validation criteria are correct</li>
  <li>Add debug output to see what grader finds</li>
  <li>Compare expected vs actual resource states</li>
</ul>

</details>

<details>
<summary><strong>Solver fails on valid workshop?</strong></summary>

<ul>
  <li>Review module instructions for accuracy</li>
  <li>Check for timing issues (add waits)</li>
  <li>Verify resource names match exactly</li>
  <li>Test solver steps manually first</li>
</ul>

</details>

<details>
<summary><strong>Points don't add up correctly?</strong></summary>

<ul>
  <li>Initialize points variable at start</li>
  <li>Use <code>| default(0)</code> for safety</li>
  <li>Debug each scoring section</li>
  <li>Verify conditional logic for point awards</li>
</ul>

</details>

---

## 🔗 Related Skills

<div class="related-skills">
  <a href="create-lab.html" class="related-skill-card">
    <div class="related-skill-icon">📝</div>
    <div class="related-skill-content">
      <h4>/showroom:create-lab</h4>
      <p>Create workshop content first</p>
    </div>
  </a>

  <a href="deployment-health-checker.html" class="related-skill-card">
    <div class="related-skill-icon">🏥</div>
    <div class="related-skill-content">
      <h4>/health:deployment-validator</h4>
      <p>Create deployment validators</p>
    </div>
  </a>

  <a href="verify-content.html" class="related-skill-card">
    <div class="related-skill-icon">✓</div>
    <div class="related-skill-content">
      <h4>/showroom:verify-content</h4>
      <p>Validate workshop quality</p>
    </div>
  </a>
</div>

---

## 📚 FTL Resources

<div class="resources-box">
  <h4>Helpful Links:</h4>
  <ul>
    <li><a href="https://github.com/redhat-gpte-devopsautomation/FTL" target="_blank">FTL Grading System</a></li>
    <li><a href="https://github.com/redhat-gpte-devopsautomation/FTL/blob/main/docs/best-practices.md" target="_blank">FTL Best Practices</a></li>
    <li>Health Namespace Documentation (coming soon)</li>
  </ul>
</div>

---

<div class="navigation-footer">
  <a href="index.html" class="nav-button">← Back to Skills</a>
  <a href="deployment-health-checker.html" class="nav-button">Next: /health:deployment-validator →</a>
</div>

<style>
.skill-badge {
  display: inline-block;
  background: linear-gradient(135deg, #F59E0B 0%, #D97706 100%);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  font-weight: 600;
  margin: 1rem 0;
}

.skill-badge.coming-soon {
  background: linear-gradient(135deg, #6366F1 0%, #4F46E5 100%);
}

.coming-soon-notice {
  background: linear-gradient(135deg, #FEF3C7 0%, #FDE68A 100%);
  border: 2px solid #F59E0B;
  border-radius: 12px;
  padding: 2rem;
  margin: 2rem 0;
}

.coming-soon-notice h3 {
  margin-top: 0;
  color: #92400E;
}

.coming-soon-notice p {
  margin: 0.5rem 0;
  color: #78350F;
}

.coming-soon-notice a {
  color: #0969da;
  text-decoration: underline;
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
  background: linear-gradient(135deg, #6366F1 0%, #4F46E5 100%);
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

.how-it-works-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.how-card {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 12px;
  padding: 1.5rem;
}

.how-card h3 {
  margin-top: 0;
  color: #6366F1;
  font-size: 1.125rem;
}

.how-card p {
  color: #586069;
  margin: 0.5rem 0;
}

.how-card ul {
  margin: 0.5rem 0 0 0;
  padding-left: 1.25rem;
  color: #586069;
  font-size: 0.875rem;
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

.example-box {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 12px;
  padding: 1.5rem;
  margin: 1.5rem 0;
}

.example-box h4 {
  margin-top: 0;
  color: #24292e;
}

.example-box pre {
  background: white;
  padding: 1rem;
  border-radius: 6px;
  margin: 0.5rem 0 0 0;
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

.integration-box {
  background: linear-gradient(135deg, #E0E7FF 0%, #C7D2FE 100%);
  border: 2px solid #6366F1;
  border-radius: 12px;
  padding: 1.5rem;
  margin: 2rem 0;
}

.integration-box h4 {
  margin-top: 0;
  color: #3730A3;
}

.integration-box pre {
  background: white;
  padding: 1rem;
  border-radius: 6px;
  margin: 0.5rem 0;
}

.integration-box ul {
  margin: 0.5rem 0 0 0;
  padding-left: 1.25rem;
  color: #3730A3;
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
  border-color: #6366F1;
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

.resources-box {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 1px solid #e1e4e8;
  border-radius: 12px;
  padding: 1.5rem;
  margin: 1rem 0;
}

.resources-box h4 {
  margin-top: 0;
  color: #24292e;
}

.resources-box a {
  color: #0969da;
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
  border-color: #6366F1;
  color: #6366F1;
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
  color: #6366F1;
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
