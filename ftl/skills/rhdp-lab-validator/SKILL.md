---
name: ftl:rhdp-lab-validator
description: This skill should be used when the user asks to "add E2E test grading to my existing RHDP lab", "create runtime-automation playbooks", "generate solve.yml and validation.yml for my showroom", "add validation to my summit lab", "create automated solve/validate graders for RHDP", "write validation playbooks", "add Solve and Validate buttons to my showroom lab", or "generate module graders".
version: 4.0.0
---

---
context: main
model: claude-sonnet-4-6
---

# RHDP Lab Validator — E2E Grading Skill

Generates `runtime-automation/module-N/{solve,validate}.yml` Ansible playbooks for any RHDP Showroom lab. Uses the **ZT runner** execution model — Ansible runs as a Kubernetes ServiceAccount inside the OCP cluster, triggered via SSE from the Showroom pod.

**Fully self-contained.** No ECC, no Demolition, no external tools required.

---

## How the ZT Runner Works

```
Showroom pod  →  SSE  →  ZT runner SA  →  runs Ansible playbook
                /stream/solve/module-01    solve.yml
                /stream/validate/module-01 validate.yml
```

The runner SA has **cluster-admin**. Playbooks run on `localhost` inside the cluster with full access to `.svc.cluster.local` service URLs and the Kubernetes API.

**Runner extravars:** `user` (student Keycloak username), `guid`, any extras configured in `ocp4_workload_runtime_automation_k8s_extra_vars`

**Runner container includes:** Python + Ansible, `kubernetes.core` collection, `validation_check` plugin, Node.js + Playwright (chromium)

---

## Core Rules

**solve.yml** → Automation priority ladder (strictly in order):
```
1. kubernetes.core.k8s / k8s_info   ← OCP resources (always first)
2. ansible.builtin.shell + oc CLI   ← oc label, oc patch, oc scale
3. ansible.builtin.uri              ← REST API (MaaS, Gitea, AAP)
4. ansible.builtin.wait_for         ← TCP checks (MCP servers, streams)
5. Playwright .js script            ← LAST RESORT — no API/CLI equivalent
```

**validate.yml** → Pure Ansible only. Never Playwright, never manual step guidance. Report only what was verified.

**Always:**
- `student_user: "{{ user | default('') }}"` in every playbook
- `validate_certs: false` on all HTTPS calls to internal services
- `ignore_errors: true` on all service checks
- `validation_check` plugin (never `ansible.builtin.fail`)
- `check:` reflects real results (never `check: "true"`)

---

## Step 0 — Present the Plan

**Before doing anything, show the user the full plan and ask for confirmation.**

```
Here's what I'll do to add E2E runtime automation to your lab:

Phase 1 — AgnosticV setup
  • Read your AgV catalog to understand namespace patterns, workloads, extravars
  • Create branch: <lab-short-name>-zt-runtime-automation in agnosticv
  • Add ZT runner workload (rhpds.ftl.ocp4_workload_runtime_automation_k8s)
    and FTL collection to requirements_content (if not already present)
  • Ask permission → push branch and create AgV PR

Phase 2 — Showroom scaffolding
  • Create branch: zt-runtime-automation in the showroom repo
  • Copy content/lib/ and content/supplemental-ui/ from reference showroom
  • Update site.yml to enable inject-buttons.js Antora extension
  • Create runtime-automation/module-N/ directories with empty solve.yml
    and validation.yml stubs for each module
  • Ask permission → push branch and create showroom PR (draft)

Phase 3 — Read lab content
  • Read all .adoc module files and classify each student step

Phase 4 — Live cluster discovery
  • Connect to a running lab environment to discover real service URLs,
    namespace patterns, and verify what's actually deployed
  • [For dedicated lab] I'll ask for your API server URL and a login token
  • [For tenant lab]  Order from integration.demo.redhat.com, then either
    log in via 'oc login' and tell me, or share admin credentials (token only)
  • I'll read namespaces and services — no passwords will be stored or echoed

Phase 5 — Generate solve.yml + validate.yml
  • One module at a time, with curl test commands after each
  • Generate Playwright scripts for any genuinely browser-only steps

Phase 6 — Test
  • Run curl tests against the live showroom SSE endpoints
  • Verify solve → validate → pass flow

Ready to start? I'll need:
  1. Your AgnosticV catalog path  (e.g. summit-2026/lb2860-private-maas-tenant)
  2. Showroom repo URL             (e.g. https://github.com/rhpds/private-maas-showroom)
  3. Lab type: dedicated or tenant?

[Y to proceed / N to adjust the plan]
```

WAIT for the user to say yes before doing anything.

---

## Phase 1 — AgnosticV Setup

### 1.1 Read the catalog

