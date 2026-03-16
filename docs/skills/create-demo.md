---
layout: default
title: /showroom:create-demo
---

# /showroom:create-demo

<div class="reference-badge">🎬 Demo Content Creation</div>

Create presenter-led demo content where YOU present and customers watch.

---

## Is This The Right Skill?

<div class="vs-grid">
<div class="vs-card vs-card-skill">
<span class="vs-label">Use create-demo when</span>
<h3>YOU present, customers watch</h3>
<ul>
<li>Like presenting PowerPoint — you drive</li>
<li>You want <strong>Know → Show</strong> structure</li>
<li>One presenter showing features</li>
</ul>
</div>
<div class="vs-card vs-card-agent">
<span class="vs-label">Use create-lab instead when</span>
<h3>Customers DO hands-on activities</h3>
<ul>
<li>Customers click buttons, run commands</li>
<li>Multiple participants following step-by-step</li>
</ul>
</div>
</div>

<div class="callout callout-tip">
<span class="callout-icon">💡</span>
<div class="callout-body">
<strong>Not sure?</strong> Demos are presentational (you drive). Labs are interactive (customers drive).
</div>
</div>

---

## What You'll Need Before Starting

### Required Inputs

<div class="category-grid">
<div class="category-card">
<span class="category-icon">🎯</span>
<h3>Demo Topic</h3>
<p>Example: "OpenShift AI capabilities"</p>
</div>
<div class="category-card">
<span class="category-icon">⭐</span>
<h3>Key Features</h3>
<p>Features to highlight</p>
</div>
<div class="category-card">
<span class="category-icon">📊</span>
<h3>Number of Sections</h3>
<p>Typically 3–4 segments</p>
</div>
<div class="category-card">
<span class="category-icon">👥</span>
<h3>Target Audience</h3>
<p>Technical, business, or executive</p>
</div>
</div>

### What The AI Will Create

<div class="callout callout-tip">
<span class="callout-icon">✅</span>
<div class="callout-body">
<strong>Generated Files:</strong>
<ul>
<li>Navigation page (index.adoc)</li>
<li>Section files (one per demo segment)</li>
<li>Know/Show structure for each section</li>
<li>Presenter notes and customer-facing content</li>
</ul>
</div>
</div>

<div class="callout callout-info">
<span class="callout-icon">ℹ️</span>
<div class="callout-body">
<strong>You DON'T need:</strong> Git knowledge, coding experience, or AsciiDoc expertise. The AI handles all technical aspects.
</div>
</div>

---

## Quick Start

<ol class="steps">
<li><div class="step-content"><h4>Open Your IDE</h4><p>Launch Claude Code (or VS Code with Claude extension)</p></div></li>
<li><div class="step-content"><h4>Invoke Skill</h4><p>Type <code>/showroom:create-demo</code> in the chat</p></div></li>
<li><div class="step-content"><h4>Answer Questions</h4><p>Provide demo title, description, technologies, sections, and audience level</p></div></li>
<li><div class="step-content"><h4>Review &amp; Customize</h4><p>Add screenshots and customize content</p></div></li>
</ol>

---

## What It Creates

```
content/modules/ROOT/
├── pages/
│   ├── index.adoc              # Navigation home
│   ├── section-01.adoc         # First section
│   ├── section-02.adoc         # Second section
│   └── section-03.adoc         # Third section
└── partials/
    └── _attributes.adoc        # Demo metadata
```

---

## Common Workflow

<ol class="steps">
<li>
<div class="step-content">
<h4>Invoke Skill</h4>

```
/showroom:create-demo
→ Skill loads prompts from showroom/prompts/
```

</div>
</li>
<li>
<div class="step-content">
<h4>Demo Details</h4>
<p>Answer prompts for demo title, abstract, technologies, audience level, and number of sections.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>Provide Showroom Repository Path</h4>
<p>Skill asks for your Showroom repo. You can provide a local path or a GitHub URL — the skill auto-clones GitHub URLs to <code>/tmp/</code>:</p>

```
# Local path
~/work/showroom-content/your-demo-showroom

# GitHub URL (auto-cloned to /tmp/your-demo-showroom)
https://github.com/rhpds/your-demo-showroom
```

</div>
</li>
<li>
<div class="step-content">
<h4>Showroom Scaffold (site.yml + ui-config.yml)</h4>
<p>Skill configures the two key infrastructure files:</p>

