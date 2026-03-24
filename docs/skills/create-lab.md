---
layout: default
title: /showroom:create-lab
---

# /showroom:create-lab

<div class="reference-badge">📝 Workshop Lab Creation</div>

Create hands-on workshop content where customers follow along step-by-step.

---

## Is This The Right Skill?

<div class="vs-grid">
<div class="vs-card vs-card-skill">
<span class="vs-label">Use create-lab when</span>
<h3>Customers DO things hands-on</h3>
<ul>
<li>Customers click buttons, run commands, follow steps</li>
<li>You want <strong>Know → Do → Check</strong> structure</li>
<li>Multiple participants learning together</li>
</ul>
</div>
<div class="vs-card vs-card-agent">
<span class="vs-label">Use create-demo instead when</span>
<h3>YOU present, customers watch</h3>
<ul>
<li>One-directional presentation (like PowerPoint)</li>
<li>Know → Show structure</li>
<li>Single presenter showing features</li>
</ul>
</div>
</div>

<div class="callout callout-tip">
<span class="callout-icon">💡</span>
<div class="callout-body">
<strong>Not sure?</strong> Labs are more interactive. Demos are more presentational.
</div>
</div>

---

## What You'll Need Before Starting

### Required Inputs

<div class="category-grid">
<div class="category-card">
<span class="category-icon">📚</span>
<h3>Workshop Topic</h3>
<p>Example: "Getting started with OpenShift Pipelines"</p>
</div>
<div class="category-card">
<span class="category-icon">🎯</span>
<h3>Learning Goals</h3>
<p>What should customers learn?</p>
</div>
<div class="category-card">
<span class="category-icon">📊</span>
<h3>Number of Sections</h3>
<p>Typically 3–5 modules</p>
</div>
<div class="category-card">
<span class="category-icon">📖</span>
<h3>Reference Materials</h3>
<p>Product docs, screenshots, etc.</p>
</div>
</div>

### What The AI Will Create

<div class="callout callout-tip">
<span class="callout-icon">✅</span>
<div class="callout-body">
<strong>Generated Files:</strong>
<ul>
<li>Navigation page (index.adoc)</li>
<li>Module files (one per section)</li>
<li>Know/Do/Check structure for each module</li>
<li>Placeholder images and examples</li>
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
<li><div class="step-content"><h4>Invoke Skill</h4><p>Type <code>/showroom:create-lab</code> in the chat</p></div></li>
<li><div class="step-content"><h4>Answer Questions</h4><p>Provide workshop title, abstract, technologies, modules, and objectives</p></div></li>
<li><div class="step-content"><h4>Review &amp; Customize</h4><p>Review generated content and edit as needed</p></div></li>
</ol>

---

## What It Creates

```
content/modules/ROOT/
├── pages/
│   ├── index.adoc              # Navigation home
│   ├── module-01.adoc          # First module
│   ├── module-02.adoc          # Second module
│   └── module-03.adoc          # Third module
└── partials/
    └── _attributes.adoc        # Workshop metadata
```

---

## Common Workflow

<ol class="steps">
<li>
<div class="step-content">
<h4>Invoke Skill</h4>

```
/showroom:create-lab
→ Skill loads prompts from showroom/prompts/
```

</div>
</li>
<li>
<div class="step-content">
<h4>Workshop Details</h4>
<p>Answer prompts for workshop title, abstract, technologies, and number of modules.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>Provide Showroom Repository Path</h4>
<p>Skill asks for your Showroom repo. You can provide a local path or a GitHub URL — the skill auto-clones GitHub URLs to <code>/tmp/</code>:</p>

```
# Local path
~/work/showroom-content/your-lab-showroom

# GitHub URL (auto-cloned to /tmp/your-lab-showroom)
https://github.com/rhpds/your-lab-showroom
```

</div>
</li>
<li>
<div class="step-content">
<h4>Showroom Scaffold (site.yml + ui-config.yml)</h4>
<p>Skill configures the two key infrastructure files in your Showroom repo (cloned from showroom_template_nookbag):</p>

