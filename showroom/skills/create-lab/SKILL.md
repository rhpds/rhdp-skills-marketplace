---
name: showroom:create-lab
description: This skill should be used when the user asks to "create a lab module", "write a workshop module", "build a Showroom lab", "convert docs to a lab", "write a hands-on exercise", "create an AsciiDoc module", or "turn this documentation into a lab exercise".
---

---
context: main
model: claude-sonnet-4-6
---

# Lab Module Generator

Orchestrates agents to create Red Hat Showroom workshop or demo content. Two modes: interactive (human) and headless (Publishing House via ph_payload).

## Architecture

This skill is an orchestrator. Generation and review are delegated to agents:
- `showroom:file-generator` (Sonnet) — generates one AsciiDoc file, runs in parallel for new labs
- `showroom:module-reviewer` (Sonnet) — quality check on generated files

The orchestrator handles: argument parsing, repo detection, planning, agent spawning, nav merge, delivery.

See @showroom/docs/SKILL-COMMON-RULES.md for AsciiDoc rules, version pinning, image conventions, and navigation format.

---

## ph_payload — Headless Mode (Publishing House)

If `ph_payload` is present in the invocation, skip ALL interactive questions and run headless. Return structured JSON.

```yaml
ph_payload:
  target_dir: content/modules/ROOT/pages/
  mode: new | continue
  previous_module: 03-module-01-pipelines.adoc  # continue mode only
  spec:
    lab_name: OpenShift Pipelines Workshop
    audience: intermediate
    learning_objectives: [Deploy a pipeline, Configure triggers, Monitor builds]
    business_scenario: ACME Corp needs to modernize their CI/CD pipeline
    duration: 90min
    module_outline: |
      Module 1: Pipeline setup (~30 min)
      Module 2: Triggers (~30 min)
      Module 3: Monitoring (~30 min)
    env:
      ocp_version: "4.18"
      attributes: {user: user1, password: openshift}
```

Headless return (JSON only, no prose):
```json
{
  "files_created": ["index.adoc", "01-overview.adoc", "02-details.adoc", "03-module-01-pipelines.adoc"],
  "nav_updated": true,
  "quality": {"critical": 0, "high": 0, "warnings": 2},
  "warnings": ["Module has only 1 exercise, recommend adding more"]
}
```

---

## Interactive Mode

### Phase 0 — Parse Arguments

```bash
/create-lab                                    # interactive, asks all questions
/create-lab <directory>                        # specify target directory
/create-lab <directory> --new                  # new lab, skip mode question
/create-lab <directory> --continue <module>    # continue from module
```

Validate directory exists. If empty: tell user to clone nookbag template first:
```
git clone https://github.com/rhpds/showroom_template_nookbag <repo-name>
```
Never suggest `showroom-nookbag` (hyphens) — always `showroom_template_nookbag` (underscores).

---

### Phase 1 — Detect Mode (new lab vs continue)

If not set by arguments:
```
Are you:
1. Starting a NEW lab (creates index + overview + details + first module)
2. Adding a module to an EXISTING lab
```

Detect content type from existing files (no question):
- `=== Verify` sections or numbered exercises → Workshop
- Know/Show structure, presenter notes → Demo
- Unknown → Workshop

---

### Phase 2 — Planning Form (ALL questions at once, no sequential blocking)

**For NEW lab — ask as one grouped form:**

```
Let's plan your workshop. Answer all at once or skip any you're unsure about:

Lab name:
Target audience (e.g. Developers, SREs, Platform Engineers):
Experience level (Beginner / Intermediate / Advanced):
Main learning goal (what can learners DO when finished?):
Learning outcomes (list 3-4 skills they'll gain):
Business scenario (company name + challenge, e.g. "ACME Corp needs to modernize CI/CD"):
Duration (e.g. 30min, 1hr, 2hr):
Module breakdown (how many modules, what each covers):

OpenShift version (or leave blank for {ocp_version} placeholder):
Cluster type (multinode / SNO):
Access type (admin / multi-user htpasswd / keycloak):
UserInfo variables (paste from demo.redhat.com → My services → Details → Advanced settings):
  Leave blank to use placeholder attributes {user}, {password}, {openshift_console_url}

Reference materials (paste URLs, file paths, or text — leave blank to use templates):

Writing style (optional — skip for standard Red Hat style):
  Describe: "conversational, short sentences, active voice, no jargon"
  OR paste 1-3 paragraphs of your own writing as an example
  OR give a file path: ~/my-showroom/content/modules/ROOT/pages/03-my-module.adoc
  Saved profile? Point to: ~/.claude/context/my-writing-style.md
```

User fills what they know, skips the rest. Orchestrator confirms the plan in one summary block:
```
📋 Plan confirmed:
  Lab: [name] | [audience] | [duration]
  Modules: [breakdown]
  Environment: OCP [version] | [access type]
  References: [N URLs / no references]

Generating files... (running in parallel)
```

