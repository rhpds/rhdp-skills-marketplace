---
name: agnosticv:catalog-builder
description: Create or update AgnosticV catalog files (common.yaml, dev.yaml, description.adoc, info-message-template.adoc)
---

---
context: main
model: claude-opus-4-6
---

# Skill: agnosticv-catalog-builder

**Name:** AgnosticV Catalog Builder
**Description:** Create or update AgnosticV catalog files for RHDP deployments
**Version:** 2.1.0
**Last Updated:** 2026-02-03

---

## ⚠️ CRITICAL: Keep Questions Simple and Direct

**When asking for paths, URLs, or locations:**
- Just ask for the path or URL directly
- DO NOT ask about GitHub organizations, root folders, subdirectories, or try to find/detect them
- DO NOT offer multiple options to search or auto-detect
- Accept exactly what the user provides - don't try to be smart about it

**Example of what NOT to do:**
```
❌ Which GitHub organization? (rhpds / redhat-scholars / Other)
❌ Should I auto-detect your catalog directory? [Y/n]
❌ Which subdirectory should I use?
```

**Example of what TO do:**
```
✅ What is the URL or path to your Showroom repository?
✅ What is the path to the catalog/CI directory?
```

Just ask, use what they give you, move on. Users know their paths - trust them.

---

## Purpose

Unified skill for creating and updating AgnosticV catalog configurations. Handles everything from full catalog creation to updating individual files like description.adoc or info-message-template.adoc.

## Workflow Diagram

![Workflow](workflow.svg)

## What You'll Need Before Starting

Have these ready before running this skill:

**Choose your mode first:**
1. **Full Catalog** - Creating complete new catalog
2. **Description Only** - Just updating description.adoc
3. **Info Message Template** - Creating info-message-template.adoc
4. **Virtual CI** - Creating published/ Virtual CI

**For Full Catalog mode:**
- 📁 **AgnosticV repo path** - Where your local AgnosticV repository is (e.g., `~/work/code/agnosticv`)
- 🏢 **Catalog details**:
  - Display name (appears in RHDP UI)
  - Short name (directory name, lowercase with hyphens)
  - Brief description (1-2 sentences)
  - Category (workshop, demo, integration, etc.)
- 🔧 **Infrastructure choices**:
  - Cloud provider (AWS, Azure, OpenShift CNV, None)
  - Sandbox architecture (single-node, multi-node)
  - Workloads needed (which ocp4_workload_* roles)
- 🔗 **Showroom URL** (optional) - Link to your workshop/demo repository

**For Description Only mode:**
- 📁 **Showroom path or URL** - Where your workshop content is
- 📁 **Catalog directory path** - Where to save description.adoc
- 📋 **Module content** - Completed Showroom modules to extract from

**For Info Message Template:**
- 📁 **Catalog path** - Path to existing AgV catalog
- 📊 **User data keys** - List of data your workload shares via agnosticd_user_info

**For Virtual CI:**
- 📁 **Base component path** - Existing component to create Virtual CI from
- 🏷️ **Naming** - Virtual CI folder name (must be unique)

**Access needed:**
- ✅ Write permissions to AgnosticV repository
- ✅ Git configured with SSH access to GitHub
- ✅ RHDP account with AgnosticV repository access

---

## When to Use This Skill

Use `/agnosticv-catalog-builder` when you need to:

- Create a complete new RHDP catalog item
- Generate just description.adoc from Showroom content
- Create info-message-template.adoc for user data display
- Update catalog files after Showroom content changes
- Set up infrastructure provisioning for workshops/demos

**Prerequisites:**
- RHDP account with AgnosticV repository access
- AgnosticV repository cloned locally (e.g., `~/work/code/agnosticv` or `~/devel/git/agnosticv`)
- Git configured with SSH access to GitHub
- For description generation: Showroom content in `content/modules/ROOT/pages/`

---

## Skill Workflow Overview

```
Step 0: Prerequisites & Scope Selection
  ↓
  ├─ Full Catalog → Steps 1-10 (infrastructure + all files)
  ├─ Description Only → Steps 1-3 (extract from Showroom)
  └─ Info Message Template → Steps 1-2 (user data template)
```

---

## Step 0: Prerequisites & Scope Selection (FIRST)

**CRITICAL:** Start by asking what the user wants to generate.

### Ask for Scope

```
🏗️  AgnosticV Catalog Builder

What would you like to create or update?

1. Full Catalog (common.yaml, dev.yaml, description.adoc, info-message-template.adoc)
   └─ For: New catalog from scratch with infrastructure setup

2. Description Only (description.adoc)
   └─ For: Generate/update description from Showroom content

3. Info Message Template (info-message-template.adoc)
   └─ For: Display user data from your workload CI

4. Create Virtual CI (published/ folder)
   └─ For: Create Virtual CI from existing base component

Your choice [1-4]:
```

### Get AgnosticV Repository Path

Detect AgV path automatically by checking config files (`~/CLAUDE.md`, `~/claude/*.md`, `~/.claude/*.md`) for a line containing `agnosticv` with a path. If found, confirm with user. If not found, ask the user for their AgV repository path (e.g., `~/work/code/agnosticv`). Validate the path exists and is a git repo.

See `@agnosticv/docs/AGV-COMMON-RULES.md` for the full detection procedure.

### Git Branch Selection

```bash
cd "$agv_path"

# Show current branch
current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
```

**Ask about branch:**
```
📍 I see you are working on branch: $current_branch

Q: Do you want to use this branch or should I create a new one?

1. Use current branch: $current_branch
2. Create new branch

Choice [1/2]:
```

**If user chooses 1 (Use current branch):**
```
✓ Using your current branch: $current_branch
```

**If user chooses 2 (Create new branch):**
```
Q: New branch name (e.g., add-my-catalog or update-description):
   (no 'feature/' prefix needed)

Branch name:
```

```bash
# Strip feature/ prefix if user added it
branch_name="${branch_name#feature/}"

# Create and switch to new branch
git checkout -b "$branch_name"

echo "✓ Created and switched to branch: $branch_name"
```

---

## MODE 1: Full Catalog Creation

**When selected:** User chose option 1 (Full Catalog)

### Step 0.5: Context (REQUIRED — ask before anything else)

Ask these TWO questions sequentially before touching anything else.

**Question 1 — Type and Event (combined):**

```
🏗️  What type of catalog is this?

For Red Hat Summit 2026:
  1. Lab / Workshop   (Brand_Events, multi-user)
  2. Demo             (Brand_Events, single-user)

For Red Hat One 2026:
  3. Lab / Workshop   (Brand_Events, multi-user)
  4. Demo             (Brand_Events, single-user)

Standard (no event):
  5. Workshop         (multi-user, hands-on)
  6. Demo             (single-user, presenter-led)
  7. Sandbox          (self-service)

Choice [1-7]:
```

If 1–4 selected, ask immediately:
```
Q: Lab ID? (e.g., lb2298)
```

Auto-set from choice:

| Choice | event_name | category | multiuser |
|---|---|---|---|
| 1 | summit-2026 | Brand_Events | true |
| 2 | summit-2026 | Brand_Events | false |
| 3 | rh1-2026 | Brand_Events | true |
| 4 | rh1-2026 | Brand_Events | false |
| 5 | none | Workshops | true |
| 6 | none | Demos | false |
| 7 | none | Sandboxes | false |

**Question 2 — Technologies:**

```
Q: What technologies will users learn or see? (comma-separated)
   Examples: ansible, openshift ai, pipelines, gitops, kubevirt

Technologies:
```

Store: `event_name`, `lab_id`, `catalog_type`, `category`, `technologies`.

**Naming standards** (applied automatically from here):

