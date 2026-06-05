---
name: novascan:generate
description: This skill should be used when the user asks to "generate agnosticv", "create a catalog item", "build a common.yaml from a scan", "create provisioning config for my demo", or "scaffold an agnosticv tenant config".
---

---
context: main
model: claude-sonnet-4-6
---

# Skill: novascan:generate

**Name:** NovaScan AgnosticV Generator
**Description:** Generate a complete AgnosticV catalog item directory from scan results
**Version:** 1.0.0

---

## Purpose

Scan a demo repo and generate a right-sized AgnosticV catalog item (common.yaml + dev/test/prod.yaml) matching the production RHDP `quickstart_deploy_via_make` pattern. Quotas are based on actual resource detection, not blanket defaults.

## Prerequisites

NovaScan must be cloned at `~/Documents/novascan`.

## Usage

```
/novascan:generate ~/Documents/my-demo ./output/ai-qs-my-demo-tenant/
/novascan:generate ~/Documents/my-demo ./output/ --seats 60 --repo-url https://github.com/rh-ai-quickstart/my-demo --slug my-demo
```

## Instructions

1. Parse: repo path, output directory, optional seats, optional repo URL, optional slug.

2. Run the generator:

```bash
PYTHONPATH=~/Documents/novascan/src python3 -c "
from novascan.scanner import scan_repo
from novascan.planner import recommend_tier
from novascan.generator import generate_agnosticv, write_agnosticv
from pathlib import Path

results = scan_repo(Path('REPO_PATH').expanduser().resolve())
plan = recommend_tier(results, seats=SEATS)
config = generate_agnosticv(plan, seats=SEATS, repo_url='REPO_URL', slug_override='SLUG')
write_agnosticv(config, Path('OUTPUT_DIR'))
print('Generated catalog item')
"
```

3. Report what was generated:
   - Files created (common.yaml, dev.yaml, test.yaml, prod.yaml)
   - Tier and quotas applied
   - Models included in LiteLLM virtual key list
   - Remind user to review before committing

4. After generating, offer to show the common.yaml content for review.
