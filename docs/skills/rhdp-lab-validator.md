---
layout: default
title: /ftl:rhdp-lab-validator
---

# /ftl:rhdp-lab-validator

<div class="reference-badge">🚀 RHDP ZT Lab Validator</div>

Generate `runtime-automation/module-N/{solve,validation,setup}.yml` playbooks for RHDP showroom labs using the Zero Touch (nookbag) grading system. Works for OCP tenant, OCP dedicated+bastion, RHEL VM+bastion, and AAP labs.

> **Different from `/ftl:lab-validator`** — that skill generates external FTL grader containers (`grade_lab`/`solve_lab`). This skill generates **inline runtime-automation playbooks** that run inside the showroom runner sidecar, powering the Solve/Validate buttons in the nookbag UI.

---

## Workflow Overview

<div class="ftl-workflow">

  <div class="ftl-row">
    <div class="ftl-node ftl-start">
      <span>▶ /ftl:rhdp-lab-validator</span>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 0</div>
      <div class="ftl-step-title">⚠️ AgV Prereqs Check</div>
      <div class="ftl-step-body">Confirm FTL workload roles are in the AgV catalog. <strong>Stop here if missing</strong> — show the correct snippet and wait.<br><br>
      OCP: <code>rhpds.ftl.ocp4_workload_runtime_automation_k8s</code><br>
      RHEL: <code>rhpds.ftl.vm_workload_runtime_automation</code><br><br>
      <em>Do NOT order the environment yet — showroom must be committed first.</em></div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 1</div>
      <div class="ftl-step-title">Read Showroom Repo (Mandatory)</div>
      <div class="ftl-step-body">All <code>.adoc</code> module pages + existing <code>runtime-automation/</code></div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 2</div>
      <div class="ftl-step-title">Read AgV Catalog (Optional)</div>
      <div class="ftl-step-body">Detect <code>config:</code>, <code>instances:</code>, namespace suffixes, node names, missing FTL roles</div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 3</div>
      <div class="ftl-step-title">Confirm Lab Type</div>
      <div class="ftl-step-body">OCP tenant / OCP dedicated+bastion / RHEL VM+bastion / AAP — module count, namespaces, nodes</div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <div class="ftl-row">
    <div class="ftl-node ftl-step ftl-generate">
      <div class="ftl-step-label">Step 3b — BEFORE ordering</div>
      <div class="ftl-step-title">Scaffold Showroom Repo</div>
      <div class="ftl-step-body">
        Generate <code>ui-config.yml</code> (zero-touch, module list, tabs) · Verify <code>site.yml</code> uses nookbag bundle v0.0.3 · Create <code>runtime-automation/module-N/</code> stub files · <strong>Commit + push</strong><br><br>
        Then: <em>"Now order from integration.demo.redhat.com — share GUID when ready"</em>
      </div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 4 — while env provisions</div>
      <div class="ftl-step-title">Gather Existing Scripts</div>
      <div class="ftl-step-body">Bash scripts / Jinja2 templates / FTL playbooks / curl commands — module by module.<br>Will wrap into ZT pattern. For modules with nothing → generate from Step 5 questions.</div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 5</div>
      <div class="ftl-step-title">Per-Module Task Questions</div>
      <div class="ftl-step-body">For modules without existing scripts — what tasks, where (namespace / bastion / node / AAP), what to verify per task</div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 6</div>
      <div class="ftl-step-title">Env Ready → Connect → Generate</div>
      <div class="ftl-step-body">
        <strong>OCP:</strong> <code>oc login &lt;api&gt; --username admin --password &lt;pw&gt;</code> → Claude verifies zt-runner SA, kubeconfig Secret, RoleBindings<br><br>
        <strong>RHEL:</strong> share bastion SSH credentials → Claude SSHes to verify SSH config, runner logs<br><br>
        Then generate <code>solve.yml</code> + <code>validation.yml</code> for module 1 (replacing stubs)
      </div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 7 — repeat per module</div>
      <div class="ftl-step-title">Test with curl</div>
      <div class="ftl-step-body">
        <strong>OCP (from laptop):</strong> <code>curl -sk https://&lt;showroom&gt;/runner/api/module-N/solve</code><br>
        <strong>RHEL (from bastion):</strong> <code>curl -s http://localhost:8501/api/module-N/solve</code><br><br>
        Paste result → Claude debugs inline → repeat until all modules pass ✅
      </div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <div class="ftl-row">
    <div class="ftl-node ftl-end">
      <span>✅ All Modules Generated &amp; Tested</span>
    </div>
  </div>

</div>

