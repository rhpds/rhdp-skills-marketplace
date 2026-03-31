# OCP Tenant Patterns

Runner: inside showroom pod (zerotouch chart). Uses `k8s_kubeconfig` extravar.
Auth: `zt-runner` SA with admin RoleBinding in each student namespace.

## Extravars Available

```
student_user  = devuser-{guid}
student_ns    = devuser-{guid}-zttest   (first suffix)
student_ns2   = devuser-{guid}-ztworkspace  (second suffix)
k8s_kubeconfig = /tmp/zt-runner-XXXX.kubeconfig
guid
```

## solve.yml — Create a Kubernetes Resource

```yaml
---
- name: Module N Solve — <description>
  hosts: localhost
  connection: local
  gather_facts: false
  tasks:
    - name: Create <resource-name>
      kubernetes.core.k8s:
        kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
        validate_certs: false
        state: present
        definition:
          apiVersion: v1
          kind: ConfigMap         # or Secret, Deployment, etc.
          metadata:
            name: <resource-name>
            namespace: "{{ student_ns }}"   # or student_ns2
          data:
            key: value
```

## validation.yml — Multi-Task Check

```yaml
---
- name: Module N Validation — <description>
  hosts: localhost
  connection: local
  gather_facts: false
  tasks:
    # --- Check each task ---
    - name: Check Task 1 — <resource> exists
      kubernetes.core.k8s_info:
        kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
        validate_certs: false
        api_version: v1
        kind: ConfigMap
        name: <resource-name>
        namespace: "{{ student_ns }}"
      register: r_task1

    - name: Check Task 2 — <data field correct>
      ansible.builtin.set_fact:
        _task2_check: >-
          {{ r_task1.resources | length > 0 and
             r_task1.resources[0].data is defined and
             r_task1.resources[0].data.get('key', '') == 'expected' }}

    # --- Aggregate and report ---
    - name: Build task summary
      ansible.builtin.set_fact:
        _task1_ok: "{{ r_task1.resources | length > 0 }}"
        _task2_ok: "{{ _task2_check }}"

    - name: Validate all tasks
      validation_check:
        check: "{{ _task1_ok and _task2_ok }}"
        pass_msg: |
          ✅ Task 1: <description>
          ✅ Task 2: <description>
        error_msg: |
          {{ '✅' if _task1_ok else '❌' }} Task 1: <description>
          {{ '✅' if _task2_ok else '❌' }} Task 2: <description>

          Fix missing tasks:
          {% if not _task1_ok %}  oc create configmap <name> --from-literal=key=value -n {{ student_ns }}
          {% endif %}{% if not _task2_ok %}  oc patch configmap <name> --type=merge -p '{"data":{"key":"expected"}}' -n {{ student_ns }}
          {% endif %}
```

## setup.yml — Stub

```yaml
---
- name: Module N Setup
  hosts: localhost
  connection: local
  gather_facts: false
  tasks:
    - ansible.builtin.debug:
        msg: "Setup complete — proceed with the module instructions."
```

## Resource Type Quick Reference

| Student does | kubernetes.core check | register field |
|---|---|---|
| `oc create configmap` | `kind: ConfigMap` | `r.resources[0].data.KEY` |
| `oc create secret` | `kind: Secret` | `r.resources[0].data` (base64) |
| `oc create deployment` | `kind: Deployment` | `r.resources[0].status.availableReplicas` |
| `oc expose svc` / route | `kind: Route` | `r.resources[0].spec.host` |
| `oc create -f` (any) | `kind: <Kind>` | `r.resources \| length > 0` |
| RBAC role binding | `kind: RoleBinding` | `r.resources \| length > 0` |

## Developer Impersonation (Dedicated Labs Only)

For tasks the student does as a non-admin user:

```yaml
    - name: Check resource as developer
      kubernetes.core.k8s_info:
        kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
        validate_certs: false
        impersonate_user: developer
        kind: ConfigMap
        name: <name>
        namespace: <ns>
      register: r_dev
```

## Test Commands (OCP — from laptop)

