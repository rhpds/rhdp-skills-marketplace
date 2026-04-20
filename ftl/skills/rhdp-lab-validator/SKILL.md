---
name: ftl:rhdp-lab-validator
description: This skill should be used when the user asks to "write solve and validate playbooks", "add E2E testing to my lab", "generate solve.yml", "generate validate.yml", "add solve and validate buttons", "set up runtime automation", "add ZT grading to my lab", "set up load testing for my lab", "add Demolition grading", or "configure run_e2e_load_test".
context: main
model: claude-opus-4-6
---

# Skill: FTL Lab Validator — Orchestrator

Orchestrates 4 agents to write and test `solve.yml` and `validate.yml` playbooks for RHDP Showroom labs:

| Agent | Job |
|---|---|
| `ftl:content-reader` | Reads .adoc module, extracts tasks and expected outcomes |
| `ftl:solve-writer` | Writes solve.yml from content-reader output |
| `ftl:validate-writer` | Writes validate.yml from content-reader + solve-writer output |
| `ftl:env-connector` | Pushes, restarts, runs full test cycle, reports pass/fail |

Agents talk through this orchestrator — each agent's output is passed as input to the next.

---

## Step 0: Pre-flight Check

Show this message before asking anything else:

```
Before using this skill, make sure two things are ready:

═══ 1. SHOWROOM REPO ════════════════════════════════════════════

Sync from: github.com/rhpds/showroom_template_nookbag (e2e-template branch)

Copy these into your showroom repo:
  content/supplemental-ui/js/buttons.js
  content/supplemental-ui/css/site-extra.css
  content/lib/inject-buttons.js
  content/lib/dev-mode.js
  runtime-automation/module-XX/solve.yml      ← one dir per module
  runtime-automation/module-XX/validate.yml

Your site.yml must have these extensions and supplemental_files configured:

  ui:
    supplemental_files:
      - path: ./content/supplemental-ui
      - path: ./content/lib
      - path: ui.yml
        contents: "static_files: [ .nojekyll, css/site-extra.css, js/buttons.js ]"
  antora:
    extensions:
      - require: ./content/lib/dev-mode.js
        enabled: false
      - require: ./content/lib/inject-buttons.js

Add solve/validate button placeholders to each .adoc module that needs them.

═══ 2. AgV CATALOG (common.yaml) ═══════════════════════════════

  • rhpds-ftl collection in requirements_content
  • showroom collection v1.6.6 or later (earlier versions silently
    ignore runtime_automation vars — runner will not deploy)
  • ocp4_workload_runtime_automation_k8s workload (OCP tenant/dedicated)
    or vm_workload_runtime_automation (RHEL VM)
  • zt-runner image: quay.io/rhpds/zt-runner:v2.4.2
  • wetty image: quay.io/rhpds/wetty:v3.0

See examples/ in the e2e-template branch for exact common.yaml config:
  github.com/rhpds/showroom_template_nookbag/tree/e2e-template

═════════════════════════════════════════════════════════════════

Ready? Tell me:
  1. Lab type: ocp-tenant / ocp-dedicated / vm-rhel
  2. Path to your showroom repo (local path or GitHub URL)
  3. Access:
       OCP labs — provide a cluster admin token, OR log in with
                  `oc login` and restart Claude so it inherits
                  your kubeconfig
       VM labs  — provide SSH host, user, and key path
                  (or paste your SSH config block)
  4. Existing files: Do you already have solve.yml or validate.yml
     for any modules? If yes, paste them or share the paths now.
     I'll use them as the baseline and only fill in what's missing
     instead of generating from scratch.
```

Wait for the user to reply before proceeding.

**If user provides existing files (Step 4 above):**
- Read the existing solve.yml and validate.yml
- Skip `ftl:content-reader` and `ftl:solve-writer`/`ftl:validate-writer` for those modules
- Go directly to `ftl:env-connector` to test the existing files
- Only re-invoke the writer agents if env-connector reports failures

---

## Step 1: Setup

Collect from user reply:
- `lab_type` — `ocp-tenant` | `ocp-dedicated` | `vm-rhel`
- `showroom_path` — local path or GitHub URL (clone to `/tmp/<repo>` if URL)
- Access details

**Verify the showroom repo has the required E2E files:**
```bash
ls <showroom_path>/content/lib/inject-buttons.js \
   <showroom_path>/content/lib/dev-mode.js \
   <showroom_path>/content/supplemental-ui/js/buttons.js 2>/dev/null
```

If any are missing, tell the user which files to copy from the e2e-template branch before continuing.

**Check dev.yaml silent override:**
```bash
grep "ocp4_workload_showroom_content_git_repo_ref" <showroom_path>/dev.yaml 2>/dev/null
```
If found → warn the user. This overrides common.yaml and the showroom pod clones the wrong branch.

**OCP tenant — guide environment ordering:**

Run `oc whoami` to confirm login. If no live lab exists:
```
**Order the lab now on demo.redhat.com:**

  1. Go to https://demo.redhat.com and find your catalog item
  2. Order using your Red Hat SSO user (same user as oc login)
  3. Note the GUID from the order confirmation

Come back with the GUID once provisioned.
```

If already provisioned, detect GUID:
```bash
GUID=$(oc get namespaces -o name | grep showroom | head -1 | sed 's|namespace/showroom-||')
echo "GUID: $GUID"
```

---

## Step 2: Discover Modules

List all `.adoc` files and identify those with exercises:

