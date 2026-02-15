---
layout: default
title: Claude Code Best Practices for RHDP
---

# Claude Code Best Practices for RHDP

<div class="reference-badge">The complete guide to working effectively with Claude Code</div>

<div class="callout callout-info">
<strong>Who this is for:</strong> RHDP developers who use Claude Code daily across AgnosticV, AgnosticD, and Showroom repos. Whether you're creating catalog items, writing workshop content, or building validation roles, this page covers how to configure Claude Code for maximum effectiveness.
</div>

---

## How Claude Code Memory Works {#memory}

Claude Code uses a layered memory system. Understanding it is the difference between Claude knowing your project conventions and Claude guessing wrong every time.

### CLAUDE.md File Hierarchy

Claude reads `CLAUDE.md` files at multiple levels. Files closer to your working directory take priority:

```text
~/CLAUDE.md                          # Global -- applies to ALL projects
~/work/code/agnosticv/CLAUDE.md      # Project -- applies to this repo
~/work/code/agnosticv/.claude/rules/  # Auto-loaded rules (always active)
```

When you run `claude` inside `~/work/code/agnosticv/`, Claude loads **all three levels** automatically. You don't need to reference them -- they're injected into every conversation.

<div class="callout callout-tip">
<strong>Tip:</strong> Put universal rules (git commit style, no AI attribution) in <code>~/CLAUDE.md</code>. Put repo-specific rules (file structure, AsciiDoc vs Markdown, naming conventions) in each repo's <code>CLAUDE.md</code>.
</div>

### What Goes in Each Level

**Global `~/CLAUDE.md`** -- rules that apply everywhere:

```markdown
## Git Rules
- No AI attribution in commit messages
- No feature/ prefix on branches
- Branch from main, short descriptive names

## Style
- Direct, practical tone
- No corporate language
```

**Project `CLAUDE.md`** -- repo-specific conventions:

```markdown
## AgnosticV Repository
- Catalog items live in agd_v2/<category>/<name>/
- Key files: common.yaml, dev.yaml, description.adoc
- Always validate with yamllint before committing
- PR directly to main
```

**`.claude/rules/` directory** -- granular rules that auto-load:

```text
.claude/rules/
  git-conventions.md     # Branch naming, commit format
  yaml-standards.md      # YAML formatting rules
  naming-conventions.md  # Variable and file naming
```

Each `.md` file in `.claude/rules/` is loaded automatically. Use this for rules that should always be active without cluttering the main `CLAUDE.md`.

### Template Interpolation

CLAUDE.md supports {% raw %}`{{path}}`{% endraw %} syntax to include content from other files:

{% raw %}
```markdown
# My Project CLAUDE.md

{{~/claude/agnosticd-context}}
{{~/claude/litemaas.md}}
```
{% endraw %}

This pulls in shared context files without duplicating content across repos.

### The /memory Command

Type `/memory` in a Claude Code session to view and edit what Claude remembers about the current project. Claude stores learned preferences here -- things like "this user prefers yamllint over manual checking" or "always use oc instead of kubectl in this repo."

```text
> /memory
```

This opens your project memory file for direct editing. Add rules here that you want Claude to remember across sessions.

---

## Choosing and Switching Models {#models}

Claude Code supports three model tiers. The right model depends on what you're doing.

### Available Models

<div style="overflow-x: auto;">

| Model | Best For | Cost |
|---|---|---|
| **Sonnet** (default) | Daily work -- editing files, running commands, writing code, using skills | Lower |
| **Opus** | Complex architecture, multi-file refactoring, nuanced content generation | Higher |
| **Haiku** | Quick lookups, simple questions, fast responses | Lowest |

</div>

### How to Switch Models

**For the current session:**

```text
> /model
```

This opens an interactive picker. Select the model you want.

**When starting Claude:**

```bash
claude --model opus
```

**Set a default model permanently:**

```bash
claude /config
```

Navigate to the model setting and change it. This persists across sessions.

<div class="callout callout-tip">
<strong>Tip:</strong> Use Sonnet for everyday RHDP work (catalog items, showroom modules, validation roles). Switch to Opus when you need Claude to understand complex relationships across multiple files -- like building a new AgnosticD role that inherits from core_workload while generating matching AgnosticV catalog configs.
</div>

---

## Context Management {#context}

