---
layout: default
title: /ftl:lab-validator
---

# /ftl:lab-validator

<div class="reference-badge">🧪 FTL Lab Validator</div>

Generate production-quality FTL (Full Test Lifecycle) grader and solver playbooks for a Showroom workshop by analyzing module content. The skill reads your `.adoc` module files and AgnosticV catalog, identifies student exercises and checkpoints, and generates complete Ansible playbooks following all FTL framework conventions.

---

## Workflow Overview

<div class="ftl-workflow">

  <!-- Row 1: Start -->
  <div class="ftl-row">
    <div class="ftl-node ftl-start">
      <span>▶ /ftl:lab-validator</span>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <!-- Step 0.5 -->
  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 0.5</div>
      <div class="ftl-step-title">Read Lab Content</div>
      <div class="ftl-step-body">Ask for Showroom repo URL or path → clone/read ALL .adoc files → ask for AgV catalog (optional) → present detected lab type, user model, pre-deployed components</div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <!-- Decision: running env? -->
  <div class="ftl-row ftl-decision-row">
    <div class="ftl-node ftl-decision">
      <div class="ftl-decision-text">Running lab<br>environment?</div>
    </div>
  </div>

  <!-- NO branch -->
  <div class="ftl-row ftl-branches">
    <div class="ftl-branch-left">
      <div class="ftl-branch-label ftl-label-no">NO</div>
      <div class="ftl-node ftl-stop">
        <div class="ftl-step-title">⛔ Hard Stop</div>
        <div class="ftl-step-body">Order a lab from demo.redhat.com. Come back when provisioned (~15–60 min). No placeholder generation.</div>
      </div>
    </div>
    <div class="ftl-branch-right">
      <div class="ftl-branch-label ftl-label-yes">YES</div>
      <div class="ftl-node ftl-step">
        <div class="ftl-step-title">Environment Discovery</div>
        <div class="ftl-step-body">OCP labs: ask laptop oc or bastion SSH → give exact commands to run → paste real namespace names, ConfigMap credentials, running pods back</div>
      </div>
    </div>
  </div>
  <div class="ftl-row ftl-rejoin-arrow"><div class="ftl-arrow">↓</div></div>

  <!-- Step 1 -->
  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 1</div>
      <div class="ftl-step-title">Locate FTL Repository</div>
      <div class="ftl-step-body">Auto-detect from <code>~/CLAUDE.md</code> → check common paths (<code>~/work/code/experiment/ftl</code>) → ask if not found. Read <code>roles/</code> catalog + bundled examples.</div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <!-- Step 1.5 -->
  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 1.5</div>
      <div class="ftl-step-title">Process AgV Catalog</div>
      <div class="ftl-step-body">Read <code>common.yaml</code> → determine OCP vs RHEL/VM → extract workloads, <code>num_users</code>, namespace patterns, service URLs, <code>agnosticd_user_info</code> keys. Confirm with developer.</div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <!-- Step 2 -->
  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 2</div>
      <div class="ftl-step-title">Analyze Workshop Content</div>
      <div class="ftl-step-body">Extract exact namespace names from <code>oc new-project</code> / <code>-n &lt;ns&gt;</code> commands. Classify every service as <strong>shared</strong> (admin credentials) or <strong>per-user</strong> (student credentials). Confirm.</div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <!-- Step 3 -->
  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 3</div>
      <div class="ftl-step-title">Determine Lab Configuration</div>
      <div class="ftl-step-body">Auto-detect lab short name from AgV path → confirm. Set env vars needed: <code>OPENSHIFT_CLUSTER_INGRESS_DOMAIN</code>, <code>PASSWORD</code>, Gitea/AAP creds if shared services found.</div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <!-- Step 4 -->
  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 4</div>
      <div class="ftl-step-title">Checkpoint Analysis</div>
      <div class="ftl-step-body">List every checkpoint with source tag (<strong>Pre-configured</strong> = deployed by AgnosticD / <strong>Student action</strong> = student must do this) and mapped grader role. Wait for confirmation.</div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <!-- Decision: Module 1 type -->
  <div class="ftl-row ftl-decision-row">
    <div class="ftl-node ftl-decision">
      <div class="ftl-decision-text">Module 1<br>classification?</div>
    </div>
  </div>

  <!-- Module 1 three branches -->
  <div class="ftl-row ftl-three-branches">
    <div class="ftl-branch-third">
      <div class="ftl-branch-label ftl-label-setup">SETUP / INTRO</div>
      <div class="ftl-node ftl-variant">
        <div class="ftl-step-body">All pre-configured. <code>grade_e2e_readiness.yml</code> already covers this. <strong>Skip</strong> grade/solve_module_01.yml</div>
      </div>
    </div>
    <div class="ftl-branch-third">
      <div class="ftl-branch-label ftl-label-mixed">MIXED</div>
      <div class="ftl-node ftl-variant">
        <div class="ftl-step-body">Some pre-configured + student actions. Generate grade/solve_module_01.yml for <strong>student actions only</strong></div>
      </div>
    </div>
    <div class="ftl-branch-third">
      <div class="ftl-branch-label ftl-label-exercise">EXERCISE</div>
      <div class="ftl-node ftl-variant">
        <div class="ftl-step-body">All student actions. Generate full grade/solve_module_01.yml for <strong>all checkpoints</strong></div>
      </div>
    </div>
  </div>
  <div class="ftl-row ftl-rejoin-arrow"><div class="ftl-arrow">↓</div></div>

  <!-- Step 5 -->
  <div class="ftl-row">
    <div class="ftl-node ftl-step ftl-generate">
      <div class="ftl-step-label">Step 5 — Module 1 only</div>
      <div class="ftl-step-title">Generate Files</div>
      <div class="ftl-files">
        <div class="ftl-file ftl-file-always">grade_e2e_readiness.yml <span class="ftl-tag">always first</span></div>
        <div class="ftl-file">lab.yml</div>
        <div class="ftl-file">grade_module_01.yml</div>
        <div class="ftl-file">solve_module_01.yml</div>
        <div class="ftl-file">README.md</div>
      </div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <!-- Step 6: Test loop -->
  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 6A</div>
      <div class="ftl-step-title">Test Locally — no git push</div>
      <div class="ftl-step-body"><code>bash bin/grade_lab &lt;lab&gt; &lt;user&gt; 1 --podman --local</code><br>Pre-configured → PASS &nbsp;|&nbsp; Student actions → FAIL (expected)</div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 6B</div>
      <div class="ftl-step-title">Run Solver → Grade Again</div>
      <div class="ftl-step-body"><code>bash bin/solve_lab &lt;lab&gt; &lt;user&gt; 1 --podman --local</code><br><code>bash bin/grade_lab &lt;lab&gt; &lt;user&gt; 1 --podman --local</code><br>Expect: all PASS</div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 6C</div>
      <div class="ftl-step-title">Push &amp; Test from GitHub</div>
      <div class="ftl-step-body"><code>git push</code> → <code>bash bin/grade_lab &lt;lab&gt; &lt;user&gt; 1 --podman</code><br>Production test — pulls from GitHub, same as final grader</div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <div class="ftl-row">
    <div class="ftl-node ftl-step">
      <div class="ftl-step-label">Step 6D</div>
      <div class="ftl-step-title">Load Test All Users</div>
      <div class="ftl-step-body"><code>bash bin/grade_lab &lt;lab&gt; all 1 --podman</code><br>All users run in parallel — auto-discovered from showroom namespaces</div>
    </div>
  </div>
  <div class="ftl-row"><div class="ftl-arrow">↓</div></div>

  <!-- Decision: module 1 passes? -->
  <div class="ftl-row ftl-decision-row">
    <div class="ftl-node ftl-decision">
      <div class="ftl-decision-text">Module 1<br>passes?</div>
    </div>
  </div>

  <div class="ftl-row ftl-branches">
    <div class="ftl-branch-left">
      <div class="ftl-branch-label ftl-label-no">NO</div>
      <div class="ftl-node ftl-step">
        <div class="ftl-step-title">Debug &amp; Fix</div>
        <div class="ftl-step-body">Report unexpected results. Fix namespace patterns, credential approach, or solver steps. Edit files, re-run with <code>--local</code> — no git push needed.</div>
      </div>
      <div class="ftl-loop-arrow">↑ back to Step 6A</div>
    </div>
    <div class="ftl-branch-right">
      <div class="ftl-branch-label ftl-label-yes">YES</div>
      <div class="ftl-node ftl-step">
        <div class="ftl-step-title">Generate Module 2</div>
        <div class="ftl-step-body">Repeat Steps 4–6 for each subsequent module. One module at a time — never all at once.</div>
      </div>
    </div>
  </div>
  <div class="ftl-row ftl-rejoin-arrow"><div class="ftl-arrow">↓</div></div>

  <!-- Done -->
  <div class="ftl-row">
    <div class="ftl-node ftl-end">
      <span>✅ All Modules Generated &amp; Tested</span>
    </div>
  </div>

