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
