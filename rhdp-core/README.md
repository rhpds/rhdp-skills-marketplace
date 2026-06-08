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
