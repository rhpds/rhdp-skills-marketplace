---
layout: home
title: Home
---

<div class="hero">
  <div class="hero-eyebrow">v2.14.0 · Red Hat Demo Platform</div>
  <h1>RHDP Skills Marketplace</h1>
  <p class="hero-subtitle">AI-powered skills for Claude Code. Create workshops, demos, and catalog items faster — with built-in Red Hat standards and quality checks.</p>
  <div class="hero-actions">
    <a href="#skills" class="btn btn-primary btn-large">Browse Skills</a>
    <a href="#platforms" class="btn btn-secondary">Get Started</a>
  </div>
</div>

<div class="section" id="skills">
  <div class="section-header">
    <h2>Available Skills</h2>
    <p>8 skills · 10 agents · 4 namespaces — orchestrator pattern with parallel execution</p>
  </div>

  <div class="category-grid">
    <div class="category-card">
      <span class="category-icon">📝</span>
      <h3>Showroom — Workshop &amp; Demo Creation</h3>
      <p>Create labs, demos, and blog posts for Red Hat Showroom. Handles AsciiDoc, navigation, quality validation, and Red Hat style standards.</p>
      <ul style="margin: 0.875rem 0; color: var(--color-text-3); font-size: 0.875rem;">
        <li><code>/showroom:create-lab</code> — Hands-on workshop modules (Know/Do/Check)</li>
        <li><code>/showroom:create-demo</code> — Presenter-led demos (Know/Show)</li>
        <li><code>/showroom:verify-content</code> — Quality &amp; standards validation</li>
        <li><code>/showroom:blog-generate</code> — Workshop → blog post</li>
      </ul>
      <a href="{{ '/skills/create-lab.html' | relative_url }}">Learn more →</a>
    </div>

    <div class="category-card">
      <span class="category-icon">⚙️</span>
      <h3>AgnosticV — Catalog Automation</h3>
      <p>Build and validate RHDP catalog items — common.yaml, dev.yaml, description.adoc, info messages — with guided questions covering all infrastructure types.</p>
      <ul style="margin: 0.875rem 0; color: var(--color-text-3); font-size: 0.875rem;">
        <li><code>/agnosticv:catalog-builder</code> — Create or update catalog items</li>
        <li><code>/agnosticv:validator</code> — Validate before submitting PR</li>
      </ul>
      <a href="{{ '/skills/agnosticv-catalog-builder.html' | relative_url }}">Learn more →</a>
    </div>

    <div class="category-card">
      <span class="category-icon">🏥</span>
      <h3>Health — Infrastructure Validation</h3>
      <p><strong>Did my workload deploy correctly?</strong> Generates Ansible roles that check pods, routes, and services are healthy — run at provisioning time, not during student exercises.</p>
      <ul style="margin: 0.875rem 0; color: var(--color-text-3); font-size: 0.875rem;">
        <li><code>/health:deployment-validator</code> — Create Ansible health check roles for deployed workloads</li>
      </ul>
      <a href="{{ '/skills/deployment-health-checker.html' | relative_url }}">Learn more →</a>
    </div>

    <div class="category-card">
      <span class="category-icon">🧪</span>
      <h3>FTL — E2E Lab Testing</h3>
      <p><strong>Can a student complete the lab?</strong> Reads your .adoc modules and writes solve.yml + validate.yml playbooks for student exercise validation. 4-agent pipeline with self-healing Playwright and screenshot evidence.</p>
      <ul style="margin: 0.875rem 0; color: var(--color-text-3); font-size: 0.875rem;">
        <li><code>/ftl:rhdp-lab-validator</code> — Orchestrate 4 agents: read → solve → validate → test</li>
        <li><code>/ftl:content-reader</code> — AsciiDoc reader with vision analysis</li>
        <li><code>/ftl:solve-writer</code> — Intent-based Playwright, self-healing on UI changes</li>
        <li><code>/ftl:env-connector</code> — Live test + screenshot evidence + UI drift recovery</li>
      </ul>
      <a href="{{ '/skills/rhdp-lab-validator.html' | relative_url }}">Learn more →</a>
    </div>

    <div class="category-card">
      <span class="category-icon">🔎</span>
      <h3>AIOps — Incident Investigation</h3>
      <p>AI-assisted root-cause analysis of infrastructure failures. Correlate Ansible/AAP logs with Splunk OCP pod logs and GitHub configuration to diagnose failed jobs.</p>
      <ul style="margin: 0.875rem 0; color: var(--color-text-3); font-size: 0.875rem;">
        <li><code>/aiops-skill:root-cause-analysis</code> — Investigate job failures</li>
        <li><code>/aiops-skill:logs-fetcher</code> — Fetch logs via SSH</li>
        <li><code>/aiops-skill:context-fetcher</code> — Fetch config and docs</li>
        <li><code>/aiops-skill:feedback-capture</code> — Capture session feedback</li>
      </ul>
      <a href="{{ '/skills/root-cause-analysis.html' | relative_url }}">Learn more →</a>
    </div>
  </div>
</div>

<div class="section section-primary" id="platforms">
  <div class="section-header">
    <h2>Quick Install</h2>
    <p>Two commands to get started on Claude Code</p>
  </div>

  <div class="category-grid">
    <div class="category-card">
      <span class="category-icon">🚀</span>
      <h3>Claude Code <span class="badge badge-recommended" style="vertical-align:middle;">Recommended</span></h3>
      <p>Native plugin marketplace — automatic updates, version management.</p>

