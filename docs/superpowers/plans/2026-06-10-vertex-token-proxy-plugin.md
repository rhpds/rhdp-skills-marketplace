# vertex-token-proxy Plugin Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `vertex-token-proxy` plugin to the RHDP Skills Marketplace with three skills (setup, analyze-report, compare), a SessionStart hook, docs pages, and a reusable skill-feedback issue template.

**Architecture:** Strict mirror of the `sandbox-cli` plugin layout (`.claude-plugin/plugin.json`, flat `skills/<name>/SKILL.md`, `examples/`, README) plus two marketplace-first additions: a silent-by-default SessionStart hook in `hooks/`, and a `.github/ISSUE_TEMPLATE/skill-feedback.yml` template linked from the plugin's docs pages. Docs follow the existing Jekyll pattern: one page per skill in `docs/skills/` with a hand-authored workflow SVG, sidebar nav entries in `docs/_layouts/default.html`, and updated counts on the home and skills index pages.

**Tech Stack:** Markdown/YAML (Claude Code plugin spec), Bash (hook script), Jekyll (docs site), jq (JSON validation).

**Spec:** `docs/superpowers/specs/2026-06-10-vertex-token-proxy-plugin-design.md`

**Branch:** `vertex-token-proxy-plugin` (already created)

**Conventions that override defaults in this repo:**
- Commit messages: plain English, NO conventional-commit prefixes (`feat:`, `fix:` are banned by workspace CLAUDE.md). End with `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>`.
- No emojis in commits, README prose, SKILL.md files, or code comments. Exception: the Jekyll docs pages use emoji icons in `nav-icon`/`category-icon` spans as an established site pattern — match it there only.
- This is a PUBLIC repo: placeholders only, never real tokens/hostnames/project IDs.

---

## Facts about the wrapped CLI (verified against source)

The plan references real output. From `vertex-token-proxy` (github.com/rhpds/vertex-token-proxy):

- Commands: `start [--no-launch] [--no-statusline]`, `stop`, `status`, `report [--all]`, `compare [A B]`, `clear-metrics`.
- `start` sets `ANTHROPIC_VERTEX_BASE_URL` to `http://localhost:8787` and launches Claude Code; metrics go to `~/.vertex-token-proxy/metrics.json`.
- `report` sections: `TOKEN USAGE (Vertex AI reported)` (input uncached/cache read/cache write, output, estimated cost, cache hit rate, cache breaks), `INPUT BREAKDOWN (tiktoken estimate)` (categories: `system_prompt`, `tool_schemas`, `conversation_history`, `user_input`, `tool_results`, `thinking_config`), `REPETITION ANALYSIS` (unchanged system prompt / tool schemas per turn, repeated tokens, cost if uncached), `DRY-RUN COMPRESSION` (`json_dedup_savings`, `log_compression_savings`, `whitespace_savings`, total compressible, potential savings), `COMBINED SAVINGS POTENTIAL`, `LATENCY` (proxy overhead avg/max, Vertex roundtrip avg).
- `compare` with no args diffs the two most recent sessions; with `A B` diffs by session id. Rows: Turns, Input (uncached/cache read/cache write), Output, Cache hit rate %, Cache breaks, Repeated tokens, Compressible tokens, Estimated cost $, Vertex avg latency ms — each with delta and percent.
- Session ids are listed in `metrics.json` under `sessions[].session_id`.
- Requires Python 3.12+ and `uv`. Install: `git clone https://github.com/rhpds/vertex-token-proxy.git && cd vertex-token-proxy && uv pip install -e .`

---

### Task 1: Plugin scaffold and marketplace registration

**Files:**
- Create: `vertex-token-proxy/.claude-plugin/plugin.json`
- Create: `vertex-token-proxy/README.md`
- Modify: `.claude-plugin/marketplace.json` (append to `plugins` array)

- [ ] **Step 1: Create plugin.json**

Write `vertex-token-proxy/.claude-plugin/plugin.json`:

```json
{
  "name": "vertex-token-proxy",
  "version": "1.0.0",
  "description": "Token usage measurement for Claude Code on Vertex AI - install the proxy, analyze session reports, and A/B compare sessions to cut token spend",
  "author": {
    "name": "Joshua Disraeli",
    "email": "jcdisraeli@gmail.com"
  }
}
```

- [ ] **Step 2: Create plugin README**

Write `vertex-token-proxy/README.md`:

```markdown
# vertex-token-proxy Skills

Claude Code skills for [vertex-token-proxy](https://github.com/rhpds/vertex-token-proxy),
a local reverse proxy that measures token usage for Claude Code sessions routed
through Google Vertex AI. It counts tokens by category, detects repetition,
and projects compression savings. No requests are ever modified.

## Install

From the RHDP marketplace:

    /plugin install vertex-token-proxy@rhdp-marketplace

## Skills

| Skill | What it does |
|---|---|
| `/vertex-token-proxy:setup` | Install the proxy, start it, verify your session is measured |
| `/vertex-token-proxy:analyze-report` | Run a session report and get prioritized token-saving recommendations |
| `/vertex-token-proxy:compare` | A/B compare two sessions to see whether a change helped |

## SessionStart hook

The plugin ships a SessionStart hook that stays silent unless all of the
following are true: you are on Vertex AI (`CLAUDE_CODE_USE_VERTEX` is set),
`vertex-token-proxy` is installed, and the current session is not being
measured. In that one case it prints a single reminder line. The hook cannot
start measurement mid-session because the proxy must set
`ANTHROPIC_VERTEX_BASE_URL` before Claude Code launches.

## Who is this for

- Anyone running Claude Code through Google Vertex AI who wants to know
  where their tokens go.
- RHDP team members optimizing token spend across sessions, MCP servers,
  and system prompts.

## Feedback

Open an issue with the skill-feedback template:
https://github.com/rhpds/rhdp-skills-marketplace/issues/new?template=skill-feedback.yml&labels=vertex-token-proxy
```

- [ ] **Step 3: Register in marketplace.json**

In `.claude-plugin/marketplace.json`, append this object to the `plugins` array (after the last existing entry, keeping valid JSON):

