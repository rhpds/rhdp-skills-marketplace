---
name: ftl:lab-validator
description: This skill should be used when the user asks to "write solve and validate playbooks", "add E2E testing to my lab", "generate solve.yml", "generate validate.yml", "add solve and validate buttons", "set up runtime automation", or "add ZT grading to my lab".
---

---
context: main
model: claude-opus-4-6
---

# Skill: FTL Lab Validator

Write `solve.yml` and `validate.yml` Ansible playbooks for RHDP Showroom labs.
Reads your existing module exercises and generates working playbooks for the
zt-runner sidecar (solve/validate buttons and Demolition load testing).

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
```

Wait for the user to reply with all three before proceeding.

---

## Step 1: Collect Inputs

From the user's reply, extract:

- `lab_type` — one of: `ocp-tenant`, `ocp-dedicated`, `vm-rhel`
- `showroom_path` — local path or GitHub URL to the showroom repo
- Access details — token string, kubeconfig path, or SSH details

**If a local path:** confirm it exists and contains `content/modules/ROOT/pages/`.

**If a GitHub URL:** clone to `/tmp/<repo-name>` and use that path.

**Access validation:**

For OCP labs:
```bash
oc whoami 2>/dev/null || echo "not logged in"
# Or if user provided a token:
oc login --token=<token> --server=<api-url> --insecure-skip-tls-verify && oc whoami
```

For VM labs:
```bash
ssh -i <key> <user>@<host> "hostname && id"
```

Confirm access before continuing. If access fails, stop and tell the user what's needed.

**⚠️ dev.yaml silent override — always check:**

```bash
grep "content_git_repo_ref" <showroom_path>/dev.yaml 2>/dev/null
```

If `dev.yaml` has `ocp4_workload_showroom_content_git_repo_ref` set, it overrides
`common.yaml`. The showroom pod will clone from that ref — not your working branch.
Warn the user and ask if they want to remove it.

---

## Step 2: Discover Modules

Read all `.adoc` files in `content/modules/ROOT/pages/` and identify which modules
contain exercises (numbered steps under `==` headings).

```bash
ls <showroom_path>/content/modules/ROOT/pages/*.adoc | sort
```

Read each file and collect:
- Module name (from filename, e.g. `module-01`)
- Exercise tasks (numbered list items under exercise headings)
- Commands students run (look for `role="execute"`, `role="send-to-wetty"`, etc.)
- Any existing `solve-button-placeholder` or `validate-button-placeholder` divs

Also check the AgV common.yaml if available to understand:
- `ocp4_workload_tenant_namespace_namespaces` — what namespaces exist and their quotas
- Shared namespaces (from showroom userdata ConfigMap if cluster is live)

Present a summary:

```
Found N modules with exercises:

  module-01 — <title> (X tasks)
  module-02 — <title> (Y tasks)
  ...

Which modules do you want solve/validate playbooks for? [all / enter numbers]
```

---

## Step 3: Generate Playbooks

For each selected module, read the exercise content carefully and generate:

### solve.yml

The solve playbook completes the exercise on behalf of the student.

**Load the appropriate pattern reference before writing:**
- OCP tenant → `@ftl/skills/rhdp-lab-validator/references/ocp-tenant.md`
- OCP dedicated → `@ftl/skills/rhdp-lab-validator/references/ocp-dedicated.md`
- RHEL VM → `@ftl/skills/rhdp-lab-validator/references/vm-rhel.md`

**Solver priority ladder — always try in this order:**
1. `kubernetes.core.k8s_exec` into the target pod (bypasses NetworkPolicy)
2. `kubernetes.core.k8s` / `k8s_info` via k8s API
3. `ansible.builtin.uri` for REST APIs
4. `ansible.builtin.wait_for` for TCP checks
5. Playwright script — last resort for browser-only UI

**Critical rules for solve.yml:**
- Every operation must be **idempotent** — solve runs multiple times when students retry
- Guard every create: check if it already exists before creating
- Use `--dry-run=client -o yaml | oc apply -f -` for `oc create` idempotency
- Use `state: present` with `kubernetes.core.k8s` (naturally idempotent)
- For async operations (builds, analysis): trigger and exit immediately —
  students click Validate later when it completes

### validate.yml

Checks that the exercise outcome exists and is correct.

**Critical rules for validate.yml:**
- One `validation_check` task at the end — never multiple
- Check **durable outcomes**, not transient state (a file that persists, not a branch
  that may switch; a resource that stays, not a pod that restarts)
- For async operations: check `any()` completed, not `max()` — new queued tasks
  must not block completed ones
- Be specific in error messages — tell students exactly which step failed and how to fix it

**validation_check structure:**
```yaml
- name: Validate all tasks
  validation_check:
    check: "{{ _task1_ok and _task2_ok }}"
    pass_msg: |
      ✅ Task 1: <what was checked>
      ✅ Task 2: <what was checked>
    error_msg: |
      {{ '✅ Task 1: ok' if _task1_ok else '❌ Step incomplete: <what failed — fix: <command>' }}
      {{ '✅ Task 2: ok' if _task2_ok else '❌ Step incomplete: <what failed — fix: <command>' }}
```

**For async operations (e.g. analysis still running):**
```yaml
error_msg: |
  {{ '✅' if _done_ok else '❌ Still running — come back in a few minutes and click Validate again' }}
```

### Write the files

Show a preview of both files. Ask: `Write these files? [Y/n]`

```bash
mkdir -p <showroom_path>/runtime-automation/<module-name>
# Write solve.yml and validate.yml
```

---

## Step 4: Test Against Live Environment

Push and restart Showroom to pick up the new playbooks.

**OCP labs:**
```bash
cd <showroom_path>
git add runtime-automation/ && git commit -m "Add solve/validate for <module>" && git push

SHOWROOM_NS=$(oc get pods -A | grep showroom | awk '{print $1}' | head -1)
oc rollout restart deployment/showroom -n $SHOWROOM_NS
oc rollout status deployment/showroom -n $SHOWROOM_NS
SHOWROOM=https://$(oc get route showroom -n $SHOWROOM_NS -o jsonpath='{.spec.host}')
```

**VM labs:**
```bash
cd <showroom_path>
git add runtime-automation/ && git commit -m "Add solve/validate for <module>" && git push
ssh -i <key> <user>@<host> "podman restart showroom"
SHOWROOM=https://<showroom-fqdn>
```

**Test cycle — always run fresh validate first, then solve, then validate again:**
```bash
# 1. Fresh validate — exercise tasks should fail (student hasn't done them)
echo "=== Fresh validate ===" && curl -sk -N $SHOWROOM/stream/validate/<module>

# 2. Solve
echo "=== Solve ===" && curl -sk -N $SHOWROOM/stream/solve/<module>

# 3. Validate again — should pass
echo "=== Validate after solve ===" && curl -sk -N $SHOWROOM/stream/validate/<module>
```

Expected: infra checks (service reachable, pod running) pass fresh.
Student-state checks (resource created, config applied) fail fresh → pass after solve.

---

## Step 5: Fix Loop

If validation fails:
1. Show the exact error from the SSE stream
2. Propose a targeted fix to the playbook
3. Ask: `Apply fix? [Y/n]`
4. After fix → push → restart → re-run test cycle
5. Repeat until all selected modules pass clean validate after solve

---

## Step 6: Summary

When all modules pass the full test cycle:

```
✅ All modules pass solve + validate

Files written:
  runtime-automation/module-01/solve.yml
  runtime-automation/module-01/validate.yml
  ...

Next steps:
  1. Provision a full lab and order with run_e2e_load_test: true
     to confirm Demolition-style automated testing works end to end
```
