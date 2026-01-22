---
layout: default
title: AgnosticV Namespace Setup
---

# AgnosticV Namespace Setup

Complete setup guide for RHDP provisioning skills.

---

## Overview

The **agnosticv** namespace provides AI-powered skills for managing RHDP catalog infrastructure provisioning and validation. These skills are designed for RHDP internal team members and advanced users who need to create and manage AgnosticV catalog items.

**Target Audience:** RHDP Internal/Advanced developers

---

## Installation

Install the agnosticv namespace:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | bash
# Select: agnosticv namespace (or all)
```

---

## Included Skills

### /agnosticv-catalog-builder

Create or update AgnosticV catalog files (unified skill).

**Modes:**
- Full Catalog - Generate all files (common.yaml, dev.yaml, description.adoc, info-message-template.adoc)
- Description Only - Extract from Showroom content
- Info Template - Document agnosticd_user_info usage

**Features:**
- Git workflow built-in (pull main, create branch)
- Workload recommendations
- UUID generation and validation
- Showroom content extraction

[View detailed documentation →](../skills/agnosticv-catalog-builder.html)

### /agnosticv-validator

Validate AgnosticV configurations against best practices and deployment requirements.

**Features:**
- Comprehensive validation checks
- UUID and YAML validation
- Workload dependency checking
- Infrastructure recommendations
- Best practice suggestions

[View detailed documentation →](../skills/agnosticv-validator.html)

---

## Prerequisites

### Required

- **Claude Code** or **Cursor** installed
- **RHDP account** with access to AgnosticV repository
- **AgnosticV repository** cloned to `~/work/code/agnosticv`
- **Git** configured with SSH access to GitHub

### Recommended

- **GitHub CLI** (`gh`) installed for PR creation
- **OpenShift CLI** (`oc`) for testing deployments
- **Ansible** knowledge for workload customization
- **RHDP Integration environment** access for testing

---

## Setup Steps

### 1. Clone AgnosticV Repository

```bash
cd ~/work/code
git clone git@github.com:rhpds/agnosticv.git
```

### 2. Verify Repository Structure

```bash
cd agnosticv
ls -la

# Should see:
# ├── agd_v2/           # AgnosticD v2 catalogs
# ├── enterprise/       # Enterprise catalogs
# ├── summit-2025/      # Event-specific catalogs
# └── .tests/           # Validation tests
```

### 3. Configure Git

```bash
git config user.name "Your Name"
git config user.email "your.email@redhat.com"
```

### 4. Install Skills

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | bash
# Select: agnosticv namespace
```

---

## Typical Workflow

```
1. /agnosticv-catalog-builder
   ↓ Creates catalog files (git workflow built-in)
   ↓ Generates: common.yaml, dev.yaml, description.adoc, info-message-template.adoc

2. /agnosticv-validator
   ↓ Validates configuration

3. Push and create PR (git already committed)
   ↓

4. Test in RHDP Integration environment
   ↓

5. Deploy via GitOps (Argo CD)
   ↓

6. /create-lab with UserInfo variables
   ↓ Generate workshop content using deployed resources
```

---

## Example: Creating a Catalog

### Step 1: Run /agnosticv-catalog-builder

```
In Claude Code or Cursor:
/agnosticv-catalog-builder

Choose mode: 1 (Full Catalog)
Git workflow: Pulls main, creates branch automatically
Answer prompts:
- AgnosticV path: ~/work/code/agnosticv
- Search similar catalogs
- Catalog name: "Agentic AI on OpenShift"
- Infrastructure: CNV multi-node
- Multi-user: Yes
- Workloads: OpenShift AI, LiteLLM, Showroom

Auto-commits to new branch
```

### Step 2: Review Generated Files

```bash
cd ~/work/code/agnosticv/agd_v2/agentic-ai-openshift

ls -la
# ├── common.yaml         # Main configuration
# ├── description.adoc    # Catalog description
# └── dev.yaml            # Development overrides
```

### Step 3: Push and Create PR

```bash
# /agnosticv-catalog-builder already committed to branch
git push origin your-branch-name
gh pr create --fill
```

### Step 4: Test in RHDP

1. Go to RHDP Integration environment
2. Search for your catalog
3. Deploy and verify
4. Extract UserInfo variables from deployment

### Step 5: Validate (if issues)

```
/agnosticv-validator

Checks:
✓ UUID format
✓ YAML syntax
✓ Workload dependencies
⚠️ Infrastructure recommendations
```

---

## AgnosticV Configuration

### Directory Structure

Choose appropriate directory for your catalog:

```
agnosticv/
├── agd_v2/           # Standard AgDv2 catalogs (most common)
├── enterprise/       # Enterprise-specific catalogs
└── summit-2025/      # Event-specific catalogs
```

