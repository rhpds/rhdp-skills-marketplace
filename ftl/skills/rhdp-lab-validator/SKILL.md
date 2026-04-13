---
name: ftl:rhdp-lab-validator
description: This skill should be used when the user asks to "add E2E test grading to my existing RHDP lab", "create runtime-automation playbooks", "generate solve.yml and validation.yml for my showroom", "add validation to my summit lab", "create automated solve/validate graders for RHDP", "write validation playbooks", "add Solve and Validate buttons to my showroom lab", or "generate module graders".
version: 3.0.0
---

---
context: main
model: claude-sonnet-4-6
---

# RHDP Lab Validator — E2E Grading Skill

Generates `runtime-automation/module-N/{solve,validate}.yml` Ansible playbooks for any RHDP Showroom lab. Uses the **ZT runner** execution model exclusively — Ansible runs as a Kubernetes ServiceAccount inside the OCP cluster, triggered via SSE from the Showroom pod.

This skill is fully self-contained. No ECC, no Demolition, no external tools required.

---

## How the ZT Runner Works

```
Showroom pod  →  SSE endpoint  →  ZT runner SA  →  runs Ansible playbook
                /stream/solve/module-01            solve.yml
                /stream/validate/module-01          validate.yml
```

The ZT runner SA has **cluster-admin** on the OCP cluster. Playbooks run on `localhost` (inside the cluster pod) with full access to `.svc.cluster.local` service URLs and the Kubernetes API.

**What the runner passes as extravars:**
- `user` — student's Keycloak username (e.g., `llmuser-abc123`)
- `guid` — lab GUID
- Any additional vars configured in `ocp4_workload_runtime_automation_k8s_extra_vars`

**What's available inside the runner container:**
- Python + Ansible
- `kubernetes.core` collection
- `validation_check` custom plugin (outputs ✅/❌ per task via SSE)
- Node.js + Playwright (chromium) — for UI-only solve steps

---

## Core Principle

**solve.yml and validate.yml are always Ansible playbooks.**

**validate.yml** → pure Ansible state checks only. No browser interaction, no manual steps, no navigation instructions. Only report what was verified.

**solve.yml** → follow this priority ladder:

```
1. kubernetes.core.k8s / k8s_info   ← OCP resources (preferred for anything k8s-backed)
2. ansible.builtin.shell (oc CLI)   ← oc label, oc patch, oc scale, oc create
3. ansible.builtin.uri              ← REST API calls (MaaS API, Gitea, AAP, any HTTP)
4. ansible.builtin.wait_for         ← TCP port checks (MCP servers, SSE streams)
5. Playwright .js script            ← LAST RESORT — only when no API/CLI equivalent exists
```

Before reaching for Playwright, always check:
- Does this OCP Console action have an `oc` equivalent? → use `oc` CLI
- Is the resource in the k8s API? → use `kubernetes.core.k8s`
- Is there a REST endpoint? → use `ansible.builtin.uri`
- Is it just a TCP service? → use `ansible.builtin.wait_for`

Playwright is only for steps where **the browser interaction itself is the exercise** — visual editors, drag-and-drop UIs, chat playgrounds, multi-step wizards with no backing API.

---

## Workflow

```
Step 0 → Read AgV catalog → understand namespace patterns and extravars
Step 1 → Read showroom .adoc files → classify every student step
Step 2 → Generate solve.yml + validate.yml per module
Step 3 → Give curl test commands → wait for confirmation → next module
```

**Ask ONE question at a time.**

---

## Step 0: Read the AgnosticV Catalog

**Mandatory before anything else.** Namespace patterns cannot be guessed — they must be read from the catalog. Getting this wrong means service URLs that point at namespaces that don't exist.

**Ask:**
```
AgnosticV catalog path for this lab?
Example: summit-2026/lb2860-private-maas-tenant

Path (or 'n' to skip):
```

**If provided — read `common.yaml` and extract:**

