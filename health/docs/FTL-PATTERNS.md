# FTL Framework Patterns Reference

Core patterns and conventions for generating FTL grader and solver playbooks. This document is read by the `/health:ftl-create-lab` skill at runtime.

---

## Three-Play Pattern (CRITICAL)

Every grader playbook MUST follow this exact three-play structure:

```yaml
# Play 1: Initialize
- name: Initialize FTL Grading Session - Module X
  hosts: localhost
  gather_facts: false
  become: false
  vars:
    lab_id: "Lab Name - Module X: Module Title"
    module_number: "0X"
    student_name: "{{ lookup('env', 'LAB_USER') | default('student') }}"
    grader_student_report_file: "grading_report_{{ lookup('env', 'LAB_USER') | default(lookup('env', 'USER')) | default('student') }}_module_0X.txt"
  roles:
    - ftl_run_init

# Play 2: Grade (MUST include grader_student_report_file!)
- name: Grade Module X - Module Title
  hosts: localhost
  gather_facts: false
  become: false
  vars:
    grader_student_report_file: "grading_report_{{ lookup('env', 'LAB_USER') | default(lookup('env', 'USER')) | default('student') }}_module_0X.txt"
  tasks:
    - name: "Exercise X.1: Description"
      ansible.builtin.include_role:
        name: grader_check_*
      vars:
        task_description_message: "Exercise X.1: Short description"
        # ... role-specific vars

# Play 3: Finalize
- name: Finalize FTL Grading Session - Module X
  hosts: localhost
  gather_facts: false
  vars:
    module_number: "0X"
    grader_student_report_file: "grading_report_{{ lookup('env', 'LAB_USER') | default(lookup('env', 'USER')) | default('student') }}_module_0X.txt"
  roles:
    - ftl_run_grade_report_generation
    - ftl_run_finish
```

**CRITICAL**: `grader_student_report_file` MUST be defined in ALL THREE plays. Ansible plays have isolated variable scopes. If missing from Play 2, results write to the wrong file and the report shows empty Results sections.

---

## Grader Role Catalog

### Generic System Roles

| Role | Purpose | Key Variables |
|------|---------|---------------|
| `grader_check_command_output` | Validate command output (exact or regex) | `command`, `expected_output`, `use_regex` |
| `grader_check_file_exists` | Verify file/directory exists | `file_path` |
| `grader_check_file_contains` | File exists and contains content | `file_path`, `expected_content`, `use_regex` |
| `grader_check_service_running` | Check systemd service state | `service_name` |
| `grader_check_package_installed` | Verify package installed | `package_name` |
| `grader_check_user_exists` | Check user account exists | `user_name` |
| `grader_check_container_running` | Verify podman/docker container | `container_name` |

### OpenShift/Kubernetes Roles

| Role | Purpose | Key Variables |
|------|---------|---------------|
| `grader_check_ocp_resource` | Generic K8s resource validation | `resource_kind`, `resource_name`, `resource_namespace` |
| `grader_check_ocp_pod_running` | Verify pod is Running | `pod_name`, `pod_namespace`, `pod_label_selector` |
| `grader_check_ocp_route_exists` | Check OpenShift route exists | `route_name`, `route_namespace` |
| `grader_check_ocp_service_exists` | Verify service exists | `service_name`, `service_namespace` |
| `grader_check_ocp_deployment` | Verify deployment exists and ready | `deployment_name`, `deployment_namespace` |
| `grader_check_ocp_build_completed` | Validate BuildConfig and build | `build_config_name`, `build_namespace`, `check_build_success` |
| `grader_check_ocp_secret_exists` | Validate Secret with keys | `secret_name`, `secret_namespace`, `required_keys` |
| `grader_check_ocp_configmap_exists` | Validate ConfigMap | `configmap_name`, `configmap_namespace`, `required_keys` |
| `grader_check_ocp_pvc_exists` | Validate PVC | `pvc_name`, `pvc_namespace`, `check_bound`, `min_storage` |
| `grader_check_ocp_pipeline_run` | Validate Tekton Pipeline | `pipeline_name`, `pipeline_namespace`, `check_run_success` |

