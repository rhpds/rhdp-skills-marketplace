---
name: showroom:create-demo
description: This skill should be used when the user asks to "create a demo module", "write a Know/Show demo", "build a presenter demo", "create a Showroom demo", "write a facilitator guide", "build a demo script", or "create a presenter-led demo for RHDP".
---

---
context: main
model: claude-sonnet-4-6
---

# Demo Module Generator

Orchestrates agents to create Red Hat Showroom presenter-led demo content using the Know/Show structure. Two modes: interactive (human) and headless (Publishing House via ph_payload).

## Architecture

This skill is an orchestrator. Generation and review are delegated to agents:
- `showroom:file-generator` (Sonnet) — generates one AsciiDoc file, runs in parallel for new demos
- `showroom:module-reviewer` (Sonnet) — quality check on generated files

The orchestrator handles: argument parsing, repo detection, planning, agent spawning, nav merge, delivery.

## Know/Show Structure

Demos separate what presenters need to **understand** from what they need to **do**:
- **Know sections**: Business context, customer pain points, value propositions
- **Show sections**: Step-by-step presenter instructions, what to click/run, expected outcomes

See `@showroom/skills/create-demo/references/content-rules.md` for detailed Know/Show patterns.
See `@showroom/docs/SKILL-COMMON-RULES.md` for AsciiDoc rules, version pinning, image conventions.

---

## ph_payload — Headless Mode (Publishing House)

If `ph_payload` is present, skip ALL interactive questions and run headless. Return structured JSON.

```yaml
ph_payload:
  target_dir: content/modules/ROOT/pages/
  mode: new | continue
  previous_module: 03-module-01-pipelines.adoc  # continue mode only
  spec:
    demo_name: OpenShift Pipelines Live Demo
    audience: Platform Engineers, Architects
    business_scenario: ACME Corp needs to modernize their CI/CD pipeline
    key_messages: [Speed up delivery, Reduce toil, Enterprise-grade reliability]
    duration: 45min
    module_outline: |
      Module 1: Pipeline overview (~15 min)
      Module 2: Live pipeline run (~20 min)
      Module 3: Monitoring and insights (~10 min)
    env:
      ocp_version: "4.18"
      attributes: {user: user1, password: openshift}
```

Headless return (JSON only):
```json
{
  "files_created": ["index.adoc", "01-overview.adoc", "02-details.adoc", "03-module-01-pipelines.adoc"],
  "nav_updated": true,
  "quality": {"critical": 0, "high": 0, "warnings": 1},
  "warnings": ["No customer ROI metrics provided — add in Know section"]
}
```

---

## Interactive Mode

### Phase 0 — Parse Arguments

```bash
/create-demo                                   # interactive
/create-demo <directory>                       # specify target directory
/create-demo <directory> --new                 # new demo
/create-demo <directory> --continue <module>   # continue from module
```

Validate directory exists. If empty: tell user to clone nookbag template:
```
git clone https://github.com/rhpds/showroom_template_nookbag <repo-name>
```

---

### Phase 1 — Detect Mode

If not set by arguments:
```
Are you:
1. Starting a NEW demo (creates index + overview + details + first module)
2. Adding a module to an EXISTING demo
```

---

### Phase 2 — Planning Form (ALL questions at once)

**For NEW demo — ask as one grouped form:**

```
Let's plan your demo. Answer what you know — skip anything you're unsure about:

Demo name:
Target audience (e.g. Platform Engineers, Solution Architects, CxOs):
Primary business challenge being solved:
Key messages (3-4 points you want the audience to leave with):
Duration (e.g. 20min, 45min, 1hr):
Module breakdown (how many modules, what each demonstrates):

Customer story or ROI metrics to reference (or leave blank):
Competitive angle (what makes this stand out vs alternatives):

OpenShift version (or leave blank for {ocp_version} placeholder):
Access type (admin / multi-user):
UserInfo variables (paste from demo.redhat.com → My services → Details → Advanced settings):
  Leave blank to use placeholders {user}, {password}, {openshift_console_url}

Reference materials (URLs, docs, competitive briefs — leave blank to use templates):

Writing style (optional — skip for standard Red Hat style):
  Describe: "executive-friendly, outcome-focused, analogies over jargon"
  OR paste 1-3 paragraphs of your own writing as an example
  OR give a file path to an existing demo module you wrote
  Saved profile? Point to: ~/.claude/context/my-writing-style.md
```

Confirm plan in one summary:
```
📋 Demo plan confirmed:
  Demo: [name] | [audience] | [duration]
  Modules: [breakdown]
  Key messages: [list]

Generating files... (running in parallel)
```

