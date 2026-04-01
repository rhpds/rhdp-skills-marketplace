---
name: ftl:rhdp-lab-validator
description: This skill should be used when the user asks to "add ZT grading to my existing RHDP lab", "create runtime-automation playbooks", "generate solve.yml and validation.yml for my showroom", "add validation to my summit lab", "create ZT graders for RHDP", "wrap my bash scripts into ZT validation", "add Solve and Validate buttons to my showroom lab", "write zero-touch validation playbooks", "create grading for my RHEL lab", "generate nookbag module graders", or "add ZT grading to my AAP lab".
version: 1.0.0
---

---
context: main
model: claude-sonnet-4-6
---

# RHDP Lab Validator — Zero Touch Grading

Generate `runtime-automation/module-N/{solve,validation,setup}.yml` playbooks for labs that already have their infrastructure and showroom content in place. Adds Zero Touch (nookbag) Solve/Validate buttons without touching the existing lab setup. Works for OCP tenant, OCP dedicated+bastion, RHEL VM+bastion, and AAP labs.

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
## Working Examples

Use these as templates when generating — all patterns are verified from real labs:

- `@ftl/skills/rhdp-lab-validator/examples/ocp-tenant/module-01/` — ConfigMap + data key check (2 tasks)
- `@ftl/skills/rhdp-lab-validator/examples/ocp-dedicated/module-01/` — Namespace + RoleBinding check
- `@ftl/skills/rhdp-lab-validator/examples/ocp-dedicated/module-02/` — Bash script via ansible.builtin.script
- `@ftl/skills/rhdp-lab-validator/examples/rhel-vm/module-01/` — Bastion + node multi-host, hostvars aggregation

---

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

**CRITICAL RULES — ALL MANDATORY, NO EXCEPTIONS.**

1. Ask ONE question at a time — wait for answer before next
2. **Scaffold IMMEDIATELY when showroom repo is provided — before reading any .adoc files**
3. **ONE MODULE AT A TIME — ABSOLUTE RULE.** Generate Module N, test it, confirm it passes. Only then Module N+1.
4. **Read .adoc files per module when generating — not upfront.** Focus gives quality.
5. **Detect non-automatable steps automatically** from content and scripts. Use ⚠️ warnings.
6. **ALWAYS multi-task ✅/❌ pattern** — every validation.yml shows per-task status. Never single pass/fail.
7. **After each module — give curl commands and STOP. Wait for results.**

---

### Step 1: Get Showroom Repo → Scaffold Immediately

```
Showroom repo? (GitHub URL or local path)
```

**As soon as the repo is provided — do a lightweight read for scaffolding only.**

Read ONLY the first heading (`= Title`) from each `.adoc` file to get:
- Module count and order
- Module titles (for `ui-config.yml` labels)

Do NOT read the exercise content, commands, or steps yet — that happens per module in Step 5.

Generate immediately:

**`ui-config.yml`** — based on lab type (ask if not obvious from repo name):
```yaml
type: zero-touch
default_width: 35
persist_url_state: true
view_switcher: {enabled: true, default_mode: split}
antora:
  name: modules
  dir: www
  modules:
    - {name: index, label: "Welcome"}
    - {name: module-01, label: "Module 1", scripts: [setup, validation, solve], solveButton: true}
    # ... one entry per module
    - {name: conclusion, label: "Conclusion"}
tabs:
  - {name: OCP Console, url: 'https://console-openshift-console.${DOMAIN}', external: false}
  # OR for RHEL/dedicated:
  - {name: Terminal, url: '/wetty', external: false}
skipModuleEnabled: true
```

**Verify `site.yml`** has nookbag bundle v0.0.3.

**Create `runtime-automation/module-N/` stub files** for each module:
```yaml
# setup.yml, solve.yml, validation.yml — all stubs with debug msg
```

**Commit + push** the scaffold to the showroom repo.

Do NOT ask to order yet — AgV must be confirmed first.

---

### Step 2: AgV Catalog (Optional)

```
AgV catalog path? (e.g. summit-2026/lb1390-my-lab-cnv  or 'skip')
```

If provided — read `common.yaml`, detect lab type and whether FTL role is in workloads.
- FTL role present → proceed
- FTL role missing → offer to create branch and add it (see agv-prereqs.md)

If not provided — ask: *"Is `rhpds.ftl.ocp4_workload_runtime_automation_k8s` (OCP) or `rhpds.ftl.vm_workload_runtime_automation` (RHEL) already in your workloads?"*

**Once both showroom AND AgV are confirmed committed/ready — tell the developer to order:**

```
✅ Showroom scaffold pushed.
✅ AgV catalog ready (role present / branch pushed).

Now order the lab:
  go to integration.demo.redhat.com → order your catalog item
  Share your GUID when it's up.
```

---

### Step 3: Ask About Existing Scripts

**While the lab provisions, ask:**

```
Do you already have solve or validation scripts for any modules?
  - Bash scripts (.sh files)
  - Jinja2 templates (.sh.j2)
  - Existing Ansible playbooks
  - curl commands or API tests

Share them module by module (GitHub URL or paste) — I'll wrap them.
For modules with nothing, I'll generate from scratch.
```

If `.sh.j2` provided → ask to strip Jinja2 to plain `.sh`.
If `.sh` provided → read the script, infer what it does, auto-generate matching validation.

---

### Step 4: Env Ready → Connect

GUID shared? Get showroom URL / bastion SSH.

**OCP:** `oc login <api-url> --username admin --insecure-skip-tls-verify`
→ Claude verifies: zt-runner SA · kubeconfig Secret · RoleBindings · `curl /runner/api/config`

**RHEL:** share bastion host/port/password
→ Claude SSHes: checks SSH config · node hosts · `curl localhost:8501/api/config`

Confirm runner returns the module list before generating anything.

---

### Step 5: Generate Module N (One at a Time)

**NOW read the module .adoc file** for Module N only. From it:
- Extract every student task (commands, resources, actions)
- Detect automatable vs manual (browser/GitHub/OAuth) — no asking
- Identify exact resource names, namespaces, file paths

Generate `solve.yml` + `validation.yml` replacing the stubs.
Multi-task ✅/❌ mandatory. Manual steps get ⚠️ warning pattern.

**STOP. Give curl test commands immediately.**

**OCP (laptop):** `curl -sk https://<showroom>/runner/api/module-N/solve`
**RHEL (bastion):** `curl -s http://localhost:8501/api/module-N/solve`

Wait for results. Debug inline if needed. Only proceed to Module N+1 after this passes.


## Related Skills

- `/showroom:create-lab` -- Create showroom content (run before this skill)
- `/agnosticv:catalog-builder` -- Set up the AgV catalog (run before this skill)
- `/ftl:zt-lab-validator` -- For pure ZT labs (zt-ansiblebu pattern, shell scripts)