```bash
ls <showroom_path>/content/modules/ROOT/pages/*.adoc | sort
```

For each file, do a quick check for numbered exercise steps and button placeholders.

Present summary and ask which modules to process:

```
Found N modules with exercises:
  module-01 — <title> (has solve/validate buttons: yes/no)
  module-02 — <title> (has solve/validate buttons: yes/no)

Which modules? [all / numbers]
```

**If a module has exercises but no button placeholders**, tell the user:
```
⚠️  module-XX has exercises but no solve/validate button placeholders.
    Add these to the module .adoc before or after generating playbooks:

      ++++
      <div class="solve-button-placeholder" data-module="module-XX"></div>
      ++++
      ++++
      <div class="validate-button-placeholder" data-module="module-XX"></div>
      ++++
```
Still proceed with playbook generation — buttons can be added separately.

---

## Step 3: Run Agents — One Module at a Time

For each selected module, run all 4 agents in sequence. Pass each agent's output to the next.

---

### 3a — content-reader

Use the **Task tool** with `subagent_type: "ftl:content-reader"`:

```
Task tool:
  subagent_type: ftl:content-reader
  prompt: |
    MODULE_FILE: <showroom_path>/content/modules/ROOT/pages/<module>.adoc
    AGV_COMMON:  <path to common.yaml if available, else "none">
    LAB_TYPE:    <lab_type>
```

Wait for the structured task report. Store as `CONTENT_REPORT`.

Show the user a one-line summary:
```
📖 content-reader: found X tasks in <module>
```

---

### 3b — solve-writer

Use the **Task tool** with `subagent_type: "ftl:solve-writer"`:

```
Task tool:
  subagent_type: ftl:solve-writer
  prompt: |
    CONTENT_READER_REPORT: <CONTENT_REPORT>
    LAB_TYPE:              <lab_type>
    REFERENCE_FILE:        <absolute path to references/<lab_type>.md>
```

Wait for solve.yml + SOLVE_ACTIONS summary. Store both.

Show the user a preview of solve.yml and ask: `Write solve.yml? [Y/n]`

Write if confirmed:
```bash
mkdir -p <showroom_path>/runtime-automation/<module>
# write solve.yml
```

---

### 3c — validate-writer

Use the **Task tool** with `subagent_type: "ftl:validate-writer"`:

```
Task tool:
  subagent_type: ftl:validate-writer
  prompt: |
    CONTENT_READER_REPORT: <CONTENT_REPORT>
    SOLVE_ACTIONS:         <SOLVE_ACTIONS from solve-writer>
    LAB_TYPE:              <lab_type>
```

Wait for validate.yml + VALIDATION_SUMMARY. Store both.

Show the user a preview of validate.yml and ask: `Write validate.yml? [Y/n]`

Write if confirmed:
```bash
# write validate.yml
```

---

### 3d — env-connector

Use the **Task tool** with `subagent_type: "ftl:env-connector"`:

```
Task tool:
  subagent_type: ftl:env-connector
  prompt: |
    LAB_TYPE:           <lab_type>
    SHOWROOM_PATH:      <showroom_path>
    MODULE_NAME:        <module>
    GUID:               <guid if known>
    ACCESS:             <token / kubeconfig / ssh details>
    VALIDATION_SUMMARY: <VALIDATION_SUMMARY from validate-writer>
```

env-connector pushes, restarts, and runs the full test cycle:
1. Fresh validate → expect ❌
2. Solve → expect clean
3. Validate after solve → expect ✅
4. Validate again → idempotency check

Wait for TEST_RESULT.

---

## Step 4: Fix Loop

If TEST_RESULT is FAIL:

1. Show the user the exact failing lines from env-connector
2. Determine which agent needs to fix it:
   - solve.yml has a `fatal:` error → re-invoke **solve-writer** with the error context
   - validate.yml fails after solve → re-invoke **validate-writer** with the error context
   - Playwright step failed (output contains `FAILED:` and `INTENT:`) →
     **do NOT re-invoke writers yet** — trigger **env-connector self-healing** first:
       a. Pull `/tmp/playwright-debug.png` from runner pod
       b. Read screenshot + INTENT description with vision
       c. Vision generates updated selector for current UI
       d. Patch the `.js` file in showroom repo
       e. Push and re-run full test cycle
     Only re-invoke solve-writer if self-healing fails after 2 attempts
3. Re-invoke the appropriate agent:

```
Re-invoke: ftl:solve-writer | ftl:validate-writer
Pass:
  (original inputs)
  ERROR_CONTEXT: <raw output from env-connector showing the failure>
  INSTRUCTION: Fix the failing task: <task name>
```

4. Preview the fix. Ask: `Apply fix? [Y/n]`
5. Re-invoke **env-connector** for the full test cycle again
6. Repeat until TEST_RESULT is PASS

---

## Step 5: Next Module

When a module passes, move to the next selected module and repeat Step 3.

---

## Step 6: Summary

When all modules pass:

```
✅ All modules pass solve + validate

  module-01: fresh ❌ → solve ✅ → validate ✅ → idempotency ✅
  module-02: fresh ❌ → solve ✅ → validate ✅ → idempotency ✅
  ...

Showroom URL: <url>

━━━ Next step ━━━
Order with run_e2e_load_test: true to confirm Demolition-style
automated testing. The load test role calls /stream/solve then
/stream/validate for every module and fails the provision on any ❌.
```
