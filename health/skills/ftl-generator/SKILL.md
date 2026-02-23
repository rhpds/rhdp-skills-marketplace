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

**CRITICAL — extract exact project/namespace names from the module content itself.**

Read every module `.adoc` file and look for:
- `oc new-project <name>` or `oc project <name>` — tells you the exact project name
- `-n <namespace>` in commands — tells you the namespace pattern
- Lines like `project mcp-openshift-{user}` or `namespace wksp-{user}` in instructions

Also check if vars/attributes files exist (`vars.adoc`, `_attributes.adoc`) — they may define aliases like `:ocp4_starter_project: wksp-{user}`. But these files don't always exist — always read the modules too.

**⚠️ NEVER assume or invent namespace names.** Real examples of how easy it is to get wrong:
- ocp4-getting-started uses `wksp-{{ LAB_USER }}` NOT `workshop-{{ LAB_USER }}`
- Wrong namespace = grader checks wrong place and always passes OR always fails silently

**Always verify by finding the actual `oc new-project` or `-n <ns>` commands in the .adoc files. If you cannot find the namespace in the module content, ask the developer.**

Also note: if the module says "A project has already been created for you" — it is **pre-deployed**. Error messages for pre-deployed resources must NOT say "create it".

For each module file, extract:
- Module title (from `= Title` heading)
- Exercise sections (numbered steps, code blocks with commands)
- Student actions (commands they run: `oc`, `kubectl`, `curl`, `ansible-playbook`, etc.)
- Resources created (deployments, services, routes, secrets, configmaps, pipelines, etc.)
- Technology indicators (OpenShift, AAP, RHEL, Tekton, database, etc.)
- Whether resources are **pre-deployed** or **created by student** — error messages for pre-deployed resources must NOT say "create it"

**CRITICAL — Identify shared vs per-user services from the URLs and namespaces in module content:**

For every external service students access (Gitea, LibreChat, AAP, dashboards, etc.), determine whether it is shared or per-user by reading how the URL is constructed:

| URL pattern in module | Conclusion |
|---|---|
| `https://gitea.apps.{domain}` — no user in hostname | **Shared service** — one instance for all users |
| `https://gitea-{user}.apps.{domain}` or `https://gitea-mcp-gitea-{user}.apps.{domain}` | **Per-user service** — each user has their own instance |
| `-n gitea` or `namespace: gitea` — single namespace | **Shared service** |
| `-n gitea-{user}` or `namespace: "gitea-{{ LAB_USER }}"` | **Per-user service** |

**Why this matters for credential handling:**

- **Shared service**: Student may not have logged in / initialized yet. Use **admin credentials** (from `showroom-userdata` ConfigMap: `gitea_admin_username`, `gitea_admin_password`). Student credentials will fail until they first log in.
- **Per-user service**: Each user has their own isolated instance. Use the student's own credentials or a per-user admin/service token. The common `PASSWORD` env var may work if the service was provisioned with it.

**Present your service analysis to the developer before proceeding to Step 3:**

```
📋 Service Analysis

Shared services found (use admin credentials in grader):
  ✓ Gitea — URL: https://gitea.apps.{domain} (single instance, all users)
  ✓ AAP   — URL: https://controller.apps.{domain}

Per-user services found (student credentials or per-user token):
  ✓ LibreChat — https://librechat-librechat-{user}.apps.{domain} (per-user namespace)
  ✓ MCP server — namespace: mcp-openshift-{user}

Does this look correct? [Y/n]
```

WAIT for confirmation. Adjust based on developer feedback.

This analysis directly determines which env vars the grader needs (Step 3) and which credential approach to use per service (Step 5).

---

### Step 3: Determine Lab Configuration

Ask these questions ONE AT A TIME.

**Question 1 — Lab short name:**
```
What short name should this lab use for the grade_lab/solve_lab commands?

This becomes the directory name under labs/ and the argument to grade_lab.

Examples: mcp-with-openshift, ocp4-getting-started, automating-ripu-with-ansible

Your lab short name:
```

WAIT for answer.

**Question 2 — Lab type (routes the rest of the questions):**
```
What type of lab is this?

1. OpenShift-based  (OCP cluster — pods, routes, builds, pipelines, operators)
2. RHEL / AAP-based (VMs — systemd services, packages, AAP job templates, RHEL upgrades)

Choice [1/2]:
```

