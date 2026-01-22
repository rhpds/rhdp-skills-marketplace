---
name: agv-generator
description: Create complete AgnosticV catalog items with infrastructure provisioning configuration for RHDP
---

---
context: main
model: sonnet
---

# Skill: agv-generator

**Name:** AgnosticV Catalog Generator
**Description:** Create complete AgnosticV catalog items with infrastructure provisioning configuration for RHDP
**Version:** 1.0.0
**Last Updated:** 2026-01-22

---

## Purpose

Generate production-ready AgnosticV catalog configurations for Red Hat Demo Platform (RHDP) deployments. This skill guides users through creating catalog items with proper infrastructure, workloads, and metadata following agd_v2 best practices.

---

## When to Use This Skill

Use `/agv-generator` when you need to:

- Create a new RHDP catalog item for a workshop or demo
- Set up infrastructure provisioning for Showroom content
- Configure OpenShift clusters with workloads for hands-on labs
- Deploy multi-user workshop environments
- Build on existing catalog patterns

**Prerequisites:**
- RHDP account with AgnosticV repository access
- AgnosticV repository cloned locally (`~/work/code/agnosticv`)
- Git configured with SSH access to GitHub
- Basic understanding of OpenShift and RHDP concepts

---

## Skill Workflow Overview

```
Step 0: Prerequisites Check
  ↓
Step 1: Catalog Discovery (Search Existing)
  ↓
Step 2: Decision Point (Use Existing / Create New / Create Based on Reference)
  ↓
Step 3: Category Selection (REQUIRED)
  ↓
Step 4: UUID Generation (REQUIRED)
  ↓
Step 5: Infrastructure Selection
  ↓
Step 6: Workload Selection
  ↓
Step 7: Showroom Repository Detection
  ↓
Step 8: Git Workflow Setup
  ↓
Step 9: File Generation
  ↓
Step 10: Testing Guidance
```

---

## Step 0: Prerequisites Check (FIRST)

**CRITICAL:** Before any file operations, verify prerequisites.

### Ask for AgnosticV Repository Path

```
🏗️  AgnosticV Catalog Generator

First, I need your AgnosticV repository location.

Q: What is your AgnosticV repository directory path?

This directory is my reference library for:
- Searching existing catalogs by name or keywords
- Learning catalog patterns and structures
- Copying/basing new catalogs on existing ones
- Understanding workload configurations

Example paths:
- ~/work/code/agnosticv/
- ~/projects/agnosticv/
- /path/to/agnosticv/

Your AgV path: [Enter full path or 'help' for setup instructions]
```

**If user enters 'help':**

```
📚 Setting Up AgnosticV Repository

If you don't have the repository yet:

1. Navigate to your code directory:
   cd ~/work/code

2. Clone the AgnosticV repository:
   git clone git@github.com:rhpds/agnosticv.git

3. Verify the clone:
   cd agnosticv
   ls -la
   # Should see: agd_v2/, enterprise/, summit-2025/, .tests/

4. Return to this skill and provide the path:
   ~/work/code/agnosticv/

Need more help? Contact RHDP team in #forum-rhdp
```

### Validate Path

**After user provides path:**

```bash
# Verify path exists
if [ -d "$USER_PROVIDED_PATH" ]; then
  # Verify it's an AgV repository
  if [ -d "$USER_PROVIDED_PATH/agd_v2" ]; then
    ✅ Valid AgnosticV repository found
    📁 Path: $USER_PROVIDED_PATH
  else
    ❌ Path exists but doesn't look like AgnosticV repository
    Expected to find: agd_v2/ directory
    
    Try again? [Yes/No]
  fi
else
  ❌ Path not found: $USER_PROVIDED_PATH
  
  Did you mean:
  - ~/work/code/agnosticv/
  - Check spelling and try again
fi
```

**Store validated path** for use throughout workflow.

---

## Step 1: Catalog Discovery Phase

### Ask User About Existing Catalogs

```
Q: Do you know of an existing catalog that could be a good base for your workshop/demo?

Providing a catalog name helps me:
- Find the closest match faster
- Show you exactly what's available
- Use it as a template if creating new
- Copy proven working configurations

Options:
1. ✅ Yes, I know one → I'll search by name
2. 🔍 No / Not sure → I'll search by keywords  
3. ⏩ Skip search → Create from scratch

Your choice? [1/2/3]
```

### Option 1: Search by Display Name or Slug

**If user chooses option 1:**

```
Q: What's the catalog display name or slug?

Examples:
- Display name: "Agentic AI on OpenShift"
- Catalog slug: "agentic-ai-openshift"
- Partial match: "openshift ai"

Your search term: [Enter name or slug]
```

**Search Algorithm:**