```bash
cat <agv-repo>/<catalog-path>/common.yaml
```

Extract:
- `config:` → lab type (`namespace` = tenant, `openshift-workloads` = dedicated)
- `ocp4_workload_tenant_namespace_namespaces:` → per-student namespace patterns
- `ocp4_workload_tenant_keycloak_username:` → maps to `user` extravar
- `workloads:` → already has `rhpds.ftl.ocp4_workload_runtime_automation_k8s`?
- `requirements_content.collections:` → already has `rhpds-ftl`?

### 1.2 Create AgV branch and update

```bash
git -C <agv-repo> checkout -b <lab-short-name>-zt-runtime-automation
```

**Add if missing — ZT runner workload:**
```yaml
workloads:
  - ...existing workloads...
  - rhpds.ftl.ocp4_workload_runtime_automation_k8s

ocp4_workload_runtime_automation_k8s_cluster_admin: true
ocp4_workload_runtime_automation_k8s_openshift_api_url: "{{ sandbox_openshift_api_url }}"
ocp4_workload_runtime_automation_k8s_openshift_api_token: "{{ cluster_admin_agnosticd_sa_token }}"
```

**Add if missing — FTL collection in requirements_content:**
```yaml
requirements_content:
  collections:
    - name: https://github.com/rhpds/rhpds-ftl.git
      type: git
      version: main
```

**Update showroom content ref (for testing this branch):**
```yaml
ocp4_workload_showroom_content_git_repo_ref: zt-runtime-automation
```

### 1.3 Ask permission to push and create PR

```
I've updated the AgV catalog. Ready to:
  git push origin <lab-short-name>-zt-runtime-automation
  gh pr create --draft --title "feat(<lab>): add ZT runner + FTL for E2E grading"

Shall I push and create the AgV PR? [Y/n]
```

---

## Phase 2 — Showroom Scaffolding

### 2.1 Clone or use local showroom

If local path provided — use it.
If GitHub URL provided — clone to `/tmp/ftl-<lab-short-name>-showroom/`.

### 2.2 Create branch

```bash
git -C <showroom-repo> checkout -b zt-runtime-automation
```

### 2.3 Copy reference supplemental files

Copy from the reference showroom (if accessible locally) OR generate from templates:

**`content/lib/inject-buttons.js`** — Antora extension that injects Solve/Validate buttons into each module page. Copy from `ocp-zt-tenant-showroom` or the canonical source.

**`content/supplemental-ui/js/buttons.js`** — SSE client that connects to `/stream/solve/{module}` and `/stream/validate/{module}`. Copy from reference.

**`content/supplemental-ui/css/site-extra.css`** — Button and terminal output styling.

### 2.4 Update site.yml

Ensure these are present in `site.yml`:
```yaml
ui:
  supplemental_files:
    - path: ./content/supplemental-ui
    - path: ./content/lib
    - path: .nojekyll
    - path: ui.yml
      contents: "static_files: [ .nojekyll, css/site-extra.css, js/buttons.js ]"

antora:
  extensions:
    - require: ./content/lib/dev-mode.js
      enabled: false
    - require: ./content/lib/inject-buttons.js
```

### 2.5 Create runtime-automation scaffolding

Read all module `.adoc` files to get module names. For each module that has student exercises:

```bash
mkdir -p runtime-automation/<module-dir>
```

Create stub `solve.yml`:
```yaml
---
- name: <Module Title> Solve
  hosts: localhost
  connection: local
  gather_facts: false
  vars:
    student_user: "{{ user | default('') }}"
  tasks: []
```

Create stub `validation.yml`:
```yaml
---
- name: <Module Title> Validation
  hosts: localhost
  connection: local
  gather_facts: false
  vars:
    student_user: "{{ user | default('') }}"
  tasks: []
```

### 2.6 Show scaffolding summary and ask permission

```
Showroom branch ready:
  Branch: zt-runtime-automation
  Supplemental files: ✅ content/lib/, content/supplemental-ui/
  site.yml: ✅ inject-buttons.js enabled
  Scaffolding created:
    runtime-automation/module-02-model/solve.yml  (stub)
    runtime-automation/module-02-model/validation.yml  (stub)
    runtime-automation/module-03-code/solve.yml  (stub)
    ... (N modules)

Shall I push and create the showroom PR (draft)? [Y/n]
```

---

## Phase 3 — Read Lab Content

Read every `.adoc` file in `content/modules/ROOT/pages/`. For each student step, classify:

| Type | What it is | How to automate |
|---|---|---|
| `k8s` | Create/update OCP resource | `kubernetes.core.k8s` |
| `k8s-check` | Read/verify OCP resource | `kubernetes.core.k8s_info` |
| `oc-cli` | OCP Console action with `oc` equivalent | `ansible.builtin.shell` + `oc` |
| `api` | REST API call (MaaS, Gitea, AAP) | `ansible.builtin.uri` |
| `tcp-check` | Service reachability | `ansible.builtin.wait_for` |
| `ui-playwright` | No API/CLI equivalent — UI is the exercise | Playwright script |
| `skip` | Informational, no student action | no task |

Show the full classification per module. Confirm before generating.

---

## Phase 4 — Live Cluster Discovery

**This phase reads the real cluster to get correct service URLs and namespace patterns.**
Without real cluster data, service hostnames and namespace names will be wrong.

### For a dedicated lab

```
I need to connect to the lab cluster.

Please run:
  oc login --token=<your-token> --server=<api-url>

Then tell me: "I've logged in" — I'll take it from there.

(Alternative: share just the API URL and a read-only token.
 Never share passwords directly.)
```

### For a tenant lab

```
I need a running tenant lab environment.

Option A — Order and connect:
  1. Go to integration.demo.redhat.com
  2. Order <lab-name>
  3. Once provisioned, log in: oc login --token=<token> --server=<api-url>
  4. Tell me: "I've logged in as admin on the cluster"

Option B — Share a read-only token:
  oc create token <service-account> -n default
  Share the token + API server URL.
  I'll log in and read what I need.

(Never share your personal password. Tokens only.)
```

WAIT for user to confirm they've logged in. Do NOT proceed to discovery until confirmed.

### What Claude reads from the cluster

Once logged in, Claude runs these discovery commands automatically:

```bash
# All student-related namespaces
oc get namespaces --no-headers | awk '{print $1}' | grep -E "<pattern from agv>"

# What services exist in each namespace
oc get services -n <student-namespace> --no-headers
oc get services -n <shared-namespace> --no-headers

# Showroom userdata for real extravars
oc get configmap showroom-userdata -n showroom-<user> \
  -o jsonpath='{.data.user_data\.yml}'

# What pods are running
oc get pods -A --no-headers | grep -E "<lab-pattern>"
```

**Record from discovery:**
- Exact namespace names per student (e.g., `llamastack-llmuser-GUID` vs `lls-demo`)
- Whether MCP servers / services are shared or per-student
- Internal `.svc.cluster.local` hostnames for each service
- Ports (critical — `8080` vs `8443` vs `3000` matters)
- `user` extravar value from ConfigMap

**Present findings:**
```
📋 Live cluster discovery (GUID: pp6md, user: llmuser-pp6md)

Shared namespaces (same URL for all students):
  lls-demo       → ocp-mcp-server:8080, slack-mcp-server:80
  llm            → qwen3-4b-instruct-kserve-workload-svc:8000
  redhat-ods-applications → maas-api:8443 (HTTPS, validate_certs: false)
  grafana        → grafana-service:3000

Per-student namespaces (use {{ user }} in URLs):
  llmuser-{{ user }}   → lsd-genai-playground-service:8321
  wksp-{{ user }}      → DevSpaces workspace
  showroom-{{ user }}  → Showroom pod

Confirmed? [Y/n]
```

---

## Phase 5 — Generate solve.yml + validate.yml

Using the Phase 3 classification + Phase 4 discovery, generate the actual playbooks.

One module at a time — fill in the stubs created in Phase 2.

### solve.yml pattern

```yaml
---
- name: Module N Solve — <Title>
  hosts: localhost
  connection: local
  gather_facts: false
  vars:
    student_user: "{{ user | default('') }}"
    # Per-student (use {{ student_user }}):
    wksp_namespace: "wksp-{{ student_user }}"
    # Shared (no {{ student_user }}):
    model_url: "https://<service>.<namespace>.svc.cluster.local:<port>"
    maas_api_url: "https://maas-api.redhat-ods-applications.svc.cluster.local:8443"
  tasks:
    # ... generated tasks based on Phase 3 classification
    - name: Report solve status
      ansible.builtin.debug:
        msg: |
          <service>: {{ 'ok' if <condition> else 'NOT ok' }}
```

### validate.yml pattern

```yaml
---
- name: Module N Validation — <Title>
  hosts: localhost
  connection: local
  gather_facts: false
  vars:
    student_user: "{{ user | default('') }}"
    # same namespace vars as solve.yml
  tasks:
    - name: Check <thing>
      ansible.builtin.uri:  # or k8s_info / wait_for
        validate_certs: false  # required for internal HTTPS
        ...
      register: r_<name>
      ignore_errors: true

    - name: Build task results
      ansible.builtin.set_fact:
        _task1_ok: "{{ <condition> }}"
        _task2_ok: "{{ <condition> }}"

    - name: Validate all tasks
      validation_check:
        check: "{{ _task1_ok and _task2_ok }}"
        pass_msg: |
          ✅ Task 1: <description>
          ✅ Task 2: <description>
        error_msg: |
          {{ '✅' if _task1_ok else '❌' }} Task 1: {{ 'ok' if _task1_ok else 'FAILED — <fix hint>' }}
          {{ '✅' if _task2_ok else '❌' }} Task 2: {{ 'ok' if _task2_ok else 'FAILED — <fix hint>' }}
```

