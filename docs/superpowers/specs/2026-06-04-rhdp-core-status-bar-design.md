# rhdp-core Plugin: Status Bar Design

**Date:** 2026-06-04
**Branch:** feature/rhdp-core-01
**Scope:** Phase 1 — status bar script + setup skill

---

## Overview

A new `rhdp-core` plugin provides general-purpose utility skills for all RHDP team members, regardless of role. The first feature is a cost-aware terminal status bar (`rhdp-core-prompt.sh`) that extends the existing `context-bar.sh` pattern with session efficiency metrics — cache hit rate, turn count, and session duration.

The plugin will grow to include `project-init` and `commit` skills; this spec covers only the status bar and its setup skill.

---

## Plugin Structure

```
rhdp-core/
  .claude-plugin/
    plugin.json            # name: "rhdp-core"
  scripts/
    rhdp-core-prompt.sh   # status bar script (bundled, copied on setup)
  skills/
    setup/
      SKILL.md             # /rhdp-core:setup — installs script + wires settings.json
    project-init/
      SKILL.md             # future
    commit/
      SKILL.md             # future
  README.md
```

`scripts/` is a new directory convention for this repo — no existing plugins use it. The setup skill handles distributing the script to the user's environment.

---

## Status Bar Format

4-line output, replacing the existing `context-bar.sh`:

```
Sonnet 4.6 | 📁 rhdp-core-01 | ████░░░░░░ 60% of 200k | $2.96
cache:68% | turns:7 | 4m
💬 last user message here
⎇ feature/rhdp-core-01 (0 files uncommitted, no upstream)
```

### Line 1 — Cost bar (unchanged from context-bar.sh)

`model | 📁 dir | [context bar] N% of Mk | $cost`

- Model name: `C_ACCENT` (blue)
- Context bar: filled segments in `C_ACCENT`, empty in `C_BAR_EMPTY`
- Cost: `C_COST_OK` (gray, <$1) / `C_COST_WARN` (amber, $1–$5) / `C_COST_HIGH` (red, ≥$5)

### Line 2 — Session metrics (new, flush left)

`cache:N% | turns:N | Nm`

| Field | Source | Color logic |
|-------|--------|-------------|
| `cache:N%` | `cache_read / (input + cache_read + cache_creation)` × 100 from last turn | `C_ACCENT` ≥70% · `C_COST_WARN` 40–69% · `C_COST_HIGH` <40% |
| `turns:N` | count of `type == "user"` entries in transcript | `C_ACCENT` |
| `Nm` / `Nh Nm` / `Xs` | last timestamp − first timestamp in transcript | `C_ACCENT` |

Labels (`cache:`, `turns:`, etc.) in `C_GRAY`. Any field missing from transcript is silently omitted — no placeholder shown.

### Line 3 — Last user message (unchanged)

`💬 <text of last user message, truncated at 95 chars>`

### Line 4 — Git status (unchanged)

`⎇ branch-name (N files uncommitted, sync-status)`

---

## Data Sources

All metrics are computed from the transcript JSONL at `$transcript_path` (same as context-bar.sh):

```bash
# Cache hit rate
cache_pct=$(jq -s '
  map(select(.message.usage and .isSidechain != true and .isApiErrorMessage != true)) |
  last |
  if . then
    (.message.usage.cache_read_input_tokens // 0) as $cr |
    (.message.usage.input_tokens // 0) as $i |
    (.message.usage.cache_creation_input_tokens // 0) as $cc |
    ($cr + $i + $cc) as $total |
    if $total > 0 then ($cr * 100 / $total | round) else 0 end
  else 0 end
' <"$transcript_path")

# Turn count
turns=$(jq -s '[.[] | select(.type == "user" and .isSidechain != true)] | length' \
  <"$transcript_path")

# Session duration (requires .timestamp fields in transcript entries)
duration=$(jq -rs '
  map(select(.timestamp)) |
  if length > 1 then
    ((last.timestamp) - (first.timestamp)) as $secs |
    if $secs < 60 then "\($secs)s"
    elif $secs < 3600 then "\($secs / 60 | floor)m"
    else "\($secs / 3600 | floor)h \(($secs % 3600) / 60 | floor)m"
    end
  else "" end
' <"$transcript_path")
```

If `$transcript_path` is empty or a field can't be computed, that field is omitted silently.

---

## Setup Skill (`/rhdp-core:setup`)

When invoked:

1. **Locate the script** — resolve path to `rhdp-core-prompt.sh` within the installed plugin directory
2. **Copy to user scripts dir** — `~/.claude/scripts/rhdp-core-prompt.sh`; create `~/.claude/scripts/` if it doesn't exist
3. **Read `~/.claude/settings.json`** and check the `statusline` field:
   - **Not set** → write the new path silently
   - **Already points to `rhdp-core-prompt.sh`** → report "already up to date", exit without writing
   - **Points to something else** → show the current value, ask for confirmation before replacing
4. **Write updated `settings.json`** with `statusline.command` pointing to the new script
5. **Report** — script destination path + before/after statusline value in a short summary

The skill touches only the `statusline` field. No other settings are modified.

---

## Installation Flow

```bash
# Add marketplace (one-time)
/plugin marketplace add rhpds/rhdp-skills-marketplace

# Install plugin
/plugin install rhdp-core@rhdp-marketplace

# Configure status bar
/rhdp-core:setup
```

---

## Future Skills (out of scope for this spec)

| Skill | Purpose |
|-------|---------|
| `project-init` | Writes project metadata to CLAUDE.md: `project_name`, `type` (lab/demo/ci), optional description |
| `commit` | Git commit helper that appends session token/cost data to the commit message |
| Hooks | Configured as needed via `settings.json` alongside the status bar |