Search in `$AGV_PATH/agd_v2/*/common.yaml` for:
1. `__meta__.catalog.display_name` (partial match, case-insensitive) - **50 points**
2. Catalog directory slug (partial match) - **40 points**
3. `__meta__.catalog.keywords` array (exact keyword match) - **10 points each**
4. `__meta__.catalog.category` (partial match) - **5 points**

**Show Top 5 Results:**

```
📋 Found 5 matching catalogs (sorted by relevance):

1. ⭐⭐⭐⭐⭐ Agentic AI on OpenShift (Score: 90)
   Slug: agd_v2/agentic-ai-openshift
   Category: Workshops
   Multi-user: Yes (5-40 users)
   Infrastructure: CNV multi-node
   OpenShift: 4.20
   
   Workloads (8):
   - authentication_htpasswd (Multi-user login)
   - showroom (Workshop platform)
   - openshift_ai (OpenShift AI operator)
   - litellm_virtual_keys (LLM API proxy)
   - pipelines (Tekton pipelines)
   - gitea_operator (Git server)
   
   Path: agd_v2/agentic-ai-openshift

2. ⭐⭐⭐⭐ OpenShift AI Workshop (Score: 75)
   ...

3. ⭐⭐⭐ AI-Driven Automation (Score: 60)
   ...

[Show next 2 results? Yes/No]

Options:
A. Use catalog #1 as-is (extract variables, no new files)
B. Create new based on catalog #1 (copy as template)
C. See details for catalog #2
D. Search again with different term
E. Skip to keyword search

Your choice? [A/B/C/D/E]
```

### Option 2: Search by Keywords

**If user chooses option 2 or search finds no results:**

```
Q: I'll search by technology keywords.

What technologies will your workshop/demo cover?

Examples:
- AI, ML, OpenShift AI, LLMs
- Pipelines, GitOps, Tekton, Argo CD
- Security, ACS, Compliance
- Developer, Dev Spaces, Inner Loop
- Service Mesh, Observability

Your keywords (comma-separated): [Enter keywords]
```

**Keyword-Based Recommendations:**

Extract and score catalogs by:
1. Matching keywords in display name
2. Matching keywords in catalog keywords array
3. Analyzing workload lists for technology match
4. Infrastructure type relevance

**Show Results** (same format as name search above)

### Option 3: Skip Search (Create From Scratch)

**If user chooses option 3:**

```
⏩ Skipping catalog search

I'll guide you through creating a catalog from scratch with recommended workloads based on your technologies.

→ Proceeding to Step 3: Category Selection
```

---

## Step 2: Decision Point

**After showing search results, user makes decision:**

### Choice A: Use Existing Catalog As-Is

```
✅ Using catalog "{{ selected_catalog_name }}" as-is

No new files will be created. I'll help you use this catalog for your workshop/demo.

**Next Steps:**

1. Deploy this catalog in RHDP Integration:
   - Login to https://integration.demo.redhat.com
   - Search for: "{{ catalog_display_name }}"
   - Order the catalog
   - Wait for provisioning (~1-2 hours)

2. Extract UserInfo variables:
   - Go to My Services → Your service
   - Click "Details" tab
   - Expand "Advanced settings"
   - Copy all UserInfo variables

3. Use variables in Showroom content:
   - Use /create-lab or /create-demo
   - Paste UserInfo variables when prompted
   - Attributes will be generated automatically

Would you like me to:
1. Show example UserInfo usage
2. Exit (you'll handle this yourself)

Your choice? [1/2]
```

**Exit skill** if user chooses option 2.

### Choice B: Create New Based on Reference

```
✅ Creating new catalog based on "{{ reference_catalog_name }}"

I'll use this as a template and customize it for your workshop/demo.

**Reference catalog structure:**
- Multi-user: {{ ref_multiuser }}
- Authentication: {{ ref_auth }}
- Infrastructure: {{ ref_infra }}
- Workloads: {{ ref_workload_count }} workloads

→ Proceeding to Step 3: Category Selection
```

**Store reference catalog path** for template copying later.

### Choice C/D/E: Continue Search or Create From Scratch

Continue to appropriate workflow.

---

## Step 3: Category Selection (REQUIRED)

**CRITICAL:** Category determines how catalog appears in RHDP portal and affects multi-user defaults.

```
Q: What category is this catalog?

Category determines:
- How it appears in RHDP catalog
- Default multi-user settings
- Authentication recommendations

Options:

1. 📚 Workshops
   - Multi-user hands-on labs
   - 5-50 concurrent users
   - Self-paced or instructor-led
   - Example: "OpenShift Pipelines Workshop"
   
2. 🎯 Demos  
   - Presenter-led demonstrations
   - Single presenter or small group
   - Executive/sales briefings
   - Example: "AI Platform Demonstration"
   
3. 🧪 Sandboxes
   - Self-service playground environments
   - Individual exploration
   - No structured content
   - Example: "OpenShift Developer Sandbox"

Your choice? [1/2/3]
```