<style>
.ftl-workflow { font-family:'Red Hat Text',sans-serif; max-width:700px; margin:2rem auto; display:flex; flex-direction:column; align-items:center; }
.ftl-row { width:100%; display:flex; justify-content:center; }
.ftl-node { border-radius:10px; padding:1rem 1.25rem; width:100%; max-width:520px; box-sizing:border-box; }
.ftl-start,.ftl-end { background:linear-gradient(135deg,#151515,#2d0000); color:white; text-align:center; font-weight:700; font-size:1rem; border-radius:99px; padding:.75rem 2rem; max-width:320px; border:2px solid rgba(238,0,0,.4); }
.ftl-end { background:linear-gradient(135deg,#1a3a1a,#0d1f0d); border-color:rgba(62,134,53,.4); }
.ftl-step { background:var(--color-bg); border:1.5px solid var(--color-border); border-left:4px solid #EE0000; }
.ftl-step.ftl-generate { border-left-color:#3E8635; background:var(--color-green-light,#f3faf2); }
.ftl-step-label { font-size:.6875rem; font-weight:700; text-transform:uppercase; letter-spacing:.07em; color:#EE0000; margin-bottom:.25rem; }
.ftl-step-title { font-weight:700; font-size:.9375rem; color:var(--color-text,#151515); margin-bottom:.375rem; }
.ftl-step-body { font-size:.8125rem; color:var(--color-text-3,#6a6e73); line-height:1.5; }
.ftl-step-body code { background:rgba(0,0,0,.06); padding:.1em .4em; border-radius:3px; font-size:.75rem; }
.ftl-arrow { font-size:1.5rem; color:var(--color-text-3,#6a6e73); line-height:1.8; text-align:center; }
</style>

---

## Lab Types Supported

<table>
<thead><tr><th>Lab Type</th><th>Config</th><th>Validation Pattern</th><th>Key Extravar</th></tr></thead>
<tbody>
<tr><td><strong>OCP Tenant</strong></td><td><code>config: namespace</code></td><td><code>kubernetes.core.k8s_info</code> in student namespace</td><td><code>student_ns</code>, <code>k8s_kubeconfig</code></td></tr>
<tr><td><strong>OCP Dedicated</strong></td><td><code>config: openshift-workloads</code></td><td>k8s admin + bastion bash script + <code>oc --as developer</code></td><td><code>bastion_host</code>, <code>k8s_kubeconfig</code></td></tr>
<tr><td><strong>RHEL VM + Bastion</strong></td><td><code>config: cloud-vms-base</code></td><td>SSH via <code>/app/.ssh/config</code> to bastion + nodes</td><td><code>bastion_host</code>, <code>bastion_port</code></td></tr>
<tr><td><strong>AAP</strong></td><td>any</td><td><code>ansible.builtin.uri</code> against AAP Controller API</td><td><code>aap_controller_url</code>, <code>aap_token</code></td></tr>
</tbody>
</table>

---

## What It Creates

```
runtime-automation/
├── module-01/
│   ├── setup.yml       # debug stub
│   ├── solve.yml       # creates resources / runs scripts
│   └── validation.yml  # ✅/❌ per-task output
├── module-02/
│   ├── solve-module2.sh     # bash script (if applicable)
│   ├── validate-module2.sh  # bash script (if applicable)
│   └── ...
```

Plus `ui-config.yml` snippet and AgV workload vars snippet.

---

## Handling Existing Scripts

When developers already have bash scripts (like `.sh` or `.sh.j2` from Ansible roles), the skill wraps them automatically:

**Scripts in the showroom repo** → `ansible.builtin.script` (copies to bastion + runs):
```yaml
- ansible.builtin.script:
    executable: /bin/bash
    cmd: "{{ playbook_dir }}/solve-module1.sh"
```

**Scripts already on the bastion** → `ansible.builtin.shell` (runs in-place):
```yaml
- ansible.builtin.shell: /home/lab-user/scripts/solve-module1.sh
```

The skill reads the solve script content to generate a matching `validation.yml` automatically.

---

## Tips: Getting the Most from This Skill

- **`/rename` your session** — provisioning takes 15-60 min. Rename with `/rename ZT grading — my-lab` and resume anytime.
- **`oc login` as admin** — Claude can then inspect namespaces, check zt-runner SA, read pod logs directly.
- **Share bastion SSH** upfront (RHEL labs) — Claude SSHes to check runner logs and curl jobs without copy-paste.
- **Paste failing job output** — Claude diagnoses and fixes inline.

---

## Related Skills

<div class="links-grid">
  <a href="create-lab.html" class="link-card">
    <h4>/showroom:create-lab</h4>
    <p>Create showroom content first, then add grading</p>
  </a>
  <a href="ftl.html" class="link-card">
    <h4>/ftl:lab-validator</h4>
    <p>External FTL grader containers (grade_lab/solve_lab pattern)</p>
  </a>
  <a href="agnosticv-catalog-builder.html" class="link-card">
    <h4>/agnosticv:catalog-builder</h4>
    <p>Set up the AgV catalog with FTL workload roles</p>
  </a>
</div>

<div class="navigation-footer">
  <a href="index.html" class="nav-button">← Back to Skills</a>
  <a href="ftl.html" class="nav-button">See also: /ftl:lab-validator →</a>
</div>