### AAP Roles

| Role | Purpose | Key Variables |
|------|---------|---------------|
| `grader_check_aap_licensed` | Verify AAP license | `aap_hostname`, `aap_username`, `aap_password` |
| `grader_check_aap_job_completed` | Validate job template execution | `aap_hostname`, `aap_username`, `aap_password`, `job_template_name` |
| `grader_check_aap_workflow_completed` | Validate workflow execution | `aap_hostname`, `aap_username`, `aap_password`, `workflow_template_name` |

### HTTP Roles

| Role | Purpose | Key Variables |
|------|---------|---------------|
| `grader_check_http_endpoint` | HTTP/HTTPS endpoint validation | `endpoint_url`, `expected_status_code`, `validate_certs` |
| `grader_check_http_json_response` | JSON response field validation | `endpoint_url`, `expected_fields`, `expected_values` |

### Common Variables (All Grader Roles)

Every grader role accepts these standard variables:

```yaml
task_description_message: "Exercise X.Y: What is being validated"
student_error_message: |
  What failed and how to fix it.

  Example fix command:
    oc create deployment myapp --image=myimage
```

---

## Multi-User vs Single-User Patterns

### Pattern A: Multi-User (shared cluster)

Multiple students share one cluster. Each gets a namespace derived from `LAB_USER`.

```yaml
# Derive namespace from LAB_USER
lab_user: "{{ lookup('env', 'LAB_USER') | default('user1') }}"
project_name: "workshop-{{ lab_user }}"

# Per-user report files
grader_student_report_file: "grading_report_{{ lab_user }}_module_01.txt"
```

Usage: `grade_lab lab-name user1`, `grade_lab lab-name user2`

### Pattern B: Single-User (dedicated environment)

One student per environment. No namespace isolation.

```yaml
# Falls back to system user
student_name: "{{ lookup('env', 'LAB_USER') | default(lookup('env', 'USER')) | default('student') }}"
grader_student_report_file: "grading_report_{{ student_name }}_module_01.txt"
```

Usage: `grade_lab lab-name` (no user argument needed)

---

## Environment Variable Patterns

### Validation Block (Start of Play 2)

```yaml
tasks:
  - name: Validate required environment variables
    ansible.builtin.assert:
      that:
        - lookup('env', 'OPENSHIFT_CLUSTER_INGRESS_DOMAIN') | length > 0
        - lookup('env', 'PASSWORD') | length > 0
      fail_msg: |
        Required environment variables not set:
        - OPENSHIFT_CLUSTER_INGRESS_DOMAIN: OpenShift cluster domain
        - PASSWORD: User password

        Example:
          export OPENSHIFT_CLUSTER_INGRESS_DOMAIN="apps.cluster-xxxxx.example.com"
          export PASSWORD="your-password"
```

### Variable Priority Chain

```
LAB_USER: command argument > $LAB_USER env > $USER env > "student"
```

---

## AAP 2.6 API Reference

AAP 2.6 uses gateway architecture with different API paths:

| Resource | AAP 2.4 (Legacy) | AAP 2.6 (Current) |
|----------|------------------|--------------------|
| Config | `/api/v2/config/` | `/api/controller/v2/config/` |
| Job Templates | `/api/v2/job_templates/` | `/api/controller/v2/job_templates/` |
| Inventories | `/api/v2/inventories/` | `/api/controller/v2/inventories/` |
| Organizations | `/api/v2/organizations/` | `/api/gateway/v1/organizations/` |

Survey responses must be passed in `extra_vars`, not as a separate `survey` field:

```yaml
# CORRECT (AAP 2.6):
body:
  extra_vars:
    rhel_inventory_group: "ALL_rhel"

# WRONG (AAP 2.4 style):
body:
  survey: "ALL_rhel"
```

---

## Error Message Quality

Good error messages include: what failed, why it failed, how to fix it, and commands to check status.

