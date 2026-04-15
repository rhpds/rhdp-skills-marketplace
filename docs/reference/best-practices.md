---
layout: default
title: Claude Code Best Practices for RHDP
---

# Claude Code Best Practices for RHDP

<div class="reference-badge">The complete guide to working effectively with Claude Code</div>

<div class="callout callout-info"><span class="callout-icon">ℹ️</span><div class="callout-body"><strong>Who this is for:</strong> RHDP developers who use Claude Code daily across AgnosticV, AgnosticD, and Showroom repos. Whether you're creating catalog items, writing workshop content, or building validation roles, this page covers how to configure Claude Code for maximum effectiveness.</div></div>

---

## Managing Your CLAUDE.md {#memory}

CLAUDE.md is Claude's persistent memory. Unlike a chat prompt, it loads automatically on every session — no need to re-explain your conventions. But it only works if it's kept lean and precise.

### The File Hierarchy

Three layers load on every session, additively:

```text
~/CLAUDE.md                           # Global — applies to ALL repos, ALL sessions
~/work/code/agnosticv/CLAUDE.md       # Project — applies to this repo only
~/work/code/agnosticv/.claude/rules/  # Rules — always active, modular
```

**Global `~/CLAUDE.md`** — rules that never change regardless of repo:
- Git commit style (no feature/ prefix)
- Personal writing tone and style preferences
- Persistent workflows with trigger phrases (see Work Log example below)

**Project `CLAUDE.md`** — checked into git, repo-specific:
- Directory structure and key file paths
- Validation commands (`yamllint`, `ansible-lint`)
- Naming conventions for this codebase

**`.claude/rules/` directory** — modular, auto-load every session:

```text
.claude/rules/
  git-conventions.md     # Branch naming, commit format
  yaml-standards.md      # YAML formatting rules
  naming-conventions.md  # Variable and file naming
```

Rules files let you split concerns without one giant CLAUDE.md. Each file loads automatically — no configuration needed.

### What to Include vs Exclude

**Include:**
- Commands Claude can't guess (`yamllint -d relaxed`, `bun test`)
- Rules that differ from standard defaults (AsciiDoc vs Markdown, `%user%` not `{user}`)
- Repo etiquette (branch naming, no feature/ prefix, PR to main)
- Architectural decisions not obvious from the code

**Exclude:**
- Anything Claude can figure out by reading the codebase
- Standard language conventions Claude already knows
- Long tutorials or explanations — put them in a file and `@`-import it
- Frequently changing information

<div class="callout callout-warning">
<span class="callout-icon">⚠️</span>
<div class="callout-body">
<strong>Keep it under 200 lines.</strong> A bloated CLAUDE.md causes Claude to miss rules buried deep in it. If Claude keeps ignoring a rule that's in the file, the file is too long. Prune it — remove anything Claude already knows.
</div>
</div>

### RHDP Repo Examples

**AgnosticV `CLAUDE.md`:**

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

### Naming
- Catalog names: lowercase with hyphens
- Branch names: short, descriptive (e.g., update-aap-catalog)
```

**Showroom `CLAUDE.md`:**

```markdown
## Showroom Workshop

### Content Format
- AsciiDoc (.adoc), NOT Markdown
- Files: content/modules/ROOT/pages/
- Navigation: content/modules/ROOT/nav.adoc

### Writing Style
- Second person ("you will", not "we will")
- Use %user% for username substitution (never {user})

### AsciiDoc Patterns
- [source,bash,role=execute,subs=attributes+] for commands (not [source,bash] alone)
- [NOTE]/[IMPORTANT]/[WARNING] for callouts
- Every action needs a verification step
```

**AgnosticD `CLAUDE.md`:**

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
```

### @-Imports for Shared Context

CLAUDE.md supports `{{path}}` syntax to pull in other files without duplicating them:

{% raw %}
```markdown
{{~/claude/agnosticd-context}}
{{~/claude/litemaas.md}}
```
{% endraw %}

Use this for large reference documents that multiple repos need — keep CLAUDE.md short and import the detail on demand.

### Real Example: Work Log

A good global rule defines a **trigger phrase**, an **exact format**, and **where to write output**. The work log pattern does all three:

```markdown
## Work Log

Maintain a running log in ~/work-log/ for quarterly reviews.
One file per quarter: 2026-Q1.md, 2026-Q2.md, etc.

When the user says "log this" or "write log":
1. Determine the current quarter from today's date
2. Open (or create) ~/work-log/YYYY-QN.md
3. Find the Monday of the current week for the section header
4. If a "## Week of YYYY-MM-DD" section exists, append bullets under it
5. If not, add a new section at the TOP of the file (most recent first)
6. Write concise, action-oriented bullets

Format:
## Week of 2026-02-10
- Built validation role for AAP2 catalog item
- Fixed Showroom module 3 AsciiDoc formatting
```

This belongs in `~/CLAUDE.md` because it applies across every repo and every session. The trigger phrase means Claude acts on it without you having to remember — just say "log this" at the end of any session.

### Staying Current

- **`/init`** — run in any repo to generate a starter CLAUDE.md from the actual codebase, then prune
- **`/memory`** — view and edit what Claude has learned about the current project; add rules you want persisted
- **Review quarterly** — remove stale rules, update paths, trim anything Claude already infers on its own

---

## Choosing and Switching Models {#models}

Claude Code supports three model tiers. The right model depends on what you're doing.

### Available Models

<table>
<thead><tr><th>Model</th><th>Best For</th><th>Cost</th></tr></thead>
<tbody>
<tr><td><strong>Sonnet</strong> (default)</td><td>Daily work — editing files, running commands, writing code, using skills</td><td>Lower</td></tr>
<tr><td><strong>Opus</strong></td><td>Complex architecture, multi-file refactoring, nuanced content generation</td><td>Higher</td></tr>
<tr><td><strong>Haiku</strong></td><td>Quick lookups, simple questions, fast responses</td><td>Lowest</td></tr>
</tbody>
</table>

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

<div class="callout callout-tip"><span class="callout-icon">✅</span><div class="callout-body"><strong>Tip:</strong> Use Sonnet for everyday RHDP work (catalog items, showroom modules, validation roles). Switch to Opus when you need Claude to understand complex relationships across multiple files -- like building a new AgnosticD role that inherits from core_workload while generating matching AgnosticV catalog configs.</div></div>

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

<div class="callout callout-warning"><span class="callout-icon">⚠️</span><div class="callout-body"><strong>Auto-compact happens automatically</strong> when context reaches ~95%. When this fires, Claude summarizes everything -- and summaries lose detail. To avoid surprises, compact proactively with focus instructions before auto-compact triggers.</div></div>

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