| Item | Pattern | Example |
|---|---|---|
| AgnosticV directory | `<event-name>/<lab-id>-<short-name>-<cloud_provider>` | `summit-2026/lb1234-ocp-fish-swim-aws` |
| Showroom repo | `<short-name>-showroom` | `ocp-fish-swim-showroom` |
| Slack channel | `<event-name>-<lab-id>-<short-name>` | `summit-2026-lb1234-ocp-fish-swim` |

All GitHub repositories must be in `github.com/rhpds`.

**`__meta__` driven by event:**

| Event | `Brand_Event` label | keywords auto-added |
|---|---|---|
| summit-2026 | `Red_Hat_Summit_2026` | `summit-2026`, `<lab-id>` |
| rh1-2026 | `Red_Hat_One_2026` | `rh1-2026`, `<lab-id>` |
| No event | _(omit)_ | _(none)_ |

---

### Step 1: Catalog Discovery (Search Existing)

Using the type and technologies from Step 0.5, silently search `agd_v2/` and `openshift_cnv/`. No question needed — just search and show results.

```bash
# Search by technologies keywords in directory names and display_names
grep -rl "$technologies" "$AGV_PATH/agd_v2/" "$AGV_PATH/openshift_cnv/" \
  --include="common.yaml" -l 2>/dev/null \
  | xargs -I{} dirname {} | head -5
```

**Show results and ask ONE question:**

```
📖 Found similar catalogs:

1. agd_v2/ansible-aap-workshop/
   └─ Ansible Automation Platform Self-Service

2. openshift_cnv/ocp-cnv-kubevirt-demo/
   └─ KubeVirt Virtualization Demo

Would you like to use one of these as a reference? [Y/n]
```

**If YES:** `Which one? Enter number:`
Read that catalog's `common.yaml` — copy its workloads, collections, and infra as defaults. User can override anything.

**If NO or none found:** Proceed with fresh catalog from template.

### Step 2: Category *(auto — no question)*

Category is already determined from Step 0.5. Confirm internally:

| Type answered in Step 0.5 | Event? | Category set |
|---|---|---|
| Lab / Workshop | Yes | `Brand_Events` |
| Demo | Yes | `Brand_Events` |
| Lab / Workshop | No | `Workshops` |
| Demo | No | `Demos` |
| Sandbox | No | `Sandboxes` |

Multiuser auto-set: `Brand_Events` / `Workshops` → `true`, `Demos` → `false`.

### Step 3: UUID Generation (REQUIRED)

```
🔑 UUID Generation

Every catalog needs a unique RFC 4122 compliant UUID.

Generating UUID...
```

**Generate and validate:**
```bash
# Generate lowercase UUID
new_uuid=$(uuidgen | tr '[:upper:]' '[:lower:]')

# Check for collisions
echo "Generated: $new_uuid"
echo "Checking for collisions..."

# Search all common.yaml files
grep -r "asset_uuid: $new_uuid" $AGV_PATH/ --exclude-dir=.git

if [[ $? -eq 0 ]]; then
  echo "⚠️  Collision detected! Regenerating..."
  # Regenerate until unique
fi
```

### Step 4: Infrastructure Selection

Ask sequentially — ONE question at a time.

**Question A — Infrastructure type:**

```
🏗️  What type of infrastructure does this catalog need?

1. OpenShift cluster  (OCP-based — workshops, demos on OpenShift)
2. RHEL / AAP VMs     (cloud-vms-base — RHEL demos, AAP on VMs, non-OCP workloads)

Choice [1/2]:
```

---

**BRANCH 1: OpenShift cluster (choice 1)**

**Question B — Cluster size:**
```
Q: SNO or Multi-node?

1. Multi-node  (default — workshops, most demos)
2. SNO         (lightweight single-user demos, edge content)

Choice [1/2]:
```

*If SNO selected → force `multiuser: false`, skip Step 9 user count question.*

**Question C — OCP version:**
```
Q: Which OpenShift version?

1. 4.18
2. 4.20
3. 4.21 (latest)

Choice [1/2/3]:
```

**Question D — Custom pool:**
```
Q: Do you have a custom CNV pool allocated? [Y/n]

Default: agd-v2/ocp-cluster-cnv-pools/prod
```

**Question E — Auto-scale:** *(multi-node only)*
```
Q: Auto-scale workers based on num_users? [Y/n]
```

**Question F — AWS instead of CNV:** *(optional)*
```
Q: Do you need AWS instead of CNV? [Y/n]

AWS is only needed for GPU workloads or specific AWS-feature demos.
```
→ If YES: `Q: Do you have RHDP team approval for AWS? [Y/n]`
*(No approval → stop)*

**Generated config — CNV Multi-node:**
```yaml
config: openshift-workloads
cloud_provider: none

__meta__:
  components:
  - name: openshift
    display_name: OpenShift Cluster
    item: agd-v2/ocp-cluster-cnv-pools/prod   # or custom pool / aws-pools
    parameter_values:
      cluster_size: multinode                  # or sno
      host_ocp4_installer_version: "4.21"      # from Question C
      ocp4_fips_enable: false
      num_users: "{{ num_users }}"
    propagate_provision_data:
    - name: openshift_api_url
      var: openshift_api_url
    - name: openshift_cluster_admin_token
      var: openshift_api_key
```

*If auto-scale:* add `openshift_cnv_scale_cluster: true` and worker formula.

*If AWS:* change `cloud_provider: aws`, `cloud_provider_version: 1.0.0`, `config: openshift-cluster`, `item: agd-v2/ocp-cluster-aws-pools`.

---

**BRANCH 2: RHEL / AAP VMs (choice 2) — `cloud-vms-base`**

**Question B — Cloud provider for VMs:**
```
Q: Where should the VMs run?

1. CNV  (OpenShift Virtualization — VMs on CNV infrastructure)
2. AWS  (EC2 instances on AWS)

Choice [1/2]:
```
→ If AWS: `Q: Do you have RHDP team approval for AWS? [Y/n]`

**Question C — Bastion / VM image:**
```
Q: Which RHEL version for the bastion/VMs?

1. RHEL 9.6  (default)
2. RHEL 10   (latest)

Choice [1/2]:
```

**Question D — VM sizing:**
```
Q: VM cores and memory?

Common sizes:
1. Small   — 4 cores, 8Gi   (lightweight demos)
2. Medium  — 8 cores, 16Gi  (standard)
3. Large   — 16 cores, 32Gi (AAP, heavy workloads)

Choice [1/2/3]:
```

**Generated config — cloud-vms-base CNV:**
```yaml
config: cloud-vms-base
cloud_provider: openshift_cnv   # or: aws

bastion_instance_image: rhel-9.6   # from Question C

instances:
  - name: bastion
    count: 1
    image: "{{ bastion_instance_image }}"
    cores: 8         # from Question D
    memory: 16G
    image_size: 200Gi
```

### Step 5: Authentication Setup

Single unified workload for all authentication. Ask ONE question:

```
🔐 Authentication Provider

Which authentication provider?

1. htpasswd  (simple username/password — default, most common)
2. Keycloak  (RHBK — Red Hat Build of Keycloak, for multi-user workshops, AAP)

Note: RHSSO is not supported. Use Keycloak (RHBK) for SSO needs.

Q: Provider [1/2]:
```

**Workload is always the same — only the provider var changes:**

```yaml
workloads:
  - agnosticd.core_workloads.ocp4_workload_authentication
  # ... other workloads
```

**htpasswd config:**
```yaml
# Authentication provider
ocp4_workload_authentication_provider: htpasswd

# Admin account (password auto-generated if left empty)
ocp4_workload_authentication_admin_username: admin
ocp4_workload_authentication_admin_password: ""

# User accounts
ocp4_workload_authentication_num_users: "{{ num_users | default(0) }}"
ocp4_workload_authentication_user_password: ""
ocp4_workload_authentication_remove_kubeadmin: true
```

