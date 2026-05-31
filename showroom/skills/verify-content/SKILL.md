---
name: showroom:verify-content
description: This skill should be used when the user asks to "verify my workshop content", "review my lab module", "check my Showroom content", "validate my AsciiDoc module", "quality check my demo", "review my workshop for Red Hat standards", or "run a content review on my lab".
---

---
context: main
model: claude-sonnet-4-6
---

# Content Verification Skill

Orchestrates parallel agents to verify workshop or demo content against Red Hat quality standards. Presents one consolidated findings table. User picks which issue to fix first.

## Architecture

This skill is an orchestrator. It delegates work to agents:
- `showroom:scaffold-checker` (Haiku) — checks root config files
- `showroom:module-reviewer` (Sonnet) — reviews each .adoc module, one agent per file in parallel

The orchestrator handles: repo detection, pre-flight extraction, cross-module logic, result merging, findings presentation, and fix loop.

---

## ph_payload — Headless Mode (Publishing House)

If `ph_payload` is present, skip Phase 1 auto-detect and Phase 6 fix loop. Return structured JSON.

```yaml
ph_payload:
  content_path: content/modules/ROOT/pages/
  modules: []                    # empty = all modules
  lab_type: workshop
  shared_context:
    defined_attributes: {ocp_version: "4.18", user: user1}
    nav_order: [index, 01-overview, 02-details, 03-module-01]
    first_use_map: {AAP: 01-overview.adoc}
```

Headless return (JSON only):
```json
{
  "findings": [
    {"id": "E.3a", "module": "03-module-01.adoc", "line": 47, "severity": "High", "message": "..."}
  ],
  "summary": {"critical": 0, "high": 1, "medium": 0, "warnings": 3}
}
```

---

## Phase 1 — Auto-detect (silent, no questions)

Check CWD for Showroom structure:

- `content/modules/ROOT/pages/` exists and contains `.adoc` files → use it, proceed silently

**If CWD is not a Showroom repo**, output:

```
📁 No Showroom content found in [CWD].

Provide a local path or GitHub URL:
```

Wait for user response:

- **Local path** → use it, proceed
- **GitHub URL** → ask to clone to `/tmp/[repo-name]`, then proceed

Detect content type silently:
- Has `=== Verify` sections or numbered exercise steps → Workshop
- Has Know/Show structure, presenter notes → Demo
- Cannot determine → default to Workshop

Detect lab type silently from `ui-config.yml`:
- `console-openshift-console` or `rhods-dashboard` → `ocp`
- `/wetty` with `port:` or AAP/Cockpit URLs → `vm`
- AI/ML workloads referenced → `ai`
- RHEL/bastion pattern → `rhel`
- Cannot determine → `unknown`

Confirm in one line:
```
📋 Workshop content detected (ocp lab, 6 modules). Launching parallel review...
```

---

## Phase 2 — Pre-flight (orchestrator, inline)

Before spawning agents, extract shared context that all module agents need. Run silently.

**2a. Read `content/modules/ROOT/nav.adoc`**
Extract: ordered list of module filenames → `module_order`

**2b. Read `content/antora.yml`**
Extract: all keys under `asciidoc.attributes` → `defined_attributes`

**2c. Scan all .adoc files**
Build `first_use_map`: for each acronym (OCP, AAP, RHOAI, RHEL, etc.), record which module file contains its first expansion.

**2d. Cross-module structure checks (B.1–B.7)**

Run these inline now — they require seeing all modules at once:

| ID | Check | Fail condition | Severity |
|---|---|---|---|
| B.1 | `index.adoc` exists | Missing | Critical |
| B.2 | Workshop: `index.adoc` is learner-facing. Demo: facilitator-facing | Wrong framing | High |
| B.3 | `01-overview.adoc` present with scenario/value framing | Missing or no framing | High |
| B.4 | `02-details.adoc` present | Missing | High |
| B.5 | Workshop: ≥1 hands-on module (`03-*` or higher). Demo: ≥1 Know/Show module | None found | Critical |
| B.6 | `nav.adoc` lists all module files | Any `.adoc` not in nav | High |
| B.7 | Conclusion module exists | Missing | High |

Collect findings. Continue regardless.

**Output `SHARED_CONTEXT`:**
```json
{
  "module_order": ["index.adoc", "01-overview.adoc", "..."],
  "defined_attributes": {"ocp_version": "4.18", "user": "user1"},
  "first_use_map": {"OCP": "01-overview.adoc", "AAP": "03-module-01.adoc"},
  "lab_type": "ocp",
  "content_type": "workshop"
}
```

---