Every Claude Code session has a context window -- a limit on how much information Claude can hold at once. Managing it well prevents Claude from "forgetting" your conventions mid-task.

### Check Your Context Usage

```text
> /context
```

This shows how much of the context window is in use. When it gets above 70-80%, Claude may start losing details from earlier in the conversation.

### Clear Context Between Tasks

```text
> /clear
```

Use `/clear` when switching between unrelated tasks. If you just finished an AgnosticV catalog item and now need to write Showroom content, clear first. Otherwise Claude carries over YAML patterns into your AsciiDoc files.

### Compact Without Losing Everything

```text
> /compact Keep the role naming conventions, delegate_to patterns,
> and the validation task structure from core_workload
```

`/compact` summarizes the conversation to free up space while preserving what you specify. Use it when you're deep in a long session and don't want to start over.

<div class="callout callout-warning">
<strong>Auto-compact happens automatically</strong> when context reaches ~95%. When this fires, Claude summarizes everything -- and summaries lose detail. To avoid surprises, compact proactively with focus instructions before auto-compact triggers.
</div>

### What to Preserve During Compaction

When compacting during a Showroom session:

```text
> /compact Keep the AsciiDoc patterns from module-01.adoc,
> the %user% variable format, the [NOTE]/[IMPORTANT] callout style,
> and the verification step pattern. I still need modules 4 and 5.
```

When compacting during an AgnosticD session:

```text
> /compact Keep the role naming conventions, delegate_to: bastion pattern,
> core_workload inheritance, and the validation task structure
```

---

## Session Management {#sessions}

### Name Your Sessions

Always name your session when starting real work:

```text
> /rename agd-aap-validation-role
```

### Resume After Interruptions

Claude saves every session locally. If your laptop restarts, VPN drops, or you close the terminal:

```bash
# Resume the most recent session in this directory
claude --continue

# Pick from a list of recent sessions
claude --resume

# Resume a specific named session
claude --resume agd-aap-validation-role
```

The full conversation history, tool outputs, and file states are all restored. Claude picks up exactly where it left off.

### Multiple Sessions for Multiple Repos

When working across repos, run separate Claude sessions:

```bash
# Terminal 1 -- AgnosticD
cd ~/work/code/agnosticd && claude

# Terminal 2 -- AgnosticV
cd ~/work/code/agnosticv && claude

# Terminal 3 -- Showroom
cd ~/work/showroom-content/my-workshop/ && claude
```

Each session has its own context. No bleed-over between repos.

---

## Plan Mode {#plan-mode}

Plan mode lets Claude explore and design before writing code. It's read-only -- Claude can read files and search, but can't modify anything until you approve the plan.

### How to Enter Plan Mode

**Cycle modes with the keyboard:**

Press `Shift+Tab` to cycle: **Normal** > **Auto-Accept** > **Plan**

**Or ask Claude directly:**

```text
> Plan how to add a new validation role for AAP health checks
```

### When to Use Plan Mode

- Building a new AgnosticD role from scratch
- Creating a multi-module Showroom workshop
- Refactoring an existing catalog item structure
- Any task where you want Claude to understand the codebase before making changes

### Edit Plans in Your Editor

Press `Ctrl+G` to open the current plan in your default editor (vim, VS Code, etc.) for direct editing.

---

## Keyboard Shortcuts {#shortcuts}

<div style="overflow-x: auto;">

