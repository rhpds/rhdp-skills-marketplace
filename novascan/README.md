# NovaScan — RHDP Capacity Scanner

Scan any demo repository and produce right-sized RHDP provisioning recommendations. Detects LLM models, application infrastructure, resource requirements, and generates ready-to-commit AgnosticV catalog items.

## Skills

| Skill | Description |
|-------|-------------|
| `/novascan:scan` | Scan a repo for provisioning requirements |
| `/novascan:plan` | Generate capacity plan with lab sizing |
| `/novascan:generate` | Create AgnosticV catalog item from scan |
| `/novascan:validate` | Compare scan vs existing AgnosticV config |

## Installation

```
/plugin install novascan@rhdp-marketplace
```

## Prerequisites

NovaScan must be cloned locally:

```bash
git clone https://github.com/rhpds/NovaScan.git ~/Documents/novascan
```

## Repository

https://github.com/rhpds/NovaScan