**Keycloak (RHBK) config:**
```yaml
# Authentication provider
ocp4_workload_authentication_provider: keycloak

# Admin account (password auto-generated if left empty)
ocp4_workload_authentication_admin_username: admin
ocp4_workload_authentication_admin_password: ""

# User accounts
ocp4_workload_authentication_num_users: "{{ num_users | default(0) }}"
ocp4_workload_authentication_user_password: ""
ocp4_workload_authentication_remove_kubeadmin: true

# Keycloak-specific settings
ocp4_workload_authentication_keycloak_channel: stable-v26.2
```

### Step 6: Workload Selection

Using the technologies from Step 0.5, recommend workloads silently. Present recommendations and confirm.

**Workload recommendation engine:**

Based on technologies already provided, suggest from `@agnosticv/docs/workload-mappings.md`:
- `ansible` or `aap` → `rhpds.aap25.ocp4_workload_aap25`
- `ai` or `gpu` → `rhpds.nvidia_gpu.ocp4_workload_nvidia_gpu`
- `gitops` or `argocd` → `rhpds.openshift_gitops.ocp4_workload_openshift_gitops`
- `pipelines` → `rhpds.openshift_pipelines.ocp4_workload_openshift_pipelines`
- `showroom` → `agnosticd.showroom.ocp4_workload_ocp_console_embed` + `agnosticd.showroom.ocp4_workload_showroom` (always recommended together)

**Present recommendations:**
```
Recommended workloads:

✓ agnosticd.core_workloads.ocp4_workload_authentication (selected - auth)
✓ agnosticd.showroom.ocp4_workload_ocp_console_embed (recommended - console embedding)
✓ agnosticd.showroom.ocp4_workload_showroom (recommended - guide)
  agnosticd.aap25.ocp4_workload_aap25 (suggested - ansible)
  agnosticd.openshift_gitops.ocp4_workload_openshift_gitops (suggested - gitops)

Select workloads (comma-separated numbers, or 'all'):
```

### Step 6.5: Collection Versions *(auto — no question)*

Use the `{{ tag }}` pattern — one variable controls all standard collection versions.

**In `common.yaml`, always generate:**
```yaml
# Tag for all repositories used in this config.
# Override in prod.yaml or event.yaml with a specific release tag.
tag: main
```

**All standard collections use `"{{ tag }}"` as version:**
```yaml
requirements_content:
  collections:
  - name: https://github.com/agnosticd/core_workloads.git
    type: git
    version: "{{ tag }}"
  # Add other collections as needed — all use "{{ tag }}"
```

**Showroom collection always uses a fixed pinned version — NOT `{{ tag }}`:**

Silently grep AgV repo for the highest pinned showroom version in use:
```bash
grep -r "agnosticd/showroom" "$AGV_PATH" --include="*.yaml" -h \
  | grep "version:" | grep -v "tag" | sort -V | tail -1
```

Use that version, or `v1.5.1` as minimum if nothing higher found:
```yaml
  - name: https://github.com/agnosticd/showroom.git
    type: git
    version: v1.5.1   # fixed — minimum v1.5.1, use highest found in AgV
```

**EE image:** Grep AgV for most recent `ee-multicloud` chained image in use and write directly to `__meta__.deployer.execution_environment.image`.

**In `prod.yaml`**, the developer overrides `tag` to pin a specific release:
```yaml
tag: my-catalog-1.0.0   # overrides main → pins all collections to this release
```

No question asked — all of this is generated automatically.

---

### Step 7: Showroom Configuration

**Ask for the Showroom repo:**

```
📚 Showroom repository

Based on naming convention, your Showroom repo should be:
  https://github.com/rhpds/<short-name>-showroom

Has this repository been created yet? [Y/n]
```

**If YES:**
```
Q: URL or local path to the Showroom repository:
```

- Local path → silently check 1.5.1 structure (`default-site.yml`, `supplemental-ui/` at root, `ui-config.yml`)
  - Pre-1.5.1 → block with migration instructions + `/showroom:create-lab --new`
- GitHub URL → note 1.5.1 requirement, continue

**If NO (not created yet):**

```
ℹ️  No problem. I'll add the recommended name as a placeholder.

Once created, update ocp4_workload_showroom_content_git_repo in common.yaml.
Remember: repository must be on Showroom 1.5.1+
Run: /showroom:create-lab --new  to scaffold the correct structure.
```

Add to common.yaml as placeholder:
```yaml
ocp4_workload_showroom_content_git_repo: https://github.com/rhpds/<short-name>-showroom
```

Continue without blocking.

**Dev mode** — set automatically, no question needed:
- `common.yaml`: `ocp4_workload_showroom_antora_enable_dev_mode: "false"`
- `dev.yaml`: `ocp4_workload_showroom_antora_enable_dev_mode: "true"`

**Generate complete Showroom section for common.yaml:**

```yaml
# ===================================================================
# Additional Collections & roles to be installed for this config
# ===================================================================
requirements_content:
  collections:
  # ... other collections ...
  # Showroom
  - name: https://github.com/agnosticd/showroom.git
    type: git
    version: v1.5.1

# -------------------------------------------------------------------
# Workloads
# -------------------------------------------------------------------
workloads:
# ... other workloads ...
- agnosticd.showroom.ocp4_workload_ocp_console_embed
- agnosticd.showroom.ocp4_workload_showroom

# -------------------------------------------------------------------
# Workload: ocp4_workload_showroom
# -------------------------------------------------------------------
ocp4_workload_showroom_content_git_repo: {{ showroom_repo_url }}
ocp4_workload_showroom_content_git_repo_ref: main
# Default antora playbook is default-site.yml, override here if needed
# ocp4_workload_showroom_content_antora_playbook: site.yml
# Dev mode is overridden in dev.yaml
ocp4_workload_showroom_antora_enable_dev_mode: "false"
```

**Generate dev.yaml Showroom section:**

```yaml
# -------------------------------------------------------------------
# Workload: ocp4_workload_showroom
# -------------------------------------------------------------------
ocp4_workload_showroom_antora_enable_dev_mode: "true"
```

**If NO (no Showroom repo):**
```
ℹ️  You can add the Showroom URL later in common.yaml
```

### Step 8: Catalog Details

```
📝 Catalog Details

Q: Display name (appears in RHDP UI):
   Example: Ansible Automation Platform with OpenShift AI

Name:

Q: Short name (lowercase, hyphens, descriptive):
   Example: ansible-aap-ai-workshop

Short name:

Q: Brief description (1-2 sentences):
   This appears in the catalog listing.

Description:

Q: Maintainer name and email?
   This goes into __meta__.owners.maintainer
   Example: Wolfgang Kulhanek / wkulhanek@redhat.com

Name:
Email:
```

**Validate directory doesn't exist across entire repo:**
```bash
# Check if directory name exists anywhere in AgV repo
if find "$AGV_PATH" -maxdepth 2 -type d -name "$short_name" 2>/dev/null | grep -q .; then
  echo "⚠️  Directory '$short_name' already exists in AgnosticV repo"
  echo "Choose a different name."
  exit 1
fi
```

### Step 8a: Repository Setup

**If no Showroom repo was provided in Step 7**, show creation instructions and pause:

```
📚 Create Showroom Repository (Showroom 1.5.1+ REQUIRED)

1. Create a new empty GitHub repo in github.com/rhpds
   Naming: {short-name}-showroom

2. Clone it locally and run: /showroom:create-lab --new
   Creates: default-site.yml, ui-config.yml, supplemental-ui/,
            content/lib/, .github/workflows/gh-pages.yml

   Reference: https://github.com/rhpds/lb2298-ibm-fusion

⚠️  Do NOT use showroom_template_nookbag — it is pre-1.5.1.

⏸️  Re-run this skill once the Showroom repo is ready.
```

