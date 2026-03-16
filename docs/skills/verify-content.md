---
layout: default
title: /showroom:verify-content
---

# /showroom:verify-content

<div class="reference-badge">✅ Content Quality Validation</div>

Validate Showroom workshop or demo content for quality and Red Hat standards compliance.

---

## Prerequisites

<div class="category-grid">
<div class="category-card">
<span class="category-icon">📁</span>
<h3>Workshop Content Ready</h3>

```
# Your Showroom repository with:
content/modules/ROOT/pages/*.adoc
```

</div>
<div class="category-card">
<span class="category-icon">✓</span>
<h3>Content Complete</h3>
<ul>
<li>All module/section files created</li>
<li>Navigation structure in place</li>
<li>Images and diagrams included</li>
<li>Code examples added</li>
</ul>
</div>
<div class="category-card">
<span class="category-icon">💾</span>
<h3>Files Saved</h3>
<ul>
<li>Current directory in Showroom repo</li>
<li>All AsciiDoc files saved</li>
</ul>
</div>
</div>

---

## Quick Start

<ol class="steps">
<li><div class="step-content"><h4>Navigate to Repository</h4><p>Open your workshop repository directory</p></div></li>
<li><div class="step-content"><h4>Run Verification</h4><p><code>/showroom:verify-content</code></p></div></li>
<li><div class="step-content"><h4>Review Results</h4><p>Check validation report for issues</p></div></li>
<li><div class="step-content"><h4>Fix Issues</h4><p>Address errors and warnings</p></div></li>
</ol>

---

## What It Checks

<div class="category-grid">
<div class="category-card">
<span class="category-icon">📝</span>
<h3>Content Quality</h3>
<ul>
<li><strong>Structure:</strong> Proper AsciiDoc formatting</li>
<li><strong>Navigation:</strong> Links and cross-references work</li>
<li><strong>Code blocks:</strong> Syntax highlighting and formatting</li>
<li><strong>Images:</strong> Proper paths and alt text</li>
</ul>
</div>
<div class="category-card">
<span class="category-icon">🎨</span>
<h3>Red Hat Standards</h3>
<ul>
<li><strong>Terminology:</strong> Correct product names</li>
<li><strong>Voice:</strong> Active, clear, direct language</li>
<li><strong>Style:</strong> Consistent formatting</li>
<li><strong>Branding:</strong> Red Hat guidelines compliance</li>
</ul>
</div>
<div class="category-card">
<span class="category-icon">⚙️</span>
<h3>Technical Accuracy</h3>
<ul>
<li><strong>Commands:</strong> Valid syntax</li>
<li><strong>Examples:</strong> Working code snippets</li>
<li><strong>Versions:</strong> Current product versions</li>
<li><strong>URLs:</strong> Valid links to documentation</li>
</ul>
</div>
<div class="category-card">
<span class="category-icon">🖥️</span>
<h3>Scaffold Files</h3>
<ul>
<li><strong>site.yml</strong> (preferred) or <strong>default-site.yml</strong>: Title not stale, start_page, ui-bundle URL, supplemental_files pointing to <code>./content/supplemental-ui</code></li>
<li><strong>site.yml standard:</strong> If repo has <code>default-site.yml</code> only → flag to rename to <code>site.yml</code> and update gh-pages.yml reference</li>
<li><strong>ui-config.yml:</strong> type: showroom, view_switcher enabled, tabs configured, persist_url_state</li>
<li><strong>content/antora.yml:</strong> title not stale, name: modules, start_page, nav, lab_name attribute</li>
<li><strong>content/lib/:</strong> All 4 JS extension files present</li>
<li><strong>content/supplemental-ui/:</strong> Red Hat branding files (CSS, HBS partials)</li>
</ul>
</div>
</div>

---

## Common Workflow

<ol class="steps">
<li>
<div class="step-content">
<h4>Invoke Skill</h4>

```
/showroom:verify-content
```

