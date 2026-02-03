---
layout: default
title: Quick Reference
---

# Quick Reference

Common commands and workflows for RHDP Skills Marketplace.

---

## Installation Commands

```bash
# Add marketplace (choose one)
# If you have SSH keys configured for GitHub
/plugin marketplace add rhpds/rhdp-skills-marketplace

# If SSH not configured, use HTTPS
/plugin marketplace add https://github.com/rhpds/rhdp-skills-marketplace

# Install plugins
/plugin install showroom@rhdp-marketplace
/plugin install agnosticv@rhdp-marketplace
/plugin install health@rhdp-marketplace

# Update marketplace (interactive: select marketplace, press 'u')
/plugin marketplace update

# Update plugins (interactive: navigate to "Update now", press Enter)
/plugin update showroom@rhdp-marketplace
/plugin update agnosticv@rhdp-marketplace
/plugin update health@rhdp-marketplace
```

---

## Showroom Workflows

### Creating a Workshop Lab

```
1. /showroom:create-lab
2. Answer prompts (name, abstract, technologies, module count)
3. Review generated content
4. /showroom:verify-content
5. Fix any issues
6. /showroom:blog-generate (optional)
7. Publish
```

### Creating a Demo

```
1. /showroom:create-demo
2. Answer prompts (name, abstract, technologies)
3. Review generated content
4. /showroom:verify-content
5. Present or publish
```

---

## AgnosticV Workflows

### Creating a New Catalog

```
1. cd ~/work/code/agnosticv
2. /agnosticv:catalog-builder
3. Choose mode: 1 (Full Catalog)
4. Git workflow runs automatically (pulls main, creates branch)
5. Answer prompts (name, infrastructure, workloads)
6. Review generated files (auto-committed to branch)
7. git push origin <branch-name>
8. gh pr create --fill
9. Test in RHDP Integration
```

### Validating a Catalog

```
1. cd ~/work/code/agnosticv/<directory>/<catalog-name>
2. /agnosticv:validator
3. Review validation report
4. Fix errors and warnings
5. Re-validate
```

### Generating Catalog Description

```
1. Have Showroom content ready
2. /agnosticv:catalog-builder
3. Choose mode: 2 (Description Only)
4. Provide Showroom repo URL or local path
5. Review generated description.adoc
6. Auto-committed to branch
```

---

## Common File Locations

### Claude Code / VS Code with Claude

```
~/.claude/
├── plugins/             # Installed plugins
│   ├── installed/
│   │   ├── showroom@rhdp-marketplace/
│   │   ├── agnosticv@rhdp-marketplace/
│   │   └── health@rhdp-marketplace/
│   └── marketplaces/
│       └── rhdp-marketplace/
└── skills/              # Legacy skills (if migrating)
```

### Cursor

```
~/.cursor/
├── plugins/             # Installed plugins
└── skills/              # Legacy skills
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

### description.adoc (v1.8.0+ RHDP Structure - Nate's Format)

```asciidoc
Brief overview (3-4 sentences max). Start with product name, not catalog name.
Explain what this shows and intended use.

[IMPORTANT]
====
Warnings after overview (GPU required, beta/alpha features, limited support, etc.)
====

== Lab Guide

You can find a preview version of the link:<showroom-url>[lab guide^] here.

== Featured Technology and Products

* Red Hat OpenShift Container Platform {ocp_version}
* Technology {version}
* Product Name {version}

== Detailed Overview

* *Module 1 Title*
** Key learning point 1
** Key learning point 2
** Key learning point 3

* *Module 2 Title*
** Key learning point 1
** Key learning point 2

== Authors

* Author Name 1
* Author Name 2

== Support

For help with instructions or functionality, contact lab authors.

For problems with provisioning or environment stability:

* Open an RHDP link:https://red.ht/rhdp-ticket[Support Ticket^]
* Post a message in Slack channel: link:https://redhat.enterprise.slack.com/archives/C06QWD4A5TE[#forum-demo-redhat-com^]
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
# Check installed plugins
/plugin list

# Check marketplace
/plugin marketplace list

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
# Restart Claude Code
# Then verify installation:
/plugin list
```

### Need to Reinstall

```bash
# Uninstall plugins
/plugin uninstall showroom@rhdp-marketplace
/plugin uninstall agnosticv@rhdp-marketplace
/plugin uninstall health@rhdp-marketplace

# Reinstall
/plugin install showroom@rhdp-marketplace
/plugin install agnosticv@rhdp-marketplace
/plugin install health@rhdp-marketplace
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
- **Slack:** [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX)
- **Documentation:** [Full docs](https://rhpds.github.io/rhdp-skills-marketplace)
- **Changelog:** [Version history](https://github.com/rhpds/rhdp-skills-marketplace/blob/main/CHANGELOG.md)

---

[← Back to Home](../)