**If Showroom repo URL was already provided in Step 7**, skip this step.

**Ask about custom Ansible collection:**
```
Q: Will this catalog use a custom Ansible collection? [Y/n]

ℹ️  Custom collections are needed when:
   - Creating new workloads specific to this catalog
   - Sharing workload logic across multiple catalogs
   - Building reusable automation components
```

**If YES:**
```
Collection naming: rhpds.{short-name}
Repository: https://github.com/rhpds/rhpds.{short-name}

Note:
- Collection must be created in github.com/rhpds organization
- Will be added to requirements_content in common.yaml
- Use this for catalog-specific workloads

Example structure:
  rhpds.{short-name}/
  ├── galaxy.yml
  ├── roles/
  │   └── ocp4_workload_{catalog_feature}/
  └── README.md
```

**If NO:**
```
✓ Using standard collections only (agnosticd.core_workloads, agnosticd.showroom, etc.)
```

### Step 9: Multi-User Configuration

```
👥 Multi-User Setup
```

**Auto-set based on category:**
- **Workshops / Brand_Events:** Multiuser REQUIRED
- **Demos:** Single-user only (multiuser: false)
- **Labs / Sandboxes:** Ask user

**If multi-user (Workshops/Brand_Events):**
```
Q: How many concurrent users (maximum)?
   Typical range: 10-60
   Default: 30

Max users [default: 30]:
```

**Set in common.yaml:**
```yaml
__meta__:
  catalog:
    multiuser: true
    workshopLabUiRedirect: true  # Auto-enable for workshops
    parameters:
      - name: num_users
        description: Number of users to provision within the environment
        formLabel: User Count
        openAPIV3Schema:
          type: integer
          default: 3
          minimum: 3
          maximum: 60
```

**Worker scaling formula (if CNV/SNO):**
```yaml
# Auto-scale workers based on num_users
openshift_cnv_scale_cluster: "{{ (num_users | int) > 3 }}"

# Per-user resource calculation
# Example: 1 worker per 5 users (adjust based on workload)
worker_instance_count: "{{ [(num_users | int / 5) | round(0, 'ceil') | int, 1] | max if (num_users | int) > 3 else 0 }}"

ai_workers_cores: 32
ai_workers_memory: 128Gi
```

**If single-user (Demos):**
```yaml
__meta__:
  catalog:
    multiuser: false  # Demos are always single-user
    # NO workshopLabUiRedirect for demos
```

### Step 10: Generate Files

Now generate all four files:

#### 10.1: Generate common.yaml

Read the template at `@agnosticv/skills/catalog-builder/templates/common.yaml.template` and use it as the base structure. Replace all `<placeholders>` with actual values collected from the user in previous steps.

#### 10.2: Generate dev.yaml

```yaml
---
# -------------------------------------------------------------------
# Purpose - Cost tag. One of development, ilt, production, event
# -------------------------------------------------------------------
purpose: development
__meta__:
  deployer:
    scm_ref: main
    scm_type: git
```

**Note:** dev.yaml is minimal — only overrides scm_ref and sets purpose tag for cost tracking.

#### 10.2a: Generate `__meta__` block (REQUIRED — ask sequentially)

The `__meta__` block is generated based on all information collected. Use the following rules exactly.

**NEVER define `anarchy.namespace`** — it is set at the top level of AgV now. Omit it entirely.

**Ask: deployer actions** (for workloads that touch resources OUTSIDE the cluster/sandbox):

```
Q: Does any workload in this catalog deploy or configure something
   outside the OpenShift cluster or sandbox? (e.g., external DNS,
   cloud resources, external registries) [Y/n]

If YES: which deployer actions should be disabled?
  - start  (set to true if base component handles start)
  - stop   (set to true if base component handles stop)
  - remove_workloads (set to true only if you DON'T want workload cleanup)

All default to false. Only set true to DISABLE that action.
```

Generate only the actions the user marks true:
```yaml
__meta__:
  deployer:
    actions:
      stop:
        disable: true    # only if user said yes
      start:
        disable: true    # only if user said yes
```

If user says No or unsure → omit `deployer.actions` entirely.

**deployer.ee** — use the current chained EE image (from summit-2026/lb2298-ibm-fusion reference):

```yaml
  deployer:
    scm_url: https://github.com/agnosticd/agnosticd-v2
    scm_ref: main
    execution_environment:
      image: quay.io/agnosticd/ee-multicloud:chained-2026-02-16
      pull: missing
```

**Ask: sandbox_api destroy behavior** (only if workload modifies external resources):

```
Q: Should remove_workloads run when the environment is destroyed?
   (Default: yes — set catch_all to false only if you want cleanup skipped)

Set catch_all to false? [Y/n]
```

If yes → add:
```yaml
  sandbox_api:
    actions:
      destroy:
        catch_all: false
```
If no → omit.

**catalog.reportingLabels** — always ask:

```
Q: What is the primary business unit (primaryBU)?

Common values:
- Hybrid_Platforms
- Application_Services
- OpenShift_AI
- Ansible
- Edge
- RHEL
- Middleware
- Cloud_Services

primaryBU:

Q: Secondary BU? (optional, press Enter to skip)

secondaryBU:
```

**catalog.labels.Brand_Event** — auto-set from event selection (Step 0.5):

| Event | Value |
|---|---|
| summit-2026 | `Red_Hat_Summit_2026` |
| rh1-2026 | `Red_Hat_One_2026` |
| No event | _(omit entirely)_ |

**catalog.keywords** — build from event + lab ID + user input:

```
Q: What specific keywords describe this catalog?
   (Do NOT add generic terms like "workshop", "openshift", or words already in the title)

Examples: ibm-fusion, cnv, kubevirt, rag, llm

Keywords:
```

Auto-add event keywords silently (user should not add these manually):
- summit-2026 → add `summit-2026` and `<lab-id>`
- rh1-2026 → add `rh1-2026` and `<lab-id>`

**catalog.labels.Product and Product_Family** — ask:

```
Q: What is the primary Red Hat product featured in this catalog?
   This goes into catalog.labels.Product

Common values:
- Red_Hat_OpenShift_Container_Platform
- Red_Hat_Ansible_Automation_Platform
- Red_Hat_OpenShift_AI
- Red_Hat_Enterprise_Linux

Product:

Q: Product family?
   Common values: Red_Hat_Cloud, Red_Hat_Automation, Red_Hat_Linux

Product_Family:
```

**catalog.workshopLabUiRedirect** — ask if applicable:

```
Q: Should users go directly to the Showroom URL when they claim a seat? [Y/n]
   (Only set if lab_ui_url is defined in the catalog)
```

If yes → set `workshopLabUiRedirect: true`.

**Full `__meta__` output:**

```yaml
__meta__:
  asset_uuid: <auto-generated>
  owners:
    maintainer:
    - name: <from Step 8>
      email: <from Step 8>
    instructions:
    - name: TBD
      email: tbd@redhat.com

  deployer:
    scm_url: https://github.com/agnosticd/agnosticd-v2
    scm_ref: main
    execution_environment:
      image: <latest ee-multicloud chained from AgV grep>
      pull: missing
    # actions:          # Only add if workload touches external resources
    #   stop:
    #     disable: true
    #   start:
    #     disable: true

  # sandbox_api:        # Only add if remove_workloads should be skipped
  #   actions:
  #     destroy:
  #       catch_all: false

  catalog:
    reportingLabels:
      primaryBU: <from Step 10.2a>
      # secondaryBU: <optional>
    namespace: babylon-catalog-{{ stage | default('?') }}
    display_name: "<from Step 8>"
    category: <auto from Step 0.5>
    keywords:
    - <event_name>      # auto: summit-2026 or rh1-2026 (event catalogs only)
    - <lab_id>          # auto: lbxxxx (event catalogs only)
    - <user keywords split from comma-separated input>
    labels:
      Product: <from Step 10.2a>
      Product_Family: <from Step 10.2a>
      Provider: RHDP
      # Brand_Event: Red_Hat_Summit_2026   # auto-set for event catalogs
    multiuser: <auto from Step 0.5>
    # workshopLabUiRedirect: true          # if user confirmed in Step 10.2a
```