```
/plugin marketplace add rhpds/rhdp-skills-marketplace
/plugin install showroom@rhdp-marketplace
```

      <a href="{{ '/setup/claude-code.html' | relative_url }}">Full setup guide →</a>
    </div>

    <div class="category-card">
      <span class="category-icon">⚡</span>
      <h3>Cursor</h3>
      <p>One-command bash install. Works alongside your existing Cursor setup.</p>

```
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install-cursor.sh | bash
```

      <a href="{{ '/setup/cursor.html' | relative_url }}">Full setup guide →</a>
    </div>
  </div>
  <p class="platform-note">Also works with VS Code using the Claude extension — same setup as Claude Code.</p>
</div>

<div class="section">
  <div class="section-header">
    <h2>What's New — v2.14.0</h2>
    <p>Major release: agent orchestrator pattern, parallel execution, PH integration · <a href="{{ '/reference/changelog.html' | relative_url }}">Full changelog →</a></p>
  </div>

  <div class="category-grid">
    <div class="category-card">
      <span class="category-icon">⚡</span>
      <h3>Skill-as-Orchestrator Pattern</h3>
      <p>All showroom skills now delegate to specialized agents running in parallel — same design as the FTL plugin. <strong>6× faster</strong> on a 6-module lab (8 min → ~90 sec). Each agent returns dimension-scored JSON, enabling future regression detection.</p>
    </div>

    <div class="category-card">
      <span class="category-icon">🤖</span>
      <h3>5 New Showroom Agents</h3>
      <p><code>scaffold-checker</code> (Haiku), <code>module-reviewer</code> (Sonnet), <code>file-generator</code> (Sonnet), <code>score-aggregator</code> (Haiku), <code>doc-writer</code> (Sonnet). Skills and agents use the right model for each task — Haiku for reading, Sonnet for generation.</p>
    </div>

    <div class="category-card">
      <span class="category-icon">🔗</span>
      <h3>Publishing House Integration</h3>
      <p><code>verify-content</code> and <code>create-lab</code> support headless <code>ph_payload</code> mode. PH passes a JSON spec — the skill runs all agents silently and returns structured JSON. Zero changes to PH required.</p>
    </div>

    <div class="category-card">
      <span class="category-icon">🔒</span>
      <h3>Security Checks — Field-Validated</h3>
      <p>Two new validator checks based on real production issues: multiuser htpasswd labs with shared passwords, and VS Code workloads with no authentication. Both flag as High — blocking for lab readiness.</p>
    </div>

    <div class="category-card">
      <span class="category-icon">✍️</span>
      <h3>Personal Writing Style</h3>
      <p>Describe your writing style, paste example paragraphs, or save a profile to <code>~/.claude/context/my-writing-style.md</code>. All content creation skills apply your style and run an auto-humanizer pass — no AI writing patterns in the output.</p>
    </div>

    <div class="category-card">
      <span class="category-icon">📐</span>
      <h3>babylon.yaml Schema Authority</h3>
      <p>The agnosticv validator now reads <code>$agv_path/.schemas/babylon.yaml</code> as the authoritative source before running checks. Category enums, field types, and <code>additionalProperties: false</code> enforcement all derived from the real schema — no more invented rules.</p>
    </div>
  </div>
</div>

<div class="section">
  <div class="section-header">
    <h2>Resources</h2>
  </div>

  <div class="category-grid">
    <div class="category-card category-card-highlight">
      <span class="category-icon">💡</span>
      <h3>Best Practices</h3>
      <p>Context management, CLAUDE.md setup, git rules, and real pitfalls from daily RHDP work.</p>
      <a href="{{ '/reference/best-practices.html' | relative_url }}" class="category-cta">Read before you start →</a>
    </div>

    <div class="category-card">
      <span class="category-icon">⚡</span>
      <h3>Quick Reference</h3>
      <p>All install commands, skill commands, and common workflows in one place.</p>
      <a href="{{ '/reference/quick-reference.html' | relative_url }}">Open quick reference →</a>
    </div>

    <div class="category-card">
      <span class="category-icon">🔧</span>
      <h3>Troubleshooting</h3>
      <p>Skills not showing, plugin errors, common fixes.</p>
      <a href="{{ '/reference/troubleshooting.html' | relative_url }}">Fix common issues →</a>
    </div>

    <div class="category-card">
      <span class="category-icon">🛠️</span>
      <h3>Build Your Own Skill</h3>
      <p>Have a repetitive workflow? Turn it into a reusable Claude Code skill. Walkthrough guides for different roles.</p>
      <a href="{{ '/contributing/create-your-own-skill.html' | relative_url }}">Start building →</a><br>
      <a href="{{ '/reference/skills-vs-agents.html' | relative_url }}" style="font-size:0.8125rem; color: var(--color-text-3);">Skills vs Agents explainer →</a>
    </div>

    <div class="category-card">
      <span class="category-icon">🏗️</span>
      <h3>Agent Architecture</h3>
      <p>How skills and agents work together — orchestration diagrams, model assignments, agent communication patterns.</p>
      <a href="{{ '/reference/agent-architecture.html' | relative_url }}">See the architecture →</a>
    </div>

    <div class="category-card">
      <span class="category-icon">🔗</span>
      <h3>Publishing House Integration</h3>
      <p>Sequence diagrams showing agent communication in interactive vs headless mode. ph_payload schema and JSON response format for all supported skills.</p>
      <a href="{{ '/reference/ph-integration.html' | relative_url }}">Integration guide →</a>
    </div>

    <div class="category-card">
      <span class="category-icon">✍️</span>
      <h3>Personal Writing Style</h3>
      <p>Save your writing style profile once and all content creation skills use it automatically. Full guide with examples.</p>
      <a href="{{ '/reference/writing-style.html' | relative_url }}">Set up your style →</a>
    </div>
  </div>
</div>
