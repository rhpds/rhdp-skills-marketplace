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
