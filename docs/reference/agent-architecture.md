---
layout: default
title: Agent Architecture
---

# Agent Architecture

The RHDP Skills Marketplace follows the **skill-as-orchestrator, agent-as-worker** pattern — the same design used by the FTL plugin.

---

## Core Principle

Skills handle user interaction and coordination. Agents do the actual work in parallel, each with a fresh context window.

```mermaid
graph TD
    User([User]) --> Skill[Skill\nOrchestrator\nSonnet 4.6]
    Skill -->|Task tool| A1[Agent 1\nHaiku]
    Skill -->|Task tool| A2[Agent 2\nSonnet]
    Skill -->|Task tool| A3[Agent N\nSonnet]
    A1 -->|JSON| Merge[Merge +\nPresent]
    A2 -->|JSON| Merge
    A3 -->|JSON| Merge
    Merge --> Output([Result])

    style Skill fill:#cc0000,color:#fff
    style A1 fill:#f5a623,color:#000
    style A2 fill:#4a90d9,color:#fff
    style A3 fill:#4a90d9,color:#fff
```

**Why agents instead of inline checks?**

| Old approach | Agent approach |
|---|---|
| All checks in one context window | Each agent gets a fresh context — no saturation |
| Sequential — each check waits for the previous | Parallel — N modules reviewed simultaneously |
| 8 minutes for a 6-module lab | ~90 seconds (6× faster) |
| Model sees everything — can't score dimensions | Each agent returns structured JSON — eval-ready |

---

## All Agents

### Showroom Plugin

| Agent | Model | Purpose | Called by |
|---|---|---|---|
| `showroom:scaffold-checker` | Haiku | Checks site.yml, ui-config.yml, antora.yml, gh-pages.yml | verify-content |
| `showroom:module-reviewer` | Sonnet | Reviews one .adoc module — B/C/D/E/F checks + dimension scores | verify-content, create-lab, create-demo |
| `showroom:file-generator` | Sonnet | Generates one AsciiDoc file (or Markdown blog) from spec | create-lab, create-demo, blog-generate |
| `showroom:score-aggregator` | Haiku | Aggregates dimension scores, detects regressions vs baseline | showroom:eval (future) |
| `showroom:doc-writer` | Sonnet | Generates/updates GitHub Pages docs from SKILL.md | any skill after changes |

### FTL Plugin (reference pattern)

| Agent | Model | Purpose |
|---|---|---|
| `ftl:content-reader` | Sonnet | Reads .adoc, extracts tasks and classifies steps |
| `ftl:solve-writer` | Sonnet | Writes solve.yml from content-reader output |
| `ftl:validate-writer` | Sonnet | Writes validate.yml playbooks |
| `ftl:env-connector` | Sonnet | Pushes to live showroom, runs test cycle |

### AgnosticV Plugin

| Agent | Model | Purpose |
|---|---|---|
| `agnosticv:workflow-reviewer` | Sonnet | Checks builder/validator skill consistency |

---

## How Skills Spawn Agents

Skills use the **Task tool** with `subagent_type`:

```text
Task tool:
  subagent_type: showroom:module-reviewer
  prompt: |
    MODULE_FILE: /path/to/03-module-01.adoc
    CONTENT_TYPE: workshop
    LAB_TYPE: ocp
    SHARED_CONTEXT: {"module_order": [...], "defined_attributes": {...}}
    REPO_PATH: /path/to/repo
```

All agents return **structured JSON only** — no prose, no tables. The orchestrating skill handles presentation.

---

## verify-content Orchestration

```mermaid
graph TD
    User([User]) --> VC[verify-content\nSonnet 4.6]
    VC -->|pre-flight| PF[Extract shared_context\nnav order, attributes,\nfirst-use map]
    PF -->|parallel| SC[scaffold-checker\nHaiku]
    PF -->|parallel| MR1[module-reviewer\nSonnet]
    PF -->|parallel| MR2[module-reviewer\nSonnet]
    PF -->|parallel| MRN[module-reviewer × N\nSonnet]
    SC -->|findings JSON| Merge[Merge +\ncross-module logic]
    MR1 -->|scored JSON| Merge
    MR2 -->|scored JSON| Merge
    MRN -->|scored JSON| Merge
    Merge --> Table([Findings table])

    style VC fill:#cc0000,color:#fff
    style SC fill:#f5a623,color:#000
    style MR1 fill:#4a90d9,color:#fff
    style MR2 fill:#4a90d9,color:#fff
    style MRN fill:#4a90d9,color:#fff
```