WAIT for answer.

---

**BRANCH 1: OpenShift-based lab**

**Question 3 — Multi-user or single-user:**
```
Is this a multi-user or single-user OpenShift lab?

1. Multi-user — multiple students share one cluster, each gets their own namespace
   Example: wksp-user1, mcp-openshift-user1
   Usage: grade_lab lab-name user1

2. Single-user — one student per cluster, no namespace isolation needed
   Usage: grade_lab lab-name (no user argument)

Choice [1/2]:
```

WAIT for answer.

**If multi-user — Question 4: namespace pattern:**
```
What namespace pattern do per-user namespaces follow?

⚠️  Get this from the module .adoc files — look for 'oc new-project <name>'
    or '-n <namespace>' in student commands. Never assume or invent it.

Examples found in real labs:
- wksp-{{ LAB_USER }}              (ocp4-getting-started — NOT workshop-!)
- mcp-openshift-{{ LAB_USER }}     (mcp-with-openshift)
- librechat-{{ LAB_USER }}         (mcp-with-openshift, second namespace)

Your namespace pattern (from the .adoc files):
```

WAIT for answer.

**Auto-set from lab type + service analysis from Step 2:**
- OCP multi-user → use admin kubeconfig + `kubernetes.core.k8s_info` scoped to student namespace
- Standard vars always needed: `OPENSHIFT_CLUSTER_INGRESS_DOMAIN`, `PASSWORD`
- **Shared services** identified in Step 2 → add their admin credential env vars:
  - Shared Gitea → `GITEA_ADMIN_USER`, `GITEA_ADMIN_PASSWORD`
  - Shared AAP → `AAP_HOSTNAME`, `AAP_PASSWORD`, `AAP_USERNAME`
  - Other shared services → ask developer for admin credentials
- **Per-user services** → student `PASSWORD` or per-user token (determined case by case)

**If single-user OCP:**
- No namespace isolation — grader uses whatever namespace the lab creates
- `LAB_USER` falls back to `$USER`

---

**BRANCH 2: RHEL / AAP-based lab**

**Auto-set:** Single-user only. No multi-user question needed — RHEL/AAP labs provision one environment per student, no shared cluster.

**Required env vars for AAP labs:**
- `AAP_HOSTNAME` — AAP Controller URL (maps to Showroom `{controller_url}`)
- `AAP_PASSWORD` — AAP password (maps to Showroom `{controller_password}`)
- `AAP_USERNAME` — AAP username (default: `lab-user`)

**Note:** Match job/workflow template names EXACTLY as they appear in AAP — including any typos created by CaC playbooks. Always verify against the live cluster:
```bash
curl -sk -u lab-user:$AAP_PASSWORD $AAP_HOSTNAME/api/controller/v2/job_templates/ \
  | python3 -c "import sys,json; [print(t['name']) for t in json.load(sys.stdin)['results']]"
```

---

**Question 5 — Additional environment variables:**
```
Any additional environment variables beyond what's standard for this lab type?

(Standard OCP vars: OPENSHIFT_CLUSTER_INGRESS_DOMAIN, PASSWORD
 Standard AAP vars: AAP_HOSTNAME, AAP_PASSWORD, AAP_USERNAME)

Additional vars (or press Enter if none):
```

WAIT for answer.

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

**⚠️ Never use `oc` CLI in graders.** The `oc` binary (amd64) crashes silently on arm64 Mac running the linux/amd64 container. Always use `kubernetes.core.k8s_info` instead — it uses the Python kubernetes client which works on all platforms.

**Credential handling — based on Step 3 choice:**

**Choice 1 — Admin kubeconfig + namespace scoping (recommended for all labs):**
No login needed. The container/bastion uses admin kubeconfig. All resource checks are scoped to the student's namespace via `LAB_USER`. This works regardless of whether students use htpasswd or SSO.

```yaml
- name: "Exercise 1.1: Verify pod running"
  kubernetes.core.k8s_info:
    kind: Pod
    namespace: "{{ student_namespace }}"
    label_selectors:
      - "app=myapp"
  register: r_pods

- name: Evaluate pod check
  ansible.builtin.set_fact:
    grader_output_message: >-
      {{ 'PASS: ' if r_pods.resources | selectattr('status.phase', 'equalto', 'Running') | list | length > 0
         else 'FAIL: ' }}{{ task_description_message }}
```

