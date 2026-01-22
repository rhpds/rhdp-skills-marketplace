---
layout: default
title: Quick Reference
---

# Quick Reference

Common commands and workflows for RHDP Skills Marketplace.

---

## Installation Commands

```bash
# Interactive installation
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | bash

# Install showroom namespace for Claude Code
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | \
  bash -s -- --platform claude --namespace showroom

# Install all namespaces for Cursor
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | \
  bash -s -- --platform cursor --namespace all

# Dry run (test without installing)
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | \
  bash -s -- --dry-run

# Check for updates
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/update.sh | bash
```

---

## Showroom Workflows

### Creating a Workshop Lab

```
1. /create-lab
2. Answer prompts (name, abstract, technologies, module count)
3. Review generated content
4. /verify-content
5. Fix any issues
6. /blog-generate (optional)
7. Publish
```

### Creating a Demo

```
1. /create-demo
2. Answer prompts (name, abstract, technologies)
3. Review generated content
4. /verify-content
5. Present or publish
```

---

## AgnosticV Workflows

### Creating a New Catalog

```
1. cd ~/work/code/agnosticv
2. git checkout main && git pull origin main
3. /agv-generator
4. Answer prompts (name, infrastructure, workloads)
5. Review generated files
6. git checkout -b <catalog-name>
7. git add agd_v2/<catalog-name>/
8. git commit -m "Add <catalog-name> catalog"
9. git push origin <catalog-name>
10. gh pr create --fill
11. Test in RHDP Integration
```

### Validating a Catalog

```
1. cd ~/work/code/agnosticv/<directory>/<catalog-name>
2. /agv-validator
3. Review validation report
4. Fix errors and warnings
5. Re-validate
```

### Generating Catalog Description

```
1. Have Showroom content ready
2. /generate-agv-description
3. Provide Showroom repo URL or local path
4. Review generated description.adoc
5. Copy to AgnosticV catalog directory
```

---

## Common File Locations

### Claude Code

```
~/.claude/
├── skills/               # Installed skills
│   ├── create-lab/
│   ├── create-demo/
│   ├── verify-content/
│   ├── blog-generate/
│   ├── agv-generator/
│   ├── agv-validator/
│   ├── generate-agv-description/
│   └── validation-role-builder/
└── docs/                # Skill documentation
    ├── SKILL-COMMON-RULES.md
    └── AGV-COMMON-RULES.md
```

### Cursor

```
~/.cursor/
├── skills/              # Installed skills
└── docs/                # Skill documentation
```

### AgnosticV Repository

```
~/work/code/agnosticv/
├── agd_v2/              # Standard catalogs
│   └── <catalog-name>/
│       ├── common.yaml
│       ├── description.adoc
│       └── dev.yaml
├── enterprise/          # Enterprise catalogs
└── summit-2025/         # Event catalogs
```

---

## Showroom Content Structure

```
showroom-repo/
├── content/
│   └── modules/
│       └── ROOT/
│           ├── pages/
│           │   ├── index.adoc
│           │   ├── module-01.adoc
│           │   ├── module-02.adoc
│           │   └── module-03.adoc
│           ├── partials/
│           │   └── _attributes.adoc
│           └── nav.adoc
└── antora.yml
```

---

## AgnosticV Catalog Structure

### common.yaml

```yaml
---
__meta__:
  asset_uuid: <UUID>
  catalog:
    display_name: "<Name>"
    abstract: "<Abstract>"
  deployer: babylon

workloads:
  - <collection>.<role>

requirements_content:
  collections:
    - name: <collection>
      version: ">=1.0.0"
```

### description.adoc

```asciidoc
= Catalog Display Name

Abstract starting with product name...

== Showroom Guide

link:<showroom-url>[Access workshop guide]

== Featured Technology

* OpenShift {ocp_version}
* Technology {version}
```

---

## Common AsciiDoc Attributes

```asciidoc
:openshift_console_url: <console-url>
:user: <username>
:password: <password>
:api_url: <api-url>
:user_namespace: <namespace>
:litellm_api_url: <litellm-url>
:litellm_api_key: <api-key>
```

---

## Git Commands for AgnosticV

```bash
# Start new catalog
cd ~/work/code/agnosticv
git checkout main
git pull origin main
git checkout -b <catalog-name>

# Commit changes
git status
git add <directory>/<catalog-name>/
git commit -m "Add <catalog-name> catalog"
git push origin <catalog-name>

# Create PR
gh pr create --fill

# Clean up after merge
git checkout main
git pull origin main
git branch -d <catalog-name>
```

---

## Verification Commands

```bash
# Check installed skills
ls ~/.claude/skills/        # Claude Code
ls ~/.cursor/skills/        # Cursor

# Check version
cat ~/.claude/skills/.rhdp-marketplace-version
cat ~/.cursor/skills/.rhdp-marketplace-version

# Check AgnosticV repo
cd ~/work/code/agnosticv && git status

# Validate YAML syntax
yamllint common.yaml

# Test Showroom locally
npm run dev
```

---

## Troubleshooting Quick Fixes

### Skills Not Showing

```bash
# Restart editor
# Then verify installation:
ls ~/.claude/skills/
```

### Wrong Platform Installed

```bash
# Reinstall with correct platform
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | \
  bash -s -- --platform <claude|cursor> --namespace <namespace>
```

### AgnosticV Repo Not Found

```bash
cd ~/work/code
git clone git@github.com:rhpds/agnosticv.git
```

### UUID Collision

```bash
# Generate new UUID
uuidgen
# Update common.yaml:__meta__:asset_uuid
```

---

## Support Resources

- **GitHub Issues:** [Report bugs](https://github.com/rhpds/rhdp-skills-marketplace/issues)
- **Slack:** #forum-rhdp or #forum-rhdp-content
- **Documentation:** [Full docs](https://rhpds.github.io/rhdp-skills-marketplace)
- **Changelog:** [Version history](https://github.com/rhpds/rhdp-skills-marketplace/blob/main/CHANGELOG.md)

---

[← Back to Home](../)
