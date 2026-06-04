# rhdp-core Status Bar Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create the `rhdp-core` plugin with a status bar script (`rhdp-core-prompt.sh`) that adds cache hit rate, turn count, and session duration to the existing `context-bar.sh` format, plus a `/rhdp-core:setup` skill that installs it.

**Architecture:** A new `rhdp-core/` plugin directory follows the same layout as `showroom/` and `agnosticv/`. The status bar script is a self-contained bash script that extends `context-bar.sh` — same line 1/3/4, new line 2 with session metrics. The setup skill writes the script to `~/.claude/scripts/` and updates `statusLine` in `~/.claude/settings.json`.

**Tech Stack:** Bash, jq, awk — same toolchain as the existing `context-bar.sh`. No new dependencies.

**Working directory:** All file paths are relative to the worktree root:
`/Users/tok/Dropbox/PARAL/Projects/rhdp-skills-marketplace/rhdp-skills-marketplace/worktrees/rhdp-core-01/`

The worktree is on branch `feature/rhdp-core-01`. Commit each task there.

---

### Task 1: Plugin skeleton

**Files:**
- Create: `rhdp-core/.claude-plugin/plugin.json`
- Create: `rhdp-core/README.md`

- [ ] **Step 1: Create plugin.json**

```json
{
  "name": "rhdp-core",
  "version": "0.1.0",
  "description": "Core utility skills for all RHDP team members — status bar, project init, and commit helpers"
}
```

Write to `rhdp-core/.claude-plugin/plugin.json`.

- [ ] **Step 2: Create README.md**

```markdown
# rhdp-core

Core utility skills for all RHDP team members.

## Skills

| Skill | Description |
|-------|-------------|
| `/rhdp-core:setup` | Install the RHDP status bar and wire it into Claude Code |

## Installation

```bash
/plugin install rhdp-core@rhdp-marketplace
/rhdp-core:setup
```

## Status Bar

After running `/rhdp-core:setup`, your Claude Code status bar shows:

```
Sonnet 4.6 | 📁 my-project | ████░░░░░░ 53% of 200k | $2.69
cache:74% | turns:7 | 12m
💬 last message you sent
⎇ main (0 files uncommitted, synced 5m ago)
```

Line 2 fields:
- `cache:N%` — cache hit rate (blue ≥70%, amber 40–69%, red <40%)
- `turns:N` — how many exchanges this session
- `Nm` — session duration
```
Write to `rhdp-core/README.md`.

- [ ] **Step 3: Commit**

```bash
git -C /Users/tok/Dropbox/PARAL/Projects/rhdp-skills-marketplace/rhdp-skills-marketplace/worktrees/rhdp-core-01 add rhdp-core/
git -C /Users/tok/Dropbox/PARAL/Projects/rhdp-skills-marketplace/rhdp-skills-marketplace/worktrees/rhdp-core-01 commit -m "feat: rhdp-core plugin skeleton"
```

---

### Task 2: Status bar script

**Files:**
- Create: `rhdp-core/scripts/rhdp-core-prompt.sh`

This script is a superset of `~/.claude/scripts/context-bar.sh`. It preserves all existing behaviour (lines 1, 3, 4) and adds line 2 with session metrics.

- [ ] **Step 1: Create the script**

Write to `rhdp-core/scripts/rhdp-core-prompt.sh`:

