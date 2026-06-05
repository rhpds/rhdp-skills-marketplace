---
name: darkscope:batch
description: This skill should be used when the user asks to "scan all repos", "batch security scan", "scan my projects", "portfolio security", "scan everything in a directory", or "security overview of all repos".
---

---
context: main
model: claude-sonnet-4-6
---

# Skill: darkscope:batch

**Name:** DarkScope Batch Scanner
**Description:** Scan all repositories in a directory and produce a portfolio security overview
**Version:** 1.0.0

---

## Purpose

Scan every repository in a directory and produce a summary table showing risk grades, scores, and finding counts. Identifies the highest-risk repos that need attention first.

## Instructions

```bash
PYTHONPATH=~/Documents/darkscope/src python3 -c "
from darkscope.scanner import scan_repo
from pathlib import Path

repos_dir = Path('REPOS_DIR').expanduser().resolve()
results = []
for child in sorted(repos_dir.iterdir()):
    if not child.is_dir() or child.name.startswith('.'):
        continue
    try:
        r = scan_repo(child, deep=True)
        results.append(r)
    except: pass

results.sort(key=lambda r: r['summary']['risk_score'], reverse=True)
print(f'{\"Repo\":<35s} {\"Grade\":<6s} {\"Score\":<6s} {\"Crit\":<5s} {\"High\":<5s} {\"Med\":<5s} {\"Total\":<6s}')
print('=' * 68)
for r in results:
    s = r['summary']
    sv = s['by_severity']
    print(f'{Path(r[\"repo\"]).name:<35s} {s[\"risk_grade\"]:<6s} {s[\"risk_score\"]:<6} {sv.get(\"critical\",0):<5} {sv.get(\"high\",0):<5} {sv.get(\"medium\",0):<5} {s[\"total_findings\"]:<6}')
"
```

Present as a sorted table (worst first). Highlight any repos at C or below. Recommend which repos to fix first.
