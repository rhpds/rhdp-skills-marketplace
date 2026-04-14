---
name: ftl:rhdp-lab-validator
description: This skill should be used when the user asks to "add E2E test grading to my existing RHDP lab", "create runtime-automation playbooks", "generate solve.yml and validation.yml for my showroom", "add validation to my summit lab", "create automated solve/validate graders for RHDP", "write validation playbooks", "add Solve and Validate buttons to my showroom lab", or "generate module graders".
version: 5.0.0
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

**Runner extravars:** `user` (student Keycloak username), `guid`, extras from `ocp4_workload_runtime_automation_k8s_extra_vars`

**Runner container includes:** Python + Ansible, `kubernetes.core` collection, `validation_check` plugin, Node.js + Playwright (chromium)

**Testing endpoints directly (no Demolition needed):**
```bash
SHOWROOM="https://$(oc get route showroom -n showroom-<user> -o jsonpath='{.spec.host}')"
curl -sk -N "$SHOWROOM/stream/validate/module-02-model"
curl -sk -N "$SHOWROOM/stream/solve/module-02-model"
```

---

## Core Rules

**solve.yml** → Automation priority ladder (strictly in order):
```
1. kubernetes.core.k8s_exec into pod  ← exec into pod, call localhost (bypasses NetworkPolicy)
2. kubernetes.core.k8s / k8s_info     ← OCP resources (always use kubeconfig param)
3. ansible.builtin.shell + oc CLI     ← oc label, oc patch, oc scale
4. ansible.builtin.uri                ← REST API (MaaS, Grafana, Gitea, AAP)
5. ansible.builtin.wait_for           ← TCP checks (MCP servers, SSE streams)
6. Playwright .js script              ← LAST RESORT — genuine browser-only UI
```

**validate.yml** → Pure Ansible only. Never Playwright, never manual step guidance. Report only what was verified.

**Always in every playbook:**
- `student_user: "{{ user | default('') }}"` in `vars:` — runner passes `user`, NOT `student_user`
- `validate_certs: false` on ALL HTTPS calls to internal services
- `ignore_errors: true` on all service checks
- `validation_check` plugin (never `ansible.builtin.fail`)
- `check:` reflects real results — **never `check: "true"`** (always-pass is a bug)
- `kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"` on every `kubernetes.core.*` task

---

## Critical Bugs to Avoid (Learned from LB2860)

### 1. Wrong showroom collection breaks runner deployment
```yaml
# WRONG — old, ignores runtime_automation_enable
workloads:
  - agnosticd.core_workloads.ocp4_workload_showroom

# CORRECT — v1.6.6 added runtime_automation_image support
workloads:
  - agnosticd.showroom.ocp4_workload_showroom

requirements_content:
  collections:
    - name: https://github.com/agnosticd/showroom.git
      type: git
      version: v1.6.6   # ← critical — do not use main
```
Without `v1.6.6`, `runtime_automation_enable: true` is silently ignored and the runner container never appears in the showroom pod.

### 2. Missing chart vars — helm call fails silently
Always set all three:
```yaml
ocp4_workload_showroom_chart_package_url: https://rhpds.github.io/showroom-deployer
ocp4_workload_showroom_deployer_chart_name: showroom-single-pod
ocp4_workload_showroom_deployer_chart_version: "2.1.4"
```

### 3. dev.yaml overrides common.yaml — always check it
`dev.yaml` in the same catalog directory can override `content_git_repo_ref` back to `main`, silently defeating your branch. Check and clean it before testing.

### 4. kubernetes.core tasks without kubeconfig use the wrong SA
The showroom pod's own SA has no cross-namespace access. The runner loads cluster-admin kubeconfig from the `zt-runner-kubeconfig` Secret and passes it as `k8s_kubeconfig`. Always add:
```yaml
kubernetes.core.k8s_info:
  kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
  ...
```

### 5. k8s_exec command must be a string, not a list
```yaml
# WRONG — Kubernetes treats "[python3," as the executable name
command:
  - python3
  - -c
  - "..."

# CORRECT — single string
command: "python3 -c \"import os; ...\""
```

### 6. check: "true" is always-pass — silent bug
```yaml
# WRONG
validation_check:
  check: "true"   # always passes, never catches failures

# CORRECT
validation_check:
  check: "{{ _task1_ok and _task2_ok }}"
```

