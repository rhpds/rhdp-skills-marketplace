# FTL Framework Patterns Reference

Core patterns and conventions for generating FTL grader and solver playbooks. This document is read by the `/health:ftl-generator` skill at runtime.

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

## Grader Role Catalog (22 roles)

### ⚠️ Never Use `oc` CLI — Use `kubernetes.core` Instead

The `oc` binary (amd64) crashes silently on arm64/Apple Silicon Macs running the linux/amd64 container (`lfstack.push` Go runtime bug). Always use `kubernetes.core` modules for portability.

```yaml
# ❌ WRONG — crashes on arm64 Mac running amd64 container
- ansible.builtin.command: oc get pods -n {{ namespace }} --no-headers | wc -l

# ✅ CORRECT — works everywhere (uses Python k8s client, not native binary)
- kubernetes.core.k8s_info:
    kind: Pod
    namespace: "{{ namespace }}"
  register: r_pods
- ansible.builtin.set_fact:
    pod_count: "{{ r_pods.resources | length }}"
```

Common replacements:

| Old `oc` command | Replacement |
|---|---|
| `oc get <resource>` | `kubernetes.core.k8s_info` |
| `oc new-project` (solver) | `kubernetes.core.k8s` with `kind: Namespace` |
| `oc create secret` (solver) | `kubernetes.core.k8s` with `kind: Secret, stringData:` |
| `oc policy add-role-to-user` (solver) | `kubernetes.core.k8s` with `kind: RoleBinding` |
| `oc expose svc` (solver) | `kubernetes.core.k8s` with `kind: Route` |

---

### Generic System Roles (7)

| Role | Purpose | Key Variables |
|------|---------|---------------|
| `grader_check_command_output` | Validate command output (exact or regex) | `command`, `expected_output`, `use_regex` |
| `grader_check_file_exists` | Verify file/directory exists | `file_path`, `check_file_type` |
| `grader_check_file_contains` | File exists and contains content | `file_path`, `expected_content`, `use_regex` |
| `grader_check_service_running` | Check systemd service state | `service_name`, `check_enabled` |
| `grader_check_package_installed` | Verify package installed | `package_name` |
| `grader_check_user_exists` | Check user account exists | `username`, `check_uid`, `check_groups` |
| `grader_check_container_running` | Verify podman/docker container | `container_name_pattern`, `container_runtime` |

### OpenShift/Kubernetes Roles (11)

| Role | Purpose | Key Variables |
|------|---------|---------------|
| `grader_check_ocp_resource` | Generic K8s resource validation | `resource_kind`, `resource_name`, `resource_namespace` |
| `grader_check_ocp_pod_running` | Verify pod is Running | `pod_name` (regex), `pod_namespace`, `min_ready_pods` |
| `grader_check_ocp_deployment` | Verify deployment exists and ready | `deployment_name`, `deployment_namespace`, `expected_replicas` |
| `grader_check_ocp_route_exists` | Check OpenShift route exists | `route_name`, `route_namespace`, `check_https` |
| `grader_check_ocp_service_exists` | Verify service exists | `service_name`, `service_namespace`, `check_port` |
| `grader_check_ocp_build_completed` | Validate BuildConfig and build | `build_config_name`, `build_config_namespace`, `require_build_execution`, `check_last_n_builds` |
| `grader_check_ocp_secret_exists` | Validate Secret with keys | `secret_name`, `secret_namespace`, `required_keys` |
| `grader_check_ocp_configmap_exists` | Validate ConfigMap | `configmap_name`, `configmap_namespace`, `required_keys` |
| `grader_check_ocp_pvc_exists` | Validate PVC | `pvc_name`, `pvc_namespace`, `check_pvc_bound`, `min_storage_size` |
| `grader_check_ocp_pipeline_run` | Validate Tekton Pipeline + PipelineRun | `pipeline_name`, `pipeline_namespace`, `require_pipeline_run`, `check_last_n_runs` |

### AAP Roles (3)

| Role | Purpose | Key Variables |
|------|---------|---------------|
| `grader_check_aap_licensed` | Verify AAP 2.6 license | `aap_hostname`, `aap_username`, `aap_password` |
| `grader_check_aap_job_completed` | Validate job template execution | `job_template_name`, `require_job_execution`, `check_last_n_jobs` |
| `grader_check_aap_workflow_completed` | Validate workflow execution | `workflow_template_name`, `aap_hostname`, `aap_username`, `aap_password`, `require_job_execution` |

### HTTP Roles (2)

| Role | Purpose | Key Variables |
|------|---------|---------------|
| `grader_check_http_endpoint` | HTTP/HTTPS endpoint validation | `endpoint_url`, `expected_status_code`, `validate_certs` |
| `grader_check_http_json_response` | JSON response field validation | `endpoint_url`, `json_field_checks`, `json_value_checks` |

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

## OCP Checks: User Kubeconfig First, Admin Fallback

`grade_lab` and `solve_lab` attempt `oc login -u userX -p PASSWORD` before running checks:

- **Success** (htpasswd clusters) → mounts userX kubeconfig → checks run as that student (proper RBAC testing)
- **Failure** (SSO/Keycloak clusters) → falls back to admin kubeconfig silently

This means graders automatically test RBAC where possible without any special configuration. For `all` user mode, each parallel subshell gets its own isolated temp kubeconfig.

**Final working command pattern:**
```bash
OCP_API_URL="https://api.cluster-xxx.dynamic.redhatworkshops.io:6443" \
OCP_ADMIN_PASSWORD="<admin-pass>" \
OPENSHIFT_CLUSTER_INGRESS_DOMAIN="apps.cluster-xxx.dynamic.redhatworkshops.io" \
grade_lab mcp-with-openshift all 1 --podman
```

`OCP_API_URL` and `OCP_ADMIN_PASSWORD` are used by the wrapper to `oc login` as admin and discover user credentials from the Showroom ConfigMap. `PASSWORD` is auto-discovered per user from the ConfigMap — you do not set it manually when using `all` mode.

---

## `oc login` Output Suppression

Always suppress `oc login` output with `&>/dev/null`. In parallel runs, unredirected login output (`Login successful`, `Using project default`, `401 Unauthorized`) makes terminal output unreadable.

```bash
# CORRECT
oc login ... &>/dev/null

# WRONG — pollutes output in parallel runs
oc login ...
```

This applies to all credential commands (`oc login`, `oc logout`, kubeconfig writes).

---

## AAP Template Names — Verify Exactly Against Live Cluster

CaC playbooks sometimes create job templates with typos. Never guess the name — always verify:

```bash
curl -sk -u lab-user:${AAP_PASSWORD} \
  ${AAP_HOSTNAME}/api/controller/v2/job_templates/ \
  | python3 -c "import sys,json; [print(t['name']) for t in json.load(sys.stdin)['results']]" | sort
```

Match **exactly** what the API returns, including typos. Example:
- Expected: `"Ansible Leapp Lab Initialization"`
- Actual:   `"Ansible Leapp Lab initailization"` ← typo in CaC

---

## Pre-Deployed vs Student-Created Resources

If the Showroom module says "A project has been created for you" or "The environment has been pre-configured" — the resource is **pre-deployed**. Error messages for pre-deployed resources must **NOT** say "create it".

```yaml
# WRONG — project is pre-deployed, student cannot create it
student_error_message: |
  Create the project: oc new-project workshop-user1

# CORRECT
student_error_message: |
  The project workshop-user1 was pre-created for you by the lab environment.
  Contact your instructor if it is missing.
```

---

## S2I Build Order (Critical for Solver Playbooks)

When solving an S2I build exercise, create resources in this EXACT order:

1. Secret (database credentials)
2. Database Deployment + Service
3. **ImageStream** ← MUST be before BuildConfig
4. BuildConfig → triggers S2I build automatically
5. Wait for build: `until: status.phase in ['Complete', 'Failed']`, `retries: 60`, `delay: 10`
6. Deployment (full spec — image from internal registry)
7. Service
8. Route (with labels for service discovery)
9. Env vars via strategic-merge (or included in initial Deployment)
10. Health probes

```yaml
# ImageStream MUST come before BuildConfig
- name: Create ImageStream
  kubernetes.core.k8s:
    state: present
    definition:
      apiVersion: image.openshift.io/v1
      kind: ImageStream
      metadata:
        name: nationalparks
        namespace: "{{ project_name }}"

- name: Create BuildConfig  # This triggers the S2I build
  kubernetes.core.k8s:
    state: present
    definition:
      apiVersion: build.openshift.io/v1
      kind: BuildConfig
      ...
```

**Why:** If BuildConfig is created first, it gets `InvalidOutputReference` error because the ImageStream doesn't exist yet. The build never starts.

---

## Strategic-Merge Only on Existing Objects

`merge_type: strategic-merge` **only works when the target object already exists.** If the object doesn't exist yet, strategic-merge tries to CREATE it — and fails with `422 Unprocessable Entity` if the spec is partial.

```yaml
# WRONG — fails if Deployment doesn't exist yet (missing selector, labels, image)
- kubernetes.core.k8s:
    merge_type: strategic-merge
    definition:
      kind: Deployment
      spec:
        template:
          spec:
            containers:
              - name: app
                env: [...]   # Partial spec fails!

# CORRECT — always create with full spec first
- kubernetes.core.k8s:
    state: present
    definition:
      kind: Deployment
      spec:
        selector:
          matchLabels: {app: myapp}
        template:
          metadata:
            labels: {app: myapp}
          spec:
            containers:
              - name: myapp
                image: image-registry.openshift-image-registry.svc:5000/{{ ns }}/myapp:latest
                env: [...]
```

---

## Tekton Triggers Pattern

When a module has students create Tekton triggers from a YAML file in Gitea:

```bash
# Student runs:
oc create -f {gitea_url}/{user}/repo/raw/branch/master/pipeline/triggers.yaml
```

The YAML typically creates 3 resources. Solver should create all 3 directly:

```yaml
- name: Create TriggerTemplate
  kubernetes.core.k8s:
    state: present
    definition:
      apiVersion: triggers.tekton.dev/v1beta1
      kind: TriggerTemplate
      ...

- name: Create TriggerBinding
  kubernetes.core.k8s:
    state: present
    definition:
      apiVersion: triggers.tekton.dev/v1beta1
      kind: TriggerBinding
      ...

- name: Create EventListener
  kubernetes.core.k8s:
    state: present
    definition:
      apiVersion: triggers.tekton.dev/v1beta1
      kind: EventListener
      metadata:
        name: "{{ pipeline_name }}"
      spec:
        serviceAccountName: pipeline
        triggers:
          - bindings:
              - ref: "{{ pipeline_name }}"
            template:
              ref: "{{ pipeline_name }}"
```

Read the actual YAML from the student's Gitea repo to get the exact spec.

---

## Verify Critical Files After Git Merges

After any merge conflict resolution, verify key files aren't empty:

```bash
find labs/ -name "*.yml" -empty
```

Empty playbook files = lost content. Recreate from memory or git history.

---

## Unknown APIs — Ask the Developer to Probe Them

For APIs the skill doesn't know (RHDH, LibreChat, MCP servers, custom services), do NOT guess. Ask the developer to run test commands from the deployed environment and share the output.

```bash
# Find routes in the namespace
oc get routes -n <namespace> --no-headers

# Probe the API root
curl -sk https://<route-url>/api/ | python3 -m json.tool | head -60

# If auth needed
curl -sk -H "Authorization: Bearer ${PASSWORD}" https://<route-url>/api/v1/ | python3 -m json.tool
```

From the response, identify:
- Available endpoints to check
- Fields that indicate health/configuration
- Auth mechanism

Then write a grader using `grader_check_http_endpoint` or `grader_check_http_json_response` based on actual API structure — never guess.

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

## Execution Modes

`grade_lab` and `solve_lab` support two modes via flags:

```bash
# Laptop (container-based) — no SSH needed, runs via quay.io/rhpds/ftl:latest
grade_lab <lab> [user] [module] --podman

# Bastion (direct ansible-playbook)
grade_lab <lab> [user] [module] --ansible

# Load test — 'all' discovers users from showroom namespaces, runs in parallel
grade_lab <lab> all [module] --podman
grade_lab <lab> all --podman
```

**`--podman` mode:**
- Pulls `quay.io/rhpds/ftl:latest` (FTL labs cloned at container startup — no rebuild for grader changes)
- Override image: `export FTL_IMAGE=quay.io/rhpds/ftl:my-tag`
- Reports saved to: `~/ftl-reports/` (override: `export FTL_REPORT_DIR=...`)
- OCP auth: mounts `~/.kube/config` (active context must point to correct cluster)
- `oc login` to the right cluster immediately before running — active context at `podman run` time determines cluster

**`--ansible` mode:**
- Requires bastion setup: `bash bin/setup_ftl && export PATH="$HOME/ftl/bin:$PATH"`
- Reports saved to: `/tmp/grading_dir/`

## Environment Variables

| Variable | Description | Required for |
|---|---|---|
| `OPENSHIFT_CLUSTER_INGRESS_DOMAIN` | OCP cluster apps domain (e.g., `apps.cluster-xxx.example.com`) | OCP labs |
| `PASSWORD` | User password (from Showroom → User tab) | All labs |
| `LAB_USER` | Student username (auto-set from command argument) | Auto |
| `AAP_HOSTNAME` | AAP Controller URL | RIPU lab |
| `AAP_PASSWORD` | AAP password | RIPU lab |
| `AAP_USERNAME` | AAP username (default: `lab-user`) | RIPU lab |
| `GITEA_ADMIN_USER` | Gitea admin username (from showroom-userdata ConfigMap) | MCP, labs with Gitea |
| `GITEA_ADMIN_PASSWORD` | Gitea admin password (from showroom-userdata ConfigMap) | MCP, labs with Gitea |
| `OCP_API_URL` | OCP API server URL (for wrapper auto-login) | `--podman` mode |
| `OCP_ADMIN_PASSWORD` | OCP admin password (for wrapper auto-login and user discovery) | `--podman` mode |
| `FTL_IMAGE` | Override container image (default: `quay.io/rhpds/ftl:latest`) | Dev only |
| `FTL_REPORT_DIR` | Report directory for podman mode (default: `~/ftl-reports`) | `--podman` only |

**Showroom ConfigMap — credential source for external services:**

```bash
oc get configmap showroom-userdata -n showroom-<guid>-1-user1 \
  -o jsonpath='{.data.user_data\.yml}'
```

Key fields: `password`, `gitea_admin_username`, `gitea_admin_password`, `gitea_console_url`, `openshift_cluster_ingress_domain`.

**Important:** Use `grep`+`sed` to parse this ConfigMap — it is NOT valid JSON (contains YAML tags like `! "value"`). `json.loads()` will fail silently.

For any external service check (Gitea, LibreChat, AAP), use **admin credentials** from the ConfigMap — student credentials may fail if the student hasn't initialized the service yet.

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