```yaml
student_error_message: |
  PostgreSQL database pod is not running in {{ namespace }}.

  Deploy PostgreSQL using the CNPG Cluster resource as described in the lab.

  Check pod status:
    oc get pods -n {{ namespace }} | grep mcp-registry-db
```

---

## Common Pitfalls

### 1. Skipped Task Handling

```yaml
# WRONG: skipped tasks are still "defined"
when: r_result is defined

# CORRECT: check for skipped status
when: r_result is not skipped
```

### 2. Attribute Access on Skipped Tasks

```yaml
# WRONG: will error if task was skipped
result: "{{ r_pod_logs.rc == 0 }}"

# CORRECT: check before accessing
result: "{{
  r_pod_logs is not skipped and
  r_pod_logs.rc is defined and
  r_pod_logs.rc == 0
}}"
```

### 3. Solver Prompts

Solvers must NEVER use `ansible.builtin.pause`. Use `debug` messages instead.

### 4. Shared vs Per-User Services

Some services are shared across all users (e.g., Gitea), while others are per-user namespaced. Construct URLs accordingly:

```yaml
# Shared service
gitea_url: "https://gitea.{{ ingress_domain }}"

# Per-user service
librechat_url: "https://librechat-librechat-{{ lab_user }}.{{ ingress_domain }}"
```

---

## Grade Lab Orchestrator Pattern

```yaml
---
# grade_lab.yml - Full Lab Grader
- name: Initialize Full Lab Grading
  hosts: localhost
  gather_facts: false
  vars:
    lab_id: "Lab Name - Full Lab"
    grader_student_report_file: "grading_report_{{ lookup('env', 'LAB_USER') | default(lookup('env', 'USER')) | default('student') }}.txt"
  roles:
    - ftl_run_init

- name: Grade All Modules
  hosts: localhost
  gather_facts: false
  vars:
    grader_student_report_file: "grading_report_{{ lookup('env', 'LAB_USER') | default(lookup('env', 'USER')) | default('student') }}.txt"
  tasks:
    - name: Grade Module 1
      ansible.builtin.include_tasks: grade_module_01.yml

    - name: Grade Module 2
      ansible.builtin.include_tasks: grade_module_02.yml
      # Add more modules as needed

- name: Finalize Full Lab Grading
  hosts: localhost
  gather_facts: false
  vars:
    grader_student_report_file: "grading_report_{{ lookup('env', 'LAB_USER') | default(lookup('env', 'USER')) | default('student') }}.txt"
  roles:
    - ftl_run_grade_report_generation
    - ftl_run_finish
```

---

## Solver Pattern

```yaml
---
# solve_module_01.yml
- name: Solve Module 1 - Module Title
  hosts: localhost
  gather_facts: false
  become: false
  vars:
    lab_user: "{{ lookup('env', 'LAB_USER') | default('user1') }}"
    ingress_domain: "{{ lookup('env', 'OPENSHIFT_CLUSTER_INGRESS_DOMAIN') }}"
    project_name: "workshop-{{ lab_user }}"
  tasks:
    - name: Validate required environment variables
      ansible.builtin.assert:
        that:
          - ingress_domain | length > 0
        fail_msg: "Set OPENSHIFT_CLUSTER_INGRESS_DOMAIN first"

    - name: Create project
      kubernetes.core.k8s:
        state: present
        definition:
          apiVersion: v1
          kind: Namespace
          metadata:
            name: "{{ project_name }}"

    # ... more tasks to complete the module
    # NO ansible.builtin.pause prompts
    # Use until/retries/delay for async waits
```

---

## Lab Directory Structure

```
labs/<lab-short-name>/
  lab.yml                  # Lab metadata
  grade_module_01.yml      # Module 1 grader
  grade_module_02.yml      # Module 2 grader
  grade_lab.yml            # Full lab orchestrator
  solve_module_01.yml      # Module 1 solver (optional)
  solve_module_02.yml      # Module 2 solver (optional)
  README.md                # Lab documentation
```