| Shortcut | Action |
|---|---|
| `Esc` | Stop Claude mid-action |
| `Esc` `Esc` | Rewind / checkpoint menu |
| `Shift+Tab` | Cycle modes: Normal > Auto-Accept > Plan |
| `Ctrl+G` | Open plan in your editor |
| `Ctrl+O` | Toggle verbose mode (see Claude's reasoning) |
| `Option+T` / `Alt+T` | Toggle extended thinking on/off |
| `Ctrl+B` | Background a running task |

</div>

---

## All Slash Commands {#commands}

<div style="overflow-x: auto;">

| Command | What It Does |
|---|---|
| `/clear` | Wipe conversation history -- start fresh |
| `/compact` | Summarize conversation to free context space |
| `/model` | Switch between Sonnet, Opus, Haiku |
| `/rename` | Name the current session for later resume |
| `/resume` | Pick from previous sessions to continue |
| `/rewind` | Undo Claude's last changes (code + conversation) |
| `/init` | Generate a CLAUDE.md for the current repo |
| `/memory` | View/edit persistent project memory |
| `/cost` | Check token usage and cost (API users) |
| `/context` | See context window usage |
| `/config` | Open Claude Code settings |
| `/hooks` | Configure automated checks |
| `/help` | Show all available commands |

</div>

---

## Extended Thinking {#thinking}

Extended thinking gives Claude more time to reason through complex problems before responding. Toggle it with `Option+T` (Mac) or `Alt+T` (Linux).

Use extended thinking when:
- Debugging a multi-file issue where the root cause isn't obvious
- Writing complex Ansible logic with nested conditionals
- Designing a new AgnosticV catalog item structure with multiple workloads
- Claude keeps producing wrong output and you want it to reason more carefully

<div class="callout callout-info">
<strong>Note:</strong> Extended thinking uses more tokens and is slower. Don't leave it on for simple tasks like file edits or running commands.
</div>

---

## Hooks {#hooks}

Hooks run shell commands automatically before or after Claude performs actions. Use them to enforce standards without remembering to ask.

### Example: Auto-lint YAML After Every Edit

Add to `.claude/settings.json` in your AgnosticV repo:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "yamllint -d relaxed \"$TOOL_INPUT_FILE_PATH\" 2>&1 || true"
          }
        ]
      }
    ]
  }
}
```

Every time Claude edits or creates a file, `yamllint` runs automatically. Claude sees the lint output and fixes issues without you asking.

### Example: Block Destructive Git Commands

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "echo \"$TOOL_INPUT\" | grep -qE 'push --force|reset --hard|clean -f' && echo 'Blocked: destructive git command' >&2 && exit 2 || exit 0"
          }
        ]
      }
    ]
  }
}
```

---

## RHDP Skills Usage {#skills}

### Available Skills

<div style="overflow-x: auto;">

| Skill | What It Does | Use When |
|---|---|---|
| `/showroom:create-lab` | Generate a workshop module with AsciiDoc | Building hands-on lab content |
| `/showroom:create-demo` | Create a Know/Show demo module | Building presenter-led demos |
| `/showroom:verify-content` | Run quality checks on Showroom content | Before submitting a PR |
| `/showroom:blog-generate` | Convert workshop/demo into a blog post | Repurposing content |
| `/agnosticv:catalog-builder` | Create/update AgV catalog files | New catalog items or updates |
| `/agnosticv:validator` | Validate AgV catalog configs | Before submitting AgV PRs |
| `/health:deployment-validator` | Create Ansible validation roles | Building RHDP health checks |

</div>

### Getting Better Output from Skills

The most common complaint is that skills produce generic content. Here's how to fix that.

**Always provide a reference module:**

```text
> Read @content/modules/ROOT/pages/module-01.adoc for the style,
> tone, and AsciiDoc patterns. Now create module-02 following
> the exact same structure.
```

**Be specific about what you want:**

```text
# Bad -- produces generic content
> /showroom:create-lab

# Good -- Claude knows exactly what to generate
> /showroom:create-lab
> Workshop topic: Migrating VMs from VMware to OpenShift Virtualization
> This module covers the MTV operator. Target audience: infrastructure
> admins familiar with VMware but new to OpenShift.
> Reference: @content/modules/ROOT/pages/module-01.adoc
```

**For AgnosticV, know your mode:**

The catalog-builder skill offers 4 modes. Choose the right one:
1. **Full Catalog** -- new catalog item from scratch
2. **Common.yaml Only** -- updating deployment config
3. **Description.adoc Only** -- updating the RHDP listing page
4. **Info Message Only** -- updating the post-deployment info page

---

## Setting Up CLAUDE.md for Each Repo {#claude-md-setup}

### For AgnosticV

```markdown
## AgnosticV Repository

### Structure
- Catalogs: agd_v2/<category>/<name>/ (standard)
- Enterprise: enterprise/<category>/<name>/
- Key files: common.yaml, dev.yaml, description.adoc

### Rules
- Validate YAML with yamllint before committing
- Asset UUIDs must be unique (generate with uuidgen)
- Branch from main, PR to main
- No feature/ prefix on branches
- No AI attribution in commits

### Naming
- Catalog names: lowercase with hyphens
- Branch names: short, descriptive (e.g., update-aap-catalog)
```

