---
layout: default
title: /showroom:blog-generate
---

# /showroom:blog-generate

<div class="skill-badge">📰 Blog Post Generation</div>

Transform Red Hat Showroom workshop content into Red Hat Developer blog post format.

---

## 📋 What You'll Need Before Starting

<div class="workflow-diagram">
  <a href="workflow.svg" target="_blank">
    <img src="workflow.svg" alt="blog-generate workflow diagram" style="max-width: 100%; height: auto; border-radius: 8px; border: 1px solid #e1e4e8;" />
  </a>
  <p style="text-align: center; color: #586069; font-size: 0.875rem; margin-top: 0.5rem;">Click to view full workflow diagram</p>
</div>

### Prerequisites

<div class="prereq-grid">
  <div class="prereq-item">
    <div class="prereq-icon">✓</div>
    <h4>Complete Workshop Content</h4>
    <pre><code># Your Showroom repository with finished workshop:
content/modules/ROOT/pages/
├── index.adoc
├── module-01.adoc
├── module-02.adoc
└── module-03.adoc</code></pre>
  </div>

  <div class="prereq-item">
    <div class="prereq-icon">🔍</div>
    <h4>Verified Content Quality</h4>
    <ul>
      <li>Run <code>/showroom:verify-content</code> first</li>
      <li>All modules complete</li>
      <li>Standards compliance checked</li>
    </ul>
  </div>

  <div class="prereq-item">
    <div class="prereq-icon">📝</div>
    <h4>Blog Metadata Ready</h4>
    <ul>
      <li>Target publication date</li>
      <li>Blog categories/tags</li>
      <li>Author bio</li>
      <li>Featured image (optional)</li>
    </ul>
  </div>
</div>

### What You'll Need

<div class="inputs-grid">
  <div class="input-card">
    <div class="input-icon">📚</div>
    <h4>Completed Workshop</h4>
    <p>Finished and verified content</p>
  </div>
  <div class="input-card">
    <div class="input-icon">🎯</div>
    <h4>Blog Title</h4>
    <p>May differ from workshop title</p>
  </div>
  <div class="input-card">
    <div class="input-icon">👥</div>
    <h4>Target Audience</h4>
    <p>For blog readers</p>
  </div>
  <div class="input-card">
    <div class="input-icon">📣</div>
    <h4>Call-to-Action</h4>
    <p>Try the workshop, sign up, etc.</p>
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
      <h4>Run Generation</h4>
      <p><code>/showroom:blog-generate</code></p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">3</div>
    <div class="quick-step-content">
      <h4>Answer Questions</h4>
      <p>Provide blog-specific metadata</p>
    </div>
  </div>

  <div class="quick-step">
    <div class="quick-step-number">4</div>
    <div class="quick-step-content">
      <h4>Review & Submit</h4>
      <p>Edit blog and submit to Red Hat Developer</p>
    </div>
  </div>
</div>

---

## 📁 What It Creates

<div class="file-structure">
  <h4>Generated Directory Structure:</h4>
  <pre><code>blog/
├── blog-post.md              # Blog post in Markdown
├── assets/
│   └── featured-image.png    # Hero image for post
└── metadata.yml              # Publication metadata</code></pre>
</div>

---

## 🔄 Common Workflow

<div class="workflow-steps">
  <div class="workflow-step">
    <div class="workflow-icon">1️⃣</div>
    <div class="workflow-content">
      <h4>Create and Verify Workshop</h4>
      <pre><code>/showroom:create-lab
→ Generate workshop content

/showroom:verify-content
→ Ensure quality</code></pre>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">2️⃣</div>
    <div class="workflow-content">
      <h4>Generate Blog Post</h4>
      <pre><code>/showroom:blog-generate
→ Transform to blog format
→ Add narrative flow
→ Include call-to-action</code></pre>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">3️⃣</div>
    <div class="workflow-content">
      <h4>Review and Edit</h4>
      <p>Polish the content for blog readers:</p>
      <ul style="margin: 0.5rem 0 0 0; padding-left: 1.25rem;">
        <li>Read for blog audience (less technical)</li>
        <li>Add personal insights or experiences</li>
        <li>Include links to workshop and resources</li>
        <li>Add screenshots or diagrams</li>
      </ul>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">4️⃣</div>
    <div class="workflow-content">
      <h4>Submit for Publication</h4>
      <ul style="margin: 0; padding-left: 1.25rem;">
        <li>Follow Red Hat Developer blog submission process</li>
        <li>Include metadata.yml</li>
        <li>Provide featured image</li>
        <li>Coordinate publication date</li>
      </ul>
    </div>
  </div>
</div>

---

## 📊 Blog vs Workshop Differences

<div class="comparison-box">
  <h3>Key Transformations</h3>
  <div class="comparison-grid">
    <div class="comparison-item">
      <div class="comparison-header workshop">Workshop</div>
      <ul>
        <li>Step-by-step instructions</li>
        <li>Technical commands</li>
        <li>Know/Do/Check structure</li>
        <li>Complete procedures</li>
        <li>For hands-on learning</li>
      </ul>
    </div>
    <div class="comparison-arrow">→</div>
    <div class="comparison-item">
      <div class="comparison-header blog">Blog Post</div>
      <ul>
        <li>Narrative explanation</li>
        <li>Conceptual overview</li>
        <li>Story-driven flow</li>
        <li>Highlights and insights</li>
        <li>For reading and inspiration</li>
      </ul>
    </div>
  </div>
</div>

---

## 💡 Tips & Best Practices