**Validation:**

```yaml
# Valid categories (EXACTLY as shown):
valid_categories = ["Workshops", "Demos", "Sandboxes"]

# Store user selection:
if choice == 1:
  catalog_category = "Workshops"
  default_multiuser = true
  recommended_auth = "htpasswd"
elif choice == 2:
  catalog_category = "Demos"
  default_multiuser = false
  recommended_auth = "keycloak"
elif choice == 3:
  catalog_category = "Sandboxes"
  default_multiuser = false
  recommended_auth = "keycloak"
```

**Confirmation:**

```
✅ Category: {{ catalog_category }}

Recommended defaults:
- Multi-user: {{ default_multiuser }}
- Authentication: {{ recommended_auth }}

We'll configure these in later steps.
```

---

## Step 4: UUID Generation (REQUIRED)

**CRITICAL:** Every catalog MUST have a unique UUID. Generate BEFORE file creation.

```
Q: Please generate a unique UUID for this catalog.

Every AgnosticV catalog requires a unique identifier (UUID).

Run ONE of these commands to generate a UUID:

macOS/Linux:
  uuidgen

OR

Python (any platform):
  python3 -c 'import uuid; print(uuid.uuid4())'

Then paste the generated UUID here: [paste UUID]
```

**UUID Format Validation:**

```python
import re

uuid_pattern = r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'

if re.match(uuid_pattern, user_input.lower()):
  ✅ Valid UUID format
  UUID: {{ user_input }}
  
  # Check for collisions in AgV repository
  if uuid_exists_in_agv_repo(user_input):
    ❌ UUID COLLISION DETECTED
    
    This UUID already exists in:
    {{ existing_catalog_path }}
    
    UUIDs must be unique. Please generate a new one:
    uuidgen
    
    Enter new UUID: [paste]
  else:
    ✅ UUID is unique
    → Proceeding to Step 5
else:
  ❌ Invalid UUID format
  
  Expected format: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
  Example: 5ac92190-6f0d-4c0e-a9bd-3b20dd3c816f
  
  Your input: {{ user_input }}
  
  This is NOT a valid UUID:
  ❌ "gitops-openshift-2026-01" (descriptive name, not UUID)
  ❌ "12345" (too short)
  ❌ Missing hyphens
  
  Generate a proper UUID and try again: [paste UUID]
```

**Store validated UUID** for use in common.yaml generation.

---

## Step 5: Infrastructure Selection

```
Q: What infrastructure does this workshop/demo need?

Choose based on requirements:

1. 🖥️  CNV (Container-Native Virtualization) - RECOMMENDED
   - Best for: Most workshops and demos
   - Provision time: 10-15 minutes
   - Multi-user: Yes (5-40 users)
   - Cost: $$ (moderate)
   - Resources: 64Gi RAM / 32 cores per worker
   - Use when: Standard OpenShift workloads, no GPU
   
2. 📱 SNO (Single Node OpenShift)
   - Best for: Edge demos, lightweight single-user
   - Provision time: 5-10 minutes
   - Multi-user: No (single node)
   - Cost: $ (low)
   - Resources: 32Gi RAM / 16 cores total
   - Use when: Edge computing, quick platform tours
   
3. ☁️  AWS (Cloud-Specific)
   - Best for: GPU workloads, large memory
   - Provision time: 30-45 minutes
   - Multi-user: Yes
   - Cost: $$$ (high)
   - Resources: Scalable, GPU instances available
   - Use when: AI/ML training (GPU), >128Gi RAM needed

Your choice? [1/2/3 or 'help' for decision tree]
```

**If user enters 'help':**

```
📊 Infrastructure Decision Tree

Answer these questions:

1. Do you need GPU acceleration?
   → YES: Choose AWS (option 3)
   → NO: Continue to question 2

2. Is this an edge computing demo?
   → YES: Choose SNO (option 2)
   → NO: Continue to question 3

3. Do you need multi-user support (5+ users)?
   → YES: Choose CNV (option 1) - RECOMMENDED
   → NO: Choose CNV (option 1) or SNO (option 2)

4. Do you need >128Gi total RAM?
   → YES: Choose AWS (option 3)
   → NO: Choose CNV (option 1) - RECOMMENDED

💡 Most workshops/demos use CNV (option 1)

Your choice? [1/2/3]
```

**Store infrastructure choice** and set defaults:

```python
if choice == 1:  # CNV
  infra_type = "CNV"
  config_type = "openshift-workloads"
  cloud_provider = "none"
  cluster_item = "agd-v2/ocp-cluster-cnv-pools/prod"
  cluster_size = "multinode"
  showroom_workload = "agnosticd.showroom.ocp4_workload_showroom"
  
elif choice == 2:  # SNO
  infra_type = "SNO"
  config_type = "openshift-workloads"
  cloud_provider = "none"
  cluster_item = "agd-v2/ocp-cluster-cnv-pools/prod"
  cluster_size = "sno"
  showroom_workload = "agnosticd.showroom.ocp4_workload_showroom_sno"
  
elif choice == 3:  # AWS
  infra_type = "AWS"
  config_type = "ocp-workloads"
  cloud_provider = "ec2"
  cluster_item = "agd-v2/ocp-cluster-aws/prod"
  cluster_size = "default"
  showroom_workload = "agnosticd.showroom.ocp4_workload_showroom"
```

---

## Step 6: Workload Selection

### Authentication Workload (REQUIRED)

```
Q: Which authentication method?

Based on category "{{ catalog_category }}":
Recommended: {{ recommended_auth }}

Options:

1. 🔐 htpasswd (Simple, fast)
   - Best for: Multi-user workshops
   - Setup time: Fast
   - Features: Basic username/password
   - Users: user1, user2, ..., userN
   
2. 🎫 Keycloak (Advanced, SSO)
   - Best for: Demos, production-like
   - Setup time: Moderate
   - Features: SSO, advanced auth, better UX
   - Users: Configurable via Keycloak

{{ recommended_auth == "htpasswd" ? "Recommended: 1 (htpasswd)" : "Recommended: 2 (Keycloak)" }}

Your choice? [1/2]
```

**Store authentication choice:**

```python
if auth_choice == 1:
  auth_workload = "agnosticd.core_workloads.ocp4_workload_authentication_htpasswd"
  auth_type = "htpasswd"
else:
  auth_workload = "agnosticd.core_workloads.ocp4_workload_authentication_keycloak"
  auth_type = "keycloak"
```

### Technology-Specific Workloads

```
Q: What technologies will your workshop/demo use?

I'll recommend workloads based on your keywords.

Enter technologies (comma-separated):
Examples:
- AI, ML, OpenShift AI, LLMs
- Pipelines, GitOps, Tekton
- Security, ACS
- Developer, Dev Spaces

Your technologies: [Enter keywords]
```

**Workload Recommendation Engine:**

Based on keywords from workload-mappings.md:

```python
recommended_workloads = []

# AI/ML keywords
if any(keyword in user_keywords for keyword in ['ai', 'ml', 'llm', 'openshift-ai']):
  recommended_workloads.append({
    'name': 'agnosticd.ai_workloads.ocp4_workload_openshift_ai',
    'purpose': 'OpenShift AI operator, notebook servers, data science pipelines',
    'required': True,
    'category': 'AI/ML'
  })
  
  recommended_workloads.append({
    'name': 'rhpds.litellm_virtual_keys.ocp4_workload_litellm_virtual_keys',
    'purpose': 'LLM API proxy with virtual keys (Mistral, Granite, CodeLlama)',
    'required': False,
    'category': 'AI/ML'
  })

# Pipelines/GitOps keywords
if any(keyword in user_keywords for keyword in ['pipeline', 'gitops', 'tekton', 'argo']):
  recommended_workloads.append({
    'name': 'agnosticd.core_workloads.ocp4_workload_pipelines',
    'purpose': 'Tekton Pipelines (cloud-native CI/CD)',
    'required': True,
    'category': 'DevOps'
  })
  
  recommended_workloads.append({
    'name': 'agnosticd.core_workloads.ocp4_workload_openshift_gitops',
    'purpose': 'Argo CD for GitOps workflows',
    'required': False,
    'category': 'DevOps'
  })

# ... (continue for all technology categories)
```

**Present Recommendations:**

```
📦 Recommended Workloads

Based on your keywords: {{ user_keywords }}

CORE (Always Required):
✅ {{ auth_workload }} - Authentication
✅ {{ showroom_workload }} - Workshop platform

TECHNOLOGY STACK (Recommended):
{% for workload in recommended_workloads if workload.required %}
✅ {{ workload.name }}
   Purpose: {{ workload.purpose }}
   Category: {{ workload.category }}
{% endfor %}

OPTIONAL WORKLOADS:
{% for workload in recommended_workloads if not workload.required %}
? {{ workload.name }}
   Purpose: {{ workload.purpose }}
   When to include: {{ workload.use_case }}
{% endfor %}

Include optional workloads? [All/Customize/Skip optional]
```

