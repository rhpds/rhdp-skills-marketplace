---
layout: default
title: /health:ftl-generator
---

# /health:ftl-generator

<div class="skill-badge">🧪 FTL Lab Generator</div>

Generate production-quality FTL (Finish The Labs) grader and solver playbooks for a Showroom workshop by analyzing module content. The skill reads your `.adoc` module files and AgnosticV catalog, identifies student exercises and checkpoints, and generates complete Ansible playbooks following all FTL framework conventions.

---

## What You'll Need Before Starting

<div class="prereq-grid">
  <div class="prereq-item">
    <div class="prereq-icon">📖</div>
    <h4>Showroom Workshop Content</h4>
    <p>A Showroom repo with <code>.adoc</code> module files (GitHub URL or local path)</p>
    <pre><code>content/modules/ROOT/pages/
├── 01-overview.adoc
├── 02-details.adoc
└── 03-module-01.adoc</code></pre>
  </div>

  <div class="prereq-item">
    <div class="prereq-icon">☸️</div>
    <h4>Deployed Lab Environment</h4>
    <p>A running lab ordered from RHDP — cluster access required to verify real namespace names, service URLs, and credentials</p>
    <pre><code>export OCP_API_URL="https://api.cluster-xxx..."
export OCP_ADMIN_PASSWORD="&lt;password&gt;"
export OPENSHIFT_CLUSTER_INGRESS_DOMAIN="apps.cluster-xxx..."</code></pre>
  </div>

  <div class="prereq-item">
    <div class="prereq-icon">📦</div>
    <h4>FTL Repository</h4>
    <p>FTL repo cloned locally with <code>labs/</code>, <code>roles/</code>, and <code>bin/</code> directories</p>
    <pre><code>git clone https://github.com/rhpds/ftl.git
~/work/code/experiment/ftl/</code></pre>
  </div>
</div>

---

## Quick Start

```text
/health:ftl-generator
```

The skill will walk you through the complete workflow step by step.

---

## How It Works

The skill follows a structured workflow before generating any code:

<div class="workflow-steps">
  <div class="workflow-step">
    <div class="workflow-icon">📖</div>
    <div class="workflow-content">
      <h4>Step 0.5 — Read Lab Content First</h4>
      <p>Reads <strong>every</strong> <code>.adoc</code> module file from the Showroom repo, reads the AgnosticV catalog and collection role defaults, then asks about the deployed environment. All cluster discovery commands are run by you and pasted back — the skill never runs commands itself.</p>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">🗂️</div>
    <div class="workflow-content">
      <h4>Steps 1–3 — Confirm Configuration</h4>
      <p>Confirms FTL repo path, lab short name (derived from AgV catalog path), lab type (OCP/RHEL), and multi-user vs single-user — detected from the content already read, not asked cold.</p>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">✅</div>
    <div class="workflow-content">
      <h4>Step 4 — Checkpoint Analysis</h4>
      <p>Presents every checkpoint with its source (<strong>Pre-configured</strong> = deployed by AgnosticD, <strong>Student action</strong> = student must do this) and the grader role to use. You confirm before any files are generated.</p>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">⚙️</div>
    <div class="workflow-content">
      <h4>Step 5 — Generate Module 1 Only</h4>
      <p>Copies from <code>labs/lab-template/</code>, generates <code>grade_module_01.yml</code> and <code>solve_module_01.yml</code> using the 22 generic grader roles. Generates Module 2 only after Module 1 passes testing.</p>
    </div>
  </div>

  <div class="workflow-step">
    <div class="workflow-icon">🧪</div>
    <div class="workflow-content">
      <h4>Step 6 — Guided Testing</h4>
      <p>Walks you through local testing with <code>--local</code> mount (no git push needed), solver testing, then production testing from GitHub.</p>
    </div>
  </div>
</div>

---

## What It Creates

Files are generated inside your FTL repo:

<div class="file-structure">
  <h4>Generated files per lab:</h4>
  <pre><code>labs/
└── &lt;lab-short-name&gt;/
    ├── lab.yml                  # Lab metadata
    ├── grade_module_01.yml      # Module 1 grader (generated first)
    ├── solve_module_01.yml      # Module 1 solver
    ├── grade_module_02.yml      # Added after Module 1 passes
    ├── solve_module_02.yml
    └── README.md</code></pre>
</div>

**Note:** `grade_lab.yml` is never generated. The `bin/grade_lab` wrapper auto-discovers `grade_module_*.yml` files automatically.

---

## Running Graders

All graders run from the **FTL repo root** using `bash bin/grade_lab`. Always use `export` — variables without it are not passed into the container.