### Per-student namespaces

Look for `ocp4_workload_tenant_namespace_namespaces:`:

```yaml
ocp4_workload_tenant_namespace_namespaces:
  - "wksp-{{ ocp4_workload_tenant_keycloak_username }}"
  - "llamastack-{{ ocp4_workload_tenant_keycloak_username }}"
  - "showroom-{{ ocp4_workload_tenant_keycloak_username }}"
```

The ZT runner extravar `user` = `ocp4_workload_tenant_keycloak_username`.
So in playbooks: `llamastack-{{ user }}`, `wksp-{{ user }}`, `showroom-{{ user }}`.

### Shared (cluster-wide) namespaces

Workloads that deploy to a single shared namespace — same URL for all students:
- Model serving: `*.llm.svc.cluster.local`
- MaaS API: `maas-api.maas-api.svc.cluster.local`
- Grafana: `grafana-service.grafana.svc.cluster.local`

These do NOT get `{{ user }}` in their hostnames.

### Confirm before proceeding

```
📋 AgV: summit-2026/lb2860-private-maas-tenant

Runner extravar: user = "llmuser-{{ guid }}"

Per-student namespaces:
  wksp-{{ user }}         ← DevSpaces, app workloads
  llamastack-{{ user }}   ← Llama Stack, MCP servers
  showroom-{{ user }}     ← Showroom pod

Shared services:
  llm                     ← Model serving
  maas-api                ← MaaS API
  grafana                 ← Grafana

Correct? [Y/n]
```

---

## Step 1: Read the Showroom Repo

**Ask:**
```
Showroom repo path or GitHub URL?
```

Read every `.adoc` file under `content/modules/ROOT/pages/`. Read each module fully — do not skim.

For each student step, classify it:

| Type | What it is | How to automate |
|---|---|---|
| `k8s` | Create/update OCP resource | `kubernetes.core.k8s` |
| `k8s-check` | Read/verify OCP resource | `kubernetes.core.k8s_info` |
| `oc-cli` | OCP Console action with `oc` equivalent | `ansible.builtin.shell` + `oc` |
| `api` | REST API call (MaaS, Gitea, AAP) | `ansible.builtin.uri` |
| `tcp-check` | Service reachability (MCP, SSE stream) | `ansible.builtin.wait_for` |
| `ui-playwright` | No API/CLI equivalent — UI is the exercise | Playwright script |
| `skip` | Informational only, no student action | no task |

