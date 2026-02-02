---
name: agnosticv-catalog-builder
description: Create or update AgnosticV catalog files (common.yaml, dev.yaml, description.adoc, info-message-template.adoc)
---

---
context: main
model: sonnet
---

# Skill: agnosticv-catalog-builder

**Name:** AgnosticV Catalog Builder
**Description:** Create or update AgnosticV catalog files for RHDP deployments
**Version:** 2.0.1
**Last Updated:** 2026-01-22

---

## Purpose

Unified skill for creating and updating AgnosticV catalog configurations. Handles everything from full catalog creation to updating individual files like description.adoc or info-message-template.adoc.

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
- AgnosticV repository cloned locally (`~/work/code/agnosticv`)
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

Your choice [1-3]:
```

### Ask for AgnosticV Repository Path

```
Q: What is your AgnosticV repository directory path?

Example paths:
- ~/work/code/agnosticv/
- ~/projects/agnosticv/

Your AgV path: [Enter full path]
```

**Validate path exists:**
```bash
ls -la /path/to/agnosticv/agd_v2/
```

### Git Workflow Setup (REQUIRED FOR ALL MODES)

**IMPORTANT:** Always pull latest and create a new branch.

```
🔧 Git Workflow Setup

Before we start, let's ensure you're working on a clean branch.

I'll do the following:
1. Pull latest changes from main
2. Create a new feature branch for your catalog

Branch naming: Use descriptive names WITHOUT 'feature/' prefix
  Good: add-ansible-ai-workshop
  Good: update-ocp-pipelines-description
  Bad: feature/add-workshop
```

**Execute git workflow:**
```bash
cd /path/to/agnosticv

# Check current branch
current_branch=$(git rev-parse --abbrev-ref HEAD)

# If not on main, warn user
if [[ "$current_branch" != "main" ]]; then
  echo "⚠️  You're currently on branch: $current_branch"
  echo "We need to switch to main first."
  read -p "Switch to main and pull latest? [Y/n] " confirm
  if [[ ! "$confirm" =~ ^[Nn] ]]; then
    git checkout main
  fi
fi

# Pull latest
echo "📥 Pulling latest changes from main..."
git pull origin main

# Ask for branch name
echo ""
echo "Q: What should we name your branch?"
echo "   (Use format: add-<catalog-name> or update-<catalog-name>-description)"
read -p "Branch name: " branch_name

# Validate branch name doesn't have feature/
if [[ "$branch_name" =~ ^feature/ ]]; then
  echo "⚠️  Remove 'feature/' prefix. Just use: ${branch_name#feature/}"
  read -p "Branch name (without feature/): " branch_name
fi

# Create branch
echo "🌿 Creating branch: $branch_name"
git checkout -b "$branch_name"
```

---

## MODE 1: Full Catalog Creation

**When selected:** User chose option 1 (Full Catalog)

### Step 1: Catalog Discovery (Search Existing)

Search for similar catalogs to learn from or use as reference.

```
📖 Catalog Discovery

Let me search for existing catalogs to help you.

Q: What keywords describe your catalog?
   (Examples: ansible, openshift ai, pipelines, gitops)

Keywords:
```

**Search logic:**
```bash
cd $AGV_PATH/agd_v2

# Search by keywords in:
# - Directory names
# - common.yaml display names
# - description.adoc content

find . -type f -name "common.yaml" | while read file; do
  dir=$(dirname "$file")
  name=$(grep "^name:" "$file" | cut -d':' -f2-)
  echo "$dir: $name"
done | grep -i "$keywords"
```

**Present results and ask:**
```
Found similar catalogs:

1. agd_v2/ansible-aap-workshop/
   └─ Ansible Automation Platform Self-Service

2. agd_v2/openshift-gitops-intro/
   └─ OpenShift GitOps Introduction

Do you want to:
A. Create new catalog from scratch
B. Use one as reference (copy structure)
C. Just browse and continue

Choice [A/B/C]:
```

### Step 2: Category Selection (REQUIRED)

```
📂 Category Selection

RHDP catalogs MUST have exactly one category:

1. Workshops - Multi-user hands-on learning with exercises
2. Demos - Single-user presenter-led demonstrations
3. Labs - General learning environments
4. Sandboxes - Self-service playground environments
5. Brand_Events - Events like Red Hat Summit, Red Hat One

Q: Which category? [1-5]:
```

**Validate:** Must be one of: `Workshops`, `Demos`, `Labs`, `Sandboxes`, `Brand_Events` (exact match)

**Important validation rules:**
- Workshops/Brand_Events → Must set multiuser: true
- Demos → Must set multiuser: false (single-user only)

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
grep -r "asset_uuid: $new_uuid" $AGV_PATH/agd_v2/

if [[ $? -eq 0 ]]; then
  echo "⚠️  Collision detected! Regenerating..."
  # Regenerate until unique
fi
```

