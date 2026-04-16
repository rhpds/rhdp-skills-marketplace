---
name: ftl:solve-writer
description: Writes solve.yml playbooks from the structured task report produced by ftl:content-reader. Uses the automation priority ladder (k8s_exec → k8s → uri → wait_for → Playwright) to generate Ansible tasks that replicate what the student does in the lab.
version: 1.0.0
context: main
model: claude-sonnet-4-6
---

# ftl:solve-writer — Ansible Solve Playbook Generator

Receives the structured task report from `ftl:content-reader` and writes `solve.yml` — an Ansible playbook that automates what the student does in the lab.

**Self-contained. No ECC dependency.**

---

## What You Receive

- `CONTENT_REPORT` — structured task report from content-reader
- `LAB_TYPE` — `ocp-tenant` | `ocp-dedicated` | `vm-rhel`
- `REFERENCE_FILE` — path to `references/<lab_type>.md` with cluster context

---

## Step 1 — Read Reference Context

Read `references/<lab_type>.md` for:
- Namespace patterns (e.g., `user-{{ guid }}-mta`, `wksp-{{ user }}`)
- Internal service URLs (e.g., `mta-hub.{{ student_user }}-mta.svc.cluster.local:8080`)
- Known NetworkPolicy restrictions
- Available extravars (`user`, `guid`, `password`, `litellm_virtual_key`, etc.)

---

## Step 2 — Generate solve.yml

### Standard header (always)
```yaml
---
- name: <Module Title> Solve
  hosts: localhost
  connection: local
  gather_facts: false
  vars:
    student_user: "{{ user | default('') }}"
    # add service URLs and namespace vars from reference
  tasks:
```

### Task generation per classification

**k8s** — create/update resource:
```yaml
- name: <description>
  kubernetes.core.k8s:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    state: present
    definition: <manifest>
  ignore_errors: true
```

**k8s-check** — verify resource exists:
```yaml
- name: <description>
  kubernetes.core.k8s_info:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    kind: <Kind>
    namespace: <namespace>
    label_selectors:
      - "app=<name>"
  register: r_<name>
  ignore_errors: true
```

**exec-into-pod** — call service at localhost (bypasses NetworkPolicy):
```yaml
- name: Find <service> pod
  kubernetes.core.k8s_info:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    kind: Pod
    namespace: "{{ mta_namespace }}"
    label_selectors:
      - "role=mta-hub"
  register: r_pods
  ignore_errors: true

- name: Set pod name
  ansible.builtin.set_fact:
    target_pod: "{{ (r_pods.resources | selectattr('status.phase', 'equalto', 'Running') | list | first).metadata.name }}"
  when: r_pods.resources | default([]) | selectattr('status.phase', 'equalto', 'Running') | list | length > 0

- name: <description>
  kubernetes.core.k8s_exec:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    namespace: "{{ mta_namespace }}"
    pod: "{{ target_pod }}"
    command: "sh -c 'curl -s http://localhost:8080/...'"
  when: target_pod is defined
  ignore_errors: true
```

**shell-workspace** — exec into DevSpaces workspace pod:
```yaml
- name: Find workspace pod
  kubernetes.core.k8s_info:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    kind: Pod
    namespace: "{{ student_user }}-devworkspace"
  register: r_workspace
  ignore_errors: true

- name: Set workspace pod
  ansible.builtin.set_fact:
    workspace_pod: "{{ (r_workspace.resources | selectattr('status.phase', 'equalto', 'Running') | list | first).metadata.name }}"
  when: r_workspace.resources | default([]) | selectattr('status.phase', 'equalto', 'Running') | list | length > 0

- name: <description>
  kubernetes.core.k8s_exec:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    namespace: "{{ student_user }}-devworkspace"
    pod: "{{ workspace_pod }}"
    command: "sh -c '<command>'"
  when: workspace_pod is defined
  ignore_errors: true
```

**Write file into workspace pod** — always use base64 to avoid quoting hell:
```yaml
- name: Build file content
  ansible.builtin.set_fact:
    file_content: |
      key: "{{ value }}"
  when: value | length > 0

- name: Write file to workspace
  kubernetes.core.k8s_exec:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    namespace: "{{ student_user }}-devworkspace"
    pod: "{{ workspace_pod }}"
    command: "python3 -c \"import base64,os; os.makedirs('/path/to/dir',exist_ok=True); open('/path/to/file','w').write(base64.b64decode('{{ file_content | b64encode }}').decode()); print('written')\""
  when:
    - workspace_pod is defined
    - file_content is defined
  ignore_errors: true
```

**oc-cli** — use oc binary with kubeconfig:
```yaml
- name: <description>
  kubernetes.core.k8s_exec:
    kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"
    namespace: "{{ student_user }}-devworkspace"
    pod: "{{ workspace_pod }}"
    command: "sh -c 'oc login --server={{ openshift_api_url }} --username={{ student_user }} --password={{ password }} --insecure-skip-tls-verify=true && oc project {{ student_user }}-coolstore && echo logged-in'"
  when: workspace_pod is defined
  ignore_errors: true
```

**api** — REST call:
```yaml
- name: <description>
  ansible.builtin.uri:
    url: "{{ service_url }}/endpoint"
    method: POST
    headers:
      Content-Type: application/json
    body_format: json
    body:
      key: "{{ value }}"
    validate_certs: false
    timeout: 30
    status_code: [200, 201]
  register: r_result
  ignore_errors: true
```

**tcp-check** — wait for port:
```yaml
- name: Check <service> reachable
  ansible.builtin.wait_for:
    host: "<service>.<namespace>.svc.cluster.local"
    port: <port>
    timeout: 5
  register: r_check
  ignore_errors: true
```

