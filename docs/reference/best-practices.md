---
layout: default
title: Claude Code Best Practices for RHDP
---

# Claude Code Best Practices for RHDP

<div class="reference-badge">Real problems, real fixes -- from our repos</div>

<div style="background: linear-gradient(135deg, #fff3cd 0%, #fff8e1 100%); border-left: 4px solid #ffc107; padding: 1rem 1.25rem; margin: 1.5rem 0; border-radius: 6px;">
<strong>Why this page exists:</strong> We've seen Claude produce broken YAML, create branches with wrong naming, generate generic Showroom content, and "forget" what repo it's working in -- all because of avoidable mistakes. This page walks through what goes wrong and how to fix it, using examples from AgnosticV, AgnosticD, and Showroom.
</div>

---

## Not Clearing Context Between Tasks

### What happens

You're updating an AgnosticV catalog item for `aap-selfserv-intro`. It goes well. Then, without clearing, you ask Claude to write a Showroom module for a different workshop entirely.

Claude starts mixing up the two. It references `aap-selfserv-intro` variables in your new Showroom content. It uses YAML structures from the catalog item inside an AsciiDoc file. You correct it, but the corrections pile up and Claude gets worse, not better.

### What you see

```asciidoc
// Showroom module -- but Claude leaks AgV context into it
[source,yaml]
----
agd_v2_collections:
  - name: aap_selfserv_collection    # <-- wrong workshop entirely
    git_repo: https://github.com/...
----
```

Or Claude generates a `common.yaml` that includes Showroom-style AsciiDoc formatting because it's still holding onto the previous task.

### Fix

```
> /clear
> I'm working on the Showroom content for ocp-virt-admin-rosetta.
> The repo is at ~/work/showroom-content/ocp-virt-admin-rosetta-showroom/
> Create module 2 following the structure in module 1.
```

One `/clear` between tasks. That's it. Claude starts fresh, no bleed-over.

---

## Never Compacting During Long AgnosticD Sessions

### What happens

You're building a new AgnosticD v2 validation role. You've been going for a while -- Claude has read `core_workload`, your role's `tasks/main.yml`, the `defaults/main.yml`, three other reference roles, and the AgnosticV `common.yaml` to understand the collections. The context window is at 80%.

You ask Claude to add a new task to check AAP Controller health. Claude produces something that looks right but silently drops the `delegate_to: bastion` pattern it was using earlier. Or it forgets your role naming convention and generates `validate_aap_health` instead of `ocp4_workload_aap_health`.

### What you see

```yaml
# Claude "forgot" the project conventions from earlier in the session
- name: Check AAP Controller
  ansible.builtin.uri:
    url: "https://{{ aap_controller_url }}/api/v2/ping/"
  # Missing: delegate_to: bastion
  # Missing: register + result check
  # Wrong role name in the file path
```

### Fix

Compact with focus instructions so Claude keeps what matters:

```
> /compact Keep the role naming conventions, delegate_to patterns,
> core_workload inheritance, and the validation task structure
```

Or if you're really deep in the weeds, `/clear` and start a fresh session with a more precise prompt:

```
> I'm building a validation role at roles/ocp4_workload_aap_validate/.
> It follows core_workload patterns. All oc/ansible commands must use
> delegate_to: bastion. Read @roles/ocp4_workload_example/tasks/main.yml
> for the pattern. Add a task that checks AAP Controller health via the
> /api/v2/ping/ endpoint.
```

---

## No CLAUDE.md in Your Repo

### What happens in AgnosticV

You ask Claude to create a PR for your catalog item changes. Claude runs:

```bash
git checkout -b feature/update-aap-catalog    # Wrong -- we don't use feature/ prefix
git commit -m "Update catalog

Co-Authored-By: Claude <noreply@anthropic.com>"   # Wrong -- no AI attribution
```

Then it pushes to `feature/update-aap-catalog` and creates a PR. Nate reviews it, sees the wrong branch naming and the AI footer in the commit message. You have to redo it.

### What happens in Showroom

Without a CLAUDE.md, Claude doesn't know your content lives in `content/modules/ROOT/pages/`. It creates files in the repo root. Or it writes Markdown instead of AsciiDoc. Or it uses a formal corporate tone instead of the direct, hands-on style your workshops follow.

```markdown
<!-- Claude writes Markdown because nobody told it to use AsciiDoc -->
## Introduction

In this module, we will leverage Red Hat OpenShift Virtualization
to demonstrate enterprise-grade virtual machine management
capabilities for modern infrastructure...
```