### Step 4: Infrastructure Selection

```
🏗️  Infrastructure Selection

Choose your OpenShift deployment type:

1. CNV Multi-Node (Standard - Recommended for most)
   └─ Full OpenShift cluster on CNV pools
   └─ Best for: Multi-user workshops, complex workloads
   └─ Component: agd-v2/ocp-cluster-cnv-pools/prod

2. SNO (Single Node OpenShift)
   └─ Single-node cluster for lightweight demos
   └─ Best for: Quick demos, single-user environments, edge demos
   └─ Component: agd-v2/ocp-cluster-cnv-pools/prod (cluster_size: sno)

3. AWS (Cloud-based VMs)
   └─ VM-based deployment on AWS
   └─ Best for: GPU workloads, AWS-specific features, bastion-only demos
   └─ Component: Custom (requires bastion + instances configuration)

4. CNV VMs (Cloud VMs on CNV)
   └─ Virtual machines on CNV infrastructure
   └─ Best for: RHEL demos, edge appliances, non-OpenShift workloads
   └─ Component: Custom (cloud_provider: openshift_cnv, config: cloud-vms-base)

Q: Infrastructure choice [1-4]:
```

**Set configuration based on choice:**

1. **CNV Multi-Node:**
```yaml
config: openshift-workloads
cloud_provider: none
clusters:
  - default:
      api_url: "{{ openshift_api_url }}"
      api_token: "{{ openshift_cluster_admin_token }}"

__meta__:
  components:
    - name: openshift
      display_name: OpenShift Cluster
      item: agd-v2/ocp-cluster-cnv-pools/prod
      parameter_values:
        cluster_size: multinode
        host_ocp4_installer_version: "4.20"
        ocp4_fips_enable: false
        num_users: "{{ num_users }}"
```

2. **SNO:**
```yaml
config: openshift-workloads
cloud_provider: none
clusters:
  - default:
      api_url: "{{ openshift_api_url }}"
      api_token: "{{ openshift_cluster_admin_token }}"

__meta__:
  components:
    - name: openshift
      display_name: OpenShift Cluster
      item: agd-v2/ocp-cluster-cnv-pools/prod
      parameter_values:
        cluster_size: sno
        host_ocp4_installer_version: "4.20"
        ocp4_fips_enable: false
```

3. **AWS:**
```yaml
cloud_provider: aws
config: cloud-vms-base

# Define security groups and instances
security_groups:
  - name: BastionSG
    rules:
      - name: SSH
        from_port: 22
        to_port: 22
        protocol: tcp
        cidr: "0.0.0.0/0"
        rule_type: Ingress

instances:
  - name: bastion
    count: 1
    image: RHEL-10.0-GOLD-latest
    flavor:
      ec2: t3a.large
    security_groups:
      - BastionSG
```

4. **CNV VMs:**
```yaml
cloud_provider: openshift_cnv
config: cloud-vms-base

instances:
  - name: bastion
    count: 1
    image: rhel-9.6
    cores: 8
    memory: 16G
    image_size: 200Gi
```

### Step 5: Authentication Setup

```
🔐 Authentication Method

How should users authenticate to OpenShift?

1. htpasswd (Simple username/password - Most common)
   └─ Workload: agnosticd.core_workloads.ocp4_workload_authentication_htpasswd

2. Keycloak SSO (Enterprise authentication - For AAP/complex setups)
   └─ Workload: agnosticd.core_workloads.ocp4_workload_authentication_keycloak

Q: Authentication method [1-2]:
```

**Set workload based on choice:**

1. **htpasswd:**
```yaml
workloads:
  - agnosticd.core_workloads.ocp4_workload_authentication_htpasswd
  # ... other workloads

# htpasswd configuration
common_password: "{{ (guid[:5] | hash('md5') | int(base=16) | b64encode)[:8] }}"
ocp4_workload_authentication_htpasswd_admin_user: admin
ocp4_workload_authentication_htpasswd_admin_password: "{{ common_password }}"
ocp4_workload_authentication_htpasswd_user_base: user
ocp4_workload_authentication_htpasswd_user_password: "{{ common_password }}"
ocp4_workload_authentication_htpasswd_user_count: "{{ num_users | default('1') }}"
ocp4_workload_authentication_htpasswd_remove_kubeadmin: true
```

