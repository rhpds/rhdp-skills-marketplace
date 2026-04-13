---
name: ftl:rhdp-lab-validator
description: This skill should be used when the user asks to "add E2E test grading to my existing RHDP lab", "create runtime-automation playbooks", "generate solve.yml and validation.yml for my showroom", "add validation to my summit lab", "create automated solve/validate graders for RHDP", "wrap my bash scripts into validation", "add Solve and Validate buttons to my showroom lab", "write validation playbooks", "create grading for my RHEL lab", "generate module graders", or "add E2E test grading to my AAP lab".
version: 2.0.0
---

---
context: main
model: claude-sonnet-4-6
---

# RHDP Lab Validator — E2E Grading Skill

Generates `runtime-automation/module-N/{solve,validate}.yml` Ansible playbooks for any RHDP showroom lab. Works for OCP tenant, OCP dedicated, RHEL VM, AAP, and any other lab type.

## Core Principle

**solve.yml and validate.yml are always Ansible playbooks** — no exceptions.

**validate.yml** → ALWAYS pure Ansible (checking state via API/SSH — never needs a browser).

**solve.yml** → follow this priority ladder strictly:

### Automation Priority Ladder

```
1. kubernetes.core.k8s / k8s_info   ← OCP resources (PREFERRED for anything k8s-backed)
2. ansible.builtin.shell (oc CLI)   ← oc label, oc patch, oc scale, oc create
3. ansible.builtin.uri              ← REST API calls (AAP, Gitea, any HTTP endpoint)
4. ansible.builtin.shell (SSH)      ← Commands on bastion/node (RHEL labs)
5. Playwright .js script            ← LAST RESORT ONLY — genuinely no API equivalent
```

**Before reaching for Playwright, always ask:**
- Does this OCP Console action have an `oc` equivalent? (`oc label`, `oc patch`, `oc scale`, `oc create`) → use `oc` CLI
- Does this resource exist in the k8s API? → use `kubernetes.core.k8s`
- Is there a REST API endpoint? → use `ansible.builtin.uri`

**Playwright is ONLY for steps where the UI interaction itself is the verification:**
- Visual pipeline editors (drag-and-drop flow builders)
- Canvas/diagram-based UIs with no API backing
- Custom web apps with no REST API
- Multi-step wizards where client-side JS state cannot be replicated via API

**OCP Console steps almost always have `oc` or `kubernetes.core` equivalents — use those.**

---

## Three-Phase Workflow

### Phase 1 — Survey (all modules, fast)

Read ALL module `.adoc` files in one pass. For each step in each module, classify:

| Classification | Description | Ansible approach | Priority |
|---|---|---|---|
| `k8s` | OCP resource create/update/delete | `kubernetes.core.k8s` | 1 — always first |
| `k8s-check` | OCP resource read/verify | `kubernetes.core.k8s_info` | 1 |
| `oc-cli` | OCP Console action with `oc` equivalent (label, patch, scale) | `ansible.builtin.shell` with `oc` | 2 |
| `shell-bastion` | Command on bastion VM | `ansible.builtin.shell` via SSH | 3 |
| `shell-node` | Command on node VM | `ansible.builtin.shell` via SSH | 3 |
| `api` | REST API call (AAP, Gitea, any HTTP) | `ansible.builtin.uri` | 3 |
| `ui-playwright` | **No API/CLI equivalent exists** (visual editor, canvas, custom JS) | Playwright `.js` script | **LAST RESORT** |
| `skip` | Informational only | no task | — |

**Key rule:** If the step is done in OCP Console but has an `oc` command equivalent → classify as `oc-cli`, NOT `ui-playwright`.
Examples: "label a ConfigMap in Console" → `oc label`, "scale deployment" → `oc scale`, "create route" → `oc expose`.

Output: a step-by-step blueprint per module showing what each step maps to.

---

### Phase 2 — Generate (module by module)

For each module using the Phase 1 blueprint:

**For `api`, `k8s`, `shell-*` steps → generate Ansible tasks directly.**

Use the appropriate module per lab type:

```yaml
# OCP labs — kubernetes.core
- kubernetes.core.k8s:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    validate_certs: false
    state: present
    definition: ...

# RHEL VM / bastion labs — SSH
- ansible.builtin.add_host:
    name: bastion
    ansible_user: "{{ bastion_user | default('lab-user') }}"
    ansible_ssh_private_key_file: /app/.ssh/id_rsa
    ansible_ssh_common_args: "-F /app/.ssh/config"

- name: Run command on bastion
  hosts: bastion
  tasks:
    - ansible.builtin.shell: |
        oc create configmap lab-config --from-literal=env=dev -n demo-project

# AAP labs — REST API
- ansible.builtin.uri:
    url: "{{ aap_url }}/api/v2/job_templates/{{ template_id }}/launch/"
    method: POST
    headers:
      Authorization: "Bearer {{ aap_token }}"
```

**For `ui` steps → Claude generates a Playwright script:**

Store in `runtime-automation/module-N/playwright/step-N-<description>.js`

Call from solve.yml:
```yaml
- name: "{{ step_description }} (via Playwright)"
  ansible.builtin.script:
    executable: node
    cmd: "{{ playbook_dir }}/playwright/step-03-label-configmap.js"
  environment:
    CONSOLE_URL: "{{ openshift_console_url | default('') }}"
    NAMESPACE: "{{ student_ns | default(namespace | default('demo-project')) }}"
    OCP_TOKEN: "{{ k8s_token | default('') }}"
    USERNAME: "{{ student_user | default('') }}"
    PASSWORD: "{{ student_password | default('') }}"
  register: r_playwright

- name: Assert Playwright step succeeded
  ansible.builtin.assert:
    that: r_playwright.rc == 0
    fail_msg: "UI step failed: {{ r_playwright.stdout | default('') }}"
```

**NOTE:** `ansible.builtin.script` requires `node` in the runner's PATH. Add this note in a comment when Playwright scripts are generated.

**validate.yml — always pure Ansible, never Playwright:**
```yaml
# Even if solve used a Playwright script to label a ConfigMap,
# validate just checks the label exists via API:
- kubernetes.core.k8s_info:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    validate_certs: false
    kind: ConfigMap
    name: lab-config
    namespace: "{{ student_ns }}"
  register: r_cm

- validation_check:
    check: "{{ r_cm.resources | length > 0 and 'app' in (r_cm.resources[0].metadata.labels | default({})) }}"
    pass_msg: "✅ ConfigMap lab-config has app label"
    error_msg: "❌ ConfigMap lab-config missing app label\nFix: oc label configmap lab-config app=lab -n {{ student_ns }}"
```

---

### Phase 3 — Verify (per module)

After generating solve.yml + validate.yml for a module:

1. Show the user a clear breakdown:
```
Module 1 — CLI + Console:
  Step 1: Create ConfigMap      → kubernetes.core.k8s        ✅ Ansible
  Step 2: Create Secret         → kubernetes.core.k8s        ✅ Ansible
  Step 3: Label ConfigMap       → Playwright script          🎭 UI
  validate: ConfigMap + label   → kubernetes.core.k8s_info  ✅ Ansible
```

2. Give curl test commands:
```bash
SHOWROOM=https://<showroom-url>
curl -sk -N "$SHOWROOM/stream/solve/module-01"
curl -sk -N "$SHOWROOM/stream/validate/module-01"
```

3. Wait for user to confirm → move to next module.

---

## Playwright Script Pattern

When Claude generates a Playwright script for a UI step, follow this pattern:

```javascript
// runtime-automation/module-01/playwright/step-03-label-configmap.js
// Generated by ftl:rhdp-lab-validator
// UI step: Label ConfigMap lab-config with app=lab in OCP Console
//
// Environment variables:
//   CONSOLE_URL  — OCP console URL
//   NAMESPACE    — student namespace
//   OCP_TOKEN    — bearer token for OCP login (optional, may use USERNAME/PASSWORD)
//   USERNAME     — OCP username (if token not provided)
//   PASSWORD     — OCP password (if token not provided)

const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({ ignoreHTTPSErrors: true });
  const page = await context.newPage();

  const consoleUrl = process.env.CONSOLE_URL;
  const namespace = process.env.NAMESPACE || 'default';

  try {
    // Navigate and authenticate
    await page.goto(consoleUrl);
    // ... auth steps based on what's available (token or username/password)

    // Perform the UI action
    await page.goto(`${consoleUrl}/k8s/ns/${namespace}/configmaps/lab-config`);
    await page.click('[data-test-id="actions-menu-button"]');
    await page.click('text=Edit labels');
    await page.fill('[data-test="labels-input"]', 'app=lab');
    await page.click('[data-test="confirm-action"]');

    console.log('SUCCESS: ConfigMap labeled app=lab');
    process.exit(0);
  } catch (err) {
    console.error('FAILED:', err.message);
    process.exit(1);
  } finally {
    await browser.close();
  }
})();
```

