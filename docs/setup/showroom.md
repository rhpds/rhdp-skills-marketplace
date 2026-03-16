---
layout: default
title: Showroom Namespace Setup
---

# Showroom Namespace Setup

<div class="reference-badge">Content Creation Skills</div>

Complete setup guide for Red Hat Showroom workshop and demo content creation.

---

## Overview

<div class="callout callout-info"><span class="callout-icon">ℹ️</span><div class="callout-body">
  <p>The <strong>showroom</strong> namespace provides AI-powered skills for creating Red Hat Showroom workshop and demo content. These skills focus purely on content creation without infrastructure provisioning.</p>

  <p><strong>Target Audience:</strong> Content creators, technical writers, workshop developers</p>
</div></div>

---

## Installation

<div class="callout callout-info"><span class="callout-icon">ℹ️</span><div class="callout-body">
  <h4>Install the showroom namespace:</h4>
  <div class="category-grid" style="margin-top: 1rem;">
    <div class="category-card">
      <h5>Claude Code</h5>
      <pre><code>/plugin marketplace add rhpds/rhdp-skills-marketplace
/plugin install showroom@rhdp-marketplace</code></pre>
    </div>
    <div class="category-card">
      <h5>Cursor</h5>
      <pre><code>curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install-cursor.sh | bash</code></pre>
    </div>
  </div>
</div></div>

---

## Included Skills

<div class="category-grid">
  <a href="../skills/create-lab.html" class="category-card">
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

  <a href="../skills/create-demo.html" class="category-card">
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

  <a href="../skills/verify-content.html" class="category-card">
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

  <a href="../skills/blog-generate.html" class="category-card">
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

## Prerequisites

<div class="category-grid">
  <div class="category-card">
    <h3>Required</h3>
    <ul>
      <li><strong>Claude Code</strong> or <strong>Cursor</strong> installed</li>
      <li>Basic understanding of AsciiDoc (helpful but not required)</li>
    </ul>
  </div>

  <div class="category-card">
    <h3>Optional</h3>
    <ul>
      <li>Red Hat Showroom template repository</li>
      <li>GitHub account for publishing</li>
      <li>Red Hat Developer account (for blog publishing)</li>
    </ul>
  </div>
</div>

---

## Typical Workflow

<ol class="steps">
  <li><div class="step-content"><p><code>/showroom:create-lab</code> or <code>/showroom:create-demo</code></p></div></li>
  <li><div class="step-content"><p>Review and edit generated content</p></div></li>
  <li><div class="step-content"><p><code>/showroom:verify-content</code></p></div></li>
  <li><div class="step-content"><p>Fix any issues identified</p></div></li>
  <li><div class="step-content"><p><code>/showroom:blog-generate</code> <span class="text-muted">(optional)</span></p></div></li>
  <li><div class="step-content"><p>Publish to Showroom and/or blog</p></div></li>
</ol>

---

## Example: Creating a Workshop Lab

<ol class="steps">
  <li><div class="step-content">
    <h4>Run /showroom:create-lab</h4>
    <pre><code>In Claude Code or Cursor:
/showroom:create-lab

Answer prompts:
- Lab name: "CI/CD with OpenShift Pipelines"
- Abstract: "Learn cloud-native CI/CD using Tekton pipelines on OpenShift"
- Technologies: Tekton, OpenShift, Pipelines
- Module count: 3</code></pre>
  </div></li>

  <li><div class="step-content">
    <h4>Generated Structure</h4>
    <pre><code>content/modules/ROOT/
├── pages/
│   ├── index.adoc
│   ├── module-01.adoc
│   ├── module-02.adoc
│   └── module-03.adoc
├── partials/
│   └── _attributes.adoc
└── nav.adoc</code></pre>
  </div></li>

  <li><div class="step-content">
    <h4>Verify Quality</h4>
    <pre><code>/showroom:verify-content

Reviews:
✓ AsciiDoc syntax
✓ Know/Do/Check structure
✓ Exercise clarity
⚠️ Suggestions for improvement</code></pre>
  </div></li>

  <li><div class="step-content">
    <h4>Generate Blog (Optional)</h4>
    <pre><code>/showroom:blog-generate

Creates:
- Blog post from workshop content
- Introduction and conclusion
- Key takeaways
- Call-to-action</code></pre>
  </div></li>
</ol>

---

## Content Structure

<div class="callout callout-info"><span class="callout-icon">ℹ️</span><div class="callout-body">
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
</div></div>

<div class="callout callout-info"><span class="callout-icon">ℹ️</span><div class="callout-body">
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
</div></div>

---

## Tips & Best Practices

<div class="category-grid">
  <div class="category-card">
    <h3>Content Creation</h3>
    <ol>
      <li><strong>Start with clear objectives</strong> - Know what learners should achieve</li>
      <li><strong>Keep modules focused</strong> - One concept per module</li>
      <li><strong>Use active voice</strong> - "Create a pipeline" not "A pipeline is created"</li>
      <li><strong>Test exercises</strong> - Ensure steps work as documented</li>
      <li><strong>Add verification</strong> - Help learners confirm success</li>
    </ol>
  </div>

  <div class="category-card">
    <h3>Using Skills</h3>
    <ol>
      <li><strong>Be specific with prompts</strong> - More detail = better output</li>
      <li><strong>Iterate on content</strong> - Run /showroom:create-lab multiple times if needed</li>
      <li><strong>Verify early</strong> - Run /showroom:verify-content before extensive edits</li>
      <li><strong>Leverage examples</strong> - Ask skills for similar examples</li>
    </ol>
  </div>
</div>

---

## Troubleshooting

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

## Next Steps

<div class="links-grid">
  <a href="../skills/" class="link-card"><h4>View All Skills</h4><p>Explore skill documentation</p></a>
  <a href="../reference/quick-reference.html" class="link-card"><h4>Quick Reference</h4><p>Common commands & workflows</p></a>
  <a href="../reference/troubleshooting.html" class="link-card"><h4>Troubleshooting</h4><p>Common issues & solutions</p></a>
</div>

---

<div class="navigation-footer">
  <a href="index.html" class="nav-button">← Back to Setup</a>
  <a href="agnosticv.html" class="nav-button">Next: AgnosticV Setup →</a>
</div>