2. **Keycloak:**
```yaml
workloads:
  - agnosticd.core_workloads.ocp4_workload_authentication_keycloak
  # ... other workloads

# Keycloak configuration
common_password: "{{ (guid[:5] | hash('md5') | int(base=16) | b64encode)[:8] }}"
ocp4_workload_authentication_keycloak_namespace: keycloak
ocp4_workload_authentication_keycloak_channel: stable-v26.2
ocp4_workload_authentication_keycloak_admin_username: admin
ocp4_workload_authentication_keycloak_admin_password: "{{ common_password }}"
ocp4_workload_authentication_keycloak_num_users: "{{ num_users }}"
ocp4_workload_authentication_keycloak_user_username_base: user
ocp4_workload_authentication_keycloak_user_password: "{{ common_password }}"
ocp4_workload_authentication_keycloak_remove_kubeadmin: true
```

### Step 6: Workload Selection

```
🧩 Workload Selection

I'll recommend workloads based on your catalog.

Q: What technologies will users learn? (comma-separated)
   Examples: ansible aap, openshift ai, gitops, pipelines

Technologies:
```

**Workload recommendation engine:**

Based on keywords, suggest from workload-mappings.md:
- `ansible` or `aap` → `rhpds.aap25.ocp4_workload_aap25`
- `ai` or `gpu` → `rhpds.nvidia_gpu.ocp4_workload_nvidia_gpu`
- `gitops` or `argocd` → `rhpds.openshift_gitops.ocp4_workload_openshift_gitops`
- `pipelines` → `rhpds.openshift_pipelines.ocp4_workload_openshift_pipelines`
- `showroom` → `rhpds.showroom.ocp4_workload_showroom` (always recommended)

**Present recommendations:**
```
Recommended workloads:

✓ rhpds.ocp4_workload_authentication.ocp4_workload_authentication (selected - auth)
✓ rhpds.showroom.ocp4_workload_showroom (recommended - guide)
  rhpds.aap25.ocp4_workload_aap25 (suggested - ansible)
  rhpds.openshift_gitops.ocp4_workload_openshift_gitops (suggested - gitops)

Select workloads (comma-separated numbers, or 'all'):
```

### Step 7: Showroom Repository Detection

```
📚 Showroom Content

Q: Do you have a Showroom repository for this catalog? [Y/n]
```

**If YES:**
```
Q: Showroom repository URL:
   Example: https://github.com/rhpds/showroom-ansible-ai

URL:
```

**If NO:**
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
```

**Validate directory doesn't exist:**
```bash
if [[ -d "$AGV_PATH/agd_v2/$short_name" ]]; then
  echo "⚠️  Directory already exists: $short_name"
  echo "Choose a different name."
fi
```

### Step 8a: Repository Setup

```
📦 Repository Configuration
```

**Ask about Showroom repository:**
```
Q: Do you have a Showroom repository created for this catalog? [Y/n]
```

**If NO:**
```
📚 Create Showroom Repository

Use the Showroom Nookbag template to create your repository:

Repository: https://github.com/rhpds/showroom_template_nookbag

Instructions:
1. Visit: https://github.com/rhpds/showroom_template_nookbag
2. Follow the README to generate your showroom repository
3. Recommended naming: {short-name}-showroom
4. Create in: github.com/rhpds organization

Example:
  Use the nookbag template to create your repository:
  https://github.com/rhpds/showroom_template_nookbag

Once created, come back and re-run this skill with the repository URL.

⏸️  Pausing - Create your Showroom repository first.
```

**If YES:**
```
Q: Showroom repository URL:
   Example: https://github.com/rhpds/ansible-aap-ai-showroom

Showroom URL:
```

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

**Modern catalog structure (2026+):**

```yaml
---
#include /includes/agd-v2-mapping.yaml
#include /includes/sandbox-api.yaml
#include /includes/catalog-icon-openshift.yaml  # or catalog-icon-project-dance, catalog-icon-rh-ai-2025
#include /includes/terms-of-service.yaml
#include /includes/access-restriction-rh1-2026-devs.yaml  # Optional - for restricted catalogs

#include /includes/parameters/purpose.yaml
#include /includes/parameters/salesforce-id.yaml
#include /includes/parameters/num-users-salesforce.yaml  # If multi-user

#include /includes/secrets/ocp4_ai_offline_token.yaml
#include /includes/secrets/s3-rhpds-private-bucket.yaml

# -------------------------------------------------------------------
# --- Catalog Item: <Display Name>
# -------------------------------------------------------------------

# ===================================================================
# Repository Tag
# Tag for all repositories that are used in this config.
# ===================================================================
tag: main  # Override in prod.yaml, event.yaml with specific tag (e.g., <short-name>-1.0.0)

