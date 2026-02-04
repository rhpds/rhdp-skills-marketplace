---
layout: default
title: Showroom Namespace Setup
---

# Showroom Namespace Setup

<div class="namespace-badge showroom">📝 Content Creation Skills</div>

Complete setup guide for Red Hat Showroom workshop and demo content creation.

---

## 📖 Overview

<div class="overview-box">
  <p>The <strong>showroom</strong> namespace provides AI-powered skills for creating Red Hat Showroom workshop and demo content. These skills focus purely on content creation without infrastructure provisioning.</p>

  <div class="audience-tag">
    <strong>Target Audience:</strong> Content creators, technical writers, workshop developers
  </div>
</div>

---

## 📦 Installation

<div class="install-instructions">
  <h4>Install the showroom namespace:</h4>
  <div class="install-tabs">
    <div class="install-tab">
      <h5>Claude Code</h5>
      <pre><code>/plugin marketplace add rhpds/rhdp-skills-marketplace
/plugin install showroom@rhdp-marketplace</code></pre>
    </div>
    <div class="install-tab">
      <h5>Cursor</h5>
      <pre><code>curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install-cursor.sh | bash</code></pre>
    </div>
  </div>
</div>

---

## 🛠️ Included Skills

<div class="skills-showcase">
  <a href="../skills/create-lab.html" class="showcase-card">
    <div class="showcase-icon">📝</div>
    <h3>/showroom:create-lab</h3>
    <p>Generate workshop lab modules with Red Hat Showroom structure</p>
    <div class="features-list">
      <ul>
        <li>Know/Do/Check pedagogical structure</li>
        <li>Multi-module workshops</li>
        <li>Proper AsciiDoc formatting</li>
        <li>Dynamic content placeholders</li>
      </ul>
    </div>
    <div class="view-docs">View detailed documentation →</div>
  </a>

  <a href="../skills/create-demo.html" class="showcase-card">
    <div class="showcase-icon">🎭</div>
    <h3>/showroom:create-demo</h3>
    <p>Generate presenter-led demo content</p>
    <div class="features-list">
      <ul>
        <li>Know/Show demo structure</li>
        <li>Presenter notes</li>
        <li>Show-first approach</li>
        <li>Time estimates per section</li>
      </ul>
    </div>
    <div class="view-docs">View detailed documentation →</div>
  </a>

  <a href="../skills/verify-content.html" class="showcase-card">
    <div class="showcase-icon">✓</div>
    <h3>/showroom:verify-content</h3>
    <p>AI-powered quality validation for workshop and demo content</p>
    <div class="features-list">
      <ul>
        <li>AsciiDoc syntax checking</li>
        <li>Know/Do/Check structure validation</li>
        <li>Exercise clarity checks</li>
        <li>Red Hat style guide compliance</li>
      </ul>
    </div>
    <div class="view-docs">View detailed documentation →</div>
  </a>

  <a href="../skills/blog-generate.html" class="showcase-card">
    <div class="showcase-icon">📰</div>
    <h3>/showroom:blog-generate</h3>
    <p>Transform completed lab/demo content into blog posts</p>
    <div class="features-list">
      <ul>
        <li>Blog-appropriate formatting</li>
        <li>Key takeaways extraction</li>
        <li>Call-to-action generation</li>
        <li>Red Hat Developer blog style</li>
      </ul>
    </div>
    <div class="view-docs">View detailed documentation →</div>
  </a>
</div>

---

## ✓ Prerequisites

<div class="prerequisites-grid">
  <div class="prereq-section required">
    <h3>Required</h3>
    <ul>
      <li><strong>Claude Code</strong> or <strong>Cursor</strong> installed</li>
      <li>Basic understanding of AsciiDoc (helpful but not required)</li>
    </ul>
  </div>

  <div class="prereq-section optional">
    <h3>Optional</h3>
    <ul>
      <li>Red Hat Showroom template repository</li>
      <li>GitHub account for publishing</li>
      <li>Red Hat Developer account (for blog publishing)</li>
    </ul>
  </div>
</div>

---

## 🔄 Typical Workflow

<div class="workflow-diagram-box">
  <div class="workflow-flow">
    <div class="flow-item">
      <div class="flow-number">1</div>
      <div class="flow-content">
        <code>/showroom:create-lab</code> or <code>/showroom:create-demo</code>
      </div>
    </div>

    <div class="flow-arrow">↓</div>

    <div class="flow-item">
      <div class="flow-number">2</div>
      <div class="flow-content">
        Review and edit generated content
      </div>
    </div>

    <div class="flow-arrow">↓</div>

    <div class="flow-item">
      <div class="flow-number">3</div>
      <div class="flow-content">
        <code>/showroom:verify-content</code>
      </div>
    </div>

    <div class="flow-arrow">↓</div>

    <div class="flow-item">
      <div class="flow-number">4</div>
      <div class="flow-content">
        Fix any issues identified
      </div>
    </div>

    <div class="flow-arrow">↓</div>

    <div class="flow-item">
      <div class="flow-number">5</div>
      <div class="flow-content">
        <code>/showroom:blog-generate</code> <span class="optional-tag">(optional)</span>
      </div>
    </div>

    <div class="flow-arrow">↓</div>

    <div class="flow-item">
      <div class="flow-number">6</div>
      <div class="flow-content">
        Publish to Showroom and/or blog
      </div>
    </div>
  </div>
