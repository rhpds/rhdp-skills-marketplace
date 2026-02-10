---
layout: default
title: Testing & Tech Preview
---

# Testing Skills & Tech Preview Branch

<div class="reference-badge">Try changes before they land in main</div>

<div style="background: linear-gradient(135deg, #e3f2fd 0%, #e8eaf6 100%); border-left: 4px solid #1976d2; padding: 1rem 1.25rem; margin: 1.5rem 0; border-radius: 6px;">
<strong>Why this matters:</strong> Skill changes (new prompts, restructured SKILL.md files, template extraction) can break workflows if pushed to <code>main</code> untested. The <code>tech-preview</code> branch lets you test changes in real sessions before anyone else is affected.
</div>

---

## How Skills Load

When you install the RHDP Skills Marketplace plugin, Claude Code pulls skills from the `main` branch by default. Every team member who runs `/showroom:create-lab` or `/agnosticv:catalog-builder` gets the same SKILL.md content.

That means a bad change to `main` breaks everyone simultaneously. The `tech-preview` branch exists to avoid that.

---

## The `tech-preview` Branch

`tech-preview` is a persistent branch that sits between your working branch and `main`. The flow is:

```
your-branch  -->  tech-preview  -->  main
   (dev)          (team testing)     (stable)
```

### When to Use It

- You've changed a SKILL.md and want to verify it works before merging to `main`
- You've extracted templates, reorganized files, or updated AGV-COMMON-RULES.md
- You want a teammate to try your changes without cloning your branch
- You're testing a new skill end-to-end before releasing it

### Keeping It Current

`tech-preview` should always be based on `main` plus your changes:

```bash
git checkout tech-preview
git merge main            # catch up with latest stable
git merge your-branch     # add your changes on top
git push origin tech-preview
```

---

## Testing Skills from `tech-preview`

### Option 1: Marketplace with Branch Specifier

The simplest way. Add `#tech-preview` to the marketplace URL:

```bash
claude /install-plugin https://github.com/rhpds/rhdp-skills-marketplace#tech-preview
```

This tells Claude Code to pull all skills from the `tech-preview` branch instead of `main`. Your skills list stays the same -- `/showroom:create-lab`, `/agnosticv:catalog-builder`, etc. -- but the underlying SKILL.md files come from the `tech-preview` branch.

To go back to stable:

```bash
claude /install-plugin https://github.com/rhpds/rhdp-skills-marketplace
```

(No `#branch` defaults to `main`.)

### Option 2: Local Directory (For Development)

If you're actively developing a skill and want to test changes immediately without pushing:

```bash
# Clone the repo if you haven't already
cd ~/work/code/rhdp-skills-marketplace

# Switch to your working branch
git checkout my-skill-changes

# Start Claude with your local plugins
claude --plugin-dir ~/work/code/rhdp-skills-marketplace/showroom
claude --plugin-dir ~/work/code/rhdp-skills-marketplace/agnosticv
claude --plugin-dir ~/work/code/rhdp-skills-marketplace/health
```

With `--plugin-dir`, Claude loads the skills directly from your local files. Every time you edit a SKILL.md and restart Claude, you see the changes immediately. No pushing, no branch switching.

You can also load multiple plugin directories at once:

```bash
claude \
  --plugin-dir ~/work/code/rhdp-skills-marketplace/showroom \
  --plugin-dir ~/work/code/rhdp-skills-marketplace/agnosticv
```

### Option 3: Test a Single Plugin Group

If you only changed AgnosticV skills and don't want to touch Showroom:

```bash
# Load AgnosticV from local, Showroom from marketplace (main)
claude --plugin-dir ~/work/code/rhdp-skills-marketplace/agnosticv
```

Your marketplace-installed Showroom skills still load from `main`. Only AgnosticV comes from your local directory.

---

## Testing Workflow

Here's the recommended flow when you change a skill:

### 1. Make Your Changes on a Branch

```bash
cd ~/work/code/rhdp-skills-marketplace
git checkout -b optimize-agv-skills main

# Edit SKILL.md files, templates, etc.
```

### 2. Test Locally First

```bash
# Start Claude with your local plugin
claude --plugin-dir ~/work/code/rhdp-skills-marketplace/agnosticv

# Run the skill you changed
> /agnosticv:catalog-builder
```

Verify the skill works: Does it follow the right steps? Does it find the templates? Does it produce correct output?

### 3. Push to `tech-preview` for Team Testing

```bash
git push origin optimize-agv-skills

# Update tech-preview
git checkout tech-preview
git merge main
git merge optimize-agv-skills
git push origin tech-preview
```

Tell your teammates:

```
I've pushed AgV skill changes to tech-preview. To test:
claude /install-plugin https://github.com/rhpds/rhdp-skills-marketplace#tech-preview

Try running /agnosticv:catalog-builder and let me know if it works.
```

### 4. Merge to Main and Release

Once tested, merge your branch to `main` via PR, tag a release, and teammates switch back to stable:

```bash
claude /install-plugin https://github.com/rhpds/rhdp-skills-marketplace
```

---

## Quick Reference

| Method | Command | Best For |
|---|---|---|
| Marketplace (stable) | `claude /install-plugin URL` | Day-to-day use |
| Marketplace (preview) | `claude /install-plugin URL#tech-preview` | Team testing before merge |
| Local directory | `claude --plugin-dir ./path` | Active development |

| Branch | Purpose | Who Uses It |
|---|---|---|
| `main` | Stable, released skills | Everyone |
| `tech-preview` | Pre-release testing | Testers, reviewers |
| `your-branch` | Active development | Just you |

---

## Troubleshooting

### Skills don't update after switching branches

Claude Code caches plugins. After switching between marketplace branches, restart Claude:

```bash
# Reinstall from tech-preview
claude /install-plugin https://github.com/rhpds/rhdp-skills-marketplace#tech-preview

# Restart Claude to pick up changes
exit
claude
```

### `--plugin-dir` skills not showing up

Make sure the directory contains a `.claude-plugin/plugin.json` file. Each plugin group (showroom, agnosticv, health) has its own `plugin.json`:

```
rhdp-skills-marketplace/
  showroom/.claude-plugin/plugin.json
  agnosticv/.claude-plugin/plugin.json
  health/.claude-plugin/plugin.json
```

Point `--plugin-dir` to the group directory, not the repo root:

```bash
# Correct
claude --plugin-dir ~/work/code/rhdp-skills-marketplace/agnosticv

# Wrong -- repo root doesn't have plugin.json
claude --plugin-dir ~/work/code/rhdp-skills-marketplace
```

### Not sure which version you're running

Check your installed plugins:

```bash
claude /plugins
```

This shows which plugins are loaded and where they come from (marketplace URL or local path).