**Choice 2 — common password login (only if lab uses a known fixed password):**
Only use when AgV sets `ocp4_workload_authentication_user_password: "redhat"` (or similar known value). Even then, prefer `kubernetes.core.k8s_info` with admin kubeconfig over `oc login`.

**Choice 3 — External service credentials:**

Use the service analysis from Step 2 to determine the right approach per service:

**Shared service** (e.g., shared Gitea, shared AAP) — use admin credentials from `showroom-userdata` ConfigMap. Student credentials will fail if student hasn't logged into the service yet.

```yaml
# Shared Gitea — admin token from ConfigMap
- name: "Exercise 1.5: Verify student Gitea repo exists"
  ansible.builtin.include_role:
    name: grader_check_command_output
  vars:
    task_description_message: "Exercise 1.5: Student Gitea repo exists"
    command: >
      curl -s
      -u "{{ lookup('env', 'GITEA_ADMIN_USER') | default('mcpadmin', true) }}:{{ lookup('env', 'GITEA_ADMIN_PASSWORD') | default(lookup('env', 'PASSWORD'), true) }}"
      https://gitea.{{ ingress_domain }}/api/v1/repos/{{ lab_user }}/myrepo | jq -r '.name'
    expected_output: "myrepo"
```

**Per-user service** (e.g., per-user Gitea instance, per-user LibreChat) — student's `PASSWORD` or a service-account token provisioned per-user. The service was provisioned specifically for that student, so their credentials work from the start.

```yaml
# Per-user service — student credentials work
- name: "Exercise 2.1: Verify per-user service accessible"
  ansible.builtin.include_role:
    name: grader_check_http_endpoint
  vars:
    task_description_message: "Exercise 2.1: LibreChat accessible for {{ lab_user }}"
    endpoint_url: "https://librechat-librechat-{{ lab_user }}.{{ ingress_domain }}"
    expected_status_code: 200
```

Note: `default('value', true)` — the `true` argument is required. Without it, Jinja2 `default()` only triggers on `undefined`, not empty string.

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

### Step 6: Deliver — Module 1 First

**IMPORTANT: Do NOT generate all modules at once. Generate Module 1 only, then ask the developer to test before proceeding.**

This is because:
- Wrong namespace prefix (e.g., `wksp-` vs `workshop-`) will cause all checks to silently pass or fail
- Wrong resource names discovered during testing are cheaper to fix before generating 4 modules
- The developer may want to adjust checkpoint scope after seeing Module 1 output

```
✅ Module 1 Generated

Lab: {lab_name}
Location: {ftl_repo}/labs/{lab_short_name}/

Files Created:
- lab.yml
- grade_module_01.yml (X checkpoints)
- solve_module_01.yml

Commit and test Module 1 before I generate the remaining modules:

1. Commit and push:
   cd {ftl_repo}
   git add labs/{lab_short_name}/
   git commit -m "Add FTL module 1 for {lab_short_name} (WIP)"
   git push

2. Set environment variables:
   export OPENSHIFT_CLUSTER_INGRESS_DOMAIN="apps.cluster-xxx.example.com"
   export PASSWORD="<from Showroom User tab>"
   # Lab-specific vars (see README above)

3. Test grading — FROM LAPTOP (podman):
   grade_lab {lab_short_name} {user_arg} 1 --podman
   Expected: some PASS (pre-deployed resources), some FAIL (student tasks)

   OR from bastion (ansible):
   grade_lab {lab_short_name} {user_arg} 1 --ansible

4. Run solver — Module 1:
   solve_lab {lab_short_name} {user_arg} 1 --podman

5. Grade again — expect all PASS:
   grade_lab {lab_short_name} {user_arg} 1 --podman
   Expected: SUCCESS 0 Errors for Module 1

6. Report results and let me know if any checkpoints are wrong.
   I'll then generate Module 2.
```

**Load testing (after all modules pass):**
```bash
# Grade all discovered users in parallel
grade_lab {lab_short_name} all --podman

# Grade specific module for all users
grade_lab {lab_short_name} all 1 --podman
```
Users are auto-discovered from `showroom-*-userN` namespaces.

---

## Related Skills

- `/showroom:create-lab` -- Create Showroom workshop content (run this first, then use this skill)
- `/health:deployment-validator` -- Create deployment health check validation roles
- `/showroom:verify-content` -- Validate workshop content quality