</div>

---

## 📚 Example: Creating a Workshop Lab

<div class="example-workflow">
  <div class="example-step">
    <div class="step-header">
      <span class="step-badge">Step 1</span>
      <h3>Run /showroom:create-lab</h3>
    </div>
    <pre><code>In Claude Code or Cursor:
/showroom:create-lab

Answer prompts:
- Lab name: "CI/CD with OpenShift Pipelines"
- Abstract: "Learn cloud-native CI/CD using Tekton pipelines on OpenShift"
- Technologies: Tekton, OpenShift, Pipelines
- Module count: 3</code></pre>
  </div>

  <div class="example-step">
    <div class="step-header">
      <span class="step-badge">Step 2</span>
      <h3>Generated Structure</h3>
    </div>
    <pre><code>content/modules/ROOT/
├── pages/
│   ├── index.adoc
│   ├── module-01.adoc
│   ├── module-02.adoc
│   └── module-03.adoc
├── partials/
│   └── _attributes.adoc
└── nav.adoc</code></pre>
  </div>

  <div class="example-step">
    <div class="step-header">
      <span class="step-badge">Step 3</span>
      <h3>Verify Quality</h3>
    </div>
    <pre><code>/showroom:verify-content

Reviews:
✓ AsciiDoc syntax
✓ Know/Do/Check structure
✓ Exercise clarity
⚠️ Suggestions for improvement</code></pre>
  </div>

  <div class="example-step">
    <div class="step-header">
      <span class="step-badge">Step 4</span>
      <h3>Generate Blog (Optional)</h3>
    </div>
    <pre><code>/showroom:blog-generate

Creates:
- Blog post from workshop content
- Introduction and conclusion
- Key takeaways
- Call-to-action</code></pre>
  </div>
</div>

---

## 📄 Content Structure

<div class="content-structure-box">
  <h3>Module Format (Know/Do/Check)</h3>
  <p>Each module follows this structure:</p>

  <pre><code>= Module Title

== Know (2 minutes)

Brief explanation of the concept...

== Do (8 minutes)

Hands-on exercise:

.Procedure
. Step 1
. Step 2
. Step 3

.Verification
After completing...you should see...</code></pre>
</div>

<div class="attributes-box">
  <h3>Placeholder Attributes</h3>
  <p>Use these in your content:</p>

  <table class="attributes-table">
    <thead>
      <tr>
        <th>Attribute</th>
        <th>Usage</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><code>{openshift_console_url}</code></td>
        <td>Console URL</td>
      </tr>
      <tr>
        <td><code>{user}</code></td>
        <td>Username</td>
      </tr>
      <tr>
        <td><code>{password}</code></td>
        <td>Password</td>
      </tr>
      <tr>
        <td><code>{user_namespace}</code></td>
        <td>Namespace</td>
      </tr>
      <tr>
        <td><code>{api_url}</code></td>
        <td>API URL</td>
      </tr>
    </tbody>
  </table>

  <p style="margin-top: 1rem;">Defined in <code>partials/_attributes.adoc</code></p>
</div>

---

## 💡 Tips & Best Practices

<div class="tips-section">
  <div class="tips-category">
    <h3>Content Creation</h3>
    <div class="tips-list">
      <div class="tip-item">
        <span class="tip-number">1</span>
        <div class="tip-text">
          <strong>Start with clear objectives</strong> - Know what learners should achieve
        </div>
      </div>
      <div class="tip-item">
        <span class="tip-number">2</span>
        <div class="tip-text">
          <strong>Keep modules focused</strong> - One concept per module
        </div>
      </div>
      <div class="tip-item">
        <span class="tip-number">3</span>
        <div class="tip-text">
          <strong>Use active voice</strong> - "Create a pipeline" not "A pipeline is created"
        </div>
      </div>
      <div class="tip-item">
        <span class="tip-number">4</span>
        <div class="tip-text">
          <strong>Test exercises</strong> - Ensure steps work as documented
        </div>
      </div>
      <div class="tip-item">
        <span class="tip-number">5</span>
        <div class="tip-text">
          <strong>Add verification</strong> - Help learners confirm success
        </div>
      </div>
    </div>
  </div>

  <div class="tips-category">
    <h3>Using Skills</h3>
    <div class="tips-list">
      <div class="tip-item">
        <span class="tip-number">1</span>
        <div class="tip-text">
          <strong>Be specific with prompts</strong> - More detail = better output
        </div>
      </div>
      <div class="tip-item">
        <span class="tip-number">2</span>
        <div class="tip-text">
          <strong>Iterate on content</strong> - Run /showroom:create-lab multiple times if needed
        </div>
      </div>
      <div class="tip-item">
        <span class="tip-number">3</span>
        <div class="tip-text">
          <strong>Verify early</strong> - Run /showroom:verify-content before extensive edits
        </div>
      </div>
      <div class="tip-item">
        <span class="tip-number">4</span>
        <div class="tip-text">
          <strong>Leverage examples</strong> - Ask skills for similar examples
        </div>
      </div>
    </div>
  </div>
