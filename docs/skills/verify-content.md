---
layout: default
title: /showroom:verify-content
---

# /showroom:verify-content

<div class="reference-badge">✅ Content Quality Validation</div>

Validate Showroom workshop or demo content against Red Hat quality standards. Runs all checks silently, then gives you one findings table — pick what to fix first.

---

## Quick Start

```text
/showroom:verify-content
```

Run this from inside your Showroom repo. The skill auto-detects the content and starts immediately.

---

## How It Works

<ol class="steps">
<li>
<div class="step-content">
<h4>Auto-detect</h4>
<p>Checks the current directory for Showroom content (<code>content/modules/ROOT/pages/</code>). Infers whether it's a workshop or demo from the file structure. If nothing is found in CWD, asks for a local path or GitHub URL.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>All checks run silently</h4>
<p>Reads the appropriate verification prompt files for your content type, then runs everything in one pass — scaffold files, structure, AsciiDoc formatting, Red Hat style, and technical accuracy. No output until complete.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>One findings table</h4>
<p>Every issue in a single sorted table: Critical first, then High, Medium, Low. Scaffold issues appear before content issues.</p>

```
| # | ID  | Issue                            | Severity | Location          |
|---|-----|----------------------------------|----------|-------------------|
| 1 | E.4 | Hardcoded cluster URL            | Critical | module-02.adoc:88 |
| 2 | S.1 | site.title is a template default | High     | site.yml:3        |
| 3 | C.5 | Code block missing language      | High     | module-01.adoc:47 |
| 4 | D.2 | "AAP" without first-use expansion| High     | 01-overview.adoc:12|

Total: 4 issues — 1 Critical, 3 High
```

</div>
</li>
<li>
<div class="step-content">
<h4>Fix by number</h4>
<p>The skill asks: <em>"Which issue do you want to fix first?"</em> Enter the number. The skill shows before/after, applies the fix, confirms, then shows the remaining table. Repeat until done.</p>
</div>
</li>
</ol>

---

## What It Checks

<div class="category-grid">
<div class="category-card">
<span class="category-icon">🏗️</span>
<h3>Scaffold (S)</h3>
<ul>
<li><code>site.yml</code> — title, start_page, ui-bundle, supplemental_files</li>
<li><code>ui-config.yml</code> — type, view_switcher, tabs configured</li>
<li><code>content/antora.yml</code> — title, name, nav, lab_name attribute</li>
<li><code>.github/workflows/gh-pages.yml</code> — references correct playbook</li>
</ul>
</div>
<div class="category-card">
<span class="category-icon">📐</span>
<h3>Structure (B)</h3>
<ul>
<li>index, overview, details, conclusion modules exist</li>
<li>Learning objectives ≥3 per module</li>
<li>Exercises have numbered steps + Verify sections</li>
<li>nav.adoc includes all module files</li>
</ul>
</div>
<div class="category-card">
<span class="category-icon">📝</span>
<h3>AsciiDoc (C)</h3>
<ul>
<li>Code blocks have language specifier</li>
<li>Images have descriptive alt text</li>
<li>Sentence case headings</li>
<li>External links open in new tab (<code>^</code>)</li>
</ul>
</div>
<div class="category-card">
<span class="category-icon">🎨</span>
<h3>Red Hat Style (D)</h3>
<ul>
<li>No prohibited terms (robust, powerful, leverage)</li>
<li>Acronyms expanded on first use</li>
<li>Oxford comma, numerals for 0–9</li>
<li>Inclusive language (they/them, allowlist/denylist)</li>
</ul>
</div>
<div class="category-card">
<span class="category-icon">⚙️</span>
<h3>Technical (E)</h3>
<ul>
<li>No hardcoded cluster URLs, usernames, passwords</li>
<li>Expected output after every command</li>
<li>No skipped heading levels</li>
<li>All <code>{attribute}</code> placeholders defined</li>
</ul>
</div>
<div class="category-card">
<span class="category-icon">🎬</span>
<h3>Demo-specific (F)</h3>
<ul>
<li>Know section before Show section</li>
<li>Business value stated per section</li>
<li>Presenter notes present</li>
<li>No hands-on exercises in presenter-led content</li>
</ul>
</div>
</div>

---

## Tips

<div class="category-grid">
<div class="category-card">
<span class="category-icon">🔍</span>
<h3>Run from the right directory</h3>
<p>Start Claude Code inside your Showroom repo so the skill auto-detects without asking. <code>cd ~/work/showroom-content/my-lab && claude</code></p>
</div>
<div class="category-card">
<span class="category-icon">🎯</span>
<h3>Fix Critical first</h3>
<p>Enter the number of the Critical issue first. Critical = broken builds or broken navigation. Everything else is quality.</p>
</div>
<div class="category-card">
<span class="category-icon">🔄</span>
<h3>Re-run after fixing</h3>
<p>Once you've fixed everything, run <code>/showroom:verify-content</code> again to confirm clean. The table should come back empty.</p>
</div>
<div class="category-card">
<span class="category-icon">📋</span>
<h3>Before every PR</h3>
<p>Run verification before creating a pull request. Zero findings = ready to merge.</p>
</div>
</div>

---

## Troubleshooting

<details>
<summary>Skill not found?</summary>

- Restart Claude Code
- Check installation: `/plugin list` — you should see `showroom`
- See the [Troubleshooting Guide](../reference/troubleshooting.html)

</details>

<details>
<summary>Skill lists repos from my showroom-content directory?</summary>

You're not inside a Showroom repo when you run the skill. `cd` into the specific repo first, then run `/showroom:verify-content`. The skill works on CWD — it should never present a list of available repos.

</details>

<details>
<summary>Zero findings but content looks wrong?</summary>

The skill checks against specific criteria. It won't catch everything — have a colleague do a manual read-through, and always test the workshop end-to-end in a live environment before publishing.

</details>

---

## Related Skills

<div class="links-grid">
  <a href="create-lab.html" class="link-card">
    <h4>/showroom:create-lab</h4>
    <p>Generate workshop content first</p>
  </a>
  <a href="create-demo.html" class="link-card">
    <h4>/showroom:create-demo</h4>
    <p>Generate demo content first</p>
  </a>
  <a href="blog-generate.html" class="link-card">
    <h4>/showroom:blog-generate</h4>
    <p>Convert workshop to blog post</p>
  </a>
</div>

<div class="navigation-footer">
  <a href="index.html" class="nav-button">← Back to Skills</a>
  <a href="blog-generate.html" class="nav-button">Next: /showroom:blog-generate →</a>
</div>