**For CONTINUE mode — minimal questions:**
```
Which module are you adding? (title + brief description)
Reference materials for this module? (URLs, files, or blank)
Include troubleshooting section? [Y/n]
```

---

### Phase 2.5 — Showroom Setup (NEW lab only)

Ask Q0–Q3 from `@showroom/skills/create-lab/references/showroom-scaffold.md`:
- Q0: OCP or VM?
- Q1: Which tabs/consoles?
- Q2: Which Red Hat theme?
- Q3: Planning E2E tests with FTL skill? (optional — creates buttons.js + runtime-automation/ if yes)

Create/update `site.yml` and `ui-config.yml` in repo root.

---

### Phase 3 — Spawn File Generator Agents (parallel)

Build `FULL_SPEC` JSON from the planning form answers.

**NEW lab — spawn all files simultaneously:**

```
Task tool:
  subagent_type: showroom:file-generator
  prompt: |
    TARGET_FILE: <repo_path>/content/modules/ROOT/pages/index.adoc
    FILE_TYPE: index
    FULL_SPEC: <FULL_SPEC JSON>
    LAB_TYPE: <ocp|rhel|vm|ai>
    CONTENT_TYPE: <workshop|demo>
    REPO_PATH: <absolute repo path>

Task tool:
  subagent_type: showroom:file-generator
  prompt: |
    TARGET_FILE: <repo_path>/content/modules/ROOT/pages/01-overview.adoc
    FILE_TYPE: overview
    FULL_SPEC: <FULL_SPEC JSON>
    ...

Task tool:
  subagent_type: showroom:file-generator
  prompt: |
    TARGET_FILE: <repo_path>/content/modules/ROOT/pages/02-details.adoc
    FILE_TYPE: details
    FULL_SPEC: <FULL_SPEC JSON>
    ...

Task tool:
  subagent_type: showroom:file-generator
  prompt: |
    TARGET_FILE: <repo_path>/content/modules/ROOT/pages/03-module-01-<slug>.adoc
    FILE_TYPE: module
    FULL_SPEC: <FULL_SPEC JSON>
    ...
```

All four run concurrently. Wait for all to return JSON.

**CONTINUE mode — single agent, sequential:**

```
Task tool:
  subagent_type: showroom:file-generator
  prompt: |
    TARGET_FILE: <repo_path>/content/modules/ROOT/pages/<next-module>.adoc
    FILE_TYPE: module
    FULL_SPEC: <FULL_SPEC JSON>
    PREVIOUS_MODULE: <path to previous .adoc>
    REPO_PATH: <absolute repo path>
```

---

### Phase 4 — Quality Check

Spawn `showroom:module-reviewer` on each generated file:

```
Task tool:
  subagent_type: showroom:module-reviewer
  prompt: |
    MODULE_FILE: <path to generated .adoc>
    CONTENT_TYPE: <workshop|demo>
    LAB_TYPE: <ocp|rhel|vm|ai>
    SHARED_CONTEXT: {"module_order": [...], "defined_attributes": {...}, "first_use_map": {}, "lab_type": "ocp", "content_type": "workshop"}
    REPO_PATH: <absolute repo path>
    is_first_module: <true if overview>
    is_conclusion: false
```

Collect findings. If Critical or High issues found, fix inline before delivering.

---

### Phase 5 — Update Navigation

Merge `nav_entry` values from each file-generator JSON output.

Read existing `content/modules/ROOT/nav.adoc`. Insert new entries in correct order. Write back.

Confirm: `✅ nav.adoc updated with [N] new entries.`

---

### Phase 6 — Deliver

**Human mode:**
```
✅ Files created:
  index.adoc (247 words)
  01-overview.adoc (312 words)
  02-details.adoc (198 words)
  03-module-01-pipeline-setup.adoc (1,340 words, 2 exercises)

✅ nav.adoc updated

Quality: 0 Critical, 0 High, 2 Warnings
  - W1: Module has only 1 exercise — consider adding a second
  - W2: [source,bash] found — run /verify-content E.3a fix when ready

Next: Add more modules with /create-lab --continue, or verify the full lab with /verify-content
```

**Headless mode:** return JSON from Phase 2's ph_payload schema.

---

### Phase 7 — Conclusion Module

When all modules are complete and user asks for the conclusion:
```
Task tool:
  subagent_type: showroom:file-generator
  prompt: |
    FILE_TYPE: conclusion
    FULL_SPEC: <FULL_SPEC JSON with all module summaries>
    ...
```

See `@showroom/skills/create-lab/references/conclusion-template.md` for conclusion structure.

---

## Related Skills

- `/showroom:verify-content` — full quality review after content is created
- `/showroom:create-demo` — presenter-led demo content
- `/ftl:rhdp-lab-validator` — write E2E solve/validate automation