</div>

---

## 🆘 Troubleshooting

<details>
<summary><strong>Skill Not Found</strong></summary>

<div class="troubleshoot-content">
  <p><strong>Problem:</strong> <code>/showroom:create-lab</code> not recognized</p>

  <p><strong>Solution:</strong></p>
  <ol>
    <li>Restart your editor</li>
    <li>Verify installation: <code>ls ~/.claude/skills/</code> or <code>ls ~/.cursor/skills/</code></li>
    <li>Reinstall if needed</li>
  </ol>
</div>

</details>

<details>
<summary><strong>Generated Content Has Issues</strong></summary>

<div class="troubleshoot-content">
  <p><strong>Problem:</strong> Content doesn't meet quality standards</p>

  <p><strong>Solution:</strong></p>
  <ol>
    <li>Run <code>/showroom:verify-content</code> to identify specific issues</li>
    <li>Edit content based on suggestions</li>
    <li>Re-verify after changes</li>
  </ol>
</div>

</details>

<details>
<summary><strong>Attributes Not Rendering</strong></summary>

<div class="troubleshoot-content">
  <p><strong>Problem:</strong> <code>{openshift_console_url}</code> shows as literal text</p>

  <p><strong>Solution:</strong></p>
  <p>Ensure <code>_attributes.adoc</code> is defined in <code>partials/</code>:</p>

  <pre><code>:openshift_console_url: https://console-openshift-console.apps.cluster.example.com
:user: user1
:password: openshift</code></pre>
</div>

</details>

---

## 🔗 Next Steps

<div class="next-steps-grid">
  <a href="../skills/" class="next-step-card">
    <div class="next-step-icon">📚</div>
    <h4>View All Skills</h4>
    <p>Explore skill documentation</p>
  </a>

  <a href="../reference/quick-reference.html" class="next-step-card">
    <div class="next-step-icon">⚡</div>
    <h4>Quick Reference</h4>
    <p>Common commands & workflows</p>
  </a>

  <a href="../reference/troubleshooting.html" class="next-step-card">
    <div class="next-step-icon">🔧</div>
    <h4>Troubleshooting</h4>
    <p>Common issues & solutions</p>
  </a>
</div>

---

<div class="navigation-footer">
  <a href="index.html" class="nav-button">← Back to Setup</a>
  <a href="agnosticv.html" class="nav-button">Next: AgnosticV Setup →</a>
</div>