**For no-event catalogs**: omit `Brand_Event` label and event keywords.

#### 10.3: Generate description.adoc

**Ask for description content:**
```
📄 Description Generation

I can extract description content from your Showroom, or you can provide it manually.

Q: Do you want me to extract from Showroom content? [Y/n]
```

**If YES and Showroom URL provided:**
```bash
# Clone showroom temporarily
temp_dir=$(mktemp -d)
git clone <showroom-url> "$temp_dir"

# Extract modules
find "$temp_dir/content/modules/ROOT/pages" -name "*.adoc" | sort

# Read module titles
grep "^= " "$temp_dir/content/modules/ROOT/pages"/*.adoc
```

Read the template and examples at `@agnosticv/skills/catalog-builder/templates/description.adoc.template`. Follow Nate's RHDP format exactly -- the template includes key guidelines and two real examples (demo + workshop).

#### 10.4: Generate info-message-template.adoc

```
📧 Info Message Template

This template displays user data after deployment.

Q: Does your catalog use agnosticd_user_info to share data? [Y/n]
```

**If YES:**
```
Q: What data keys does your workload share via agnosticd_user_info.data?

Examples:
  - litellm_api_base_url
  - litellm_virtual_key
  - grafana_admin_password

Data keys (comma-separated):
```

Read the template at `@agnosticv/skills/catalog-builder/templates/info-message.adoc.template`. It includes both variants (with and without user data) and explains how `agnosticd_user_info` works.

### Step 11: Determine Catalog Directory Path

**If event was selected (summit-2026 or rh1-2026):**

Auto-generate path from event, lab ID, short name, and cloud provider. No question needed.

```bash
# Pattern: <event-name>/<lab-id>-<short-name>-<cloud_provider>
# Example: summit-2026/lb2298-ocp-fish-swim-aws
directory_name="${lab_id}-${short_name}-${cloud_provider}"
catalog_path="$AGV_PATH/${event_name}/${directory_name}"
```

Show the user what will be created:
```
📂 Catalog path (from event + naming standards):
   summit-2026/lb2298-ocp-fish-swim-aws

Using: $catalog_path
```

**If no event (standard catalog):**

```
📂 Catalog Directory Path

Q: Which subdirectory should I create the catalog in?

Common options:
- agd_v2 (standard catalogs)
- openshift_cnv (CNV-based catalogs)
- sandboxes-gpte (sandbox catalogs)
- published (Virtual CIs)

Enter subdirectory (e.g., agd_v2):
```

```bash
catalog_path="$AGV_PATH/$subdirectory/$short_name"
```

**Validate doesn't exist:**
```bash
if [[ -d "$catalog_path" ]]; then
  echo "⚠️  Directory already exists: $catalog_path"
  echo "Choose a different name or location."
  exit 1
fi
```

### Step 12: Write Files

```
💾 Writing Files

Creating catalog directory: $catalog_path

Writing:
  ✓ common.yaml
  ✓ dev.yaml
  ✓ description.adoc
  ✓ info-message-template.adoc
```

**Execute:**
```bash
mkdir -p "$catalog_path"

# Write all four files
cat > "$catalog_path/common.yaml" <<'EOF'
<generated-content>
EOF

cat > "$catalog_path/dev.yaml" <<'EOF'
<generated-content>
EOF

cat > "$catalog_path/description.adoc" <<'EOF'
<generated-content>
EOF

cat > "$catalog_path/info-message-template.adoc" <<'EOF'
<generated-content>
EOF
```

### Step 13: Git Commit (Optional)

```
🚀 Ready to Commit

Files created in: $catalog_path

Q: Commit these changes? [Y/n]
```

**If YES:**
```bash
# Get relative path from AgV root for commit message
rel_path="${catalog_path#$AGV_PATH/}"

cd "$AGV_PATH"

git add "$rel_path/"

git commit -m "Add $directory_name catalog

- Category: $category
- Infrastructure: $cloud_provider ($sandbox_architecture)
- Workloads: $num_workloads selected
- UUID: $asset_uuid
- Path: $rel_path"

current_branch=$(git rev-parse --abbrev-ref HEAD)
echo "✓ Committed to branch: $current_branch"
echo ""
echo "Next steps:"
echo "  1. Test locally: cd $rel_path && agnosticv_cli dev.yaml"
echo "  2. Run validator: /agnosticv-validator"
echo "  3. Create PR: git push origin $current_branch && gh pr create --fill"
```

---

## MODE 2: Description Only

**When selected:** User chose option 2 (Description Only)

**Simplified workflow - just extract from Showroom and generate description.adoc**

### Step 1: Locate Showroom

**Ask directly for the path. DO NOT ask about GitHub org or try to find it yourself:**

```
📚 Showroom Content

Q: What is the path to your Showroom repository?

   💡 TIP: Use local paths to avoid GitHub API rate limits

   If you provide a GitHub URL, I'll need to clone it first.
   Local paths are faster and don't hit GitHub rate limits.

   Examples:
   - /Users/you/work/my-workshop-showroom (Recommended - local path)
   - ~/work/showroom-content/my-workshop (Recommended - local path)
   - . (current directory)
   - https://github.com/rhpds/my-workshop-showroom (Will clone locally first)

Path:
```

**If user provides GitHub URL:**
```
⚠️  GitHub URL Detected

You provided: <github-url>

GitHub API rate limits can cause issues. I'll clone this repository locally first.

Clone to: /tmp/showroom-<random>/

Proceed? [Y/n]
```

**If Yes:**
```bash
temp_dir=$(mktemp -d "/tmp/showroom-XXXXX")
git clone <github-url> "$temp_dir"

# Use temp_dir as path for rest of workflow
path="$temp_dir"
```

**If No:**
```
Q: Please provide a local path to your Showroom repository instead:

Local path:
```

**Validate:**
```bash
if [[ -d "$path/content/modules/ROOT/pages" ]]; then
  echo "✓ Found Showroom content"
  HAS_SHOWROOM=true
else
  echo "✗ No Showroom content found at: $path/content/modules/ROOT/pages"
  HAS_SHOWROOM=false
fi
```

**If no Showroom found, offer manual entry:**
```
⚠️  No Showroom Content Found

Mode 2 works best when you have Showroom content to extract from.

Options:
1. Enter description details manually (I'll ask you questions)
2. Create Showroom content first and come back
3. Exit and use Mode 1 (Full Catalog) instead

Your choice [1/2/3]:
```

**If option 2 (Create Showroom first):**
```
📚 Create Showroom Content First

Use the /create-lab or /create-demo skills to generate Showroom content:

For workshops:
  /create-lab

For demos:
  /create-demo

Once you have Showroom content, run this skill again with Mode 2.

⏸️  Exiting - Create Showroom content first.
```

**If option 3 (Use Mode 1):**
```
ℹ️  Mode 1 (Full Catalog) creates everything including description.adoc

Re-run this skill and select Mode 1 at the beginning.

⏸️  Exiting
```

**If option 1 (Manual entry), continue to Step 1a**

---

### Step 1a: Manual Entry (When No Showroom)

**Only run this step if HAS_SHOWROOM=false and user chose manual entry**