## create-lab Orchestration

```mermaid
graph TD
    User([User]) --> CL[create-lab\nSonnet 4.6]
    CL -->|Phase A| Plan[Planning form\nall questions at once]
    Plan --> Spec[FULL_SPEC JSON]
    Spec -->|Phase B parallel| FG1[file-generator\nindex.adoc]
    Spec -->|Phase B parallel| FG2[file-generator\noverview.adoc]
    Spec -->|Phase B parallel| FG3[file-generator\ndetails.adoc]
    Spec -->|Phase B parallel| FG4[file-generator\nmodule-01.adoc]
    FG1 -->|nav_entry + JSON| Merge[Nav merge +\nQC review]
    FG2 -->|nav_entry + JSON| Merge
    FG3 -->|nav_entry + JSON| Merge
    FG4 -->|nav_entry + JSON| Merge
    Merge --> MR[module-reviewer × N\nSonnet]
    MR --> Deliver([Files on disk\nnav updated])

    style CL fill:#cc0000,color:#fff
    style FG1 fill:#4a90d9,color:#fff
    style FG2 fill:#4a90d9,color:#fff
    style FG3 fill:#4a90d9,color:#fff
    style FG4 fill:#4a90d9,color:#fff
    style MR fill:#4a90d9,color:#fff
```

---

## Model Assignments

| Tier | Model | Used for |
|---|---|---|
| Orchestrators | Sonnet 4.6 | All skills — user interaction + coordination |
| Generation/review agents | Sonnet 4.6 | module-reviewer, file-generator, doc-writer, workflow-reviewer |
| Reading/computation agents | Haiku 4.5 | scaffold-checker, score-aggregator |
| FTL agents | Sonnet 4.6 | content-reader, solve-writer, validate-writer, env-connector |

---

## Skill Evaluation Framework

One of the most important aspects of this architecture is that **agent outputs are structured JSON with dimension scores** — making the skills measurable and comparable across versions.

### The Challenge

Evaluating content creation skills is hard:
- Did a change improve introduction quality but degrade the main body?
- Is the skill now better at RHEL labs but worse at OpenShift labs?
- Did adding a rule improve style compliance but hurt pacing?

The `agnosticv:validator` is the easy case — formal rules, deterministic output, pass/fail clear. Evaluating `create-lab` is genuinely hard.

### What the Score-Aggregator Enables

The `showroom:score-aggregator` (Haiku) receives module-reviewer JSON outputs and produces:

```json
{
  "dimensions": {
    "structure":      {"current": 0.88, "baseline": 0.85, "delta": "+0.03"},
    "pedagogy":       {"current": 0.72, "baseline": 0.78, "delta": "-0.06 ⚠️"},
    "style":          {"current": 0.94, "baseline": 0.93, "delta": "+0.01"},
    "intro_quality":  {"current": 0.91, "baseline": 0.84, "delta": "+0.07"}
  },
  "verdict": "REGRESSION — pedagogy degraded by 0.06 on OCP labs",
  "lab_type": "ocp"
}
```

This catches the case where "intro_quality improved but pedagogy regressed on OCP labs" — per-dimension, per-lab-type regression detection that no single score could surface.

### The Pioneer Opportunity

Skill evals for content generation skills don't exist in the industry at this level. The patterns here — structured JSON agents, dimension scoring, golden datasets, lab_type tagging — could be applied beyond RHDP:

- **Publishing House** — eval before publishing, not just after
- **Tailwind** — same eval pipeline for any generated content
- **Across Red Hat** — any team generating structured technical content

The `agnosticv:validator` provides the immediate proof: formal output schema, automated scoring, no ambiguity. The generative skills (create-lab, create-demo) are harder but the architecture makes it possible for the first time.

See [Writing Style Guide](writing-style.md) for how personal style profiles interact with the eval framework.
