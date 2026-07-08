---
name: darkscope:compare
description: This skill should be used when the user asks to "compare security", "before and after", "security improvement", "compare two repos", "how much did we improve", or "security delta".
---

---
context: main
model: claude-sonnet-4-6
---

# Skill: darkscope:compare

**Name:** DarkScope Security Comparison
**Description:** Compare security posture between two repos or before/after states
**Version:** 1.0.0

---

## Purpose

Compare the security posture of two repositories, or track improvement over time by comparing current scan results against a saved baseline.

## Instructions

1. Scan both repos:

```bash
PYTHONPATH=~/Documents/darkscope/src python3 -c "
from darkscope.scanner import scan_repo
from pathlib import Path

r1 = scan_repo(Path('REPO_1').expanduser().resolve(), deep=True)
r2 = scan_repo(Path('REPO_2').expanduser().resolve(), deep=True)

s1, s2 = r1['summary'], r2['summary']
print(f'Repo 1: {Path(r1[\"repo\"]).name} — Grade {s1[\"risk_grade\"]} (score {s1[\"risk_score\"]}, {s1[\"total_findings\"]} findings)')
print(f'Repo 2: {Path(r2[\"repo\"]).name} — Grade {s2[\"risk_grade\"]} (score {s2[\"risk_score\"]}, {s2[\"total_findings\"]} findings)')
print(f'Delta: {s1[\"risk_score\"] - s2[\"risk_score\"]:+d} points')
"
```

2. Present a side-by-side comparison: grade, score, findings by severity, and which specific issues were fixed or introduced.
