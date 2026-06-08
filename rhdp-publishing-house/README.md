# RHDP Publishing House Skills

Claude Code plugin for AI-powered content lifecycle management on Red Hat Demo Platform.

## Installation

```bash
git clone git@github.com:rhpds/rhdp-publishing-house-skills.git ~/rhdp-publishing-house-skills
claude --plugin-dir ~/rhdp-publishing-house-skills
```

Or add the plugin directory to your Claude Code settings to load it automatically.

## Usage

Run from your project directory:

```
/rhdp-publishing-house
```

The orchestrator checks the current directory for your project manifest, syncs the repo, and picks up where you left off. If no project is found, it offers to locate it by path, clone it from a remote, or walk you through creating a new one from the template.

## Skills

| Skill | Description |
|-------|-------------|
| `/rhdp-publishing-house` | Orchestrator — discovers project, syncs repo, reads state, manages repo setup at phase gates, routes to agents |
| `/rhdp-publishing-house:intake` | Spec generation, RCARS vetting, spec refinement |
| `/rhdp-publishing-house:writer` | Content writing (wraps Showroom skills, module-by-module) |
| `/rhdp-publishing-house:editor` | Technical editing and quality review (wraps showroom:verify-content) |
| `/rhdp-publishing-house:automation` | Automation requirements, catalog, code, and testing gate |
| `/rhdp-publishing-house:worklog` | Session bridging — notes, decisions, handoffs, summaries |

## Documentation

Full documentation lives in the [dev repo](https://github.com/rhpds/rhdp-publishing-house/tree/main/docs):

- [Getting Started](https://github.com/rhpds/rhdp-publishing-house/blob/main/docs/getting-started.md)
- [How It Works](https://github.com/rhpds/rhdp-publishing-house/blob/main/docs/how-it-works.md)
- [Portal](https://github.com/rhpds/rhdp-publishing-house/blob/main/docs/portal.md)