<style>
.namespace-badge {
  display: inline-block;
  background: linear-gradient(135deg, #EE0000 0%, #CC0000 100%);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  font-weight: 600;
  margin: 1rem 0;
}

.namespace-badge.showroom {
  background: linear-gradient(135deg, #EE0000 0%, #CC0000 100%);
}

.overview-box {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 12px;
  padding: 2rem;
  margin: 2rem 0;
}

.overview-box p {
  margin: 0 0 1rem 0;
  color: #24292e;
  line-height: 1.6;
}

.audience-tag {
  background: #e7f3ff;
  border-left: 4px solid #0969da;
  padding: 0.75rem 1rem;
  border-radius: 4px;
  margin-top: 1rem;
}

.install-instructions {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 12px;
  padding: 2rem;
  margin: 2rem 0;
}

.install-instructions h4 {
  margin-top: 0;
  color: #24292e;
}

.install-tabs {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1rem;
  margin-top: 1rem;
}

.install-tab {
  background: white;
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 1rem;
}

.install-tab h5 {
  margin-top: 0;
  color: #EE0000;
}

.install-tab pre {
  margin: 0.5rem 0 0 0;
}

.skills-showcase {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.showcase-card {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 12px;
  padding: 2rem;
  text-decoration: none;
  color: inherit;
  transition: all 0.3s ease;
}

.showcase-card:hover {
  border-color: #EE0000;
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
}

.showcase-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.showcase-card h3 {
  margin: 0.5rem 0;
  color: #24292e;
  font-size: 1.25rem;
}

.showcase-card > p {
  color: #586069;
  margin: 0.5rem 0 1rem 0;
}

.features-list ul {
  margin: 0;
  padding-left: 1.25rem;
  color: #586069;
  font-size: 0.875rem;
}

.features-list li {
  margin: 0.25rem 0;
}

.view-docs {
  margin-top: 1rem;
  color: #0969da;
  font-weight: 600;
}

.prerequisites-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.prereq-section {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 12px;
  padding: 1.5rem;
}

.prereq-section.required {
  border-color: #EE0000;
}

.prereq-section.optional {
  border-color: #0969da;
}

.prereq-section h3 {
  margin-top: 0;
  color: #24292e;
}

.prereq-section ul {
  margin: 0;
  padding-left: 1.25rem;
  color: #586069;
}

.workflow-diagram-box {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 12px;
  padding: 2rem;
  margin: 2rem 0;
}

.workflow-flow {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.flow-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  background: white;
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 1rem;
}

.flow-number {
  flex-shrink: 0;
  width: 32px;
  height: 32px;
  background: #EE0000;
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
}

.flow-content {
  flex: 1;
  color: #24292e;
}

.flow-content code {
  background: #f6f8fa;
  padding: 0.2rem 0.4rem;
  border-radius: 3px;
  color: #EE0000;
}

.optional-tag {
  color: #586069;
  font-size: 0.875rem;
  font-style: italic;
}

.flow-arrow {
  text-align: center;
  color: #586069;
  font-size: 1.5rem;
  margin: 0.25rem 0;
}

.example-workflow {
  margin: 2rem 0;
}

.example-step {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 1px solid #e1e4e8;
  border-radius: 12px;
  padding: 1.5rem;
  margin-bottom: 1.5rem;
}

.step-header {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-bottom: 1rem;
}

.step-badge {
  background: #EE0000;
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-size: 0.875rem;
  font-weight: 600;
}

.step-header h3 {
  margin: 0;
  color: #24292e;
  font-size: 1.125rem;
}

.example-step pre {
  background: white;
  padding: 1rem;
  border-radius: 6px;
  margin: 0;
}

.content-structure-box, .attributes-box {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 12px;
  padding: 2rem;
  margin: 2rem 0;
}

.content-structure-box h3, .attributes-box h3 {
  margin-top: 0;
  color: #24292e;
}

.content-structure-box p, .attributes-box p {
  color: #586069;
  margin: 0.5rem 0;
}

.content-structure-box pre {
  background: white;
  padding: 1rem;
  border-radius: 6px;
  margin: 1rem 0 0 0;
}

.attributes-table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  border-radius: 8px;
  overflow: hidden;
  margin: 1rem 0;
}

.attributes-table thead {
  background: #f6f8fa;
}

.attributes-table th {
  padding: 0.75rem;
  text-align: left;
  font-weight: 600;
  border-bottom: 2px solid #e1e4e8;
}

.attributes-table td {
  padding: 0.75rem;
  border-bottom: 1px solid #e1e4e8;
}

.attributes-table tbody tr:last-child td {
  border-bottom: none;
}

.attributes-table code {
  background: #f6f8fa;
  padding: 0.2rem 0.4rem;
  border-radius: 3px;
  color: #EE0000;
  font-size: 0.875rem;
}

.tips-section {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.tips-category {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 12px;
  padding: 2rem;
}

.tips-category h3 {
  margin-top: 0;
  color: #24292e;
}

.tips-list {
  margin-top: 1rem;
}

.tip-item {
  display: flex;
  gap: 1rem;
  margin-bottom: 1rem;
  align-items: start;
}

.tip-number {
  flex-shrink: 0;
  width: 28px;
  height: 28px;
  background: #EE0000;
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 0.875rem;
}

.tip-text {
  flex: 1;
  color: #586069;
  font-size: 0.875rem;
}

.tip-text strong {
  color: #24292e;
}

.troubleshoot-content {
  padding: 1rem 0;
}

.troubleshoot-content p {
  margin: 0.5rem 0;
}

.troubleshoot-content ol, .troubleshoot-content ul {
  margin: 0.5rem 0;
  padding-left: 1.5rem;
}

.troubleshoot-content pre {
  background: #f6f8fa;
  padding: 1rem;
  border-radius: 6px;
  margin: 0.5rem 0;
}

.next-steps-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin: 2rem 0;
}

.next-step-card {
  display: block;
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 12px;
  padding: 1.5rem;
  text-decoration: none;
  color: inherit;
  text-align: center;
  transition: all 0.3s ease;
}

.next-step-card:hover {
  border-color: #EE0000;
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
}

.next-step-icon {
  font-size: 2.5rem;
  margin-bottom: 0.5rem;
}

.next-step-card h4 {
  margin: 0.5rem 0;
  color: #24292e;
}

.next-step-card p {
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
