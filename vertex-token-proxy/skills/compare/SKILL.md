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
