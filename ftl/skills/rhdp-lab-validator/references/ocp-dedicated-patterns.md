# OCP Dedicated + Bastion Patterns

Three task types can appear in a single module. Mix as needed.

## Type A: kubernetes.core (cluster-admin, from runner directly)

```yaml
---
- name: Module N Solve — admin task (no SSH needed)
  hosts: localhost
  connection: local
  gather_facts: false
  tasks:
    - name: Create namespace as cluster-admin
      kubernetes.core.k8s:
        kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
        validate_certs: false
        state: present
        definition:
          apiVersion: v1
          kind: Namespace
          metadata:
            name: demo-project
```

Validation:
```yaml
    - name: Check namespace exists
      kubernetes.core.k8s_info:
        kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
        validate_certs: false
        api_version: v1
        kind: Namespace
        name: demo-project
      register: r_ns
    - ansible.builtin.set_fact:
        _task1_ok: "{{ r_ns.resources | length > 0 }}"
```

## Type B: Bash Script on Bastion (ansible.builtin.script)

Script lives in same directory as solve.yml, gets copied to bastion and run there.
Bastion has `lab-user` with system:admin → `oc` commands work natively.

```yaml
---
- name: Build SSH inventory
  hosts: localhost
  gather_facts: false
  tasks:
    - ansible.builtin.add_host:
        name: bastion
        ansible_host: "{{ bastion_host }}"
        ansible_port: "{{ bastion_port | default(22) }}"
        ansible_user: "{{ student_user }}"
        ansible_password: "{{ bastion_password }}"
        ansible_ssh_common_args: "-o StrictHostKeyChecking=no"

- name: Run solve script on bastion
  hosts: bastion
  gather_facts: false
  tasks:
    - name: Run solve-moduleN.sh
      ansible.builtin.script:
        executable: /bin/bash
        cmd: "{{ playbook_dir }}/solve-moduleN.sh"
      register: r_solve
    - ansible.builtin.debug:
        msg: "{{ r_solve.stdout }}"
```

The bash script (`solve-moduleN.sh`) uses `oc` directly:
```bash
#!/bin/bash
set -euo pipefail
oc create configmap app-config \
  --from-literal=environment=production \
  -n demo-project \
  --dry-run=client -o yaml | oc apply -f -
echo "OK: app-config ConfigMap created"
```

Validation wrapping the bash script:
```yaml
- name: Run validate-moduleN.sh
  ansible.builtin.script:
    executable: /bin/bash
    cmd: "{{ playbook_dir }}/validate-moduleN.sh"
  register: r_validate
  ignore_errors: true
- name: Report
  validation_check:
    check: "{{ r_validate.rc == 0 }}"
    pass_msg: "{{ r_validate.stdout | trim }}"
    error_msg: "{{ r_validate.stdout | trim }}"
```

## Type C: Developer User Tasks (oc --as developer on bastion)

Bastion has system:admin → can impersonate any user with `oc --as developer`.

```yaml
- name: Create resource as developer user
  hosts: bastion
  gather_facts: false
  tasks:
    - name: Create secret as developer
      ansible.builtin.shell: |
        oc create secret generic dev-secret \
          --from-literal=api-key=my-key \
          -n demo-project \
          --as developer \
          --dry-run=client -o yaml | oc apply -f - --as developer
```

Validation:
```yaml
    - name: Check secret as developer
      ansible.builtin.shell: |
        oc get secret dev-secret -n demo-project --as developer
      register: r_secret
      ignore_errors: true
    - ansible.builtin.set_fact:
        _task3_ok: "{{ r_secret.rc == 0 }}"
```

## Combined Module (All Three Types)

```yaml
---
- name: Build SSH inventory
  hosts: localhost
  gather_facts: false
  tasks:
    - ansible.builtin.add_host:
        name: bastion
        ansible_host: "{{ bastion_host }}"
        ansible_port: "{{ bastion_port | default(22) }}"
        ansible_user: "{{ student_user }}"
        ansible_password: "{{ bastion_password }}"
        ansible_ssh_common_args: "-o StrictHostKeyChecking=no"

- name: Type A — kubernetes.core as cluster-admin
  hosts: localhost
  connection: local
  gather_facts: false
  tasks:
    - kubernetes.core.k8s_info:
        kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
        validate_certs: false
        api_version: v1
        kind: Namespace
        name: demo-project
      register: r_ns

- name: Type B+C validation on bastion
  hosts: bastion
  gather_facts: false
  tasks:
    - ansible.builtin.shell: oc get configmap app-config -n demo-project
      register: r_cm
      ignore_errors: true

    - ansible.builtin.shell: oc get secret dev-secret -n demo-project --as developer
      register: r_secret
      ignore_errors: true

    - ansible.builtin.set_fact:
        _task1_ok: "{{ hostvars['localhost']['r_ns'].resources | length > 0 }}"
        _task2_ok: "{{ r_cm.rc == 0 }}"
        _task3_ok: "{{ r_secret.rc == 0 }}"

    - validation_check:
        check: "{{ _task1_ok and _task2_ok and _task3_ok }}"
        pass_msg: |
          ✅ Task 1: Namespace demo-project exists (cluster-admin)
          ✅ Task 2: ConfigMap app-config exists (bastion bash)
          ✅ Task 3: Secret dev-secret accessible as developer
        error_msg: |
          {{ '✅' if _task1_ok else '❌' }} Task 1: Namespace demo-project
          {{ '✅' if _task2_ok else '❌' }} Task 2: ConfigMap app-config
          {{ '✅' if _task3_ok else '❌' }} Task 3: Secret as developer

## Test Commands (OCP Dedicated — from laptop)

```bash
SHOWROOM="https://<showroom-url>"
JOB=$(curl -sk -X POST "$SHOWROOM/runner/api/module-N/solve" \
  | python3 -c "import json,sys; print(json.load(sys.stdin)['Job_id'])")
sleep 35 && curl -sk "$SHOWROOM/runner/api/job/$JOB" | python3 -m json.tool
```
