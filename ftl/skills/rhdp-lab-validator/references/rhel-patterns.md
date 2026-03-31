# RHEL VM + Bastion Patterns

Runner: Podman container ON the bastion (`vm_workload_showroom`).
SSH key at `/app/.ssh/id_rsa`, SSH config at `/app/.ssh/config`.
Config has `Host bastion` (external NodePort) and `Host node`, `Host node01` etc. (cluster service IPs).

## Extravars Available

```
student_user     = lab-user
bastion_host     = ssh.ocpvXX.rhdp.net
bastion_port     = 3XXXX  (NodePort)
bastion_password = <password>
```

## Inventory Setup (Required in Every Playbook)

```yaml
- name: Build SSH inventory
  hosts: localhost
  connection: local
  gather_facts: false
  tasks:
    - name: Add node to inventory
      ansible.builtin.add_host:
        name: node          # or node01, node02, etc.
        ansible_user: lab-user
        ansible_ssh_private_key_file: /app/.ssh/id_rsa
        ansible_ssh_common_args: "-F /app/.ssh/config"

    - name: Add bastion to inventory
      ansible.builtin.add_host:
        name: bastion
        ansible_user: lab-user
        ansible_ssh_private_key_file: /app/.ssh/id_rsa
        ansible_ssh_common_args: "-F /app/.ssh/config"
```

## solve.yml — Tasks on Node and Bastion

```yaml
---
- name: Module N Solve — <description>
  hosts: localhost
  connection: local
  gather_facts: false
  tasks:
    - name: Add node to inventory
      ansible.builtin.add_host:
        name: node
        ansible_user: lab-user
        ansible_ssh_private_key_file: /app/.ssh/id_rsa
        ansible_ssh_common_args: "-F /app/.ssh/config"
    - name: Add bastion to inventory
      ansible.builtin.add_host:
        name: bastion
        ansible_user: lab-user
        ansible_ssh_private_key_file: /app/.ssh/id_rsa
        ansible_ssh_common_args: "-F /app/.ssh/config"

- name: Tasks on node
  hosts: node
  gather_facts: false
  become: true    # add only if sudo needed
  tasks:
    - name: Task 1 — install package
      ansible.builtin.package:
        name: htop
        state: present

    - name: Task 2 — create directory
      ansible.builtin.file:
        path: /home/lab-user/myproject
        state: directory
        mode: "0755"

- name: Tasks on bastion
  hosts: bastion
  gather_facts: false
  tasks:
    - name: Task 3 — create file on bastion
      ansible.builtin.file:
        path: /home/lab-user/lab-notes.txt
        state: touch
        mode: "0644"
```

## solve.yml — Wrapping Existing Bash Scripts

When the developer provides existing `.sh` scripts:

```yaml
---
- name: Module N Solve — run existing solve script on bastion
  hosts: localhost
  connection: local
  gather_facts: false
  tasks:
    - name: Add bastion to inventory
      ansible.builtin.add_host:
        name: bastion
        ansible_user: lab-user
        ansible_ssh_private_key_file: /app/.ssh/id_rsa
        ansible_ssh_common_args: "-F /app/.ssh/config"

- name: Run solve script on bastion
  hosts: bastion
  gather_facts: false
  tasks:
    - name: Run solve-moduleN.sh
      ansible.builtin.script:    # copies script from runner to bastion and runs it
        executable: /bin/bash
        cmd: "{{ playbook_dir }}/solve-moduleN.sh"
      register: r_solve
    - ansible.builtin.debug:
        msg: "{{ r_solve.stdout }}"
```

Note: `solve-moduleN.sh` must live in the same directory as `solve.yml`.

## validation.yml — Multi-Host with Cross-Host Facts

