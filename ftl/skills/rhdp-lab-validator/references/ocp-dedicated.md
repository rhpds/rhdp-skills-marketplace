# OCP Dedicated — Playbook Patterns

Used when `lab_type: ocp-dedicated` (single-user dedicated cluster, `config: openshift-workloads`).
No multi-user namespaces. SA must be cluster-admin.

---

## AgV requirements (cluster-admin always required for dedicated)

```yaml
ocp4_workload_runtime_automation_k8s_cluster_admin: true
ocp4_workload_runtime_automation_k8s_openshift_api_url: "{{ openshift_api_url }}"
ocp4_workload_runtime_automation_k8s_openshift_api_token: "{{ openshift_cluster_admin_token }}"
```

---

## Extravars injected automatically

```
k8s_kubeconfig    — path to cluster-admin kubeconfig for zt-runner SA
student_ns        — EMPTY for dedicated clusters — do not rely on this
student_user      — may also be empty
guid              — environment GUID
```

---

## CRITICAL: student_ns is empty on dedicated

Always provide a fixed namespace fallback:

```yaml
namespace: "{{ student_ns | default('demo-project', true) | trim }}"
```

Or create the namespace in solve.yml:

```yaml
- name: Ensure project exists
  kubernetes.core.k8s:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    validate_certs: false
    state: present
    definition:
      apiVersion: project.openshift.io/v1
      kind: ProjectRequest
      metadata:
        name: demo-project
```

---

## CRITICAL: Always pass kubeconfig

Same rule as OCP tenant — plain `oc` uses the showroom SA (no cluster access).

**For kubernetes.core modules:**
```yaml
kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
validate_certs: false
```

**For shell tasks using `oc`:**
```yaml
vars:
  oc: "oc --kubeconfig={{ k8s_kubeconfig }}"
```

---

## k8s_exec — command MUST be a string, not a list

```yaml
# CORRECT
kubernetes.core.k8s_exec:
  kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
  namespace: my-namespace
  pod: "{{ pod_name }}"
  command: "sh -c 'curl -s http://localhost:8080/status'"
```

---

## Solver priority ladder

Same as OCP tenant — prefer k8s_exec to bypass NetworkPolicy.

---

## Idempotency — solve runs multiple times

Use `state: present` with kubernetes.core.k8s. Guard shell operations:

```yaml
# oc create is NOT idempotent — use apply pattern
ansible.builtin.shell: "{{ oc }} create ns my-ns --dry-run=client -o yaml | {{ oc }} apply -f -"
```

---

## Namespace discovery — probe, don't list

The zt-runner SA cannot list cluster namespaces. Probe known candidates:

```yaml
# Must be inside an ansible.builtin.shell task — {{ oc }} is Ansible templating
- name: Find shared namespace
  ansible.builtin.shell: |
    for ns in stackrox rhacs my-app; do
      if {{ oc }} get namespace ${ns} 2>/dev/null | grep -q Active; then
        echo ${ns}; break
      fi
    done
  vars:
    oc: "oc --kubeconfig={{ k8s_kubeconfig }}"
  register: r_ns
```

---

## Common pitfalls

See `references/common-pitfalls.md` for regex_search, JSON parsing, and other cross-cutting issues.

---

## Working examples

- https://github.com/rhpds/showroom_template_nookbag/tree/e2e-template/examples/e2e-ocp-dedicated
- https://github.com/rhpds/agnosticv/tree/master/tests/zt-ocp-dedicated-grading
