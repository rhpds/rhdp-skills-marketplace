---
name: novascan:validate
description: This skill should be used when the user asks to "validate agnosticv config", "check if my catalog item is right-sized", "compare scan vs provisioning", "is my demo over-provisioned", or "check quota waste".
---

---
context: main
model: claude-sonnet-4-6
---

# Skill: novascan:validate

**Name:** NovaScan Config Validator
**Description:** Compare a NovaScan scan against an existing AgnosticV config to find over/under-provisioning
**Version:** 1.0.0

---

## Purpose

Validate whether an existing AgnosticV catalog item is right-sized for the demo it provisions. Compares the scan results against the actual config to find quota waste, missing models, or tier mismatches.

## Prerequisites

NovaScan must be cloned at `~/Documents/novascan`.

## Usage

```
/novascan:validate ~/Documents/my-demo ~/agnosticv/ai-qs-my-demo-tenant/common.yaml
```

## Instructions

1. Parse: repo path and agnosticv config path.

2. Run the validator:

```bash
PYTHONPATH=~/Documents/novascan/src python3 -c "
from novascan.scanner import scan_repo
from novascan.planner import recommend_tier
from novascan.validator import compare_against_agnosticv
from pathlib import Path
import yaml

results = scan_repo(Path('REPO_PATH').expanduser().resolve())
plan = recommend_tier(results)
comparison = compare_against_agnosticv(plan, Path('AGNOSTICV_PATH'))
print(yaml.dump(comparison, default_flow_style=False))
"
```

3. Present results:
   - **Tier match**: recommended vs actual (MATCH or MISMATCH)
   - **Resource deltas**: CPU, memory, storage — over-provisioned, under-provisioned, or matched
   - **Model coverage**: models missing from agnosticv, extra models in agnosticv
   - **Recommendation**: what to change to right-size
