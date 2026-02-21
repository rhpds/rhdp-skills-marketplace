---
name: health:ftl-generator
description: Generate FTL grader and solver playbooks for a Showroom workshop by analyzing module content
---

---
context: main
model: claude-opus-4-6
---

# FTL Lab Generator

Generate production-quality FTL (Finish The Labs) grader and solver playbooks for a Showroom workshop by reading existing module content. The skill analyzes your `.adoc` module files, identifies student exercises and checkpoints, and generates complete Ansible playbooks following all FTL framework conventions.

## What You'll Need Before Starting

**Required:**
- **FTL repository** cloned locally (ask for path at runtime)
- **Showroom workshop content** with `.adoc` module files containing student exercises
- **SSH access to bastion host** for testing generated playbooks

**Helpful to have:**
- Access to a deployed environment for testing
- Knowledge of which resources students create (pods, routes, secrets, etc.)
- Required environment variables for the lab (cluster domain, passwords, etc.)

**Access needed:**
- Write permissions to FTL repository
- Git configured for commits

## FTL Patterns Reference

See @health/docs/FTL-PATTERNS.md for:
- Three-play pattern (CRITICAL - grader_student_report_file in every play)
- Complete grader role catalog (17 roles with variables)
- Multi-user vs single-user patterns
- Environment variable validation patterns
- AAP 2.6 API reference
- Common pitfalls and fixes
- Solver conventions

## When to Use

**Use this skill when you want to:**
- Add grading and solving capabilities to a Showroom workshop
- Create automated lab validation for student exercises
- Generate test infrastructure for workshop content

**Don't use this for:**
- Creating Showroom workshop content -> use `/showroom:create-lab`
- Validating deployment health checks -> use `/health:deployment-validator`
- Validating workshop content quality -> use `/showroom:verify-content`

## Workflow

**CRITICAL RULES**

### 1. Ask Questions SEQUENTIALLY
- Ask ONE question at a time
- WAIT for user's answer before proceeding
- Do NOT ask questions from multiple steps together

### 2. Read FTL Patterns Before Generating
- Read @health/docs/FTL-PATTERNS.md BEFORE generating any playbooks
- Follow the three-play pattern exactly
- Use the correct grader role for each checkpoint type

### 3. Manage Output Tokens
- Use Write tool to create files -- do NOT output full playbook content
- Show brief confirmations: "Created: grade_module_01.yml (120 lines, 8 checkpoints)"
- Keep total output under 5000 tokens

---

### Step 1: Locate FTL Repository

Ask directly:

```
Where is your FTL repository cloned?

Example: ~/work/code/ftl

FTL repo path:
```

WAIT for answer.

**Validate** the path has `roles/`, `labs/`, and `bin/` directories.

Read the available grader roles from `roles/` directory to know what validation types are available.

---

### Step 2: Locate Workshop Content

Ask:

```
Where is your Showroom workshop content?

I need the path to the directory containing your .adoc module files.

Default: content/modules/ROOT/pages/ (relative to current directory)

Your workshop content path:
```

WAIT for answer.

**Validate** the path exists and contains `.adoc` files.

Read ALL module `.adoc` files (files matching pattern `*module*.adoc` or numbered files like `03-*.adoc`, `04-*.adoc`, etc.).

For each module file, extract:
- Module title (from `= Title` heading)
- Exercise sections (numbered steps, code blocks with commands)
- Student actions (commands they run: `oc`, `kubectl`, `curl`, `ansible-playbook`, etc.)
- Resources created (deployments, services, routes, secrets, configmaps, pipelines, etc.)
- Technology indicators (OpenShift, AAP, RHEL, Tekton, database, etc.)

---

### Step 3: Determine Lab Configuration

Ask these questions ONE AT A TIME:

**Question 1:**
```
What short name should this lab use for the grade_lab/solve_lab commands?

This becomes the directory name under labs/ and the argument to grade_lab.

Examples: mcp-with-openshift, ocp4-getting-started, automating-ripu-with-ansible

Your lab short name:
```

WAIT for answer.

**Question 2:**
```
Is this a multi-user or single-user lab?

1. Multi-user (multiple students share one cluster, each gets their own namespace)
   Example: workshop-user1, workshop-user2
   Usage: grade_lab lab-name user1

2. Single-user (one student per environment, no namespace isolation needed)
   Usage: grade_lab lab-name (no user argument)

Your choice: [1/2]
```

WAIT for answer.

**If multi-user, ask:**
```
What namespace pattern do per-user namespaces follow?

Examples:
- workshop-{{ LAB_USER }} (e.g., workshop-user1)
- {{ LAB_USER }}-aap-instance (e.g., user1-aap-instance)
- mcp-openshift-{{ LAB_USER }} (e.g., mcp-openshift-user1)

Your namespace pattern:
```

WAIT for answer.

