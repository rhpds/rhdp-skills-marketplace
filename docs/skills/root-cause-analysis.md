---
layout: default
title: /aiops-skill:root-cause-analysis
---

# /aiops-skill:root-cause-analysis

<div class="reference-badge">🔎 Root Cause Analysis</div>

Investigate failed Ansible/AAP jobs by correlating logs with Splunk OCP pod logs and GitHub configuration, then generate a structured root cause summary with evidence and recommendations.

---

## When to Use

<div class="callout callout-tip">
<span class="callout-icon">💡</span>
<div class="callout-body">
<strong>Invoke this skill when you want to:</strong>
<ul>
<li>Investigate why a specific job failed</li>
<li>Analyze Ansible/AAP logs for errors and failure patterns</li>
<li>Correlate infrastructure events across AAP logs and Splunk pod logs</li>
<li>Find root causes of failed deployments or provisioning runs</li>
<li>Troubleshoot Kubernetes/OpenShift problems surfaced during job execution</li>
<li>Get specific, evidence-backed recommendations for configuration fixes</li>
</ul>
</div>
</div>

**Example invocations:**

```
"Analyze job 1234567 for root cause"
"Why did job 1234567 fail?"
"Investigate the failure in job 1234567"
"Debug the deployment failure in job 1234567"
```

---

## Prerequisites

<div class="category-grid">
<div class="category-card">
<span class="category-icon">📁</span>
<h3>JOB_LOGS_DIR <span class="reference-badge">Required</span></h3>
<p>Local directory where job log files are stored. The skill searches here first before attempting a remote fetch.</p>
</div>
<div class="category-card">
<span class="category-icon">🔗</span>
<h3>JUMPBOX_URI <span class="reference-badge">Required</span></h3>
<p>SSH jumpbox connection string for uploading analysis results and feedback after the investigation.</p>
</div>
<div class="category-card">
<span class="category-icon">🖥️</span>
<h3>SSH / REMOTE_HOST</h3>
<p>SSH access to the remote log server. Without this, the <code>--fetch</code> flag won't work — logs must be placed in JOB_LOGS_DIR manually.</p>
</div>
<div class="category-card">
<span class="category-icon">📊</span>
<h3>Splunk Credentials</h3>
<p>SPLUNK_HOST, SPLUNK_USERNAME, SPLUNK_PASSWORD, SPLUNK_INDEX, SPLUNK_OCP_APP_INDEX, SPLUNK_OCP_INFRA_INDEX. Without these, Steps 2–3 (log correlation) are skipped.</p>
</div>
<div class="category-card">
<span class="category-icon">🐙</span>
<h3>GITHUB_TOKEN</h3>
<p>Personal access token for GitHub API. Without this, Step 4 (config fetching) is skipped and AgnosticD/AgnosticV context won't be available.</p>
</div>
</div>

<div class="callout callout-info">
<span class="callout-icon">ℹ️</span>
<div class="callout-body">
<strong>Interactive setup:</strong> On first run, the skill checks all prerequisites via <code>scripts/cli.py setup --json</code> and offers to walk you through configuring any missing items. Secrets are written to <code>.claude/settings.json</code> — ensure this file is in <code>.gitignore</code>.
</div>
</div>

---

## 5-Step Pipeline