### 7. Pod labels never match the pod name
Always inspect actual pod labels before writing selectors:
```bash
oc get pod <pod-name> -o jsonpath='{.metadata.labels}' | python3 -m json.tool
```
Example: pod named `lsd-genai-playground` had label `app=llama-stack`, not `app=lsd-genai-playground`.

### 8. k8s API proxy uses pod SA, not cluster-admin kubeconfig
`ansible.builtin.uri` against the k8s API server proxy uses the pod's mounted SA token. You get 403. Use `kubernetes.core.k8s_exec` instead to call services via localhost from inside the target pod.

---

## Step 0 — Present the Plan

**Before doing anything, show the full plan and ask for Y.**

```
Here's what I'll do to add E2E runtime automation to your lab:

Phase 1 — AgnosticV setup
  • Read AgV catalog: namespace patterns, workloads, extravars
  • Also read dev.yaml — it may override content_git_repo_ref
  • Create branch: <lab-short-name>-zt-runtime-automation
  • Add showroom collection v1.6.6, FTL collection, ZT runner workload
  • Add chart vars + runtime_automation_enable/image
  • Ask: content-only or terminal (wetty)?
  • Push + create AgV PR

Phase 2 — Showroom scaffolding
  • Create branch: zt-runtime-automation
  • Copy content/lib/ + content/supplemental-ui/ from ocp-zt-tenant-showroom
  • Update site.yml (inject-buttons.js, static_files)
  • Create stub solve.yml + validation.yml per module
  • Push + create showroom PR (draft)

Phase 3 — Read lab content
  • Read all .adoc files including screenshots — screenshots show exact UI labels
  • Classify each student step

Phase 4 — Live cluster discovery (MANDATORY before writing any URLs)
  • Read actual namespaces, services, ports, pod labels from a running lab
  • Get showroom userdata ConfigMap for all extravars
  • Never invent service hostnames

Phase 5 — Generate solve.yml + validate.yml (one module at a time)

Phase 6 — Test: validate (fail) → solve → validate (pass)

Ready? I need:
  1. AgV catalog path
  2. Showroom repo URL
  3. Lab type: dedicated or tenant?

[Y/n]
```

---

## Phase 1 — AgnosticV Setup

### 1.1 Read catalog AND dev.yaml

```bash
cat <agv-repo>/<catalog-path>/common.yaml
cat <agv-repo>/<catalog-path>/dev.yaml   # ← always check this too
```

From `common.yaml` extract:
- `config:` → `namespace` = tenant, `openshift-workloads` = dedicated
- `ocp4_workload_tenant_namespace_namespaces:` → per-student namespace list
- `ocp4_workload_tenant_keycloak_username:` → maps to `user` extravar
- `workloads:` → using `core_workloads` or `showroom` collection?
- `requirements_content.collections:` → showroom version pinned?

From `dev.yaml`: remove any `ocp4_workload_showroom_content_git_repo_ref: main` — this overrides your branch.

### 1.2 Create branch and update

**Showroom workload — use showroom collection, not core_workloads:**
```yaml
# requirements_content
collections:
  - name: https://github.com/agnosticd/showroom.git
    type: git
    version: v1.6.6    # critical — this version added runtime_automation support
  - name: https://github.com/rhpds/rhpds-ftl.git
    type: git
    version: main

# workloads
# Change: agnosticd.core_workloads.ocp4_workload_showroom
# To:     agnosticd.showroom.ocp4_workload_showroom
```

**ZT runner workload:**
```yaml
workloads:
  - ...
  - rhpds.ftl.ocp4_workload_runtime_automation_k8s

ocp4_workload_runtime_automation_k8s_cluster_admin: true
ocp4_workload_runtime_automation_k8s_openshift_api_url: "{{ sandbox_openshift_api_url }}"
ocp4_workload_runtime_automation_k8s_openshift_api_token: "{{ cluster_admin_agnosticd_sa_token }}"
```

**Ask: content-only or terminal?**
- **Content-only** (students use DevSpaces, own IDE): add `ocp4_workload_showroom_content_only: true`, no wetty vars
- **With terminal** (wetty/SSH to bastion): add `ocp4_workload_showroom_terminal_type: wetty`

