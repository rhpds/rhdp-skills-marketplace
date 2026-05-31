---
layout: default
title: Developer Guide
---

# Developer Guide

Everything you need to know to contribute rules, templates, prompts, or agents to the RHDP Skills Marketplace. This guide describes every file that agents and skills read, so you know exactly where to make changes.

---

## How Skills and Agents Read Rules

Skills and agents follow a **priority chain** — they check sources in order and use the first match:

```
1. Your repo's own files    ← highest priority (project-specific)
2. Marketplace bundled      ← fallback defaults
```

This means you can override any marketplace rule for a specific project by creating the same file in your Showroom repo.

---

## File Map — Every File Agents Read

### Showroom Content Rules

#### `showroom/docs/SKILL-COMMON-RULES.md`
**Who reads it:** `showroom:file-generator`, `showroom:module-reviewer`, all showroom skills

The master contract shared by all showroom skills. Defines:
- Version pinning rules (always use `{ocp_version}`, never hardcode)
- AsciiDoc list formatting rules (numbered steps vs bullets)
- Image path conventions (`link=self,window=blank`)
- Navigation update expectations
- Writing style and personalization rules
- Humanizer auto-run behaviour

**To update:** Edit this file. Changes apply immediately to all showroom skills on next install.

---

#### `showroom/prompts/` — Verification Prompt Files
**Who reads them:** `showroom:module-reviewer` (for verify-content), `showroom:file-generator` (during creation)

| File | Purpose |
|---|---|
| `enhanced_verification_workshop.txt` | Full quality checklist for workshop content |
| `enhanced_verification_demo.txt` | Full quality checklist for demo content |
| `verify_workshop_structure.txt` | Module structure requirements |
| `verify_technical_accuracy_workshop.txt` | Technical accuracy rules for workshops |
| `verify_technical_accuracy_demo.txt` | Technical accuracy rules for demos |
| `verify_accessibility_compliance_workshop.txt` | WCAG accessibility for workshops |
| `verify_accessibility_compliance_demo.txt` | WCAG accessibility for demos |
| `redhat_style_guide_validation.txt` | Red Hat branding and style rules |

**To add a new check:** Edit the relevant `.txt` file. The `module-reviewer` agent reads these before running checks.

**To override for a specific project:** Create `showroom/prompts/` inside your Showroom repo. Files there take priority over marketplace copies.

---

#### `showroom/templates/` — AsciiDoc Templates
**Who reads them:** `showroom:file-generator` when generating new content

```
showroom/templates/
  workshop/
    templates/     ← blank templates (used for new files)
      00-index-learner.adoc
      01-overview.adoc
      02-details.adoc
      03-module-01.adoc
    example/       ← filled examples (used for style reference)
      01-overview.adoc
      02-details.adoc
      03-module-01.adoc
  demo/
    templates/
    example/
```

**Priority:** `{REPO_PATH}/examples/workshop/templates/` beats marketplace templates. Clone the nookbag template (`showroom_template_nookbag`, branch `e2e-template`) and edit the files there.

**To change the default template:** Edit the `.adoc` files in `showroom/templates/`. Changes apply to all new labs/demos created after the next marketplace install.

---

#### `showroom/skills/create-lab/references/showroom-scaffold.md`
**Who reads it:** `showroom:create-lab` skill during Showroom setup (Q0–Q3)

Documents the scaffold setup: `site.yml`, `ui-config.yml`, AgnosticV workloads, E2E automation setup. Includes the canonical source URLs for `buttons.js` and solve/validate stubs.

**To update:** Edit this file to change the default tab configurations, workload patterns, or E2E setup instructions.

---

#### `showroom/skills/create-lab/references/asciidoc-rules.md`
**Who reads it:** `showroom:file-generator` during module generation

All AsciiDoc formatting rules with correct/incorrect examples — em dashes, external links, code block roles, image syntax.

---

#### `showroom/skills/create-lab/references/conclusion-template.md`
#### `showroom/skills/create-demo/references/conclusion-template.md`
**Who reads them:** `showroom:file-generator` with `FILE_TYPE: conclusion`

Templates for the conclusion module of workshops and demos. Includes the References consolidation pattern (all references from all modules go in the conclusion, not individual modules).

---

### AgnosticV Rules

#### `agnosticv/docs/AGV-COMMON-RULES.md`
**Who reads it:** `agnosticv:catalog-builder`, `agnosticv:validator`

AgV-wide rules: how to detect the AgV repo path, branch selection, git workflow.

---

#### `agnosticv/docs/ocp-catalog-questions.md`
#### `agnosticv/docs/cloud-vms-base-catalog-questions.md`
#### `agnosticv/docs/sandbox-tenant-ci-questions.md`
#### `agnosticv/docs/sandbox-cluster-ci-questions.md`
**Who reads them:** `agnosticv:catalog-builder` during catalog creation