```yaml
---
- name: Module N Validation — <description>
  hosts: localhost
  connection: local
  gather_facts: false
  tasks:
    - name: Add node to inventory
      ansible.builtin.add_host:
        name: node
        ansible_user: lab-user
        ansible_ssh_private_key_file: /app/.ssh/id_rsa
        ansible_ssh_common_args: "-F /app/.ssh/config"
    - name: Add bastion to inventory
      ansible.builtin.add_host:
        name: bastion
        ansible_user: lab-user
        ansible_ssh_private_key_file: /app/.ssh/id_rsa
        ansible_ssh_common_args: "-F /app/.ssh/config"

- name: Check tasks on node
  hosts: node
  gather_facts: false
  tasks:
    - name: Task 1 — check package installed
      ansible.builtin.command: rpm -q htop
      register: r_pkg
      changed_when: false
      ignore_errors: true

    - name: Task 2 — check directory exists
      ansible.builtin.stat:
        path: /home/lab-user/myproject
      register: r_dir

- name: Check task on bastion + report
  hosts: bastion
  gather_facts: false
  tasks:
    - name: Task 3 — check file on bastion
      ansible.builtin.stat:
        path: /home/lab-user/lab-notes.txt
      register: r_notes

    - name: Build task summary (cross-host via hostvars)
      ansible.builtin.set_fact:
        _task1_ok: "{{ hostvars['node']['r_pkg'].rc == 0 }}"
        _task2_ok: "{{ hostvars['node']['r_dir'].stat.exists }}"
        _task3_ok: "{{ r_notes.stat.exists }}"

    - name: Validate all tasks
      validation_check:
        check: "{{ _task1_ok and _task2_ok and _task3_ok }}"
        pass_msg: |
          ✅ Task 1: Package htop installed on node
          ✅ Task 2: Directory /home/lab-user/myproject exists on node
          ✅ Task 3: File lab-notes.txt exists on bastion
        error_msg: |
          {{ '✅' if _task1_ok else '❌' }} Task 1: Package htop installed on node
          {{ '✅' if _task2_ok else '❌' }} Task 2: Directory /home/lab-user/myproject exists on node
          {{ '✅' if _task3_ok else '❌' }} Task 3: File lab-notes.txt exists on bastion

          Fix:
          {% if not _task1_ok %}  ssh node "sudo dnf install -y htop"
          {% endif %}{% if not _task2_ok %}  ssh node "mkdir -p /home/lab-user/myproject"
          {% endif %}{% if not _task3_ok %}  touch /home/lab-user/lab-notes.txt
          {% endif %}
```

## validation.yml — Wrapping Existing Bash Validation Script

```yaml
---
- name: Module N Validation — run existing validate script on bastion
  hosts: localhost
  connection: local
  gather_facts: false
  tasks:
    - name: Add bastion to inventory
      ansible.builtin.add_host:
        name: bastion
        ansible_user: lab-user
        ansible_ssh_private_key_file: /app/.ssh/id_rsa
        ansible_ssh_common_args: "-F /app/.ssh/config"

- name: Run validation script on bastion
  hosts: bastion
  gather_facts: false
  tasks:
    - name: Run validate-moduleN.sh
      ansible.builtin.script:
        executable: /bin/bash
        cmd: "{{ playbook_dir }}/validate-moduleN.sh"
      register: r_validate
      ignore_errors: true

    - name: Report result
      validation_check:
        check: "{{ r_validate.rc == 0 }}"
        pass_msg: "{{ r_validate.stdout | trim }}"
        error_msg: "{{ r_validate.stdout | trim }}"
```

## Check Type Quick Reference

| Task type | Ansible module | Key field |
|---|---|---|
| File exists | `ansible.builtin.stat` | `.stat.exists` |
| Directory exists | `ansible.builtin.stat` | `.stat.exists and .stat.isdir` |
| Package installed | `ansible.builtin.command: rpm -q` | `.rc == 0` |
| Service active | `ansible.builtin.command: systemctl is-active sshd` | `.rc == 0` |
| Command output | `ansible.builtin.command` | `.stdout contains 'expected'` |
| Port listening | `ansible.builtin.wait_for` | module completes without failure |

## Test Commands (RHEL — via bastion SSH)

```bash
# SSH to bastion first
ssh -p <port> lab-user@<bastion-host>

# On bastion — test solve
JOB=$(curl -s -X POST http://localhost:8501/api/module-N/solve \
  | python3 -c "import json,sys; print(json.load(sys.stdin)['Job_id'])")
sleep 30 && curl -s http://localhost:8501/api/job/$JOB

# On bastion — test validation
JOB=$(curl -s -X POST http://localhost:8501/api/module-N/validation \
  | python3 -c "import json,sys; print(json.load(sys.stdin)['Job_id'])")
sleep 30 && curl -s http://localhost:8501/api/job/$JOB
```
