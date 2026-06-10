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