vs what you actually want:

```asciidoc
== What You'll Do

We're going to migrate a VM from VMware into OpenShift Virtualization.
By the end of this module, your VM will be running on OpenShift with
zero downtime. Let's get started.
```

### Fix

Add a CLAUDE.md to each repo. It doesn't need to be long. Here are working examples:

**AgnosticV** (`~/work/code/agnosticv/CLAUDE.md`):

```markdown
## Git Rules
- Branch from main, never from other branches
- Branch names: short and descriptive (e.g., aap-selfserv-catalog)
- DO NOT use feature/ prefix
- No AI attribution in commit messages

## Catalog Items
- Key files: common.yaml, dev.yaml, description.adoc
- Validate with yamllint before committing
- PR directly to main
```

**Showroom** (in each showroom repo):

```markdown
## Content
- AsciiDoc format, NOT Markdown
- Files go in content/modules/ROOT/pages/
- Follow Say > Do > Explain pattern
- No corporate tone -- write like you're sitting next to someone

## Git Rules
- Branch from main
- Short descriptive branch names, no feature/ prefix
- No AI attribution in commits
```

---

## Vague Prompts That Burn Through Context

### What happens

You open Claude in your `agnosticv` repo and type:

```
> help me fix the catalog item
```

Claude doesn't know which catalog item. There are hundreds. So it starts scanning directories, reading `common.yaml` files one by one, trying to figure out what you mean. It reads 15 files. Your context is now half full and Claude hasn't done anything useful yet.

Or in a Showroom repo:

```
> make the content better
```

Claude reads every `.adoc` file in the repo, produces a vague plan to "improve clarity and flow," and rewrites Module 1 in a way that loses all the technical accuracy.

### What you see

Claude burns through 40-50% of its context window just exploring. Then when it finally writes something, it doesn't have enough room left to do a good job. You hit auto-compact. Claude loses the specifics of what you asked for. The output is generic.

### Fix

Be specific. Reference the file. Tell Claude what "fixed" looks like.

```
> The common.yaml at sandboxes-gpte/AAP_WORKSHOPS/aap-selfserv-intro/
> has an incorrect collection repo URL in agd_v2_collections.
> The URL should point to https://github.com/rhpds/aap-selfserv-collection.
> Fix it and run yamllint on the result.
```

```
> Module 3 in content/modules/ROOT/pages/module-03.adoc needs a new section
> after the "Deploy the application" step. Add a verification step where
> the user runs: oc get pods -n %user%-project
> Follow the same AsciiDoc pattern as the existing steps in the file.
```

---

## Working Across AgV + AgD + Showroom in One Session

### What happens

A new workshop needs work across all three repos: AgnosticV catalog item, AgnosticD role, and Showroom content. You open one Claude session and start jumping between them.

By the time you're on the Showroom content, Claude's context is packed with AgnosticV YAML structures, AgnosticD role patterns, and Ansible task definitions. It starts generating AsciiDoc that includes YAML frontmatter from AgV. Or it uses Ansible `register:` syntax inside a Showroom module because that's what it's been seeing for the last 30 messages.

### What you see

```asciidoc
// Claude mixes AgD Ansible syntax into Showroom content
== Deploy the Application

[source,bash]
----
- name: Deploy application     # <-- This is Ansible, not a user command
  ansible.builtin.shell: |
    oc apply -f manifests/
  delegate_to: bastion
----
```

### Fix

Separate sessions per repo. Each gets clean context.

```bash
# Terminal 1 -- AgnosticD role
cd ~/work/code/agnosticd && claude
> /rename agd-new-workshop

# Terminal 2 -- AgnosticV catalog
cd ~/work/code/agnosticv && claude
> /rename agv-new-workshop

# Terminal 3 -- Showroom content
cd ~/work/showroom-content/my-workshop-showroom && claude
> /rename showroom-new-workshop
```

Finish the AgD role first. Then the AgV catalog. Then the Showroom content. Each session knows exactly what repo it's in and doesn't get confused.

---

## Generating Showroom Content Without a Reference

### What happens

You run `/showroom:create-lab` and tell Claude to generate Module 2 for your workshop. Claude has no reference for your existing content's style, structure, or technical depth. It produces generic content that reads like a product datasheet, not a hands-on lab.

### What you see

```asciidoc
== Module 2: Configuring Red Hat Ansible Automation Platform

In this module, you will configure the Ansible Automation Platform
to enable self-service automation capabilities across your organization.

Red Hat Ansible Automation Platform provides a comprehensive solution
for IT automation that enables your organization to...
```