**Showroom chart vars (required for all labs):**
```yaml
ocp4_workload_showroom_chart_package_url: https://rhpds.github.io/showroom-deployer
ocp4_workload_showroom_deployer_chart_name: showroom-single-pod
ocp4_workload_showroom_deployer_chart_version: "2.1.4"
ocp4_workload_showroom_runtime_automation_enable: true
ocp4_workload_showroom_runtime_automation_image: "quay.io/rhpds/zt-runner:v2.4.2"
ocp4_workload_showroom_content_git_repo_ref: zt-runtime-automation
```

---

## Phase 2 — Showroom Scaffolding

Copy reference supplemental files from `ocp-zt-tenant-showroom`:
- `content/lib/inject-buttons.js`
- `content/supplemental-ui/js/buttons.js`
- `content/supplemental-ui/css/site-extra.css`

`site.yml` must have:
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

Stub `solve.yml` and `validation.yml` per module — both always start with:
```yaml
vars:
  student_user: "{{ user | default('') }}"
```

---

## Phase 3 — Read Lab Content

Read every `.adoc` file AND the screenshots referenced in them. Screenshots show exact button labels, tab names, dropdown options — critical for Playwright scripts.

Classify each student step:

| Type | What | How |
|---|---|---|
| `exec-into-pod` | Service inside cluster blocked by NetworkPolicy | `kubernetes.core.k8s_exec` at localhost |
| `k8s` | Create/update OCP resource | `kubernetes.core.k8s` + kubeconfig param |
| `k8s-check` | Read/verify OCP resource | `kubernetes.core.k8s_info` + kubeconfig param |
| `api` | REST API (MaaS, Grafana, Gitea, AAP) | `ansible.builtin.uri` |
| `tcp-check` | Service port reachability | `ansible.builtin.wait_for` |
| `devspaces-exec` | Action in DevSpaces workspace | `k8s_exec` into workspace pod |
| `vsix-install` | VS Code extension install | Download VSIX from Open VSX, extract to `/checode/.../extensions/` |
| `ui-playwright` | No API/CLI equivalent — browser-only | Playwright script |
| `skip` | Informational only | no task |

---

## Phase 4 — Live Cluster Discovery

**Never invent service hostnames. Always inspect a running lab first.**

```bash
# 1. All student namespaces
oc get namespaces --no-headers | awk '{print $1}' | grep "<guid>"

# 2. Services in each namespace — get actual hostnames and ports
oc get services -A --no-headers | grep -E "<relevant-pattern>"

# 3. Pod labels — needed for kubernetes.core selectors
oc get pod <pod-name> -n <namespace> -o jsonpath='{.metadata.labels}'

# 4. Showroom userdata — all extravars available to runner
oc get configmap showroom-userdata -n showroom-<user> -o jsonpath='{.data.user_data\.yml}'

# 5. Verify runner container is present
oc get pod -n showroom-<user> -o json | python3 -c "
import json,sys; d=json.load(sys.stdin)
for item in d['items']:
    for c in item['spec']['containers']: print(c['name'], c['image'])
"
```

**Present findings before generating any playbooks:**
```
Shared services (same URL for all students):
  lls-demo       → ocp-mcp-server:8080, slack-mcp-server:80
  llm            → qwen3-4b-instruct-kserve-workload-svc:8000 (HTTPS, validate_certs: false)
  redhat-ods-applications → maas-api:8443 (HTTPS, validate_certs: false)
  grafana        → grafana-service:3000

Per-student namespaces (use {{ student_user }}):
  llmuser-{{ student_user }}  → lsd-genai-playground-service:8321 (label: app=llama-stack)
  wksp-{{ student_user }}     → DevSpaces workspace pod
  showroom-{{ student_user }} → Showroom pod

Runner extravars from userdata:
  user=llmuser-<guid>, password=..., openshift_cluster_ingress_domain=apps.xxx

Confirmed? [Y/n]
```

---

## Phase 5 — Generate Playbooks

### solve.yml patterns

**Standard header (every module):**
```yaml
---
- name: Module N Solve — <Title>
  hosts: localhost
  connection: local
  gather_facts: false
  vars:
    student_user: "{{ user | default('') }}"
    maas_api_url: "https://maas-api.redhat-ods-applications.svc.cluster.local:8443"
    ingress_domain: "{{ openshift_cluster_ingress_domain | default('') }}"
```