```
📝 Manual Description Entry (RHDP Structure)

Since you don't have Showroom content, I'll ask for all the details needed for description.adoc.
```

**1. Brief Overview (3-4 sentences max):**
```
Q: Brief overview (3-4 sentences):
   - Sentence 1: What is this showing or doing?
   - Sentence 2-3: What is the intended use? Business context?
   - Sentence 4: What do learners do/deploy?
   - Do NOT mention catalog name or generic info

   Example: "vLLM Playground demonstrates deploying and managing vLLM inference servers using containers with features like structured outputs and tool calling. This demo uses the ACME Corporation customer support scenario to show how Red Hat AI Inference Server modernizes AI-powered infrastructure. Learners deploy vLLM servers, configure structured outputs, and implement agentic workflows with performance benchmarking."

Overview:
```

**2. Warnings (optional):**
```
Q: Any warnings or special requirements? (optional)
   Examples: "GPU-enabled nodes recommended for optimal performance"
             "Beta release - features subject to change"
             "High memory usage - 32GB RAM minimum"

Warnings [press Enter to skip]:
```

**3. Guide Link:**
```
Q: Lab/Demo Guide URL:
   - Link to rendered Showroom (preferred)
   - Or link to repo/document if no Showroom yet

   Example: https://rhpds.github.io/my-workshop-showroom

Guide URL:
```

**4. Featured Products (max 3-4):**
```
Q: Featured Technology and Products (max 3-4, ONLY what matters):
   List the products that are the FOCUS of this asset with major versions.
   Do NOT list every product - only what matters.

   Example: "Red Hat Enterprise Linux 10, vLLM Playground 0.1.1, Red Hat AI"

Products [comma-separated with versions]:
```

**5. Module Details:**
```
Q: How many modules/chapters are in this lab/demo?

Module count:
```

**For each module, ask:**
```bash
for ((i=1; i<=module_count; i++)); do
  echo ""
  echo "=== Module $i Details ==="
  echo ""
  echo "Q: Module $i title:"
  read module_title

  echo ""
  echo "Q: Module $i details (2-3 bullets max, what do learners do?):"
  echo "   Enter bullets one per line, press Enter twice when done"
  echo ""

  bullets=()
  while IFS= read -r line; do
    [[ -z "$line" ]] && break
    bullets+=("$line")
  done

  # Store module data
  module_data["$i"]="$module_title|${bullets[*]}"
done
```

**6. Authors:**
```
Q: Lab/Demo authors (from __meta__.owners or manual entry):
   If this catalog has a common.yaml, I'll extract from __meta__.owners.
   Otherwise, enter author names (one per line, press Enter twice when done):

Authors:
```

**Capture authors:**
```bash
authors=()
while IFS= read -r line; do
  [[ -z "$line" ]] && break
  authors+=("$line")
done
```

**7. Support Information:**
```
Q: Content support Slack channel (where users get help with instructions):
   Example: #my-lab-support

Content Slack channel:

Q: Author Slack handle (to tag for content questions):
   Example: @john-smith

Author Slack handle:

Q: Author email (alternative to Slack):
   Example: jsmith@redhat.com

Author email [optional]:
```

**Set variables for Step 3:**
```bash
# For manual entry, set these variables
brief_overview="$overview_input"
warnings="$warnings_input"
guide_url="$guide_url_input"
featured_products="$products_input"
module_details=("${module_data[@]}")
authors=("${authors[@]}")
content_slack_channel="$content_slack_input"
author_slack_handle="$author_slack_handle_input"
author_email="$author_email_input"

# Skip Step 2 (extraction) and go directly to Step 3 (generate)
```

### Step 2: Extract Content from Showroom

**Only run this step if HAS_SHOWROOM=true (skip if manual entry)**

**IMPORTANT: Read ALL modules locally from filesystem to avoid GitHub rate limits**

GitHub API can hit rate limits when fetching files. Instead, we read all modules directly from the local filesystem, which is:
- ✅ Faster (no network calls)
- ✅ No rate limits
- ✅ Works offline
- ✅ Reads ALL modules comprehensively

**Read ALL modules and extract comprehensive information:**
```bash
# Get ALL modules from local filesystem (ensure we don't miss any)
# This reads files directly - NO GitHub API calls, NO rate limits
modules=$(find "$path/content/modules/ROOT/pages" -type f -name "*.adoc" \
  -not -name "index.adoc" \
  -not -name "*nav.adoc" \
  -not -name "workshop-overview.adoc" | sort)

# Count modules
module_count=$(echo "$modules" | grep -c "\.adoc$")

# Extract and display all module titles
echo "📚 Reading $module_count modules:"
module_titles=()
while IFS= read -r module; do
  if [[ -f "$module" ]]; then
    title=$(grep "^= " "$module" | head -1 | sed 's/^= //')
    echo "  * $title ($(basename "$module"))"
    module_titles+=("$title")
  fi
done <<< "$modules"

# Read ALL modules for comprehensive content extraction
echo ""
echo "📖 Analyzing all module content from local files..."
echo "   (Reading from filesystem - no GitHub API, no rate limits)"

# Combine all module content from local files (excluding index/nav)
# Direct file reading - fast, no network, no API limits
all_content=$(cat "$path/content/modules/ROOT/pages"/*.adoc 2>/dev/null | grep -v "^include::" | grep -v "^::")

# Extract overview from index.adoc first
if [[ -f "$path/content/modules/ROOT/pages/index.adoc" ]]; then
  index_overview=$(awk '
    /^= / { in_content=1; next }
    in_content && /^:/ { next }
    in_content && /^$/ { next }
    in_content && /^[A-Z]/ {
      print;
      for(i=1; i<=3; i++) {
        getline;
        if ($0 != "") print;
      }
      exit
    }
  ' "$path/content/modules/ROOT/pages/index.adoc" 2>/dev/null)
fi

# Extract key learning objectives from all modules
learning_objectives=$(echo "$all_content" | grep -E "learn|understand|configure|deploy|create|build|integrate|automate" | grep -v "^#" | head -10)

# Detect Red Hat product names across ALL modules
detected_products=$(echo "$all_content" | grep -hoE '(Red Hat )?OpenShift (Container Platform|Virtualization|AI|GitOps|Pipelines|Data Foundation)?|Ansible Automation Platform|(Red Hat )?Ansible( AI)?|Red Hat Enterprise Linux|RHEL [0-9.]+|Red Hat Device Edge|Red Hat Insights|Advanced Cluster Management|ACM|Red Hat Quay|Red Hat OpenShift Service Mesh|Red Hat AMQ|Red Hat Integration|Red Hat build of Keycloak|Red Hat OpenShift Data Foundation|Red Hat Advanced Cluster Security' 2>/dev/null | sort -u | head -15)

# Extract version numbers mentioned across ALL modules
version_info=$(echo "$all_content" | grep -hoE '(OpenShift|Ansible|RHEL|AAP|Kubernetes) [0-9]+\.[0-9]+|version [0-9]+\.[0-9]+' 2>/dev/null | sort -u | head -8)

# Detect key technical topics across ALL modules
technical_topics=$(echo "$all_content" | grep -hoE 'GitOps|CI/CD|Kubernetes|Operators|Helm|Service Mesh|Serverless|Tekton|ArgoCD|Prometheus|Grafana|Storage|Networking|Security|Multi-cluster' 2>/dev/null | sort -u | head -10)

# Get git author
author=$(git -C "$path" config user.name 2>/dev/null || echo "Unknown")

# Get GitHub Pages URL from remote
remote=$(git -C "$path" remote get-url origin 2>/dev/null)
if [[ -n "$remote" ]]; then
  github_pages_url=$(echo "$remote" | sed 's|git@github.com:|https://|' | sed 's|\.git$|/|' | sed 's|github.com/|rhpds.github.io/|')
else
  github_pages_url=""
fi

echo ""
echo "📊 Extracted from ALL modules (read from local filesystem):"
echo "  ✓ Modules analyzed: $module_count (all read locally - no GitHub API used)"
echo "  ✓ Module titles:"
for title in "${module_titles[@]}"; do
  echo "    - $title"
done
echo "  ✓ Author: $author"
echo "  ✓ GitHub Pages: $github_pages_url"
echo "  ✓ Red Hat Products detected:"
echo "$detected_products" | while read product; do
  [[ -n "$product" ]] && echo "    - $product"
done
if [[ -n "$version_info" ]]; then
  echo "  ✓ Versions found:"
  echo "$version_info" | while read version; do
    [[ -n "$version" ]] && echo "    - $version"
  done
fi
if [[ -n "$technical_topics" ]]; then
  echo "  ✓ Technical topics:"
  echo "$technical_topics" | while read topic; do
    [[ -n "$topic" ]] && echo "    - $topic"
  done
fi
```

