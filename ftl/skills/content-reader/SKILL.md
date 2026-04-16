---
name: ftl:content-reader
description: AsciiDoc reader agent for the FTL lab validator. Reads a showroom .adoc module file, extracts executable code blocks (role="execute"), classifies each step by automation type, and outputs a structured task report for the solve-writer and validate-writer agents.
version: 1.0.0
---

---
context: main
model: claude-sonnet-4-6
---

# ftl:content-reader — AsciiDoc Lab Step Extractor

Reads a Showroom `.adoc` module file and produces a structured task report classifying every student step. This feeds directly into `ftl:solve-writer` and `ftl:validate-writer`.

**Self-contained. No ECC, no external tools required.**

---

## What You Receive

- `MODULE_FILE` — absolute path to the `.adoc` file
- `AGV_COMMON` — path to `common.yaml` (or `"none"`)
- `LAB_TYPE` — `ocp-tenant` | `ocp-dedicated` | `vm-rhel`
- `CLUSTER_CONTEXT` (optional) — namespace patterns, service URLs from live cluster

---

## Step 1 — Parse AsciiDoc Structure

Read the full `.adoc` file. Extract:

### A. Executable code blocks (primary signal)

AsciiDoc executable blocks have `role="execute"` — these are commands the student runs in the terminal:

```asciidoc
[source,bash,role="execute"]
----
oc login --server={openshift_api_url}
----

[source,bash,role="execute",subs="attributes"]
----
oc project {user}-coolstore
----
```

For each block, capture:
- **language** — `bash`, `python`, `yaml`, etc.
- **raw command** — the text inside `----`
- **substituted command** — replace `{attr}` with known values (from AgV `ocp4_workload_showroom_content_*` or userdata keys like `{user}`, `{guid}`)
- **surrounding section** — the nearest `==` or `===` heading above it
- **surrounding prose** — 2-3 sentences before/after for context

### B. Non-executable prose sections

Every section heading (`==`, `===`) + its prose content that does NOT have `role="execute"` blocks — these may contain UI steps.

### C. AsciiDoc attribute substitutions

Look for `_attributes.adoc`, `vars.adoc`, or attribute definitions at the top of the file:
```asciidoc
:user: user1
:openshift_api_url: https://api.cluster...
```
Use these to substitute `{attr}` placeholders in code blocks.

---

## Step 2 — Classify Every Step

For each extracted block or prose section, assign a classification. Apply the priority ladder strictly:

| Classification | Signal | Automate with |
|---|---|---|
| `k8s` | `kubectl`/`oc` command creating/updating a k8s resource | `kubernetes.core.k8s` |
| `k8s-check` | `kubectl`/`oc` command reading a k8s resource | `kubernetes.core.k8s_info` |
| `oc-cli` | `oc` command with no direct k8s equivalent (login, project, new-app, etc.) | `ansible.builtin.shell` + oc |
| `api` | `curl` to REST API, Python HTTP call | `ansible.builtin.uri` |
| `tcp-check` | Port/connectivity check | `ansible.builtin.wait_for` |
| `exec-into-pod` | Command that must run INSIDE a pod (NetworkPolicy, localhost URLs) | `kubernetes.core.k8s_exec` |
| `shell-workspace` | Command inside DevSpaces/workspace pod | `kubernetes.core.k8s_exec` into workspace pod |
| `ui-playwright` | Browser interaction with NO api/oc equivalent | Playwright script |
| `skip` | Informational only / visual verification / pure AI interaction | No automation — document reason |

### GUI Step Decision Tree

When a step is described in prose (no `role="execute"`) or the code doesn't map to a known command:

```
Is there an oc CLI equivalent?
  YES → classify as oc-cli
  NO  → Is there a REST API endpoint?
    YES → classify as api
    NO  → Is this a k8s resource operation?
      YES → classify as k8s
      NO  → Is this a browser interaction that Playwright CAN reproduce?
        YES → classify as ui-playwright (only if reproducible deterministically)
        NO  → classify as skip
```