</div>

<style>
/* ── FTL Workflow Diagram ──────────────────────────────────── */
.ftl-workflow {
  font-family: 'Red Hat Text', sans-serif;
  max-width: 700px;
  margin: 2rem auto;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0;
}

.ftl-row {
  width: 100%;
  display: flex;
  justify-content: center;
}

/* Nodes */
.ftl-node {
  border-radius: 10px;
  padding: 1rem 1.25rem;
  width: 100%;
  max-width: 520px;
  box-sizing: border-box;
}

.ftl-start, .ftl-end {
  background: linear-gradient(135deg, #151515 0%, #2d0000 100%);
  color: white;
  text-align: center;
  font-weight: 700;
  font-size: 1rem;
  border-radius: 99px;
  padding: 0.75rem 2rem;
  max-width: 320px;
  border: 2px solid rgba(238,0,0,0.4);
}

.ftl-end {
  background: linear-gradient(135deg, #1a3a1a 0%, #0d1f0d 100%);
  border-color: rgba(62,134,53,0.4);
}

.ftl-step {
  background: var(--color-bg);
  border: 1.5px solid var(--color-border);
  border-left: 4px solid #EE0000;
}

.ftl-step.ftl-generate {
  border-left-color: #3E8635;
  background: var(--color-green-light, #f3faf2);
}

.ftl-stop {
  background: #fff5f5;
  border: 1.5px solid rgba(238,0,0,0.25);
  border-left: 4px solid #EE0000;
}

.ftl-variant {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  font-size: 0.875rem;
}

.ftl-decision {
  background: linear-gradient(135deg, #0f0f0f 0%, #1a1a1a 100%);
  color: white;
  border-radius: 50%;
  width: 110px;
  height: 110px;
  max-width: 110px;
  min-width: 110px;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  border: 3px solid #EE0000;
  padding: 0;
}

.ftl-decision-text {
  font-weight: 700;
  font-size: 0.8125rem;
  line-height: 1.35;
}

/* Step parts */
.ftl-step-label {
  font-size: 0.6875rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.07em;
  color: #EE0000;
  margin-bottom: 0.25rem;
}

.ftl-step-title {
  font-weight: 700;
  font-size: 0.9375rem;
  color: var(--color-text, #151515);
  margin-bottom: 0.375rem;
}

.ftl-stop .ftl-step-title { color: #8A0000; }

.ftl-step-body {
  font-size: 0.8125rem;
  color: var(--color-text-3, #6a6e73);
  line-height: 1.5;
}

.ftl-step-body code {
  background: rgba(0,0,0,0.06);
  padding: 0.1em 0.4em;
  border-radius: 3px;
  font-size: 0.75rem;
}

/* Generated files list */
.ftl-files {
  display: flex;
  flex-direction: column;
  gap: 0.375rem;
  margin-top: 0.625rem;
}

.ftl-file {
  font-family: 'Red Hat Mono', monospace;
  font-size: 0.8125rem;
  color: var(--color-text-2, #3d3d3d);
  padding: 0.3rem 0.625rem;
  background: rgba(0,0,0,0.04);
  border-radius: 4px;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.ftl-file-always {
  background: rgba(62,134,53,0.1);
  color: #2a5f1e;
  font-weight: 600;
}

.ftl-tag {
  font-family: 'Red Hat Text', sans-serif;
  font-size: 0.6875rem;
  font-weight: 600;
  background: #3E8635;
  color: white;
  padding: 0.1em 0.45em;
  border-radius: 99px;
}

/* Arrows */
.ftl-arrow {
  font-size: 1.5rem;
  color: var(--color-text-3, #6a6e73);
  line-height: 1.8;
  text-align: center;
}

/* Branch rows */
.ftl-decision-row { margin: 0.5rem 0; }

.ftl-branches {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1.25rem;
  width: 100%;
  max-width: 640px;
  align-items: start;
}

.ftl-three-branches {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  gap: 0.875rem;
  width: 100%;
  max-width: 700px;
  align-items: start;
}

.ftl-branch-left, .ftl-branch-right, .ftl-branch-third {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
}

.ftl-branch-left .ftl-node,
.ftl-branch-right .ftl-node,
.ftl-branch-third .ftl-node {
  max-width: 100%;
  width: 100%;
}

/* Branch labels */
.ftl-branch-label {
  font-size: 0.6875rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  padding: 0.2em 0.75em;
  border-radius: 99px;
}

.ftl-label-no     { background: #FFEDED; color: #8A0000; }
.ftl-label-yes    { background: #f3faf2; color: #2a5f1e; }
.ftl-label-setup  { background: #E8F2FF; color: #0050a0; font-size: 0.625rem; }
.ftl-label-mixed  { background: #FFF8E1; color: #7a5900; font-size: 0.625rem; }
.ftl-label-exercise { background: #F3FAF2; color: #2a5f1e; font-size: 0.625rem; }

/* Rejoin + loop arrows */
.ftl-rejoin-arrow { justify-content: center; }

.ftl-loop-arrow {
  font-size: 0.75rem;
  color: #EE0000;
  font-weight: 600;
  text-align: center;
  padding: 0.25rem;
}

/* Responsive */
@media (max-width: 640px) {
  .ftl-branches { grid-template-columns: 1fr; }
  .ftl-three-branches { grid-template-columns: 1fr; }
  .ftl-node { max-width: 100%; }
}
</style>

---

## What You'll Need Before Starting

<div class="category-grid">
  <div class="category-card">
    <div class="category-icon">📖</div>
    <h4>Showroom Workshop Content</h4>
    <p>A Showroom repo with <code>.adoc</code> module files (GitHub URL or local path)</p>

```
content/modules/ROOT/pages/
├── 01-overview.adoc
├── 02-details.adoc
└── 03-module-01.adoc
```

  </div>

  <div class="category-card">
    <div class="category-icon">☸️</div>
    <h4>Deployed Lab Environment</h4>
    <p>A running lab ordered from RHDP — cluster access required to verify real namespace names, service URLs, and credentials</p>

```bash
export OCP_API_URL="https://api.cluster-xxx..."
export OCP_ADMIN_PASSWORD="<password>"
export OPENSHIFT_CLUSTER_INGRESS_DOMAIN="apps.cluster-xxx..."
```

  </div>

  <div class="category-card">
    <div class="category-icon">📦</div>
    <h4>FTL Repository</h4>
    <p>FTL repo cloned locally. The skill auto-detects it from <code>~/CLAUDE.md</code> or common paths — you don't need to provide the path manually unless it's in a non-standard location.</p>

```bash
# Auto-detected from ~/CLAUDE.md, or falls back to:
~/work/code/experiment/ftl/
~/work/code/ftl/
```

  </div>
</div>

---

## Quick Start

```text
/ftl:lab-validator
```

The skill walks you through the complete workflow step by step.

---

## What It Creates

Files are generated inside your FTL repo:

```
labs/
└── <lab-short-name>/
    ├── grade_e2e_readiness.yml  # Always first — pre-deployed infra checks
    ├── lab.yml                  # Lab metadata
    ├── grade_module_01.yml      # Module 1 grader (skipped if SETUP/INTRO)
    ├── solve_module_01.yml      # Module 1 solver
    ├── grade_module_02.yml      # Added after Module 1 passes
    ├── solve_module_02.yml
    └── README.md
```

<div class="callout callout-info">
<span class="callout-icon">ℹ️</span>
<div class="callout-body">
<strong><code>grade_lab.yml</code> is never generated.</strong> The <code>bin/grade_lab</code> wrapper auto-discovers <code>grade_module_*.yml</code> files automatically. Run <code>grade_e2e_readiness.yml</code> with module arg <code>e2e_readiness</code>: <code>bash bin/grade_lab &lt;lab&gt; &lt;user&gt; e2e_readiness --podman --local</code>
</div>
</div>

---

## Running Graders

All graders run from the **FTL repo root** using `bash bin/grade_lab`. Always use `export` — variables without it are not passed into the container.

```bash
cd ~/work/code/experiment/ftl

# Set environment (use export — required for podman)
export OCP_API_URL="https://api.cluster-xxx.dynamic.redhatworkshops.io:6443"
export OCP_ADMIN_PASSWORD="<admin-password>"
export OPENSHIFT_CLUSTER_INGRESS_DOMAIN="apps.cluster-xxx.dynamic.redhatworkshops.io"
```

### Step 0 — Run readiness check first (before students start)

`grade_e2e_readiness.yml` checks that all **pre-deployed infrastructure** is healthy — the things AgnosticD provisioned, not things students do. Run this **before** students begin. If it fails, the environment is broken, not the student.

```bash
# Check pre-deployed infra — all lab types
bash bin/grade_lab <lab> <user> e2e_readiness --podman --local

# Expected: all PASS — environment is healthy and ready
```

What the readiness check contains depends on lab type:

<table>
<thead><tr><th>Lab type</th><th>What it checks</th><th>Env vars needed</th></tr></thead>
<tbody>
<tr>
<td><strong>OCP lab</strong></td>
<td>Showroom ConfigMap readable, pre-deployed pods running, routes accessible via <code>kubernetes.core.k8s_info</code></td>
<td><code>OCP_API_URL</code>, <code>OCP_ADMIN_PASSWORD</code>, <code>OPENSHIFT_CLUSTER_INGRESS_DOMAIN</code></td>
</tr>
<tr>
<td><strong>RHEL / VM lab</strong></td>
<td><strong>Derived from the Showroom content and AgV catalog — not assumed.</strong> A RHEL lab might have AAP + Cockpit + Satellite + 4 upgrade nodes, or it might just have RHEL nodes with httpd. The skill reads <code>software_workloads:</code> in common.yaml and collection role defaults to determine what was actually deployed, then generates checks only for those components.</td>
<td><code>BASTION_HOST</code>, <code>BASTION_USER</code> always. <code>AAP_HOSTNAME</code>, <code>AAP_PASSWORD</code> only if AAP is in the catalog. Lab-specific vars only if needed by the derived checks.</td>
</tr>
<tr>
<td><strong>AAP-on-OCP</strong></td>
<td>Both — OCP resources via <code>kubernetes.core.k8s_info</code> + AAP templates via <code>grader_check_aap_*</code></td>
<td>Both sets above</td>
</tr>
</tbody>
</table>

<div class="callout callout-tip">
<span class="callout-icon">💡</span>
<div class="callout-body">
<strong>For RHEL / VM labs:</strong> the readiness checklist is derived from the catalog, not assumed. Every role in <code>software_workloads: bastions:</code> created something to check. Every service students interact with in the Showroom modules is pre-deployed and must be reachable. The skill reads both before generating any checks.
</div>
</div>

If anything fails here, fix the environment before students start. Do not proceed to module graders until `e2e_readiness` is clean.

### Steps 1+ — Run module graders

```bash
# Test Module 1 locally (no git push needed — mounts local repo)
bash bin/grade_lab <lab> <user> 1 --podman --local

# Run solver then grade again (expect all PASS)
bash bin/solve_lab <lab> <user> 1 --podman --local
bash bin/grade_lab <lab> <user> 1 --podman --local

# Production test (pulls from GitHub)
bash bin/grade_lab <lab> <user> 1 --podman

# Load test all users in parallel
bash bin/grade_lab <lab> all 1 --podman
```

The user arg comes from the `"user"` field in the Showroom ConfigMap output — never hardcode `student` or `user1`.

---

## Grader Roles Reference

All checks use generic grader roles — write custom tasks only when none of these apply.

### OCP Labs

<table>
<thead><tr><th>Student Action</th><th>Role</th></tr></thead>
<tbody>
<tr><td>Deploy / create pod</td><td><code>grader_check_ocp_pod_running</code></td></tr>
<tr><td>Create deployment</td><td><code>grader_check_ocp_deployment</code></td></tr>
<tr><td>Create route</td><td><code>grader_check_ocp_route_exists</code></td></tr>
<tr><td>Create service</td><td><code>grader_check_ocp_service_exists</code></td></tr>
<tr><td>Create secret</td><td><code>grader_check_ocp_secret_exists</code></td></tr>
<tr><td>Create configmap</td><td><code>grader_check_ocp_configmap_exists</code></td></tr>
<tr><td>Create PVC</td><td><code>grader_check_ocp_pvc_exists</code></td></tr>
<tr><td>Run S2I build</td><td><code>grader_check_ocp_build_completed</code></td></tr>
<tr><td>Run Tekton pipeline</td><td><code>grader_check_ocp_pipeline_run</code></td></tr>
<tr><td>Any K8s resource</td><td><code>grader_check_ocp_resource</code></td></tr>
</tbody>
</table>

### RHEL / VM Labs

<table>
<thead><tr><th>Student Action</th><th>Role</th></tr></thead>
<tbody>
<tr><td>Start / enable systemd service</td><td><code>grader_check_service_running</code></td></tr>
<tr><td>Install package</td><td><code>grader_check_package_installed</code></td></tr>
<tr><td>Create user</td><td><code>grader_check_user_exists</code></td></tr>
<tr><td>Create file</td><td><code>grader_check_file_exists</code></td></tr>
<tr><td>File contains content</td><td><code>grader_check_file_contains</code></td></tr>
<tr><td>Run command with expected output (SSH)</td><td><code>grader_check_command_output</code></td></tr>
<tr><td>Run AAP job template</td><td><code>grader_check_aap_job_completed</code></td></tr>
<tr><td>Run AAP workflow</td><td><code>grader_check_aap_workflow_completed</code></td></tr>
<tr><td>AAP licensed and ready</td><td><code>grader_check_aap_licensed</code></td></tr>
<tr><td>Run container</td><td><code>grader_check_container_running</code></td></tr>
</tbody>
</table>

### Satellite-Managed Repos (RHEL Upgrade Labs)

No dedicated Satellite grader role is needed — existing generic roles cover all common checks:

<table>
<thead><tr><th>What to check</th><th>Role</th><th>How</th></tr></thead>
<tbody>
<tr><td>Upgrade repo file present on node</td><td><code>grader_check_file_exists</code></td><td><code>/etc/yum.repos.d/rhel8-for-ripu.repo</code> on RHEL 7 nodes, <code>rhel9-for-ripu.repo</code> on RHEL 8 nodes</td></tr>
<tr><td>Entitlement cert present</td><td><code>grader_check_command_output</code></td><td><code>ls /etc/pki/entitlement/*.pem</code> via SSH to each node</td></tr>
<tr><td>Host registered (subscription-manager)</td><td><code>grader_check_command_output</code></td><td><code>subscription-manager status</code> — check output contains "Current"</td></tr>
<tr><td>Satellite API reachable</td><td><code>grader_check_http_endpoint</code></td><td><code>GET /api/v2/status</code> on Satellite FQDN</td></tr>
<tr><td>Host registered in Satellite DB</td><td><code>grader_check_http_json_response</code></td><td><code>GET /api/v2/hosts?search=name=node1</code> — check <code>total</code> &gt; 0</td></tr>
<tr><td>Node reachable via SSH from bastion</td><td><code>grader_check_command_output</code></td><td><code>ssh node1 hostname</code> — check exit code 0</td></tr>
</tbody>
</table>

<div class="callout callout-info">
<span class="callout-icon">ℹ️</span>
<div class="callout-body">
<strong>No Satellite-specific grader role needed.</strong> <code>grader_check_file_exists</code> handles repo files and certs. <code>grader_check_command_output</code> handles subscription-manager checks over SSH. <code>grader_check_http_json_response</code> handles Satellite API queries. Write custom tasks only when none of these cover your check.
</div>
</div>

### Both Lab Types

<table>
<thead><tr><th>Student Action</th><th>Role</th></tr></thead>
<tbody>
<tr><td>HTTP/HTTPS endpoint accessible</td><td><code>grader_check_http_endpoint</code></td></tr>
<tr><td>HTTP JSON response validation</td><td><code>grader_check_http_json_response</code></td></tr>
<tr><td>Multi-step custom check</td><td>Direct tasks + <code>ftl_run_log_grade_to_log</code></td></tr>
</tbody>
</table>

---

## Key Rules

<div class="category-grid">
  <div class="category-card">
    <h4>One Module at a Time</h4>
    <p>Generate Module 1, test it, then proceed to Module 2. Never generate all modules at once.</p>
  </div>
  <div class="category-card">
    <h4>Admin Only for ConfigMap</h4>
    <p>Admin credentials read the Showroom ConfigMap to get the student's password. All grader checks then run as the student user.</p>
  </div>
  <div class="category-card">
    <h4>Never generate grade_lab.yml</h4>
    <p>The <code>bin/grade_lab</code> wrapper auto-discovers <code>grade_module_*.yml</code> files — no orchestrator needed.</p>
  </div>
  <div class="category-card">
    <h4>No oc CLI in graders</h4>
    <p>Use <code>kubernetes.core.k8s_info</code> — <code>oc</code> crashes silently on arm64 Mac running linux/amd64 containers.</p>
  </div>
  <div class="category-card">
    <h4>Generic roles first</h4>
    <p>No Satellite-specific role needed — <code>grader_check_file_exists</code>, <code>grader_check_command_output</code>, and <code>grader_check_http_json_response</code> cover all Satellite checks.</p>
  </div>
  <div class="category-card">
    <h4>Read real environment</h4>
    <p>Namespace names, API endpoints, and job template names must come from the live cluster — never guessed.</p>
  </div>
</div>

---

## Related Skills

<div class="links-grid">
  <a href="create-lab.html" class="link-card">
    <h4>/showroom:create-lab</h4>
    <p>Create workshop content first, then generate graders</p>
  </a>

  <a href="deployment-health-checker.html" class="link-card">
    <h4>/health:deployment-validator</h4>
    <p>Create deployment health check validation roles</p>
  </a>

  <a href="verify-content.html" class="link-card">
    <h4>/showroom:verify-content</h4>
    <p>Validate workshop content quality before grading</p>
  </a>
</div>

---

## Resources

<div class="callout callout-info">
<span class="callout-icon">🔗</span>
<div class="callout-body">
<ul>
<li><a href="https://github.com/rhpds/ftl" target="_blank">FTL Repository (rhpds/ftl)</a></li>
<li><a href="https://redhat.enterprise.slack.com/archives/C04MLMA15MX" target="_blank">#forum-demo-developers</a></li>
</ul>
</div>
</div>

<div class="navigation-footer">
  <a href="index.html" class="nav-button">← Back to Skills</a>
  <a href="deployment-health-checker.html" class="nav-button">Next: /health:deployment-validator →</a>
</div>
