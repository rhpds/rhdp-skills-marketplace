---
layout: default
title: Publishing House Integration
---

# Publishing House Integration

Skills support two modes: **interactive** (human at terminal) and **headless** (Publishing House via `ph_payload`). Zero changes to PH — the integration is entirely in the skills.

---

## How It Works

```mermaid
sequenceDiagram
    participant H as Human User
    participant PH as Publishing House
    participant S as Skill (Orchestrator)
    participant A as Agents

    Note over H,A: Interactive Mode
    H->>S: /verify-content
    S->>H: "Workshop detected. Running checks..."
    S->>A: spawn scaffold-checker (Haiku)
    S->>A: spawn module-reviewer × N (Sonnet, parallel)
    A-->>S: findings JSON
    S->>H: findings table
    H->>S: "Fix #3"
    S->>H: "Fixed. 4 issues remaining."

    Note over PH,A: Headless Mode (ph_payload)
    PH->>S: ph_payload + content_path
    S->>A: spawn scaffold-checker (Haiku)
    S->>A: spawn module-reviewer × N (Sonnet, parallel)
    A-->>S: findings JSON
    S-->>PH: structured JSON response
    Note right of PH: PH decides what to fix
```

---

## verify-content — PH Headless

**PH sends:**

```yaml
ph_payload:
  content_path: content/modules/ROOT/pages/
  modules: []          # empty = all modules
  lab_type: workshop
  shared_context:
    defined_attributes: {ocp_version: "4.18", user: user1}
    nav_order: [index, 01-overview, 02-details, 03-module-01]
    first_use_map: {AAP: 01-overview.adoc}
```

**What happens inside:**

```mermaid
sequenceDiagram
    participant PH as Publishing House
    participant VC as verify-content
    participant SC as scaffold-checker (Haiku)
    participant MR1 as module-reviewer (Sonnet)
    participant MR2 as module-reviewer (Sonnet)

    PH->>VC: ph_payload JSON
    Note over VC: Detect ph_payload → headless mode
    Note over VC: Skip auto-detect (use content_path directly)
    VC->>SC: REPO_PATH + SHARED_CONTEXT
    VC->>MR1: MODULE_FILE=01-overview.adoc + SHARED_CONTEXT
    VC->>MR2: MODULE_FILE=03-module-01.adoc + SHARED_CONTEXT
    Note over SC,MR2: All three run in parallel
    SC-->>VC: {"findings": [...], "passed": [...]}
    MR1-->>VC: {"dimensions": {...}, "findings": [...]}
    MR2-->>VC: {"dimensions": {...}, "findings": [...]}
    Note over VC: Merge, cross-module logic, deduplicate
    VC-->>PH: {"findings": [...], "summary": {"critical": 0, "high": 1}}
    Note over PH: PH decides what to fix, no interactive loop
```

**PH receives:**

```json
{
  "findings": [
    {
      "id": "E.3a",
      "module": "03-module-01.adoc",
      "line": 47,
      "severity": "High",
      "message": "[source,bash] missing role=execute"
    }
  ],
  "summary": {"critical": 0, "high": 1, "medium": 0, "warnings": 3}
}
```

---

## create-lab — PH Headless

**PH sends:**

```yaml
ph_payload:
  target_dir: content/modules/ROOT/pages/
  mode: new
  spec:
    lab_name: OpenShift Pipelines Workshop
    audience: intermediate
    learning_objectives:
      - Deploy a Tekton pipeline
      - Configure event triggers
      - Monitor build results
    business_scenario: ACME Corp needs to modernize their CI/CD pipeline...
    duration: 90min
    module_outline: |
      Module 1: Pipeline setup (~30 min)
      Module 2: Triggers (~30 min)
      Module 3: Monitoring (~30 min)
    env:
      ocp_version: "4.18"
      attributes: {user: user1, password: openshift}
    writing_style: "conversational, short sentences, active voice"
```

**What happens inside:**

