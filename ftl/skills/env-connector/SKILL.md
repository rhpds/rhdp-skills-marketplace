---
name: ftl:env-connector
description: Pushes solve.yml and validate.yml to a live RHDP showroom, restarts the pod, and runs the full test cycle (fresh validate → solve → validate again → idempotency check). Reports pass/fail per task with full output for debugging.
version: 1.0.0
context: main
model: claude-sonnet-4-6
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

## Step 1 — Get Showroom URL

**OCP labs:**
```bash
SHOWROOM_NS=$(oc get namespaces --no-headers 2>/dev/null | awk '{print $1}' | grep "showroom" | grep "$GUID" | head -1)
SHOWROOM_URL="https://$(oc get route showroom -n $SHOWROOM_NS -o jsonpath='{.spec.host}' 2>/dev/null)"
echo "Showroom: $SHOWROOM_URL"
```

**VM labs:**
```bash
SHOWROOM_URL="https://$(ssh -i $SSH_KEY $SSH_USER@$BASTION 'cat /home/lab-user/showroom_url' 2>/dev/null)"
```

---

## Step 2 — Push Content and Restart

**Pull latest in content container (force fresh clone):**
```bash
POD=$(oc get pod -n $SHOWROOM_NS -o name 2>/dev/null | head -1)
oc exec -n $SHOWROOM_NS $POD -c content -- bash -c "
  git config --global --add safe.directory /showroom/repo 2>/dev/null
  git -C /showroom/repo fetch origin main
  git -C /showroom/repo reset --hard origin/main
  git -C /showroom/repo log --oneline -2
" 2>/dev/null
```

If content container doesn't pick up changes, restart the pod:
```bash
oc rollout restart deployment/showroom -n $SHOWROOM_NS
oc rollout status deployment/showroom -n $SHOWROOM_NS --timeout=60s
```

Verify the correct files are deployed:
```bash
POD=$(oc get pod -n $SHOWROOM_NS -o name 2>/dev/null | head -1)
oc exec -n $SHOWROOM_NS $POD -c runner -- ls /showroom/repo/runtime-automation/
```

---

## Step 3 — Run Full Test Cycle

Run each step sequentially. Capture full output for debugging.

