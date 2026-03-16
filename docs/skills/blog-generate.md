---
layout: default
title: /showroom:blog-generate
---

# /showroom:blog-generate

<div class="reference-badge">✍️ Blog Post Generation</div>

Transform Red Hat Showroom workshop content into Red Hat Developer blog post format.

---

## Prerequisites

<div class="category-grid">
<div class="category-card">
<span class="category-icon">✓</span>
<h3>Complete Workshop Content</h3>

```
# Your Showroom repository with finished workshop:
content/modules/ROOT/pages/
├── index.adoc
├── module-01.adoc
├── module-02.adoc
└── module-03.adoc
```

</div>
<div class="category-card">
<span class="category-icon">🔍</span>
<h3>Verified Content Quality</h3>
<ul>
<li>Run <code>/showroom:verify-content</code> first</li>
<li>All modules complete</li>
<li>Standards compliance checked</li>
</ul>
</div>
<div class="category-card">
<span class="category-icon">📝</span>
<h3>Blog Metadata Ready</h3>
<ul>
<li>Target publication date</li>
<li>Blog categories/tags</li>
<li>Author bio</li>
<li>Featured image (optional)</li>
</ul>
</div>
</div>

### What You'll Need

<div class="category-grid">
<div class="category-card">
<span class="category-icon">📚</span>
<h3>Completed Workshop</h3>
<p>Finished and verified content</p>
</div>
<div class="category-card">
<span class="category-icon">🎯</span>
<h3>Blog Title</h3>
<p>May differ from workshop title</p>
</div>
<div class="category-card">
<span class="category-icon">👥</span>
<h3>Target Audience</h3>
<p>For blog readers</p>
</div>
<div class="category-card">
<span class="category-icon">📣</span>
<h3>Call-to-Action</h3>
<p>Try the workshop, sign up, etc.</p>
</div>
</div>

---

## Quick Start

<ol class="steps">
<li><div class="step-content"><h4>Navigate to Repository</h4><p>Open your workshop repository directory</p></div></li>
<li><div class="step-content"><h4>Run Generation</h4><p><code>/showroom:blog-generate</code></p></div></li>
<li><div class="step-content"><h4>Answer Questions</h4><p>Provide blog-specific metadata</p></div></li>
<li><div class="step-content"><h4>Review &amp; Submit</h4><p>Edit blog and submit to Red Hat Developer</p></div></li>
</ol>

---

## What It Creates

```
blog/
├── blog-post.md              # Blog post in Markdown
├── assets/
│   └── featured-image.png    # Hero image for post
└── metadata.yml              # Publication metadata
```

---

## Common Workflow

<ol class="steps">
<li>
<div class="step-content">
<h4>Create and Verify Workshop</h4>

```
/showroom:create-lab
→ Generate workshop content

/showroom:verify-content
→ Ensure quality
```

</div>
</li>
<li>
<div class="step-content">
<h4>Generate Blog Post</h4>

```
/showroom:blog-generate
→ Transform to blog format
→ Add narrative flow
→ Include call-to-action
```

</div>
</li>
<li>
<div class="step-content">
<h4>Review and Edit</h4>
<p>Polish the content for blog readers:</p>
<ul>
<li>Read for blog audience (less technical)</li>
<li>Add personal insights or experiences</li>
<li>Include links to workshop and resources</li>
<li>Add screenshots or diagrams</li>
</ul>
</div>
</li>
<li>
<div class="step-content">
<h4>Submit for Publication</h4>
<ul>
<li>Follow Red Hat Developer blog submission process</li>
<li>Include metadata.yml</li>
<li>Provide featured image</li>
<li>Coordinate publication date</li>
</ul>
</div>
</li>
</ol>

---

## Blog vs Workshop Differences

