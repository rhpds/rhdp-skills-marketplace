---
name: ftl:rhdp-lab-validator
description: This skill should be used when the user asks to "add ZT grading to my RHDP lab", "create runtime-automation playbooks", "generate solve and validation for my showroom lab", "add validation to my summit lab", "create module graders for RHDP", "generate runtime-automation for OCP lab", "add solve and validate buttons to my lab", "write ZT validation playbooks", or "create grading for my RHEL lab".
version: 1.0.0
---

---
context: main
model: claude-sonnet-4-6
---

# RHDP Lab Validator — Zero Touch Grading

Generate `runtime-automation/module-N/{solve,validation,setup}.yml` playbooks for RHDP showroom labs using the Zero Touch (nookbag) grading system. Works for OCP tenant, OCP dedicated+bastion, RHEL VM+bastion, and AAP labs.

## ⚠️ Prerequisites — AgV Must Be Set Up First

**Before this skill can work, the lab's AgV catalog must already have the correct ZT workload roles.** Warn the developer if these are missing:

**For OCP tenant labs:**
```yaml
workloads:
  - rhpds.ftl.ocp4_workload_runtime_automation_k8s   # ← REQUIRED

# Required collections:
- name: https://github.com/rhpds/rhpds-ftl.git
  type: git
  version: "{{ tag }}"
- name: https://github.com/agnosticd/showroom.git
  type: git
  version: v1.6.3

# Required showroom vars:
ocp4_workload_showroom_deployer_chart_name: zerotouch
ocp4_workload_showroom_deployer_chart_version: "1.9.18"
ocp4_workload_showroom_runtime_automation_image: "quay.io/rhpds/zt-runner:v2.3.0"
ocp4_workload_showroom_zero_touch_ui_enabled: true
```

**For OCP dedicated labs:** Same as tenant PLUS `ocp4_workload_runtime_automation_k8s_cluster_admin: true`

**For RHEL VM labs:**
```yaml
post_software_final_workloads:
  bastions:
    - agnosticd.showroom.vm_workload_showroom
    - rhpds.ftl.vm_workload_runtime_automation   # ← REQUIRED

showroom_ansible_runner_api: true
showroom_ansible_runner_image: quay.io/rhpds/zt-runner
showroom_ansible_runner_image_tag: v2.3.0
```

See `@ftl/skills/rhdp-lab-validator/references/agv-prereqs.md` for complete AgV snippets per lab type.

---

## Tips: Getting the Most from This Skill

### 1. Rename Your Session — Resume Any Time

This skill may take multiple sessions (waiting for env provisioning, testing modules, iterating). Rename the session so you can find and resume it:

```
/rename ZT grading — my-lab-name
```

When you come back, just open the renamed session — full context is preserved. You can say "resume where we left off" and continue from the last module.

### 2. Log In to Your Cluster — Let Claude Help Troubleshoot

If you run `oc login` in your terminal before using this skill, Claude can:
- Inspect what's actually deployed in your namespaces
- Check if the zt-runner SA and kubeconfig Secret were created correctly
- Verify RoleBindings and permissions
- Read pod logs when a module fails
- Check the showroom-userdata ConfigMap contents

```bash
# OCP tenant/dedicated — log in as admin
oc login https://api.cluster-{guid}.dynamic.redhatworkshops.io:6443 \
  --username admin --password <password> --insecure-skip-tls-verify

# Then tell Claude: "I'm logged in, can you check the showroom namespace?"
```

Claude will run `oc` commands on your behalf and explain what it finds.

### 3. Share Bastion Access for RHEL Labs

For RHEL VM labs, share your SSH credentials at the start:

```
bastion: ssh.ocpvXX.rhdp.net port 31XXX
user: lab-user
password: <password>
```

Claude can SSH to the bastion, check runner logs, inspect the SSH config, and debug failed validation/solve jobs directly — no copy-paste needed.

### 4. Paste Failing Job Output

When a module fails, paste the raw job output:

```bash
# OCP: from laptop
curl -sk "https://<showroom-url>/runner/api/job/<job-id>" | python3 -m json.tool

# RHEL: from bastion
curl -s http://localhost:8501/api/job/<job-id>
```

Claude will diagnose the failure and fix the playbook on the spot.

---

## Workflow

**CRITICAL RULES:**
1. Ask ONE question at a time — wait for answer before next
2. Generate ONE module at a time — give curl test commands after each
3. Warn about AgV prerequisites BEFORE generating anything
4. Tell developer to ORDER the environment BEFORE starting module generation
5. Read existing scripts/playbooks before generating from scratch

---

### Step 0: Confirm AgV is Ready

**Before anything else, ask:**

```
Is the ZT grading infrastructure already in your AgV catalog?
  Required for OCP:  rhpds.ftl.ocp4_workload_runtime_automation_k8s
  Required for RHEL: rhpds.ftl.vm_workload_runtime_automation

AgV catalog ready? [Y/n]
```

If NOT ready — show the correct snippet from `@ftl/skills/rhdp-lab-validator/references/agv-prereqs.md` and **stop**. Do not proceed until AgV is updated.

**Do NOT ask them to order yet — showroom repo must be scaffolded and committed first so the provisioner picks it up.**

---

### Step 1: Get Showroom Repo (Mandatory)

```
Where is your showroom content repo?
  GitHub URL:  https://github.com/rhpds/my-lab-showroom
  Local path:  ~/work/showroom-content/my-lab/
```

Read ALL `.adoc` files under `content/modules/ROOT/pages/` and the existing `runtime-automation/` directory (if any). Extract:
- Number of modules
- What students do per module (commands, resources created)
- Whether a `runtime-automation/` directory already exists with any playbooks

---

### Step 2: Get AgV Catalog (Optional but Recommended)

```
Do you have the AgV catalog path for this lab?
  Example: tests/zt-ocp-pipelines-tenant/
           summit-2026/lb1390-my-lab-cnv

AgV path (or 'skip'):
```

If provided, read `common.yaml` and extract:
- `config:` → lab type (namespace=OCP tenant, openshift-workloads=OCP dedicated, cloud-vms-base=RHEL)
- `instances:` → node names and AnsibleGroup tags (for RHEL)
- `ocp4_workload_tenant_namespace_suffixes:` → student namespace names
- Whether `rhpds.ftl.ocp4_workload_runtime_automation_k8s` or `rhpds.ftl.vm_workload_runtime_automation` is present

⚠️ If the required FTL workload roles are **missing** from the catalog — warn the developer immediately and show the correct AgV snippet from `@ftl/skills/rhdp-lab-validator/references/agv-prereqs.md` before proceeding.

---

### Step 3: Confirm Lab Type

Present what was detected and confirm:

```
Based on what I read:

  Lab type:    [OCP tenant / OCP dedicated+bastion / RHEL VM+bastion / AAP]
  Modules:     [N modules detected]
  Namespaces:  [e.g. devuser-{guid}-zttest, devuser-{guid}-ztworkspace]  ← OCP only
  Nodes:       [e.g. node, node01, node02]  ← RHEL only

Does this look correct? [Y/n]
```

---

### Step 3b: Scaffold the Showroom Repo → Then Order the Environment

**Scaffold BEFORE ordering** — the provisioner clones the showroom repo at provision time, so the scaffold must be committed first. This is also the right moment: you now know the lab type and module count.

Generate the showroom scaffolding now:

**Create `ui-config.yml`** based on lab type and detected modules:

```yaml
# ui-config.yml
---
type: zero-touch
default_width: 35
persist_url_state: true
view_switcher:
  enabled: true
  default_mode: split

antora:
  name: modules
  dir: www
  modules:
    - name: index
      label: "Welcome"
    - name: module-01
      label: "Module 1: <title from .adoc>"
      scripts: [setup, validation, solve]
      solveButton: true
    # ... repeat per module
    - name: conclusion
      label: "Conclusion"

tabs:
  - name: OCP Console                          # OCP labs
    url: 'https://console-openshift-console.${DOMAIN}'
    external: false
  # OR for RHEL/dedicated:
  - name: Terminal
    url: '/wetty'
    external: false

skipModuleEnabled: true
```