### Infrastructure Selection

| Use Case | Infrastructure | When to Use |
|----------|---------------|-------------|
| Multi-user lab | CNV multi-node | Labs with 10+ users |
| Demo/POC | CNV SNO | Lightweight demos |
| GPU workloads | AWS | AI/ML requiring GPU |
| High memory | AWS | Resource-intensive apps |

### Authentication Methods

| Method | Use Case | Workload |
|--------|----------|----------|
| Keycloak | Multi-user labs | `ocp4_workload_authentication` |
| htpasswd | Demos, single user | `ocp4_workload_htpasswd` |

### Common Workloads

| Workload | Purpose | Collection |
|----------|---------|------------|
| Showroom (CNV) | Workshop guide | `rhpds.showroom` |
| Showroom (SNO) | Workshop guide (SNO) | `rhpds.showroom` |
| OpenShift AI | AI/ML platform | `agnosticd.core_workloads` |
| Pipelines | CI/CD | `agnosticd.core_workloads` |
| GitOps | Argo CD | `agnosticd.core_workloads` |
| LiteLLM | LLM access | `rhpds.litellm_virtual_keys` |

---

## UserInfo Variables

After deploying a catalog, extract variables for workshop content:

### From RHDP Portal

1. Go to **My Services**
2. Click on deployed service
3. Click **Details** → **Advanced settings**
4. Copy UserInfo variables

### Common Variables

```asciidoc
:openshift_console_url: {openshift_console_url}
:user: {user}
:password: {password}
:api_url: {api_url}
:user_namespace: {user_namespace}
:litellm_api_url: {litellm_api_url}
:litellm_api_key: {litellm_api_key}
```

### Use in create-lab/create-demo

After extracting UserInfo, use in content creation:

```
/create-lab

At Step 2.5, select:
Option 3: "I have UserInfo variables from a deployed catalog"

Paste UserInfo JSON or variables
```

---

## Best Practices

### Catalog Creation

1. **Search first** - Check for similar existing catalogs
2. **Use references** - Base on proven templates
3. **Test early** - Deploy to Integration before PR
4. **Validate always** - Run /agnosticv-validator before PR
5. **Document changes** - Clear commit messages

### Workload Selection

1. **Start minimal** - Add only required workloads
2. **Check dependencies** - Ensure collections are available
3. **Use latest versions** - Reference collection versions
4. **Test combinations** - Some workloads conflict

### Git Workflow

1. **Branch naming** - Use descriptive names (NO `feature/` prefix)
2. **Atomic commits** - One logical change per commit
3. **Test before push** - Validate locally first
4. **Clean commits** - No debug code or temp files

---

## Troubleshooting

### Repository Not Found

**Problem:** `/agnosticv-catalog-builder` can't find AgnosticV repo

**Solution:**
```bash
# Clone to correct location
cd ~/work/code
git clone git@github.com:rhpds/agnosticv.git
```

### UUID Collision

**Problem:** UUID already exists in repository

**Solution:**
```bash
# Generate new UUID
uuidgen
# Update common.yaml with new UUID
```

### Workload Not Found

**Problem:** Collection not available in requirements

**Solution:**
1. Check collection name spelling
2. Verify collection version exists
3. Check AgnosticD core_workloads repository

### Validation Fails

**Problem:** /agnosticv-validator reports errors

**Solution:**
1. Read error messages carefully
2. Fix errors one at a time
3. Re-validate after each fix
4. Ask in #forum-rhdp if stuck

---

## RHDP Integration Testing

### Deploy Catalog

1. Log in to RHDP Integration
2. Go to **Catalog**
3. Search for your catalog slug
4. Click **Order**
5. Fill in parameters
6. Click **Submit**

### Monitor Deployment

1. Go to **My Services**
2. Click on service
3. Monitor **Events** tab
4. Check for errors

### Extract UserInfo

1. Click **Details** tab
2. Click **Advanced settings**
3. Copy all UserInfo variables
4. Use in `/create-lab` or `/create-demo`

---

## Next Steps

- [View all skill documentation](../skills/)
- [Read AgnosticV common rules](https://github.com/rhpds/rhdp-skills-marketplace/blob/main/agnosticv/docs/AGV-COMMON-RULES.md)
- [Check workload mappings](https://github.com/rhpds/rhdp-skills-marketplace/blob/main/agnosticv/docs/workload-mappings.md)
- [Review infrastructure guide](https://github.com/rhpds/rhdp-skills-marketplace/blob/main/agnosticv/docs/infrastructure-guide.md)

---

[← Back to Setup](index.html) | [Showroom Setup ←](showroom.html)