<div class="vs-grid">
<div class="vs-card vs-card-skill">
<span class="vs-label">Workshop</span>
<h3>Hands-on Learning</h3>
<ul>
<li>Step-by-step instructions</li>
<li>Technical commands</li>
<li>Know/Do/Check structure</li>
<li>Complete procedures</li>
<li>For hands-on learning</li>
</ul>
</div>
<div class="vs-card vs-card-agent">
<span class="vs-label">Blog Post</span>
<h3>Reading and Inspiration</h3>
<ul>
<li>Narrative explanation</li>
<li>Conceptual overview</li>
<li>Story-driven flow</li>
<li>Highlights and insights</li>
<li>For reading and inspiration</li>
</ul>
</div>
</div>

---

## Tips &amp; Best Practices

<div class="category-grid">
<div class="category-card">
<span class="category-icon">📖</span>
<h3>Overview Style</h3>
<p>Blog posts are overview, not full tutorial</p>
</div>
<div class="category-card">
<span class="category-icon">🎯</span>
<h3>Focus on Why</h3>
<p>Emphasize what you learned</p>
</div>
<div class="category-card">
<span class="category-icon">🔗</span>
<h3>Link to Workshop</h3>
<p>Include link to full workshop for details</p>
</div>
<div class="category-card">
<span class="category-icon">✍️</span>
<h3>Personal Touch</h3>
<p>Add your perspective and insights</p>
</div>
<div class="category-card">
<span class="category-icon">📏</span>
<h3>Word Count</h3>
<p>Aim for 800–1200 words</p>
</div>
<div class="category-card">
<span class="category-icon">💬</span>
<h3>Conversational Tone</h3>
<p>Use friendly, accessible language</p>
</div>
<div class="category-card">
<span class="category-icon">📣</span>
<h3>Clear CTA</h3>
<p>Add a strong call-to-action at the end</p>
</div>
<div class="category-card">
<span class="category-icon">🖼️</span>
<h3>Visual Appeal</h3>
<p>Include diagrams and screenshots</p>
</div>
</div>

---

## Troubleshooting

<details>
<summary>Skill not found?</summary>

- Restart Claude Code or VS Code
- Verify installation: `ls ~/.claude/skills/blog-generate` (Claude Code) or `ls ~/.cursor/skills/showroom-blog-generate` (Cursor)
- Check the [Troubleshooting Guide](../reference/troubleshooting.html)

</details>

<details>
<summary>Generated blog is too technical?</summary>

<div class="callout callout-tip">
<span class="callout-icon">✅</span>
<div class="callout-body">
<strong>Make It More Accessible:</strong>
<ul>
<li>Edit to focus on concepts over commands</li>
<li>Add more narrative and context</li>
<li>Simplify technical jargon</li>
<li>Use analogies and examples</li>
<li>Explain the "why" before the "how"</li>
</ul>
</div>
</div>

</details>

<details>
<summary>Blog doesn't flow well?</summary>

- Restructure sections for storytelling
- Add transitions between sections
- Focus on reader journey, not lab steps
- Start with a compelling hook
- End with clear next steps

</details>

---

## Red Hat Developer Blog Resources

<div class="callout callout-info">
<span class="callout-icon">🔗</span>
<div class="callout-body">
<strong>Helpful Links:</strong>
<ul>
<li><a href="https://developers.redhat.com/blog" target="_blank">Red Hat Developer Blog</a></li>
<li><a href="https://developers.redhat.com/blog/write-for-us" target="_blank">Blog Submission Guidelines</a></li>
<li>Contact: <a href="mailto:developer-content@redhat.com">developer-content@redhat.com</a></li>
</ul>
</div>
</div>

---

## Related Skills

<div class="links-grid">
  <a href="create-lab.html" class="link-card">
    <h4>/showroom:create-lab</h4>
    <p>Create workshop first</p>
  </a>
  <a href="verify-content.html" class="link-card">
    <h4>/showroom:verify-content</h4>
    <p>Verify before generating blog</p>
  </a>
  <a href="create-demo.html" class="link-card">
    <h4>/showroom:create-demo</h4>
    <p>Can also be transformed to blog</p>
  </a>
</div>

<div class="navigation-footer">
  <a href="index.html" class="nav-button">← Back to Skills</a>
  <a href="agnosticv-catalog-builder.html" class="nav-button">Next: /agnosticv:catalog-builder →</a>
</div>
