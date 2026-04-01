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

  <!-- Start -->
  <div class="ftl-row">
    <div class="ftl-node ftl-start"><span>▶ /ftl:rhdp-lab-validator</span></div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <!-- Step 0 -->
  <div class="ftl-row">
    <div class="ftl-node ftl-stop">
      <div class="ftl-step-label">Step 0 — Gate</div>
      <div class="ftl-step-title">⚠️ AgV Prereqs Check</div>
      <div class="ftl-step-body">
        Confirm FTL workload roles are in the AgV catalog. <strong>Stop if missing — show snippet, wait.</strong><br><br>
        OCP: <code>rhpds.ftl.ocp4_workload_runtime_automation_k8s</code><br>
        RHEL: <code>rhpds.ftl.vm_workload_runtime_automation</code><br><br>
        ✅ Only proceed when AgV is confirmed ready.
      </div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <!-- Steps 1+2 -->
  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Steps 1 + 2</div>
      <div class="ftl-step-title">Read Content</div>
      <div class="ftl-step-body">
        <strong>Showroom repo (mandatory):</strong> all <code>.adoc</code> module pages + existing <code>runtime-automation/</code><br><br>
        <strong>AgV catalog (optional):</strong> detect <code>config:</code>, <code>instances:</code>, namespace suffixes, node names
      </div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <!-- Step 3 -->
  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 3 — Confirm</div>
      <div class="ftl-step-title">Lab Type Detection</div>
      <div class="ftl-step-body">
        Present detected type + confirm with developer:<br>
        <em>OCP tenant · OCP dedicated+bastion · RHEL VM+bastion · AAP</em><br><br>
        Module count · namespace patterns · node names
      </div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <!-- Step 3b -->
  <div class="ftl-row">
    <div class="ftl-node ftl-step ftl-generate">
      <div class="ftl-step-label">Step 3b — Before ordering ⬇</div>
      <div class="ftl-step-title">Scaffold Showroom Repo</div>
      <div class="ftl-step-body">
        <strong>Generate:</strong> <code>ui-config.yml</code> (type: zero-touch, module list, correct tabs)<br>
        <strong>Verify:</strong> <code>site.yml</code> has nookbag bundle v0.0.3<br>
        <strong>Create:</strong> <code>runtime-automation/module-N/{setup,solve,validation}.yml</code> stubs<br>
        <strong>Commit + push →</strong> <em>then order environment from integration.demo.redhat.com</em>
      </div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <!-- Step 4 -->
  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 4 — While env provisions</div>
      <div class="ftl-step-title">Gather Existing Scripts</div>
      <div class="ftl-step-body">
        Share any existing <code>.sh</code> / <code>.sh.j2</code> / FTL playbooks — module by module.<br><br>
        <strong>Claude reads scripts and auto-generates matching validation tasks.</strong><br>
        <code>.sh.j2</code> → ask to strip Jinja2 to plain <code>.sh</code><br>
        Nothing exists → generate from scratch in Step 5
      </div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <!-- Step 5 -->
  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 5 — Auto-detect</div>
      <div class="ftl-step-title">Per-Module Analysis</div>
      <div class="ftl-step-body">
        For each module task — detect automatically from <code>.adoc</code> content and scripts:<br><br>
        <strong>✅ Automatable</strong> → generate ✅/❌ multi-task validation<br>
        <strong>⚠️ Manual</strong> (browser/GitHub/OAuth) → use warning pattern, never fail<br><br>
        Present findings per module, confirm before generating.
      </div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <!-- Step 6 -->
  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 6 — Required</div>
      <div class="ftl-step-title">Connect to Environment</div>
      <div class="ftl-step-body">
        <strong>OCP labs:</strong><br>
        <code>oc login &lt;api-url&gt; --username admin --insecure-skip-tls-verify</code><br>
        Claude verifies: zt-runner SA · kubeconfig Secret · RoleBindings · showroom-userdata CM<br><br>
        <strong>RHEL VM labs:</strong><br>
        Share bastion host / port / password<br>
        Claude SSHes: checks SSH config · node host entries · <code>curl localhost:8501/api/config</code>
      </div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <!-- Generate loop -->
  <div class="ftl-row">
    <div class="ftl-node ftl-step ftl-generate">
      <div class="ftl-step-label">Step 7 — ONE MODULE AT A TIME</div>
      <div class="ftl-step-title">Generate Module N</div>
      <div class="ftl-step-body">
        <strong>Focus entirely on Module N.</strong> Re-read its content. Generate:<br>
        <div class="ftl-files">
          <div class="ftl-file">solve.yml — creates resources / runs scripts</div>
          <div class="ftl-file">validation.yml — ✅/❌ per task (mandatory)</div>
          <div class="ftl-file">setup.yml — debug stub</div>
        </div>
        <strong>STOP.</strong> Give curl test commands. Wait for results.
      </div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <!-- Test -->
  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 8 — Test</div>
      <div class="ftl-step-title">curl → Paste → Debug</div>
      <div class="ftl-step-body">
        <strong>OCP (laptop):</strong> <code>curl -sk https://&lt;showroom&gt;/runner/api/module-N/solve</code><br>
        <strong>RHEL (bastion):</strong> <code>curl -s http://localhost:8501/api/module-N/solve</code><br><br>
        Paste result → Claude debugs inline → fix → re-test<br>
        ✅ Module N passes → proceed to Module N+1
      </div>
    </div>
  </div>

  <!-- Decision loop -->
  <div class="ftl-row ftl-decision-row">
    <div class="ftl-node ftl-decision">
      <div class="ftl-decision-text">More<br>modules?</div>
    </div>
  </div>

  <div class="ftl-row ftl-branches">
    <div class="ftl-branch-left">
      <div class="ftl-branch-label ftl-label-yes">YES</div>
      <div class="ftl-node ftl-variant">
        <div class="ftl-step-body">Return to Step 7 for next module.<br><strong>Never generate ahead.</strong></div>
      </div>
      <div class="ftl-loop-arrow">↑ back to Step 7</div>
    </div>
    <div class="ftl-branch-right">
      <div class="ftl-branch-label ftl-label-no" style="background:#f3faf2;color:#2a5f1e;">DONE</div>
      <div class="ftl-node ftl-variant">
        <div class="ftl-step-body">All modules generated and tested ✅</div>
      </div>
    </div>
  </div>
  <div class="ftl-row ftl-rejoin-arrow"><div class="ftl-arrow">↓</div></div>

  <!-- End -->
  <div class="ftl-row">
    <div class="ftl-node ftl-end"><span>✅ All Modules Generated &amp; Tested</span></div>
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