```mermaid
sequenceDiagram
    participant PH as Publishing House
    participant CL as create-lab
    participant FG1 as file-generator (Sonnet)
    participant FG2 as file-generator (Sonnet)
    participant FG3 as file-generator (Sonnet)
    participant FG4 as file-generator (Sonnet)
    participant MR as module-reviewer (Sonnet)

    PH->>CL: ph_payload JSON
    Note over CL: Detect ph_payload → skip all questions
    Note over CL: Build FULL_SPEC from spec field
    CL->>FG1: FILE_TYPE=index + FULL_SPEC
    CL->>FG2: FILE_TYPE=overview + FULL_SPEC
    CL->>FG3: FILE_TYPE=details + FULL_SPEC
    CL->>FG4: FILE_TYPE=module + FULL_SPEC
    Note over FG1,FG4: All four run in parallel
    Note over FG1: Apply writing_style to prose
    Note over FG1: Auto-humanizer pass
    FG1-->>CL: {file_created, nav_entry, word_count}
    FG2-->>CL: {file_created, nav_entry, word_count}
    FG3-->>CL: {file_created, nav_entry, word_count}
    FG4-->>CL: {file_created, nav_entry, word_count}
    Note over CL: Merge nav.adoc
    CL->>MR: quality check on generated files
    MR-->>CL: {findings: [...]}
    CL-->>PH: {files_created: [...], nav_updated: true, quality: {...}}
```

**PH receives:**

```json
{
  "files_created": [
    "index.adoc",
    "01-overview.adoc",
    "02-details.adoc",
    "03-module-01-pipeline-setup.adoc"
  ],
  "nav_updated": true,
  "quality": {"critical": 0, "high": 0, "warnings": 1},
  "warnings": ["Module has only 1 exercise — consider adding a second"]
}
```

---

## Agent Communication Flow

When any showroom skill runs — interactive or headless — agents communicate through their JSON outputs:

```mermaid
graph LR
    subgraph "Skill (Orchestrator)"
        S[Skill spawns agents\nvia Task tool]
        M[Merges JSON\nfrom all agents]
        S --> M
    end

    subgraph "Agents (Workers)"
        A1[scaffold-checker\n→ findings JSON]
        A2[module-reviewer\n→ scored findings JSON]
        A3[file-generator\n→ file + nav_entry JSON]
    end

    S -->|REPO_PATH\nSHARED_CONTEXT| A1
    S -->|MODULE_FILE\nSHARED_CONTEXT| A2
    S -->|FULL_SPEC\nFILE_TYPE| A3
    A1 --> M
    A2 --> M
    A3 --> M

    subgraph "Output"
        H[Human: findings table\nor delivery summary]
        P[PH: structured JSON\nno interaction needed]
    end

    M --> H
    M --> P
```

**Key design decisions:**
- Agents **never** talk to each other directly — all communication goes through the orchestrator
- Agents return **JSON only** — the orchestrator handles all human-facing output
- `SHARED_CONTEXT` is built once by the orchestrator and injected into every agent — agents don't read across files

---

## Skill Comparison: Interactive vs Headless

| | Human interactive | PH headless |
|---|---|---|
| **Trigger** | `/verify-content` | `ph_payload` JSON |
| **Questions asked** | Yes (if repo not found) | Never |
| **Output format** | Findings table + fix loop | Structured JSON |
| **Agents used** | Same agents, same models | Identical — no difference |
| **Performance** | Same | Same |
| **Fix loop** | Yes — user picks issues | No — PH handles fixes |

---

## Supported Skills

| Skill | ph_payload supported | Notes |
|---|---|---|
| `showroom:verify-content` | ✅ | Returns findings JSON |
| `showroom:create-lab` | ✅ | Returns files_created + quality JSON |
| `showroom:create-demo` | ✅ | Same as create-lab |
| `agnosticv:catalog-builder` | — | PH doesn't drive catalog creation |
| `ftl:rhdp-lab-validator` | — | Requires live cluster connection |
