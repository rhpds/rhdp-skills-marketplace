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
