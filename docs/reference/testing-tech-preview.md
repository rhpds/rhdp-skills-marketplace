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

Edit `~/.claude/plugins/known_marketplaces.json` and add a `ref` field pointing to `tech-preview`:

```json
{
  "rhdp-marketplace": {
    "source": {
      "source": "github",
      "repo": "rhpds/rhdp-skills-marketplace",
      "ref": "tech-preview"
    },
    "installLocation": "/Users/you/.claude/plugins/marketplaces/rhdp-marketplace",
    "lastUpdated": "2026-01-01T00:00:00.000Z"
  }
}
```

Then update the plugins inside Claude Code:

```
/plugin marketplace update rhdp-marketplace
/plugin update showroom@rhdp-marketplace
/plugin update agnosticv@rhdp-marketplace
/plugin update health@rhdp-marketplace
```

**Then sync the cache** (required — `/plugin update` updates the marketplace copy but not the cache Claude actually reads from):

```bash
plugin-sync
```

Restart Claude Code (exit and relaunch) to pick up the new skill definitions.

To go back to stable, remove the `"ref": "tech-preview"` line from the JSON file, repeat the update and sync commands, and restart.

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

1. Edit ~/.claude/plugins/known_marketplaces.json
   Add "ref": "tech-preview" to the source object
2. Run: /plugin marketplace update rhdp-marketplace
3. Run: /plugin update agnosticv@rhdp-marketplace
4. Run in terminal: plugin-sync
5. Restart Claude Code

Try running /agnosticv:catalog-builder and let me know if it works.
```

### 4. Merge to Main and Release

Once tested, merge your branch to `main` via PR, tag a release, and teammates switch back to stable by removing the `ref` field from their `known_marketplaces.json` and running the update commands again.

---

## Quick Reference

| Method | How | Best For |
|---|---|---|
| Marketplace (stable) | Default `known_marketplaces.json` (no `ref`) | Day-to-day use |
| Marketplace (preview) | Add `"ref": "tech-preview"` + update plugins | Team testing before merge |
| Local directory | `claude --plugin-dir ./path` | Active development |

| Branch | Purpose | Who Uses It |
|---|---|---|
| `main` | Stable, released skills | Everyone |
| `tech-preview` | Pre-release testing | Testers, reviewers |
| `your-branch` | Active development | Just you |

---

## Troubleshooting

### Skills don't update after switching branches

Claude Code has two layers of caching — `/plugin update` only updates the marketplace copy. The cache that skills are actually served from must be synced separately.

Full update sequence:

```
/plugin marketplace update rhdp-marketplace
/plugin update showroom@rhdp-marketplace
/plugin update agnosticv@rhdp-marketplace
/plugin update health@rhdp-marketplace
```

Then in a regular terminal (not inside Claude Code):

```bash
plugin-sync
```

Then exit and relaunch Claude Code.

**Important:** `plugin-sync` is a shell function defined in `~/.zshrc` — run it in a **regular terminal**, not inside Claude Code. If you type it inside Claude Code, it will try to invoke it as a skill and fail.

**Setup:** If you don't have `plugin-sync` yet, add this to your `~/.zshrc`:

```bash
plugin-sync() {
    local marketplace="${1:-rhdp-marketplace}"
    local marketplaces_dir="$HOME/.claude/plugins/marketplaces/$marketplace"
    local cache_dir="$HOME/.claude/plugins/cache/$marketplace"

    for plugin_dir in "$marketplaces_dir"/*/; do
        local plugin=$(basename "$plugin_dir")
        local plugin_json="$plugin_dir/.claude-plugin/plugin.json"
        [ -f "$plugin_json" ] || continue
        local version=$(python3 -c "import json; print(json.load(open('$plugin_json'))['version'])" 2>/dev/null)
        [ -z "$version" ] && echo "  ⚠️  $plugin: could not read version" && continue
        local target="$cache_dir/$plugin/$version"
        [ -d "$target" ] || echo "  ⚠️  $plugin: cache $version not found (run /plugin update first)" && continue
        rsync -a --delete "$plugin_dir" "$target/"
        echo "  ✓ $plugin → $version"
    done
    echo "Done. Restart Claude Code to pick up changes."
}
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

```
/plugins
```

This shows which plugins are loaded and where they come from (marketplace URL or local path).