```json
{
  "name": "vertex-token-proxy",
  "source": "./vertex-token-proxy",
  "description": "Token usage measurement for Claude Code on Vertex AI - setup, report analysis, and A/B session comparison",
  "version": "1.0.0",
  "author": {
    "name": "Joshua Disraeli",
    "email": "jcdisraeli@gmail.com"
  },
  "homepage": "https://rhpds.github.io/rhdp-skills-marketplace",
  "repository": "https://github.com/rhpds/rhdp-skills-marketplace",
  "license": "Apache-2.0",
  "tags": [
    "vertex",
    "tokens",
    "metrics",
    "cost",
    "proxy",
    "optimization"
  ]
}
```

- [ ] **Step 4: Validate JSON syntax**

Run: `jq . vertex-token-proxy/.claude-plugin/plugin.json > /dev/null && jq . .claude-plugin/marketplace.json > /dev/null && echo OK`
Expected: `OK`

- [ ] **Step 5: Commit**

```bash
git add vertex-token-proxy/.claude-plugin/plugin.json vertex-token-proxy/README.md .claude-plugin/marketplace.json
git commit -m "Add vertex-token-proxy plugin scaffold and marketplace entry

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

### Task 2: setup skill

**Files:**
- Create: `vertex-token-proxy/skills/setup/SKILL.md`

- [ ] **Step 1: Write SKILL.md**

Write `vertex-token-proxy/skills/setup/SKILL.md` (double frontmatter is the marketplace pattern — identity block first, execution block second):

```markdown
---
name: vertex-token-proxy:setup
description: This skill should be used when the user asks to "install vertex-token-proxy", "set up token measurement", "measure my token usage", "track Claude Code tokens on Vertex", "start the token proxy", or "I don't have vertex-token-proxy installed".
---

---
context: main
---

# Skill: setup

**Name:** Vertex Token Proxy Setup
**Description:** Install and start vertex-token-proxy so Claude Code sessions on Google Vertex AI are measured.

---

## Purpose

Guide the user through installing vertex-token-proxy, starting the proxy,
and verifying that a Claude Code session is routed through it. The proxy
binds to 127.0.0.1 only, never modifies or logs request content, and writes
aggregated numbers to `~/.vertex-token-proxy/metrics.json`.

## What You'll Need Before Starting