**Pattern: exec into pod to call its own API (bypasses NetworkPolicy)**
```yaml
# Use when: service is inside cluster and NetworkPolicy blocks runner → service traffic
# Example: Llama Stack server, any internal-only service
- name: Find target pod
  kubernetes.core.k8s_info:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    kind: Pod
    namespace: "{{ student_user }}"
    label_selectors:
      - "app=llama-stack"    # ← get from: oc get pod -o yaml | grep -A5 labels
  register: r_pod

- name: Set pod name
  ansible.builtin.set_fact:
    target_pod: "{{ (r_pod.resources | selectattr('status.phase', 'equalto', 'Running') | list | first).metadata.name }}"
  when: r_pod.resources | default([]) | selectattr('status.phase', 'equalto', 'Running') | list | length > 0

- name: Call service at localhost from inside pod
  kubernetes.core.k8s_exec:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    namespace: "{{ student_user }}"
    pod: "{{ target_pod }}"
    command: "curl -s -X POST http://localhost:8321/v1/chat/completions -H 'Content-Type: application/json' -d '{\"model\":\"...\",\"messages\":[{\"role\":\"user\",\"content\":\"...\"}]}'"
  register: r_chat
  when: target_pod is defined
  ignore_errors: true
```

**Pattern: exec into DevSpaces workspace to write files or run commands**
```yaml
# Use when: need to write config files, install extensions, run code in DevSpaces
- name: Find DevSpaces workspace pod
  kubernetes.core.k8s_info:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    kind: Pod
    namespace: "wksp-{{ student_user }}"
  register: r_workspace
  ignore_errors: true

- name: Set workspace pod name
  ansible.builtin.set_fact:
    workspace_pod: "{{ (r_workspace.resources | selectattr('status.phase', 'equalto', 'Running') | list | first).metadata.name }}"
  when: r_workspace.resources | default([]) | selectattr('status.phase', 'equalto', 'Running') | list | length > 0

# Write a config file via base64 (avoids quoting issues with YAML content)
- name: Write config file into workspace
  kubernetes.core.k8s_exec:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    namespace: "wksp-{{ student_user }}"
    pod: "{{ workspace_pod }}"
    command: "python3 -c \"import base64,os; os.makedirs('/home/user/.continue',exist_ok=True); open('/home/user/.continue/config.yaml','w').write(base64.b64decode('{{ config_content | b64encode }}').decode()); print('written')\""
  when: workspace_pod is defined
  ignore_errors: true

# Install VS Code extension from Open VSX (linux-x64 VSIX)
- name: Download Continue extension from Open VSX
  kubernetes.core.k8s_exec:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    namespace: "wksp-{{ student_user }}"
    pod: "{{ workspace_pod }}"
    command: "sh -c 'ls /checode/checode-linux-libc/ubi9/extensions/Continue.continue 2>/dev/null && echo already_installed || (curl -skL https://open-vsx.org/api/Continue/continue/linux-x64/1.3.38/file/Continue.continue-1.3.38@linux-x64.vsix -o /tmp/continue.vsix && echo downloaded)'"
  register: r_download
  when: workspace_pod is defined
  ignore_errors: true

- name: Extract VSIX to extensions directory
  kubernetes.core.k8s_exec:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    namespace: "wksp-{{ student_user }}"
    pod: "{{ workspace_pod }}"
    command: "sh -c 'rm -rf /tmp/ext && unzip -q /tmp/continue.vsix -d /tmp/ext && mv /tmp/ext/extension /checode/checode-linux-libc/ubi9/extensions/Continue.continue && echo installed'"
  when:
    - workspace_pod is defined
    - r_download.stdout is defined
    - "'downloaded' in r_download.stdout"
  ignore_errors: true

# Run a script inside DevSpaces workspace
- name: Run game solution in workspace
  kubernetes.core.k8s_exec:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    namespace: "wksp-{{ student_user }}"
    pod: "{{ workspace_pod }}"
    command: "sh -c 'echo rock | python3 /projects/exercises/fun-and-games/game_solutions/rock_paper_scissors/rps_solution.py'"
  when: workspace_pod is defined
  ignore_errors: true
```

