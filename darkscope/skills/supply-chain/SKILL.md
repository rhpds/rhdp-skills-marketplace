---
name: darkscope:supply-chain
description: This skill should be used when the user asks to "check dependencies", "scan for CVEs", "are my packages safe", "vulnerability check on requirements", "check for outdated packages", or "dependency audit".
---

---
context: main
model: claude-sonnet-4-6
---

# Skill: darkscope:supply-chain

**Name:** DarkScope Supply Chain Audit
**Description:** Check dependencies against known CVE database
**Version:** 1.0.0

---

## Purpose

Scan requirements.txt, package.json, and other dependency files against a catalog of known critical/high CVEs for AI and web packages. Reports vulnerable versions with upgrade recommendations.

## Instructions

```bash
PYTHONPATH=~/Documents/darkscope/src python3 -c "
from darkscope.analyzers.supply_chain import scan
from pathlib import Path

repo = Path('REPO_PATH').expanduser().resolve()
findings = scan(repo)
for f in findings:
    rel = f.file.split(str(repo) + '/')[-1] if str(repo) in f.file else f.file
    print(f'{f.severity:8s} {f.title}')
    print(f'         {rel}')
    print(f'         → {f.recommendation}')
    print()
if not findings:
    print('No known CVEs found in dependencies.')
else:
    print(f'Total: {len(findings)} vulnerable dependencies')
"
```

Present as a table: package, current version, CVE ID, severity, fix version.