**Required:**
- Claude Code configured for Google Vertex AI (`CLAUDE_CODE_USE_VERTEX=1`)
- Python 3.12 or newer
- uv (https://docs.astral.sh/uv/getting-started/installation/)

**Helpful to have:**
- An idea of what you want to measure (a baseline session, an MCP-heavy session)

## When to Use

**Use this skill when you want to:**
- Install vertex-token-proxy for the first time
- Get an existing install running and verified

**Don't use this for:**
- Interpreting metrics -> use `/vertex-token-proxy:analyze-report`
- Comparing sessions -> use `/vertex-token-proxy:compare`

## Workflow

### Step 1: Verify the user is on Vertex AI

```bash
echo "CLAUDE_CODE_USE_VERTEX=${CLAUDE_CODE_USE_VERTEX:-<not set>}"
```

If not set, stop and tell the user: this proxy only measures Claude Code
traffic routed through Google Vertex AI. It does nothing for the Claude API
or Bedrock. Do not proceed.

### Step 2: Check prerequisites

```bash
python3 --version   # need 3.12+
uv --version
```

If Python is older than 3.12, ask the user to install a newer Python first.
If uv is missing, point them at the uv install docs and wait.

### Step 3: Check if already installed

```bash
command -v vertex-token-proxy && vertex-token-proxy status
```

If installed, skip to Step 5.

### Step 4: Clone and install

```bash
git clone https://github.com/rhpds/vertex-token-proxy.git ~/repos/vertex-token-proxy
cd ~/repos/vertex-token-proxy
uv pip install -e .
```

Verify:

```bash
command -v vertex-token-proxy
```

### Step 5: Ask about the status line

Ask the user ONE question and wait for the answer:

> The proxy can install a Claude Code status line showing live token counts
> and cost. If you already have a custom status line, the proxy wraps it
> rather than replacing it. Install the status line? (yes/no, default yes)

### Step 6: Start the proxy

This launches a NEW measured Claude Code session, so it must run in a
separate terminal, not inside the current session. Tell the user to run
(in a new terminal):

```bash
vertex-token-proxy start              # with status line (default)
vertex-token-proxy start --no-statusline   # if they answered no in Step 5
```

If they only want the proxy without launching Claude Code:

```bash
vertex-token-proxy start --no-launch
```

### Step 7: Verify

In the measured session (or any terminal):

```bash
vertex-token-proxy status
```

Expected: the proxy reports running on 127.0.0.1:8787. After a few prompts
in the measured session:

```bash
vertex-token-proxy report
```

Expected: a report with TOKEN USAGE, INPUT BREAKDOWN, REPETITION ANALYSIS,
DRY-RUN COMPRESSION, and LATENCY sections. Suggest
`/vertex-token-proxy:analyze-report` for interpretation.

## Troubleshooting

| Error | Cause | Fix |
|-------|-------|-----|
| Port 8787 already in use | Stale proxy or another service | `vertex-token-proxy stop`, then check `lsof -i :8787` and kill the listener |
| `uv: command not found` | uv not installed | Install uv: https://docs.astral.sh/uv/getting-started/installation/ |
| Report is empty after a session | Session not routed through proxy | Launch Claude Code via `vertex-token-proxy start`, not directly |
| `CLAUDE_CODE_USE_VERTEX` not set | Not using Vertex AI | This tool only applies to Vertex AI sessions |

## Security Notes

- The proxy binds to 127.0.0.1 only; there is no network exposure.
- It never reads, logs, or stores request or response content.
- Authorization headers pass through opaquely.
- `metrics.json` stores only aggregated numbers and SHA-256 hashes.
- Never paste tokens or credentials into the conversation.
```

- [ ] **Step 2: Commit**

```bash
git add vertex-token-proxy/skills/setup/SKILL.md
git commit -m "Add vertex-token-proxy setup skill

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

### Task 3: analyze-report skill and example

**Files:**
- Create: `vertex-token-proxy/skills/analyze-report/SKILL.md`
- Create: `vertex-token-proxy/examples/analyze-report-example.md`

- [ ] **Step 1: Write SKILL.md**

Write `vertex-token-proxy/skills/analyze-report/SKILL.md`:

```markdown
---
name: vertex-token-proxy:analyze-report
description: This skill should be used when the user asks to "analyze my token usage", "where are my tokens going", "interpret my vertex-token-proxy report", "why is my Claude Code session expensive", "reduce my token spend", or "analyze token metrics".
---

---
context: main
---

# Skill: analyze-report

**Name:** Token Report Analysis
**Description:** Run a vertex-token-proxy session report and turn the raw numbers into prioritized, concrete token-saving recommendations.

---

## Purpose

The proxy reports facts; this skill provides judgment. It reads the report,
identifies the dominant cost drivers, and recommends the 2-3 highest-impact
changes the user can actually make.

## What You'll Need Before Starting

**Required:**
- vertex-token-proxy installed with at least one recorded session
  (if not -> `/vertex-token-proxy:setup`)

## When to Use

**Use this skill when you want to:**
- Understand where tokens go in a session
- Get concrete recommendations to cut spend

**Don't use this for:**
- Installing the proxy -> use `/vertex-token-proxy:setup`
- Comparing two sessions -> use `/vertex-token-proxy:compare`

## Workflow

### Step 1: Confirm metrics exist

```bash
vertex-token-proxy status
ls ~/.vertex-token-proxy/metrics.json
```

If `metrics.json` is missing, route the user to `/vertex-token-proxy:setup`
and stop.

### Step 2: Ask scope

Ask ONE question and wait:

> Analyze the latest session, or a summary across all sessions?
> (latest / all, default latest)

### Step 3: Run the report

```bash
vertex-token-proxy report          # latest session
vertex-token-proxy report --all    # summary across all sessions
```

### Step 4: Interpret each section

Read the output and apply these heuristics in order:

**TOKEN USAGE**
- Cache hit rate below 70 percent: caching is underperforming. Look at
  cache breaks next.
- Cache breaks above 2 per session: something changes the prompt prefix
  between turns (rotating system prompt content, changing tool sets).
  Each break re-caches the prefix at cache-write prices; the report shows
  the wasted tokens and dollars.

**INPUT BREAKDOWN** (percentages of estimated input)
- `tool_schemas` above 15 percent: MCP schema bloat. Identify enabled MCP
  servers (`claude mcp list`) and recommend disabling unused ones.
- `tool_results` above 40 percent: verbose tool output dominates. Recommend
  more targeted reads (offset/limit), quieter commands, or output filtering.
- `system_prompt` above 20 percent: large CLAUDE.md or many always-on
  instructions; recommend trimming or splitting per-project.
- `conversation_history` dominating in long sessions is normal; recommend
  starting fresh sessions for unrelated tasks.

**REPETITION ANALYSIS**
- High repeated tokens WITH a high cache hit rate is fine - caching is
  absorbing the repetition. Say so explicitly; do not recommend action.
- High repeated tokens WITH a low cache hit rate is the expensive case:
  the same bytes are re-sent and re-billed. The "Cost if uncached" line
  quantifies it.

**DRY-RUN COMPRESSION**
- These savings are projections, never applied. Treat `total_compressible`
  as an upper bound. Mention which compressor dominates
  (`json_dedup_savings`, `log_compression_savings`, `whitespace_savings`)
  as a hint about content shape (repetitive JSON vs noisy logs).

**LATENCY**
- Proxy overhead above 5 percent of total latency is worth flagging;
  otherwise state the proxy is effectively free.

### Step 5: Deliver recommendations

End with a short section exactly like this:

```text
TOP RECOMMENDATIONS
1. <highest-impact change> - saves roughly <tokens or dollars per session>
2. <second change> - <impact>
3. <third change, optional> - <impact>
```

Rules: maximum 3 recommendations, each tied to a number from the report,
ordered by estimated savings. If the report shows healthy numbers across
the board (cache hit above 80 percent, no category anomalies), say the
session is already efficient and recommend nothing.

## Troubleshooting

| Error | Cause | Fix |
|-------|-------|-----|
| `No sessions recorded` or empty report | No measured sessions yet | Run a session via `vertex-token-proxy start` first |
| Report shows 0 turns | Claude Code launched directly, not via proxy | Relaunch with `vertex-token-proxy start` |
| Numbers look stale | Reading an old session | Use `vertex-token-proxy report --all` to see all sessions |
```

- [ ] **Step 2: Write the example walkthrough**

Write `vertex-token-proxy/examples/analyze-report-example.md`:

```markdown
# Example: analyzing a session report

Sample (abridged) output of `vertex-token-proxy report`:

```text
Session: 2026-06-10-a1b2c3
Model: claude-opus-4-6
Turns: 42

TOKEN USAGE (Vertex AI reported)
  Input (uncached):     412,000 tokens
  Input (cache read):   1,950,000 tokens
  Input (cache write):  310,000 tokens
  Output:               88,000 tokens
  Estimated cost:       $7.13
  Cache hit rate:       73.0%
  Cache breaks:         4 (~280,000 tokens re-cached, $1.75)

INPUT BREAKDOWN (tiktoken estimate)
  system_prompt             190,000 (7.1%)
  tool_schemas              540,000 (20.2%)
  conversation_history      980,000 (36.7%)
  user_input                 61,000 (2.3%)
  tool_results              880,000 (33.0%)
  thinking_config            19,000 (0.7%)

REPETITION ANALYSIS
  System prompt unchanged: 41/42 turns
  Tool schemas unchanged:  38/42 turns
  Repeated tokens total:   1,430,000
  Cost if uncached:        $7.15

DRY-RUN COMPRESSION
  json_dedup_savings        96,000 tokens
  log_compression_savings   41,000 tokens
  whitespace_savings        12,000 tokens
  Total compressible:       149,000 tokens
  Potential savings:        $0.75
```

What the skill concludes from this:

- `tool_schemas` at 20.2 percent crosses the 15 percent threshold: MCP
  schema bloat is the top finding.
- 4 cache breaks wasting $1.75 and tool schemas unchanged only 38/42 turns:
  something is changing the tool set mid-session, which both breaks the
  cache and re-sends schemas.
- `tool_results` at 33 percent is under the 40 percent threshold: no action.

```text
TOP RECOMMENDATIONS
1. Disable unused MCP servers (tool_schemas is 20.2% of input, ~540K
   tokens/session). Run `claude mcp list` and turn off what you don't use.
2. Stop mid-session tool set changes (4 cache breaks, $1.75/session
   wasted). Enable all needed MCP servers before starting the session.
```
```

- [ ] **Step 3: Commit**

```bash
git add vertex-token-proxy/skills/analyze-report/SKILL.md vertex-token-proxy/examples/analyze-report-example.md
git commit -m "Add vertex-token-proxy analyze-report skill with worked example

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

### Task 4: compare skill

**Files:**
- Create: `vertex-token-proxy/skills/compare/SKILL.md`

- [ ] **Step 1: Write SKILL.md**

Write `vertex-token-proxy/skills/compare/SKILL.md`:

```markdown
---
name: vertex-token-proxy:compare
description: This skill should be used when the user asks to "compare two sessions", "did my change reduce tokens", "A/B test my Claude Code config", "compare token usage before and after", or "vertex-token-proxy compare".
---

---
context: main
---

# Skill: compare

**Name:** Session A/B Comparison
**Description:** Compare two measured sessions and explain whether a configuration change actually reduced token usage or cost.

---

## Purpose

Guide an A/B test: the user runs a baseline session, changes one thing
(disables an MCP server, trims CLAUDE.md, switches model), runs a second
session, and this skill explains the delta.

## What You'll Need Before Starting

**Required:**
- vertex-token-proxy installed with at least two recorded sessions
- Knowledge of what changed between the two sessions (ask if unclear)

## When to Use

**Use this skill when you want to:**
- Verify a config change reduced tokens or cost
- Compare any two recorded sessions

**Don't use this for:**
- Single-session analysis -> use `/vertex-token-proxy:analyze-report`

## Workflow

### Step 1: List available sessions

```bash
jq -r '.sessions[].session_id' ~/.vertex-token-proxy/metrics.json
```

If fewer than two sessions exist, explain the A/B workflow (baseline
session, one change, second session) and stop.

### Step 2: Pick sessions

Ask ONE question and wait:

> Compare the two most recent sessions, or pick two by id?
> (recent / pick, default recent)

Also ask what changed between A and B if the user has not said.

### Step 3: Run the comparison

```bash
vertex-token-proxy compare           # two most recent (A = older, B = newer)
vertex-token-proxy compare A B       # by session id
```

### Step 4: Interpret the deltas

The output is a table with columns A, B, and delta (with percent). Apply:

- Lead with `Estimated cost $`: that is the answer to "did it help".
- Normalize by `Turns` when they differ by more than 20 percent: compare
  per-turn input rather than totals, and say you are doing so.
- Tie the delta to the user's change: an MCP server removal should show up
  in lower input per turn; a CLAUDE.md trim shows up in lower uncached
  input on turn one and fewer repeated tokens.
- Check `Cache hit rate %` and `Cache breaks` moved in the right direction;
  a config change that breaks caching can cost more even with fewer tokens.
- Call out confounds honestly: different tasks, different turn counts, or
  different models make sessions only loosely comparable. If the sessions
  are not comparable, say so rather than overinterpreting.

### Step 5: Verdict

End with one of exactly three verdicts, plus the single strongest number:

- "The change helped: <metric> improved by <delta>."
- "The change hurt: <metric> regressed by <delta>."
- "Inconclusive: the sessions differ too much in <confound> to attribute
  the delta to your change. Re-run with similar tasks."

## Troubleshooting

| Error | Cause | Fix |
|-------|-------|-----|
| Session id not found | Typo or cleared metrics | List ids via the jq command in Step 1 |
| Only one session exists | No baseline yet | Run a second measured session, then re-run |
| Deltas all near zero | Change had no effect, or both sessions used cache heavily | Check `Cache hit rate %` row before concluding |
```

- [ ] **Step 2: Commit**

```bash
git add vertex-token-proxy/skills/compare/SKILL.md
git commit -m "Add vertex-token-proxy compare skill for A/B session testing

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

### Task 5: SessionStart hook

**Files:**
- Create: `vertex-token-proxy/hooks/hooks.json`
- Create: `vertex-token-proxy/hooks/check-proxy.sh`

- [ ] **Step 1: Write hooks.json**

Write `vertex-token-proxy/hooks/hooks.json` (auto-discovered at this path by the plugin loader):

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/check-proxy.sh"
          }
        ]
      }
    ]
  }
}
```

- [ ] **Step 2: Write check-proxy.sh**

Write `vertex-token-proxy/hooks/check-proxy.sh`:

```bash
#!/usr/bin/env bash
# SessionStart hook for the vertex-token-proxy plugin.
# Silent unless: Vertex session AND proxy installed AND session unmeasured.
# Cannot start measurement itself: ANTHROPIC_VERTEX_BASE_URL must be set
# before Claude Code launches, so the most this hook can do is remind.