That's marketing copy, not a workshop. The user doesn't learn anything from it. Nate rejects it, and you have to rewrite it by hand.

### Fix

Always point Claude to an existing module as a reference:

```
> Read the existing Module 1 at
> @content/modules/ROOT/pages/module-01.adoc
> to understand the style, tone, and AsciiDoc structure.
>
> Now create Module 2 that covers configuring job templates.
> Follow the exact same patterns -- the callout boxes, the
> [source,bash] blocks, the verification steps after each action.
> Keep the same hands-on tone.
```

Or better yet, point to a module from a different repo that's already reviewed and approved:

```
> Use ~/work/showroom-content/aap-selfserv-intro-showroom/
> content/modules/ROOT/pages/module-02.adoc as a reference
> for quality, structure, and writing style.
```

---

## Not Verifying Claude's Output

### What happens

Claude updates your AgnosticV `common.yaml`. The YAML looks reasonable. You commit and push. The PR fails CI because the YAML has an indentation error on line 47, or a duplicate key, or a missing required field.

Or Claude writes an AgnosticD validation role that looks correct but has a `when:` condition that never evaluates to true, so the task silently skips every time.

### What you see

```yaml
# Looks fine to a human scanning it quickly
agd_v2_collections:
  - name: my_collection
    git_repo: https://github.com/rhpds/my-collection
    version: main
    git_repo: https://github.com/rhpds/my-collection  # Duplicate key -- YAML error
```

### Fix

Always tell Claude to validate after making changes:

```
> Update the common.yaml to add the new collection.
> After the change, run yamllint common.yaml and fix any issues.
```

```
> Add the validation tasks. After writing them, run:
> ansible-lint roles/ocp4_workload_aap_validate/
> Fix any errors and run it again until it passes clean.
```

For Showroom content, you can use the verify skill:

```
> /showroom:verify-content
```

---

## Auto-Compact Kicks In While Writing a Showroom Lab

### What happens

You're halfway through creating Module 4 of your Showroom workshop. Claude has read Modules 1-3 for reference, read the Antora nav file, read your CLAUDE.md, and generated about 200 lines of AsciiDoc. Then auto-compact triggers because the context window is full.

Claude summarizes everything. But summaries lose detail. It forgets the exact callout-box pattern you used in Module 2. It loses the specific variable substitution format (`%user%` vs `{user}`). It drops the navigation structure. When it continues writing, Module 4 suddenly has a different style than Modules 1-3 -- different heading levels, different admonition syntax, missing verification steps.

### What you see

```asciidoc
// Before auto-compact -- Module 3 style (correct)
[NOTE]
====
Make sure you replace `%user%` with your assigned username.
====

// After auto-compact -- Module 4 style (drifted)
NOTE: Replace `{user}` with your username.
```

The module is inconsistent with the rest of the workshop. You have to go back and fix it by hand.

### Fix

**Before you start a long content session**, tell Claude what to preserve during compaction. Add this to your prompt or your CLAUDE.md:

```markdown
# Compact instructions
When compacting, always preserve: the AsciiDoc patterns from existing
modules (callout boxes, source blocks, variable substitution format),
the Antora nav structure, and the list of completed vs remaining modules.
```

**When you see context getting high** (check with `/context`), proactively compact instead of waiting for auto-compact:

```
> /compact Keep the AsciiDoc patterns from module-01.adoc, the %user%
> variable format, the [NOTE]/[IMPORTANT] callout style, and the
> verification step pattern. I still need to write modules 4 and 5.
```

**If auto-compact already fired and the output drifted**, don't keep going. Rewind or clear and re-anchor:

```
> /clear
> Read @content/modules/ROOT/pages/module-03.adoc for the exact AsciiDoc
> patterns and style. Continue writing module-04.adoc using the same
> structure. The topic is: configuring job templates in AAP.
```

---

## Your Laptop Restarts Mid-Session

### What happens

You're building an AgnosticD validation role. Claude has written half the tasks, read the `core_workload` reference, and has a clear picture of what needs to happen next. Then your laptop restarts -- macOS update, battery dies, VPN drops and terminal closes.

You open a new terminal and type `claude`. Fresh session. All that context is gone. You try to pick up where you left off, but Claude has no idea what you were working on. You end up re-explaining everything from scratch.

### What you see

```
# New session -- Claude knows nothing about your previous work
> continue working on the validation role

I'd be happy to help with a validation role! Could you tell me more
about what you're trying to validate? What's the target environment?
```