### Step 3: Generate Description

**If HAS_SHOWROOM=true (extracted from Showroom):**

**Review comprehensive extracted content from ALL modules:**
```
📝 Description Content Review

I've read ALL $module_count modules locally (from filesystem - no GitHub API, no rate limits) and extracted the following:

Module Structure:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
${module_titles[@]}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Overview (from index.adoc):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$index_overview
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Red Hat Products Detected (from all modules):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$detected_products
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Versions Found (from all modules):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$version_info
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Technical Topics (from all modules):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$technical_topics
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Q: Is the extracted overview accurate? [Y to use as-is / N to provide custom]:

If N:
Q: Provide a brief overview (2-3 sentences, starting with product name):
   Base it on the module titles and content above.

Custom overview:

Q: Are the detected products/technologies/versions correct? [Y to use / N to customize]:

If N:
Q: Featured technologies (comma-separated with versions):
   Example: OpenShift 4.14, Ansible Automation Platform 2.5, Red Hat Enterprise Linux 9

   Detected: $detected_products $version_info

Custom technologies:

Q: Any warnings or special requirements? (optional)
   Examples: "Requires GPU nodes", "High memory usage", "Network-intensive"
   Based on: $technical_topics

Warnings [optional]:
```

**IMPORTANT:**
- ALL modules have been read and analyzed, not just index.adoc
- If user says Yes to extracted content, use it directly. Don't ask again!
- Show comprehensive data from all modules so user can make informed decisions
- Module titles, products, versions, and topics are extracted from the entire workshop content

---

**If HAS_SHOWROOM=false (manual entry):**

**Review manually entered content:**
```
📝 Description Content Review

You entered the following information:

Display Name:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$display_name
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Overview:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$index_overview
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Technologies:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$detected_products
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Modules ($module_count):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
${module_titles[@]}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Author: $author
GitHub Pages: ${github_pages_url:-"Not provided"}
Warnings: ${warnings:-"None"}

Q: Is this information correct? [Y to proceed / N to edit]:

If N, allow editing:
  Q: What would you like to edit?
     1. Overview
     2. Technologies
     3. Modules
     4. All of the above

  Choice [1-4]:
```

**After confirmation, proceed to generate description.adoc**

---

**Generate and write description.adoc** (same format as Mode 1, Step 10.3)

### Step 4: Locate Output Directory

**Ask directly for the path. DO NOT try to auto-detect, search, or ask about subdirectories:**

```
📂 Output Location

Q: What is the path to the catalog/CI directory where I should save description.adoc?

   Just provide the full path - I'll save the file there directly.

   Examples:
   - ~/work/code/agnosticv/agd_v2/my-workshop
   - /Users/you/code/agnosticv/catalogs/demo-catalog
   - agd_v2/my-catalog (relative to AgV repo)

Path:
```

**Write file and optionally commit** (same as Mode 1, Step 12)

---

## MODE 3: Info Message Template Only

**When selected:** User chose option 3 (Info Message Template)

### Step 1: Locate Catalog

**Ask directly for the path. DO NOT try to find it or ask about subdirectories:**

```
📂 Catalog Location

Q: What is the path to your AgV catalog directory?

   Examples:
   - ~/work/code/agnosticv/agd_v2/my-catalog
   - /path/to/agnosticv/catalogs/demo-catalog

Path:
```

### Step 2: User Data Configuration

```
📧 Info Message Template

This template uses data from agnosticd_user_info.

Q: Does your workload share data via agnosticd_user_info? [Y/n]
```

**If YES:**
```
Q: List the data keys your workload shares (comma-separated):

Examples:
  - litellm_api_base_url, litellm_virtual_key
  - grafana_url, grafana_password
  - custom_service_url, custom_api_key

Data keys:
```

**Generate template** (same as Mode 1, Step 10.4)

**Write file and optionally commit**

---

## MODE 4: Create Virtual CI

**When selected:** User chose option 4 (Create Virtual CI)

Create a Virtual CI in the `published/` folder based on an existing base component.

**What this mode does:**
- Creates Virtual CI in `published/<name>/` with common.yaml, dev.yaml, prod.yaml, description.adoc
- Copies description.adoc and templates from base component
- Adds dev restriction (`#include /includes/access-restriction-devs-only.yaml`) to base component
- Adds warning to base component's description.adoc
- Creates/updates base component's prod.yaml with scm_ref version (for production stability)
- Ensures `reportingLabels.primaryBU` is set on both Virtual CI and base component

**Bulk usage:** The user may provide multiple base component paths. Process each one sequentially.

### Step 1: Get Base Component Path

If not provided as argument, ask:

```
Q: What is the path to the base component?
   (Relative to AgV root, e.g., openshift_cnv/kafka-developer-workshop-cnv)

   You can provide multiple paths separated by spaces for bulk processing.

Path(s):
```

### Step 2: Locate and Read Base Component

For each base component path:

1. Path is relative to `$AGV_PATH` (detected from configuration files or user input)
2. Read `<base-component-path>/common.yaml`
3. If file doesn't exist, report error and skip (or stop if single component)

### Step 3: Derive Virtual CI Name

1. Take last segment of base component path (e.g., `kafka-developer-workshop-cnv`)
2. Check for known provider suffixes: `-cnv`, `-aws`, `-azure`, `-gcp`, `-sandbox`, `-pool`
3. If suffix exists, strip it to get Virtual CI name (e.g., `kafka-developer-workshop`)

**If no recognizable suffix:**
- Base component name doesn't have provider suffix
- **Cannot reuse base component folder name** — names must be unique across AgnosticV
- Ask: "The base component `<name>` doesn't have a provider suffix. What should the Virtual CI folder be named? (Must be unique across all of AgnosticV)"

**Uniqueness Check (CRITICAL):**

Folder names must be unique across **entire AgnosticV repository**.

**ALWAYS run this check:**
```bash
find "$AGV_PATH" -type d -name "<proposed-name>" 2>/dev/null
```

**If name already exists:**
- In `published/`: Ask if user wants to add to existing Virtual CI (multi-component)
- Elsewhere (agd_v2/, openshift_cnv/, etc.): Cannot use name, ask for alternative
- User can also skip this base component

### Step 4: Extract Information from Base Component

From base component's `common.yaml`, extract **only what exists** — do NOT invent values:

| Field | Action |
|-------|--------|
| `#include` statements | Copy icon include (e.g., `#include /includes/catalog-icon-*.yaml`) |
| `__meta__.asset_uuid` | Note it (Virtual CI needs NEW UUID) |
| `__meta__.owners` | Copy exactly as-is |
| `__meta__.catalog` | Copy exactly, modify `display_name` |
| `__meta__.catalog.display_name` | Remove provider suffix (e.g., "(CNV)", "(AWS)") |
| `__meta__.catalog.parameters` | Copy, update component references |