[ -n "${CLAUDE_CODE_USE_VERTEX:-}" ] || exit 0
command -v vertex-token-proxy >/dev/null 2>&1 || exit 0

case "${ANTHROPIC_VERTEX_BASE_URL:-}" in
  *localhost:8787*|*127.0.0.1:8787*)
    # Routed through the proxy. Confirm it is actually listening.
    if curl -s -o /dev/null --max-time 1 "http://127.0.0.1:8787/" 2>/dev/null; then
      exit 0
    fi
    echo "vertex-token-proxy: this session points at the proxy but nothing is listening on port 8787. Restart with: vertex-token-proxy stop && vertex-token-proxy start"
    exit 0
    ;;
esac

echo "vertex-token-proxy is installed but this session is not being measured. Run 'vertex-token-proxy start' to launch a measured Claude Code session."
exit 0
```

- [ ] **Step 3: Make executable and validate JSON**

```bash
chmod +x vertex-token-proxy/hooks/check-proxy.sh
jq . vertex-token-proxy/hooks/hooks.json > /dev/null && echo OK
bash -n vertex-token-proxy/hooks/check-proxy.sh && echo SYNTAX-OK
```

Expected: `OK` then `SYNTAX-OK`

- [ ] **Step 4: Test the four behavior cases**

```bash
H=vertex-token-proxy/hooks/check-proxy.sh
# Case 1 - non-Vertex session: silent
env -u CLAUDE_CODE_USE_VERTEX bash "$H"
# Case 2 - Vertex but proxy binary missing: silent
CLAUDE_CODE_USE_VERTEX=1 PATH=/usr/bin:/bin bash "$H"
# Case 3 - Vertex, binary present, not routed: one reminder line
mkdir -p /tmp/vtp-fake && printf '#!/bin/sh\nexit 0\n' > /tmp/vtp-fake/vertex-token-proxy && chmod +x /tmp/vtp-fake/vertex-token-proxy
CLAUDE_CODE_USE_VERTEX=1 PATH="/tmp/vtp-fake:$PATH" ANTHROPIC_VERTEX_BASE_URL= bash "$H"
# Case 4 - routed but port 8787 dead: one restart line
CLAUDE_CODE_USE_VERTEX=1 PATH="/tmp/vtp-fake:$PATH" ANTHROPIC_VERTEX_BASE_URL=http://localhost:8787 bash "$H"
rm -rf /tmp/vtp-fake
```

Expected: cases 1 and 2 print nothing; case 3 prints the "not being measured" line; case 4 prints the "nothing is listening" line (assuming no local proxy is running on 8787 — if one is, case 4 is silent, which is also correct).

- [ ] **Step 5: Commit**

```bash
git add vertex-token-proxy/hooks/hooks.json vertex-token-proxy/hooks/check-proxy.sh
git commit -m "Add SessionStart hook that flags unmeasured Vertex sessions

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