**Create `runtime-automation/` directory structure** with stub files per module:

```
runtime-automation/
├── module-01/
│   ├── setup.yml       # stub — debug msg
│   ├── solve.yml       # TODO — fill in next
│   └── validation.yml  # TODO — fill in next
├── module-02/
│   └── ...
```

Write stub `setup.yml` for each module:
```yaml
---
- name: Module N Setup
  hosts: localhost
  connection: local
  gather_facts: false
  tasks:
    - ansible.builtin.debug:
        msg: "Setup complete — proceed with the module instructions."
```

**Also verify `site.yml`** uses nookbag bundle:
```yaml
ui:
  bundle:
    url: https://github.com/rhpds/nookbag-bundle/releases/download/v0.0.3/ui-bundle.zip
    snapshot: true
```

Commit and push the scaffold to the showroom repo.

Then tell the developer:
```
✅ Scaffold committed to your showroom repo.

Now order the environment:
  1. Go to integration.demo.redhat.com
  2. Order your catalog item — it will provision in 15-60 min
  3. Share your GUID once it's up

While you wait, share any existing bash scripts or playbooks
for the modules (Step 4) so I can generate the full playbooks
as soon as the environment is ready.
```

---

### Step 4: Check for Existing Scripts or Playbooks

```
Do you already have bash scripts, Ansible playbooks, or Jinja2 templates
for validation or solving? Share them module by module.

For each module:
  Module 1 solve:      [paste content, GitHub URL, or 'none']
  Module 1 validation: [paste content, GitHub URL, or 'none']
  Module 2 solve:      [paste or 'none']
  ...

Examples of what you might have:
  - Bash scripts (.sh files) that run oc commands on bastion
  - Jinja2 templates (.sh.j2) from Ansible roles
  - Existing validation playbooks from FTL or other frameworks
  - curl commands or API test scripts

I'll wrap existing content into the ZT runtime-automation pattern.
For modules with nothing — I'll generate from scratch based on follow-up questions.
```

If the developer provides GitHub URLs, fetch and read the files directly.

---

### Step 5: Per-Module Questions (for modules WITHOUT existing content)

**For each module without existing scripts, ask based on lab type:**

**OCP Tenant/Dedicated:**
```
Module N — what should be validated?
List each task (what the student creates/does):
  Task 1: [e.g. create ConfigMap 'app-config' in namespace X]
  Task 2: [e.g. deploy Deployment 'my-app']
  Task 3: [e.g. route accessible at /health]

For dedicated labs also: which tasks run on bastion?
Which use oc --as developer?
```

**RHEL VM:**
```
Module N — what should be validated?
For each task, specify:
  Task 1: [where: node/bastion] [what: file/package/service/command] [path/name]
  Task 2: ...
```

**AAP:**
```
Module N — what AAP objects to validate?
  Task 1: [job template / workflow / inventory / credential / collection] [name]
  Task 2: ...

AAP controller URL comes from: [showroom-userdata CM / env var / hardcoded]
Auth: [Bearer token from CM / lab-user + password]
```

---

### Step 6: Wait for Environment → Connect → Generate Module (One at a Time)

Before generating the first module playbook, confirm the environment is up:

```
Is your lab environment ready? Share the GUID (and showroom URL if OCP).

OCP labs: showroom URL (https://showroom-{guid}.apps....)
RHEL labs: bastion SSH details (host, port, password)
```

WAIT for the developer to share environment details. Do NOT generate module
playbooks without a running environment — there's no way to test them.

**Once environment is confirmed — establish access immediately:**