**For CONTINUE mode:**
```
Which module are you adding? (title + what you'll demonstrate)
Reference materials for this module? (URLs or blank)
```

---

### Phase 2.5 — Showroom Setup (NEW demo only)

Ask Q0–Q3 from `@showroom/skills/create-demo/references/showroom-scaffold.md`:
- Q0: OCP or VM?
- Q1: Which tabs/consoles?
- Q2: Which Red Hat theme?
- Q3: Planning E2E automation? (optional — creates buttons.js + runtime-automation/ if yes)

Create/update `site.yml` and `ui-config.yml` in repo root.

---

### Phase 3 — Spawn File Generator Agents (parallel)

Build `FULL_SPEC` JSON from planning answers. Set `CONTENT_TYPE: demo`.

**NEW demo — spawn all files simultaneously:**

```
Task tool:
  subagent_type: showroom:file-generator
  prompt: |
    TARGET_FILE: <repo_path>/content/modules/ROOT/pages/index.adoc
    FILE_TYPE: index
    FULL_SPEC: <FULL_SPEC JSON>
    LAB_TYPE: <ocp|rhel|vm|ai>
    CONTENT_TYPE: demo
    REPO_PATH: <absolute repo path>

Task tool:
  subagent_type: showroom:file-generator
  prompt: |
    TARGET_FILE: <repo_path>/content/modules/ROOT/pages/01-overview.adoc
    FILE_TYPE: overview
    CONTENT_TYPE: demo
    FULL_SPEC: <FULL_SPEC JSON>
    ...

Task tool:
  subagent_type: showroom:file-generator
  prompt: |
    TARGET_FILE: <repo_path>/content/modules/ROOT/pages/02-details.adoc
    FILE_TYPE: details
    CONTENT_TYPE: demo
    FULL_SPEC: <FULL_SPEC JSON>
    ...

Task tool:
  subagent_type: showroom:file-generator
  prompt: |
    TARGET_FILE: <repo_path>/content/modules/ROOT/pages/03-module-01-<slug>.adoc
    FILE_TYPE: module
    CONTENT_TYPE: demo
    FULL_SPEC: <FULL_SPEC JSON>
    ...
```

All four run concurrently.

**CONTINUE mode — single agent:**

```
Task tool:
  subagent_type: showroom:file-generator
  prompt: |
    TARGET_FILE: <next-module path>
    FILE_TYPE: module
    CONTENT_TYPE: demo
    PREVIOUS_MODULE: <path to previous .adoc>
    FULL_SPEC: <FULL_SPEC JSON>
    REPO_PATH: <absolute repo path>
```

---

### Phase 4 — Quality Check

Spawn `showroom:module-reviewer` on each generated file with `CONTENT_TYPE: demo`:

```
Task tool:
  subagent_type: showroom:module-reviewer
  prompt: |
    MODULE_FILE: <path>
    CONTENT_TYPE: demo
    LAB_TYPE: <ocp|rhel|vm|ai>
    SHARED_CONTEXT: <JSON>
    REPO_PATH: <absolute repo path>
    is_first_module: <true if overview>
    is_conclusion: false
```

Fix any Critical or High issues before delivering.

---

### Phase 5 — Update Navigation

Merge `nav_entry` values from file-generator outputs. Update `content/modules/ROOT/nav.adoc`.

---

### Phase 6 — Deliver

**Human mode:**
```
✅ Files created:
  index.adoc
  01-overview.adoc
  02-details.adoc
  03-module-01-<slug>.adoc

✅ nav.adoc updated

Quality: 0 Critical, 0 High, 1 Warning
  - W1: No customer ROI metrics — add in Know section when available

Next: Add more modules with /create-demo --continue, or verify with /verify-content
```

**Headless mode:** return JSON from ph_payload schema.

---

### Phase 7 — Conclusion Module

When all modules complete:
```
Task tool:
  subagent_type: showroom:file-generator
  prompt: |
    FILE_TYPE: conclusion
    CONTENT_TYPE: demo
    FULL_SPEC: <FULL_SPEC JSON with all module summaries>
    ...
```

See `@showroom/skills/create-demo/references/conclusion-template.md` for demo conclusion structure (ROI recap, call-to-action, presenter action items, Q&A guidance).

---

## Related Skills

- `/showroom:verify-content` — full quality review after content is created
- `/showroom:create-lab` — hands-on workshop content
- `/showroom:blog-generate` — transform demo to blog post
