---
layout: default
title: /showroom:create-demo
---

# /showroom:create-demo

<div class="skill-badge">🎭 Demo Content Creation</div>

Create presenter-led demo content where YOU present and customers watch.

---

## 🤔 Is This The Right Skill?

<div class="decision-grid">
  <div class="decision-card use-this">
    <h3>✅ Use /showroom:create-demo if:</h3>
    <ul>
      <li><strong>YOU present</strong> while customers watch (like presenting PowerPoint)</li>
      <li>You want <strong>Know → Show</strong> structure (explain, then demonstrate)</li>
      <li>One presenter showing features</li>
    </ul>
  </div>

  <div class="decision-card use-other">
    <h3>❌ Use /showroom:create-lab instead if:</h3>
    <ul>
      <li>Customers <strong>DO hands-on activities</strong> (click buttons, run commands)</li>
      <li>Multiple participants following step-by-step instructions</li>
    </ul>
  </div>
</div>

<div class="tip-box">
💡 <strong>Not sure?</strong> Demos are presentational (you drive). Labs are interactive (customers drive).
</div>

---

## 📋 What You'll Need Before Starting

<div class="workflow-diagram">
  <a href="create-demo-workflow.svg" target="_blank">
    <img src="create-demo-workflow.svg" alt="create-demo workflow diagram" style="max-width: 100%; height: auto; border-radius: 8px; border: 1px solid #e1e4e8;" />
  </a>
  <p style="text-align: center; color: #586069; font-size: 0.875rem; margin-top: 0.5rem;">Click to view full workflow diagram</p>
</div>

### Required Inputs

<div class="inputs-grid">
  <div class="input-card">
    <div class="input-icon">🎯</div>
    <h4>Demo Topic</h4>
    <p>Example: "OpenShift AI capabilities"</p>
  </div>
  <div class="input-card">
    <div class="input-icon">⭐</div>
    <h4>Key Features</h4>
    <p>Features to highlight</p>
  </div>
  <div class="input-card">
    <div class="input-icon">📊</div>
    <h4>Number of Sections</h4>
    <p>Typically 3-4 segments</p>
  </div>
  <div class="input-card">
    <div class="input-icon">👥</div>
    <h4>Target Audience</h4>
    <p>Technical, business, or executive</p>
  </div>
</div>

### What The AI Will Create

<div class="outputs-box">
  <h4>Generated Files:</h4>
  <ul>
    <li>✓ Navigation page (index.adoc)</li>
    <li>✓ Section files (one per demo segment)</li>
    <li>✓ Know/Show structure for each section</li>
    <li>✓ Presenter notes and customer-facing content</li>
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
      <p>Type <code>/showroom:create-demo</code> in the chat</p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">3</div>
    <div class="quick-step-content">
      <h4>Answer Questions</h4>
      <p>Provide demo title, description, technologies, sections, and audience level</p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">4</div>
    <div class="quick-step-content">
      <h4>Review & Customize</h4>
      <p>Add screenshots and customize content</p>
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
│   ├── section-01.adoc         # First section
│   ├── section-02.adoc         # Second section
│   └── section-03.adoc         # Third section
└── partials/
    └── _attributes.adoc        # Demo metadata</code></pre>
</div>

---

## 🔄 Common Workflow

<div class="workflow-steps">
  <div class="workflow-step">
    <div class="workflow-icon">1️⃣</div>
    <div class="workflow-content">
      <h4>Step 1: Invoke Skill</h4>
      <pre><code>/showroom:create-demo
→ Skill loads prompts from showroom/prompts/</code></pre>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">2️⃣</div>
    <div class="workflow-content">
      <h4>Step 2: Demo Details</h4>
      <p>Answer prompts for demo title, abstract, technologies, audience level, and number of sections.</p>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">2.5️⃣</div>
    <div class="workflow-content">
      <h4>Step 2.5: Provide Showroom Repository Path</h4>
      <p>Skill asks: <em>"What is the path to your RHDP-provided cloned Showroom repository?"</em></p>
      <p>This is the repo RHDP already provisioned for you — not where to create files, but the existing repo to write into.</p>
      <pre><code>Example: ~/work/showroom-content/your-demo-showroom</code></pre>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">3️⃣</div>
    <div class="workflow-content">
      <h4>Step 3.1: Showroom Scaffold (site.yml + ui-config.yml)</h4>
      <p>Skill configures the two key infrastructure files in your Showroom repo (cloned from showroom_template_nookbag):</p>
      <pre><code>site.yml              # Antora playbook — fix title, ui-bundle theme
