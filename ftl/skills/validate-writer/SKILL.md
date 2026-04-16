---
name: ftl:validate-writer
description: Writes validate.yml playbooks using the validation_check Ansible plugin. Takes the content-reader task report and solve-writer actions as input, producing checks that verify student progress without manual steps or navigation instructions.
version: 1.0.0
context: main
model: claude-sonnet-4-6
---

# ftl:validate-writer — Ansible Validate Playbook Generator

Writes `validate.yml` — a playbook using `validation_check` that verifies the student has completed each automatable step.

**Self-contained. No ECC dependency.**

---

## What You Receive

- `CONTENT_REPORT` — from content-reader (student steps + classifications)
- `SOLVE_ACTIONS` — from solve-writer (what the solver does)
- `LAB_TYPE` — `ocp-tenant` | `ocp-dedicated` | `vm-rhel`

---

## Step 1 — Determine What to Check

For each step from CONTENT_REPORT, determine the **durable outcome** — something that persists after the student completes the step and can be verified via API/k8s without UI:

| Step type | Durable outcome to check |
|---|---|
| API token generated | API returns token for student user |
| Config file written | File exists at expected path in workspace pod |
| k8s resource deployed | Deployment/Pod running in correct namespace |
| Analysis triggered (async) | Latest analysis task has Succeeded state |
| Git branch switched | `git branch --show-current` = expected branch |
| Extension installed | Directory exists in extensions path |

**Do NOT check:**
- Which UI page the student is on
- Whether they reviewed/scrolled through results
- Git branch (if subsequent steps change it — check durable outcome instead)

---

## Step 2 — Generate validate.yml

### Standard header
```yaml
---
- name: <Module Title> Validation
  hosts: localhost
  connection: local
  gather_facts: false
  vars:
    student_user: "{{ user | default('') }}"
    # same namespace/service vars as solve.yml
  tasks:
```

### Check pattern
```yaml
    # -------------------------------------------------------
    # Check N — <description>
    # -------------------------------------------------------
    - name: Check <thing>
      ansible.builtin.uri:        # or k8s_info / k8s_exec / wait_for
        ...
        validate_certs: false
        timeout: 10
      register: r_<name>
      ignore_errors: true
```

### Build results and validation_check
```yaml
    - name: Build task results
      ansible.builtin.set_fact:
        _task1_ok: "{{ <condition> }}"
        _task2_ok: "{{ <condition> }}"

    - name: Validate all tasks
      rhpds.ftl.validation_check:
        check: "{{ _task1_ok and _task2_ok }}"
        pass_msg: |
          ✅ Task 1: <what passed>
          ✅ Task 2: <what passed>
        error_msg: |
          {{ '✅' if _task1_ok else '❌' }} Task 1: {{ 'ok' if _task1_ok else 'FAILED — <how to fix>' }}
          {{ '✅' if _task2_ok else '❌' }} Task 2: {{ 'ok' if _task2_ok else 'FAILED — <how to fix>' }}
```

---

## Step 3 — Check Patterns by Type

**API key exists:**
```yaml
- ansible.builtin.uri:
    url: "{{ maas_api_url }}/v1/api-keys"
    method: GET
    headers:
      X-MaaS-Username: "{{ student_user }}"
    validate_certs: false
    timeout: 10
  register: r_api_keys
  ignore_errors: true

# _task_ok: "{{ r_api_keys.json | default([]) | length > 0 }}"
```

**File exists in workspace:**
```yaml
- kubernetes.core.k8s_exec:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    namespace: "{{ student_user }}-devworkspace"
    pod: "{{ workspace_pod }}"
    command: "sh -c 'test -f /path/to/file && echo exists || echo missing'"
  register: r_file
  ignore_errors: true

# _task_ok: "{{ 'exists' in (r_file.stdout | default('')) }}"
```

**Pod running:**
```yaml
- kubernetes.core.k8s_info:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    kind: Pod
    namespace: "{{ student_user }}-coolstore"
    label_selectors:
      - "deployment=coolstore-database"
  register: r_pod
  ignore_errors: true

# _task_ok: "{{ r_pod.resources | default([]) | selectattr('status.phase', 'equalto', 'Running') | list | length > 0 }}"
```

**Service reachable via exec (NetworkPolicy blocked from runner):**
```yaml
- kubernetes.core.k8s_exec:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    namespace: "{{ student_user }}-mta"
    pod: "{{ mta_hub_pod }}"
    command: "sh -c 'curl -s -o /dev/null -w \"%{http_code}\" http://localhost:8080/applications'"
  register: r_health
  ignore_errors: true

# _task_ok: "{{ '200' in (r_health.stdout | default('')) }}"
```

**Async operation completed (use `any()` not `max()`):**
```yaml
- kubernetes.core.k8s_exec:
    ...
    command: "sh -c 'curl -s \"http://localhost:8080/tasks?kind=analyzer\" | python3 -c \"import json,sys; tasks=json.load(sys.stdin); print(any(t.get(\\\"state\\\") in [\\\"Succeeded\\\",\\\"Completed\\\"] for t in tasks if t.get(\\\"addon\\\")==\\\"analyzer\\\"))\"'"
  register: r_analysis
  ignore_errors: true

# _task_ok: "{{ r_analysis is defined and 'True' in (r_analysis.stdout | default('')) }}"
# error_msg for async: "❌ Task N: Analysis still running — come back in a few minutes and click Validate again"
```

**Route reachable:**
```yaml
- kubernetes.core.k8s_info:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    api_version: route.openshift.io/v1
    kind: Route
    name: coolstore
    namespace: "{{ student_user }}-coolstore"
  register: r_route
  ignore_errors: true

- ansible.builtin.set_fact:
    app_url: "https://{{ (r_route.resources | default([]) | map(attribute='spec.host') | list | first) | default('') }}"
  when: r_route.resources | default([]) | length > 0

- ansible.builtin.uri:
    url: "{{ app_url }}"
    method: GET
    validate_certs: false
    timeout: 10
    status_code: [200, 301, 302]
  register: r_app
  when: app_url is defined and app_url | length > 10
  ignore_errors: true

# _task_ok: "{{ r_app is defined and r_app is not failed and r_app is not skipped }}"
```

---

## Step 4 — Critical Rules

1. **`check: "true"` is always-pass — never use it.** Always use real conditions.
2. **`student_user: "{{ user | default('') }}"`** must be in every playbook.
3. **No manual steps in output** — validate never says "navigate to" or "click".
4. **For async ops** — check if ANY matching task Succeeded, not just the latest (`max()` breaks when new tasks queue after success).
5. **Durable outcomes only** — don't check git branch if it changes between modules; check the file/resource that proves the step was done instead.
6. **Error messages** — tell the student EXACTLY what failed and how to fix it:
   ```
   ❌ Task 2: provider-settings.yaml missing — run Solve or configure LLM settings in DevSpaces
   ```
7. **k8s_exec for JSON parsing** — parse inside the exec command with python3, not Ansible `from_json` (extra content in stdout causes parse errors).

---

## Step 5 — Output

Return:
1. Full `validate.yml` content
2. `VALIDATION_SUMMARY` — brief list of what the validator checks (passed to env-connector):
```
VALIDATION_SUMMARY:
  - Task 1: MTA hub reachable
  - Task 2: Legacy Pathfinder questionnaire required
  - Task 3: Customers app has Git repo configured
  - Task 4: MTA analysis completed (async — may need retry)
```
