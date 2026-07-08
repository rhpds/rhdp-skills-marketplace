---
name: darkscope:containers
description: This skill should be used when the user asks to "check container security", "is my Containerfile secure", "check Dockerfile hardening", "container best practices", "is it running as root", or "check K8s manifests".
---

---
context: main
model: claude-sonnet-4-6
---

# Skill: darkscope:containers

**Name:** DarkScope Container & K8s Hardening Check
**Description:** Check Containerfiles and K8s manifests for security best practices
**Version:** 1.0.0

---

## Purpose

Scan Containerfiles/Dockerfiles for hardening issues (root user, COPY ., :latest tags, TLS disabled) and Kubernetes manifests for security context gaps (runAsNonRoot, capabilities, resource limits, privileged mode).

## Instructions

```bash
PYTHONPATH=~/Documents/darkscope/src python3 -c "
from darkscope.analyzers.container_deep import scan as scan_containers
from darkscope.analyzers.k8s_deep import scan as scan_k8s
from darkscope.scanner import _collect_files
from pathlib import Path

repo = Path('REPO_PATH').expanduser().resolve()
findings = scan_containers(repo)
config_files = _collect_files(repo, {'.yaml', '.yml'})
findings.extend(scan_k8s(config_files))
for f in findings:
    rel = f.file.split(str(repo) + '/')[-1] if str(repo) in f.file else f.file
    print(f'{f.severity:8s} {f.title}')
    print(f'         {rel}')
    print(f'         → {f.recommendation}')
    print()
print(f'Total: {len(findings)} container/K8s findings')
"
```

Group results by: Containerfile issues, then K8s manifest issues. Show specific fix for each.
