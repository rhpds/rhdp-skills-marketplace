---
layout: default
title: /aiops-skill:logs-fetcher
---

# /aiops-skill:logs-fetcher

<div class="reference-badge">📋 Log Retrieval</div>

Fetch Ansible/AAP job logs from a remote server via SSH using either a time-range window or specific job numbers, then transfer them locally for analysis.

---

## When to Use

<div class="callout callout-tip">
<span class="callout-icon">💡</span>
<div class="callout-body">
<strong>Invoke this skill when you want to:</strong>
<ul>
<li>Download logs for a known set of job IDs before root cause analysis</li>
<li>Fetch all failed jobs from a specific incident time window</li>
<li>Retrieve recent processed or ignored job logs for investigation</li>
<li>Pull logs by minute or second precision when troubleshooting a narrow time window</li>
</ul>
</div>
</div>

**Example invocations:**

```
"Fetch logs from the last 2 hours"
"Get logs for jobs 1234567, 1234568, and 1234569"
"Download all processed logs from 2025-12-10 08:00 to 2025-12-10 17:00"
"Fetch the 20 most recent failed job logs"
```

---

## Prerequisites

<div class="category-grid">
<div class="category-card">
<span class="category-icon">🔑</span>
<h3>SSH Access <span class="reference-badge">Required</span></h3>
<p>A working SSH profile to the remote log server. The skill uses rsync over SSH, so passwordless key-based auth is expected.</p>
</div>
<div class="category-card">
<span class="category-icon">🖥️</span>
<h3>REMOTE_HOST <span class="reference-badge">Required</span></h3>
<p>The SSH host alias as defined in <code>~/.ssh/config</code>. The skill connects to this host to discover and transfer log files.</p>
</div>
<div class="category-card">
<span class="category-icon">📂</span>
<h3>REMOTE_DIR <span class="reference-badge">Required</span></h3>
<p>Directory on the remote server where job log files reside (e.g., <code>/var/log/aap/jobs</code>).</p>
</div>
</div>

<div class="callout callout-info">
<span class="callout-icon">ℹ️</span>
<div class="callout-body">
<strong>SSH config setup:</strong> Add your remote host to <code>~/.ssh/config</code> for passwordless access:

```
Host log-server
    HostName logs.example.com
    User your-username
    Port 22
    IdentityFile ~/.ssh/id_rsa
```

Test with: <code>ssh log-server</code> (should connect without a password prompt)
</div>
</div>

---

## Two Fetch Modes

<div class="vs-grid">
<div class="vs-card vs-card-skill">
<span class="vs-label">Option A — Fetch by Time Range</span>
<h3>Use when you know the incident window</h3>
<ul>
<li>Filter by start and end time with minute or second precision</li>
<li>Combine with <code>--limit</code> to cap the number of files</li>
<li>Use <code>--order desc</code> to get newest logs first</li>
<li>Supports <code>processed</code>, <code>ignored</code>, or <code>all</code> log types</li>
</ul>
</div>
<div class="vs-card vs-card-agent">
<span class="vs-label">Option B — Fetch by Job Number</span>
<h3>Use when you know specific job IDs</h3>
<ul>
<li>Pass one or more job numbers directly</li>
<li>Works with or without the <code>job_</code> prefix</li>
<li>Fetches all transform statuses for each job</li>
<li>Automatically locates matching files on the remote server</li>
</ul>
</div>
</div>

---

## Workflow

<ol class="steps">
<li>
<div class="step-content">
<h4>Option A — Fetch by Time/Mode</h4>

```bash
# Fetch recent logs (newest first, limit 20)
python -m scripts.fetch_logs_ssh \
  --mode processed \
  --order desc \
  --limit 20 \
  --local-dir .incidents/<incident-id>/raw_logs

# Fetch logs in a specific time range
python -m scripts.fetch_logs_ssh \
  --mode processed \
  --start-time "2025-12-09 08:00:00" \
  --end-time "2025-12-10 17:00:00" \
  --local-dir .incidents/<incident-id>/raw_logs

# Fetch all logs from a single day
python -m scripts.fetch_logs_ssh \
  --mode all \
  --start-time "2025-12-10" \
  --end-time "2025-12-10" \
  --local-dir .incidents/<incident-id>/raw_logs
```

</div>
</li>
<li>
<div class="step-content">
<h4>Option B — Fetch by Job Number</h4>

```bash
# With job_ prefix
python -m scripts.fetch_logs_by_job \
  job_1234567 job_1234568 job_1234569 \
  --local-dir .incidents/<incident-id>/raw_logs

# Without prefix (both forms work)
python -m scripts.fetch_logs_by_job \
  1234567 1234568 1234569 \
  --local-dir .incidents/<incident-id>/raw_logs
```

</div>
</li>
<li>
<div class="step-content">
<h4>Verify the Transfer</h4>
<p>Check that files were transferred. Note job IDs from filenames (e.g., <code>job_1234567.json.gz.transform-processed</code>) and confirm the time range matches the incident window.</p>
</div>
</li>
</ol>

---

## Time Filter Format

| Format | Example | Precision |
|---|---|---|
| Full timestamp | `"2025-12-10 14:30:45"` | Second |
| Minute precision | `"2025-12-10 14:30"` | Minute |
| Day only | `"2025-12-10"` | Day |

Time filters can be combined with `--limit` and `--order`:

```bash
--start-time "2025-12-10 00:00" --limit 10 --order desc
```

---

## Configuration

| Variable | Purpose | Example |
|---|---|---|
| `REMOTE_HOST` | SSH host alias | `log-server` |
| `REMOTE_DIR` | Remote log directory | `/var/log/aap/jobs` |
| `DEFAULT_LOCAL_DIR` | Default local output directory | `~/aiops_extracted_logs` |

---

## Next Steps

Once logs are fetched locally, run root cause analysis:

```
"Analyze job 1234567 for root cause"
```

The root-cause-analysis skill automatically finds logs in `JOB_LOGS_DIR` and proceeds through the 5-step pipeline.

---

<div class="navigation-footer">
  <a href="{{ '/index.html' | relative_url }}" class="nav-button">← Back to Skills</a>
  <a href="{{ '/skills/root-cause-analysis.html' | relative_url }}" class="nav-button">Root Cause Analysis →</a>
</div>