# -------------------------------------------------------------------
# Mandatory Variables
# -------------------------------------------------------------------
config: openshift-workloads
cloud_provider: none
software_to_deploy: none
openshift_cnv_scale_cluster: true
clusters:
  - default:
      api_url: "{{ openshift_api_url }}"
      api_token: "{{ openshift_cluster_admin_token }}"

# -------------------------------------------------------------------
# Platform
# -------------------------------------------------------------------
platform: rhpds

# -------------------------------------------------------------------
# CNV Specific (if using CNV pools)
# -------------------------------------------------------------------
bastion_instance_image: rhel-9.6
bastion_cores: 2
bastion_memory: 4Gi

# Worker scaling formula
worker_instance_count: "{{ [2, ((num_users | int / 5.0) | round(0, 'ceil') | int) + 1] | max }}"
ai_workers_cores: 32
ai_workers_memory: 128Gi

# -------------------------------------------------------------------
# Common Password
# -------------------------------------------------------------------
common_password: "{{ (guid[:5] | hash('md5') | int(base=16) | b64encode)[:8] }}"

# -------------------------------------------------------------------
# Student User on Bastion (if needed)
# -------------------------------------------------------------------
install_student_user: true
student_name: lab-user
student_sudo: true

# -------------------------------------------------------------------
# Custom collections for this environment
# -------------------------------------------------------------------
requirements_content:
  collections:
    - name: https://github.com/agnosticd/core_workloads.git
      type: git
      version: main
    - name: https://github.com/agnosticd/showroom.git
      type: git
      version: v1.3.9
    # Add other collections as needed

# -------------------------------------------------------------------
# Workloads
# -------------------------------------------------------------------
workloads:
  - agnosticd.core_workloads.ocp4_workload_authentication_htpasswd
  - agnosticd.showroom.ocp4_workload_showroom_ocp_integration
  - agnosticd.showroom.ocp4_workload_showroom
  # Add technology-specific workloads

# ===================================================================
# Workload: ocp4_workload_authentication_htpasswd
# ===================================================================
ocp4_workload_authentication_htpasswd_admin_user: admin
ocp4_workload_authentication_htpasswd_admin_password: "{{ common_password }}"
ocp4_workload_authentication_htpasswd_user_base: user
ocp4_workload_authentication_htpasswd_user_password: "{{ common_password }}"
ocp4_workload_authentication_htpasswd_user_count: "{{ num_users | default('1') }}"
ocp4_workload_authentication_htpasswd_remove_kubeadmin: true

# ===================================================================
# Workload: ocp4_workload_showroom
# ===================================================================
ocp4_workload_showroom_content_git_repo: https://github.com/rhpds/showroom-repo.git
ocp4_workload_showroom_content_git_repo_ref: main

# -------------------------------------------------------------------
# Metadata
# -------------------------------------------------------------------
__meta__:
  asset_uuid: <generated-uuid>
  anarchy:
    namespace: babylon-anarchy-7
  components:
    - name: openshift
      display_name: OpenShift Cluster
      item: agd-v2/ocp-cluster-cnv-pools/prod
      parameter_values:
        cluster_size: multinode  # or sno
        host_ocp4_installer_version: "4.20"
        ocp4_fips_enable: false
        num_users: "{{ num_users }}"
      propagate_provision_data:
        - name: sandbox_openshift_api_key
          var: sandbox_openshift_api_key
        - name: sandbox_openshift_api_url
          var: sandbox_openshift_api_url
        - name: sandbox_openshift_namespace
          var: sandbox_openshift_namespace
        - name: openshift_cluster_admin_token
          var: openshift_cluster_admin_token
        - name: openshift_api_url
          var: openshift_api_url
        - name: bastion_public_hostname
          var: bastion_ansible_host
        - name: bastion_ssh_user_name
          var: bastion_ansible_user
        - name: bastion_ssh_password
          var: bastion_ansible_ssh_pass
        - name: bastion_ssh_port
          var: bastion_ansible_port
  catalog:
    namespace: babylon-catalog-{{ stage | default('?') }}
    display_name: "<Display Name>"
    category: <Workshops|Demos|Labs|Sandboxes|Brand_Events>
    multiuser: true  # or false for demos
    workshopLabUiRedirect: true  # Only for workshops
    parameters:
      - name: num_users
        description: Number of users to provision within the environment
        formLabel: User Count
        openAPIV3Schema:
          type: integer
          default: 3
          minimum: 3
          maximum: 60
    keywords:
      - <keyword1>
      - <keyword2>
    labels:
      Provider: RHDP
      Product: <Product_Name>
      Product_Family: <Product_Family>
      # Brand_Event: Red_Hat_One_2026  # If Brand_Events
    reportingLabels:
      primaryBU: Hybrid_Platforms  # CRITICAL: For business unit tracking/reporting (Hybrid_Platforms, Application_Services, Ansible, RHEL, etc.)
  owners:
    maintainer:
      - email: <email>
        name: <Name>
    sme:
      - email: <sme-email>
        name: <SME Name>
  tower:
    timeout: 14400  # 4 hours - adjust based on complexity
  deployer:
    scm_url: https://github.com/agnosticd/agnosticd-v2
    scm_ref: main
    execution_environment:
      image: quay.io/agnosticd/ee-multicloud:chained-2025-12-17
      pull: missing
