# DarkScope — Deep Security Analysis

Multi-layer security scanner for demo repositories. Combines AST-level code analysis, secret detection with entropy scoring, container and Kubernetes hardening checks, and supply chain CVE auditing.

## Skills

| Skill | Description |
|-------|-------------|
| `/darkscope:scan` | Scan a repo for security vulnerabilities |
| `/darkscope:audit` | Full security audit with all layers |

## Installation

```
/plugin install darkscope@rhdp-marketplace
```

## Prerequisites

DarkScope must be cloned locally:

```bash
git clone https://github.com/rhpds/DarkScope.git ~/Documents/darkscope
```
