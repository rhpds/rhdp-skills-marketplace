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

## Step 1: Collect Inputs and Guide Environment Setup

From the user's reply, extract:

- `lab_type` — one of: `ocp-tenant`, `ocp-dedicated`, `vm-rhel`
- `showroom_path` — local path or GitHub URL to the showroom repo
- Access details — token string, kubeconfig path, or SSH details

**If a local path:** confirm it exists and contains `content/modules/ROOT/pages/`.

**If a GitHub URL:** clone to `/tmp/<repo-name>` and use that path.

### Validate access

For OCP labs:
```bash
oc whoami 2>/dev/null && oc whoami --show-server 2>/dev/null
```

If not logged in and no token provided, tell the user:
```
Run:  oc login --token=<your-token> --server=<api-url> --insecure-skip-tls-verify
Then: restart Claude so it picks up your kubeconfig
```

For VM labs:
```bash
ssh -i <key> <user>@<host> "hostname && id"
```

Confirm access before continuing. If access fails, stop and tell the user exactly what to do.

### Guide the user to order the lab (OCP tenant — if no live env yet)

**For `ocp-tenant` labs:** After confirming the user is logged in, run:

```bash
# Get the logged-in username (this is what to use when ordering)
oc whoami

# Get the GUID from an existing showroom namespace (if already provisioned)
oc get namespaces | grep showroom | head -5
```

If no showroom namespace exists yet, the user needs to provision a lab. Tell them:

```
**Order the lab now on integration.demo.redhat.com:**

  1. Go to https://demo.redhat.com
  2. Find your catalog item
  3. Order it — use your Red Hat SSO user (the same user you are logged in as)
  4. Note the GUID from the order confirmation

Once provisioned, your showroom namespace will be:
  showroom-<guid>     (OCP tenant)
  showroom-<user>     (varies by lab)

Come back with the GUID and I'll pick up from here.
```

If already provisioned, extract the GUID:
```bash
GUID=$(oc get namespaces -o name | grep showroom | head -1 | sed 's|namespace/showroom-||')
echo "GUID: $GUID"
```

Store `GUID` and `SHOWROOM_NS` for use in all subsequent steps.

### Check dev.yaml silent override

```bash
grep "content_git_repo_ref" <showroom_path>/dev.yaml 2>/dev/null
```

If `ocp4_workload_showroom_content_git_repo_ref` is set in `dev.yaml`, warn:
```
⚠️  dev.yaml overrides content_git_repo_ref — the showroom pod will clone
    from that ref instead of your working branch. Remove or update it.
```

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

Also check the AgV common.yaml if available:
- `ocp4_workload_tenant_namespace_namespaces` — what namespaces exist
- `ocp4_workload_showroom_runtime_automation_image` — confirm zt-runner version

Present a summary and ask which modules to generate:

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
- Guard every create: check existence before creating
- Use `--dry-run=client -o yaml | oc apply -f -` for `oc create` idempotency
- Use `state: present` with `kubernetes.core.k8s` (naturally idempotent)
- For async operations: trigger and exit — student clicks Validate later

### validate.yml

Checks that the exercise outcome exists and is correct.

**Critical rules:**
- One `validation_check` task at the end — never multiple
- Check **durable outcomes** not transient state
- For async: use `any()` completed, not `max()`
- Be specific — tell students exactly which step failed and the fix command

**validation_check structure:**
```yaml
- name: Validate all tasks
  validation_check:
    check: "{{ _task1_ok and _task2_ok }}"
    pass_msg: |
      ✅ Task 1: <what was checked>
      ✅ Task 2: <what was checked>
    error_msg: |
      {{ '✅ Task 1: ok' if _task1_ok else '❌ Step incomplete: <what failed> — fix: <command>' }}
      {{ '✅ Task 2: ok' if _task2_ok else '❌ Step incomplete: <what failed> — fix: <command>' }}
```

### Write the files

Show a preview of both files. Ask: `Write these files? [Y/n]`

```bash
mkdir -p <showroom_path>/runtime-automation/<module-name>
# Write solve.yml and validate.yml
```

---

## Step 4: Test Against Live Environment

This step is a guided walkthrough. Follow each part in order.

### 4a — Push and restart Showroom

**OCP labs — run these commands and show the user the output at each step:**