```

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

**Note:** dev.yaml is minimal - only overrides scm_ref and sets purpose tag for cost tracking.

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

**Generate description.adoc:**
```asciidoc
= <Display Name>

== Overview

<Product Name> provides... (2-3 sentences starting with product, NOT "This workshop")

NOTE: Add any warnings here (GPU requirements, etc.)

== Guide

link:<github-pages-url>[Open Guide^,role=params-link]

== Featured Products and Technologies

* Product Name Version
* Another Product Version

== Agenda

* Module 1: <title>
* Module 2: <title>
* Module 3: <title>

== Authors

* <Author Name> - mailto:<email>[<email>] - <slack-handle>

For questions or feedback, reach out in Slack: [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX)
```

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

**Generate info-message-template.adoc:**
```asciidoc
= Environment Provisioned

Your <catalog-name> environment has been provisioned successfully!

== Access Information

* *Console URL*: {openshift_console_url}
* *Username*: {openshift_cluster_admin_username}
* *Password*: {openshift_cluster_admin_password}

== Guide

Access your workshop guide:

* link:{openshift_cluster_console_url}/showroom[Workshop Guide^]

== Additional Information

=== <Service Name>

* *API URL*: {<data_key_1>}
* *API Key*: {<data_key_2>}

NOTE: The data above comes from `agnosticd_user_info.data` in your workload.

== Support

Questions? Reach out in Slack: [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX)
```

**Explain agnosticd_user_info:**
```
ℹ️  How to share data from your workload:

In your workload tasks/workload.yml:

- name: Save user data for info message
  agnosticd.core.agnosticd_user_info:
    data:
      my_api_url: "{{ api_base_url }}"
      my_api_key: "{{ virtual_key }}"

Then use in info-message-template.adoc:

* API URL: {my_api_url}
* API Key: {my_api_key}

The template renders when users receive their environment.
```

**If NO user data:**
```asciidoc
= Environment Provisioned

Your <catalog-name> environment is ready!

== Access Information

* *Console URL*: {openshift_console_url}
* *Username*: {openshift_cluster_admin_username}
* *Password*: {openshift_cluster_admin_password}

== Workshop Guide

link:{openshift_cluster_console_url}/showroom[Open Guide^]

== Support

Questions? [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX)
```

### Step 11: Write Files

```
💾 Writing Files

Creating catalog directory: agd_v2/<directory-name>/

Writing:
  ✓ common.yaml
  ✓ dev.yaml
  ✓ description.adoc
  ✓ info-message-template.adoc
```

**Execute:**
```bash
mkdir -p "$AGV_PATH/agd_v2/$directory_name"

# Write all four files
cat > "$AGV_PATH/agd_v2/$directory_name/common.yaml" <<'EOF'
<generated-content>
EOF

cat > "$AGV_PATH/agd_v2/$directory_name/dev.yaml" <<'EOF'
<generated-content>
EOF

cat > "$AGV_PATH/agd_v2/$directory_name/description.adoc" <<'EOF'
<generated-content>
EOF

cat > "$AGV_PATH/agd_v2/$directory_name/info-message-template.adoc" <<'EOF'
<generated-content>
EOF
```

### Step 12: Git Commit (Optional)

```
🚀 Ready to Commit

Files created in: agd_v2/<directory-name>/

Q: Commit these changes? [Y/n]
```

**If YES:**
```bash
cd "$AGV_PATH"

git add "agd_v2/$directory_name/"

git commit -m "Add $directory_name catalog

- Category: $category
- Infrastructure: $cloud_provider ($sandbox_architecture)
- Workloads: $num_workloads selected
- UUID: $asset_uuid"

echo "✓ Committed to branch: $branch_name"
echo ""
echo "Next steps:"
echo "  1. Test locally: agnosticv_cli dev.yaml"
echo "  2. Run validator: /agnosticv-validator"
echo "  3. Create PR: gh pr create --fill"
```

---

## MODE 2: Description Only

**When selected:** User chose option 2 (Description Only)

**Simplified workflow - just extract from Showroom and generate description.adoc**

### Step 1: Locate Showroom

```
📚 Showroom Content

