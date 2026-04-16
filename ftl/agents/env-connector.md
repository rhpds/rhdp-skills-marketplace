---
description: Pushes solve.yml and validate.yml to a live RHDP showroom, restarts the pod, and runs the full test cycle (fresh validate → solve → validate again → idempotency check). Reports pass/fail per task with full output for debugging.
model: claude-sonnet-4-6
tools:
  - Bash
  - Read
  - Write
  - Glob
---

# ftl:env-connector — Live Environment Test Runner

Pushes playbooks to a running Showroom pod and runs the full test cycle. Requires a live lab environment and cluster access.

**Self-contained. No ECC dependency.**

---

## What You Receive

- `LAB_TYPE` — `ocp-tenant` | `ocp-dedicated` | `vm-rhel`
- `SHOWROOM_PATH` — local path to showroom repo
- `MODULE_NAME` — e.g., `module-01-mta-analysis`
- `GUID` — lab GUID (e.g., `m8vxw`)
- `ACCESS` — kubeconfig path, OCP token, or SSH details
- `VALIDATION_SUMMARY` — from validate-writer

---

## Step 1 — Get Showroom Pod and URL

**OCP labs:**
```bash
SHOWROOM_NS=$(oc get namespaces --no-headers 2>/dev/null | awk '{print $1}' | grep "showroom" | grep "$GUID" | head -1)
POD=$(oc get pods -n $SHOWROOM_NS --no-headers | awk '{print $1}' | head -1)
SHOWROOM_URL="https://$(oc get route showroom -n $SHOWROOM_NS -o jsonpath='{.spec.host}' 2>/dev/null)"
echo "NS: $SHOWROOM_NS  Pod: $POD  URL: $SHOWROOM_URL"
```

**VM labs:**
```bash
SHOWROOM_URL="https://$(ssh -i $SSH_KEY $SSH_USER@$BASTION 'cat /home/lab-user/showroom_url' 2>/dev/null)"
```

---

## Step 2 — Push Playbooks Directly to Runner Pod

The runner reads playbooks from `/showroom/repo/runtime-automation/` inside the pod. Use `oc cp` to push local files in-place — no restart needed.

```bash
MODULE=<module-name>
NS=$SHOWROOM_NS

oc cp -n $NS \
  $SHOWROOM_PATH/runtime-automation/$MODULE/solve.yml \
  "$NS/$POD:/showroom/repo/runtime-automation/$MODULE/solve.yml" -c runner

oc cp -n $NS \
  $SHOWROOM_PATH/runtime-automation/$MODULE/validation.yml \
  "$NS/$POD:/showroom/repo/runtime-automation/$MODULE/validation.yml" -c runner

echo "Pushed solve.yml and validation.yml to runner"
```

Verify:
```bash
oc exec -n $NS $POD -c runner -- ls /showroom/repo/runtime-automation/$MODULE/
```

---

## Step 3 — Run Full Test Cycle

Run sequentially. Capture and parse output at each step.

### 3a — Runner health check
```bash
oc exec -n $NS $POD -c runner -- curl -s http://localhost:8501/health
```
Expected: `{"status":"healthy"}`

If stuck (zombie ansible process):
```bash
oc exec -n $NS $POD -c runner -- ps aux | grep "ansible\|defunct"
# If found → delete pod to restart
oc delete pod -n $NS $POD
oc rollout status deployment/showroom -n $NS --timeout=60s
POD=$(oc get pods -n $NS --no-headers | awk '{print $1}' | head -1)
```

### 3b — Fresh Validate (expect ❌ or infra-only passes)
```bash
oc exec -n $NS $POD -c runner -- \
  curl -s --no-buffer "http://localhost:8501/validate/$MODULE" 2>/dev/null
```
Note which tasks pass on a fresh env — those are infra checks, not student steps.

### 3c — Solve
```bash
oc exec -n $NS $POD -c runner -- \
  curl -s --no-buffer "http://localhost:8501/solve/$MODULE" 2>/dev/null
```
Expected: `✓ Completed successfully!`
Watch for: `fatal:`, `FAILED`, unexpected `ignored=N`

### 3d — Validate After Solve (expect ✅)
```bash
oc exec -n $NS $POD -c runner -- \
  curl -s --no-buffer "http://localhost:8501/validate/$MODULE" 2>/dev/null
```
Expected: all automatable tasks ✅

### 3e — Idempotency (run solve again)
```bash
oc exec -n $NS $POD -c runner -- \
  curl -s --no-buffer "http://localhost:8501/solve/$MODULE" 2>/dev/null
```
Expected: completes cleanly, no errors, no destructive side effects

---

## Step 4 — Screenshot Evidence Collection

After solve, pull any Playwright screenshots as evidence:
```bash
EVIDENCE_DIR="test-runs/${GUID}-$(date +%Y%m%d)/${MODULE}/evidence"
mkdir -p "$EVIDENCE_DIR"
oc exec -n $NS $POD -c runner -- ls /tmp/evidence/ 2>/dev/null && \
  oc cp "$NS/$POD:/tmp/evidence/" "$EVIDENCE_DIR/" -c runner 2>/dev/null
oc cp "$NS/$POD:/tmp/playwright-evidence-${MODULE}.png" \
  "$EVIDENCE_DIR/" -c runner 2>/dev/null || true
echo "Evidence saved to $EVIDENCE_DIR"
```

---

## Step 5 — Self-Healing: Playwright Failure Recovery

When a Playwright step fails:

1. Pull the debug screenshot:
```bash
oc cp "$NS/$POD:/tmp/playwright-debug.png" \
  "test-runs/${GUID}-$(date +%Y%m%d)/${MODULE}/failure-screenshot.png" -c runner
```

2. Read the failure screenshot with vision. Ask:
   - Has the UI layout changed?
   - Where is the element described by the INTENT comment?
   - What selector would reliably target it now?

3. Update the Playwright script in the solve.yml with the new selector.

4. Push and re-run the full test cycle.

5. If retry passes → commit the fix.
   If retry fails again → escalate to TEST_RESULT: FAIL.

---

## Step 6 — Output TEST_RESULT

```
TEST_RESULT: PASS | FAIL | PARTIAL

MODULE: <module>
SHOWROOM_URL: <url>

FRESH_VALIDATE: all-failed | partial-passed
SOLVE: passed | failed | error
VALIDATE_AFTER: passed | failed
IDEMPOTENCY: passed | failed | skipped

FAILING_TASKS:
  - Task N: <error message>
    suggestion: <what to fix in solve.yml or validate.yml>

LOGS:
  solve: <key lines>
  validate: <key lines>
```
