---
name: novascan:plan
description: This skill should be used when the user asks to "plan provisioning", "size a lab", "how many seats can this cluster support", "capacity plan for a workshop", "what cluster do I need for 60 users", or "plan for a demo event".
---

---
context: main
model: claude-sonnet-4-6
---

# Skill: novascan:plan

**Name:** NovaScan Capacity Planner
**Description:** Generate a capacity plan with multi-seat lab sizing and cluster recommendations
**Version:** 1.0.0

---

## Purpose

Scan a demo repo and produce a full capacity plan for a multi-seat lab or workshop. Calculates per-seat resources, total cluster requirements, worker node sizing, sandbox API config, and AgnosticV cluster overrides. Warns about MAAS rate limits and GPU sharing at scale.

## Prerequisites

NovaScan must be cloned at `~/Documents/novascan`.

## Usage

```
/novascan:plan ~/Documents/my-demo 60
/novascan:plan ~/Documents/my-demo --seats 25
/novascan:plan .
```

## Instructions

1. Parse repo path and seat count from user input. Default: current directory, 1 seat.

2. Run the planner:

```bash
PYTHONPATH=~/Documents/novascan/src python3 -c "
from novascan.scanner import scan_repo
from novascan.planner import recommend_tier
from pathlib import Path
import yaml

results = scan_repo(Path('REPO_PATH').expanduser().resolve())
plan = recommend_tier(results, seats=SEATS)
print(yaml.dump(plan, default_flow_style=False))
"
```

3. Present results:
   - **Per-seat estimate**: CPU, memory, storage
   - **Lab total**: per-seat × seats + shared infra overhead
   - **Cluster sizing**: worker count × worker size (auto-selected)
   - **Sandbox config**: max_placements, usage percentages
   - **AgnosticV cluster overrides**: worker_instance_count, ai_workers_cores, ai_workers_memory
   - **Warnings**: MAAS RPM limits, GPU sharing risks

4. If seats > 1, always show the lab capacity section. If seats = 1, show only per-seat.