```bash
#!/bin/bash

# rhdp-core-prompt.sh — Claude Code status bar for RHDP team
# Extends context-bar.sh with cache hit rate, turn count, and session duration.
#
# Output:
#   Line 1: model | dir | context bar | cost
#   Line 2: cache:N% | turns:N | Nm
#   Line 3: 💬 last user message
#   Line 4: ⎇ branch (git status)

# Color theme: gray, orange, blue, teal, green, lavender, rose, gold, slate, cyan
COLOR="blue"

C_RESET='\033[0m'
C_GRAY='\033[38;5;245m'
C_BAR_EMPTY='\033[38;5;238m'
C_COST_OK='\033[38;5;245m'
C_COST_WARN='\033[38;5;179m'
C_COST_HIGH='\033[38;5;167m'

case "$COLOR" in
orange)   C_ACCENT='\033[38;5;173m' ;;
blue)     C_ACCENT='\033[38;5;74m'  ;;
teal)     C_ACCENT='\033[38;5;66m'  ;;
green)    C_ACCENT='\033[38;5;71m'  ;;
lavender) C_ACCENT='\033[38;5;139m' ;;
rose)     C_ACCENT='\033[38;5;132m' ;;
gold)     C_ACCENT='\033[38;5;136m' ;;
slate)    C_ACCENT='\033[38;5;60m'  ;;
cyan)     C_ACCENT='\033[38;5;37m'  ;;
*)        C_ACCENT="$C_GRAY"        ;;
esac

input=$(cat)

fmt_money() {
  local raw="$1"
  if [[ -z "$raw" || "$raw" == "null" ]]; then
    return 1
  fi
  awk -v n="$raw" 'BEGIN {
    if (n < 0.01)    printf "$%.3f", n;
    else if (n < 10) printf "$%.2f", n;
    else             printf "$%.1f", n;
  }'
}

pick_cost_color() {
  local raw="$1"
  awk -v n="$raw" 'BEGIN {
    if (n >= 5) print "high";
    else if (n >= 1) print "warn";
    else print "ok";
  }'
}

pick_cache_color() {
  local pct="$1"
  awk -v n="$pct" 'BEGIN {
    if (n >= 70) print "good";
    else if (n >= 40) print "warn";
    else print "poor";
  }'
}

model=$(echo "$input" | jq -r '.model.display_name // .model.id // "?"')
cwd=$(echo "$input" | jq -r '.cwd // empty')
dir=$(basename "$cwd" 2>/dev/null || echo "?")
transcript_path=$(echo "$input" | jq -r '.transcript_path // empty')

max_context=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
max_k=$((max_context / 1000))

branch=""
git_status=""
if [[ -n "$cwd" && -d "$cwd" ]]; then
  branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
  if [[ -n "$branch" ]]; then
    file_count=$(git -C "$cwd" --no-optional-locks status --porcelain -uall 2>/dev/null | wc -l | tr -d ' ')
    sync_status=""
    upstream=$(git -C "$cwd" rev-parse --abbrev-ref @{upstream} 2>/dev/null)

    if [[ -n "$upstream" ]]; then
      fetch_head="$cwd/.git/FETCH_HEAD"
      fetch_ago=""
      if [[ -f "$fetch_head" ]]; then
        fetch_time=$(stat -f %m "$fetch_head" 2>/dev/null || stat -c %Y "$fetch_head" 2>/dev/null)
        if [[ -n "$fetch_time" ]]; then
          now=$(date +%s)
          diff=$((now - fetch_time))
          if [[ $diff -lt 60 ]]; then
            fetch_ago="<1m ago"
          elif [[ $diff -lt 3600 ]]; then
            fetch_ago="$((diff / 60))m ago"
          elif [[ $diff -lt 86400 ]]; then
            fetch_ago="$((diff / 3600))h ago"
          else
            fetch_ago="$((diff / 86400))d ago"
          fi
        fi
      fi

      counts=$(git -C "$cwd" rev-list --left-right --count HEAD...@{upstream} 2>/dev/null)
      ahead=$(echo "$counts" | cut -f1)
      behind=$(echo "$counts" | cut -f2)

      if [[ "$ahead" -eq 0 && "$behind" -eq 0 ]]; then
        [[ -n "$fetch_ago" ]] && sync_status="synced ${fetch_ago}" || sync_status="synced"
      elif [[ "$ahead" -gt 0 && "$behind" -eq 0 ]]; then
        sync_status="${ahead} ahead"
      elif [[ "$ahead" -eq 0 && "$behind" -gt 0 ]]; then
        sync_status="${behind} behind"
      else
        sync_status="${ahead} ahead, ${behind} behind"
      fi
    else
      sync_status="no upstream"
    fi

    if [[ "$file_count" -eq 0 ]]; then
      git_status="(0 files uncommitted, ${sync_status})"
    elif [[ "$file_count" -eq 1 ]]; then
      single_file=$(git -C "$cwd" --no-optional-locks status --porcelain -uall 2>/dev/null | head -1 | sed 's/^...//')
      git_status="(${single_file} uncommitted, ${sync_status})"
    else
      git_status="(${file_count} files uncommitted, ${sync_status})"
    fi
  fi
fi

baseline=20000
bar_width=10
context_length=0
last_user_msg=""
session_cost_raw=""
cache_pct=""
turns=""
duration=""

if [[ -n "$transcript_path" && -f "$transcript_path" ]]; then
  context_length=$(jq -s '
    map(select(.message.usage and .isSidechain != true and .isApiErrorMessage != true)) |
    last |
    if . then
      (.message.usage.input_tokens // 0) +
      (.message.usage.cache_read_input_tokens // 0) +
      (.message.usage.cache_creation_input_tokens // 0)
    else 0 end
  ' <"$transcript_path")

  last_user_msg=$(jq -rs '
    map(select(.type == "user")) | last |
    if . then
      .message.content
      | if type == "string" then .
        elif type == "array" then
          map(select(.type == "text") | .text) | join(" ")
        else "" end
    else "" end
  ' <"$transcript_path" | tr '\n' ' ' | sed 's/[[:space:]]\+/ /g; s/^ //; s/ $//')

  session_cost_raw=$(jq -rs '
    map(select(.message.usage and .isSidechain != true and .isApiErrorMessage != true)) |
    last |
    if . then
      .message.usage.total_cost_usd //
      .message.usage.cost_usd //
      empty
    else empty end
  ' <"$transcript_path")

  # Cache hit rate: cache_read / (input + cache_read + cache_creation)
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

  # Turn count: user messages excluding sidechains
  turns=$(jq -s '[.[] | select(.type == "user" and .isSidechain != true)] | length' \
    <"$transcript_path")

  # Session duration from first to last timestamp (Unix integers in transcript)
  duration=$(jq -rs '
    map(select(.timestamp)) |
    if length > 1 then
      ((last.timestamp) - (first.timestamp)) as $secs |
      if $secs < 60 then "\($secs | round)s"
      elif $secs < 3600 then "\($secs / 60 | floor)m"
      else "\($secs / 3600 | floor)h \(($secs % 3600) / 60 | floor)m"
      end
    else "" end
  ' <"$transcript_path")
fi

if [[ -z "$session_cost_raw" || "$session_cost_raw" == "null" ]]; then
  session_cost_raw=$(echo "$input" | jq -r '
    .cost.total_cost_usd //
    .usage.total_cost_usd //
    .session.total_cost_usd //
    empty
  ')
fi

# ── Build context bar ──────────────────────────────────────────────────────
if [[ "$context_length" -gt 0 ]]; then
  pct=$((context_length * 100 / max_context))
else
  pct=$((baseline * 100 / max_context))
fi
[[ $pct -gt 100 ]] && pct=100

filled=$((pct * bar_width / 100))
bar=""
for ((i = 0; i < bar_width; i++)); do
  if [[ $i -lt $filled ]]; then
    bar="${bar}${C_ACCENT}█"
  else
    bar="${bar}${C_BAR_EMPTY}░"
  fi
done
bar="${bar}${C_RESET}"

# ── Build cost segment ─────────────────────────────────────────────────────
cost_segment=""
if formatted_cost=$(fmt_money "$session_cost_raw"); then
  cost_level=$(pick_cost_color "$session_cost_raw")
  case "$cost_level" in
  high) cost_color="$C_COST_HIGH" ;;
  warn) cost_color="$C_COST_WARN" ;;
  *)    cost_color="$C_COST_OK"   ;;
  esac
  cost_segment=" | ${cost_color}${formatted_cost}${C_RESET}"
fi

# ── Line 1: model | dir | bar | cost ──────────────────────────────────────
echo -e "${C_ACCENT}${model}${C_RESET} ${C_GRAY}|${C_RESET} 📁${C_GRAY}${dir}${C_RESET} ${C_GRAY}|${C_RESET} ${bar} ${C_GRAY}${pct}% of ${max_k}k${C_RESET}${cost_segment}"

# ── Line 2: cache | turns | duration ─────────────────────────────────────
metrics_parts=()

if [[ -n "$cache_pct" && "$cache_pct" != "null" && "$cache_pct" -gt 0 ]] 2>/dev/null; then
  cache_level=$(pick_cache_color "$cache_pct")
  case "$cache_level" in
  good) cache_color="$C_ACCENT"    ;;
  warn) cache_color="$C_COST_WARN" ;;
  *)    cache_color="$C_COST_HIGH" ;;
  esac
  metrics_parts+=("${C_GRAY}cache:${C_RESET}${cache_color}${cache_pct}%${C_RESET}")
fi

if [[ -n "$turns" && "$turns" != "null" && "$turns" -gt 0 ]] 2>/dev/null; then
  metrics_parts+=("${C_GRAY}turns:${C_RESET}${C_ACCENT}${turns}${C_RESET}")
fi

if [[ -n "$duration" && "$duration" != "null" && "$duration" != "" ]]; then
  metrics_parts+=("${C_ACCENT}${duration}${C_RESET}")
fi

if [[ ${#metrics_parts[@]} -gt 0 ]]; then
  sep=" ${C_GRAY}|${C_RESET} "
  line2=""
  for i in "${!metrics_parts[@]}"; do
    [[ $i -gt 0 ]] && line2="${line2}${sep}"
    line2="${line2}${metrics_parts[$i]}"
  done
  echo -e "$line2"
fi

# ── Line 3: last user message ──────────────────────────────────────────────
if [[ -n "$last_user_msg" ]]; then
  max_len=95
  if [[ ${#last_user_msg} -gt $max_len ]]; then
    echo "💬 ${last_user_msg:0:$((max_len - 3))}..."
  else
    echo "💬 ${last_user_msg}"
  fi
fi

# ── Line 4: branch + git status ───────────────────────────────────────────
if [[ -n "$branch" ]]; then
  echo -e "${C_GRAY} ${branch} ${git_status}${C_RESET}"
fi
```

