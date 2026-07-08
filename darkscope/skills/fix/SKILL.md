---
name: darkscope:fix
description: This skill should be used when the user asks to "fix security issues", "how do I fix these vulnerabilities", "show me the fixes", "remediation plan", "what do I need to change", or "generate security fixes".
---

---
context: main
model: claude-sonnet-4-6
---

# Skill: darkscope:fix

**Name:** DarkScope Remediation Planner
**Description:** Scan a repo and produce a prioritized remediation plan with specific code changes
**Version:** 1.0.0

---

## Purpose

Scan a repository, then produce a prioritized remediation plan grouped by fix type. For each finding group, provide the exact file, line, current code, and recommended fix. Estimate effort per group.

## Instructions

1. Run a full DarkScope scan:

```bash
PYTHONPATH=~/Documents/darkscope/src python3 -c "
from darkscope.scanner import scan_repo
from pathlib import Path
import yaml
results = scan_repo(Path('REPO_PATH').expanduser().resolve(), deep=True)
print(yaml.dump(results, default_flow_style=False))
"
```

2. Analyze the findings and produce a remediation plan:
   - Group findings by fix type (e.g., "Add USER 1001 to Containerfiles", "Add securityContext to Deployments")
   - Order by severity (critical first)
   - For each group: list affected files, show the exact change needed, estimate effort (minutes)
   - Provide copy-pasteable fix snippets where possible

3. Present as a checklist the user can work through:
   ```
   [ ] Fix 1: Add USER 1001 (3 files, ~5 min)
       - Containerfile: add `USER 1001` before CMD
       - backend/Dockerfile: same
   [ ] Fix 2: Upgrade requests>=2.32.0 (1 file, ~1 min)
       - requirements.txt line 5: change 2.31.0 → 2.32.0
   ```

4. After presenting the plan, offer to apply the fixes automatically if the user approves.
