# AgnosticV Namespace

AI-powered skills for RHDP catalog infrastructure provisioning and validation.

---

## Overview

The **agnosticv** namespace provides skills for managing Red Hat Demo Platform (RHDP) catalog items with AgnosticV configuration. These skills help create, validate, and manage infrastructure provisioning for workshops and demos.

**Target Audience:** RHDP Internal/Advanced developers

**Focus:** Infrastructure provisioning, catalog management, validation

---

## Included Skills

### /agnosticv-catalog-builder

Create or update AgnosticV catalog files (unified skill).

**Modes:**
- **Mode 1: Full Catalog** - Generate all files (common.yaml, dev.yaml, description.adoc, info-message-template.adoc)
- **Mode 2: Description Only** - Extract from Showroom content
- **Mode 3: Info Template** - Document agnosticd_user_info usage

**Features:**
- Interactive catalog creation workflow
- Built-in git workflow (pull main, create branch without feature/ prefix)
- Reference catalog search by name or keywords
- Workload recommendations based on technology
- UUID generation and validation
- Showroom content extraction
- Auto-commit functionality

**Use When:**
- Creating new RHDP catalog items
- Updating catalog descriptions
- Creating info-message templates
- Need infrastructure provisioning setup

**Output:** Complete AgV catalog or individual files based on mode