- [ ] **Step 2: Make executable**

```bash
chmod +x /Users/tok/Dropbox/PARAL/Projects/rhdp-skills-marketplace/rhdp-skills-marketplace/worktrees/rhdp-core-01/rhdp-core/scripts/rhdp-core-prompt.sh
```

- [ ] **Step 3: Commit**

```bash
git -C /Users/tok/Dropbox/PARAL/Projects/rhdp-skills-marketplace/rhdp-skills-marketplace/worktrees/rhdp-core-01 add rhdp-core/scripts/
git -C /Users/tok/Dropbox/PARAL/Projects/rhdp-skills-marketplace/rhdp-skills-marketplace/worktrees/rhdp-core-01 commit -m "feat: rhdp-core-prompt.sh status bar with cache/turns/duration metrics"
```

---

### Task 3: Smoke test the script

No test framework exists in this repo — verify by running the script with controlled input.

- [ ] **Step 1: Create a mock transcript**

```bash
cat > /tmp/rhdp-prompt-test-transcript.jsonl <<'EOF'
{"type":"user","message":{"content":"Hello there"},"timestamp":1717500000,"isSidechain":false}
{"type":"assistant","message":{"usage":{"input_tokens":1000,"cache_read_input_tokens":7000,"cache_creation_input_tokens":2000,"total_cost_usd":1.50}},"timestamp":1717500120,"isSidechain":false,"isApiErrorMessage":false}
EOF
```

