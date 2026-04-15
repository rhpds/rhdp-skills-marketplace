# OCP Tenant — Playbook Patterns

Used when `lab_type: ocp-tenant` (`config: namespace` in AgV).
One student namespace per user. Runner has namespace-scoped SA by default.

---

## Extravars injected automatically

```
k8s_kubeconfig    — path to kubeconfig for zt-runner SA
student_ns        — student's namespace, e.g. "user-abc123"
student_user      — student's username, e.g. "user-abc123"
guid              — environment GUID
```

## Connection header (always the same)

```yaml
- name: Module N Solve/Validate
  hosts: localhost
  connection: local
  gather_facts: false
  tasks:
```

---

## CRITICAL: Always pass kubeconfig

The showroom pod runs as the `showroom` SA which has access only to its own namespace.
The zt-runner injects a separate `zt-runner` kubeconfig with proper student access.

**For kubernetes.core modules:**
```yaml
kubernetes.core.k8s:
  kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
  validate_certs: false
```

**For shell tasks using `oc`:**
```yaml
vars:
  oc: "oc --kubeconfig={{ k8s_kubeconfig }}"

tasks:
  - name: Get pods
    ansible.builtin.shell: "{{ oc }} get pods -n {{ student_ns }}"
```

Without `--kubeconfig`, plain `oc` uses the showroom SA and fails with `Forbidden`.

---

## k8s_exec — command MUST be a string, not a list

```yaml
# WRONG — Kubernetes treats "[python3," as the executable name
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

## Solver priority ladder

Use the highest applicable method — go lower only when blocked:

1. **k8s_exec into the target pod** — bypass NetworkPolicy by calling localhost from inside
2. **kubernetes.core.k8s / k8s_info** — k8s API calls (allowed cross-namespace via kubeconfig)
3. **ansible.builtin.uri** — REST API calls
4. **ansible.builtin.wait_for** — TCP port checks
5. **Playwright script** — last resort for browser-only UI

### k8s_exec to bypass NetworkPolicy

NetworkPolicy often blocks cross-namespace HTTP from the runner.
Exec into the target pod and call localhost instead:

```yaml
- name: Get target pod
  kubernetes.core.k8s_info:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    validate_certs: false
    kind: Pod
    namespace: "{{ student_user }}-myapp"
    label_selectors:
      - "app=myapp"
  register: r_pods

- name: Call service from inside pod
  kubernetes.core.k8s_exec:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    namespace: "{{ student_user }}-myapp"
    pod: "{{ r_pods.resources[0].metadata.name }}"
    command: "sh -c 'curl -s http://localhost:8080/healthz'"
  register: r_health
```

---

## Namespace discovery — probe, don't list

The zt-runner SA cannot list all namespaces (cluster-scoped). Probe candidates directly:

```yaml
# Must be inside an ansible.builtin.shell task — {{ oc }} is Ansible templating
- name: Find shared namespace
  ansible.builtin.shell: |
    for ns in stackrox rhacs rhacs-operator; do
      if {{ oc }} get namespace ${ns} 2>/dev/null | grep -q Active; then
        echo ${ns}; break
      fi
    done
  vars:
    oc: "oc --kubeconfig={{ k8s_kubeconfig }}"
  register: r_ns
```

---

## Idempotency — solve runs multiple times

Students retry. Every create operation must be safe to run twice:

```yaml
# kubernetes.core.k8s is idempotent with state: present
kubernetes.core.k8s:
  state: present

# For oc create — use apply pattern
ansible.builtin.shell: "{{ oc }} create configmap my-cm --from-literal=key=val -n {{ student_ns }} --dry-run=client -o yaml | {{ oc }} apply -f -"

# Guard file creation
ansible.builtin.shell: "[ ! -f /path/to/file ] && generate-file || echo already-exists"
```

---

## namespace default fallback

```yaml
namespace: "{{ student_ns | default('default', true) | trim }}"
```

---

## JSON parsing in k8s_exec — use python3, not from_json

`from_json` filter fails when stdout contains deprecation warnings alongside JSON.
Parse inside the exec command:

```yaml
command: "sh -c 'curl -s http://localhost:8080/items | python3 -c \"import json,sys; items=json.load(sys.stdin); print(any(i[\\\"name\\\"]==\\\"target\\\" for i in items))\"'"
```

---

## Async operations (e.g. analysis, builds)

If the solve triggers something that takes minutes:
- Trigger and exit immediately — do NOT wait in solve.yml
- Validate detects: still running → ❌ with "come back later"; completed → ✅

For checking async completion, use `any()` not `max()`:

```python
# WRONG — new queued tasks block completed ones
max(tasks, key=lambda t: t["id"])["state"] in ["Succeeded"]

# CORRECT — any completed task passes regardless of new tasks
any(t.get("state") in ["Succeeded", "Completed"]
    for t in tasks if t.get("addon") == "analyzer")
```

---

## Regex in Ansible — avoid regex_search | first

`regex_search` returns `None` on no match, and `None | first` raises a type error.
Use separate tasks instead:

```yaml
# WRONG
myvar: "{{ r_out.stdout | regex_search('KEY=(.+)', '\\1') | first }}"

# CORRECT
- name: Get value
  ansible.builtin.shell: "{{ oc }} get secret mysecret -n mynamespace -o jsonpath='{.data.key}' | base64 -d"
  register: r_val

- ansible.builtin.set_fact:
    myvar: "{{ r_val.stdout | trim }}"
```

---

## Get extravars from showroom ConfigMap (live cluster)

```bash
oc get configmap showroom-userdata -n showroom-<user> -o jsonpath='{.data.user_data\.yml}'
```

Gives: `user`, `guid`, `password`, `openshift_cluster_ingress_domain`, service URLs, virtual keys.
Inspect this before writing playbooks to know what variables are available.

---

## Working examples

- https://github.com/rhpds/showroom_template_nookbag/tree/e2e-template/examples/e2e-ocp-tenant
- https://github.com/rhpds/agnosticv/tree/master/tests/zt-ocp-pipelines-tenant
- https://github.com/rhpds/private-maas-showroom (LB2860)
- https://github.com/rhpds/rhads-ols-modernize-showroom (LB2010)