**If user chooses "Customize":**

```
Select which optional workloads to include:

{% for i, workload in enumerate(optional_workloads) %}
{{ i+1 }}. {{ workload.name }}
   {{ workload.purpose }}
   Include? [Y/N]
{% endfor %}
```

**Build final workload list:**

```python
final_workloads = [
  auth_workload,
  showroom_workload
] + [w['name'] for w in recommended_workloads if w['required'] or w['included']]
```

---

## Step 7: Showroom Repository Detection

**CRITICAL:** Auto-detect showroom git repository from current working directory.

```
Q: Detecting showroom repository from current directory...

Running: git -C $(pwd) remote get-url origin
```

**Scenarios:**

### Scenario A: Git Remote Found

```
✓ Found git remote

Remote URL: {{ detected_url }}

{% if detected_url starts with "git@github.com:" %}
🔄 Converting SSH to HTTPS (for user cloning):
  SSH:   {{ detected_url }}
  HTTPS: {{ https_url }}

Using: {{ https_url }}
{% else %}
Using: {{ detected_url }}
{% endif %}

Confirm this is your showroom repository? [Yes/No/Enter different URL]
```

### Scenario B: No Git Remote Found

```
⚠️  No git remote found in current directory.

Are you in your showroom repository directory?

Options:
1. Navigate to showroom repo and try again
2. Manually enter showroom repository URL
3. Create catalog without showroom (placeholder URL)

Your choice? [1/2/3]
```

**If user chooses option 2:**

```
Q: Enter your showroom repository URL (HTTPS format)

Format: https://github.com/rhpds/<repo-name>.git

Examples:
- https://github.com/rhpds/showroom-agentic-ai-llamastack.git
- https://github.com/rhpds/ai-driven-automation-showroom.git

Your showroom repo URL: [Enter HTTPS URL]
```

**Validation:**

```python
import re

https_pattern = r'^https://github\.com/[\w-]+/[\w-]+\.git$'

if re.match(https_pattern, user_url):
  ✅ Valid HTTPS GitHub URL
  Showroom repo: {{ user_url }}
else:
  ❌ Invalid URL format
  
  Expected: https://github.com/org/repo.git
  Your input: {{ user_url }}
  
  Issues:
  - Must start with https://github.com/
  - Must end with .git
  - No SSH format (git@github.com:...)
  
  Try again: [Enter URL]
```

**Store validated showroom URL** for common.yaml generation.

---

## Step 8: Git Workflow Setup

**CRITICAL:** Prepare git branch BEFORE generating files.

```
🔀 Preparing Git Workflow

I'll set up a clean git branch for your new catalog.

Running these commands in {{ agv_path }}:

1. Switch to main branch
   $ cd {{ agv_path }}
   $ git checkout main

2. Pull latest changes
   $ git pull origin main

3. Create new feature branch
   $ git checkout -b {{ catalog_slug }}

Branch naming: NO "feature/" prefix (AgV convention)
Example: "agentic-ai-openshift" not "feature/agentic-ai-openshift"
```

**Execute git commands:**

```bash
cd {{ agv_path }}
git checkout main
git pull origin main
git checkout -b {{ catalog_slug }}
```

**Confirm success:**

```
✅ Git workflow prepared

Current branch: {{ catalog_slug }}
Base: origin/main (latest)

Ready to generate catalog files.
```

---

## Step 9: File Generation

### Determine Catalog Information

**From previous steps, we have:**
- Category: {{ catalog_category }}
- UUID: {{ validated_uuid }}
- Infrastructure: {{ infra_type }}
- Workloads: {{ final_workloads }}
- Showroom repo: {{ showroom_repo_url }}
- Authentication: {{ auth_type }}

**Ask for remaining details:**

```
Q: Catalog display name?

This appears in RHDP catalog and portal.

Examples:
- "Agentic AI on OpenShift"
- "OpenShift Pipelines Workshop"
- "Platform Engineering with GitOps"

Your catalog display name: [Enter name]
```

**Generate catalog slug from display name:**

```python
catalog_slug = display_name.lower()
  .replace(' with ', '-')
  .replace(' on ', '-')
  .replace(' ', '-')
  .replace('openshift', 'ocp')
  # Remove special characters
  .replace('[^a-z0-9-]', '')

# Example: "Agentic AI on OpenShift" → "agentic-ai-ocp"
```

**Ask for abstract:**

```
Q: Brief abstract (1-2 sentences)

Start with product name, describe what users will learn/do.

Example:
"Learn to build agentic AI applications using Llama Stack framework on Red Hat OpenShift AI. This hands-on workshop covers agent architecture, tool integration, and RAG patterns."

Your abstract: [Enter 1-2 sentences]
```