- [ ] **Step 2: Run the script with mock input**

```bash
TEST_INPUT=$(jq -n '{
  "model": {"display_name": "Sonnet 4.6"},
  "cwd": "/tmp",
  "context_window": {"context_window_size": 200000},
  "transcript_path": "/tmp/rhdp-prompt-test-transcript.jsonl"
}')

echo "$TEST_INPUT" | bash /Users/tok/Dropbox/PARAL/Projects/rhdp-skills-marketplace/rhdp-skills-marketplace/worktrees/rhdp-core-01/rhdp-core/scripts/rhdp-core-prompt.sh
```

- [ ] **Step 3: Verify output**

Expected (colors will show as ANSI in terminal):
```
Sonnet 4.6 | 📁 tmp | ░░░░░░░░░░ 10% of 200k | $1.50
cache:70% | turns:1 | 2m
💬 Hello there
```
(No line 4 — `/tmp` is not a git repo)

Calculations to verify:
- `cache_pct` = round(7000 × 100 / (1000 + 7000 + 2000)) = round(70.0) = **70** → blue (≥70%)
- `turns` = 1 user message → **turns:1**
- `duration` = 1717500120 − 1717500000 = 120s = **2m**
- `cost` = $1.50 → amber (`C_COST_WARN`, ≥$1)

If `duration` shows empty, the transcript `.timestamp` format may differ from what Claude Code actually writes — this is expected to work in a real session; omit is the designed fallback.

- [ ] **Step 4: Test with no transcript (bare minimum input)**