```
site.yml              # Antora playbook — fix title, ui-bundle theme
ui-config.yml          # Split view + tabs (view_switcher.enabled: true)
```

<div class="callout callout-info">
<span class="callout-icon">ℹ️</span>
<div class="callout-body">
<strong>Showroom 1.5.3+ required</strong> for split-view and OCP console embedding. Clone from <code>showroom_template_nookbag</code> as your starting template.
</div>
</div>
</div>
</li>
<li>
<div class="step-content">
<h4>Generate Section Content</h4>
<p>Skill generates <code>index.adoc</code> and one file per demo section using Know/Show structure. UserInfo attributes are written once in <code>_attributes.adoc</code>.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>Verify Content</h4>

```
/showroom:verify-content
→ Check quality and standards
```

</div>
</li>
<li>
<div class="step-content">
<h4>Generate Blog Post (Optional)</h4>

```
/showroom:blog-generate
→ Transform to blog format
```

</div>
</li>
</ol>

---

## Section Structure Pattern

<div class="section-primary">
<h3 class="text-center">Know → Show</h3>
<p class="text-center">Each section follows this proven demonstration pattern:</p>

<div class="category-grid">
<div class="category-card">
<span class="category-icon">📖</span>
<h3>Know Section</h3>
<ul>
<li>Explains what you'll demonstrate</li>
<li>Provides context and business value</li>
<li>Sets up the "why"</li>
</ul>
</div>
<div class="category-card">
<span class="category-icon">👁️</span>
<h3>Show Section</h3>
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

## Tips &amp; Best Practices

<div class="category-grid">
<div class="category-card">
<span class="category-icon">📊</span>
<h3>Section Count</h3>
<p>Start with 3–4 sections for new demos</p>
</div>
<div class="category-card">
<span class="category-icon">⏱️</span>
<h3>Timing</h3>
<p>Each section should take 5–10 minutes</p>
</div>
<div class="category-card">
<span class="category-icon">🎯</span>
<h3>Focus</h3>
<p>Keep Show sections focused on one main feature</p>
</div>
<div class="category-card">
<span class="category-icon">📝</span>
<h3>Presenter Notes</h3>
<p>Include timing and transition notes</p>
</div>
<div class="category-card">
<span class="category-icon">📸</span>
<h3>Screenshots</h3>
<p>Use screenshots to guide the flow</p>
</div>
<div class="category-card">
<span class="category-icon">🎬</span>
<h3>Practice</h3>
<p>Run through demo before presenting</p>
</div>
</div>

---

## Troubleshooting

<details>
<summary>Skill not found?</summary>

- Restart Claude Code or VS Code
- Verify installation: `ls ~/.claude/skills/create-demo` (Claude Code) or `ls ~/.cursor/skills/showroom-create-demo` (Cursor)
- Check the [Troubleshooting Guide](../reference/troubleshooting.html)

</details>

<details>
<summary>Generated content looks wrong?</summary>

- Check your demo template is up to date
- Verify you're in the correct directory
- Run `/showroom:verify-content` to check standards compliance

</details>

<details>
<summary>Demo vs Lab confusion?</summary>

<div class="callout callout-info">
<span class="callout-icon">💡</span>
<div class="callout-body">
<strong>Quick Decision Guide:</strong>
<ul>
<li>Use <code>/showroom:create-demo</code> for presenter-led content (Know/Show)</li>
<li>Use <code>/showroom:create-lab</code> for hands-on workshops (Know/Do/Check)</li>
</ul>
Think: "Am I showing, or are they doing?"
</div>
</div>

</details>

---

## Related Skills

<div class="links-grid">
  <a href="verify-content.html" class="link-card">
    <h4>/showroom:verify-content</h4>
    <p>Validate generated content</p>
  </a>
  <a href="create-lab.html" class="link-card">
    <h4>/showroom:create-lab</h4>
    <p>Create hands-on workshops instead</p>
  </a>
  <a href="blog-generate.html" class="link-card">
    <h4>/showroom:blog-generate</h4>
    <p>Convert to blog post format</p>
  </a>
</div>

<div class="navigation-footer">
  <a href="index.html" class="nav-button">← Back to Skills</a>
  <a href="verify-content.html" class="nav-button">Next: /showroom:verify-content →</a>
</div>