**Ask for directory:**

```
Q: Which AgnosticV directory?

Options:
1. agd_v2/ (Recommended - standard catalogs)
2. enterprise/ (Red Hat internal only)
3. summit-2025/ (Event-specific)

Recommended: 1 (agd_v2/)

Your choice? [1/2/3]
```

**Set directory:**

```python
if choice == 1:
  catalog_dir = "agd_v2"
elif choice == 2:
  catalog_dir = "enterprise"
elif choice == 3:
  catalog_dir = "summit-2025"

full_catalog_path = f"{agv_path}/{catalog_dir}/{catalog_slug}"
```

### Generate common.yaml

**Template with all collected information:**

```yaml
---
# AgnosticV includes
#include /includes/agd-v2-mapping.yaml
#include /includes/sandbox-api.yaml
#include /includes/catalog-icon-openshift.yaml
#include /includes/terms-of-service.yaml

#include /includes/parameters/purpose.yaml
#include /includes/parameters/salesforce-id.yaml
#include /includes/secrets/letsencrypt_with_zerossl_fallback.yaml

# Repository Tag
tag: main

# Infrastructure
cloud_provider: {{ cloud_provider }}
config: {{ config_type }}

{% if infra_type == "CNV" or infra_type == "SNO" %}
clusters:
- default:
    api_url: "{{ openshift_api_url }}"
    api_token: "{{ openshift_api_key }}"
{% endif %}

# Collections
requirements_content:
  collections:
  - name: https://github.com/agnosticd/core_workloads.git
    type: git
    version: "{{ tag }}"
  - name: https://github.com/agnosticd/showroom.git
    type: git
    version: main
{% if 'ai_workloads' in final_workloads %}
  - name: https://github.com/agnosticd/ai_workloads.git
    type: git
    version: main
{% endif %}
{% if 'litellm_virtual_keys' in final_workloads %}
  - name: https://github.com/rhpds/litellm_virtual_keys.git
    type: git
    version: main
{% endif %}

# Workloads
workloads:
{% for workload in final_workloads %}
- {{ workload }}
{% endfor %}

# Workload Variables
common_user_password: "{{ (guid[:5] | hash('md5') | int(base=16) | b64encode)[:10] }}"
common_admin_password: "{{ (guid[:5] | hash('md5') | int(base=16) | b64encode)[:16] }}"

{% if auth_type == "htpasswd" %}
ocp4_workload_authentication_htpasswd_admin_user: admin
ocp4_workload_authentication_htpasswd_admin_password: "{{ common_admin_password }}"
ocp4_workload_authentication_htpasswd_user_base: user
ocp4_workload_authentication_htpasswd_user_password: "{{ common_user_password }}"
ocp4_workload_authentication_htpasswd_user_count: "{{ (num_users | default('2')) | int }}"
{% elif auth_type == "keycloak" %}
ocp4_workload_authentication_keycloak_admin_password: "{{ common_admin_password }}"
{% endif %}

ocp4_workload_showroom_content_git_repo: {{ showroom_repo_url }}
ocp4_workload_showroom_content_git_repo_ref: main

# Metadata
__meta__:
  asset_uuid: {{ validated_uuid }}
  owners:
    maintainer:
    - name: {{ maintainer_name | default('RHDP Team') }}
      email: {{ maintainer_email | default('rhdp@redhat.com') }}
  anarchy:
    namespace: babylon-anarchy-7
  deployer:
    scm_url: https://github.com/agnosticd/agnosticd-v2
    scm_ref: main
    execution_environment:
      image: quay.io/agnosticd/ee-multicloud:chained-2025-10-09
      pull: missing
  catalog:
    namespace: babylon-catalog-{{ stage | default('?') }}
    display_name: {{ catalog_display_name }}
    category: {{ catalog_category }}
    keywords:
    {% for keyword in technology_keywords %}
    - {{ keyword }}
    {% endfor %}
    multiuser: {{ multiuser }}
{% if multiuser %}
    parameters:
    - name: num_users
      description: Number of users to provision within the cluster.
      formLabel: OpenShift User Count
      openAPIV3Schema:
        type: integer
        default: 2
        minimum: 2
        maximum: 40
{% endif %}
  components:
  - name: openshift-base
    display_name: OpenShift Cluster
    item: {{ cluster_item }}
    parameter_values:
      cluster_size: {{ cluster_size }}
      host_ocp4_installer_version: "4.20"
{% if infra_type == "AWS" and 'gpu' in workload_keywords %}
      worker_instance_type: g6.4xlarge
      worker_instance_count: 2
{% endif %}
    propagate_provision_data:
    - name: openshift_api_ca_cert
      var: openshift_api_ca_cert
    - name: openshift_api_url
      var: openshift_api_url
    - name: openshift_cluster_admin_token
      var: openshift_api_key
```

