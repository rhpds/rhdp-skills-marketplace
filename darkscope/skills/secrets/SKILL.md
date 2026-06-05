---
name: darkscope:secrets
description: This skill should be used when the user asks to "check for secrets", "find API keys", "scan for leaked credentials", "check for hardcoded passwords", "find tokens in code", or "secret scan".
---

---
context: main
model: claude-sonnet-4-6
---

# Skill: darkscope:secrets

**Name:** DarkScope Secret Scanner
**Description:** Focused scan for hardcoded secrets, API keys, tokens, passwords, and high-entropy strings
**Version:** 1.0.0

---

## Purpose

Scan a repository specifically for hardcoded secrets — API keys, tokens, passwords, private keys, connection strings, and high-entropy strings that may be leaked credentials. Skips test files, lock files, security tooling configs, and placeholder values.

## Instructions

```bash
PYTHONPATH=~/Documents/darkscope/src python3 -c "
from darkscope.analyzers.secrets_scanner import scan
from darkscope.scanner import _collect_files
from pathlib import Path

repo = Path('REPO_PATH').expanduser().resolve()
files = _collect_files(repo, {'.py','.ts','.tsx','.js','.sh','.yaml','.yml','.json','.toml','.env'})
findings = scan(files)
for f in findings:
    rel = f.file.split(str(repo) + '/')[-1] if str(repo) in f.file else f.file
    print(f'{f.severity:8s} [{f.cwe}] {f.title}')
    print(f'         {rel}:{f.line}')
    print(f'         {f.code_snippet[:60]}')
    print()
print(f'Total: {len(findings)} secret findings')
"
```

Present findings grouped by severity. For each finding, show the file, line, redacted snippet, and recommendation.