```bash
# Push the new playbooks
cd <showroom_path>
git add runtime-automation/
git commit -m "Add solve/validate for <module-name>"
git push
```

```bash
# Find the showroom namespace (use the GUID from Step 1)
SHOWROOM_NS=showroom-$GUID
echo "Showroom namespace: $SHOWROOM_NS"
```

```bash
# Restart the pod to pick up the new playbooks from git
oc rollout restart deployment/showroom -n $SHOWROOM_NS
oc rollout status deployment/showroom -n $SHOWROOM_NS --timeout=120s
```

```bash
# Get the Showroom URL
SHOWROOM=https://$(oc get route showroom -n $SHOWROOM_NS -o jsonpath='{.spec.host}')
echo "Showroom URL: $SHOWROOM"
```

Tell the user: **Save this URL — you will use it for all curl tests below.**

**VM labs:**
```bash
# Push
cd <showroom_path>
git add runtime-automation/ && git commit -m "Add solve/validate for <module-name>" && git push

# Restart showroom container on bastion
ssh -i <key> <user>@<host> "podman restart showroom && echo restarted"

# Set the URL
SHOWROOM=https://<showroom-fqdn>
echo "Showroom URL: $SHOWROOM"
```

### 4b — Run the full test cycle

**Run each curl command and show the streaming output to the user.**
The `/stream/` endpoint streams Ansible task output live — it closes when the playbook finishes.

**Step 1 — Fresh validate (should FAIL — student hasn't done the exercise yet):**

```bash
echo "━━━ FRESH VALIDATE: <module-name> ━━━"
curl -sk -N $SHOWROOM/stream/validate/<module-name>
```

Tell the user what to look for:
```
Expected: ❌ tasks fail — this confirms the validate checks real student state.
If everything passes here without solving, the checks are too loose — revisit validate.yml.
```

**Step 2 — Solve (completes the exercise):**

```bash
echo "━━━ SOLVE: <module-name> ━━━"
curl -sk -N $SHOWROOM/stream/solve/<module-name>
```

Tell the user what to look for:
```
Expected: Ansible tasks run and complete without errors.
Watch for: "fatal" lines or Python tracebacks — these need fixing.
```

**Step 3 — Validate after solve (should PASS):**

```bash
echo "━━━ VALIDATE AFTER SOLVE: <module-name> ━━━"
curl -sk -N $SHOWROOM/stream/validate/<module-name>
```

Tell the user what to look for:
```
Expected: ✅ all tasks pass.
If any ❌ remains — paste the output and I will fix the playbook.
```

**Run validate a second time without solving to confirm idempotency:**

```bash
echo "━━━ VALIDATE AGAIN (idempotency check) ━━━"
curl -sk -N $SHOWROOM/stream/validate/<module-name>
```

```
Expected: ✅ still passes — solve left the environment in a clean, checkable state.
```

---

## Step 5: Fix Loop

If any curl output shows a failure:

1. Show the exact failing lines from the stream output
2. Identify which task in the playbook caused it
3. Propose a targeted fix
4. Ask: `Apply fix? [Y/n]`
5. After fix:

```bash
# Push fix
cd <showroom_path>
git add runtime-automation/ && git commit -m "Fix <module-name> solve/validate" && git push

# Restart pod
oc rollout restart deployment/showroom -n $SHOWROOM_NS
oc rollout status deployment/showroom -n $SHOWROOM_NS --timeout=120s

# Re-run full test cycle
curl -sk -N $SHOWROOM/stream/validate/<module-name>
curl -sk -N $SHOWROOM/stream/solve/<module-name>
curl -sk -N $SHOWROOM/stream/validate/<module-name>
```

Repeat until all three steps pass clean.

---

## Step 6: Summary

When all modules pass the full test cycle, show:

```
✅ All modules pass solve + validate

  module-01: fresh validate ❌ → solve ✅ → validate ✅
  module-02: fresh validate ❌ → solve ✅ → validate ✅
  ...

Files written:
  runtime-automation/module-01/solve.yml
  runtime-automation/module-01/validate.yml
  ...

━━━ Next step ━━━

Order the lab with run_e2e_load_test: true to confirm Demolition-style
automated testing works end to end. The load test role calls /stream/solve
then /stream/validate for every module and fails the provision on any ❌.
```