**`skip` examples that cannot be automated:**
- "Accept the AI-suggested code change in VS Code"
- "Scroll through the analysis results and review each finding"
- "Click Approve or Reject on each code suggestion"
- "Review the AI-generated explanation and confirm it makes sense"
- AI model learning from user feedback

**`ui-playwright` examples (only these qualify):**
- Opening a URL and logging in
- Clicking a specific named button (e.g., "Try in Playground")
- Navigating to a known page path
- Filling a form with deterministic values

---

## Step 3 — Produce Structured Task Report

Output as a structured list. This is consumed verbatim by `ftl:solve-writer` and `ftl:validate-writer`.

```
MODULE: module-02-developer-lightspeed
FILE: /path/to/04-module-02-developer-lightspeed.adoc
LAB_TYPE: ocp-tenant

ATTRIBUTE_SUBSTITUTIONS:
  user: llmuser-{guid}
  devworkspace_namespace: user-{guid}-devworkspace
  mta_namespace: user-{guid}-mta

EXECUTABLE_BLOCKS:
  - id: block-01
    section: "Exercise 1: Open DevSpaces"
    language: bash
    role: execute
    raw: "oc login --server={openshift_api_url} --username={user} ..."
    substituted: "oc login --server={{ openshift_api_url }} --username={{ user }} ..."
    classification: oc-cli
    ansible_module: ansible.builtin.shell (oc)
    notes: "Login must happen inside workspace pod — exec into devworkspace pod"

  - id: block-02
    section: "Exercise 2: Configure LiteLLM"
    language: yaml
    role: execute
    raw: |
      models:
        OpenAI: &active
          environment:
            OPENAI_API_KEY: {litellm_virtual_key}
    substituted: |
      models:
        OpenAI: &active
          environment:
            OPENAI_API_KEY: {{ litellm_virtual_key }}
    classification: shell-workspace
    ansible_module: kubernetes.core.k8s_exec
    notes: "Write to /projects/kai-coolstore/settings/provider-settings.yaml — check if exists first"

PROSE_STEPS:
  - id: prose-01
    section: "Exercise 2: Review AI Suggestions"
    description: "Student reviews AI-generated code fixes and clicks Accept or Reject for each"
    classification: skip
    reason: "AI code review acceptance is a visual/interactive step with no deterministic API equivalent"

  - id: prose-02
    section: "Exercise 3: Open MTA Analysis Results"
    description: "Student opens MTA web console and reviews issue list"
    classification: skip
    reason: "Visual review of analysis results — validator checks that analysis completed, not that results were reviewed"

VALIDATION_TARGETS:
  - "DevSpaces workspace pod running in {{ student_user }}-devworkspace"
  - "provider-settings.yaml exists at /projects/kai-coolstore/settings/provider-settings.yaml"
  - "LiteLLM endpoint reachable with virtual key"

SKIP_SUMMARY:
  - prose-01: "AI code acceptance — manual review required"
  - prose-02: "Visual analysis review — not automatable"

STATS:
  total_blocks: 8
  automatable: 5
  ui_playwright: 0
  skip: 3
  coverage: 62%
```

---

## Step 4 — Flag Ambiguities

Before handing off to solve-writer, flag anything uncertain:

```
⚠️ AMBIGUITIES (resolve before solve-writer runs):

  1. block-04: Command uses {mta_hub_url} but no matching attribute found in .adoc.
     Check common.yaml for ocp4_workload_tenant_mta_url or equivalent.
     → Defaulting to: http://mta-hub.{{ student_user }}-mta.svc.cluster.local:8080

  2. prose-03: "Click the Configure GenAI Settings button" — is there an API equivalent?
     The MTA extension stores config at /projects/kai-coolstore/settings/provider-settings.yaml
     → Classifying as shell-workspace (write the file directly)
```

List ambiguities clearly. If resolution is clear from context (AgV catalog or known patterns), resolve it. If not, flag for human input.

---

## Output Format

Return ONLY the structured task report + ambiguities. No prose explanation. The orchestrator passes this directly to solve-writer and validate-writer.