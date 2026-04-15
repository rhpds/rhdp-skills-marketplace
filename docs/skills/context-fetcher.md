---
layout: default
title: /aiops-skill:context-fetcher
---

# /aiops-skill:context-fetcher

<div class="reference-badge">🗂️ Context Retrieval</div>

Retrieve configuration files, runbooks, and relevant messages from GitHub, Confluence, and Slack to support job investigation and incident analysis — using MCP server integrations.

---

## When to Use

<div class="callout callout-tip">
<span class="callout-icon">💡</span>
<div class="callout-body">
<strong>Invoke this skill when you want to:</strong>
<ul>
<li>Find the configuration files for a job or service before or during investigation</li>
<li>Retrieve runbooks or troubleshooting guides from Confluence</li>
<li>Review recent code changes related to a failure</li>
<li>Search Slack for team discussions about a specific job or incident</li>
<li>Gather documentation context before running root cause analysis</li>
</ul>
</div>
</div>

**Example invocations:**

```
"Get context for job OCP-Workload-1234567"
"Find the configuration files for the ocp-workload-example catalog item"
"Search for runbooks related to namespace provisioning failures"
"Look up Slack messages about the recent OCP deployment issues"
```

---

## Prerequisites

<div class="category-grid">
<div class="category-card">
<span class="category-icon">🐙</span>
<h3>GitHub MCP Server <span class="reference-badge">Required for GitHub</span></h3>
<p>Configure the <code>github</code> MCP server in your Claude Code settings. Enables <code>mcp__github__search_code</code> and <code>mcp__github__get_file_contents</code>.</p>
</div>
<div class="category-card">
<span class="category-icon">📄</span>
<h3>Confluence MCP Server</h3>
<p>Configure the <code>confluence</code> MCP server for access to runbooks, architecture docs, and incident reports. Enables <code>mcp__atlassian__confluence_search</code> and <code>mcp__atlassian__confluence_get_page</code>.</p>
</div>
<div class="category-card">
<span class="category-icon">💬</span>
<h3>Slack MCP Server</h3>
<p>Configure the <code>Slack</code> MCP server to search channel history for messages and replies related to the investigation topic.</p>
</div>
</div>

<div class="callout callout-info">
<span class="callout-icon">ℹ️</span>
<div class="callout-body">
<strong>MCP server setup:</strong> Add server entries to your Claude Code settings file. After adding new MCP servers, restart Claude Code for them to become available. Check that <code>mcp__github__*</code> tools appear in your available tools list before invoking this skill.
</div>
</div>

---

## 6-Step Workflow

<ol class="steps">
<li>
<div class="step-content">
<h4>Identify Search Terms <code>[Claude]</code></h4>
<p>Extracts relevant keywords from the job name, service name, error messages, or incident details to use as search queries across all sources.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>Search GitHub <code>[MCP]</code></h4>
<p>Searches repositories for configuration files, source code, CI/CD definitions, and infrastructure-as-code. Uses <code>mcp__github__search_code</code> and <code>mcp__github__get_file_contents</code>.</p>

```
# Example search strategies
path:config/*.yaml "job-name"
extension:yaml "catalog-item-name"
repo:org/agnosticv "workload-name"
```

</div>
</li>
<li>
<div class="step-content">
<h4>Search Confluence <code>[MCP]</code></h4>
<p>Finds runbooks, architecture docs, configuration guides, and incident reports using <code>mcp__atlassian__confluence_search</code>. Supports CQL queries for advanced filtering.</p>

```
# Example CQL queries
space = "Operations" AND text ~ "job-name"
label:runbook AND title ~ "namespace-provisioning"
```

</div>
</li>
<li>
<div class="step-content">
<h4>Search Slack <code>[MCP]</code></h4>
<p>Retrieves channel history and replies using <code>mcp__slack__slack_get_channel_history</code> to find team discussions, incident updates, and documentation links relevant to the investigation.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>Synthesize Findings <code>[Claude]</code></h4>
<p>Organizes all results by source (GitHub, Confluence, Slack) with relevance ratings, file paths, page links, and key excerpts to give a structured investigation brief.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>Capture Feedback <code>[Claude]</code></h4>
<p>Calls the feedback-capture skill to record the user's experience with the investigation. This happens automatically at the end of every context-fetcher invocation.</p>
</div>
</li>
</ol>

---

## GitHub Search Capabilities

The skill searches GitHub for:

- **Configuration files** — YAML, JSON, TOML (e.g., `config.yaml`, `values.yaml`, `deployment.yaml`)
- **Source code** — Role tasks, playbooks, Helm templates referenced by the job
- **Documentation** — README files, docs directories, markdown files
- **CI/CD definitions** — GitHub Actions workflows, Jenkinsfiles
- **Infrastructure as Code** — Terraform, Ansible, Helm charts

**Search strategies:**

| Strategy | Example |
|---|---|
| By file path pattern | `path:config/*.yaml "catalog-item"` |
| By content keywords | `"job-name" AND "config"` |
| By file extension | `extension:yaml "workload"` |
| In specific repository | `repo:org/agnosticv "search-term"` |

---

## Confluence Search Capabilities

The skill retrieves from Confluence:

- **Runbooks** — Operational procedures and troubleshooting guides
- **Architecture documentation** — System designs and component interactions
- **Configuration guides** — Setup and configuration instructions
- **Incident reports** — Historical incidents and resolutions
- **Knowledge base articles** — Best practices and common issues

**Search strategies:**

| Strategy | Example |
|---|---|
| By space filter | `space = "Operations"` |
| By label | `label:runbook`, `label:troubleshooting` |
| By content | `text ~ "namespace-provisioning"` |
| CQL advanced | `space = "Eng" AND text ~ "job-name"` |

---

## Configuration

MCP servers are configured in `.claude/settings.json` or the global Claude Code settings:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "<your-token>" }
    },
    "confluence": { },
    "Slack": { }
  }
}
```

After adding MCP servers, restart Claude Code to activate them.

---

<div class="navigation-footer">
  <a href="{{ '/index.html' | relative_url }}" class="nav-button">← Back to Skills</a>
  <a href="{{ '/skills/feedback-capture.html' | relative_url }}" class="nav-button">Next: Feedback Capture →</a>
</div>
