---
layout: default
title: /ftl:lab-validator
---

# /ftl:lab-validator

<div class="reference-badge">🚀 RHDP ZT Lab Validator</div>

Write `solve.yml` and `validate.yml` Ansible playbooks for RHDP Showroom labs.
Reads your existing module exercises and generates working playbooks for the zt-runner sidecar
(Solve/Validate buttons and Demolition load testing at Summit).

---

## Before You Start

The skill opens with a pre-flight checklist. Make sure both are ready before running it:

<div class="preflight-grid">

  <div class="preflight-card">
    <div class="preflight-title">1 — Showroom Repo</div>
    <div class="preflight-body">
      Sync from <code>showroom_template_nookbag</code> <strong>e2e-template</strong> branch:<br><br>
      <code>content/supplemental-ui/js/buttons.js</code><br>
      <code>content/supplemental-ui/css/site-extra.css</code><br>
      <code>content/lib/inject-buttons.js</code><br>
      <code>content/lib/dev-mode.js</code><br>
      <code>runtime-automation/module-XX/solve.yml</code><br>
      <code>runtime-automation/module-XX/validate.yml</code><br><br>
      <code>site.yml</code> must have the extensions and supplemental_files block configured.<br><br>
      Add <strong>solve/validate button placeholders</strong> to each .adoc module.
    </div>
  </div>

  <div class="preflight-card">
    <div class="preflight-title">2 — AgV Catalog</div>
    <div class="preflight-body">
      <strong>All lab types:</strong><br>
      rhpds-ftl collection · showroom v1.6.6+ · zt-runner v2.4.2 · wetty v3.0<br><br>
      <strong>OCP tenant/dedicated:</strong><br>
      <code>ocp4_workload_runtime_automation_k8s</code> workload<br><br>
      <strong>RHEL VM:</strong><br>
      <code>vm_workload_runtime_automation</code> workload<br><br>
      See <code>examples/</code> in the e2e-template branch for exact common.yaml per lab type.
    </div>
  </div>

</div>

---

## Workflow