### Task 6: Skill feedback issue template

**Files:**
- Create: `.github/ISSUE_TEMPLATE/skill-feedback.yml`

- [ ] **Step 1: Write the template**

Generic for any marketplace skill, not just this plugin:

```yaml
name: Skill feedback
description: Report a problem or suggest an improvement for a marketplace skill
title: "[skill-feedback] "
labels: ["skill-feedback"]
body:
  - type: dropdown
    id: skill
    attributes:
      label: Which skill?
      options:
        - showroom:create-lab
        - showroom:create-demo
        - showroom:verify-content
        - showroom:blog-generate
        - agnosticv:catalog-builder
        - agnosticv:validator
        - health:deployment-validator
        - ftl:rhdp-lab-validator
        - vertex-token-proxy:setup
        - vertex-token-proxy:analyze-report
        - vertex-token-proxy:compare
        - Other / not listed
    validations:
      required: true
  - type: textarea
    id: what-happened
    attributes:
      label: What happened?
      description: What did the skill do? Include the prompt you used if relevant. Do not paste credentials, tokens, or internal hostnames.
    validations:
      required: true
  - type: textarea
    id: expected
    attributes:
      label: What did you expect?
    validations:
      required: true
  - type: input
    id: environment
    attributes:
      label: Environment
      placeholder: "Claude Code 2.x / Cursor 2.4, macOS 15, plugin version"
    validations:
      required: false
```

- [ ] **Step 2: Validate YAML**

Run: `python3 -c "import yaml,sys; yaml.safe_load(open('.github/ISSUE_TEMPLATE/skill-feedback.yml')); print('OK')"`
Expected: `OK` (if PyYAML is unavailable, use `ruby -ryaml -e "YAML.load_file('.github/ISSUE_TEMPLATE/skill-feedback.yml'); puts 'OK'"`)

- [ ] **Step 3: Commit**