**Pattern: MaaS API token (revoke + regenerate to get value for config files)**
```yaml
# When you need the actual token value (e.g., to write into config.yaml)
# GET only returns key metadata, not the token value — must revoke and regenerate
- name: Check existing API keys
  ansible.builtin.uri:
    url: "{{ maas_api_url }}/v1/api-keys"
    method: GET
    headers:
      X-MaaS-Username: "{{ student_user }}"
      X-MaaS-Group: '["tier-enterprise-users"]'
    return_content: true
    validate_certs: false
    timeout: 10
  register: r_existing_keys
  ignore_errors: true

- name: Revoke existing token
  ansible.builtin.uri:
    url: "{{ maas_api_url }}/v1/api-keys/{{ r_existing_keys.json[0].jti | default(r_existing_keys.json[0].name) }}"
    method: DELETE
    headers:
      X-MaaS-Username: "{{ student_user }}"
      X-MaaS-Group: '["tier-enterprise-users"]'
    validate_certs: false
    status_code: [200, 204]
  when: r_existing_keys.json | default([]) | length > 0
  ignore_errors: true

- name: Generate fresh API token
  ansible.builtin.uri:
    url: "{{ maas_api_url }}/v1/api-keys"
    method: POST
    status_code: [200, 201]   # ← POST returns 201 Created, not 200
    headers:
      X-MaaS-Username: "{{ student_user }}"
      X-MaaS-Group: '["tier-enterprise-users"]'
      Content-Type: application/json
    body_format: json
    body:
      name: "{{ student_user }}-token"
    return_content: true
    validate_certs: false
    timeout: 10
  register: r_new_token
  ignore_errors: true

- name: Set token fact
  ansible.builtin.set_fact:
    maas_token: "{{ r_new_token.json.token | default('') }}"
  when: r_new_token.json is defined
```

**Pattern: Playwright for genuine browser-only UI**
```yaml
- name: Run Playwright — <description>
  ansible.builtin.script:
    executable: node
    cmd: "{{ playbook_dir }}/playwright/<script-name>.js"
  environment:
    TARGET_URL: "https://<service>.{{ ingress_domain }}"
    USERNAME: "{{ student_user }}"
    PASSWORD: "{{ password | default('') }}"
    PLAYWRIGHT_BROWSERS_PATH: /app/.playwright
  register: r_playwright
  ignore_errors: true
```

**Playwright script template (with OCP SSO login):**
```javascript
const { chromium } = require('playwright');

const TARGET_URL = process.env.TARGET_URL;
const USERNAME   = process.env.USERNAME;
const PASSWORD   = process.env.PASSWORD;

(async () => {
  const browser = await chromium.launch({
    headless: true,
    args: ['--disable-blink-features=AutomationControlled', '--no-sandbox'],
  });
  const context = await browser.newContext({ ignoreHTTPSErrors: true });
  await context.addInitScript(() => {
    Object.defineProperty(navigator, 'webdriver', { get: () => false });
  });
  const page = await context.newPage();

  try {
    await page.goto(TARGET_URL, { waitUntil: 'domcontentloaded', timeout: 30000 });

    // Handle OCP OAuth (SSO → Keycloak or htpasswd)
    if (page.url().includes('oauth') || page.url().includes('login') || page.url().includes('sso')) {
      // htpasswd: fill directly; SSO: fill after redirect to Keycloak
      const usernameField = page.locator('#username, #inputUsername, [name="username"]').first();
      await usernameField.waitFor({ state: 'visible', timeout: 15000 });
      await usernameField.fill(USERNAME);
      await page.locator('#password, #inputPassword, [name="password"]').first().fill(PASSWORD);
      await page.locator('input[type="submit"], button[type="submit"]').first().click();
      await page.waitForURL(new RegExp(new URL(TARGET_URL).hostname), { timeout: 30000 });
    }

    // Screenshot for debugging
    await page.screenshot({ path: '/tmp/playwright-debug.png' });

    // ---- Service-specific UI actions ----
    // Use text from .adoc steps as selector hints
    // Read screenshots from content/modules/ROOT/assets/images/ for exact labels

    console.log('SUCCESS: <what was done>');
    process.exit(0);
  } catch (err) {
    await page.screenshot({ path: '/tmp/playwright-debug.png' }).catch(() => {});
    console.error('FAILED:', err.message);
    process.exit(1);
  } finally {
    await browser.close();
  }
})();
```

