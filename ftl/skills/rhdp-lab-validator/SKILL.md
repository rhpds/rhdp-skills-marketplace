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
  version: v1.6.4

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

**NOTE: RUNNER LOCATION — GET THIS WRONG AND EVERY STEP FAILS.**

The runner is NOT always on the bastion. Check the AgV `config:` field:

- `config: cloud-vms-base` → runner is a **Podman container running ON the bastion**. The bastion IS the runner host. SSH there to check runner logs, invoke API, deploy playbooks.
- Any other config (`namespace`, `openshift-workloads`, etc.) → runner is an **OCP pod** (zerotouch Helm chart). This applies even if the lab has a bastion VM. The runner SSHes TO the bastion as a target; the bastion is not where the runner lives.

Never assume a bastion means the runner is on the bastion. Confirm `config:` first.

---

**CRITICAL RULES — ALL MANDATORY, NO EXCEPTIONS.**

1. Ask ONE question at a time — wait for answer before next
2. **Scaffold IMMEDIATELY when showroom repo is provided — before reading any .adoc files**
3. **ONE MODULE AT A TIME — ABSOLUTE RULE.** Generate Module N, test it, confirm it passes. Only then Module N+1.
4. **Read .adoc files per module when generating — not upfront.** Focus gives quality.
5. **Detect non-automatable steps automatically** from content and scripts. Use ⚠️ warnings.
6. **ALWAYS multi-task ✅/❌ pattern** — every validation.yml shows per-task status. Never single pass/fail.
7. **After each module — give curl commands and STOP. Wait for results.**

---

### Step 0: What type of lab?

**Ask ONE question first:**

```
What type of lab are you adding ZT grading to?

1. OCP multi-user  — shared cluster, students get scoped namespaces
2. OCP dedicated   — student has cluster-admin, lab has a bastion VM
3. RHEL VM         — bastion + node VMs (showroom runs on bastion)
```

This determines everything: runner location, SSH patterns, kubernetes.core vs shell.

---

### Step 1: Showroom Repo → Scaffold

```
Showroom repo? (GitHub URL or local path)
```

Read ONLY the `= Title` heading from each `.adoc` to get module count and labels.

Generate immediately:
- `ui-config.yml` — type: zero-touch, module list, correct tabs per lab type
- Check `site.yml` — the bundle URL MUST use `nookbag-bundle` (not `nookbag`):
  ```yaml
  ui:
    bundle:
      url: https://github.com/rhpds/nookbag-bundle/releases/download/v0.0.3/ui-bundle.zip
  ```
  If it says `rhpds/nookbag/` → fix it to `rhpds/nookbag-bundle/` — wrong repo name causes a 404 crash in antora-builder.
- `runtime-automation/module-N/` stub files

Commit + push. Do NOT order yet.

---

### Step 2: AgV Catalog (Optional)

```
AgV catalog path? (e.g. summit-2026/lb1390-my-lab-cnv  or 'skip')
```

Read ONLY to check if the ZT workload role is in `workloads:`.
- Present → proceed
- Missing → offer to create branch and add it

Once AgV confirmed: *"Now order the lab from integration.demo.redhat.com"*


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
  Share your GUID when it's up (provisioning takes 15-60 min).

💡 Tip: Rename this session so you can come back and resume:
  /rename ZT grading — <your-lab-name>
```

---

### Step 3: Ask About Existing Scripts

**Default assumption: all automation lives in the showroom repo.** Only ask if they mention they have something.

**While the lab provisions, ask:**

```
Do you already have bash scripts or Ansible playbooks for any modules?
Share them (GitHub URL or paste) — I'll wrap them into the ZT pattern.
For modules with nothing I'll generate from scratch.
```

If `.sh.j2` provided → ask to strip Jinja2 to plain `.sh` first.
If `.sh` provided → read it, infer what it creates/changes, auto-generate matching validation.
If scripts are NOT in the showroom repo (already on target from provisioning) → use `ansible.builtin.shell` instead of `ansible.builtin.script`.

---

### Step 4: Env Ready → Connect

GUID shared? Connect based on lab type from Step 0.

**OCP multi-user / OCP dedicated** (runner is OCP pod):
```
Run in your terminal:
  oc login <api-url> --token <admin-token> --insecure-skip-tls-verify
  # Use the cluster-admin token from your lab credentials (not username/password)
```
Claude then verifies: zt-runner SA · kubeconfig Secret · RoleBindings · showroom-userdata CM
Confirm: `curl https://<showroom-url>/runner/api/config` returns module list

**RHEL VM** (runner is Podman on bastion):
Share: bastion host / port / password
Claude SSHes to bastion, checks SSH config + node hosts
Confirm: `curl http://localhost:8501/api/config` returns module list

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