**If multi-user, also ask (CRITICAL for credential handling):**
```
How should the grader authenticate when checking student resources?

In multi-user labs, passwords are randomly generated per user so the grader
cannot know individual passwords. Choose the right approach:

1. oc --as impersonation (recommended)
   Uses admin kubeconfig + oc --as=<user> to run commands in student context.
   Tests RBAC correctly without needing student passwords.
   Works for any number of users.

2. Common workshop password
   Lab uses a fixed known password (e.g., "redhat") for all students.
   Grader logs in as student with that password.
   Requires: ocp4_workload_authentication_user_password set to a known value in AgV.

3. Admin namespace scoping
   Uses admin kubeconfig, checks resources directly in student namespace.
   Does NOT test student RBAC — only checks resources exist.

Your choice: [1/2/3]
```

WAIT for answer.

**If impersonation (choice 1) — read Showroom modules** to understand what the student does, then use `--as={{ lab_user }}` on all `oc` commands in the grader.

**If common password (choice 2) — ask:**
```
What is the common password used for all student accounts?
(This must match ocp4_workload_authentication_user_password in common.yaml)

Password:
```

**Question 3:**
```
What environment variables does this lab require?

Common examples:
- OCP_API_URL (OpenShift API URL — required for student credential login)
- OPENSHIFT_CLUSTER_INGRESS_DOMAIN (OpenShift cluster apps domain)
- PASSWORD (student password from Showroom {password} attribute)
- AAP_HOSTNAME (AAP controller URL)
- AAP_PASSWORD (AAP admin password)
- GUID (deployment GUID, usually auto-detected)

List your required environment variables (one per line):
```

WAIT for answer.

---

### Step 4: Analyze Modules and Identify Checkpoints

Based on the workshop content read in Step 2, analyze each module and present the checkpoint analysis:

```
Module Analysis
===============

Module 1: [Module Title]
  Checkpoints identified: X
  1.1: [Description] -> grader_check_ocp_pod_running
  1.2: [Description] -> grader_check_ocp_route_exists
  1.3: [Description] -> grader_check_ocp_service_exists
  ...

Module 2: [Module Title]
  Checkpoints identified: Y
  2.1: [Description] -> grader_check_ocp_deployment
  2.2: [Description] -> grader_check_http_endpoint
  ...

Total: Z checkpoints across N modules

Does this analysis look correct? Should I add, remove, or change any checkpoints?
```

WAIT for user confirmation or adjustments.

**Checkpoint-to-Role Mapping Guide:**

| Student Action | Grader Role |
|---------------|-------------|
| Create/deploy pod | `grader_check_ocp_pod_running` |
| Create deployment | `grader_check_ocp_deployment` |
| Create route | `grader_check_ocp_route_exists` |
| Create service | `grader_check_ocp_service_exists` |
| Create secret | `grader_check_ocp_secret_exists` |
| Create configmap | `grader_check_ocp_configmap_exists` |
| Create PVC | `grader_check_ocp_pvc_exists` |
| Run S2I build | `grader_check_ocp_build_completed` |
| Create/run Tekton pipeline | `grader_check_ocp_pipeline_run` |
| Run command with expected output | `grader_check_command_output` |
| Create file | `grader_check_file_exists` |
| File contains content | `grader_check_file_contains` |
| Start systemd service | `grader_check_service_running` |
| Install package | `grader_check_package_installed` |
| Create user | `grader_check_user_exists` |
| Run container | `grader_check_container_running` |
| Run AAP job template | `grader_check_aap_job_completed` |
| Run AAP workflow | `grader_check_aap_workflow_completed` |
| Endpoint accessible via HTTP | `grader_check_http_endpoint` |
| JSON API response validation | `grader_check_http_json_response` |
| Generic K8s resource check | `grader_check_ocp_resource` |
| Custom multi-step validation | Direct tasks + `ftl_run_log_grade_to_log` |

---

### Step 5: Generate Lab Files

After user confirms the checkpoint analysis, generate all files:

**Read FTL patterns reference first:**
Read @health/docs/FTL-PATTERNS.md before generating any playbooks.

**Generate files in this order:**

#### 5.1: lab.yml (Lab Metadata)

Use the template pattern from `labs/lab-template/lab.yml` in the FTL repo. Populate with:
- Lab name and short name from Step 3
- Technology stack detected from module analysis
- Module structure with checkpoint counts
- Environment variables from Step 3
- Multi-user support settings

Write to: `{ftl_repo}/labs/{lab_short_name}/lab.yml`
Confirm: "Created: lab.yml (X lines)"

#### 5.2: Grader Playbooks (Per Module)

For each module, generate `grade_module_XX.yml` following the three-play pattern from @health/docs/FTL-PATTERNS.md.

**CRITICAL requirements:**
- `grader_student_report_file` defined in ALL THREE plays
- Environment variable validation at start of Play 2
- Each checkpoint uses the mapped grader role from Step 4
- Helpful `student_error_message` for each checkpoint (what failed, why, how to fix)
- Multi-user namespace derivation if Pattern A

**Credential handling — based on Step 3 choice:**

