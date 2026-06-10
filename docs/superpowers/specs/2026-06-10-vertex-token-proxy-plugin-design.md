# vertex-token-proxy Plugin — Design

Date: 2026-06-10
Status: Approved by user, pending spec review

## Purpose

Contribute a new plugin to the RHDP Skills Marketplace for
[vertex-token-proxy](https://github.com/rhpds/vertex-token-proxy), a local
reverse proxy that measures token usage for Claude Code sessions routed
through Google Vertex AI. The plugin serves two audiences: users who need
help installing and running the proxy, and users who want help interpreting
its metrics to reduce token spend.

## Decisions made

- Namespace: `vertex-token-proxy` (matches the CLI binary name, the same
  convention `sandbox-cli` uses).
- Structural pattern: strict mirror of the `sandbox-cli` plugin (flat
  `skills/` directories, `examples/`, README, `.claude-plugin/plugin.json`),
  plus two additions new to this marketplace: a SessionStart hook and a
  feedback mechanism.
- Rejected: showroom-style subagents (the CLI already does the computation;
  agents add ceremony without value) and hosting the plugin in the
  vertex-token-proxy repo itself (every marketplace plugin lives in this
  repo and is registered in `marketplace.json`).

## Components

### Plugin layout

```
vertex-token-proxy/
  .claude-plugin/plugin.json        # name, version 1.0.0, description, author
  README.md                         # what it is, install, skill list
  skills/
    setup/SKILL.md                  # /vertex-token-proxy:setup
    analyze-report/SKILL.md         # /vertex-token-proxy:analyze-report
    compare/SKILL.md                # /vertex-token-proxy:compare
  examples/
    analyze-report-example.md       # sample metrics walkthrough
  hooks/
    hooks.json                      # SessionStart hook registration
    check-proxy.sh                  # detection script
```

Plus a new entry in `.claude-plugin/marketplace.json` with tags
(`vertex`, `tokens`, `metrics`, `cost`, `proxy`).

### Skills

All three follow the sandbox-cli SKILL.md template: double YAML frontmatter
(identity block with `name: vertex-token-proxy:<skill>` and trigger phrases
in the description; execution block with `context: main`), numbered workflow
steps, exact bash commands, expected output samples, and a troubleshooting
table.

1. **setup** — Check prerequisites (Python 3.12+, uv, `CLAUDE_CODE_USE_VERTEX`
   set), clone and `uv pip install -e .` the proxy, run
   `vertex-token-proxy start` (asking the user about status line preference
   first), verify with `vertex-token-proxy status`. Troubleshooting covers:
   port 8787 already in use, uv missing, user not on Vertex.
2. **analyze-report** — Run `vertex-token-proxy report` (or `report --all`
   when the user asks about all sessions), then interpret the output: flag
   repetition hotspots, MCP schema bloat, and projected compression savings.
   Ends with 2–3 concrete, prioritized recommendations (for example,
   "disable MCP server X, it accounts for N% of every request").
3. **compare** — Guide A/B testing: list available sessions, pick A and B
   (default: the two most recent), run `vertex-token-proxy compare`, explain
   the delta and whether the user's change helped.

### SessionStart hook

`check-proxy.sh` runs at session start and must be fast and silent by
default. It emits output only when ALL of the following hold:

- Vertex environment detected (`CLAUDE_CODE_USE_VERTEX` set)
- `vertex-token-proxy` is installed on PATH
- The session is not being measured: either the proxy is not running, or
  `ANTHROPIC_VERTEX_BASE_URL` does not point at `localhost:8787`

When triggered it prints one line: the proxy is installed but this session
is not being measured; run `vertex-token-proxy start` to launch a measured
session. Constraint discovered during design: the proxy sets
`ANTHROPIC_VERTEX_BASE_URL` before Claude Code launches, so a hook cannot
begin measurement mid-session — detection and a reminder are the most it
can do.

### Documentation

- One page per skill in `docs/skills/` following the existing pattern:
  workflow SVG diagram, When to Use / Don't Use, steps, troubleshooting.
- Sidebar navigation entries and updates to the home page counts
  (8 skills to 11, 4 namespaces to 5).
- No separate page in `docs/setup/`: installation is fully covered by the
  setup skill's docs page, and `docs/setup/` is reserved for
  platform-install guides (Claude Code, Cursor), not per-plugin setup.

### Feedback mechanism

- `.github/ISSUE_TEMPLATE/skill-feedback.yml` — a structured template
  (which skill, what happened, expected behavior, environment) usable for
  any marketplace skill, not just this plugin.
- Each of the plugin's docs pages gets a Feedback link to
  `https://github.com/rhpds/rhdp-skills-marketplace/issues/new?template=skill-feedback.yml&labels=vertex-token-proxy`.

## Security constraints

This is a public repository. The plugin must use placeholders only — no
real tokens, internal hostnames, or project IDs in SKILL.md files, examples,
or docs. The proxy itself never logs request content; skills must not ask
users to paste credentials.

## Testing

- Install the plugin locally (`claude --plugin-dir ./vertex-token-proxy`
  or marketplace dev install) and run each skill end to end against a real
  proxy session.
- Verify the hook stays silent in: non-Vertex sessions, sessions where the
  proxy is not installed, and measured sessions; verify it emits its one
  line in an unmeasured Vertex session.
- Validate `plugin.json` and `marketplace.json` syntax; build the Jekyll
  docs site locally to confirm new pages render and nav links resolve.

## Out of scope

- Subagents, MCP servers, or any change to the vertex-token-proxy CLI itself.
- Auto-starting the proxy from the hook (technically impossible mid-session;
  also too intrusive).