```bash
SHOWROOM="https://<showroom-url>"

# Solve
JOB=$(curl -sk -X POST "$SHOWROOM/runner/api/module-N/solve" \
  | python3 -c "import json,sys; print(json.load(sys.stdin)['Job_id'])")
sleep 30 && curl -sk "$SHOWROOM/runner/api/job/$JOB" | python3 -m json.tool

# Validate
JOB=$(curl -sk -X POST "$SHOWROOM/runner/api/module-N/validation" \
  | python3 -c "import json,sys; print(json.load(sys.stdin)['Job_id'])")
sleep 30 && curl -sk "$SHOWROOM/runner/api/job/$JOB" | python3 -m json.tool
```

## Non-Automatable Steps Pattern (Browser / GitHub / Manual Actions)

Use when a module step requires browser interaction, GitHub setup, or any action that cannot be scripted.

### solve.yml — Show manual instructions as output

Use `validation_check` with `check: true` so it always "succeeds" but shows the manual instructions in the output:

```yaml
---
- name: Module N Solve — manual steps required
  hosts: localhost
  connection: local
  gather_facts: false
  tasks:
    - name: Automate what can be automated
      kubernetes.core.k8s:
        kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
        validate_certs: false
        state: present
        definition: ...   # do the automatable parts

    - name: Show manual instructions for non-automatable steps
      validation_check:
        check: true   # always passes — this is an instruction step
        pass_msg: |
          ✅ Automated parts complete.

          ⚠️  MANUAL STEPS REQUIRED — complete these in your browser:

          1. Go to https://github.com/<your-org> and fork the repo
          2. In your fork, go to Settings → Webhooks → Add webhook
          3. Set Payload URL to: https://your-app-url/webhook
          4. Select: application/json, push events only
          5. Click Save

          Once done, click Validate to confirm.
```

### validation.yml — Check what's possible, warn about the rest

```yaml
---
- name: Module N Validation — automated checks + manual step warnings
  hosts: localhost
  connection: local
  gather_facts: false
  tasks:
    # Check the things we CAN automate
    - name: Check automated resource exists
      kubernetes.core.k8s_info:
        kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
        validate_certs: false
        kind: Deployment
        name: my-app
        namespace: "{{ student_ns }}"
      register: r_deploy

    - name: Build task summary
      ansible.builtin.set_fact:
        _task1_ok: "{{ r_deploy.resources | length > 0 }}"
        # Manual steps are always True — we can't check them, just warn
        _task2_manual: true

    - name: Validate
      validation_check:
        check: "{{ _task1_ok }}"   # only fail on automatable tasks
        pass_msg: |
          ✅ Task 1: Deployment my-app exists in {{ student_ns }}
          ⚠️  Task 2: GitHub webhook setup — manual step, not automatically verified
        error_msg: |
          {{ '✅' if _task1_ok else '❌' }} Task 1: Deployment my-app exists in {{ student_ns }}
          ⚠️  Task 2: GitHub webhook setup — manual step, not automatically verified

          Fix Task 1:
            oc apply -f deployment.yaml -n {{ student_ns }}

          For Task 2 — complete in your browser:
            1. Fork the repo at https://github.com/...
            2. Add webhook in repo Settings
```

### When the ENTIRE module is manual

If nothing can be automated at all:

```yaml
---
- name: Module N Validation — all manual steps
  hosts: localhost
  connection: local
  gather_facts: false
  tasks:
    - name: Acknowledge manual completion
      validation_check:
        check: true   # always passes — student self-certifies
        pass_msg: |
          ⚠️  This module requires manual browser steps.

          Please confirm you have completed:
            □ Forked the GitHub repository
            □ Configured the webhook (Settings → Webhooks)
            □ Triggered the pipeline by pushing a commit

          If not done yet — complete the steps above, then click Validate again.
          Use the Skip button if you want to proceed without completing this module.
```

### ui-config.yml — Always keep skipModuleEnabled

```yaml
skipModuleEnabled: true   # safety net — allows proceeding past manual modules
```

### When generating — ask the developer

```
Is this step automatable, or does it require browser/GitHub/manual action?

If manual:
  A) Partial — some tasks can be automated, some cannot
     (wrap automatable parts, show ⚠️ warning for the rest)
  B) Fully manual — nothing can be scripted
     (solve shows instructions, validate always passes with warning)
```