**Playwright tips from real debugging:**
- Always take a screenshot at the failure point: `await page.screenshot({ path: '/tmp/playwright-debug.png' })`
- Copy screenshots from runner: `oc cp <ns>/<pod>:/tmp/playwright-debug.png /tmp/debug.png -c runner`
- Use `.first()` on ambiguous selectors to avoid strict-mode errors
- RHOAI project dropdowns have a search box — type to filter, then click the result
- RHOAI Gen AI Studio nav: click "Gen AI studio" to expand, then "AI asset endpoints"
- Check which namespace appears in RHOAI — not all OCP namespaces are RHOAI projects; add `opendatahub.io/dashboard: 'true'` label to expose a namespace

### validate.yml pattern

```yaml
---
- name: Module N Validation — <Title>
  hosts: localhost
  connection: local
  gather_facts: false
  vars:
    student_user: "{{ user | default('') }}"
    maas_api_url: "https://maas-api.redhat-ods-applications.svc.cluster.local:8443"
  tasks:
    - name: Check Task 1 — <description>
      ansible.builtin.uri:
        url: "..."
        validate_certs: false
        timeout: 10
      register: r_task1
      ignore_errors: true

    - name: Check Task 2 — k8s pod running
      kubernetes.core.k8s_info:
        kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"   # ← always include this
        kind: Pod
        namespace: "{{ student_user }}"
        label_selectors:
          - "app=llama-stack"   # ← from: oc get pod -o yaml | grep labels
      register: r_pod
      ignore_errors: true

    - name: Build results
      ansible.builtin.set_fact:
        _task1_ok: "{{ r_task1.status | default(0) == 200 }}"
        _task2_ok: "{{ r_pod.resources | default([]) | selectattr('status.phase', 'equalto', 'Running') | list | length > 0 }}"

    - name: Validate
      validation_check:
        check: "{{ _task1_ok and _task2_ok }}"   # ← never "true"
        pass_msg: |
          ✅ Task 1: <what passed>
          ✅ Task 2: <what passed>
        error_msg: |
          {{ '✅' if _task1_ok else '❌' }} Task 1: {{ 'ok' if _task1_ok else 'FAILED — <fix>' }}
          {{ '✅' if _task2_ok else '❌' }} Task 2: {{ 'ok' if _task2_ok else 'FAILED — <fix>' }}
```

**What CAN be validated:**
- REST API responses (MaaS API key exists, Grafana health, model endpoint)
- K8s pod running (via k8s_info with kubeconfig)
- TCP port reachable (via wait_for — for MCP servers, SSE streams)
- File exists in workspace pod (via k8s_exec check)
- VS Code extension installed in workspace (via k8s_exec ls)

**What CANNOT be validated (accept as student learning activity):**
- RHOAI playground chat responses
- Grafana metric comprehension
- Game quality / game logic
- DevSpaces UI interaction (Continue chat)

---

## Phase 6 — Test

```bash
# On a fresh lab — validate should fail for student-action steps
curl -sk -N "$SHOWROOM/stream/validate/module-02-model"

# Run solve
curl -sk -N "$SHOWROOM/stream/solve/module-02-model"

# Validate again — should pass
curl -sk -N "$SHOWROOM/stream/validate/module-02-model"
```

Expected pattern on a fresh lab:
- Modules checking **infrastructure** (model reachable, MCP servers up) → pass immediately
- Modules checking **student state** (API token exists, config.yaml written) → fail until solved

If the runner hangs (zombie ansible process from previous failed run):
```bash
oc delete pod -n showroom-<user> <pod-name>   # fresh pod clears stuck processes
```

---

## Critical Rules

1. **Plan first** — show full plan, get Y before doing anything
2. **Read AgV catalog AND dev.yaml** — dev.yaml overrides common.yaml silently
3. **Live cluster inspection before generating** — never invent service hostnames
4. **Never ask for passwords** — `oc login` then "tell me you've logged in"; tokens only
5. **`student_user: "{{ user | default('') }}"` in every playbook vars**
6. **`kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"` on every kubernetes.core task**
7. **`validate_certs: false` on all internal HTTPS calls**
8. **`ignore_errors: true` on all service checks**
9. **`check:` reflects real results — never `"true"`**
10. **`kubernetes.core.k8s_exec` command must be a string, not a list**
11. **For NetworkPolicy-blocked services: exec into the pod, call localhost**
12. **ONE MODULE AT A TIME** — push, test, confirm before next
13. **Always screenshot Playwright on failure** for debugging

---

## Related Skills

- `/showroom:create-lab` — Create showroom content (run before this skill)
- `/agnosticv:catalog-builder` — Set up the AgV catalog
