# AAP Validation Patterns

Uses `ansible.builtin.uri` against the AAP Controller API.
Auth: Bearer token or Basic auth (lab-user + password).

## Extravars Available

From showroom-userdata CM (OCP labs) or env vars:
```
aap_controller_url  (or derive from openshift_api_url domain)
aap_password        (often same as openshift_cluster_admin_password or common_password)
student_user        = lab-user
```

## solve.yml — Create AAP Objects via API

```yaml
---
- name: Module N Solve — configure AAP
  hosts: localhost
  connection: local
  gather_facts: false
  tasks:
    - name: Create job template via API
      ansible.builtin.uri:
        url: "{{ aap_controller_url }}/api/controller/v2/job_templates/"
        method: POST
        headers:
          Authorization: "Bearer {{ aap_token }}"
          Content-Type: application/json
        body_format: json
        body:
          name: "My Job Template"
          job_type: run
          inventory: 1
          project: 1
          playbook: deploy.yml
        validate_certs: false
        status_code: [200, 201]
      register: r_jt
      failed_when: r_jt.status not in [200, 201]
```

## validation.yml — Check AAP Objects

```yaml
---
- name: Module N Validation — AAP objects exist
  hosts: localhost
  connection: local
  gather_facts: false
  tasks:
    # Task 1 — job template exists
    - name: Check job template
      ansible.builtin.uri:
        url: "{{ aap_controller_url }}/api/controller/v2/job_templates/?name=My+Job+Template"
        method: GET
        headers:
          Authorization: "Bearer {{ aap_token }}"
        validate_certs: false
      register: r_jt

    # Task 2 — workflow ran successfully
    - name: Check workflow completed
      ansible.builtin.uri:
        url: "{{ aap_controller_url }}/api/controller/v2/workflow_jobs/?status=successful&workflow_job_template__name=My+Workflow"
        method: GET
        headers:
          Authorization: "Bearer {{ aap_token }}"
        validate_certs: false
      register: r_wf

    # Task 3 — credential exists
    - name: Check credential
      ansible.builtin.uri:
        url: "{{ aap_controller_url }}/api/controller/v2/credentials/?name=My+Credential"
        method: GET
        headers:
          Authorization: "Bearer {{ aap_token }}"
        validate_certs: false
      register: r_cred

    - name: Build task summary
      ansible.builtin.set_fact:
        _task1_ok: "{{ r_jt.json.count > 0 }}"
        _task2_ok: "{{ r_wf.json.count > 0 }}"
        _task3_ok: "{{ r_cred.json.count > 0 }}"

    - name: Validate all tasks
      validation_check:
        check: "{{ _task1_ok and _task2_ok and _task3_ok }}"
        pass_msg: |
          ✅ Task 1: Job template 'My Job Template' exists in AAP
          ✅ Task 2: Workflow 'My Workflow' completed successfully
          ✅ Task 3: Credential 'My Credential' exists
        error_msg: |
          {{ '✅' if _task1_ok else '❌' }} Task 1: Job template 'My Job Template' exists
          {{ '✅' if _task2_ok else '❌' }} Task 2: Workflow 'My Workflow' completed
          {{ '✅' if _task3_ok else '❌' }} Task 3: Credential 'My Credential' exists
```

## AAP API Endpoints Quick Reference

| What to check | API endpoint | Count field |
|---|---|---|
| Job template exists | `/api/controller/v2/job_templates/?name=<name>` | `.json.count > 0` |
| Workflow template exists | `/api/controller/v2/workflow_job_templates/?name=<name>` | `.json.count > 0` |
| Workflow ran successfully | `/api/controller/v2/workflow_jobs/?status=successful&...` | `.json.count > 0` |
| Job ran successfully | `/api/controller/v2/jobs/?status=successful&job_template__name=<name>` | `.json.count > 0` |
| Inventory exists | `/api/controller/v2/inventories/?name=<name>` | `.json.count > 0` |
| Credential exists | `/api/controller/v2/credentials/?name=<name>` | `.json.count > 0` |
| Project synced | `/api/controller/v2/projects/?name=<name>&last_job_run=*` | `.json.results[0].status == 'successful'` |
| EE exists | `/api/controller/v2/execution_environments/?name=<name>` | `.json.count > 0` |
| Host in inventory | `/api/controller/v2/hosts/?name=<name>&inventory__name=<inv>` | `.json.count > 0` |

## Auth Patterns

```yaml
# Bearer token (preferred)
headers:
  Authorization: "Bearer {{ aap_token }}"

# Basic auth (fallback)
url_username: "lab-user"
url_password: "{{ aap_password }}"
force_basic_auth: true
```

## Getting AAP Token in Playbook

```yaml
- name: Get AAP token
  ansible.builtin.uri:
    url: "{{ aap_controller_url }}/api/controller/v2/tokens/"
    method: POST
    url_username: "lab-user"
    url_password: "{{ aap_password }}"
    force_basic_auth: true
    body_format: json
    body:
      description: "ZT grader token"
      scope: write
    validate_certs: false
    status_code: 201
  register: r_token

- name: Set token fact
  ansible.builtin.set_fact:
    aap_token: "{{ r_token.json.token }}"
```

## AAP on RHEL vs AAP on OCP

**AAP on RHEL:** `aap_controller_url` comes from env var or showroom-userdata CM key `controller_url`

**AAP on OCP:** Derive from cluster domain:
```yaml
aap_controller_url: "https://controller-aap.{{ openshift_cluster_ingress_domain }}"
```