**Key classification rules:**
- "Label something in OCP Console" → `oc-cli` (`oc label`), NOT `ui-playwright`
- "Check a service is reachable" → `tcp-check` if SSE/streaming; `api` if HTTP REST
- "Chat in a browser playground" → `skip` for validate (can't verify chat happened); `skip` for solve (browser-only)
- "Generate an API token in a UI" → `api` (call the backend API directly)

**Show the full classification per module and confirm before generating.**

---

## Step 2: Generate solve.yml + validate.yml

One module at a time. Generate both files together.

### solve.yml template

```yaml
---
- name: Module N Solve — <Title>
  hosts: localhost
  connection: local
  gather_facts: false
  vars:
    student_user: "{{ user | default('') }}"
    # Per-student namespaces (from AgV catalog):
    wksp_namespace: "wksp-{{ student_user }}"
    llamastack_namespace: "llamastack-{{ student_user }}"
    # Shared service URLs:
    model_internal_url: "https://qwen3-4b-instruct-kserve-workload-svc.llm.svc.cluster.local:8000"
    maas_api_url: "http://maas-api.maas-api.svc.cluster.local:8080"
    maas_groups:
      - "tier-enterprise-users"
  tasks:
    # Each k8s / api / tcp-check / oc-cli step becomes a task
    # Steps classified as 'skip' → not included
    # Steps classified as 'ui-playwright' → call Playwright script

    - name: Report solve status
      ansible.builtin.debug:
        msg: |
          <service 1>: {{ 'ok' if <condition> else 'NOT ok' }}
          <service 2>: {{ 'ok' if <condition> else 'NOT ok' }}
```

**solve.yml rules:**
- `ignore_errors: true` on all service checks
- No manual step guidance in debug output — only report results
- No `ansible.builtin.pause`
- MaaS API token: check if exists first, only POST if none found
- Internal `.svc.cluster.local` URLs only — never external routes

### validate.yml template

```yaml
---
- name: Module N Validation — <Title>
  hosts: localhost
  connection: local
  gather_facts: false
  vars:
    student_user: "{{ user | default('') }}"
    wksp_namespace: "wksp-{{ student_user }}"
    llamastack_namespace: "llamastack-{{ student_user }}"
    model_internal_url: "https://qwen3-4b-instruct-kserve-workload-svc.llm.svc.cluster.local:8000"
    maas_api_url: "http://maas-api.maas-api.svc.cluster.local:8080"
    maas_groups:
      - "tier-enterprise-users"
  tasks:
    - name: Check Task 1 — <description>
      ansible.builtin.uri:          # or k8s_info / wait_for
        ...
      register: r_task1
      ignore_errors: true

    - name: Build task results
      ansible.builtin.set_fact:
        _task1_ok: "{{ r_task1.status | default(0) == 200 }}"
        _task2_ok: "{{ ... }}"

    - name: Validate all tasks
      validation_check:
        check: "{{ _task1_ok and _task2_ok }}"
        pass_msg: |
          ✅ Task 1: <what passed>
          ✅ Task 2: <what passed>
        error_msg: |
          {{ '✅' if _task1_ok else '❌' }} Task 1: <what passed or failed — and fix hint>
          {{ '✅' if _task2_ok else '❌' }} Task 2: <what passed or failed — and fix hint>
```

**validate.yml rules:**
- `validation_check` plugin is mandatory — never use `ansible.builtin.fail`
- `check:` must reflect actual results — never `check: "true"`
- `student_user: "{{ user | default('') }}"` must be in every playbook
- No manual steps, no navigation instructions — only report what was checked
- `pass_msg` / `error_msg` use `✅` / `❌` per task so students can see exactly what passed

---

## Playwright Scripts (solve.yml only)

When a step is classified `ui-playwright`, Claude generates a Playwright `.js` script and calls it from solve.yml.

**Where to store:** `runtime-automation/module-N/playwright/step-N-<description>.js`

**How to call from solve.yml:**

```yaml
- name: "<description> (Playwright — no API equivalent)"
  ansible.builtin.script:
    executable: node
    cmd: "{{ playbook_dir }}/playwright/step-01-<description>.js"
  environment:
    CONSOLE_URL: "{{ openshift_console_url | default('') }}"
    NAMESPACE: "{{ wksp_namespace }}"
    USERNAME: "{{ student_user }}"
    PASSWORD: "{{ student_password | default('') }}"
  register: r_playwright
  ignore_errors: true

- name: Report Playwright step
  ansible.builtin.debug:
    msg: "{{ r_playwright.stdout | default('no output') }}"
```

**validate.yml never uses Playwright.** If solve used a Playwright script to label a ConfigMap, validate uses `kubernetes.core.k8s_info` to verify the label exists.

### Playwright script template

Claude generates scripts following this pattern:

```javascript
// runtime-automation/module-01/playwright/step-01-<description>.js
// UI step: <what this does>
// No API/CLI equivalent because: <reason>
//
// Environment variables:
//   CONSOLE_URL  — OCP console URL
//   NAMESPACE    — student namespace
//   USERNAME     — OCP/Keycloak username
//   PASSWORD     — OCP/Keycloak password

const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({
    headless: true,
    args: ['--disable-blink-features=AutomationControlled', '--no-sandbox'],
  });
  const context = await browser.newContext({ ignoreHTTPSErrors: true });

  // Hide webdriver flag — Keycloak SSO detects headless browsers
  await context.addInitScript(() => {
    Object.defineProperty(navigator, 'webdriver', { get: () => false });
  });

  const page = await context.newPage();

  const consoleUrl = process.env.CONSOLE_URL;
  const namespace  = process.env.NAMESPACE;
  const username   = process.env.USERNAME;
  const password   = process.env.PASSWORD;

  try {
    // 1. Navigate to console
    await page.goto(consoleUrl, { waitUntil: 'domcontentloaded' });

    // 2. Login — detect Keycloak SSO vs htpasswd
    const loginLinks = await page.getByRole('link').all();
    const rhbkLink = loginLinks.find(async l =>
      (await l.textContent()).match(/RHBK|SSO|Sandbox user/i)
    );
    if (rhbkLink) {
      // Keycloak SSO path
      await page.getByRole('link', { name: /Sandbox user.*RHBK/i }).click();
      await page.getByLabel('Username').fill(username);
      await page.getByLabel('Password').fill(password);
      await page.getByRole('button', { name: /log in/i }).click();
    } else {
      // htpasswd path
      await page.getByLabel('Username').fill(username);
      await page.getByLabel('Password').fill(password);
      await page.getByRole('button', { name: /log in/i }).click();
    }
    await page.waitForURL('**/console/**', { timeout: 30000 });

    // 3. Perform the UI action
    // ... generated based on the specific step from the .adoc content
    // Example: navigate to a resource, click Actions, fill a form, save

    console.log('SUCCESS: <what was completed>');
    process.exit(0);
  } catch (err) {
    console.error('FAILED:', err.message);
    process.exit(1);
  } finally {
    await browser.close();
  }
})();
```

**Script rules:**
- `process.exit(0)` on success, `process.exit(1)` on failure
- `console.log('SUCCESS: ...')` / `console.error('FAILED: ...')` — Ansible surfaces these via SSE
- All dynamic values via environment variables — never hardcoded
- `ignoreHTTPSErrors: true` — self-signed certs in OCP
- Hide webdriver flag — Keycloak detects headless mode
- One UI action per script file — keep them focused

**Claude generates each script by reading the exact UI steps from the `.adoc` file and translating them into Playwright actions.** The `.adoc` describes what the student clicks, fills, and submits — Claude maps each action to the corresponding Playwright selector and method.

---

## Step 3: Test Each Module

After generating, give these test commands:

```bash
SHOWROOM=https://<showroom-route-from-lab>

# Test validate (should show ❌ on fresh environment)
curl -sk -N "$SHOWROOM/stream/validate/module-01"

# Run solve
curl -sk -N "$SHOWROOM/stream/solve/module-01"

# Test validate again (should show ✅ after solve)
curl -sk -N "$SHOWROOM/stream/validate/module-01"
```

No Demolition required. The SSE endpoints are on the Showroom pod directly — `curl -N` streams the output.

**STOP after each module.** Wait for the user to confirm pass/fail before generating the next one.

---

## Critical Rules

1. **Read AgV catalog first** — namespace patterns come from `common.yaml`, never guessed
2. **`student_user: "{{ user | default('') }}"` in every playbook** — always map from runner extravar
3. **`check:` reflects real results** — never `check: "true"`
4. **No manual steps in output** — solve/validate only report what they checked
5. **`ignore_errors: true` on all service checks** — runner must not abort
6. **validate.yml never uses Playwright** — always pure Ansible
7. **`validation_check` is mandatory** — never `ansible.builtin.fail`
8. **Internal `.svc.cluster.local` only** — never external routes in playbooks
9. **ONE MODULE AT A TIME** — generate, test, confirm before next

---

## Related Skills

- `/showroom:create-lab` — Create showroom content (run before this skill)
- `/agnosticv:catalog-builder` — Set up the AgV catalog
