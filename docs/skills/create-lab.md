---
layout: default
title: /showroom:create-lab
---

# /showroom:create-lab

<div class="skill-badge">📝 Workshop Lab Creation</div>

Create hands-on workshop content where customers follow along step-by-step.

---

## 🤔 Is This The Right Skill?

<div class="decision-grid">
  <div class="decision-card use-this">
    <h3>✅ Use /showroom:create-lab if:</h3>
    <ul>
      <li>Customers will <strong>DO things hands-on</strong> (click buttons, run commands)</li>
      <li>You want <strong>Know → Do → Check</strong> structure (teach, practice, verify)</li>
      <li>Multiple participants learning together</li>
    </ul>
  </div>

  <div class="decision-card use-other">
    <h3>❌ Use /showroom:create-demo instead if:</h3>
    <ul>
      <li><strong>YOU present</strong> and customers watch (like a PowerPoint)</li>
      <li>One-directional presentation</li>
    </ul>
  </div>
</div>

<div class="tip-box">
💡 <strong>Not sure?</strong> Labs are more interactive. Demos are more presentational.
</div>

---

## 📋 What You'll Need Before Starting

<div class="workflow-diagram">
  <a href="workflow.svg" target="_blank">
    <img src="workflow.svg" alt="create-lab workflow diagram" style="max-width: 100%; height: auto; border-radius: 8px; border: 1px solid #e1e4e8;" />
  </a>
  <p style="text-align: center; color: #586069; font-size: 0.875rem; margin-top: 0.5rem;">Click to view full workflow diagram</p>
</div>

### Required Inputs

<div class="inputs-grid">
  <div class="input-card">
    <div class="input-icon">📚</div>
    <h4>Workshop Topic</h4>
    <p>Example: "Getting started with OpenShift Pipelines"</p>
  </div>
  <div class="input-card">
    <div class="input-icon">🎯</div>
    <h4>Learning Goals</h4>
    <p>What should customers learn?</p>
  </div>
  <div class="input-card">
    <div class="input-icon">📊</div>
    <h4>Number of Sections</h4>
    <p>Typically 3-5 modules</p>
  </div>
  <div class="input-card">
    <div class="input-icon">📖</div>
    <h4>Reference Materials</h4>
    <p>Product docs, screenshots, etc.</p>
  </div>
</div>

### What The AI Will Create

<div class="outputs-box">
  <h4>Generated Files:</h4>
  <ul>
    <li>✓ Navigation page (index.adoc)</li>
    <li>✓ Module files (one per section)</li>
    <li>✓ Know/Do/Check structure for each module</li>
    <li>✓ Placeholder images and examples</li>
  </ul>
</div>

<div class="info-box">
ℹ️ <strong>You DON'T need:</strong> Git knowledge, coding experience, or AsciiDoc expertise. The AI handles all technical aspects.
</div>

---

## 🚀 Quick Start

<div class="quick-start-steps">
  <div class="quick-step">
    <div class="quick-step-number">1</div>
    <div class="quick-step-content">
      <h4>Open Your IDE</h4>
      <p>Launch Claude Code (or VS Code with Claude extension)</p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">2</div>
    <div class="quick-step-content">
      <h4>Invoke Skill</h4>
      <p>Type <code>/showroom:create-lab</code> in the chat</p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">3</div>
    <div class="quick-step-content">
      <h4>Answer Questions</h4>
      <p>Provide workshop title, abstract, technologies, modules, and objectives</p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">4</div>
    <div class="quick-step-content">
      <h4>Review & Customize</h4>
      <p>Review generated content and edit as needed</p>
    </div>
  </div>
</div>

---

## 📁 What It Creates

<div class="file-structure">
  <h4>Generated Directory Structure:</h4>
  <pre><code>content/modules/ROOT/
├── pages/
│   ├── index.adoc              # Navigation home
│   ├── module-01.adoc          # First module
│   ├── module-02.adoc          # Second module
│   └── module-03.adoc          # Third module
└── partials/
    └── _attributes.adoc        # Workshop metadata</code></pre>
</div>

---

## 🔄 Common Workflow

<div class="workflow-steps">
  <div class="workflow-step">
    <div class="workflow-icon">1️⃣</div>
    <div class="workflow-content">
      <h4>Create Module Structure</h4>
      <pre><code>/showroom:create-lab
→ Enter workshop details
→ Skill generates module files</code></pre>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">2️⃣</div>
    <div class="workflow-content">
      <h4>Verify Content</h4>
      <pre><code>/showroom:verify-content
→ Check quality and standards</code></pre>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">3️⃣</div>
    <div class="workflow-content">
      <h4>Generate Blog Post (Optional)</h4>
      <pre><code>/showroom:blog-generate
→ Transform to blog format</code></pre>
    </div>
  </div>
</div>

---

## 📝 Module Structure Pattern