```bash
git add .github/ISSUE_TEMPLATE/skill-feedback.yml
git commit -m "Add skill feedback issue template for all marketplace skills

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

### Task 7: Docs pages, diagrams, and navigation

**Files:**
- Create: `docs/skills/vertex-setup.md`
- Create: `docs/skills/vertex-analyze-report.md`
- Create: `docs/skills/vertex-compare.md`
- Create: `docs/skills/vertex-setup-workflow.svg`
- Create: `docs/skills/vertex-analyze-report-workflow.svg`
- Create: `docs/skills/vertex-compare-workflow.svg`
- Modify: `docs/_layouts/default.html` (sidebar nav, around line 77-82, the "FTL & Health" section)
- Modify: `docs/index.md` (skill counts and category grid)
- Modify: `docs/skills/index.md` (add a vertex-token-proxy section)

- [ ] **Step 1: Write the three workflow SVGs**

All three use the existing diagram style (see `docs/skills/validator-workflow.svg`): blue `.input`, green `.process`, orange `.output` boxes, vertical flow with arrows. Shared SVG skeleton — reuse this exact `<defs>` block in each file:

```xml
<defs>
  <style>
    .input { fill: #0066CC; }
    .process { fill: #00AA00; }
    .output { fill: #FF8800; }
    text { fill: white; font-family: Arial, sans-serif; font-size: 14px; }
    .arrow { stroke: #333; stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
    .title { font-size: 18px; font-weight: bold; fill: #333; }
  </style>
  <marker id="arrowhead" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
    <polygon points="0 0, 10 3, 0 6" fill="#333" />
  </marker>
</defs>
```

`docs/skills/vertex-setup-workflow.svg` (full file):

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 560">
  <!-- defs block from above -->
  <text x="400" y="30" text-anchor="middle" class="title">/vertex-token-proxy:setup</text>
  <rect x="250" y="50" width="300" height="50" rx="8" class="input"/>
  <text x="400" y="80" text-anchor="middle">Verify Vertex AI environment</text>
  <path class="arrow" d="M400,100 L400,130"/>
  <rect x="250" y="130" width="300" height="50" rx="8" class="process"/>
  <text x="400" y="160" text-anchor="middle">Check Python 3.12+ and uv</text>
  <path class="arrow" d="M400,180 L400,210"/>
  <rect x="250" y="210" width="300" height="50" rx="8" class="process"/>
  <text x="400" y="240" text-anchor="middle">Clone and uv pip install</text>
  <path class="arrow" d="M400,260 L400,290"/>
  <rect x="250" y="290" width="300" height="50" rx="8" class="process"/>
  <text x="400" y="320" text-anchor="middle">Ask: install status line?</text>
  <path class="arrow" d="M400,340 L400,370"/>
  <rect x="250" y="370" width="300" height="50" rx="8" class="process"/>
  <text x="400" y="400" text-anchor="middle">vertex-token-proxy start</text>
  <path class="arrow" d="M400,420 L400,450"/>
  <rect x="250" y="450" width="300" height="50" rx="8" class="output"/>
  <text x="400" y="480" text-anchor="middle">Verified: session measured on :8787</text>
</svg>
```

`docs/skills/vertex-analyze-report-workflow.svg` (same skeleton, these nodes): input "Confirm metrics.json exists" -> process "Ask scope: latest or all" -> process "Run vertex-token-proxy report" -> process "Apply section heuristics" -> output "Top 1-3 prioritized recommendations". Full file:

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 480">
  <!-- defs block from above -->
  <text x="400" y="30" text-anchor="middle" class="title">/vertex-token-proxy:analyze-report</text>
  <rect x="250" y="50" width="300" height="50" rx="8" class="input"/>
  <text x="400" y="80" text-anchor="middle">Confirm metrics.json exists</text>
  <path class="arrow" d="M400,100 L400,130"/>
  <rect x="250" y="130" width="300" height="50" rx="8" class="process"/>
  <text x="400" y="160" text-anchor="middle">Ask scope: latest or all</text>
  <path class="arrow" d="M400,180 L400,210"/>
  <rect x="250" y="210" width="300" height="50" rx="8" class="process"/>
  <text x="400" y="240" text-anchor="middle">Run vertex-token-proxy report</text>
  <path class="arrow" d="M400,260 L400,290"/>
  <rect x="250" y="290" width="300" height="50" rx="8" class="process"/>
  <text x="400" y="320" text-anchor="middle">Apply section heuristics</text>
  <path class="arrow" d="M400,340 L400,370"/>
  <rect x="250" y="370" width="300" height="50" rx="8" class="output"/>
  <text x="400" y="400" text-anchor="middle">Top 1-3 prioritized recommendations</text>
</svg>
```

`docs/skills/vertex-compare-workflow.svg` (full file):

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 480">
  <!-- defs block from above -->
  <text x="400" y="30" text-anchor="middle" class="title">/vertex-token-proxy:compare</text>
  <rect x="250" y="50" width="300" height="50" rx="8" class="input"/>
  <text x="400" y="80" text-anchor="middle">List session ids from metrics.json</text>
  <path class="arrow" d="M400,100 L400,130"/>
  <rect x="250" y="130" width="300" height="50" rx="8" class="process"/>
  <text x="400" y="160" text-anchor="middle">Pick A and B (default: two most recent)</text>
  <path class="arrow" d="M400,180 L400,210"/>
  <rect x="250" y="210" width="300" height="50" rx="8" class="process"/>
  <text x="400" y="240" text-anchor="middle">Run vertex-token-proxy compare</text>
  <path class="arrow" d="M400,260 L400,290"/>
  <rect x="250" y="290" width="300" height="50" rx="8" class="process"/>
  <text x="400" y="320" text-anchor="middle">Interpret deltas, check confounds</text>
  <path class="arrow" d="M400,340 L400,370"/>
  <rect x="250" y="370" width="300" height="50" rx="8" class="output"/>
  <text x="400" y="400" text-anchor="middle">Verdict: helped / hurt / inconclusive</text>
</svg>
```

In each file, replace the `<!-- defs block from above -->` comment with the actual shared `<defs>` block.

- [ ] **Step 2: Write the three docs pages**

Each follows the agnosticv-validator page pattern: frontmatter, title, reference badge, intro, clickable SVG, Quick Start, How It Works steps, troubleshooting, related skills, and the new Feedback link.

`docs/skills/vertex-setup.md`:

```markdown
---
layout: default
title: /vertex-token-proxy:setup
---

# /vertex-token-proxy:setup

<div class="reference-badge">📡 Token Measurement Setup</div>

Install and start [vertex-token-proxy](https://github.com/rhpds/vertex-token-proxy) so your Claude Code sessions on Google Vertex AI are measured: token counts by category, repetition detection, projected compression savings, and live cost in your status line. No requests are ever modified.

<div style="margin: 1rem 0;">
  <a href="vertex-setup-workflow.svg" target="_blank">
    <img src="vertex-setup-workflow.svg" alt="setup workflow diagram" style="max-width: 100%; height: auto; border-radius: 8px; border: 1px solid #e1e4e8;" />
  </a>
</div>

---

## Quick Start

```text
/vertex-token-proxy:setup
```

---

## How It Works

1. **Verifies you are on Vertex AI** — the proxy only applies to `CLAUDE_CODE_USE_VERTEX` sessions.
2. **Checks prerequisites** — Python 3.12+ and uv.
3. **Installs the proxy** — clones the repo and runs `uv pip install -e .`.
4. **Asks about the status line** — live token counts and cost in your terminal; wraps any existing status line rather than replacing it.
5. **Starts a measured session** — `vertex-token-proxy start` launches Claude Code routed through `localhost:8787` and verifies with `vertex-token-proxy status`.

The proxy binds to 127.0.0.1 only, never logs request content, and stores only aggregated numbers and SHA-256 hashes in `~/.vertex-token-proxy/metrics.json`.

---

## Bundled SessionStart Hook

The plugin includes a hook that stays silent unless you are on Vertex, the proxy is installed, and the current session is not being measured — in which case it prints one reminder to relaunch via `vertex-token-proxy start`. Measurement cannot start mid-session because the routing variable must be set before Claude Code launches.

---

## Related Skills

- [`/vertex-token-proxy:analyze-report`](vertex-analyze-report.html) — interpret your metrics
- [`/vertex-token-proxy:compare`](vertex-compare.html) — A/B test config changes

---

## Feedback

Found a problem or have a suggestion? [Open a skill-feedback issue](https://github.com/rhpds/rhdp-skills-marketplace/issues/new?template=skill-feedback.yml&labels=vertex-token-proxy).
```

`docs/skills/vertex-analyze-report.md`:

```markdown
---
layout: default
title: /vertex-token-proxy:analyze-report
---

# /vertex-token-proxy:analyze-report

<div class="reference-badge">📊 Token Spend Analysis</div>

Run a vertex-token-proxy session report and get judgment, not just numbers: which costs dominate, what is healthy versus wasteful, and the 2–3 highest-impact changes to cut token spend.

<div style="margin: 1rem 0;">
  <a href="vertex-analyze-report-workflow.svg" target="_blank">
    <img src="vertex-analyze-report-workflow.svg" alt="analyze-report workflow diagram" style="max-width: 100%; height: auto; border-radius: 8px; border: 1px solid #e1e4e8;" />
  </a>
</div>

---

## Quick Start

```text
/vertex-token-proxy:analyze-report
```

Requires at least one measured session — run [`/vertex-token-proxy:setup`](vertex-setup.html) first.

---

## What It Checks

| Report section | Heuristics applied |
|---|---|
| TOKEN USAGE | Cache hit rate below 70% and cache breaks above 2 per session get flagged with the wasted dollars |
| INPUT BREAKDOWN | `tool_schemas` above 15% (MCP bloat), `tool_results` above 40% (verbose output), `system_prompt` above 20% (oversized instructions) |
| REPETITION ANALYSIS | Distinguishes repetition absorbed by caching (fine) from re-billed repetition (expensive) |
| DRY-RUN COMPRESSION | Reports projected savings as an upper bound and identifies the dominant compressor |
| LATENCY | Flags proxy overhead only if it exceeds 5% of total latency |

Output ends with at most three recommendations, each tied to a number from the report and ordered by estimated savings. A healthy session gets told it is healthy — no invented recommendations.

See the [worked example](https://github.com/rhpds/rhdp-skills-marketplace/blob/main/vertex-token-proxy/examples/analyze-report-example.md) with sample report output and the conclusions drawn from it.

---

## Related Skills

- [`/vertex-token-proxy:setup`](vertex-setup.html) — install and start the proxy
- [`/vertex-token-proxy:compare`](vertex-compare.html) — verify a change helped

---

## Feedback

Found a problem or have a suggestion? [Open a skill-feedback issue](https://github.com/rhpds/rhdp-skills-marketplace/issues/new?template=skill-feedback.yml&labels=vertex-token-proxy).
```

`docs/skills/vertex-compare.md`:

```markdown
---
layout: default
title: /vertex-token-proxy:compare
---

# /vertex-token-proxy:compare

<div class="reference-badge">⚖️ A/B Session Comparison</div>

Did disabling that MCP server actually save tokens? Run a baseline session, change one thing, run another session, and this skill explains the delta — cost first, confounds called out honestly.

<div style="margin: 1rem 0;">
  <a href="vertex-compare-workflow.svg" target="_blank">
    <img src="vertex-compare-workflow.svg" alt="compare workflow diagram" style="max-width: 100%; height: auto; border-radius: 8px; border: 1px solid #e1e4e8;" />
  </a>
</div>

---

## Quick Start

```text
/vertex-token-proxy:compare
```

Defaults to the two most recent sessions; you can also pick any two by session id.

---

## How It Works

1. **Lists sessions** from `~/.vertex-token-proxy/metrics.json`.
2. **Asks what changed** between A and B if you have not said.
3. **Runs `vertex-token-proxy compare`** — a side-by-side table of turns, input/output tokens, cache hit rate, cache breaks, repeated tokens, compressible tokens, cost, and latency with deltas.
4. **Interprets honestly** — normalizes by turn count when sessions differ in length, ties the delta to your specific change, and checks that caching did not silently regress.
5. **Delivers one of three verdicts** — helped, hurt, or inconclusive (with the confound named).

---

## Related Skills

- [`/vertex-token-proxy:analyze-report`](vertex-analyze-report.html) — single-session deep dive
- [`/vertex-token-proxy:setup`](vertex-setup.html) — install and start the proxy

---

## Feedback

Found a problem or have a suggestion? [Open a skill-feedback issue](https://github.com/rhpds/rhdp-skills-marketplace/issues/new?template=skill-feedback.yml&labels=vertex-token-proxy).
```

- [ ] **Step 3: Add sidebar navigation section**

In `docs/_layouts/default.html`, after the "FTL &amp; Health" nav-section `</div>` (around line 82) and before the "Reference" section, insert:

```html
        <div class="nav-section">
          <span class="nav-section-label">Vertex Token Proxy</span>
          <ul>
            <li><a href="{{ '/skills/vertex-setup.html' | relative_url }}"><span class="nav-icon">📡</span> Setup</a></li>
            <li><a href="{{ '/skills/vertex-analyze-report.html' | relative_url }}"><span class="nav-icon">📊</span> Analyze Report</a></li>
            <li><a href="{{ '/skills/vertex-compare.html' | relative_url }}"><span class="nav-icon">⚖️</span> Compare Sessions</a></li>
          </ul>
        </div>
```

- [ ] **Step 4: Update home page counts and category grid**

In `docs/index.md`:

1. Change the section-header line `8 skills · 10 agents · 4 namespaces — orchestrator pattern with parallel execution` to `11 skills · 10 agents · 5 namespaces — orchestrator pattern with parallel execution`. (First verify the current agent count is still 10 — grep the file; if it changed, keep that number.)
2. Add a new category card inside the `category-grid` div, after the last existing card, matching the existing card markup:

```html
    <div class="category-card">
      <span class="category-icon">📡</span>
      <h3>Vertex Token Proxy — Token Spend Measurement</h3>
      <p><strong>Where are my tokens going?</strong> Measure Claude Code sessions on Google Vertex AI — token counts by category, repetition detection, projected savings — then get concrete recommendations and A/B verification.</p>
      <ul style="margin: 0.875rem 0; color: var(--color-text-3); font-size: 0.875rem;">
        <li><code>/vertex-token-proxy:setup</code> — Install and start measurement</li>
        <li><code>/vertex-token-proxy:analyze-report</code> — Prioritized savings recommendations</li>
        <li><code>/vertex-token-proxy:compare</code> — A/B test config changes</li>
      </ul>
      <a href="{{ '/skills/vertex-setup.html' | relative_url }}">Learn more →</a>
    </div>
```

- [ ] **Step 5: Add a section to the skills index**

In `docs/skills/index.md`, after the last existing skill section, add (matching the existing category-grid card markup used on that page):

```html
## Vertex Token Proxy Skills (Cost Optimization)

<div class="category-intro">
For measuring and reducing Claude Code token spend on Google Vertex AI.
</div>

<div class="category-grid">
  <a href="vertex-setup.html" class="category-card">
    <div class="category-icon">📡</div>
    <h3>/vertex-token-proxy:setup</h3>
    <p>Install the proxy and launch a measured Claude Code session.</p>
    <div class="skill-meta">
      <div class="meta-item">
        <strong>Before:</strong> Claude Code on Vertex AI, Python 3.12+, uv
      </div>
      <div class="meta-item">
        <strong>Use when:</strong> Starting token measurement
      </div>
    </div>
    <div class="skill-status available">✅ Available</div>
  </a>

  <a href="vertex-analyze-report.html" class="category-card">
    <div class="category-icon">📊</div>
    <h3>/vertex-token-proxy:analyze-report</h3>
    <p>Turn session metrics into prioritized token-saving recommendations.</p>
    <div class="skill-meta">
      <div class="meta-item">
        <strong>Before:</strong> At least one measured session
      </div>
      <div class="meta-item">
        <strong>Use when:</strong> Tokens or cost seem high
      </div>
    </div>
    <div class="skill-status available">✅ Available</div>
  </a>

  <a href="vertex-compare.html" class="category-card">
    <div class="category-icon">⚖️</div>
    <h3>/vertex-token-proxy:compare</h3>
    <p>A/B compare two sessions to verify a config change helped.</p>
    <div class="skill-meta">
      <div class="meta-item">
        <strong>Before:</strong> Two measured sessions
      </div>
      <div class="meta-item">
        <strong>Use when:</strong> Verifying an optimization
      </div>
    </div>
    <div class="skill-status available">✅ Available</div>
  </a>
</div>
```

Note: existing cards on this page use namespace CSS classes like `category-card showroom`; check whether a generic `category-card` renders correctly (it does — the namespace class only adds an accent color). Keep `category-card` without a namespace class.

- [ ] **Step 6: Build the docs site (or fallback link check)**

```bash
cd docs && bundle exec jekyll build 2>&1 | tail -5
```

Expected: build succeeds. If Jekyll/bundler is not installed locally, fall back to verifying every referenced path exists:

```bash
ls docs/skills/vertex-setup.md docs/skills/vertex-analyze-report.md docs/skills/vertex-compare.md docs/skills/vertex-setup-workflow.svg docs/skills/vertex-analyze-report-workflow.svg docs/skills/vertex-compare-workflow.svg
grep -c "vertex-" docs/_layouts/default.html   # expect 3 nav links
```

- [ ] **Step 7: Commit**

```bash
git add docs/skills/vertex-*.md docs/skills/vertex-*-workflow.svg docs/_layouts/default.html docs/index.md docs/skills/index.md
git commit -m "Add docs pages, diagrams, and navigation for vertex-token-proxy skills

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

### Task 8: Changelog, final validation, and PR prep

**Files:**
- Modify: `CHANGELOG.md` (new entry at top, matching existing entry format — read the top entry first and mirror its heading style)

- [ ] **Step 1: Add changelog entry**

Read the top of `CHANGELOG.md` and mirror its format for a new entry describing: new vertex-token-proxy plugin (3 skills), first SessionStart hook in the marketplace, new skill-feedback issue template, docs pages.

- [ ] **Step 2: Full-tree validation**

```bash
jq . .claude-plugin/marketplace.json > /dev/null && echo MARKETPLACE-OK
jq . vertex-token-proxy/.claude-plugin/plugin.json > /dev/null && echo PLUGIN-OK
jq . vertex-token-proxy/hooks/hooks.json > /dev/null && echo HOOKS-OK
bash -n vertex-token-proxy/hooks/check-proxy.sh && echo SCRIPT-OK
test -x vertex-token-proxy/hooks/check-proxy.sh && echo EXEC-OK
grep -rn "redhat.com\|10\.\|192.168" vertex-token-proxy/ --include="*.md" | grep -v "github.com\|docs.astral.sh\|rhpds.github.io" || echo NO-LEAKS
```

Expected: all OK lines and `NO-LEAKS` (the grep guards against accidental internal hostnames/IPs in a public repo).

- [ ] **Step 3: Local plugin smoke test**

```bash
claude --plugin-dir ./vertex-token-proxy --print "List the skills available under the vertex-token-proxy namespace" 2>&1 | head -20
```

Expected: the three skills are discoverable. If `--plugin-dir` is unsupported in the installed CLI version, document manual testing instead: add the marketplace as a local dir (`/plugin marketplace add ./`) in an interactive session and run `/vertex-token-proxy:setup`.

- [ ] **Step 4: Commit and stop before pushing**

```bash
git add CHANGELOG.md
git commit -m "Add changelog entry for vertex-token-proxy plugin

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
git status && git log --oneline main..HEAD
```

DO NOT PUSH. Per workspace CLAUDE.md, pushing and opening the PR require explicit user approval. Present the branch summary and proposed PR description to the user, then use superpowers:finishing-a-development-branch.
