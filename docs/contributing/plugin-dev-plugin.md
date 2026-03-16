---
layout: default
title: Plugin Developer Toolkit
---

# Plugin Developer Toolkit

<div class="reference-badge">Anthropic Official · plugin-dev</div>

<div class="callout callout-info">
<span class="callout-icon">🔌</span>
<div class="callout-body">
<strong>What this is:</strong> An official Anthropic plugin that helps you build Claude Code plugins and skills. It ships 7 specialist skills covering every part of the plugin development workflow — with 21,000+ words of embedded documentation and 12+ working examples.
</div>
</div>

---

## Install It

```text
/plugin install plugin-dev@claude-plugins-official
```

That's it. You now have 7 new skills available under the `/plugin-dev:` namespace.

---

## The 7 Skills

<div class="category-grid">
<div class="category-card">
<span class="category-icon">🪝</span>
<h3>Hook Development</h3>
<p>All 9 hook event types: PreToolUse, PostToolUse, Stop, SubagentStop, SessionStart, SessionEnd, UserPromptSubmit, PreCompact, Notification.</p>
<p style="font-size:0.8125rem;color:var(--color-text-3);">Use: <code>/plugin-dev:hook-development</code></p>
</div>

<div class="category-card">
<span class="category-icon">🔗</span>
<h3>MCP Server Integration</h3>
<p>Connect external services via Model Context Protocol — stdio, SSE, HTTP, WebSocket protocols all covered.</p>
<p style="font-size:0.8125rem;color:var(--color-text-3);">Use: <code>/plugin-dev:mcp-integration</code></p>
</div>

<div class="category-card">
<span class="category-icon">🏗️</span>
<h3>Plugin Structure &amp; Settings</h3>
<p>Directory layout, plugin.json manifest, settings configuration, <code>.local.md</code> patterns for user-configurable plugins.</p>
<p style="font-size:0.8125rem;color:var(--color-text-3);">Use: <code>/plugin-dev:plugin-structure</code></p>
</div>

<div class="category-card">
<span class="category-icon">⌨️</span>
<h3>Slash Command Creation</h3>
<p>Custom <code>/commands</code>, YAML frontmatter fields, dynamic arguments, bash execution, interactive user prompts.</p>
<p style="font-size:0.8125rem;color:var(--color-text-3);">Use: <code>/plugin-dev:command-development</code></p>
</div>

<div class="category-card">
<span class="category-icon">🤖</span>
<h3>Agent Development</h3>
<p>Creating autonomous subagents: system prompts, tools configuration, triggering conditions, isolation modes.</p>
<p style="font-size:0.8125rem;color:var(--color-text-3);">Use: <code>/plugin-dev:agent-development</code></p>
</div>

<div class="category-card">
<span class="category-icon">📋</span>
<h3>Skill Authoring</h3>
<p>Writing effective SKILL.md files: frontmatter options, context modes, model selection, progressive disclosure patterns.</p>
<p style="font-size:0.8125rem;color:var(--color-text-3);">Use: <code>/plugin-dev:skill-development</code></p>
</div>

<div class="category-card">
<span class="category-icon">✅</span>
<h3>Plugin Validation</h3>
<p>Validate your plugin before publishing: structure checks, frontmatter validation, hook testing, marketplace readiness.</p>
<p style="font-size:0.8125rem;color:var(--color-text-3);">Use: <code>/plugin-dev:plugin-validator</code></p>
</div>
</div>

---

## Guided Creation: 8 Phases

The fastest way to build a new plugin is the guided workflow:

```text
> /plugin-dev:create-plugin
```

This launches an 8-phase creation process:

<ol class="steps">
<li>
<div class="step-content">
<h4>Discovery</h4>
<p>Claude interviews you about the workflow you want to automate. What do you do manually today? What are the inputs and outputs?</p>
</div>
</li>
<li>
<div class="step-content">
<h4>Planning</h4>
<p>Claude designs the plugin architecture: which components you need (skills, agents, hooks, MCP), how they connect.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>Design</h4>
<p>Claude drafts the skill/agent system prompts and hook logic. You review and adjust before any files are created.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>Implementation</h4>
<p>Claude generates all plugin files: directory structure, <code>plugin.json</code>, <code>SKILL.md</code> files, agent definitions, hook config.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>Validation</h4>
<p>Claude validates the structure against plugin spec — catches missing fields, incorrect frontmatter, broken references.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>Testing</h4>
<p>Claude generates test scenarios and walks you through local testing with <code>claude --plugin-dir ./your-plugin</code>.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>Documentation</h4>
<p>Claude generates a README with install instructions, usage guide, and contribution notes.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>Publishing</h4>
<p>Claude prepares the plugin for marketplace submission or team distribution.</p>
</div>
</li>
</ol>

---

## Ask Questions Naturally

You don't have to use the guided flow. Just ask questions and the right skill auto-loads:

```text
> How do I create a PreToolUse hook that blocks edits to production files?
```

Claude loads the hook-development skill and gives you a working implementation.

```text
> What's the difference between context: main and context: fork in a SKILL.md?
```

Claude loads the skill-development skill and explains the fork isolation mode.

```text
> I want my plugin to connect to a Jira instance. What's the best approach?
```

Claude loads the MCP integration skill and walks you through the Jira MCP server setup.

---

## Use It to Build RHDP Skills

The plugin-dev toolkit is how you'd build new RHDP marketplace skills. Here's the connection:

<div class="callout callout-tip">
<span class="callout-icon">✅</span>
<div class="callout-body">
<strong>Building a sales skill?</strong> Use the <a href="{{ '/contributing/for-sales.html' | relative_url }}">Sales Skill Walkthrough</a> to understand the workflow, then use <code>/plugin-dev:skill-development</code> to generate the SKILL.md. The toolkit knows the RHDP SKILL.md format.
</div>
</div>

<div class="callout callout-tip">
<span class="callout-icon">✅</span>
<div class="callout-body">
<strong>Building a frontend agent?</strong> Use the <a href="{{ '/contributing/for-developers.html' | relative_url }}">Frontend Agent Guide</a> to design your agent, then use <code>/plugin-dev:agent-development</code> and <code>/plugin-dev:hook-development</code> to generate the files.
</div>
</div>

---

## Validate Before Publishing

Before submitting a skill to the RHDP marketplace or sharing with your team:

```text
> /plugin-dev:plugin-validator
```

This checks:

- `plugin.json` has all required fields (name, version, description, author)
- All referenced files exist
- SKILL.md frontmatter is valid
- Agent definitions have required sections (Role, Instructions)
- Hooks use correct event names and exit codes
- No secrets or credentials in any files

---

## Local Testing Workflow

```bash
# Test your plugin locally (without installing to marketplace)
claude --plugin-dir ./my-plugin

# Test multiple plugins together
claude --plugin-dir ./my-plugin --plugin-dir ./another-plugin

# Reload without restarting
> /reload-plugins
```

When a local `--plugin-dir` plugin has the same name as an installed marketplace plugin, the local copy takes precedence for that session — useful for testing updates.

---

## Further Reading

<div class="links-grid">
  <a href="{{ '/contributing/create-your-own-skill.html' | relative_url }}" class="link-card">
    <h4>Create Your Own Skill</h4>
    <p>5-phase RHDP-specific skill guide</p>
  </a>
  <a href="{{ '/contributing/for-sales.html' | relative_url }}" class="link-card">
    <h4>Sales Skill Walkthrough</h4>
    <p>End-to-end example with real content</p>
  </a>
  <a href="{{ '/contributing/for-developers.html' | relative_url }}" class="link-card">
    <h4>Frontend Agent Guide</h4>
    <p>Build an agent with hooks</p>
  </a>
  <a href="{{ '/reference/skills-vs-agents.html' | relative_url }}" class="link-card">
    <h4>Skills vs Agents</h4>
    <p>When to use each</p>
  </a>
</div>

<div class="navigation-footer">
  <a href="{{ '/contributing/for-developers.html' | relative_url }}" class="nav-button">← Frontend Agent Guide</a>
  <a href="{{ '/contributing/create-your-own-skill.html' | relative_url }}" class="nav-button">Create a Skill →</a>
</div>