<ol class="steps">
<li>
<div class="step-content">
<h4>Step 1 — Parse Job Log <code>[Python]</code></h4>
<p>Reads the local job log file and extracts: job ID, GUID, namespace, failed task names, task durations, and the job time window. Output: <code>.analysis/&lt;job-id&gt;/step1_job_context.json</code></p>
</div>
</li>
<li>
<div class="step-content">
<h4>Step 2 — Query Splunk <code>[Python]</code></h4>
<p>Fetches OCP pod logs from the job's namespace within the job time window using the Splunk REST API. Searches both app and infra indexes. Output: <code>step2_splunk_logs.json</code></p>
</div>
</li>
<li>
<div class="step-content">
<h4>Step 3 — Correlate <code>[Python]</code></h4>
<p>Merges AAP and Splunk events into a unified timeline using namespace, GUID, timestamps, and pod names. Identifies which pod errors preceded, coincided with, or followed each failed task. Output: <code>step3_correlation.json</code></p>
</div>
</li>
<li>
<div class="step-content">
<h4>Step 4 — Fetch GitHub Files <code>[Python]</code></h4>
<p>Parses job metadata, then retrieves AgnosticV configuration files and AgnosticD workload role code from GitHub. Uses the GitHub token to access private repositories. Output: <code>step4_github_fetch_history.json</code></p>
</div>
</li>
<li>
<div class="step-content">
<h4>Step 5 — Analyze &amp; Generate Summary <code>[Claude]</code></h4>
<p>Claude reads the step 1, 3, and 4 outputs (plus step 2 if deeper investigation is needed) and produces a structured JSON summary with root cause category, confidence, evidence, correlation, and file-level recommendations. Output: <code>step5_analysis_summary.json</code></p>
<p>After saving, the skill uploads results to the jumpbox: <code>python scripts/cli.py upload --job-id &lt;job-id&gt;</code></p>
</div>
</li>
</ol>

---

## Workflow

<ol class="steps">
<li><div class="step-content"><h4>Preflight Check</h4><p>Skill creates a virtual environment and installs dependencies, then runs <code>scripts/cli.py setup --json</code> to verify all required settings. Offers interactive configuration for any missing items.</p></div></li>
<li><div class="step-content"><h4>Run Analysis CLI</h4>

```bash
# By job ID — auto-fetches log from remote if not found locally
.venv/bin/python scripts/cli.py analyze --job-id 1234567 --fetch

# By explicit path — when you already have the log file
.venv/bin/python scripts/cli.py analyze --job-log /path/to/job_123.json.gz
```

</div></li>
<li><div class="step-content"><h4>Claude Analyzes Step Outputs</h4><p>After Steps 1–4 complete, Claude reads all output files and generates <code>step5_analysis_summary.json</code> following the evidence and recommendation schema.</p></div></li>
<li><div class="step-content"><h4>Upload Results</h4><p>The skill uploads the full <code>.analysis/&lt;job-id&gt;/</code> directory to the configured jumpbox for team sharing.</p></div></li>
</ol>

---

## Configuration

| Variable | Purpose | Example |
|---|---|---|
| `JOB_LOGS_DIR` | Local directory for job log files | `/home/user/aiops_extracted_logs` |
| `JUMPBOX_URI` | SSH jumpbox for uploading results | `user@jumpbox.example.com -p 22` |
| `REMOTE_HOST` | SSH alias for remote log server | `log-server` |
| `REMOTE_DIR` | Directory on remote log server | `/var/log/aap/jobs` |
| `SPLUNK_HOST` | Splunk server hostname | `splunk.example.com` |
| `SPLUNK_USERNAME` | Splunk username | `analyst` |
| `SPLUNK_PASSWORD` | Splunk password | *(secret)* |
| `SPLUNK_INDEX` | Primary Splunk index | `aap_jobs` |
| `SPLUNK_OCP_APP_INDEX` | OCP application logs index | `ocp_app` |
| `SPLUNK_OCP_INFRA_INDEX` | OCP infrastructure logs index | `ocp_infra` |
| `SPLUNK_VERIFY_SSL` | Whether to verify SSL certificates | `false` |
| `GITHUB_TOKEN` | GitHub personal access token | `ghp_xxxxxxxxxxxx` |
| `MLFLOW_PORT` | MLflow tracing server port (optional) | `5000` |
| `MLFLOW_EXPERIMENT_NAME` | MLflow experiment name (optional) | `rca-analysis` |

---

## Output Files

| Step | File | Author |
|---|---|---|
| 1 | `step1_job_context.json` | Python |
| 2 | `step2_splunk_logs.json` | Python |
| 3 | `step3_correlation.json` | Python |
| 4 | `step4_github_fetch_history.json` | Python |
| 5 | `step5_analysis_summary.json` | Claude |

All files are written to `.analysis/<job-id>/` relative to the skill directory.

---

## Related Skills

<div class="navigation-footer">
  <a href="{{ '/index.html' | relative_url }}" class="nav-button">← Back to Skills</a>
  <a href="{{ '/skills/logs-fetcher.html' | relative_url }}" class="nav-button">Next: Logs Fetcher →</a>
</div>
