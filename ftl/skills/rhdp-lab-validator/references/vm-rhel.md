# RHEL VM — Playbook Patterns

Used when `lab_type: vm-rhel` (cloud-vms-base in AgV).
Runner runs as a Podman container on the bastion. SSH credentials injected automatically.

---

## AgV requirements

```yaml
showroom_ansible_runner_api: true
showroom_ansible_runner_image: quay.io/rhpds/zt-runner
showroom_ansible_runner_image_tag: v2.4.2
showroom_ansible_runner_path: "/stream"
showroom_wetty_image: "quay.io/rhpds/wetty:v3.0"

post_software_final_workloads:
  bastions:
    - agnosticd.showroom.vm_workload_showroom
    - rhpds.ftl.vm_workload_runtime_automation
```

---

## Extravars injected automatically

```
# No k8s_kubeconfig or student_ns — VM labs use SSH
# vm_workload_runtime_automation writes:
#   /app/.ssh/id_rsa      — SSH private key
#   /app/.ssh/config      — host aliases for "node" and "bastion"
```

Playbooks can reach the lab VM using `hosts: node` or `hosts: bastion` directly.

---

## Connection header

```yaml
- name: Module N Solve/Validate
  hosts: node          # or "bastion" if running commands on the bastion
  gather_facts: false
  tasks:
```

No `kubeconfig` or `k8s` modules — this is pure SSH/shell.

---

## Shell commands on the VM

```yaml
- name: Run command
  ansible.builtin.command: <command>
  register: r_cmd
  changed_when: false

- name: Check service
  ansible.builtin.systemd:
    name: httpd
  register: r_svc

- ansible.builtin.set_fact:
    _svc_ok: "{{ r_svc.status.ActiveState == 'active' }}"

- name: Check file exists
  ansible.builtin.stat:
    path: /etc/myapp/config.yaml
  register: r_file

- ansible.builtin.set_fact:
    _file_ok: "{{ r_file.stat.exists }}"
```

---

## Idempotency — solve runs multiple times

Guard every operation that creates state:

```bash
# Guard service enable
systemctl is-enabled httpd || systemctl enable httpd

# Guard file creation
[ -f /etc/myapp/config.yaml ] || cp /etc/myapp/config.yaml.example /etc/myapp/config.yaml

# Guard package install — use ansible.builtin.package with state: present
```

```yaml
- name: Install package
  ansible.builtin.package:
    name: httpd
    state: present   # naturally idempotent
```

---

## Check durable outcomes, not transient state

```yaml
# WRONG — service may restart between solve and validate
_ok: "{{ r_proc.stdout | length > 0 }}"

# CORRECT — config file persists
_ok: "{{ r_file.stat.exists }}"
```

---

## Regex in Ansible — avoid regex_search | first

`regex_search` returns `None` on no match, `None | first` crashes. Use separate tasks:

```yaml
# CORRECT
- name: Get value from command
  ansible.builtin.shell: "grep '^KEY=' /etc/myapp/config | cut -d= -f2"
  register: r_val

- ansible.builtin.set_fact:
    myvar: "{{ r_val.stdout | trim }}"
```

---

## Specific error messages in validation_check

Tell students exactly what failed:

```yaml
error_msg: |
  {{ '✅ httpd is running' if _svc_ok else '❌ Step incomplete: httpd not running — run: sudo systemctl start httpd' }}
  {{ '✅ config file exists' if _file_ok else '❌ Step incomplete: config file missing — run: sudo cp /etc/myapp/config.yaml.example /etc/myapp/config.yaml' }}
```

---

## Restarting Showroom during fix loop

After pushing a playbook fix:

```bash
ssh -i <key> <user>@<host> "podman restart showroom && echo restarted"
```

Then re-run the full test cycle:
```bash
curl -sk -N $SHOWROOM/stream/validate/<module>
curl -sk -N $SHOWROOM/stream/solve/<module>
curl -sk -N $SHOWROOM/stream/validate/<module>
```

---

## Working examples

- https://github.com/rhpds/showroom_template_nookbag/tree/e2e-template/examples/e2e-vm-rhel
- https://github.com/rhpds/agnosticv/tree/master/tests/zt-rhel-grading