<div class="pattern-box">
  <h3>Know → Do → Check</h3>
  <p>Each module follows this proven learning pattern:</p>

  <div class="pattern-sections">
    <div class="pattern-section">
      <div class="pattern-header">
        <span class="pattern-icon">📖</span>
        <h4>Know Section</h4>
      </div>
      <ul>
        <li>Explains the concept</li>
        <li>Provides context and background</li>
      </ul>
    </div>

    <div class="pattern-section">
      <div class="pattern-header">
        <span class="pattern-icon">⚙️</span>
        <h4>Do Section</h4>
      </div>
      <ul>
        <li>Hands-on exercise</li>
        <li>Step-by-step instructions</li>
        <li>Code examples with syntax highlighting</li>
      </ul>
    </div>

    <div class="pattern-section">
      <div class="pattern-header">
        <span class="pattern-icon">✓</span>
        <h4>Check Section</h4>
      </div>
      <ul>
        <li>Verification steps</li>
        <li>Expected results</li>
        <li>Troubleshooting tips</li>
      </ul>
    </div>
  </div>
</div>

---

## 💡 Tips & Best Practices

<div class="tips-grid">
  <div class="tip-card">
    <h4>📊 Module Count</h4>
    <p>Start with 3-4 modules for new workshops</p>
  </div>
  <div class="tip-card">
    <h4>⏱️ Timing</h4>
    <p>Each module should take 10-15 minutes</p>
  </div>
  <div class="tip-card">
    <h4>🎯 Focus</h4>
    <p>Keep Do sections focused on one main task</p>
  </div>
  <div class="tip-card">
    <h4>📸 Screenshots</h4>
    <p>Use screenshots sparingly (AsciiDoc format)</p>
  </div>
</div>

---

## 🆘 Troubleshooting

<details>
<summary><strong>Skill not found?</strong></summary>

<ul>
  <li>Restart Claude Code or VS Code</li>
  <li>Verify installation: <code>ls ~/.claude/skills/create-lab</code> (Claude Code) or <code>ls ~/.cursor/skills/showroom-create-lab</code> (Cursor)</li>
  <li>Check the <a href="../reference/troubleshooting.html">Troubleshooting Guide</a></li>
</ul>

</details>

<details>
<summary><strong>Generated content looks wrong?</strong></summary>

<ul>
  <li>Check your workshop template is up to date</li>
  <li>Verify you're in the correct directory</li>
  <li>Run <code>/showroom:verify-content</code> to check standards compliance</li>
</ul>

</details>

---

## 🔗 Related Skills

<div class="related-skills">
  <a href="verify-content.html" class="related-skill-card">
    <div class="related-skill-icon">✓</div>
    <div class="related-skill-content">
      <h4>/showroom:verify-content</h4>
      <p>Validate generated content</p>
    </div>
  </a>

  <a href="create-demo.html" class="related-skill-card">
    <div class="related-skill-icon">🎭</div>
    <div class="related-skill-content">
      <h4>/showroom:create-demo</h4>
      <p>Create presenter-led demos instead</p>
    </div>
  </a>

  <a href="blog-generate.html" class="related-skill-card">
    <div class="related-skill-icon">📰</div>
    <div class="related-skill-content">
      <h4>/showroom:blog-generate</h4>
      <p>Convert to blog post format</p>
    </div>
  </a>
</div>

---

<div class="navigation-footer">
  <a href="index.html" class="nav-button">← Back to Skills</a>
  <a href="verify-content.html" class="nav-button">Next: /showroom:verify-content →</a>
</div>

<style>
.skill-badge {
  display: inline-block;
  background: linear-gradient(135deg, #EE0000 0%, #CC0000 100%);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  font-weight: 600;
  margin: 1rem 0;
}

.decision-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.decision-card {
  border-radius: 12px;
  padding: 1.5rem;
  border: 2px solid;
}

.decision-card h3 {
  margin-top: 0;
  margin-bottom: 1rem;
}

.use-this {
  background: #d4edda;
  border-color: #28a745;
}

.use-this h3 {
  color: #155724;
}

.use-other {
  background: #fff3cd;
  border-color: #ffc107;
}

.use-other h3 {
  color: #856404;
}

.tip-box {
  background: #e7f3ff;
  border-left: 4px solid #0969da;
  padding: 1rem;
  margin: 1rem 0;
  border-radius: 4px;
}

.workflow-diagram {
  margin: 2rem 0;
  text-align: center;
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

.outputs-box {
  background: #d4edda;
  border-left: 4px solid #28a745;
  padding: 1.5rem;
  border-radius: 4px;
  margin: 1rem 0;
}

.outputs-box h4 {
  margin-top: 0;
  color: #155724;
}

.outputs-box ul {
  margin-bottom: 0;
  color: #155724;
}

.info-box {
  background: #e7f3ff;
  border-left: 4px solid #0969da;
  padding: 1rem;
  margin: 1rem 0;
  border-radius: 4px;
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
  background: linear-gradient(135deg, #EE0000 0%, #CC0000 100%);
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

.pattern-box {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 12px;
  padding: 2rem;
  margin: 2rem 0;
}

.pattern-box h3 {
  margin-top: 0;
  color: #24292e;
  text-align: center;
}

.pattern-box > p {
  text-align: center;
  color: #586069;
  margin-bottom: 1.5rem;
}

.pattern-sections {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
}

.pattern-section {
  background: white;
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
}

.pattern-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 0.75rem;
}

.pattern-icon {
  font-size: 1.5rem;
}

.pattern-section h4 {
  margin: 0;
  color: #24292e;
}

.pattern-section ul {
  margin: 0;
  padding-left: 1.25rem;
  color: #586069;
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
  border-color: #EE0000;
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