### For Showroom Content

```markdown
## Showroom Workshop

### Content Format
- AsciiDoc (.adoc), NOT Markdown
- Files: content/modules/ROOT/pages/
- Navigation: content/modules/ROOT/nav.adoc
- Partials: content/modules/ROOT/partials/

### Writing Style
- Second person ("you will", not "we will")
- Direct and hands-on, not corporate
- Follow Say > Do > Explain pattern
- Use %user% for username substitution (not {user})

### AsciiDoc Patterns
- [source,bash] for commands
- [NOTE]/[IMPORTANT]/[WARNING] for callouts
- Every action needs a verification step
```

### For AgnosticD

```markdown
## AgnosticD v2 Repository

### Roles
- Path: roles/ocp4_workload_<name>/
- Inherit from core_workload patterns
- All oc/ansible commands: delegate_to: bastion
- Register results and check with assert

### Naming
- Roles: ocp4_workload_<descriptive_name>
- Variables: role_name_variable_name
- Tasks: descriptive, starts with verb
```

<div class="callout callout-tip">
<strong>Quick start:</strong> Run <code>/init</code> in any repo to have Claude generate a starter CLAUDE.md based on the repo's contents.
</div>

---

## End-to-End Workflows {#workflows}

### New Workshop from Scratch

When building a new workshop, the sequence and session isolation matter.

**Step 1: Create Showroom content** (Terminal 1)

```bash
cd ~/work/showroom-content/my-new-workshop-showroom && claude
```

```text
> /rename showroom-new-workshop
> /showroom:create-lab
```

Generate Module 1 with your reference materials. Then for Module 2+, always reference the previous module:

```text
> Read @content/modules/ROOT/pages/module-01.adoc for the style
> and patterns. Now create module-02 covering job templates.
```

**Step 2: Verify Showroom content** (same terminal)

```text
> /showroom:verify-content
```

Fix any issues before moving on.

**Step 3: Create AgV catalog item** (Terminal 2)

```bash
cd ~/work/code/agnosticv && claude
```

```text
> /rename agv-new-workshop
> /agnosticv:catalog-builder
```

Choose Mode 1 (Full Catalog). Point it to your new Showroom repo.

**Step 4: Validate and PR** (each terminal)

```text
# In AgnosticV terminal
> Run yamllint on common.yaml. Fix any issues. Commit and create PR.

# In Showroom terminal
> Commit all modules. Create PR.
```

<div class="callout callout-warning">
<strong>Key discipline:</strong> Finish each repo's work in its own session before moving to the next. Don't switch between repos in a single session -- that's where context bleed happens.
</div>

### Updating an Existing Catalog Item

```text
> Read @sandboxes-gpte/AAP_WORKSHOPS/aap-selfserv-intro/common.yaml
> The collection URL is wrong. Change it to
> https://github.com/rhpds/aap-selfserv-collection
> Run yamllint after the change.
```

Always read first, state the change, ask for validation. One prompt, one task.

---

## RHDP Power Tips {#tips}

These are things that aren't documented elsewhere but matter daily.

### AsciiDoc Copy-Paste Commands in Showroom

Claude consistently writes `[source,bash]` for commands. That's wrong for Showroom -- it loses the copy button and breaks variable substitution. The correct block syntax is:

```text
[source,bash,role=execute,subs=attributes+]
----
oc get pods -n %user%-project
----
```

Without `role=execute`, no copy button in the Showroom UI. Without `subs=attributes+`, `%user%` renders as literal text. Put this in your Showroom CLAUDE.md:

```markdown
## AsciiDoc Command Blocks
Always use: [source,bash,role=execute,subs=attributes+]
Never use: [source,bash] alone
```

### Always Check nav.adoc

Claude creates module files but often forgets to update `content/modules/ROOT/nav.adoc`, or updates it with the wrong path. The module exists but doesn't appear in navigation. After generating modules, always say:

```text
> Update nav.adoc to include module-04.adoc in the correct position
```

### Read Before Updating

Don't say "update the catalog item." Say:

```text
> Read @sandboxes-gpte/AAP_WORKSHOPS/aap-selfserv-intro/common.yaml
> and add a new collection entry for aap-selfserv-collection at
> version main.
```

Claude can't update what it hasn't read. Letting it guess the current state leads to overwrites and lost fields.