All the questions the catalog-builder asks, organized by infra type. Each file covers one catalog pattern.

**To add a new question or change defaults:** Edit the relevant file. For example, to change the default showroom version:
```yaml
version: v1.6.8  # change this line
```

---

#### `agnosticv/docs/ocp-validator-checks.md`
#### `agnosticv/docs/cloud-vms-base-validator-checks.md`
#### `agnosticv/docs/sandbox-validator-checks.md`
**Who reads them:** `agnosticv:validator` for infra-type-specific checks

Check definitions for each infra type. These are the checks the validator runs beyond the base SKILL.md checks.

**To add a check:** Add a new entry in the relevant file following the existing pattern:
```python
def check_my_new_rule(config):
  """What this checks"""
  if some_condition:
    warnings.append({
      'check': 'my_check_id',
      'severity': 'WARNING',
      'message': 'What went wrong',
      'fix': 'How to fix it'
    })
```

---

#### `$agv_path/.schemas/babylon.yaml`
**Who reads it:** `agnosticv:validator` Step 0 — the authoritative schema

This is in the **AgnosticV repository itself**, not the marketplace. The validator reads it to get the authoritative list of valid `__meta__` fields, category enums, and field types.

**This is the source of truth.** If you add a new field to the babylon schema, the validator will automatically accept it. You do NOT need to update the marketplace.

---

### E2E Templates (nookbag e2e-template branch)

#### `showroom_template_nookbag` (branch: `e2e-template`)
**Who reads it:** `showroom:scaffold-checker`, `showroom:file-generator`

Canonical source for:
- `content/supplemental-ui/js/buttons.js` — the Solve/Validate button implementation
- `runtime-automation/module-01/solve.yml` — canonical Ansible play structure
- `runtime-automation/module-01/validate.yml` — uses `validation_check` (zt-runner module)
- `examples/e2e-ocp-dedicated/` — full E2E lab example with correct patterns

**To update the canonical button implementation:** Push to the `e2e-template` branch of `showroom_template_nookbag`. All skills that scaffold new repos will pick up the change.

---

## How to Add a New Check to a Skill

### Adding a verification check to verify-content

1. Find the right prompt file in `showroom/prompts/`
2. Add your check following the existing table format:

```
| ID | Check | Fail condition | Severity |
|---|---|---|---|
| E.10 | My new check | When this fails | High |
```

3. Map it to a dimension in `showroom/agents/module-reviewer.md`:

```markdown
**Dimension → check mapping:**
- `technical_accuracy`: D.10, E.1–E.9, E.10  ← add here
```

4. Open a PR against `rhpds/rhdp-skills-marketplace`

---

### Adding a validation check to agnosticv:validator

1. Edit `agnosticv/docs/ocp-validator-checks.md` (or the relevant infra file)
2. Add your Python-style check function
3. The validator picks it up automatically

---

## How to Add a New Agent

1. Create `showroom/agents/my-agent.md` (or `agnosticv/agents/`)
2. Frontmatter: `description`, `model`, `tools` — no `name:` field (name comes from filename)
3. Follow the FTL pattern: accept inputs via prompt, return structured JSON only
4. Wire it into the calling skill via `Task tool: subagent_type: showroom:my-agent`
5. Update the diagram in `docs/assets/images/diagrams/` using the `diagram-generator` agent

---

## How to Update Diagrams

The `diagram-generator` agent (Gemini CLI + Nano Banana) generates and self-reviews architecture diagrams:

```bash
# From a Claude Code session, via prakhar-helper:
"Generate a new diagram for the agnosticv catalog-builder agent orchestration"
```

Or call it directly:
```
Task tool:
  subagent_type: diagram-generator
  prompt: |
    DIAGRAM_TYPE: skill-orchestrator
    SKILL_NAME: agnosticv:catalog-builder
    OUTPUT_PATH: ~/work/code/rhdp-skills-marketplace/docs/assets/images/diagrams/catalog-builder-agents.png
    CONTEXT: [describe what to show]
```

---

## PR Checklist

Before opening a PR against `rhpds/rhdp-skills-marketplace`:

- [ ] Tested the skill/agent locally with `/plugin-dir` flag
- [ ] No credentials, internal URLs, or PII in any committed file
- [ ] If adding a check: tested it against a known-bad catalog/module
- [ ] If changing a template: checked with `showroom:verify-content` to ensure generated content still passes
- [ ] If changing a prompt file: checked that verify-content still produces sensible output
- [ ] Updated `CHANGELOG.md` with what changed and why
- [ ] Diagram updated if skill orchestration changed

---

## Related

- [Skills vs Agents](../reference/skills-vs-agents.html) — when to use each
- [Agent Architecture](../reference/agent-architecture.html) — how skills and agents connect
- [PH Integration](../reference/ph-integration.html) — headless mode for Publishing House
