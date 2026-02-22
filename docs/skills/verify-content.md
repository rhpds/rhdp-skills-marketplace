---
layout: default
title: /showroom:verify-content
---

# /showroom:verify-content

<div class="skill-badge" style="background: linear-gradient(135deg, #28a745 0%, #1e7e34 100%);">✓ Content Quality Validation</div>

Validate Showroom workshop or demo content for quality and Red Hat standards compliance.

---

## 📋 What You'll Need Before Starting

<div class="workflow-diagram">
  <a href="workflow.svg" target="_blank">
    <img src="workflow.svg" alt="verify-content workflow diagram" style="max-width: 100%; height: auto; border-radius: 8px; border: 1px solid #e1e4e8;" />
  </a>
  <p style="text-align: center; color: #586069; font-size: 0.875rem; margin-top: 0.5rem;">Click to view full workflow diagram</p>
</div>

### Prerequisites

<div class="prereq-grid">
  <div class="prereq-item">
    <div class="prereq-icon">📁</div>
    <h4>Workshop Content Ready</h4>
    <pre><code># Your Showroom repository with:
content/modules/ROOT/pages/*.adoc</code></pre>
  </div>

  <div class="prereq-item">
    <div class="prereq-icon">✓</div>
    <h4>Content Complete</h4>
    <ul>
      <li>All module/section files created</li>
      <li>Navigation structure in place</li>
      <li>Images and diagrams included</li>
      <li>Code examples added</li>
    </ul>
  </div>

  <div class="prereq-item">
    <div class="prereq-icon">💾</div>
    <h4>Files Saved</h4>
    <ul>
      <li>Current directory in Showroom repo</li>
      <li>All AsciiDoc files saved</li>
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
      <p>Open your workshop repository directory</p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">2</div>
    <div class="quick-step-content">
      <h4>Run Verification</h4>
      <p><code>/showroom:verify-content</code></p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">3</div>
    <div class="quick-step-content">
      <h4>Review Results</h4>
      <p>Check validation report for issues</p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">4</div>
    <div class="quick-step-content">
      <h4>Fix Issues</h4>
      <p>Address errors and warnings</p>
    </div>
  </div>
</div>

---

## ✓ What It Checks

<div class="checks-grid">
  <div class="check-category">
    <div class="check-header">
      <span class="check-icon">📝</span>
      <h3>Content Quality</h3>
    </div>
    <ul>
      <li><strong>Structure:</strong> Proper AsciiDoc formatting</li>
      <li><strong>Navigation:</strong> Links and cross-references work</li>
      <li><strong>Code blocks:</strong> Syntax highlighting and formatting</li>
      <li><strong>Images:</strong> Proper paths and alt text</li>
    </ul>
  </div>

  <div class="check-category">
    <div class="check-header">
      <span class="check-icon">🎨</span>
      <h3>Red Hat Standards</h3>
    </div>
    <ul>
      <li><strong>Terminology:</strong> Correct product names</li>
      <li><strong>Voice:</strong> Active, clear, direct language</li>
      <li><strong>Style:</strong> Consistent formatting</li>
      <li><strong>Branding:</strong> Red Hat guidelines compliance</li>
    </ul>
  </div>

  <div class="check-category">
    <div class="check-header">
      <span class="check-icon">⚙️</span>
      <h3>Technical Accuracy</h3>
    </div>
    <ul>
      <li><strong>Commands:</strong> Valid syntax</li>
      <li><strong>Examples:</strong> Working code snippets</li>
      <li><strong>Versions:</strong> Current product versions</li>
      <li><strong>URLs:</strong> Valid links to documentation</li>
    </ul>
  </div>

  <div class="check-category">
    <div class="check-header">
      <span class="check-icon">🖥️</span>
      <h3>Scaffold Files</h3>
    </div>
    <ul>
      <li><strong>default-site.yml:</strong> Title not stale, start_page, ui-bundle URL, supplemental_files path, runtime.fetch</li>
      <li><strong>site.yml mismatch:</strong> Warning if repo has site.yml but no default-site.yml (rename to default-site.yml)</li>
      <li><strong>ui-config.yml:</strong> type: showroom, view_switcher enabled, tabs configured, persist_url_state</li>
      <li><strong>content/antora.yml:</strong> title not stale, name: modules, start_page, nav, lab_name attribute</li>
      <li><strong>content/lib/:</strong> All 4 JS extension files present</li>
      <li><strong>supplemental-ui/:</strong> All 4 UI asset files present</li>
    </ul>
  </div>
</div>

---

## 🔄 Common Workflow

<div class="workflow-steps">
  <div class="workflow-step">
    <div class="workflow-icon">1️⃣</div>
    <div class="workflow-content">
      <h4>Step 1: Invoke Skill</h4>
      <pre><code>/showroom:verify-content</code></pre>
      <p>Prompts load directly from <code>showroom/prompts/</code> in the marketplace plugin. No content-type detection needed — the skill knows the context from the prompt files.</p>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">1.5️⃣</div>
    <div class="workflow-content">
      <h4>Step 1.5: Scaffold file check</h4>
      <p>Silently checks all scaffold files and surfaces issues grouped by severity:</p>
      <ul style="margin: 0.5rem 0 0 0; padding-left: 1.25rem;">
        <li><strong>Critical:</strong> Missing required files (default-site.yml, ui-config.yml, antora.yml)</li>
        <li><strong>High:</strong> Stale/template titles in default-site.yml, ui-config.yml, antora.yml; site.yml naming mismatch; missing view_switcher or tabs</li>
        <li><strong>High:</strong> Wrong paths (supplemental_files), missing content/lib/ JS files</li>
      </ul>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">2️⃣</div>
    <div class="workflow-content">
      <h4>Steps 2–4: Checklist verification (5 passes)</h4>
      <p>Each pass produces a complete PASS/FAIL/N/A table before the next starts — nothing is silently skipped:</p>
      <ul style="margin: 0.5rem 0 0 0; padding-left: 1.25rem;">
        <li><strong>Pass B:</strong> Structure (index, modules, nav, conclusion, exercises, verify sections)</li>
        <li><strong>Pass C:</strong> AsciiDoc formatting (images, links, code blocks, lists, headings)</li>
        <li><strong>Pass D:</strong> Red Hat style (product names, prohibited terms, numerals, Oxford comma)</li>
        <li><strong>Pass E:</strong> Technical accuracy (commands, variables, hardcoded values, heading hierarchy)</li>
        <li><strong>Pass F:</strong> Demo-specific (Know/Show, presenter notes — skipped for workshops)</li>
      </ul>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">3️⃣</div>
    <div class="workflow-content">
      <h4>Step 3: Fix Issues</h4>
      <p>Review each issue and update content:</p>
      <ul style="margin: 0.5rem 0 0 0; padding-left: 1.25rem;">
        <li>Fix AsciiDoc formatting errors</li>
        <li>Update product terminology</li>
        <li>Correct code examples</li>
        <li>Add missing alt text</li>
        <li>Add <code>view_switcher</code> to <code>ui-config.yml</code> if warned</li>
      </ul>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">4️⃣</div>
    <div class="workflow-content">
      <h4>Step 4: Re-verify</h4>
      <pre><code>/showroom:verify-content
→ Confirm all issues resolved</code></pre>
    </div>
  </div>
</div>

---

## 📊 Example Validation Report

<div class="report-box">
  <h3>Sample Verification Output</h3>
  <div class="report-items">
    <div class="report-item success">
      <span class="report-icon">✅</span>
      <div class="report-content">
        <strong>Structure:</strong> All modules follow Know/Do/Check pattern
      </div>
    </div>

    <div class="report-item success">
      <span class="report-icon">✅</span>
      <div class="report-content">
        <strong>Navigation:</strong> All links valid
      </div>
    </div>

    <div class="report-item warning">
      <span class="report-icon">⚠️</span>
      <div class="report-content">
        <strong>Terminology:</strong> Found "Openshift" (should be "OpenShift")
      </div>
    </div>

    <div class="report-item warning">
      <span class="report-icon">⚠️</span>
      <div class="report-content">
        <strong>Code blocks:</strong> Missing language identifier in module-02.adoc
      </div>
    </div>

    <div class="report-item error">
      <span class="report-icon">❌</span>
      <div class="report-content">
        <strong>Images:</strong> Missing alt text for diagram.png
      </div>
    </div>
  </div>
</div>

---

## 💡 Tips & Best Practices

<div class="tips-grid">
  <div class="tip-card">
    <h4>🔍 Before Pull Requests</h4>
    <p>Run verification before creating PRs</p>
  </div>
  <div class="tip-card">
    <h4>📝 Incremental Fixes</h4>
    <p>Fix issues one at a time, don't batch</p>
  </div>
  <div class="tip-card">
    <h4>📚 Learning Tool</h4>
    <p>Use verification to learn standards</p>
  </div>
  <div class="tip-card">
    <h4>🏷️ Product Names</h4>
    <p>Check capitalization carefully</p>
  </div>
  <div class="tip-card">
    <h4>⚙️ Test Code</h4>
    <p>Verify all examples actually work</p>
  </div>
  <div class="tip-card">
    <h4>📊 Priority Order</h4>
    <p>Fix ❌ first, then ⚠️, then ℹ️</p>
  </div>
</div>

---

## 🆘 Troubleshooting

<details>
<summary><strong>Skill not found?</strong></summary>

<ul>
  <li>Restart Claude Code or VS Code</li>
  <li>Verify installation: <code>ls ~/.claude/skills/verify-content</code> (Claude Code) or <code>ls ~/.cursor/skills/showroom-verify-content</code> (Cursor)</li>
  <li>Check the <a href="../reference/troubleshooting.html">Troubleshooting Guide</a></li>
</ul>

</details>

<details>
<summary><strong>No issues found but content looks wrong?</strong></summary>

<ul>
  <li>Manual review is still important</li>
  <li>Skill checks common issues, not everything</li>
  <li>Have a colleague review</li>
  <li>Test the workshop end-to-end</li>
</ul>

</details>

<details>
<summary><strong>Too many errors?</strong></summary>

<div class="priority-box">
  <h4>Prioritize Your Fixes:</h4>
  <ol>
    <li><strong>❌ Critical issues</strong> - Must fix (broken links, missing files)</li>
    <li><strong>⚠️ Warnings</strong> - Should fix (terminology, formatting)</li>
    <li><strong>ℹ️ Style suggestions</strong> - Optional improvements</li>
  </ol>
  <p style="margin-top: 1rem; margin-bottom: 0;">Start with critical issues and work your way down.</p>
</div>

</details>

---

## 🔗 Related Skills

<div class="related-skills">
  <a href="create-lab.html" class="related-skill-card">
    <div class="related-skill-icon">📝</div>
    <div class="related-skill-content">
      <h4>/showroom:create-lab</h4>
      <p>Generate workshop content</p>
    </div>
  </a>

  <a href="create-demo.html" class="related-skill-card">
    <div class="related-skill-icon">🎭</div>
    <div class="related-skill-content">
      <h4>/showroom:create-demo</h4>
      <p>Generate demo content</p>
    </div>
  </a>

  <a href="blog-generate.html" class="related-skill-card">
    <div class="related-skill-icon">📰</div>
    <div class="related-skill-content">
      <h4>/showroom:blog-generate</h4>
      <p>Convert to blog format</p>
    </div>
  </a>
</div>

---

<div class="navigation-footer">
  <a href="index.html" class="nav-button">← Back to Skills</a>
  <a href="blog-generate.html" class="nav-button">Next: /showroom:blog-generate →</a>
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

.prereq-item ul {
  margin: 0.5rem 0 0 0;
  padding-left: 1.25rem;
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
  background: linear-gradient(135deg, #28a745 0%, #1e7e34 100%);
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

.checks-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.check-category {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 12px;
  padding: 1.5rem;
}

.check-header {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-bottom: 1rem;
  padding-bottom: 1rem;
  border-bottom: 1px solid #e1e4e8;
}

.check-icon {
  font-size: 2rem;
}

.check-category h3 {
  margin: 0;
  color: #24292e;
}

.check-category ul {
  margin: 0;
  padding-left: 0;
  list-style: none;
}

.check-category li {
  padding: 0.5rem 0;
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

.priority-box ol {
  margin: 0.5rem 0;
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