<p>Prompts load directly from <code>showroom/prompts/</code> in the marketplace plugin.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>Scaffold File Check</h4>
<p>Silently checks all scaffold files and surfaces issues grouped by severity:</p>
<ul>
<li><strong>Critical:</strong> Missing required files (site.yml or default-site.yml, ui-config.yml, antora.yml)</li>
<li><strong>High:</strong> Stale/template titles in site.yml, ui-config.yml, antora.yml; <code>default-site.yml</code> present (rename to <code>site.yml</code>); missing view_switcher or tabs</li>
<li><strong>High:</strong> Wrong paths (supplemental_files), missing content/lib/ JS files</li>
</ul>
</div>
</li>
<li>
<div class="step-content">
<h4>Checklist Verification (5 passes)</h4>
<p>Each pass produces a complete PASS/FAIL/N/A table before the next starts:</p>
<ul>
<li><strong>Pass B:</strong> Structure (index, modules, nav, conclusion, exercises, verify sections)</li>
<li><strong>Pass C:</strong> AsciiDoc formatting (images, links, code blocks, lists, headings)</li>
<li><strong>Pass D:</strong> Red Hat style (product names, prohibited terms, numerals, Oxford comma)</li>
<li><strong>Pass E:</strong> Technical accuracy (commands, variables, hardcoded values, heading hierarchy)</li>
<li><strong>Pass F:</strong> Demo-specific (Know/Show, presenter notes — skipped for workshops)</li>
</ul>
</div>
</li>
<li>
<div class="step-content">
<h4>Fix Issues</h4>
<ul>
<li>Fix AsciiDoc formatting errors</li>
<li>Update product terminology</li>
<li>Correct code examples</li>
<li>Add missing alt text</li>
<li>Add <code>view_switcher</code> to <code>ui-config.yml</code> if warned</li>
</ul>
</div>
</li>
<li>
<div class="step-content">
<h4>Re-verify</h4>

```
/showroom:verify-content
→ Confirm all issues resolved
```

</div>
</li>
</ol>

---

## Example Validation Report

**Sample output:**

<div class="callout callout-tip">
<span class="callout-icon">✅</span>
<div class="callout-body"><strong>Structure:</strong> All modules follow Know/Do/Check pattern</div>
</div>

<div class="callout callout-tip">
<span class="callout-icon">✅</span>
<div class="callout-body"><strong>Navigation:</strong> All links valid</div>
</div>

<div class="callout callout-warning">
<span class="callout-icon">⚠️</span>
<div class="callout-body"><strong>Terminology:</strong> Found "Openshift" (should be "OpenShift")</div>
</div>

<div class="callout callout-warning">
<span class="callout-icon">⚠️</span>
<div class="callout-body"><strong>Code blocks:</strong> Missing language identifier in module-02.adoc</div>
</div>

<div class="callout callout-danger">
<span class="callout-icon">🚨</span>
<div class="callout-body"><strong>Images:</strong> Missing alt text for diagram.png</div>
</div>

---

## Tips &amp; Best Practices

<div class="category-grid">
<div class="category-card">
<span class="category-icon">🔍</span>
<h3>Before Pull Requests</h3>
<p>Run verification before creating PRs</p>
</div>
<div class="category-card">
<span class="category-icon">📝</span>
<h3>Incremental Fixes</h3>
<p>Fix issues one at a time, don't batch</p>
</div>
<div class="category-card">
<span class="category-icon">📚</span>
<h3>Learning Tool</h3>
<p>Use verification to learn standards</p>
</div>
<div class="category-card">
<span class="category-icon">🏷️</span>
<h3>Product Names</h3>
<p>Check capitalization carefully</p>
</div>
<div class="category-card">
<span class="category-icon">⚙️</span>
<h3>Test Code</h3>
<p>Verify all examples actually work</p>
</div>
<div class="category-card">
<span class="category-icon">📊</span>
<h3>Priority Order</h3>
<p>Fix ❌ first, then ⚠️, then ℹ️</p>
</div>
</div>

---

## Troubleshooting

<details>
<summary>Skill not found?</summary>

- Restart Claude Code or VS Code
- Verify installation: `ls ~/.claude/skills/verify-content` (Claude Code) or `ls ~/.cursor/skills/showroom-verify-content` (Cursor)
- Check the [Troubleshooting Guide](../reference/troubleshooting.html)

</details>

<details>
<summary>No issues found but content looks wrong?</summary>

- Manual review is still important
- Skill checks common issues, not everything
- Have a colleague review
- Test the workshop end-to-end

</details>

<details>
<summary>Too many errors?</summary>

<div class="callout callout-warning">
<span class="callout-icon">⚠️</span>
<div class="callout-body">
<strong>Prioritize Your Fixes:</strong>
<ol>
<li><strong>❌ Critical issues</strong> — Must fix (broken links, missing files)</li>
<li><strong>⚠️ Warnings</strong> — Should fix (terminology, formatting)</li>
<li><strong>ℹ️ Style suggestions</strong> — Optional improvements</li>
</ol>
Start with critical issues and work your way down.
</div>
</div>

</details>

---

## Related Skills

<div class="links-grid">
  <a href="create-lab.html" class="link-card">
    <h4>/showroom:create-lab</h4>
    <p>Generate workshop content</p>
  </a>
  <a href="create-demo.html" class="link-card">
    <h4>/showroom:create-demo</h4>
    <p>Generate demo content</p>
  </a>
  <a href="blog-generate.html" class="link-card">
    <h4>/showroom:blog-generate</h4>
    <p>Convert to blog format</p>
  </a>
</div>

<div class="navigation-footer">
  <a href="index.html" class="nav-button">← Back to Skills</a>
  <a href="blog-generate.html" class="nav-button">Next: /showroom:blog-generate →</a>
</div>