<div class="tips-grid">
  <div class="tip-card">
    <h4>📖 Overview Style</h4>
    <p>Blog posts are overview, not full tutorial</p>
  </div>
  <div class="tip-card">
    <h4>🎯 Focus on Why</h4>
    <p>Emphasize what you learned</p>
  </div>
  <div class="tip-card">
    <h4>🔗 Link to Workshop</h4>
    <p>Include link to full workshop for details</p>
  </div>
  <div class="tip-card">
    <h4>✍️ Personal Touch</h4>
    <p>Add your perspective and insights</p>
  </div>
  <div class="tip-card">
    <h4>📏 Word Count</h4>
    <p>Aim for 800-1200 words</p>
  </div>
  <div class="tip-card">
    <h4>💬 Conversational Tone</h4>
    <p>Use friendly, accessible language</p>
  </div>
  <div class="tip-card">
    <h4>📣 Clear CTA</h4>
    <p>Add a strong call-to-action at the end</p>
  </div>
  <div class="tip-card">
    <h4>🖼️ Visual Appeal</h4>
    <p>Include diagrams and screenshots</p>
  </div>
</div>

---

## 🆘 Troubleshooting

<details>
<summary><strong>Skill not found?</strong></summary>

<ul>
  <li>Restart Claude Code or VS Code</li>
  <li>Verify installation: <code>ls ~/.claude/skills/blog-generate</code> (Claude Code) or <code>ls ~/.cursor/skills/showroom-blog-generate</code> (Cursor)</li>
  <li>Check the <a href="../reference/troubleshooting.html">Troubleshooting Guide</a></li>
</ul>

</details>

<details>
<summary><strong>Generated blog is too technical?</strong></summary>

<div class="priority-box">
  <h4>Make It More Accessible:</h4>
  <ul>
    <li>Edit to focus on concepts over commands</li>
    <li>Add more narrative and context</li>
    <li>Simplify technical jargon</li>
    <li>Use analogies and examples</li>
    <li>Explain the "why" before the "how"</li>
  </ul>
</div>

</details>

<details>
<summary><strong>Blog doesn't flow well?</strong></summary>

<ul>
  <li>Restructure sections for storytelling</li>
  <li>Add transitions between sections</li>
  <li>Focus on reader journey, not lab steps</li>
  <li>Start with a compelling hook</li>
  <li>End with clear next steps</li>
</ul>

</details>

---

## 📚 Red Hat Developer Blog Resources

<div class="resources-box">
  <h4>Helpful Links:</h4>
  <ul>
    <li><a href="https://developers.redhat.com/blog" target="_blank">Red Hat Developer Blog</a></li>
    <li><a href="https://developers.redhat.com/blog/write-for-us" target="_blank">Blog Submission Guidelines</a></li>
    <li>Contact: <a href="mailto:developer-content@redhat.com">developer-content@redhat.com</a></li>
  </ul>
</div>

---

## 🔗 Related Skills

<div class="related-skills">
  <a href="create-lab.html" class="related-skill-card">
    <div class="related-skill-icon">📝</div>
    <div class="related-skill-content">
      <h4>/showroom:create-lab</h4>
      <p>Create workshop first</p>
    </div>
  </a>

  <a href="verify-content.html" class="related-skill-card">
    <div class="related-skill-icon">✓</div>
    <div class="related-skill-content">
      <h4>/showroom:verify-content</h4>
      <p>Verify before generating blog</p>
    </div>
  </a>

  <a href="create-demo.html" class="related-skill-card">
    <div class="related-skill-icon">🎭</div>
    <div class="related-skill-content">
      <h4>/showroom:create-demo</h4>
      <p>Can also be transformed to blog</p>
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
  background: linear-gradient(135deg, #F59E0B 0%, #D97706 100%);
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
  background: linear-gradient(135deg, #F59E0B 0%, #D97706 100%);
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

.comparison-box {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 12px;
  padding: 2rem;
  margin: 2rem 0;
}

.comparison-box h3 {
  margin-top: 0;
  margin-bottom: 1.5rem;
  color: #24292e;
  text-align: center;
}

.comparison-grid {
  display: grid;
  grid-template-columns: 1fr auto 1fr;
  gap: 1.5rem;
  align-items: center;
}

.comparison-item {
  background: white;
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
}

.comparison-header {
  font-weight: 600;
  padding: 0.5rem 1rem;
  border-radius: 6px;
  margin-bottom: 1rem;
  text-align: center;
}

.comparison-header.workshop {
  background: #e7f3ff;
  color: #0969da;
}

.comparison-header.blog {
  background: #fff3cd;
  color: #856404;
}

.comparison-arrow {
  font-size: 2rem;
  color: #586069;
}

.comparison-item ul {
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

.resources-box {
  background: #e7f3ff;
  border-left: 4px solid #0969da;
  padding: 1.5rem;
  border-radius: 4px;
  margin: 1rem 0;
}

.resources-box h4 {
  margin-top: 0;
  color: #0969da;
}

.resources-box ul {
  margin-bottom: 0;
}

.resources-box a {
  color: #0969da;
  text-decoration: none;
}

.resources-box a:hover {
  text-decoration: underline;
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
  border-color: #F59E0B;
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
  border-color: #F59E0B;
  color: #F59E0B;
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
  color: #F59E0B;
}

details[open] {
  padding-bottom: 1rem;
}

details[open] summary {
  margin-bottom: 1rem;
  padding-bottom: 0.5rem;
  border-bottom: 1px solid #e1e4e8;
}

@media (max-width: 768px) {
  .comparison-grid {
    grid-template-columns: 1fr;
  }

  .comparison-arrow {
    display: none;
  }
}
</style>