**Write file:**

```bash
mkdir -p {{ full_catalog_path }}
cat > {{ full_catalog_path }}/common.yaml << 'EOF'
{{ generated_common_yaml }}
EOF
```

### Generate description.adoc

```asciidoc
= {{ catalog_display_name }}

{{ catalog_abstract }}

{% if multiuser %}
This catalog supports {{ min_users }}-{{ max_users }} concurrent users.
{% endif %}

Workshop content is delivered via Red Hat Showroom platform.

== Prerequisites

* Basic knowledge of OpenShift and containers
* Familiarity with {{ primary_technology }}
{% for prereq in additional_prerequisites %}
* {{ prereq }}
{% endfor %}

== What You'll Learn

{% for outcome in learning_outcomes %}
* {{ outcome }}
{% endfor %}

== Environment Details

* OpenShift {{ ocp_version }}
{% for tech in technologies %}
* {{ tech.name }} {{ tech.version }}
{% endfor %}

{% if multiuser %}
== User Access

Each user receives:
* Unique username (user1, user2, ..., user{{ max_users }})
* Individual project namespace
* Access to shared cluster resources
{% endif %}

== Showroom Guide

link:{{ showroom_repo_url }}[Access workshop guide]
```

**Write file:**

```bash
cat > {{ full_catalog_path }}/description.adoc << 'EOF'
{{ generated_description }}
EOF
```

### Generate dev.yaml

```yaml
---
# Development overrides for testing
# Use this config for local testing before production deployment

purpose: development

# Override SCM ref for testing showroom content from feature branches
# Example: Change 'main' to your feature branch name
# ocp4_workload_showroom_content_git_repo_ref: feature-new-module

# Override collections for testing development versions
# requirements_content:
#   collections:
#   - name: https://github.com/agnosticd/core_workloads.git
#     type: git
#     version: develop

# Override num_users for smaller dev deployments
# num_users: 2

# Override workload versions for testing
# ocp4_workload_pipelines_channel: pipelines-1.20
```

**Write file:**

```bash
cat > {{ full_catalog_path }}/dev.yaml << 'EOF'
{{ generated_dev_yaml }}
EOF
```

### Confirmation

```
✅ Catalog files generated

Created in: {{ full_catalog_path }}/

Files:
✓ common.yaml ({{ common_yaml_lines }} lines)
✓ description.adoc ({{ description_lines }} lines)
✓ dev.yaml ({{ dev_yaml_lines }} lines)

Summary:
- Category: {{ catalog_category }}
- UUID: {{ validated_uuid }}
- Infrastructure: {{ infra_type }}
- Multi-user: {{ multiuser }}
- Workloads: {{ workload_count }} total

→ Proceeding to Step 10: Testing Guidance
```

---

## Step 10: Testing Guidance