<div class="ftl-workflow">

  <div class="ftl-row">
    <div class="ftl-node ftl-start"><span>▶ /ftl:lab-validator</span></div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Pre-flight</div>
      <div class="ftl-step-title">Checklist Shown</div>
      <div class="ftl-step-body">
        Skill displays required showroom files, site.yml config, and AgV vars per lab type.<br>
        <strong>Sync your repo and AgV before continuing.</strong>
      </div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 1</div>
      <div class="ftl-step-title">Collect Inputs</div>
      <div class="ftl-step-body">
        <strong>Lab type:</strong> ocp-tenant · ocp-dedicated · vm-rhel<br>
        <strong>Showroom path:</strong> local path or GitHub URL<br>
        <strong>Access — OCP:</strong> admin token or <code>oc login</code> + restart Claude<br>
        <strong>Access — VM:</strong> SSH host, user, key path<br><br>
        ⚠️ Skill checks <code>dev.yaml</code> for a silent <code>content_git_repo_ref</code> override that kills branch changes.
      </div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 2</div>
      <div class="ftl-step-title">Discover Modules</div>
      <div class="ftl-step-body">
        Reads all <code>.adoc</code> files and identifies modules with exercises.<br>
        Shows a summary — you choose which modules to generate playbooks for.
      </div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <div class="ftl-row">
    <div class="ftl-node ftl-step ftl-generate">
      <div class="ftl-step-label">Step 3 — Per module</div>
      <div class="ftl-step-title">Generate solve.yml + validate.yml</div>
      <div class="ftl-step-body">
        Reads exercise content and generates both playbooks.<br>
        Previews files before writing. Uses the correct pattern for your lab type.<br><br>
        <strong>solve.yml</strong> — completes exercises on behalf of the student (must be idempotent)<br>
        <strong>validate.yml</strong> — checks outcomes with ✅/❌ per task using <code>validation_check</code>
      </div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 4</div>
      <div class="ftl-step-title">Push + Restart + Test</div>
      <div class="ftl-step-body">
        Commits and pushes playbooks, restarts the Showroom pod, then runs the full test cycle:<br><br>
        <code>1. Fresh validate</code> — should fail (student hasn't done the exercise)<br>
        <code>2. Solve</code><br>
        <code>3. Validate again</code> — should pass<br><br>
        Uses SSE stream endpoints: <code>/stream/solve/module-XX</code> · <code>/stream/validate/module-XX</code>
      </div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <div class="ftl-row">
    <div class="ftl-node ftl-step ftl-generate">
      <div class="ftl-step-label">Step 5 — If needed</div>
      <div class="ftl-step-title">Fix Loop</div>
      <div class="ftl-step-body">
        Stream error shown → targeted fix proposed → push → restart → re-test.<br>
        Repeats until all modules pass clean.
      </div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <div class="ftl-row">
    <div class="ftl-node ftl-end"><span>✅ All Modules Pass Solve + Validate</span></div>
  </div>

</div>

---

## Lab Types

<table>
<thead><tr><th>Lab Type</th><th>AgV config</th><th>Runner</th><th>Key extravars</th></tr></thead>
<tbody>
<tr><td><strong>OCP Tenant</strong></td><td><code>config: namespace</code></td><td>k8s sidecar pod, namespace-scoped SA</td><td><code>k8s_kubeconfig</code>, <code>student_ns</code>, <code>student_user</code>, <code>guid</code></td></tr>
<tr><td><strong>OCP Dedicated</strong></td><td><code>config: openshift-workloads</code></td><td>k8s sidecar pod, cluster-admin SA</td><td><code>k8s_kubeconfig</code>, <code>guid</code> (<code>student_ns</code> empty)</td></tr>
<tr><td><strong>RHEL VM</strong></td><td><code>config: cloud-vms-base</code></td><td>Podman container on bastion</td><td>SSH via <code>/app/.ssh/config</code>, host aliases: <code>node</code>, <code>bastion</code></td></tr>
</tbody>
</table>

---

## Key Patterns

<table>
<thead><tr><th>Pattern</th><th>Rule</th></tr></thead>
<tbody>
<tr><td><strong>Always pass kubeconfig</strong></td><td>Plain <code>oc</code> uses showroom SA (no access). Always use <code>oc --kubeconfig={{ k8s_kubeconfig }}</code> or <code>kubeconfig: "{{ k8s_kubeconfig | default(omit) }}"</code></td></tr>
<tr><td><strong>k8s_exec command</strong></td><td>Must be a string, not a list. Kubernetes treats a list as the executable name and fails silently.</td></tr>
<tr><td><strong>NetworkPolicy bypass</strong></td><td>Use <code>k8s_exec</code> into the target pod and call <code>localhost</code> — avoids cross-namespace blocks.</td></tr>
<tr><td><strong>Idempotency</strong></td><td>Solve runs every time a student retries. Guard every create operation.</td></tr>
<tr><td><strong>Async operations</strong></td><td>Trigger and exit. Validate uses <code>any()</code> not <code>max()</code> to detect completion.</td></tr>
<tr><td><strong>Check durable outcomes</strong></td><td>Validate persistent state (file exists, resource created) — not transient state (branch name, pod restarts).</td></tr>
<tr><td><strong>JSON in k8s_exec</strong></td><td>Parse via <code>python3 -c "import json,sys..."</code> — Ansible's <code>from_json</code> fails if stdout has deprecation warnings.</td></tr>
<tr><td><strong>regex_search | first</strong></td><td>Returns <code>None</code> on no match. <code>None | first</code> crashes. Use separate tasks instead.</td></tr>
<tr><td><strong>dev.yaml override</strong></td><td>Check for <code>content_git_repo_ref</code> in dev.yaml — it silently overrides common.yaml and clones the wrong branch.</td></tr>
</tbody>
</table>

---

## Related Skills

<div class="links-grid">
  <a href="create-lab.html" class="link-card">
    <h4>/showroom:create-lab</h4>
    <p>Create showroom content first, then add E2E grading</p>
  </a>
  <a href="agnosticv-validator.html" class="link-card">
    <h4>/agnosticv:validator</h4>
    <p>Validate the AgV catalog before provisioning</p>
  </a>
  <a href="agnosticv-catalog-builder.html" class="link-card">
    <h4>/agnosticv:catalog-builder</h4>
    <p>Set up the AgV catalog with FTL workload roles</p>
  </a>
</div>

<div class="navigation-footer">
  <a href="index.html" class="nav-button">← Back to Skills</a>
</div>

<style>
.preflight-grid { display:grid; grid-template-columns:1fr 1fr; gap:1.25rem; margin:1.5rem 0 2rem; }
@media(max-width:640px){ .preflight-grid { grid-template-columns:1fr; } }
.preflight-card { border:1.5px solid var(--color-border,#d2d2d2); border-left:4px solid #EE0000; border-radius:8px; padding:1rem 1.25rem; }
.preflight-title { font-weight:700; font-size:.9375rem; margin-bottom:.5rem; }
.preflight-body { font-size:.8125rem; color:var(--color-text-3,#6a6e73); line-height:1.6; }
.preflight-body code { background:rgba(0,0,0,.06); padding:.1em .4em; border-radius:3px; font-size:.75rem; }

.ftl-workflow { font-family:'Red Hat Text',sans-serif; max-width:700px; margin:2rem auto; display:flex; flex-direction:column; align-items:center; }
.ftl-row { width:100%; display:flex; justify-content:center; }
.ftl-node { border-radius:10px; padding:1rem 1.25rem; width:100%; max-width:520px; box-sizing:border-box; }
.ftl-start,.ftl-end { background:linear-gradient(135deg,#151515,#2d0000); color:white; text-align:center; font-weight:700; font-size:1rem; border-radius:99px; padding:.75rem 2rem; max-width:320px; border:2px solid rgba(238,0,0,.4); }
.ftl-end { background:linear-gradient(135deg,#1a3a1a,#0d1f0d); border-color:rgba(62,134,53,.4); }
.ftl-step { background:var(--color-bg,#fff); border:1.5px solid var(--color-border,#d2d2d2); border-left:4px solid #EE0000; }
.ftl-step.ftl-generate { border-left-color:#3E8635; background:var(--color-green-light,#f3faf2); }
.ftl-step-label { font-size:.6875rem; font-weight:700; text-transform:uppercase; letter-spacing:.07em; color:#EE0000; margin-bottom:.25rem; }
.ftl-step-title { font-weight:700; font-size:.9375rem; color:var(--color-text,#151515); margin-bottom:.375rem; }
.ftl-step-body { font-size:.8125rem; color:var(--color-text-3,#6a6e73); line-height:1.5; }
.ftl-step-body code { background:rgba(0,0,0,.06); padding:.1em .4em; border-radius:3px; font-size:.75rem; }
.ftl-arrow { font-size:1.5rem; color:var(--color-text-3,#6a6e73); line-height:1.8; text-align:center; }
</style>