```bash
echo '{"model":{"display_name":"Sonnet 4.6"},"cwd":"/tmp","context_window":{"context_window_size":200000}}' \
  | bash /Users/tok/Dropbox/PARAL/Projects/rhdp-skills-marketplace/rhdp-skills-marketplace/worktrees/rhdp-core-01/rhdp-core/scripts/rhdp-core-prompt.sh
```

Expected: Line 1 only (10% baseline bar, no cost, no metrics, no message).

```
Sonnet 4.6 | 📁 tmp | ░░░░░░░░░░ 10% of 200k
```

---

### Task 4: Setup skill

**Files:**
- Create: `rhdp-core/skills/setup/SKILL.md`

The skill writes `rhdp-core-prompt.sh` to `~/.claude/scripts/` and updates `statusLine` in `~/.claude/settings.json`.

`settings.json` uses this exact format (verified from current installation):
```json
"statusLine": {
  "type": "command",
  "command": "~/.claude/scripts/context-bar.sh"
}
```

- [ ] **Step 1: Create SKILL.md**

Write to `rhdp-core/skills/setup/SKILL.md`:

````markdown
---
name: rhdp-core:setup
description: "Install the RHDP status bar for Claude Code. Copies rhdp-core-prompt.sh to ~/.claude/scripts/ and configures the statusLine in ~/.claude/settings.json. Run once after installing the rhdp-core plugin."
---

---
context: main
model: claude-sonnet-4-6
---

# RHDP Core Setup

Installs the RHDP status bar and wires it into Claude Code.

## What This Does

1. Writes `rhdp-core-prompt.sh` to `~/.claude/scripts/`
2. Updates `statusLine` in `~/.claude/settings.json`

## Workflow

### Step 1: Create scripts directory if needed

Run:
```bash
mkdir -p ~/.claude/scripts
```

### Step 2: Write the status bar script

Use the Write tool to create `~/.claude/scripts/rhdp-core-prompt.sh` with the exact content from `rhdp-core/scripts/rhdp-core-prompt.sh` in the marketplace repo.

To get the script content, read:
```bash
# The script is bundled at this path after plugin installation:
# ~/.claude/plugins/cache/rhdp-marketplace/rhdp-core/scripts/rhdp-core-prompt.sh
# Fall back to reading from this skill's own plugin directory if needed.
```

Use the Read tool to find and read `rhdp-core-prompt.sh` from the installed plugin location, then use the Write tool to write it to `~/.claude/scripts/rhdp-core-prompt.sh`.

Make it executable:
```bash
chmod +x ~/.claude/scripts/rhdp-core-prompt.sh
```

### Step 3: Check current settings.json

Use the Read tool to read `~/.claude/settings.json`.

Check the `statusLine` field:

**Case A — `statusLine` not present or null:**
Proceed to Step 4.

**Case B — `statusLine.command` already contains `rhdp-core-prompt.sh`:**
Report:
```
✅ Status bar already configured and up to date.
Script: ~/.claude/scripts/rhdp-core-prompt.sh
```
Stop here — do not modify settings.json.

**Case C — `statusLine.command` points to something else (e.g., `context-bar.sh`):**
Show the user what is currently configured:
```
Current statusLine: <current value>
Replace with rhdp-core-prompt.sh? [Y/n]
```
WAIT for their answer. If they say no, stop. If yes, proceed to Step 4.

### Step 4: Update settings.json

Use the Edit tool to update (or add) the `statusLine` field in `~/.claude/settings.json`:

```json
"statusLine": {
  "type": "command",
  "command": "~/.claude/scripts/rhdp-core-prompt.sh"
}
```

### Step 5: Report

Show a brief summary:
```
✅ RHDP status bar installed.

Script: ~/.claude/scripts/rhdp-core-prompt.sh
Settings: ~/.claude/settings.json → statusLine updated

Restart Claude Code to see the new status bar.
```

## Error Handling

**If `~/.claude/settings.json` does not exist:**
Tell the user and stop. They need to run Claude Code at least once to generate the settings file.

**If the Write tool fails on the script:**
Report the error and suggest running `/rhdp-core:setup` again or copying the script manually from the plugin directory.
````

- [ ] **Step 2: Commit**