### Fix

**Claude saves every session locally.** You don't lose anything. Just resume:

```bash
# Resume the most recent session in this directory
claude --continue

# Or pick from a list of recent sessions
claude --resume
```

If you named your session earlier (and you should), resume by name:

```bash
claude --resume agd-validation-role
```

The full conversation history, tool outputs, and file states are all restored. Claude picks up exactly where it left off.

**The habit**: always `/rename` your session when you start real work:

```
> /rename agd-aap-validation-role
```

Then if anything interrupts you -- laptop restart, VPN drop, coffee break that turns into a meeting -- you can get right back to it.

### What if you didn't name it?

`claude --resume` without a name opens an interactive picker showing your recent sessions with timestamps and first messages. You can search and preview before selecting one.

---

## Correcting Claude Over and Over

### What happens

Claude creates a branch called `feature/aap-update`. You say "no `feature/` prefix." Claude says sorry and creates `fix/aap-update`. You say "no prefix at all." Claude creates `aap-update` but now the commit message has the AI footer you told it not to use three messages ago. You correct that too. By now the context is full of failed attempts and Claude is performing worse than when you started.

### Fix

After two corrections on the same issue, stop correcting. `/clear` and write a single prompt that includes everything:

```
> /clear

> Create a branch called aap-catalog-update from main.
> Update the common.yaml to add the new collection entry.
> Run yamllint to validate.
> Commit with a clean message, NO AI attribution footer.
> Push and create a PR to main.
```

One clear prompt with all constraints upfront beats five rounds of corrections.

---

## Quick Reference Tables

### Keyboard Shortcuts

| Shortcut | Action |
|---|---|
| `Esc` | Stop Claude mid-action |
| `Esc + Esc` | Rewind / checkpoint menu |
| `Shift+Tab` | Cycle modes: Normal > Auto-Accept > Plan |
| `Ctrl+G` | Open plan in your editor |
| `Ctrl+O` | Toggle verbose mode (see Claude's thinking) |
| `Option+T` / `Alt+T` | Toggle extended thinking on/off |

### Slash Commands

| Command | When to Use |
|---|---|
| `/clear` | Switching tasks, after failed corrections, between repos |
| `/compact` | Deep in a session, need to free context without losing everything |
| `/model` | Switch between Sonnet (daily work) and Opus (complex architecture) |
| `/rename` | Name your session so you can `/resume` it later |
| `/resume` | Pick up where you left off yesterday |
| `/rewind` | Undo Claude's last changes (code + conversation) |
| `/init` | Bootstrap a CLAUDE.md for a new repo |
| `/memory` | View/edit what Claude remembers about this project |
| `/cost` | Check token usage (API users) |
| `/context` | See what's consuming your context window |
| `/hooks` | Set up automated checks (e.g., lint after every edit) |

### RHDP Skills

| Skill | Use Case |
|---|---|
| `/showroom:create-lab` | Generate a new workshop module from reference materials |
| `/showroom:create-demo` | Create a presenter-led demo using Know/Show structure |
| `/showroom:verify-content` | Run quality checks on existing Showroom content |
| `/showroom:blog-generate` | Turn a workshop/demo into a blog post |
| `/agnosticv:catalog-builder` | Create or update AgV catalog files |
| `/agnosticv:validator` | Validate AgV catalog configs |
| `/health:deployment-validator` | Create Ansible validation roles for RHDP health checks |

### RHDP Git Rules (All Repos)

| Rule | Example |
|---|---|
| Branch from `main` | `git checkout -b aap-catalog-fix main` |
| Short descriptive names | `aap-catalog-fix`, `showroom-module3`, `validation-role` |
| No `feature/` prefix | ~~`feature/aap-update`~~ |
| No AI attribution in commits | No `Co-Authored-By: Claude` footer |
| PR to `main` | `gh pr create --base main` |
| Lint before committing | `yamllint`, `ansible-lint` |

---

## Further Reading

- [Claude Code Best Practices (official)](https://code.claude.com/docs/en/best-practices) -- The full upstream guide from Anthropic
- [Memory Management](https://code.claude.com/docs/en/memory) -- CLAUDE.md, auto memory, `.claude/rules/`
- [Common Workflows](https://code.claude.com/docs/en/common-workflows) -- Plan mode, subagents, PR workflows
- [Managing Costs](https://code.claude.com/docs/en/costs) -- Token usage, model selection, reducing overhead
- [Hooks Reference](https://code.claude.com/docs/en/hooks) -- Automate lint checks, block destructive commands