**IMPORTANT:** Do not generate missing fields. If required field missing, ask user.

**Special handling for `catalog.reportingLabels.primaryBU`:**

This field is **required** for reporting and must always be verified.

Known valid values (Feb 2026):
- Application_Developer
- Artificial_Intelligence
- Automation
- DEMO_Platform
- Edge
- Hybrid_Platforms
- RHDP
- RHEL

**Verification process:**

When asking about `primaryBU`, **always include base component path** (important for bulk processing):

1. **If present in base component:**
   - Ask: "For `<base-component-path>`: The base component has `primaryBU: <value>`. Is this correct, or should it be changed to one of: [list above]?"

2. **If NOT present:**
   - Ask: "For `<base-component-path>`: Missing `primaryBU`. What business unit should this be? Options: [list above]"
   - Add answer to **BOTH** Virtual CI **AND** base component's `common.yaml`

**When processing multiple base components:** Ask about each one separately with base component path in question.

**Icon include:** Look for `#include /includes/catalog-icon-*.yaml` in base component. Use same icon in Virtual CI. If not found, ask user.

### Step 5: Generate New UUID

```bash
uuidgen | tr '[:upper:]' '[:lower:]'
```

### Step 6: Determine Component Name

Component name in `__meta__.components`:
- Use last segment from base component path (e.g., `kafka-developer-workshop-cnv`)
- Becomes both `name` and used in `item` path

### Step 7: Create Virtual CI Files

Create folder: `$AGV_PATH/published/<virtual-ci-name>/`

#### common.yaml

```yaml
---
#include /includes/<icon-from-base-component>.yaml
#include /includes/terms-of-service.yaml
#include /includes/lifetime-standard.yaml

#include /includes/parameters/salesforce-id.yaml
#include /includes/parameters/purpose.yaml

# -------------------------------------------------------------------
#
# --- Catalog Item: <Display Name>
#
# No changes should be made to this CI, other than __meta__
# All changes to the functional CI should be made to the component(s)
#
# <base-component-path>
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# Babylon meta variables
# -------------------------------------------------------------------
__meta__:
  asset_uuid: <generated-uuid>
  owners:
    # Copy exactly from base component — do not modify or add fields
    maintainer:
    - name: <name>
      email: <email>

  catalog:
    # Copy exactly from base component, only modify display_name
    # Do NOT add fields that don't exist in base component
    namespace: babylon-catalog-{{ stage | default('?') }}
    display_name: "<clean-name-without-provider-suffix>"
    # ... copy remaining catalog fields exactly as they appear

  components:
  - name: <component-name>
    display_name: <Display Name with Provider>
    item: <base-component-path>

  deployer:
    type: null
```

#### dev.yaml

```yaml
# No config required
# See dev.yaml in component CI for details
```

#### prod.yaml

```yaml
# No config required
# See prod.yaml in component CI for details
```

#### test.yaml (only if base component has one)

```yaml
# No config required
# See test.yaml in component CI for details
```

#### description.adoc (REQUIRED)

Copy from base component exactly as-is:

```bash
cp "$AGV_PATH/<base-component-path>/description.adoc" \
   "$AGV_PATH/published/<virtual-ci-name>/description.adoc"
```

#### info-message-template.adoc (if exists)

```bash
cp "$AGV_PATH/<base-component-path>/info-message-template.adoc" \
   "$AGV_PATH/published/<virtual-ci-name>/info-message-template.adoc"
```

#### user-message-template.adoc (if exists)

```bash
cp "$AGV_PATH/<base-component-path>/user-message-template.adoc" \
   "$AGV_PATH/published/<virtual-ci-name>/user-message-template.adoc"
```

### Step 8: Update Base Component Files

#### 8a: Add dev restriction to common.yaml

Add to **top** of base component's `common.yaml` (after initial `---`):

```yaml
# This item is restricted to devs only!
# It should be ordered by regular users using the Virtual CI
# in the `published` directory.
#include /includes/access-restriction-devs-only.yaml
```

**Note:** If include already exists, skip.

#### 8b: Add warning to description.adoc

Add to **beginning** of base component's `description.adoc`:

```asciidoc
[WARNING]
====
Do not order this item unless you are a developer and are working on the CI.
Order the parent CI instead, which can be found link:https://catalog.demo.redhat.com/catalog?item=babylon-catalog-prod/published.<virtual-ci-name>.prod[here^].
====

```

Replace `<virtual-ci-name>` with actual Virtual CI folder name.

#### 8c: Create/Update prod.yaml with scm_ref version

**IMPORTANT:** For production stability, base components should pin `scm_ref` to a specific version.

**Ask user:**
```
📌 Production Version Pinning

Q: What scm_ref version should be used for production?
   (e.g., demyst-1.0.1, ocp-adv-1.0.0, build-secure-dev-0.0.1)

   Enter version tag (or press Enter to skip):
```

**If user provides version:**

Create or update `<base-component-path>/prod.yaml`:

```yaml
---
# -------------------------------------------------------------------
# Babylon meta variables
# -------------------------------------------------------------------
__meta__:
  deployer:
    scm_ref: <user-provided-version>
```

**If prod.yaml already exists:**
- Read existing file
- Check if `__meta__.deployer.scm_ref` exists
- If exists and different, ask: "prod.yaml already has scm_ref: <existing>. Replace with <new-version>? [Y/n]"
- Update only the scm_ref value, preserve other settings

**If user skips:**
- No prod.yaml created/updated
- Continue to next step

### Step 9: Handle Multiple Components

If adding to existing Virtual CI (multi-component):

1. Read existing Virtual CI's `common.yaml`
2. Add new base component to `__meta__.components` list
3. If `__meta__.catalog.parameters` has `components` arrays, add new component name
4. **Check conflicts:** If owners or catalog settings differ, ask for clarification

### Step 10: Validation

After creating files:

1. Verify YAML syntax is valid
2. Validate `__meta__` against schema at `$AGV_PATH/.schemas/babylon.yaml`
   - Ensure required fields present (e.g., `asset_uuid`)
   - Verify field types match schema
   - Check no unknown properties (`additionalProperties: false`)
3. Confirm `item` path points to existing base component
4. Verify `description.adoc` copied to Virtual CI
5. Verify dev restriction added to base component's `common.yaml`
6. Verify warning added to base component's `description.adoc`
7. Verify prod.yaml created/updated in base component (if version was provided)
8. Report what was created

### Output Format

```
Created Virtual CI: published/<name>
  - Base component: <base-component-path>
  - UUID: <generated-uuid>
  - Display name: "<clean-display-name>"
  - Icon: <icon-include-used>
  - Files created: common.yaml, dev.yaml, prod.yaml, description.adoc
  - Optional files copied: info-message-template.adoc, user-message-template.adoc (if existed)
  - Base component updated:
    - Added dev restriction to common.yaml
    - Added warning to description.adoc
    - Created/Updated prod.yaml with scm_ref: <version> (if provided)
```

### Error Handling

| Error | Action |
|-------|--------|
| No base component path | Ask user |
| Base component not found | Report path, suggest alternatives if similar exist |
| No provider suffix | Ask user for Virtual CI folder name (cannot reuse base name) |
| Name matches base component | Cannot use — ask alternative |
| Name exists in `published/` | Ask preference (add component, rename, skip) |
| Name exists elsewhere | Cannot use — ask alternative |
| No icon include | Ask user which icon |
| Missing `__meta__` in base | Report error, cannot create Virtual CI |
| Missing required field | Ask user — do not invent |
| Conflicting metadata (multi-component) | Ask which values to use |
| No description.adoc | Report error — required |

## Related Skills

- `/agnosticv:validator` -- Validate catalog configurations after creation