### 3a — Fresh Validate (expect ❌)
```bash
curl -sk -N --max-time 90 "$SHOWROOM_URL/stream/validate/$MODULE" 2>/dev/null
```
Expected: all tasks fail (student hasn't done anything yet).
If any task passes on fresh env → note it (infra check — expected).

### 3b — Solve
```bash
curl -sk -N --max-time 1200 "$SHOWROOM_URL/stream/solve/$MODULE" 2>/dev/null
```
Expected: `✓ Completed successfully!`
Watch for: `fatal:`, `FAILED`, `ignored=N` (N > 0 is OK for expected failures)

### 3c — Validate After Solve (expect ✅)
```bash
curl -sk -N --max-time 90 "$SHOWROOM_URL/stream/validate/$MODULE" 2>/dev/null
```
Expected: all automatable tasks pass.
If any ❌ → capture exact task name and error message for the fix loop.

### 3d — Idempotency Check
Run solve again. Should complete cleanly (no errors, no side effects from running twice).

---

## Step 4 — Parse and Report Results

Extract results from SSE stream:

```python
# Parse SSE output
for line in output.split('\n'):
    if 'data:' in line:
        # Extract msg fields for ✅/❌
        # Detect "Completed successfully" vs "Failed"
```

Report format:
```
TEST RESULT: <MODULE>

  fresh validate:     ❌ all failed (expected)
  solve:              ✅ Completed successfully (ignored=1 expected)
  validate after:     ✅ Task 1 ✅ Task 2 ✅ Task 3 ❌ Task 4
  idempotency:        ✅ clean

FAILING TASK: Task 4
  Error: MTA analysis still running — come back in a few minutes
  Root cause: Async analysis not completed within test window

RECOMMENDATION:
  Task 4 is async — analysis takes 5-25 min on fresh cluster.
  The ❌ is expected on first run. Validate passes once analysis completes.
  Consider: do not include Task 4 in the required check: condition.
```

---

## Step 5 — Screenshot Evidence Collection

After each Playwright step in the solve, capture screenshots as evidence. Store in a structured test-run directory.

### Screenshot naming convention
All Playwright scripts must save screenshots to `/tmp/evidence/step-N-<description>.png`:
```javascript
await page.screenshot({ path: '/tmp/evidence/step-01-login.png' });
await page.screenshot({ path: '/tmp/evidence/step-02-mta-questionnaire.png' });
```

### Pull screenshots from runner pod
```bash
EVIDENCE_DIR="test-runs/${GUID}-$(date +%Y%m%d)/${MODULE}/evidence"
mkdir -p "$EVIDENCE_DIR"
POD=$(oc get pod -n $SHOWROOM_NS -o name 2>/dev/null | head -1)
oc exec -n $SHOWROOM_NS $POD -c runner -- ls /tmp/evidence/ 2>/dev/null && \
  oc cp $SHOWROOM_NS/${POD#pod/}:/tmp/evidence/ "$EVIDENCE_DIR/" -c runner 2>/dev/null
```

### Generate report.md with embedded screenshots
```markdown
# Test Run: <module> (GUID: <guid>)
Date: <date>

## Results
✅ Task 1: ...
❌ Task 4: Analysis still running

## Evidence
### Step 2 — MTA questionnaire toggled
![questionnaire](evidence/step-02-mta-questionnaire.png)
```

### Version tracking
Capture UI versions during the run for drift detection:
```bash
# Store UI version context
cat > "test-runs/${GUID}-$(date +%Y%m%d)/ui-versions.json" << EOF
{
  "date": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "guid": "$GUID",
  "module": "$MODULE"
}
EOF
```

---

## Step 6 — Self-Healing: Playwright Failure Recovery

When a Playwright step fails, do NOT immediately return FAIL. Run the self-healing loop:

### 1. Capture current state screenshot
```bash
# Get the failure screenshot (scripts save to /tmp/playwright-debug.png on failure)
oc cp $SHOWROOM_NS/${POD#pod/}:/tmp/playwright-debug.png \
  "test-runs/${GUID}-$(date +%Y%m%d)/${MODULE}/evidence/failure-screenshot.png" -c runner
```

### 2. Compare against reference (previous passing run)
If a reference screenshot exists from a previous passing run:
- Compare visually — does the page look different?
- If significant difference → UI likely changed, not a code bug

### 3. Pass BOTH screenshots to vision for selector recovery
Read the failure screenshot and (if available) the reference screenshot. Ask:
```
Vision prompt:
  Reference screenshot: [previous passing run screenshot]
  Current screenshot: [current failure state]
  Failed step: "<description of what Playwright was trying to do>"

  Questions:
  1. Has the UI layout changed between screenshots?
  2. Where is the element "<intent>" in the current screenshot?
  3. What CSS selector or accessible name would reliably target it?
  4. What changed in the UI that caused the failure?
```

### 4. Generate updated selector from vision output
Vision returns:
```
UI changed: YES — button moved from toolbar to dropdown menu
New location: Under "Actions" dropdown, second item
Suggested selector: page.getByRole('menuitem', { name: /Try in Playground/ })
Updated step: await page.getByRole('button', { name: 'Actions' }).click();
              await page.getByRole('menuitem', { name: /Try in Playground/ }).click();
```

### 5. Patch the Playwright script and retry
Update the `.js` file in the showroom repo with the new selector, push, and re-run the step.
If the retry passes → commit the updated script.
If it fails again → escalate to TEST_RESULT: FAIL with full context.

### Self-healing decision tree
```
Playwright step fails
  │
  ├── Take current screenshot
  ├── Is this the same error as last run?
  │     YES → not a UI change, genuine bug → FAIL
  │     NO  → possible UI change
  │
  ├── Compare with reference screenshot
  │     Visual diff significant → UI changed
  │     Pass both to vision
  │
  ├── Vision returns new selector
  │     Update .js file → retry
  │     Retry passes → commit fix → continue
  │     Retry fails  → FAIL with full context
  │
  └── No reference screenshot → first run baseline
        Store screenshot as reference for next run
```

---

## Step 7 — Runner Zombie Check

If a previous solve left a stuck process, the runner won't accept new requests. Check and fix:

```bash
POD=$(oc get pod -n $SHOWROOM_NS -o name 2>/dev/null | head -1)
oc exec -n $SHOWROOM_NS $POD -c runner -- ps aux 2>/dev/null | grep "ansible\|defunct"
```

If zombie found → delete pod to force restart:
```bash
oc delete pod -n $SHOWROOM_NS ${POD#pod/}
oc rollout status deployment/showroom -n $SHOWROOM_NS --timeout=60s
```

---

## Step 8 — Output TEST_RESULT

Return structured result for the orchestrator fix loop:

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
  solve: <key lines from solve output>
  validate: <key lines from validate output>
```
