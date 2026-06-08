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