Q: Path to your Showroom repository:
   (Press Enter to use current directory)

Path:
```

**Validate:**
```bash
if [[ -d "$path/content/modules/ROOT/pages" ]]; then
  echo "✓ Found Showroom content"
else
  echo "✗ No Showroom content found at: $path/content/modules/ROOT/pages"
  exit 1
fi
```

### Step 2: Extract Content from Showroom

**Read ALL modules and extract comprehensive information:**
```bash
# Get ALL modules (ensure we don't miss any)
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
echo "📖 Analyzing all module content..."

# Combine all module content (excluding index/nav)
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
echo "📊 Extracted from ALL modules:"
echo "  ✓ Modules analyzed: $module_count"
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

**Review comprehensive extracted content from ALL modules:**
```
📝 Description Content Review

I've read ALL $module_count modules and extracted the following:

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

**Generate and write description.adoc** (same format as Mode 1, Step 10.3)

### Step 4: Locate Output Directory

```
📂 Output Location

Q: Where should I save description.adoc?

1. Auto-detect AgV catalog path
2. Specify custom path

Choice [1/2]:
```

**If option 1:**
```bash
# Look for existing catalog in AgV
catalog_dirs=$(find "$AGV_PATH/agd_v2" -type f -name "common.yaml" -exec dirname {} \;)

# Match by name similarity
echo "Found catalogs:"
echo "$catalog_dirs"

echo ""
echo "Q: Which catalog? (or 'none' for custom path)"
```

**Write file and optionally commit** (same as Mode 1, Step 12)

---

## MODE 3: Info Message Template Only

**When selected:** User chose option 3 (Info Message Template)

### Step 1: Locate Catalog

```
📂 Catalog Location

Q: Path to your AgV catalog directory:
   Example: ~/work/code/agnosticv/agd_v2/my-catalog

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

## Common Git Workflow (All Modes)

After generating files, always offer to commit:

```
🚀 Commit Changes

Branch: <branch-name>
Files modified:
  - agd_v2/<catalog-name>/...

Q: Commit these changes? [Y/n]
```

**If YES:**
```bash
cd "$AGV_PATH"

git add <files>

git commit -m "<appropriate-message>"

echo "✓ Committed to branch: $branch_name"
echo ""
echo "Next steps:"
echo "  1. Push: git push origin $branch_name"
echo "  2. Create PR: gh pr create --fill"
echo "  3. Validate: /agnosticv-validator"
```

---

## Validation & Testing

After file generation, guide users to validate:

```
✅ Next Steps

Your catalog files are ready!

Recommended actions:

1. Validate configuration:
   /agnosticv-validator

2. Test locally (if you have agnosticd-cli):
   cd agd_v2/<catalog-name>
   agnosticd_cli dev.yaml

3. Create pull request:
   git push origin <branch-name>
   gh pr create --fill

4. Request review in [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX)
```

---

## Error Handling

**UUID collision:**
```
⚠️  UUID collision detected!

The generated UUID already exists in:
  <path-to-existing-catalog>

Regenerating new UUID...
```

**Invalid category:**
```
⚠️  Category must be exactly one of:
  - Workshops
  - Demos
  - Sandboxes

(Case-sensitive, plural form)
```

**Showroom not found:**
```
⚠️  Showroom content not found at: <path>

Expected structure:
  content/modules/ROOT/pages/*.adoc

Please check the path and try again.
```

**Branch name with feature/:**
```
⚠️  Branch names should NOT include 'feature/' prefix.

Instead of: feature/add-workshop
Use: add-workshop

Please provide a branch name without 'feature/':
```

---

## Smart Features

### Auto-Detection
- Showroom module structure
- GitHub Pages URL from git remote
- Author name from git config
- Technology keywords in content
- Existing catalog directories

### Recommendations
- Workloads based on technology keywords
- Infrastructure based on catalog type
- Multi-user settings based on category

### Validation
- UUID uniqueness
- Category exact match
- Directory name conflicts
- Branch naming conventions
- Showroom content structure

---

## Best Practices

1. **Always pull main before starting** - Ensures latest catalog patterns
2. **Use descriptive branch names** - No feature/ prefix, just: add-catalog-name
3. **Validate before PR** - Use /agnosticv-validator
4. **Test in dev first** - Use dev.yaml for testing
5. **Document user data** - Clear info-message-template.adoc
6. **Start with product name** - Description overview must start with product, not "This workshop"

---

## Example Sessions

### Example 1: Full Catalog Creation

