# Common Pitfalls — All Lab Types

Cross-cutting issues that apply to OCP tenant, OCP dedicated, and RHEL VM labs.
Referenced from ocp-tenant.md, ocp-dedicated.md, and vm-rhel.md.

---

## regex_search | first crashes on no match

`regex_search` returns `None` when there is no match. `None | first` raises a type error.
Use separate shell tasks instead:

```yaml
# WRONG
myvar: "{{ r_out.stdout | regex_search('KEY=(.+)', '\\1') | first }}"

# CORRECT — separate tasks, no filter chain
- name: Get value
  ansible.builtin.shell: "grep '^KEY=' /etc/myapp/config | cut -d= -f2"
  register: r_val

- ansible.builtin.set_fact:
    myvar: "{{ r_val.stdout | trim }}"
```

---

## JSON parsing in k8s_exec — use python3, not from_json

Ansible's `from_json` filter fails when stdout contains deprecation warnings before the JSON payload.
Parse inside the exec command instead:

```yaml
command: >-
  sh -c 'curl -s http://localhost:8080/items
  | python3 -c "import json,sys;
    items=json.load(sys.stdin);
    print(any(i[\"name\"]==\"target\" for i in items))"'
```

---

## k8s_exec command must be a string, not a list

```yaml
# WRONG — Kubernetes treats the first list item as the executable name
kubernetes.core.k8s_exec:
  command:
    - python3
    - -c
    - "print('hello')"

# CORRECT
kubernetes.core.k8s_exec:
  command: "python3 -c \"print('hello')\""
```

---

## Idempotency — guard every create

Solve runs every time a student retries. Always make creates safe to run twice:

```yaml
# kubernetes.core.k8s — naturally idempotent with state: present
kubernetes.core.k8s:
  state: present

# oc create — use apply pattern
ansible.builtin.shell: >-
  {{ oc }} create configmap my-cm --from-literal=key=val -n {{ student_ns }}
  --dry-run=client -o yaml | {{ oc }} apply -f -

# NEVER use 2>/dev/null || true — swallows real errors (auth failure, cluster down)
```

---

## dev.yaml silently kills content_git_repo_ref

If `dev.yaml` contains:
```yaml
ocp4_workload_showroom_content_git_repo_ref: main
```
The showroom pod will ALWAYS clone from `main` even if you push to a feature branch.
Check before every test session:

```bash
grep "ocp4_workload_showroom_content_git_repo_ref" dev.yaml
```

Remove or comment it out during development.

---

## Check durable outcomes, not transient state

```yaml
# WRONG — pod may restart, branch may change
_ok: "{{ r_pods.resources | length > 0 }}"
_ok: "{{ 'module3' in r_git_branch.stdout }}"

# CORRECT — file persists, ConfigMap persists
_ok: "{{ r_file.stat.exists }}"
_ok: "{{ r_cm.resources | length > 0 }}"
```

---

## Async operations — any() not max()

When solve triggers a long operation (analysis, build), validate must detect completion correctly:

```python
# WRONG — new queued tasks block the completed one
max(tasks, key=lambda t: t["id"])["state"] in ["Succeeded"]

# CORRECT — any completed task passes regardless of new queued tasks
any(t.get("state") in ["Succeeded", "Completed"]
    for t in tasks if t.get("addon") == "analyzer")
```

---

## validation_check FQCN

Always use the fully-qualified collection name:

```yaml
# CORRECT
rhpds.ftl.validation_check:
  check: "{{ _ok }}"

# WRONG — bare name fails if collection routing not configured
validation_check:
  check: "{{ _ok }}"
```

The module is provided by the `rhpds-ftl` collection. This collection must be in
`requirements_content` in your AgV `common.yaml`.