```bash
cd ~/work/code/experiment/ftl

# Set environment (use export — required for podman)
export OCP_API_URL="https://api.cluster-xxx.dynamic.redhatworkshops.io:6443"
export OCP_ADMIN_PASSWORD="<admin-password>"
export OPENSHIFT_CLUSTER_INGRESS_DOMAIN="apps.cluster-xxx.dynamic.redhatworkshops.io"

# Test locally (no git push needed — mounts local repo into container)
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

## Key Rules

<div class="tips-grid">
  <div class="tip-card">
    <h4>One Module at a Time</h4>
    <p>Generate Module 1, test it, then proceed to Module 2. Never generate all modules at once.</p>
  </div>
  <div class="tip-card">
    <h4>Admin Only for ConfigMap</h4>
    <p>Admin credentials read the Showroom ConfigMap to get the student's password. All grader checks then run as the student user.</p>
  </div>
  <div class="tip-card">
    <h4>Never generate grade_lab.yml</h4>
    <p>The <code>bin/grade_lab</code> wrapper auto-discovers <code>grade_module_*.yml</code> files — no orchestrator needed.</p>
  </div>
  <div class="tip-card">
    <h4>No oc CLI in graders</h4>
    <p>Use <code>kubernetes.core.k8s_info</code> — <code>oc</code> crashes silently on arm64 Mac running linux/amd64 containers.</p>
  </div>
  <div class="tip-card">
    <h4>Generic roles first</h4>
    <p>22 built-in grader roles cover most checks. Write custom tasks only when no generic role applies.</p>
  </div>
  <div class="tip-card">
    <h4>Read real environment</h4>
    <p>Namespace names, API endpoints, and job template names must come from the live cluster — never guessed.</p>
  </div>
</div>

---

## Related Skills

<div class="related-skills">
  <a href="create-lab.html" class="related-skill-card">
    <div class="related-skill-icon">📝</div>
    <div class="related-skill-content">
      <h4>/showroom:create-lab</h4>
      <p>Create workshop content first, then generate graders</p>
    </div>
  </a>

  <a href="deployment-health-checker.html" class="related-skill-card">
    <div class="related-skill-icon">🏥</div>
    <div class="related-skill-content">
      <h4>/health:deployment-validator</h4>
      <p>Create deployment health check validation roles</p>
    </div>
  </a>

  <a href="verify-content.html" class="related-skill-card">
    <div class="related-skill-icon">✓</div>
    <div class="related-skill-content">
      <h4>/showroom:verify-content</h4>
      <p>Validate workshop content quality before grading</p>
    </div>
  </a>
</div>

---

## Resources

<div class="resources-box">
  <h4>Helpful Links:</h4>
  <ul>
    <li><a href="https://github.com/rhpds/ftl" target="_blank">FTL Repository (rhpds/ftl)</a></li>
    <li><a href="https://redhat.enterprise.slack.com/archives/C04MLMA15MX" target="_blank">#forum-demo-developers</a></li>
  </ul>
</div>

---

<div class="navigation-footer">
  <a href="index.html" class="nav-button">← Back to Skills</a>
  <a href="deployment-health-checker.html" class="nav-button">Next: /health:deployment-validator →</a>
</div>

<style>
.skill-badge {
  display: inline-block;
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  font-weight: 600;
  margin: 1rem 0;
}

.prereq-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.prereq-item {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
}

.prereq-icon { font-size: 2rem; margin-bottom: 0.5rem; }
.prereq-item h4 { margin: 0.5rem 0; color: #24292e; }
.prereq-item p { color: #586069; font-size: 0.875rem; margin: 0.5rem 0; }
.prereq-item pre { background: #f6f8fa; padding: 0.75rem; border-radius: 4px; margin: 0.5rem 0 0 0; font-size: 0.8rem; }

.workflow-steps { margin: 2rem 0; }
.workflow-step {
  display: flex;
  gap: 1.5rem;
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 1px solid #e1e4e8;
  border-radius: 12px;
  padding: 1.5rem;
  margin-bottom: 1.5rem;
}
.workflow-icon { font-size: 2rem; flex-shrink: 0; }
.workflow-content { flex: 1; }
.workflow-content h4 { margin-top: 0; margin-bottom: 0.5rem; color: #24292e; }
.workflow-content p { color: #586069; margin: 0; font-size: 0.9rem; }

.file-structure {
  background: #f6f8fa;
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
  margin: 1rem 0;
}
.file-structure h4 { margin-top: 0; color: #24292e; }
.file-structure pre { background: white; padding: 1rem; border-radius: 6px; margin: 0.5rem 0 0 0; }

.tips-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin: 1.5rem 0;
}
.tip-card {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
}
.tip-card h4 { margin-top: 0; margin-bottom: 0.5rem; color: #24292e; font-size: 0.9rem; }
.tip-card p { margin: 0; color: #586069; font-size: 0.875rem; }

.related-skills {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1rem;
  margin: 1.5rem 0;
}
.related-skill-card {
  display: flex;
  gap: 1rem;
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
  text-decoration: none;
  color: inherit;
  transition: all 0.2s ease;
}
.related-skill-card:hover { border-color: #10b981; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
.related-skill-icon { font-size: 2rem; flex-shrink: 0; }
.related-skill-content h4 { margin: 0 0 0.25rem 0; color: #24292e; font-size: 1rem; }
.related-skill-content p { margin: 0; color: #586069; font-size: 0.875rem; }

.resources-box {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 1px solid #e1e4e8;
  border-radius: 12px;
  padding: 1.5rem;
  margin: 1rem 0;
}
.resources-box h4 { margin-top: 0; color: #24292e; }
.resources-box a { color: #0969da; }

.navigation-footer {
  display: flex;
  justify-content: space-between;
  gap: 1rem;
  margin: 2rem 0;
  padding-top: 2rem;
  border-top: 1px solid #e1e4e8;
}
.nav-button {
  padding: 0.75rem 1.5rem;
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 8px;
  text-decoration: none;
  color: #24292e;
  font-weight: 600;
  transition: all 0.2s ease;
}
.nav-button:hover { border-color: #10b981; color: #10b981; transform: translateY(-2px); }
</style>