### Playwright scripts (solve.yml only)

When a step is `ui-playwright` — no API/CLI equivalent exists and the UI interaction IS the exercise — generate a Playwright script:

**File:** `runtime-automation/module-N/playwright/step-N-<description>.js`

**Called from solve.yml:**
```yaml
- name: "<description> (Playwright)"
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
```

**Script pattern:**
```javascript
// runtime-automation/module-N/playwright/step-N-<description>.js
// UI step: <what this does and why no API equivalent>
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({
    headless: true,
    args: ['--disable-blink-features=AutomationControlled', '--no-sandbox'],
  });
  const context = await browser.newContext({ ignoreHTTPSErrors: true });

  // Hide webdriver — Keycloak SSO detects headless browsers
  await context.addInitScript(() => {
    Object.defineProperty(navigator, 'webdriver', { get: () => false });
  });

  const page = await context.newPage();
  const consoleUrl = process.env.CONSOLE_URL;
  const namespace  = process.env.NAMESPACE;
  const username   = process.env.USERNAME;
  const password   = process.env.PASSWORD;

  try {
    await page.goto(consoleUrl, { waitUntil: 'domcontentloaded' });

    // Detect Keycloak SSO vs htpasswd
    const rhbkLink = page.getByRole('link', { name: /Sandbox user.*RHBK/i });
    if (await rhbkLink.isVisible({ timeout: 3000 }).catch(() => false)) {
      await rhbkLink.click();
    }
    await page.getByLabel('Username').fill(username);
    await page.getByLabel('Password').fill(password);
    await page.getByRole('button', { name: /log in/i }).click();
    await page.waitForURL('**/console/**', { timeout: 30000 });

    // ---- UI action generated from .adoc steps ----
    // (Claude fills this in based on the specific module content)

    console.log('SUCCESS: <what was done>');
    process.exit(0);
  } catch (err) {
    console.error('FAILED:', err.message);
    process.exit(1);
  } finally {
    await browser.close();
  }
})();
```

---

## Phase 6 — Test on Live Cluster

After generating each module, push and test immediately.

### 6.1 Push the generated files

```bash
git -C <showroom-repo> add runtime-automation/module-N/
git -C <showroom-repo> commit -m "Add solve/validate for module-N"
git -C <showroom-repo> push
```

### 6.2 Get the showroom URL

```bash
oc get route -n showroom-<user> --no-headers | awk '{print $2}'
# e.g. showroom-showroom-llmuser-pp6md.apps.ocp.75d7w.sandbox114.opentlc.com
```

### 6.3 Run the tests

```bash
SHOWROOM="https://$(oc get route showroom -n showroom-<user> \
  -o jsonpath='{.spec.host}')"

# Test validate on fresh environment (should show ❌)
curl -sk -N "$SHOWROOM/stream/validate/module-N"

# Run solve
curl -sk -N "$SHOWROOM/stream/solve/module-N"

# Test validate again (should show ✅)
curl -sk -N "$SHOWROOM/stream/validate/module-N"
```

**No Demolition required.** The SSE endpoints are served directly by the Showroom pod's ZT runner container.

### 6.4 Report and confirm

```
Module N test results:
  validate (fresh):  ❌ Task 1 failed — <reason>
  solve:             ✅ ran successfully
  validate (after):  ✅ all tasks passed

Proceed to module N+1? [Y/n]
```

---

## Critical Rules

1. **Plan first** — always show the full plan and get Y before doing anything
2. **Read AgV catalog first** — namespace patterns come from `common.yaml`, never guessed
3. **Live cluster before generating** — real service URLs only, no invented hostnames
4. **Never ask for passwords** — ask user to `oc login` and confirm; tokens only if sharing
5. **`student_user: "{{ user | default('') }}"` in every playbook**
6. **`validate_certs: false` on all internal HTTPS calls**
7. **`ignore_errors: true` on all service checks**
8. **validate.yml: pure Ansible, no Playwright, no manual step guidance**
9. **`validation_check` is mandatory, never `ansible.builtin.fail`**
10. **ONE MODULE AT A TIME** — push, test, confirm before next module

---

## Related Skills

- `/showroom:create-lab` — Create showroom content (run before this skill)
- `/agnosticv:catalog-builder` — Set up the AgV catalog