```
🧪 Testing Your Catalog

⚠️  CRITICAL: Test in RHDP Integration BEFORE requesting PR merge

**Step 1: Commit and Push**

Run these commands in {{ agv_path }}:

$ git status
# Review what files were created

$ git add {{ catalog_dir }}/{{ catalog_slug }}/

$ git commit -m "Add {{ catalog_display_name }} catalog

- Category: {{ catalog_category }}
- Infrastructure: {{ infra_type }}
- Multi-user: {{ multiuser }}
- Workloads: {{ workload_list }}
- Target: {{ workshop_type }}"

$ git push origin {{ catalog_slug }}

**Step 2: Create Pull Request**

$ gh pr create --title "Add {{ catalog_display_name }}" --body "$(cat <<'PREOF'
## Summary

New {{ catalog_category }} catalog: {{ catalog_display_name }}

## Configuration

- **Category:** {{ catalog_category }}
- **Infrastructure:** {{ infra_type }}
- **Multi-user:** {{ multiuser }}
- **Workloads:** {{ workload_count }}
- **OpenShift:** 4.20

## Workloads

{% for workload in final_workloads %}
- {{ workload }}
{% endfor %}

## Testing Plan

1. Deploy to Integration environment
2. Verify all workloads provision successfully
3. Test showroom content with deployed environment
4. Extract UserInfo variables
5. Confirm workshop/demo functionality

## Test Checklist

- [ ] Catalog appears in Integration
- [ ] Environment provisions (1-2 hours)
- [ ] All workloads deploy successfully
- [ ] Showroom content loads
- [ ] Exercises work as documented
- [ ] UserInfo variables available

Tested by: [Your Name]
Test date: [Date]
Test environment: integration.demo.redhat.com
PREOF
)"

**Step 3: Wait for Integration Sync**

PR will be automatically labelled for integration deployment.

Wait time: ~5-10 minutes for PR to be labelled

**Step 4: Test in Integration**

1. Login to: https://integration.demo.redhat.com

2. Search for your catalog:
   Display name: "{{ catalog_display_name }}"

3. Order the catalog:
   - Fill in parameters (num_users, etc.)
   - Submit order

4. Wait for provisioning:
   ⏱️  Expected time: 1-2 hours (can take longer)
   
   Monitor: My Services → Your service → Events tab

5. Once successful, extract UserInfo:
   - Go to: My Services → Your service
   - Click: Details tab
   - Expand: Advanced settings section
   - Copy: All UserInfo variables

6. Test workshop/demo content:
   - Use /create-lab or /create-demo
   - Paste UserInfo variables
   - Verify all exercises work

**Step 5: Update PR with Test Results**

After successful testing:

$ git checkout {{ catalog_slug }}

# Add test results to PR description
$ gh pr edit --add-body "

## Test Results ✅

Tested on: $(date)
Environment: integration.demo.redhat.com

- ✅ Catalog provisions successfully
- ✅ All workloads deployed
- ✅ Showroom content loads
- ✅ Exercises verified
- ✅ UserInfo variables available

Ready for merge.
"

**Step 6: Request PR Merge**

Comment on PR:
"@rhdp-team Ready for merge after successful Integration testing"

**Step 7: After Merge**

Timeline:
- Stage deploy: ~4 hours after PR merge
- Production: After RHDP team approval

Cleanup local branch:
$ git checkout main
$ git pull origin main
$ git branch -d {{ catalog_slug }}

---

✅ Catalog Generation Complete!

You've successfully created:
- AgnosticV catalog configuration
- Git branch with files
- Pull request ready for testing

Next: Test in Integration and update PR with results

Need help? Contact RHDP team in #forum-rhdp
```

---

## Error Handling

### Invalid Path

```
❌ AgnosticV repository not found

I searched for: {{ user_provided_path }}

Common issues:
- Path doesn't exist
- Not the AgnosticV repository
- Missing agd_v2/ directory

Try:
1. Check spelling: ~/work/code/agnosticv/
2. Clone repository: git clone git@github.com:rhpds/agnosticv.git
3. Verify you're in the right directory

Try again? [Yes/No]
```

### UUID Collision

```
❌ UUID COLLISION DETECTED

The UUID you generated already exists in:
{{ existing_catalog_path }}

This catalog: "{{ existing_catalog_name }}"
Already uses UUID: {{ user_uuid }}

UUIDs must be globally unique across ALL catalogs.

Generate a NEW UUID:
$ uuidgen

Enter new UUID: [paste]
```

### Git Errors

```
❌ Git Error

Command failed: git checkout main

Possible causes:
- Uncommitted changes in repository
- Not in a git repository
- No main branch

Fix:
1. Check git status: git status
2. Commit or stash changes: git stash
3. Try again

Continue? [Yes/No]
```

### Invalid Category

```
❌ Invalid Category

You entered: {{ user_input }}

Valid categories (EXACTLY as shown):
- Workshops
- Demos
- Sandboxes

These are case-sensitive. Use exact spelling.

Try again: [1/2/3]
```

---

## Skill Exit Points

### Exit 1: Using Existing Catalog

```
✅ Skill Complete

You're using existing catalog: "{{ catalog_name }}"

No new files created.

Next steps:
1. Deploy catalog in RHDP Integration
2. Extract UserInfo variables
3. Use in /create-lab or /create-demo

👋 Exiting /agv-generator
```

### Exit 2: Files Generated Successfully

```
✅ Skill Complete

Catalog files created in: {{ full_catalog_path }}/

Next steps:
1. Review generated files
2. Commit and push to GitHub
3. Create pull request
4. Test in RHDP Integration
5. Update PR with test results
6. Request merge after successful testing

👋 Exiting /agv-generator
```

### Exit 3: User Cancellation

```
⚠️  Catalog generation cancelled

No files were created.

You can restart this skill anytime: /agv-generator

👋 Exiting /agv-generator
```

---

## References

- [AGV Common Rules](../../docs/AGV-COMMON-RULES.md) - Full AgV configuration contract
- [Workload Mappings](../../docs/workload-mappings.md) - Technology to workload reference
- [Infrastructure Guide](../../docs/infrastructure-guide.md) - CNV/SNO/AWS decision tree
- [AgnosticV Repository](https://github.com/rhpds/agnosticv) - Catalog source
- [RHDP Integration](https://integration.demo.redhat.com) - Testing environment

---

**Last Updated:** 2026-01-22
**Maintained By:** RHDP Team
**Version:** 1.0.0