[📚 Documentation](https://rhpds.github.io/rhdp-skills-marketplace/skills/agnosticv-catalog-builder.html)

---

### /agnosticv-validator

Validate AgnosticV configurations against best practices and requirements.

**Features:**
- Comprehensive validation checks
- UUID format and uniqueness validation
- YAML syntax checking
- Workload dependency verification
- Infrastructure recommendations
- Category correctness validation
- Best practice suggestions

**Use When:**
- Before creating PR for new catalog
- After editing catalog configuration
- Troubleshooting deployment issues
- Quality assurance reviews

**Output:** Validation report with errors, warnings, and suggestions

[📚 Documentation](https://rhpds.github.io/rhdp-skills-marketplace/skills/agnosticv-validator.html)

---

## Typical Workflows

### Creating a New Catalog

```
1. /agnosticv-catalog-builder
   ├─ Choose Mode 1 (Full Catalog)
   ├─ Git workflow (auto: pull main, create branch)
   ├─ Provide AgV repository path
   ├─ Search for similar catalogs (optional)
   ├─ Choose infrastructure (CNV/SNO/AWS)
   ├─ Select workloads based on technology
   ├─ Generate UUID
   ├─ Detect Showroom repository
   ├─ Generate all 4 files
   └─ Auto-commit to new branch

2. Review generated files
   ├─ common.yaml (main configuration)
   ├─ dev.yaml (development overrides)
   ├─ description.adoc (catalog description)
   └─ info-message-template.adoc (user notification)

3. Push and create PR
   ├─ git push origin <branch-name>
   └─ gh pr create --fill

4. Test in RHDP Integration
   ├─ Order catalog on integration.demo.redhat.com
   ├─ Wait for provisioning (1-2 hours)
   ├─ Extract UserInfo from Advanced settings
   └─ Test workshop/demo content

5. /agnosticv-validator (if issues found)
   └─ Fix errors and warnings

6. Request PR merge after successful testing
```

### Validating an Existing Catalog

```
1. cd ~/work/code/agnosticv/<directory>/<catalog-name>

2. /agnosticv-validator
   └─ Review validation report

3. Fix errors (MUST fix before deployment)

4. Address warnings (SHOULD fix for quality)

5. /agnosticv-validator (again)
   └─ Confirm all issues resolved
```

### Updating Catalog Description

```
1. Have Showroom content ready

2. /agnosticv-catalog-builder
   ├─ Choose Mode 2 (Description Only)
   ├─ Provide Showroom repo or local path
   ├─ Auto-extracts modules and technologies
   └─ Auto-commits to branch

3. Push changes
   └─ git push origin <branch-name>
```

---

## Prerequisites

### Required

- **RHDP account** with AgnosticV repository access
- **AgnosticV repository** cloned to `~/work/code/agnosticv`
- **Git** configured with SSH access to GitHub
- **Claude Code** or **Cursor** installed

### Recommended

- **GitHub CLI** (`gh`) for PR creation
- **OpenShift CLI** (`oc`) for testing deployments
- **Ansible** knowledge for workload customization
- **RHDP Integration** environment access for testing

---

## Directory Structure

```
~/work/code/agnosticv/
├── agd_v2/                   # Standard AgDv2 catalogs (most common)
│   └── <catalog-slug>/
│       ├── common.yaml       # Main configuration
│       ├── description.adoc  # Catalog description
│       └── dev.yaml          # Development overrides
│
├── enterprise/               # Enterprise-specific catalogs
├── summit-2025/             # Event-specific catalogs
└── .tests/                  # Validation tests
    └── babylon_checks.py
```

---

## AgV Configuration Files

### common.yaml

Main catalog configuration:

```yaml
---
# AgnosticV includes
#include /includes/agd-v2-mapping.yaml
#include /includes/sandbox-api.yaml

# Repository Tag
tag: main

# Infrastructure
cloud_provider: none
config: openshift-workloads

# Collections
requirements_content:
  collections:
  - name: https://github.com/agnosticd/core_workloads.git
    type: git
    version: main

# Workloads
workloads:
- agnosticd.core_workloads.ocp4_workload_authentication_htpasswd
- agnosticd.showroom.ocp4_workload_showroom

# Metadata
__meta__:
  asset_uuid: <UUID>
  catalog:
    display_name: "<Name>"
    category: Workshops  # or Demos
    keywords:
    - keyword1
    - keyword2
    multiuser: true
```

### description.adoc

Catalog description for RHDP portal:

```asciidoc
= Catalog Display Name

Brief description of workshop/demo purpose.

== Prerequisites

* Basic knowledge of technology
* Familiarity with concepts

== What You'll Learn

* Learning outcome 1
* Learning outcome 2
* Learning outcome 3

== Environment Details

* OpenShift {ocp_version}
* Product {version}
```

### dev.yaml

Development overrides for testing:

```yaml
---
purpose: development

# Override for testing branches
# ocp4_workload_showroom_content_git_repo_ref: feature-branch

# Smaller deployment for dev
# num_users: 2
```

---

## Infrastructure Selection Guide

| Infrastructure | Best For | Provision Time | Cost |
|----------------|----------|----------------|------|
| **CNV (multi-node)** | Multi-user labs, most workshops | 10-15 min | $$ |
| **SNO** | Edge demos, lightweight single-user | 5-10 min | $ |
| **AWS** | GPU workloads, large memory | 30-45 min | $$$ |

**Decision Tree:**
- Need GPU? → AWS
- Edge computing demo? → SNO
- Multi-user lab? → CNV
- Single-user demo? → CNV or SNO

[📄 Full Infrastructure Guide](docs/infrastructure-guide.md)

---

## Workload Mappings

Quick reference for technology → workload mapping:

| Technology | Workloads |
|------------|-----------|
| **AI/ML** | openshift_ai, litellm_virtual_keys |
| **Pipelines** | pipelines, gitea_operator |
| **GitOps** | openshift_gitops |
| **Security** | acs |
| **Developer** | devspaces |
| **Observability** | observability, logging |

[📄 Full Workload Mappings](docs/workload-mappings.md)

---

## Common Rules

All skills follow shared contracts defined in:

**📄 `agnosticv/docs/AGV-COMMON-RULES.md`**

Key rules:
- AgnosticV configuration workflow
- Git workflow requirements (branch naming, commits)
- UUID generation (REQUIRED, unique)
- Showroom repository detection (HTTPS format)
- Directory selection (agd_v2/ default)
- Category validation (Workshops vs Demos)
- Testing confirmation before module creation

---

## Best Practices

### Catalog Creation

1. **Search first** - Check for similar existing catalogs before creating new
2. **Use references** - Base new catalogs on proven templates
3. **Test early** - Deploy to Integration before PR
4. **Validate always** - Run `/agnosticv-validator` before creating PR
5. **Document changes** - Clear commit messages explaining purpose

### Workload Selection

1. **Start minimal** - Add only required workloads
2. **Check dependencies** - Ensure all collections are available
3. **Use latest versions** - Reference current collection versions
4. **Test combinations** - Some workloads may conflict

### Git Workflow

1. **Branch naming** - Use descriptive names (NO `feature/` prefix)
2. **Atomic commits** - One logical change per commit
3. **Test before push** - Validate locally first with `/agnosticv-validator`
4. **Clean commits** - No debug code or temporary files

### Category Selection

Valid categories:
- **Workshops** - Multi-user hands-on labs
- **Demos** - Presenter-led demonstrations
- **Sandboxes** - Self-service playground environments

Choose based on primary use case and audience.

---

## Troubleshooting

### Repository Not Found

**Symptom:** Skill can't find AgnosticV repo

**Solution:**
```bash
cd ~/work/code
git clone git@github.com:rhpds/agnosticv.git
```

### UUID Collision

**Symptom:** UUID already exists

**Solution:**
```bash
uuidgen  # Generate new UUID
# Update common.yaml with new UUID
```

### Validation Fails

**Symptom:** `/agnosticv-validator` reports errors

**Solution:**
1. Read error messages carefully
2. Fix **ERRORS** first (blocking)
3. Address **WARNINGS** (best practices)
4. Re-validate after fixes

### Wrong Category

**Symptom:** Validator reports incorrect category

**Solution:**
Update `__meta__.catalog.category` in `common.yaml`:
- Use "Workshops" for multi-user labs
- Use "Demos" for presenter-led content
- Use "Sandboxes" for self-service environments

---

## RHDP Integration Testing

### Deploy Catalog

1. Log in to https://integration.demo.redhat.com
2. Search for your catalog by display name
3. Click "Order"
4. Fill in parameters (num_users, etc.)
5. Click "Submit"

### Monitor Deployment

1. Go to "My Services"
2. Click on your service
3. Monitor "Events" tab for progress
4. Check for errors

### Extract UserInfo

1. Once deployed, click "Details" tab
2. Click "Advanced settings"
3. Copy all UserInfo variables
4. Use in `/create-lab` or `/create-demo` for workshop content

**Timeline:**
- Environment provisioning: 1-2 hours (can take longer)
- Testing: Before requesting PR merge
- Stage deploy: ~4 hours after PR merge
- Production: After approval

---

## Support

- **Documentation:** https://rhpds.github.io/rhdp-skills-marketplace
- **GitHub Issues:** https://github.com/rhpds/rhdp-skills-marketplace/issues
- **Slack:** #forum-rhdp or #forum-rhdp-content
- **AgnosticV Repo:** https://github.com/rhpds/agnosticv

---

## Related Namespaces

- [**showroom**](../showroom/README.md) - Content creation for workshops and demos
- [**health**](../health/README.md) - Post-deployment validation and health checks
- [**automation**](../automation/README.md) - Intelligent automation and workflow orchestration

---

**Version:** v1.0.0
**Last Updated:** 2026-01-22
**Maintained By:** RHDP Team
