---
name: novascan:scan
description: This skill should be used when the user asks to "scan a repo", "check what a demo needs", "analyze provisioning requirements", "what resources does this demo need", "scan for LLM usage", or "check infrastructure requirements".
---

---
context: main
model: claude-sonnet-4-6
---

# Skill: novascan:scan

**Name:** NovaScan Repository Scanner
**Description:** Scan a demo repository for LLM models, infrastructure, and resource requirements
**Version:** 1.0.0

---

## Purpose

Scan any demo repository and report what it needs for RHDP provisioning: LLM frameworks and models, databases, message queues, K8s workloads, Helm charts, container images, and frontends. Produces a tier recommendation (pilot/partner/dedicated) and deployment topology (namespace/platform/cnv).

## Prerequisites

NovaScan must be cloned at `~/Documents/novascan`:
```bash
git clone https://github.com/rhpds/NovaScan.git ~/Documents/novascan
```

## Usage

The user provides a path to a demo repository. If no path is given, scan the current working directory.

```
/novascan:scan ~/Documents/my-demo
/novascan:scan .
```

## Instructions

1. Parse the repo path from user input. Default to current directory if none given.

2. Run the scanner:

```bash
PYTHONPATH=~/Documents/novascan/src python3 -c "
from novascan.scanner import scan_repo
from novascan.planner import recommend_tier
from pathlib import Path
import yaml

results = scan_repo(Path('REPO_PATH').expanduser().resolve())
plan = recommend_tier(results)
print(yaml.dump(plan, default_flow_style=False))
"
```

3. Present results as a clear summary:
   - **Tier recommendation** (pilot / partner / dedicated) with reasoning
   - **Deployment topology** (namespace / platform / cnv)
   - **Per-seat resources** (CPU, memory, storage)
   - **Infrastructure detected** (databases, message queues, K8s workloads, Helm charts, frontends)
   - **LLM models detected** with hardware tier (CPU/GPU) and source (MAAS/local)
   - **Frameworks detected** (OpenAI, vLLM, LangChain, etc.)

4. If issues are found (inflated estimates, false positive models), note them.

## Output Format

Present as a structured table, not raw YAML. Highlight the tier recommendation prominently.