```
site.yml              # Antora playbook — fix title, ui-bundle theme
ui-config.yml          # Split view + tabs (view_switcher.enabled: true)
```

<p>Skill also asks: <em>"Will this lab embed an OCP console or terminal tab?"</em> — configures console embedding if yes.</p>

<div class="callout callout-info">
<span class="callout-icon">ℹ️</span>
<div class="callout-body">
<strong>Showroom 1.5.3+ required</strong> for split-view and OCP console embedding. Clone from <code>showroom_template_nookbag</code> as your starting template.
<br><br>
<strong>Existing nookbag repos:</strong> If your repo was cloned before March 2026, it may have <code>[source,bash]</code> blocks without <code>role="execute"</code>. The skill detects this and offers to bulk-fix all existing modules. New content is always generated with <code>[source,role="execute"]</code> regardless.
</div>
</div>
</div>
</li>
<li>
<div class="step-content">
<h4>Generate Module Content</h4>
<p>Skill generates <code>index.adoc</code> and one file per module using Know/Do/Check structure. UserInfo attributes are written once in <code>_attributes.adoc</code> (no duplicate entries).</p>
</div>
</li>
<li>
<div class="step-content">
<h4>Verify Content</h4>

```
/showroom:verify-content
→ Check quality and standards
→ Checks ui-config.yml for console and view_switcher
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

## Module Structure Pattern

<div class="section-primary">
<h3 class="text-center">Know → Do → Check</h3>
<p class="text-center">Each module follows this proven learning pattern:</p>

<div class="category-grid">
<div class="category-card">
<span class="category-icon">📖</span>
<h3>Know Section</h3>
<ul>
<li>Explains the concept</li>
<li>Provides context and background</li>
</ul>
</div>
<div class="category-card">
<span class="category-icon">⚙️</span>
<h3>Do Section</h3>
<ul>
<li>Hands-on exercise</li>
<li>Step-by-step instructions</li>
<li>Code examples with syntax highlighting</li>
</ul>
</div>
<div class="category-card">
<span class="category-icon">✓</span>
<h3>Check Section</h3>
<ul>
<li>Verification steps</li>
<li>Expected results</li>
<li>Troubleshooting tips</li>
</ul>
</div>
</div>
</div>

---

## Tips &amp; Best Practices

<div class="category-grid">
<div class="category-card">
<span class="category-icon">📊</span>
<h3>Module Count</h3>
<p>Start with 3–4 modules for new workshops</p>
</div>
<div class="category-card">
<span class="category-icon">⏱️</span>
<h3>Timing</h3>
<p>Each module should take 10–15 minutes</p>
</div>
<div class="category-card">
<span class="category-icon">🎯</span>
<h3>Focus</h3>
<p>Keep Do sections focused on one main task</p>
</div>
<div class="category-card">
<span class="category-icon">📸</span>
<h3>Screenshots</h3>
<p>Use screenshots sparingly (AsciiDoc format)</p>
</div>
</div>

---

## Troubleshooting

<details>
<summary>Skill not found?</summary>

- Restart Claude Code or VS Code
- Verify installation: `ls ~/.claude/skills/create-lab` (Claude Code) or `ls ~/.cursor/skills/showroom-create-lab` (Cursor)
- Check the [Troubleshooting Guide](../reference/troubleshooting.html)

</details>

<details>
<summary>Generated content looks wrong?</summary>

- Check your workshop template is up to date
- Verify you're in the correct directory
- Run `/showroom:verify-content` to check standards compliance

</details>

---

## Related Skills

<div class="links-grid">
  <a href="verify-content.html" class="link-card">
    <h4>/showroom:verify-content</h4>
    <p>Validate generated content</p>
  </a>
  <a href="create-demo.html" class="link-card">
    <h4>/showroom:create-demo</h4>
    <p>Create presenter-led demos instead</p>
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