### Track Multi-Day Work in CLAUDE.md

If a project spans multiple sessions, add state to your repo's CLAUDE.md:

```markdown
## Current Work
- aap-selfserv workshop: modules 1-2 done and merged
- Modules 3-5 remaining
- Catalog item created but not yet tested
```

This survives across sessions and gives Claude instant context, even if you forget to `--resume`.

### The %user% Variable Drift

Showroom uses `%user%` for dynamic substitution. AsciiDoc natively uses `{attribute}` syntax. Claude drifts between them, especially after compaction. Add to your CLAUDE.md or compact instructions:

```text
Always use %user% for variable substitution, never {user}
```

---

## Common Pitfalls {#pitfalls}

### Context Bleed Between Tasks

**Problem:** You finish an AgV catalog item, then ask Claude to write Showroom content without clearing. Claude puts YAML structures inside AsciiDoc files.

**Fix:** One `/clear` between unrelated tasks.

```text
> /clear
> I'm working on the Showroom content for ocp-virt-admin.
> The repo is at ~/work/showroom-content/ocp-virt-admin-showroom/
> Create module 2 following the structure in module 1.
```

### Auto-Compact Loses Your Patterns

**Problem:** You're writing Module 4 of a workshop. Auto-compact fires. Suddenly Module 4 uses different heading levels, different admonition syntax, and `{user}` instead of `%user%`.

**Fix:** Compact proactively with focus instructions before auto-compact triggers.

```text
> /compact Keep the AsciiDoc patterns from module-01.adoc,
> the %user% variable format, and the [NOTE] callout style.
> I still need to write modules 4 and 5.
```

### Vague Prompts Burn Context

**Problem:** "Help me fix the catalog item" -- Claude reads 15 files trying to figure out which one. Half your context is gone before it does anything useful.

**Fix:** Be specific. Reference the file. Tell Claude what "fixed" looks like.

```text
> The common.yaml at sandboxes-gpte/AAP_WORKSHOPS/aap-selfserv-intro/
> has an incorrect collection repo URL. The URL should point to
> https://github.com/rhpds/aap-selfserv-collection. Fix it and
> run yamllint on the result.
```

### Correcting Claude Over and Over

**Problem:** Claude creates `feature/aap-update`. You say no prefix. Claude creates `fix/aap-update`. You say no prefix at all. Three corrections later, context is full of failed attempts.

**Fix:** After two corrections on the same issue, `/clear` and write a single prompt with all constraints.

```text
> /clear
> Create a branch called aap-catalog-update from main.
> Update the common.yaml to add the new collection entry.
> Run yamllint to validate.
> Commit with a clean message, NO AI attribution footer.
> Push and create a PR to main.
```

### Not Validating Claude's Output

**Problem:** Claude writes a `common.yaml` that looks right. You commit and push. CI fails because of a duplicate key or indentation error.

**Fix:** Tell Claude to validate after every change.

```text
> Update the common.yaml. After the change, run yamllint
> and fix any issues before committing.
```

For Showroom content:

```text
> /showroom:verify-content
```

---

## Plugin Management {#plugins}

### Install the RHDP Marketplace

```text
> /plugin marketplace add rhpds/rhdp-skills-marketplace
```

### Install Plugins

```text
> /plugin install showroom@rhdp-marketplace
> /plugin install agnosticv@rhdp-marketplace
> /plugin install health@rhdp-marketplace
```

### Update Plugins

```text
> /plugin marketplace update
> /plugin update showroom@rhdp-marketplace
```

### Check What's Installed

```text
> /plugin list
```

### Test from a Branch

To test unreleased changes from the `tech-preview` branch:

```text
> /install-plugin https://github.com/rhpds/rhdp-skills-marketplace#tech-preview
```

### Test Locally

For local development with a cloned copy of the marketplace:

```bash
claude --plugin-dir ~/work/code/rhdp-skills-marketplace/showroom
```

---

## Configuration Files {#config}

### Settings Locations

<div style="overflow-x: auto;">

| File | Scope | What Goes Here |
|---|---|---|
| `~/.claude/settings.json` | Global | Default model, allowed tools, global hooks |
| `.claude/settings.json` | Project | Project-specific hooks, permissions |
| `~/CLAUDE.md` | Global | Universal rules (git style, commit format) |
| `CLAUDE.md` | Project | Repo-specific conventions |
| `.claude/rules/*.md` | Project | Auto-loaded rules (always active in this repo) |