```
User: /agnosticv-catalog-builder
Skill: 🏗️  AgnosticV Catalog Builder

What would you like to create or update?

1. Full Catalog (common.yaml, dev.yaml, description.adoc, info-message-template.adoc)
2. Description Only (description.adoc)
3. Info Message Template (info-message-template.adoc)

Your choice [1-3]: 1

Q: AgnosticV repository path: ~/work/code/agnosticv

🔧 Git Workflow Setup

Current branch: main
📥 Pulling latest changes from main...
Already up to date.

Q: Branch name (without feature/): add-ansible-ai-workshop

🌿 Creating branch: add-ansible-ai-workshop
Switched to a new branch 'add-ansible-ai-workshop'

📖 Catalog Discovery

Q: Keywords for search: ansible ai

Found similar catalogs:
1. ansible-aap-workshop (Ansible Automation Platform Self-Service)
2. ansible-automation-mesh (Ansible Automation Mesh on OpenShift)

Choice: A (Create new from scratch)

📂 Category: 1 (Workshops)

🔑 UUID: a1b2c3d4-e5f6-7890-abcd-ef1234567890 (validated)

🏗️  Infrastructure: 1 (CNV Multi-Node)

🔐 Authentication: 1 (htpasswd)

🧩 Workload Selection

Technologies: ansible aap, openshift ai

Recommended workloads:
✓ rhpds.ocp4_workload_authentication.ocp4_workload_authentication
✓ rhpds.showroom.ocp4_workload_showroom
✓ rhpds.aap25.ocp4_workload_aap25
✓ rhpds.openshift_ai.ocp4_workload_openshift_ai

📚 Showroom: https://github.com/rhpds/showroom-ansible-ai

📝 Display name: Ansible Automation with OpenShift AI
📝 Description: Learn to build intelligent automation using Ansible and OpenShift AI
📝 Directory: ansible-ai-workshop

👥 Multi-user: Y (30 users)

📄 Extract description from Showroom: Y

💾 Writing files to: agd_v2/ansible-ai-workshop/
  ✓ common.yaml
  ✓ dev.yaml  
  ✓ description.adoc
  ✓ info-message-template.adoc

🚀 Commit: Y

✓ Committed to branch: add-ansible-ai-workshop

Next steps:
  1. Validate: /agnosticv-validator
  2. Push: git push origin add-ansible-ai-workshop
  3. Create PR: gh pr create --fill
```

### Example 2: Description Only

```
User: /agnosticv-catalog-builder

What would you like to create or update?
Your choice [1-3]: 2

Q: AgnosticV repository path: ~/work/code/agnosticv

🔧 Git Workflow Setup
Current branch: update-ocp-pipelines
⚠️  You're on: update-ocp-pipelines
Switch to main? Y

📥 Pulling main...
Q: Branch name: update-ocp-pipelines-description

📚 Showroom path: ~/work/code/showroom-ocp-pipelines

✓ Found 5 modules

Auto-extracted:
  ✓ Modules: Introduction, Deploy App, Create Pipeline, Add Tests, Deploy to Prod
  ✓ Author: Prakhar Srivastava
  ✓ Guide: https://rhpds.github.io/showroom-ocp-pipelines

Q: Overview: OpenShift Pipelines enables cloud-native CI/CD using Tekton...

Q: Technologies: OpenShift 4.17, OpenShift Pipelines 1.15

Q: Warnings: [none]

📂 Output location: 1 (Auto-detect)

Found: agd_v2/openshift-pipelines-intro/

💾 Writing description.adoc

🚀 Commit: Y

✓ Updated description.adoc
```

### Example 3: Info Message Template Only

```
User: /agnosticv-catalog-builder

Your choice [1-3]: 3

Q: AgnosticV repository path: ~/work/code/agnosticv

🔧 Git Workflow Setup
Q: Branch name: add-litellm-info-message

📂 Catalog: ~/work/code/agnosticv/agd_v2/litellm-virtual-keys/

📧 Info Message Template

Q: Uses agnosticd_user_info? Y

Q: Data keys: litellm_api_base_url, litellm_virtual_key, litellm_available_models_list

ℹ️  How to share data from your workload:

In tasks/workload.yml:
- name: Save LiteMaaS credentials
  agnosticd.core.agnosticd_user_info:
    data:
      litellm_api_base_url: "{{ litellm_api_base_url }}"
      litellm_virtual_key: "{{ litellm_virtual_key }}"
      litellm_available_models_list: "{{ litellm_available_models | join(', ') }}"

Template usage:
* API URL: {litellm_api_base_url}
* API Key: {litellm_virtual_key}
* Models: {litellm_available_models_list}

💾 Writing info-message-template.adoc

🚀 Commit: Y

✓ Created info-message-template.adoc
```