ui-config.yml          # Split view + tabs (view_switcher.enabled: true)</code></pre>
      <p>Skill also asks: <em>"Will this demo embed an OCP console or terminal tab?"</em> — configures console embedding if yes.</p>
      <div class="info-box" style="margin-top: 1rem;">
        ℹ️ <strong>Showroom 1.5.3+ required</strong> for split-view and OCP console embedding. Clone from <code>showroom_template_nookbag</code> as your starting template.
      </div>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">4️⃣</div>
    <div class="workflow-content">
      <h4>Step 4-5: Generate Section Content</h4>
      <p>Skill generates <code>index.adoc</code> and one file per demo section using Know/Show structure. UserInfo attributes are written once in <code>_attributes.adoc</code> (no duplicate entries).</p>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">5️⃣</div>
    <div class="workflow-content">
      <h4>Verify Content</h4>
      <pre><code>/showroom:verify-content
→ Check quality and standards
→ Checks ui-config.yml for console and view_switcher</code></pre>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">6️⃣</div>
    <div class="workflow-content">
      <h4>Generate Blog Post (Optional)</h4>
      <pre><code>/showroom:blog-generate
→ Transform to blog format</code></pre>
    </div>
  </div>
</div>

---

## 📝 Section Structure Pattern

<div class="pattern-box">
  <h3>Know → Show</h3>
  <p>Each section follows this proven demonstration pattern:</p>

  <div class="pattern-sections">
    <div class="pattern-section">
      <div class="pattern-header">
        <span class="pattern-icon">📖</span>
        <h4>Know Section</h4>
      </div>
      <ul>
        <li>Explains what you'll demonstrate</li>
        <li>Provides context and business value</li>
        <li>Sets up the "why"</li>
      </ul>
    </div>

    <div class="pattern-section">
      <div class="pattern-header">
        <span class="pattern-icon">👁️</span>
        <h4>Show Section</h4>
      </div>
      <ul>
        <li>Step-by-step demo script</li>
        <li>What to click/type/show</li>
        <li>Expected results and talking points</li>
        <li>Screenshots with annotations</li>
      </ul>
    </div>
  </div>
</div>

---

## 💡 Tips & Best Practices

<div class="tips-grid">
  <div class="tip-card">
    <h4>📊 Section Count</h4>
    <p>Start with 3-4 sections for new demos</p>
  </div>
  <div class="tip-card">
    <h4>⏱️ Timing</h4>
    <p>Each section should take 5-10 minutes</p>
  </div>
  <div class="tip-card">
    <h4>🎯 Focus</h4>
    <p>Keep Show sections focused on one main feature</p>
  </div>
  <div class="tip-card">
    <h4>📝 Presenter Notes</h4>
    <p>Include timing and transition notes</p>
  </div>
  <div class="tip-card">
    <h4>📸 Screenshots</h4>
    <p>Use screenshots to guide the flow</p>
  </div>
  <div class="tip-card">
    <h4>🎭 Practice</h4>
    <p>Run through demo before presenting</p>
  </div>
</div>

---

## 🆘 Troubleshooting

<details>
<summary><strong>Skill not found?</strong></summary>

<ul>
  <li>Restart Claude Code or VS Code</li>
  <li>Verify installation: <code>ls ~/.claude/skills/create-demo</code> (Claude Code) or <code>ls ~/.cursor/skills/showroom-create-demo</code> (Cursor)</li>
  <li>Check the <a href="../reference/troubleshooting.html">Troubleshooting Guide</a></li>
</ul>

</details>

<details>
<summary><strong>Generated content looks wrong?</strong></summary>

<ul>
  <li>Check your demo template is up to date</li>
  <li>Verify you're in the correct directory</li>
  <li>Run <code>/showroom:verify-content</code> to check standards compliance</li>
</ul>

</details>

<details>
<summary><strong>Demo vs Lab confusion?</strong></summary>

<div class="priority-box">
  <h4>Quick Decision Guide:</h4>
  <ul>
    <li><strong>Use /showroom:create-demo</strong> for presenter-led content (Know/Show)</li>
    <li><strong>Use /showroom:create-lab</strong> for hands-on workshops (Know/Do/Check)</li>
  </ul>
  <p style="margin-top: 1rem; margin-bottom: 0;">Think: "Am I showing, or are they doing?"</p>
</div>

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

  <a href="create-lab.html" class="related-skill-card">
    <div class="related-skill-icon">📝</div>
    <div class="related-skill-content">
      <h4>/showroom:create-lab</h4>
      <p>Create hands-on workshops instead</p>
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
  background: linear-gradient(135deg, #8B5CF6 0%, #7C3AED 100%);
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
  background: linear-gradient(135deg, #8B5CF6 0%, #7C3AED 100%);
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
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
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

.priority-box ul {
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
  border-color: #8B5CF6;
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
  border-color: #8B5CF6;
  color: #8B5CF6;
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
  color: #8B5CF6;
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