**Key rules for Playwright scripts:**
- Always `process.exit(0)` on success, `process.exit(1)` on failure
- Use `console.log('SUCCESS: ...')` / `console.error('FAILED: ...')` so Ansible can surface the result
- Accept all dynamic values via environment variables — never hardcode
- Use `ignoreHTTPSErrors: true` — OCP clusters use self-signed certs
- Keep scripts focused: one UI action per script file

---

## Lab Type Reference

### OCP Tenant (shared cluster, per-student namespace)

**Available extravars:** `k8s_kubeconfig`, `student_ns`, `student_user`, `guid`

```yaml
# solve.yml header
- name: Module solve
  hosts: localhost
  connection: local
  gather_facts: false
  tasks:
    - kubernetes.core.k8s:
        kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
        validate_certs: false
        state: present
        definition:
          apiVersion: v1
          kind: ConfigMap
          metadata:
            name: lab-config
            namespace: "{{ student_ns }}"
```

### OCP Dedicated (cluster-admin, may have bastion)

**Available extravars:** `k8s_kubeconfig`, `bastion_host`, `bastion_port`, `bastion_user`, `bastion_password`, `guid`
`student_ns` is empty — use a fixed namespace with `| default('demo-project', true) | trim`

### RHEL VM + Bastion

**Available extravars:** `bastion_user`, `bastion_host`, `bastion_port`, `bastion_password`
Uses `/app/.ssh/id_rsa` and `/app/.ssh/config` for SSH. No `k8s_kubeconfig`.

```yaml
- name: Build SSH inventory
  hosts: localhost
  gather_facts: false
  tasks:
    - ansible.builtin.add_host:
        name: node
        ansible_user: "{{ bastion_user | default('lab-user') }}"
        ansible_ssh_private_key_file: /app/.ssh/id_rsa
        ansible_ssh_common_args: "-F /app/.ssh/config"

- name: Run tasks on node
  hosts: node
  gather_facts: false
  tasks:
    - ansible.builtin.shell: <command>
```

### AAP Labs

**Available extravars:** `aap_url`, `aap_token` (or `aap_username`/`aap_password`), `guid`

```yaml
- ansible.builtin.uri:
    url: "{{ aap_url }}/api/v2/job_templates/{{ jt_id }}/launch/"
    method: POST
    headers:
      Authorization: "Bearer {{ aap_token }}"
    status_code: [201, 202]
```

---

## Critical Rules

1. **Ask ONE question at a time** — lab type first, then showroom repo, then live URL
2. **Phase 1 first, always** — read ALL modules before generating anything
3. **ONE MODULE AT A TIME** — generate, test, confirm before moving to next
4. **validate.yml never uses Playwright** — always pure Ansible state checks
5. **validation_check plugin is mandatory** — never use `ansible.builtin.fail`
6. **Multi-task ✅/❌ pattern** — every validate.yml shows per-task status
7. **Playwright scripts are helpers** — not required if the UI step has a direct API equivalent; always prefer the API approach when possible
8. **After each module — give curl test commands and STOP**

---

## Step 0: What type of lab?

**Ask ONE question first:**

```
What type of lab are you adding E2E grading to?
1. OCP tenant    — shared cluster, students get namespaces
2. OCP dedicated — student has cluster-admin, may have bastion
3. RHEL VM       — bastion + node VMs, no OCP cluster
4. AAP           — Ansible Automation Platform lab
5. Other         — describe it
```

This determines extravars, Ansible modules, and SSH vs k8s patterns.

---

## Step 1: Read the showroom repo

```
Showroom repo? (GitHub URL or local path)
```

Read ONLY `= Title` headings from each `.adoc` to get module count.
Then do Phase 1 survey — classify all steps.
Show the user the full classification before generating anything.

---

## Step 2: Generate module by module

For each module:
1. Show classification: `Step N: <description> → <type>`
2. Generate solve.yml (Ansible + Playwright scripts as needed)
3. Generate validate.yml (pure Ansible)
4. Give curl test commands
5. **STOP — wait for user confirmation before next module**

---

## Related Skills

- `/showroom:create-lab` — Create showroom content (run before this skill)
- `/agnosticv:catalog-builder` — Set up the AgV catalog