**ui-playwright** — browser automation (last resort):
```yaml
- name: <description> (Playwright — no API equivalent)
  ansible.builtin.script:
    executable: node
    cmd: "{{ playbook_dir }}/playwright/<script-name>.js"
  environment:
    TARGET_URL: "https://<service>.{{ openshift_cluster_ingress_domain }}"
    USERNAME: "{{ student_user }}"
    PASSWORD: "{{ password | default('') }}"
    PLAYWRIGHT_BROWSERS_PATH: /app/.playwright
  register: r_playwright
  ignore_errors: true
```

### Playwright script pattern — intent-based, self-healing

**Do NOT hardcode selectors.** Use intent descriptions so vision can recover when UI changes.

```javascript
// runtime-automation/module-XX/playwright/step-N-<description>.js
//
// INTENT: <what the student does — semantic description not a selector>
// Example: "Click the button that opens the playground for the selected MCP servers"
//
// EVIDENCE: saves screenshot to /tmp/evidence/step-N-<description>.png
// FAILURE:  saves debug screenshot to /tmp/playwright-debug.png

const { chromium } = require('playwright');

const TARGET_URL = process.env.TARGET_URL;
const USERNAME   = process.env.USERNAME;
const PASSWORD   = process.env.PASSWORD;

// INTENT constants — describe WHAT not HOW
// These are used for self-healing: if a selector breaks, vision reads the
// intent + current screenshot to find the element in the new UI.
const INTENT = {
  step: "Click the button that opens the playground for the selected MCP servers",
  context: "RHOAI Gen AI Studio — AI asset endpoints — MCP servers tab"
};

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

  // Create evidence directory
  const fs = require('fs');
  fs.mkdirSync('/tmp/evidence', { recursive: true });

  try {
    // Login
    await page.goto(TARGET_URL, { waitUntil: 'domcontentloaded', timeout: 30000 });
    // ... login steps ...

    // Screenshot before action (for drift detection baseline)
    await page.screenshot({ path: '/tmp/evidence/step-N-before.png' });

    // Action — use flexible selectors, not exact text
    // Primary selector (current UI):
    const btn = page.getByRole('button', { name: /Try in Playground/i });
    await btn.waitFor({ state: 'visible', timeout: 10000 });
    await btn.click();

    // Screenshot after action (evidence)
    await page.screenshot({ path: '/tmp/evidence/step-N-<description>.png' });

    console.log('SUCCESS: <what was completed>');
    process.exit(0);
  } catch (err) {
    // Save debug screenshot for self-healing / vision analysis
    await page.screenshot({ path: '/tmp/playwright-debug.png' }).catch(() => {});
    console.error('FAILED:', err.message);
    console.error('INTENT:', INTENT.step);
    console.error('CONTEXT:', INTENT.context);
    process.exit(1);
  } finally {
    await browser.close();
  }
})();
```

**Key rules for self-healing Playwright scripts:**
- Always save `/tmp/evidence/step-N-before.png` before the action (drift baseline)
- Always save `/tmp/evidence/step-N-<desc>.png` after success (evidence)
- Always save `/tmp/playwright-debug.png` on failure (for vision analysis)
- Log `INTENT:` and `CONTEXT:` on failure (helps vision find element in new UI)
- Use `getByRole` with regex over exact text matches — more resilient to minor wording changes
- OCP/Keycloak login: detect RHBK vs htpasswd — don't assume one provider

**skip** — document why not automated:
```yaml
# SKIP: <reason>
# Student step: <description>
# Not automatable: <explanation>
```

### Always end with a Report task
```yaml
- name: Report solve status
  ansible.builtin.debug:
    msg: |
      <service 1>: {{ 'ok' if <condition> else 'NOT ok' }}
      <service 2>: {{ 'ok' if <condition> else 'NOT ok' }}
```

---

## Step 3 — Critical Rules

1. **k8s_exec command = string not list** — `command: "sh -c '...'"` not `command: [sh, -c, ...]`
2. **`kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"`** on every `kubernetes.core.*` task
3. **`validate_certs: false`** on all internal HTTPS calls
4. **`ignore_errors: true`** on all service checks
5. **Check if file/resource already exists** before creating — solvers run multiple times
6. **`status_code: [200, 201]`** for POST calls (201 = Created)
7. **No manual step guidance** in debug output — only report check results
8. **For async ops** (MTA analysis, S2I builds): trigger and exit immediately. Note in report: "come back in a few minutes and click Validate"
9. **MTA API** requires `addon: "analyzer"` field in task payload — hub ignores tasks without it

---

## Step 4 — Output

Return:
1. Full `solve.yml` content
2. `SOLVE_ACTIONS` — structured summary of what the solver does (passed to validate-writer).
   Use structured format so validate-writer can derive checks directly:
```
SOLVE_ACTIONS:
  task-1:
    action: "Generated MaaS API token for {{ student_user }}"
    check: "API returns token list for {{ student_user }}"
    async: false
  task-2:
    action: "Wrote config.yaml to DevSpaces workspace"
    check: "File exists at expected path in workspace pod"
    async: false
  task-3:
    action: "Installed Continue extension via Open VSX VSIX"
    check: "Extension directory exists in /checode/.../extensions/"
    async: false
  task-4:
    action: "Triggered MTA analysis"
    check: "Any analyzer task with addon=analyzer in Succeeded state"
    async: true
    async_msg: "Analysis still running — come back in a few minutes and click Validate again"
```
