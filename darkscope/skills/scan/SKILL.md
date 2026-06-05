---
name: darkscope:scan
description: This skill should be used when the user asks to "scan for security", "check for vulnerabilities", "security audit", "find secrets", "check container security", "is this repo secure", or "run a security scan".
---

---
context: main
model: claude-sonnet-4-6
---

# Skill: darkscope:scan

**Name:** DarkScope Security Scanner
**Description:** Scan a demo repository for security vulnerabilities across code, containers, K8s, and dependencies
**Version:** 1.0.0

---

## Purpose

Scan any demo repository and report security findings: hardcoded secrets, SQL injection, unsafe code patterns, container hardening gaps, Kubernetes security context issues, and known CVEs in dependencies. Produces a risk grade (A-F) with actionable recommendations.

## Prerequisites

DarkScope must be cloned at `~/Documents/darkscope`:
```bash
git clone https://github.com/rhpds/DarkScope.git ~/Documents/darkscope
```

## Usage

```
/darkscope:scan ~/Documents/my-demo
/darkscope:scan ~/Documents/my-demo --deep
/darkscope:scan .
```

## Instructions

1. Parse the repo path from user input. Default to current directory if none given.
2. Check for `--deep` flag (includes supply chain CVE scanning).

```bash
PYTHONPATH=~/Documents/darkscope/src python3 -c "
from darkscope.scanner import scan_repo
from pathlib import Path
import yaml

results = scan_repo(Path('REPO_PATH').expanduser().resolve(), deep=DEEP)
print(yaml.dump(results, default_flow_style=False))
"
```

3. Present as a security report:
   - **Risk Grade** (A-F) prominently with color
   - **Findings by severity**: critical → high → medium → low
   - Each finding: [CWE] title, file:line, recommendation
   - Summary: total findings, by category (secrets, injection, container, k8s, supply_chain)

4. Highlight any critical or high findings that need immediate attention.

## What It Detects

- **Secrets**: API keys (sk-, hf_, ghp_, AKIA), JWT tokens, private keys, passwords, connection strings, high-entropy strings
- **Code Injection**: eval(), exec(), pickle.loads(), yaml.load(), SQL f-strings, subprocess(shell=True)
- **Container**: Root user, COPY ., :latest tags, TLS disabled, privileged builds
- **K8s**: Missing runAsNonRoot, privileged containers, no capability drops, no resource limits
- **Supply Chain**: Known CVEs in PyJWT, transformers, torch, fastapi, requests, etc.

## Output Format

Present as a structured report grouped by severity, not raw YAML. Use the risk grade prominently.