**Choice 1 — `oc --as` impersonation (recommended for multi-user):**
No login needed. Add `--as={{ lab_user }}` to every `oc` command:
```yaml
- name: "Exercise 1.1: Verify pod running as student"
  ansible.builtin.command: >
    oc --as={{ lab_user }}
    get pods -n {{ student_namespace }}
    -l app=myapp
    --field-selector=status.phase=Running
  register: r_pod_check
  changed_when: false
```

For `kubernetes.core` tasks, pass impersonation via module options:
```yaml
- name: "Exercise 1.2: Verify route exists"
  kubernetes.core.k8s_info:
    kind: Route
    namespace: "{{ student_namespace }}"
    name: myapp
    api_key: "{{ lookup('env', 'CLUSTER_ADMIN_TOKEN') }}"
    # Note: k8s_info does not support --as natively; use oc --as for RBAC checks
```

Use `CLUSTER_ADMIN_TOKEN` env var (from bastion KUBECONFIG) for kubernetes.core tasks.
Use `oc --as={{ lab_user }}` for RBAC-sensitive `oc` commands.

**Choice 2 — common password login:**
Add `oc login` at START of Play 2:
```yaml
- name: Login as student user
  ansible.builtin.command: >
    oc login {{ lookup('env', 'OCP_API_URL') }}
    -u {{ lab_user }}
    -p {{ workshop_password }}
    --insecure-skip-tls-verify=true
  changed_when: false
  no_log: true
```
After grading: `oc logout`. The `workshop_password` comes from the known common password in Step 3.

**Choice 3 — admin namespace scoping:**
No login, no `--as`. All `oc` commands scoped to student namespace:
```yaml
ansible.builtin.command: oc get pods -n {{ student_namespace }} ...
```

**Exercise numbering:** X.Y format (module.checkpoint), e.g., 1.1, 1.2, 2.1, 2.2

Write to: `{ftl_repo}/labs/{lab_short_name}/grade_module_XX.yml`
Confirm: "Created: grade_module_01.yml (X lines, Y checkpoints)"

#### 5.3: Grade Lab Orchestrator

Generate `grade_lab.yml` that includes all module graders sequentially. Follow the orchestrator pattern from @health/docs/FTL-PATTERNS.md.

Write to: `{ftl_repo}/labs/{lab_short_name}/grade_lab.yml`
Confirm: "Created: grade_lab.yml (X lines)"

#### 5.4: Solver Playbooks (Per Module)

For each module, generate `solve_module_XX.yml` that programmatically completes all student exercises.

**CRITICAL requirements:**
- NO `ansible.builtin.pause` prompts (fully automated)
- Idempotent (safe to run multiple times)
- Use `until`/`retries`/`delay` for async resources
- Environment variable validation at start
- Multi-user namespace handling if Pattern A

Write to: `{ftl_repo}/labs/{lab_short_name}/solve_module_XX.yml`
Confirm: "Created: solve_module_01.yml (X lines)"

**Note:** If a module only validates pre-deployed resources (like Module 1 in MCP lab), skip solver generation and note:
```
Skipped: solve_module_01.yml (environment validation only, no student actions to solve)
```

#### 5.5: README.md

Generate a comprehensive README with:
- Lab overview and modules
- Checkpoint list per module
- Environment setup instructions
- Usage examples (grade and solve commands)
- Multi-user testing examples if applicable
- Expected results on fresh vs completed environment

Write to: `{ftl_repo}/labs/{lab_short_name}/README.md`
Confirm: "Created: README.md (X lines)"

---

### Step 6: Deliver Summary

```
FTL Lab Generation Complete

Lab: {lab_name}
Location: {ftl_repo}/labs/{lab_short_name}/

Files Created:
- lab.yml (metadata)
- grade_module_01.yml (X checkpoints)
- grade_module_02.yml (Y checkpoints)
- ...
- grade_lab.yml (orchestrator)
- solve_module_01.yml
- solve_module_02.yml
- ...
- README.md

Total: Z checkpoints across N modules

Testing Instructions:
1. Commit and push changes:
   cd {ftl_repo}
   git add labs/{lab_short_name}/
   git commit -m "Add FTL graders/solvers for {lab_short_name}"
   git push

2. SSH to bastion and pull:
   ssh lab-user@bastion
   cd ~/ftl
   git pull

3. Set environment variables:
   export {VAR1}="..."
   export {VAR2}="..."

4. Test grading (fresh environment):
   grade_lab {lab_short_name} {user_arg_if_multiuser}
   Expected: Module 1 may PASS, remaining modules FAIL

5. Run solver:
   solve_lab {lab_short_name} {user_arg_if_multiuser}

6. Test grading (after solver):
   grade_lab {lab_short_name} {user_arg_if_multiuser}
   Expected: SUCCESS 0 Errors

7. Per-module testing:
   grade_lab {lab_short_name} {user_arg} 1
   solve_lab {lab_short_name} {user_arg} 2
```

---

## Related Skills

- `/showroom:create-lab` -- Create Showroom workshop content (run this first, then use this skill)
- `/health:deployment-validator` -- Create deployment health check validation roles
- `/showroom:verify-content` -- Validate workshop content quality