---

## References

### Related Skills
- `/agnosticv-validator` - Validate catalog configuration
- `/create-lab` - Create Showroom workshop content
- `/ftl` - Create graders/solvers for workshop testing

### Documentation
- `~/.claude/docs/workload-mappings.md` - Technology to workload mapping
- `~/.claude/docs/infrastructure-guide.md` - Infrastructure selection guide

### Key Files Generated

**common.yaml** - Main catalog configuration
```yaml
asset_uuid: <uuid>
name: Display Name
description: Brief description
category: Workshops|Demos|Sandboxes
cloud_provider: equinix_metal|ec2
sandbox_architecture: standard|single-node
num_users: <number>
student_guide_url: <github-pages>
workloads:
  - namespace.collection.role
```

**dev.yaml** - Development overrides
```yaml
cloud_provider: "{{ cloud_provider }}"
sandbox_architecture: "{{ sandbox_architecture }}"
num_users: 1
```

**description.adoc** - UI catalog description
```asciidoc
= Display Name

== Overview
Product description starting with product name...

== Guide
link:url[Open Guide]

== Featured Products
* Product Version

== Agenda
* Module titles

== Authors
* Name - contact
```

**info-message-template.adoc** - User notification template
```asciidoc
= Environment Provisioned

== Access Information
* Console: {openshift_console_url}
* Username: {openshift_cluster_admin_username}

== Additional Data
* Service URL: {custom_data_key}

Variables come from agnosticd_user_info.data
```

---

## Troubleshooting

### Branch Creation Fails

**Problem:** `fatal: A branch named 'X' already exists`

**Solution:**
```bash
# List branches
git branch -a

# Delete local branch if needed
git branch -D old-branch-name

# Or use different name
```

### UUID Collision

**Problem:** Generated UUID already exists

**Solution:** Skill auto-regenerates. If persistent, check for corrupted catalogs.

### Showroom Not Detected

**Problem:** Cannot find `content/modules/ROOT/pages/`

**Solution:**
```bash
# Verify structure
ls -la ~/path/to/showroom/content/modules/ROOT/pages/

# Should contain .adoc files
```

### Git Not Clean

**Problem:** Uncommitted changes prevent branch creation

**Solution:**
```bash
# Stash changes
git stash

# Or commit them first
git add .
git commit -m "WIP"
```

### Workload Not Found

**Problem:** Selected workload doesn't exist in collections

**Solution:** Check `~/.claude/docs/workload-mappings.md` for correct namespace.collection.role format

---

## Important Reminders

### ⚠️ Branch Naming
- **NO** `feature/` prefix
- **YES** descriptive names: `add-catalog-name`, `update-description`

### ⚠️ Description Overview
- **NO** starting with "This workshop/demo/lab..."
- **YES** starting with product name: "OpenShift Pipelines enables..."

### ⚠️ Category Values
- Must be **exact match**: `Workshops`, `Demos`, or `Sandboxes`
- Plural form required
- Case-sensitive

### ⚠️ Info Message Variables
- List/array variables from Ansible don't render in AsciiDoc
- Convert to strings: `{{ my_list | join(', ') }}`
- Example: `litellm_available_models_list: "{{ litellm_available_models | join(', ') }}"`

### ⚠️ Git Workflow
- Always pull main first
- Create new branch for each catalog
- Commit with descriptive messages
- Test before creating PR

---

## Success Criteria

After using this skill, you should have:

**For Full Catalog:**
- ✅ Clean git branch (pulled main, no feature/ prefix)
- ✅ Four files created (common.yaml, dev.yaml, description.adoc, info-message-template.adoc)
- ✅ Valid UUID (lowercase, RFC 4122, unique)
- ✅ Correct category (exact match)
- ✅ Appropriate workloads for technologies
- ✅ Showroom integration configured
- ✅ Ready for validation and PR

**For Description Only:**
- ✅ Clean git branch
- ✅ description.adoc with extracted content
- ✅ Overview starts with product name
- ✅ Module agenda from Showroom
- ✅ Author and contact info
- ✅ GitHub Pages link

**For Info Message Template:**
- ✅ Clean git branch
- ✅ info-message-template.adoc with user data placeholders
- ✅ Documented how to use agnosticd_user_info
- ✅ String formatting for lists/arrays
- ✅ Clear variable names

---

## Version History

- **2.0.0** (2026-01-22) - Unified skill combining agv-generator and generate-agv-description
- **1.0.0** (2026-01-15) - Initial separate skills (deprecated)

---

**End of Skill Documentation**
