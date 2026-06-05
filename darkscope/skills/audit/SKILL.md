---
name: darkscope:audit
description: This skill should be used when the user asks to "full security audit", "deep security scan", "audit this repo", "security report", "check everything for security", or "comprehensive vulnerability assessment".
---

---
context: main
model: claude-sonnet-4-6
---

# Skill: darkscope:audit

**Name:** DarkScope Full Audit
**Description:** Complete security audit with all analysis layers enabled
**Version:** 1.0.0

---

## Purpose

Run a comprehensive security audit with all layers: static analysis (AST + secrets + containers + K8s), supply chain (dependency CVEs), and produce a full report with risk grading and remediation recommendations.

## Prerequisites

DarkScope must be cloned at `~/Documents/darkscope`.

## Usage

```
/darkscope:audit ~/Documents/my-demo
```

## Instructions

1. Parse the repo path. Default to current directory.

```bash
PYTHONPATH=~/Documents/darkscope/src python3 -c "
from darkscope.scanner import scan_repo
from darkscope.cli import _generate_markdown
from pathlib import Path

results = scan_repo(Path('REPO_PATH').expanduser().resolve(), deep=True)
report = _generate_markdown(results)
print(report)
"
```

2. Present the full markdown report.
3. After the report, provide a prioritized remediation plan:
   - Critical/High findings first with specific fix instructions
   - Group by fix type (e.g., "add USER 1001 to these 3 Containerfiles")
   - Estimate effort for each group