**OCP labs — log in as admin:**
```
Run this in your terminal so I can inspect the cluster directly:

  oc login <api-url> --username admin --password <password> --insecure-skip-tls-verify

I'll use this to verify the zt-runner SA, kubeconfig Secret, RoleBindings,
showroom-userdata CM, and pod logs when debugging.
```

**RHEL VM labs — connect to bastion:**
```
Share your bastion SSH credentials:
  Host:     <bastion-host>
  Port:     <port>
  User:     lab-user
  Password: <password>

I'll SSH to the bastion to check the SSH config, runner logs,
and run curl commands directly without you copy-pasting everything.
```

After access is established, verify ZT infrastructure is working:
- OCP: check `zt-runner` SA + `zt-runner-kubeconfig` Secret in showroom namespace
- RHEL: check `/opt/showroom/.ssh/id_rsa` and `/opt/showroom/.ssh/config` exist, `curl -s http://localhost:8501/api/config` returns module list

Then generate modules one at a time:

### Step 6b: Generate Module (One at a Time)

Generate all three files per module using patterns from:
- `@ftl/skills/rhdp-lab-validator/references/ocp-tenant-patterns.md`
- `@ftl/skills/rhdp-lab-validator/references/ocp-dedicated-patterns.md`
- `@ftl/skills/rhdp-lab-validator/references/rhel-patterns.md`
- `@ftl/skills/rhdp-lab-validator/references/aap-patterns.md`

Write files to `runtime-automation/module-N/` in the showroom repo.

Confirm: "Created module-N: solve.yml (X lines), validation.yml (Y lines), setup.yml (stub)"

---

### Step 7: Give Test Commands After Each Module

**For OCP labs (zerotouch chart — runner accessible via public URL):**
```
Test module-N from your laptop:

# Trigger solve
JOB=$(curl -sk -X POST \
  "https://<showroom-url>/runner/api/module-N/solve" \
  | python3 -c "import json,sys; print(json.load(sys.stdin)['Job_id'])")
echo "Job: $JOB"

# Wait ~30s then check result
sleep 30 && curl -sk \
  "https://<showroom-url>/runner/api/job/$JOB" | python3 -m json.tool

# Trigger validation
JOB=$(curl -sk -X POST \
  "https://<showroom-url>/runner/api/module-N/validation" \
  | python3 -c "import json,sys; print(json.load(sys.stdin)['Job_id'])")
sleep 30 && curl -sk \
  "https://<showroom-url>/runner/api/job/$JOB" | python3 -m json.tool
```

**For RHEL VM labs (runner on bastion — use localhost):**
```
SSH to your bastion first:
  ssh -p <port> lab-user@<bastion-host>

Then run from the bastion:
# Trigger solve
JOB=$(curl -s -X POST http://localhost:8501/api/module-N/solve \
  | python3 -c "import json,sys; print(json.load(sys.stdin)['Job_id'])")
echo "Job: $JOB"

# Wait ~30s then check result
sleep 30 && curl -s http://localhost:8501/api/job/$JOB
```

Ask the developer to paste the result before generating the next module.

---

### Step 8: Also Generate ui-config.yml Snippet and AgV Note

After all modules are generated, provide:

1. **`ui-config.yml` module list snippet** to add to the showroom repo
2. **AgV workload vars snippet** confirming what's needed (if not already present)

---

## After All Modules Pass

```
✅ All modules complete.

Files created in runtime-automation/:
  module-01/setup.yml, solve.yml, validation.yml
  module-02/...
  ...

Next steps:
1. Commit and push to your showroom repo
2. Restart the showroom pod to pick up new content:
   OCP: oc rollout restart deployment/showroom -n <showroom-ns>
   RHEL: sudo systemctl restart showroom (on bastion)
3. Test from the nookbag UI — click Solve then Validate per module
```

## Related Skills

- `/showroom:create-lab` -- Create showroom content (run before this skill)
- `/agnosticv:catalog-builder` -- Set up the AgV catalog (run before this skill)
- `/ftl:zt-lab-validator` -- For pure ZT labs (zt-ansiblebu pattern, shell scripts)