<table>
<thead><tr><th>Shortcut</th><th>Action</th></tr></thead>
<tbody>
<tr><td><code>Esc</code></td><td>Stop Claude mid-action</td></tr>
<tr><td><code>Esc</code> <code>Esc</code></td><td>Rewind / checkpoint menu</td></tr>
<tr><td><code>Shift+Tab</code></td><td>Cycle modes: Normal &gt; Auto-Accept &gt; Plan</td></tr>
<tr><td><code>Ctrl+G</code></td><td>Open plan in your editor</td></tr>
<tr><td><code>Ctrl+O</code></td><td>Toggle verbose mode (see Claude's reasoning)</td></tr>
<tr><td><code>Option+T</code> / <code>Alt+T</code></td><td>Toggle extended thinking on/off</td></tr>
<tr><td><code>Ctrl+B</code></td><td>Background a running task</td></tr>
</tbody>
</table>

---

## All Slash Commands {#commands}

<table>
<thead><tr><th>Command</th><th>What It Does</th></tr></thead>
<tbody>
<tr><td><code>/clear</code></td><td>Wipe conversation history — start fresh</td></tr>
<tr><td><code>/compact</code></td><td>Summarize conversation to free context space</td></tr>
<tr><td><code>/model</code></td><td>Switch between Sonnet, Opus, Haiku</td></tr>
<tr><td><code>/rename</code></td><td>Name the current session for later resume</td></tr>
<tr><td><code>/resume</code></td><td>Pick from previous sessions to continue</td></tr>
<tr><td><code>/rewind</code></td><td>Undo Claude's last changes (code + conversation)</td></tr>
<tr><td><code>/init</code></td><td>Generate a CLAUDE.md for the current repo</td></tr>
<tr><td><code>/memory</code></td><td>View/edit persistent project memory</td></tr>
<tr><td><code>/cost</code></td><td>Check token usage and cost (API users)</td></tr>
<tr><td><code>/context</code></td><td>See context window usage</td></tr>
<tr><td><code>/config</code></td><td>Open Claude Code settings</td></tr>
<tr><td><code>/hooks</code></td><td>Configure automated checks</td></tr>
<tr><td><code>/help</code></td><td>Show all available commands</td></tr>
</tbody>
</table>

</div>

---

## Extended Thinking {#thinking}

Extended thinking gives Claude more time to reason through complex problems before responding. Toggle it with `Option+T` (Mac) or `Alt+T` (Linux).

Use extended thinking when:
- Debugging a multi-file issue where the root cause isn't obvious
- Writing complex Ansible logic with nested conditionals
- Designing a new AgnosticV catalog item structure with multiple workloads
- Claude keeps producing wrong output and you want it to reason more carefully

<div class="callout callout-info"><span class="callout-icon">ℹ️</span><div class="callout-body"><strong>Note:</strong> Extended thinking uses more tokens and is slower. Don't leave it on for simple tasks like file edits or running commands.</div></div>

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

<table>
<thead><tr><th>Skill</th><th>What It Does</th><th>Use When</th></tr></thead>
<tbody>
<tr><td><code>/showroom:create-lab</code></td><td>Generate a workshop module with AsciiDoc</td><td>Building hands-on lab content</td></tr>
<tr><td><code>/showroom:create-demo</code></td><td>Create a Know/Show demo module</td><td>Building presenter-led demos</td></tr>
<tr><td><code>/showroom:verify-content</code></td><td>Run quality checks on Showroom content</td><td>Before submitting a PR</td></tr>
<tr><td><code>/showroom:blog-generate</code></td><td>Convert workshop/demo into a blog post</td><td>Repurposing content</td></tr>
<tr><td><code>/agnosticv:catalog-builder</code></td><td>Create/update AgV catalog files</td><td>New catalog items or updates</td></tr>
<tr><td><code>/agnosticv:validator</code></td><td>Validate AgV catalog configs</td><td>Before submitting AgV PRs</td></tr>
<tr><td><code>/health:deployment-validator</code></td><td>Create Ansible validation roles</td><td>Building RHDP health checks</td></tr>
</tbody>
</table>

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

<div class="callout callout-warning"><span class="callout-icon">⚠️</span><div class="callout-body"><strong>Key discipline:</strong> Finish each repo's work in its own session before moving to the next. Don't switch between repos in a single session -- that's where context bleed happens.</div></div>

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
> Commit with a clean message.
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

<table>
<thead><tr><th>File</th><th>Scope</th><th>What Goes Here</th></tr></thead>
<tbody>
<tr><td><code>~/.claude/settings.json</code></td><td>Global</td><td>Default model, allowed tools, global hooks</td></tr>
<tr><td><code>.claude/settings.json</code></td><td>Project</td><td>Project-specific hooks, permissions</td></tr>
<tr><td><code>~/CLAUDE.md</code></td><td>Global</td><td>Universal rules (git style, commit format)</td></tr>
<tr><td><code>CLAUDE.md</code></td><td>Project</td><td>Repo-specific conventions</td></tr>
<tr><td><code>.claude/rules/*.md</code></td><td>Project</td><td>Auto-loaded rules (always active in this repo)</td></tr>
</tbody>
</table>

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

<table>
<thead><tr><th>Rule</th><th>Correct</th><th>Wrong</th></tr></thead>
<tbody>
<tr><td>Branch from <code>main</code></td><td><code>git checkout -b aap-catalog-fix main</code></td><td><code>git checkout -b aap-catalog-fix dev</code></td></tr>
<tr><td>Short descriptive names</td><td><code>aap-catalog-fix</code></td><td><code>feature/aap-update</code></td></tr>
<tr><td>No prefix</td><td><code>showroom-module3</code></td><td><code>feature/showroom-module3</code></td></tr>
<tr><td>PR to <code>main</code></td><td><code>gh pr create --base main</code></td><td><code>gh pr create --base dev</code></td></tr>
<tr><td>Lint first</td><td><code>yamllint common.yaml</code></td><td>Commit without linting</td></tr>
</tbody>
</table>

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