</div>

### Open Settings

```text
> /config
```

### Change Default Model

In `~/.claude/settings.json`:

```json
{
  "model": "claude-sonnet-4-20250514",
  "permissions": {
    "allow": ["Read", "Glob", "Grep"]
  }
}
```

Or use the CLI:

```bash
claude /config
```

---

## RHDP Git Rules {#git}

These apply across all RHDP repos:

<div style="overflow-x: auto;">

| Rule | Correct | Wrong |
|---|---|---|
| Branch from `main` | `git checkout -b aap-catalog-fix main` | `git checkout -b aap-catalog-fix dev` |
| Short descriptive names | `aap-catalog-fix` | `feature/aap-update` |
| No prefix | `showroom-module3` | `feature/showroom-module3` |
| No AI attribution | Clean commit message | `Co-Authored-By: Claude` footer |
| PR to `main` | `gh pr create --base main` | `gh pr create --base dev` |
| Lint first | `yamllint common.yaml` | Commit without linting |

</div>

---

## Further Reading {#links}

<div class="links-grid">
  <a href="https://docs.anthropic.com/en/docs/claude-code" target="_blank" class="link-card">
    <h4>Claude Code Documentation</h4>
    <p>Official docs from Anthropic</p>
  </a>
  <a href="../reference/quick-reference.html" class="link-card">
    <h4>Quick Reference</h4>
    <p>Commands and workflows at a glance</p>
  </a>
  <a href="../reference/troubleshooting.html" class="link-card">
    <h4>Troubleshooting</h4>
    <p>Fix common plugin and skill issues</p>
  </a>
  <a href="../setup/claude-code.html" class="link-card">
    <h4>Claude Code Setup</h4>
    <p>First-time installation guide</p>
  </a>
</div>

---

<div class="navigation-footer">
  <a href="../index.html" class="nav-button">Back to Home</a>
</div>

<style>
/* Page badge */
.reference-badge {
  display: inline-block;
  background: linear-gradient(135deg, #0969da 0%, #0550ae 100%);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  font-weight: 600;
  margin: 1rem 0;
}

/* Callout boxes */
.callout {
  padding: 1rem 1.25rem;
  margin: 1.5rem 0;
  border-radius: 6px;
  border-left: 4px solid;
}
.callout-warning {
  background: linear-gradient(135deg, #fff3cd 0%, #fff8e1 100%);
  border-left-color: #ffc107;
}
.callout-tip {
  background: linear-gradient(135deg, #d4edda 0%, #f0fff4 100%);
  border-left-color: #28a745;
}
.callout-info {
  background: linear-gradient(135deg, #e7f3ff 0%, #f0f7ff 100%);
  border-left-color: #0969da;
}
.callout-danger {
  background: linear-gradient(135deg, #f8d7da 0%, #fff5f5 100%);
  border-left-color: #dc3545;
}

/* Tables */
table {
  border-collapse: collapse;
  width: 100%;
  margin: 1.5em 0;
}
table th {
  background-color: #f6f8fa;
  border: 1px solid #e1e4e8;
  padding: 8px 12px;
  text-align: left;
  font-weight: 600;
}
table td {
  border: 1px solid #e1e4e8;
  padding: 8px 12px;
}
table tr:nth-child(even) {
  background-color: #f6f8fa;
}

/* Collapsible sections */
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
  color: #EE0000;
}
details[open] {
  padding-bottom: 1rem;
}
details[open] summary {
  margin-bottom: 1rem;
  padding-bottom: 0.5rem;
  border-bottom: 1px solid #e1e4e8;
}

/* Links grid */
.links-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin: 2rem 0;
}
.link-card {
  display: block;
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
  text-decoration: none;
  color: inherit;
  transition: all 0.2s ease;
}
.link-card:hover {
  border-color: #EE0000;
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
}
.link-card h4 {
  margin: 0 0 0.5rem 0;
  color: #24292e;
}
.link-card p {
  margin: 0;
  color: #586069;
  font-size: 0.875rem;
}

/* Navigation footer */
.navigation-footer {
  display: flex;
  justify-content: center;
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
  border-color: #EE0000;
  color: #EE0000;
  transform: translateY(-2px);
}
</style>
