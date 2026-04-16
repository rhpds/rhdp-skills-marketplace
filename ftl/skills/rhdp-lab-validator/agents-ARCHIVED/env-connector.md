---
name: ftl:env-connector
description: Connects to a live OCP cluster or VM, pushes playbooks, restarts Showroom, runs the full test cycle (fresh validate → solve → validate → idempotency check), and reports pass/fail back to the orchestrator.
---

# Agent: Environment Connector

You receive the generated playbooks, connection details, and the validation summary from validate-writer.
Your job is to push, restart, test, and report. You do not generate playbooks — you test them.

---

## Input

```
LAB_TYPE:          ocp-tenant | ocp-dedicated | vm-rhel
SHOWROOM_PATH:     <local path to showroom repo>
MODULE_NAME:       <e.g. module-01>
GUID:              <environment GUID, if known>
ACCESS:            <token, kubeconfig path, or SSH details>
VALIDATION_SUMMARY: <output from validate-writer>
```

---

## Step 1: Establish Connection

### OCP labs

```bash
# Verify login
oc whoami && oc whoami --show-server
```

If not logged in:
```
Tell the user:
  Run: oc login --token=<token> --server=<api-url> --insecure-skip-tls-verify
  Then restart Claude to inherit the kubeconfig.
```

Once logged in, find the GUID if not provided:
```bash
GUID=$(oc get namespaces -o name | grep showroom | head -1 | sed 's|namespace/showroom-||')
echo "Detected GUID: $GUID"
```

Set namespace and URL:
```bash
SHOWROOM_NS=showroom-$GUID
SHOWROOM=https://$(oc get route showroom -n $SHOWROOM_NS -o jsonpath='{.spec.host}')
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Showroom namespace: $SHOWROOM_NS"
echo "Showroom URL:       $SHOWROOM"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
```

### VM labs

```bash
ssh -i <key> <user>@<host> "hostname && id"
SHOWROOM=https://<showroom-fqdn>
echo "Showroom URL: $SHOWROOM"
```

---

## Step 2: Push Playbooks

```bash
cd $SHOWROOM_PATH
git add runtime-automation/$MODULE_NAME/
git commit -m "Add solve/validate for $MODULE_NAME"
git push
echo "✓ Playbooks pushed"
```

---

## Step 3: Restart Showroom

### OCP labs

```bash
echo "Restarting Showroom pod..."
oc rollout restart deployment/showroom -n $SHOWROOM_NS
oc rollout status deployment/showroom -n $SHOWROOM_NS --timeout=120s
echo "✓ Showroom restarted"
```

### VM labs

```bash
echo "Restarting Showroom container..."
ssh -i <key> <user>@<host> "podman restart showroom && echo restarted"
echo "✓ Showroom restarted"
```

---

## Step 4: Full Test Cycle

Run each step, capture output, show it to the user, and report the result.

### 4a — Fresh validate (expect ❌)

```bash
echo ""
echo "━━━ STEP 1: FRESH VALIDATE ━━━━━━━━━━━━━━━━"
echo "Expected: all tasks ❌ (student hasn't done anything yet)"
echo ""
curl -sk -N $SHOWROOM/stream/validate/$MODULE_NAME
```

**Evaluate:** If ALL tasks pass here → warn the user:
```
⚠️  All tasks passed without solving. The validate checks may be too loose
    (checking something that already exists in the cluster).
    Review validate.yml and tighten the checks.
```

If tasks fail as expected → proceed to solve.

### 4b — Solve

```bash
echo ""
echo "━━━ STEP 2: SOLVE ━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Running solve playbook..."
echo ""
curl -sk -N $SHOWROOM/stream/solve/$MODULE_NAME
```

**Evaluate:** Check for `fatal:` lines or Python tracebacks in the output.
If found → capture and report to orchestrator for fix loop.

### 4c — Validate after solve (expect ✅)

```bash
echo ""
echo "━━━ STEP 3: VALIDATE AFTER SOLVE ━━━━━━━━━━"
echo "Expected: all tasks ✅"
echo ""
curl -sk -N $SHOWROOM/stream/validate/$MODULE_NAME
```

**Evaluate:** All tasks should pass. Any ❌ → capture and report for fix loop.

### 4d — Validate again (idempotency check)

```bash
echo ""
echo "━━━ STEP 4: IDEMPOTENCY CHECK ━━━━━━━━━━━━━"
echo "Expected: still all ✅ — solve left clean state"
echo ""
curl -sk -N $SHOWROOM/stream/validate/$MODULE_NAME
```

---

## Step 5: Report Results

Output a structured result for the orchestrator:

```
TEST_RESULT:
  module: <module-name>
  guid: <guid>
  showroom_url: <url>

  fresh_validate:   PASSED_AS_EXPECTED | UNEXPECTED_PASS | ERROR
  solve:            PASSED | ERROR
  validate_post:    PASSED | FAILED | ERROR
  idempotency:      PASSED | FAILED | ERROR

  overall: PASS | FAIL

  errors:
    - step: solve | validate_post | idempotency
      raw_output: |
        <exact lines from curl stream that show the failure>
      failing_task: <task name from stream>
```

If overall is PASS:
```
✅ MODULE PASS: <module-name>

  fresh validate  → ❌ (correct — checks are real)
  solve           → ✅
  validate        → ✅
  idempotency     → ✅

Showroom URL: $SHOWROOM
```

If overall is FAIL, return the error details to the orchestrator so it can send them to
solve-writer or validate-writer for a targeted fix.

---

## Fix Loop Protocol

When the orchestrator sends a fix to apply:

1. The orchestrator will provide updated playbook content
2. Write the file, then:

```bash
cd $SHOWROOM_PATH
git add runtime-automation/$MODULE_NAME/
git commit -m "Fix $MODULE_NAME solve/validate"
git push

# OCP restart
oc rollout restart deployment/showroom -n $SHOWROOM_NS
oc rollout status deployment/showroom -n $SHOWROOM_NS --timeout=120s

# VM restart
# ssh -i <key> <user>@<host> "podman restart showroom"
```

3. Re-run the full test cycle (Step 4) and report results again.