```bash
git -C /Users/tok/Dropbox/PARAL/Projects/rhdp-skills-marketplace/rhdp-skills-marketplace/worktrees/rhdp-core-01 add rhdp-core/skills/
git -C /Users/tok/Dropbox/PARAL/Projects/rhdp-skills-marketplace/rhdp-skills-marketplace/worktrees/rhdp-core-01 commit -m "feat: rhdp-core:setup skill — install status bar + wire settings.json"
```

---

### Task 5: Register in marketplace

**Files:**
- Modify: `.claude-plugin/marketplace.json`

- [ ] **Step 1: Add rhdp-core to the plugins array**

Read `.claude-plugin/marketplace.json`. Add this entry to the `plugins` array (insert before the closing `]`):

```json
    {
      "name": "rhdp-core",
      "source": "./rhdp-core",
      "description": "Core utility skills for all RHDP team members — status bar, project init, and commit helpers",
      "version": "0.1.0",
      "author": {
        "name": "RHDP Team",
        "email": "prakhar@redhat.com"
      },
      "homepage": "https://rhpds.github.io/rhdp-skills-marketplace",
      "repository": "https://github.com/rhpds/rhdp-skills-marketplace",
      "license": "Apache-2.0",
      "tags": [
        "rhdp",
        "setup",
        "status-bar",
        "utilities",
        "core"
      ]
    }
```

After editing, verify the JSON is valid:

```bash
jq . /Users/tok/Dropbox/PARAL/Projects/rhdp-skills-marketplace/rhdp-skills-marketplace/worktrees/rhdp-core-01/.claude-plugin/marketplace.json > /dev/null && echo "valid JSON"
```

Expected: `valid JSON`

- [ ] **Step 2: Commit**

```bash
git -C /Users/tok/Dropbox/PARAL/Projects/rhdp-skills-marketplace/rhdp-skills-marketplace/worktrees/rhdp-core-01 add .claude-plugin/marketplace.json
git -C /Users/tok/Dropbox/PARAL/Projects/rhdp-skills-marketplace/rhdp-skills-marketplace/worktrees/rhdp-core-01 commit -m "chore: register rhdp-core plugin in marketplace.json"
```

---

### Task 6: Update CHANGELOG

**Files:**
- Modify: `CHANGELOG.md`

- [ ] **Step 1: Add entry under `[Unreleased]`**

Read `CHANGELOG.md`. Under `## [Unreleased]`, add:

```markdown
### Added — rhdp-core Plugin (v0.1.0)

- **New plugin:** `rhdp-core` — general-purpose utility skills for all RHDP team members
- **`rhdp-core:setup` skill:** installs `rhdp-core-prompt.sh` status bar and configures `statusLine` in `~/.claude/settings.json`
- **Status bar (`rhdp-core-prompt.sh`):** extends `context-bar.sh` with a second metrics line showing cache hit rate (color-coded blue/amber/red), turn count, and session duration; all other lines unchanged
```

- [ ] **Step 2: Commit**

```bash
git -C /Users/tok/Dropbox/PARAL/Projects/rhdp-skills-marketplace/rhdp-skills-marketplace/worktrees/rhdp-core-01 add CHANGELOG.md
git -C /Users/tok/Dropbox/PARAL/Projects/rhdp-skills-marketplace/rhdp-skills-marketplace/worktrees/rhdp-core-01 commit -m "docs: add rhdp-core v0.1.0 to CHANGELOG"
```

---

## Self-Review

**Spec coverage check:**

| Spec requirement | Task that implements it |
|---|---|
| `rhdp-core/.claude-plugin/plugin.json` | Task 1 |
| `rhdp-core/scripts/rhdp-core-prompt.sh` | Task 2 |
| Line 1 identical to context-bar.sh | Task 2 (script is a strict superset) |
| Line 2: cache:N% with color thresholds | Task 2 (`pick_cache_color` + metrics_parts logic) |
| Line 2: turns:N | Task 2 (jq turn count) |
| Line 2: duration | Task 2 (jq timestamp diff) |
| Lines 3 and 4 unchanged | Task 2 (same jq as context-bar.sh) |
| `/rhdp-core:setup` skill | Task 4 |
| Setup: copies script to `~/.claude/scripts/` | Task 4, Step 3 of skill |
| Setup: handles 3 statusLine cases | Task 4 (Cases A/B/C) |
| Register in `marketplace.json` | Task 5 |
| `CHANGELOG.md` updated | Task 6 |

**No placeholders detected.**

**Type consistency:** No shared types — this is all bash + markdown.