## Phase 3 — Spawn agents (parallel)

Spawn all agents simultaneously using the Task tool.

**3a. Scaffold agent:**
```
Task tool:
  subagent_type: showroom:scaffold-checker
  prompt: |
    REPO_PATH: <absolute path to repo root>
    CONTENT_TYPE: <workshop|demo>
    SHARED_CONTEXT: <SHARED_CONTEXT JSON>
```

**3b. Module agents (one per .adoc file, all in parallel):**

For each module in `module_order` (skip nav.adoc):
```
Task tool:
  subagent_type: showroom:module-reviewer
  prompt: |
    MODULE_FILE: <absolute path to .adoc file>
    CONTENT_TYPE: <workshop|demo>
    LAB_TYPE: <ocp|rhel|vm|ai|unknown>
    SHARED_CONTEXT: <SHARED_CONTEXT JSON>
    REPO_PATH: <absolute path to repo root>
    is_first_module: <true if this is 01-overview.adoc>
    is_conclusion: <true if filename contains "conclusion" or "99-">
```

All agents run concurrently. Wait for all to complete before proceeding.

---

## Phase 4 — Merge results (orchestrator, inline)

Collect JSON outputs from all agents.

**4a. Apply cross-module logic:**

- **D.2 (acronym first-use):** For each D.2 finding from a module-reviewer, check if the acronym appears in `first_use_map`. If the first use is in an *earlier* module, suppress the finding (the expansion already happened).
- **E.5 (undefined attributes):** For each E.5 finding, check if the attribute appears in `defined_attributes`. If it does, suppress.

**4b. Flatten all findings:**
- B.1–B.7 findings from pre-flight (Phase 2)
- All findings from scaffold-checker JSON output
- All findings from module-reviewer JSON outputs (after cross-module suppression)

**4c. Deduplicate:** same ID + same file + same line → keep one.

**4d. Sort:** Critical → High → Medium → Warning → Info. Within severity: scaffold (S) before cross-module (B.1–B.7) before content (B.8–F).

---

## Phase 5 — Present findings table

Output **one table** with all findings. Nothing else before it.

```
## Verification Results

| # | ID | Issue | Severity | Location |
|---|---|---|---|---|
| 1 | S.2a | ui-config.yml missing | Critical | repo root |
| 2 | B.5 | No hands-on module found | Critical | pages/ |
| 3 | E.3a | [source,bash] missing role="execute" | High | module-01.adoc:47 |
| 4 | D.2 | "AAP" used without first-use expansion | Warning | 03-module-01.adoc:12 |

**Total: 4 issues — 2 Critical, 1 High, 0 Medium, 1 Warning**
```

If zero findings:
```
✅ No issues found. Content passes all checks.
```

Then ask:
```
Which issue do you want to fix first? (Enter the number, e.g. "3")
Or say "all critical", "all high", or "skip" to finish.
```

---

## Phase 6 — Fix loop

When the user picks an issue:

1. Show: BEFORE / AFTER / why (one sentence)
2. Apply the fix
3. Confirm: "Fixed #3. X issues remaining."
4. Re-show remaining table (fixed items removed)
5. Ask: "Which one next?"

Repeat until user says "done", "skip", or no issues remain.

**Never fix multiple issues at once unless the user says "all critical" or "all high".**

---

### Special fix — E.3a: missing `role="execute"` (bulk replace)

When E.3a is selected:

1. Inform the user:
   ```
   This fix replaces [source,bash] / [source,sh] / [source,shell] / [source,console] /
   [source,terminal] / [source,tty] / [source,wetty] → [source,role="execute"]
   across all .adoc files.

   It will NOT touch [source,text], [source,yaml], [source,json], or other non-shell blocks.

   Apply bulk fix to all module files? [Y/n]
   ```

2. If YES — replace in each module file. Skip blocks inside `[source,asciidoc]` fences.

3. Report: "Fixed: replaced N occurrences across M files."

---

## Severity reference

| Severity | Meaning |
|---|---|
| **Critical** | Lab broken — learner cannot proceed |
| **High** | Key functionality broken or degraded |
| **Warning** | Standards violation — lab works but doesn't meet quality bar |
| **Info** | Optional improvement |
| **Recommendation** | Feature is optional — shown only to inform, not to block or flag. No action required. |

Only Critical and High mark a lab as "not ready". Recommendations are shown at the bottom of the table, separated from issues.

---

## Related Skills

- `/showroom:create-lab` — Create new workshop modules
- `/showroom:create-demo` — Create presenter-led demo content
- `/showroom:blog-generate` — Transform workshop to blog post
