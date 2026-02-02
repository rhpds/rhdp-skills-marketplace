---
layout: default
title: /agnosticv:catalog-builder
---

# /agnosticv:catalog-builder

Create or update AgnosticV catalog files for RHDP deployments (unified skill).

---

## Before You Start

### Prerequisites

1. **Clone the AgnosticV repository:**
   ```bash
   cd ~/work/code
   git clone git@github.com:rhpds/agnosticv.git
   cd agnosticv
   ```

2. **Verify RHDP access:**
   - Ensure you have write access to the AgnosticV repository
   - Test with: `gh repo view rhpds/agnosticv`
   - You should be able to create pull requests

3. **For Full Catalog - Have your workshop content ready:**
   - Workshop lab content (from `/showroom:create-lab`)
   - Infrastructure requirements (CNV, AWS, etc.)
   - Workload list (OpenShift AI, AAP, etc.)

4. **For Description Only - Have Showroom content:**
   - Completed workshop in Showroom format
   - Modules in `content/modules/ROOT/pages/`

### What You'll Need

Depending on what you're creating:

**Full Catalog:**
- Catalog name (e.g., "Agentic AI on OpenShift")
- Category (Workshops, Demos, or Sandboxes)
- Infrastructure type (CNV multi-node, AWS, SNO, etc.)
- Workloads to deploy
- Multi-user requirements (yes/no)

**Description Only:**
- Path to Showroom repository
- Brief overview (2-3 sentences starting with product name)

**Info Template:**
- Data keys from `agnosticd_user_info.data`

---

## Quick Start

1. Navigate to AgnosticV repository
2. Run `/agnosticv:catalog-builder`
3. Choose mode: Full Catalog / Description Only / Info Template
4. Answer guided questions
5. Review generated files
6. Files auto-committed to new branch

---

## What It Can Generate

### Mode 1: Full Catalog

Creates complete catalog with all files:

```
~/work/code/agnosticv/agd_v2/your-catalog-name/
├── common.yaml          # Infrastructure and workloads
├── dev.yaml            # Development environment
├── description.adoc    # Catalog UI description
└── info-message-template.adoc  # User notification
```

### Mode 2: Description Only

Updates just the description file:

```
~/work/code/agnosticv/agd_v2/your-catalog-name/
└── description.adoc    # Generated from Showroom content
```

### Mode 3: Info Template

Creates user notification template:

```
~/work/code/agnosticv/agd_v2/your-catalog-name/
└── info-message-template.adoc  # With agnosticd_user_info data
```

---

## Detailed Question-by-Question Workflow

The skill asks questions step-by-step. Here's exactly what you'll see:

### Mode 1: Full Catalog - Detailed Steps

**Step 1: Mode Selection**
```
Q: What would you like to create or update?
   1. Full Catalog (common.yaml, dev.yaml, description.adoc, info-message-template.adoc)
   2. Description Only (description.adoc)
   3. Info Message Template (info-message-template.adoc)

Expected Answer: 1
```

**Step 2: Git Workflow (Automatic)**
```
✓ Checking current branch: main
✓ Pulling latest from origin/main
✓ Creating new branch...

Q: What should we name your branch? (NO feature/ prefix)
   Example: add-ansible-ai-workshop

Expected Answer: add-your-catalog-name
```

**Step 3: Repository Path**
```
Q: What is your AgnosticV repository directory path?

Expected Answer: ~/work/code/agnosticv
```

**Step 4: Search Similar Catalogs (Optional)**
```
Q: Search for similar catalogs to use as reference? (y/n)

Expected Answer: y

Q: Enter search keywords (technology, product, or catalog name)
   Example: ansible, openshift, ai

Expected Answer: ansible ai
```

**Step 5: Catalog Name**
```
Q: What is your catalog name (slug)?
   Format: lowercase-with-dashes
   Example: agentic-ai-openshift

Expected Answer: your-catalog-slug
```

**Step 6: Display Name**
```
Q: What is the display name for the catalog?
   Example: "Agentic AI on OpenShift"

Expected Answer: Your Catalog Display Name
```

**Step 7: Category**
```
Q: Category? (Workshops, Demos, or Sandboxes)
   - Workshops: Multi-user hands-on labs
   - Demos: Presenter-led demonstrations
   - Sandboxes: Self-service environments

Expected Answer: Workshops
```

**Step 8: Infrastructure**
```
Q: Which infrastructure?
   1. CNV multi-node (Most common - multi-user labs)
   2. CNV SNO (Edge demos, lightweight)
   3. AWS (GPU workloads, high memory)
   4. HCP (Hosted Control Plane)

Expected Answer: 1
```

**Step 9: Multi-user**
```
Q: Multi-user support? (y/n)
   Choose 'y' for workshops with multiple participants

Expected Answer: y
```

**Step 10: Technologies**
```
Q: What technologies will be used? (comma-separated)
   Example: OpenShift AI, Ansible, Pipelines

Expected Answer: OpenShift AI, LiteLLM, Ansible
```

**Step 11: Workload Selection**
```
Based on your technologies, recommended workloads:
  - rhpds.openshift_ai.ocp4_workload_openshift_ai
  - rhpds.litellm_virtual_keys.ocp4_workload_litellm_virtual_keys
  - agnosticd.core_workloads.ocp4_workload_authentication_htpasswd
  - rhpds.showroom.ocp4_workload_showroom

Q: Use these workloads? (y/n)

Expected Answer: y

Q: Add additional workloads? (comma-separated, or press enter to skip)

Expected Answer: (press enter or add custom workloads)
```

**Step 12: UUID Generation (Automatic)**
```
✓ Generating UUID...
✓ Validating uniqueness...
✓ UUID: 12345678-1234-1234-1234-123456789abc
```

**Step 13: Showroom Repository (Auto-detect or Ask)**
```
Q: Path or URL to your Showroom repository?
   - Local path: ~/path/to/showroom
   - HTTPS URL: https://github.com/org/repo

Expected Answer: ~/work/code/showroom/my-workshop
```

**Step 14: Directory Selection**
```
Q: Where should the catalog be created?
   1. agd_v2/ (Standard catalogs - recommended)
   2. enterprise/ (Enterprise-specific)
   3. summit-2025/ (Event-specific)

Expected Answer: 1
```

**Step 15: File Generation (Automatic)**
```
✓ Generating common.yaml...
✓ Generating dev.yaml...
✓ Generating description.adoc...
✓ Generating info-message-template.adoc...
✓ Files created in: agd_v2/your-catalog-slug/
```

**Step 16: Git Commit (Automatic)**
```
✓ Staging files...
✓ Committing to branch...
   git add agd_v2/your-catalog-slug/
   git commit -m "Add your-catalog-slug catalog"
✓ Complete! Ready to push.
```

**Step 17: Next Steps (Displayed)**
```
=== Next Steps ===

1. Review generated files:
   cd ~/work/code/agnosticv/agd_v2/your-catalog-slug/

2. Validate configuration:
   /agnosticv-validator

3. Push to remote:
   git push origin add-your-catalog-name

4. Create pull request:
   gh pr create --fill

5. Test in RHDP Integration before requesting merge
```

### Mode 2: Description Only - Detailed Steps

**Step 1: Mode Selection**
```
Q: What would you like to create or update?
   2. Description Only (description.adoc)

Expected Answer: 2
```

**Step 2: Git Workflow**
```
(Same as Mode 1 - automatic pull/branch)
```

**Step 3: Showroom Path**
```
Q: Path or URL to your Showroom repository?
   (Press Enter to use current directory)

Expected Answer: ~/work/code/showroom/my-workshop
```

**Step 4: Showroom Found or Not?**

**If Showroom content found:**
```
✓ Found Showroom content

📖 Analyzing all module content...
✓ Reading ALL modules (not just index.adoc)
✓ Extracting overview from index.adoc
✓ Detecting Red Hat products across all modules
✓ Extracting version numbers
✓ Identifying technical topics
```

**If NO Showroom content found:**
```
✗ No Showroom content found

Options:
1. Enter description details manually (I'll ask you questions)
2. Create Showroom content first and come back
3. Exit and use Mode 1 (Full Catalog) instead

Your choice [1/2/3]:
```

**Step 5a: Manual Entry (if no Showroom)**
```
Q: Brief overview (3-4 sentences):
   - What is this showing/doing?
   - What is the intended use?
   - Do NOT mention catalog name

Q: Warnings? (GPU, beta/alpha, high memory)
   [optional]

Q: Lab/Demo Guide URL:
   Link to Showroom or repo

Q: Featured Products (max 3-4 with versions):
   Only what matters

Q: How many modules/chapters?
   [number]

For each module:
Q: Module title:
Q: Module details (2-3 bullets max):
   [enter bullets, press Enter twice when done]

Q: Authors:
   [from __meta__.owners or manual]

Q: Content support Slack channel:
Q: Author Slack handle:
Q: Author email [optional]:
```

**Step 5b: Review Extracted Content (if Showroom found)**
```
📝 Description Content Review

I've read ALL X modules and extracted:

Overview (from index.adoc):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[extracted overview]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Products Detected (from all modules):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Red Hat OpenShift AI
- Ansible Automation Platform 2.5
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Q: Is this overview accurate? [Y to use / N to provide custom]:
Q: Are detected products correct? [Y to use / N to customize]:
```

**Step 6: File Generation**
```
✓ Generating description.adoc (RHDP structure)...
  - Brief overview (3-4 sentences max)
  - Warnings (if any)
  - Lab/Demo Guide link
  - Featured Products (max 3-4)
  - Detailed Overview (each module + 2-3 bullets)
  - Authors (from __meta__.owners)
  - Support (Content + Environment)
✓ Auto-committed to branch
```

### Mode 3: Info Template - Detailed Steps

**Step 1: Mode Selection**
```
Q: What would you like to create or update?
   3. Info Message Template (info-message-template.adoc)

Expected Answer: 3
```

**Step 2: Git Workflow**
```
(Same as Mode 1 - automatic pull/branch)
```

**Step 3: Data Keys**
```
Q: What data keys are set in agnosticd_user_info.data?
   Example: api_url, api_key, showroom_url

Expected Answer: litellm_api_url, litellm_api_key, showroom_primary_view_url
```

**Step 4: Lab Code (Optional)**
```
Q: Lab code (e.g., LB1234)? (press enter to skip)

Expected Answer: LB1688
```

**Step 5: File Generation**
```
✓ Generating info-message-template.adoc...
✓ Including data placeholders: {litellm_api_url}, {litellm_api_key}...
✓ Auto-committed to branch
```

---

## Common Workflows

### Workflow 1: Create Full Catalog from Scratch

```
/agnosticv:catalog-builder
→ Mode: 1 (Full Catalog)
→ Git: Pull main, create branch (no feature/ prefix)
→ Search similar catalogs
→ Select infrastructure and workloads
→ Generate all 4 files
→ Auto-commit to branch
```

Then validate and create PR:
```
/agnosticv:validator
→ Check configuration

git push origin your-branch
gh pr create --fill
```

### Workflow 2: Update Description After Content Changes

```
/agnosticv:catalog-builder
→ Mode: 2 (Description Only)
→ Point to Showroom repo
→ Auto-extracts modules and technologies
→ Generates description.adoc
→ Auto-commits to branch
```

### Workflow 3: Add Info Template for User Data

```
/agnosticv:catalog-builder
→ Mode: 3 (Info Template)
→ Specify data keys from workload
→ Generates template with placeholders
→ Shows how to use agnosticd_user_info
```

---

## Mode Details

### Mode 1: Full Catalog

**What it creates:**

**common.yaml** - Main configuration
```yaml
asset_uuid: <generated-uuid>
name: Display Name
category: Workshops
cloud_provider: equinix_metal
workloads:
  - rhpds.showroom.ocp4_workload_showroom
  - rhpds.aap25.ocp4_workload_aap25
```

**dev.yaml** - Dev overrides
```yaml
cloud_provider: "{{ cloud_provider }}"
num_users: 1
```

**description.adoc** - UI description (see example below)

**info-message-template.adoc** - User notification (see example below)

### Mode 2: Description Only

**v1.8.0: Now follows official RHDP structure**

**With Showroom:**
- Reads ALL modules (not just index.adoc)
- Extracts overview from index.adoc
- Detects Red Hat products across all modules
- Extracts version numbers
- Identifies technical topics
- Shows extracted data for review before generating

**Without Showroom:**
- Asks all questions needed for RHDP structure
- Brief overview (3-4 sentences)
- Warnings (optional)
- Guide link
- Featured products (max 3-4)
- Module details (title + 2-3 bullets per module)
- Authors and support information

Generates description.adoc with RHDP official structure:
1. Brief Overview (3-4 sentences max)
2. Warnings (optional, after overview)
3. Lab/Demo Guide (link to Showroom)
4. Featured Technology and Products (max 3-4)
5. Detailed Overview (each module + 2-3 bullets)
6. Authors (from __meta__.owners)
7. Support (Content + Environment)

### Mode 3: Info Template

Documents how to share data:

```yaml
# In your workload:
- name: Save user data
  agnosticd.core.agnosticd_user_info:
    data:
      api_url: "{{ my_api_url }}"
      api_key: "{{ my_api_key }}"
```

Template uses: `{api_url}` and `{api_key}`

---

## Real Examples

### Example description.adoc

**v1.8.0: RHDP Official Structure**

From `agd_v2/vllm-playground-aws/description.adoc`:

```asciidoc
vLLM Playground demonstrates deploying and managing vLLM inference servers using containers with features like structured outputs, tool calling, and MCP integration. This demo uses the ACME Corporation customer support scenario to show how Red Hat AI Inference Server modernizes AI-powered infrastructure. Learners deploy vLLM servers, configure structured outputs, and implement agentic workflows with performance benchmarking.

NOTE: GPU-enabled nodes recommended for optimal performance. CPU-only mode available but slower.

== Demo Guide

* link:https://rhpds.github.io/showroom-vllm-playground[Guide^]

== Featured Technology and Products

* Red Hat Enterprise Linux 10
* vLLM Playground 0.1.1
* Red Hat AI

== Detailed Overview

=== Introduction to vLLM Playground

* Overview of vLLM architecture and container-based deployment
* ACME Corp use case: modernizing customer support with AI
* Deploy first vLLM server instance

=== Structured Outputs Configuration

* Configure JSON schema validation for reliable outputs
* Integrate with downstream systems using structured data
* Test output consistency across multiple requests

=== Tool Calling and MCP Integration

* Implement function calling to extend AI capabilities
* Enable Model Context Protocol for agentic workflows
* Build human-in-the-loop approval system

=== Performance Benchmarking

* Run load tests against vLLM deployments
* Compare CPU vs GPU performance metrics
* Validate production readiness criteria

== Authors

* Michael Tao
* Jane Developer

== Support

=== Content Support

For help with instructions or functionality:

* Slack: #vllm-playground-demo - tag @michael-tao
* Email: mtao@redhat.com

=== Environment Support

For problems with provisioning or environment stability:

* link:https://red.ht/rhdp-ticket[Open RHDP Support Ticket^]
* Slack: link:https://redhat.enterprise.slack.com/archives/C06QWD4A5TE[#forum-demo-redhat-com^]
```

### Example info-message-template.adoc

From `agd_v2/agentic-ai-openshift/info-message-template.adoc`:

```asciidoc
= LB1688: Agentic AI

== Your Lab Environment Access

|===
| Instructions URL | {showroom_primary_view_url}
|===
```

---

## Git Workflow

**Always follows this pattern:**

1. **Pull latest main**
   ```bash
   git checkout main
   git pull origin main
   ```

2. **Create descriptive branch** (NO feature/ prefix)
   ```
   Good: add-ansible-ai-workshop
   Good: update-ocp-pipelines-description
   Bad: feature/add-workshop
   ```

3. **Auto-commit changes**
   ```bash
   git add agd_v2/your-catalog/
   git commit -m "Add your-catalog catalog"
   ```

4. **Push and create PR**
   ```bash
   git push origin your-branch
   gh pr create --fill
   ```

---

## Tips

- **Start with product name** - Description overview must start with product, not "This workshop"
- **Use real examples** - Reference existing catalogs for patterns
- **Validate before PR** - Always run `/agnosticv:validator`
- **Test in dev first** - Use dev.yaml for testing
- **No feature/ prefix** - Branch names should be descriptive without feature/
- **Convert lists to strings** - For info templates: `{{ my_list | join(', ') }}`

---

## Troubleshooting

**Skill not found?**
- Restart Claude Code or VS Code
- Verify installation: `ls ~/.claude/skills/agnosticv-catalog-builder`

**Branch already exists?**
```bash
git branch -D old-branch
# Or use different name
```

**UUID collision?**
- Skill auto-regenerates unique UUID

**Showroom content not found?**
```bash
# Verify structure
ls ~/path/to/showroom/content/modules/ROOT/pages/
# Should contain .adoc files
```

**Description starts with "This workshop"?**
- Must start with product name
- Example: "OpenShift Pipelines enables..." not "This workshop teaches..."

---

## Related Skills

- `/agnosticv:validator` - Validate catalog before PR
- `/showroom:create-lab` - Create Showroom workshop first
- `/ftl` - Create automated graders/solvers

---

## Migration from Old Skills

If you used `/agv-generator` or `/generate-agv-description`:

**Old:** `/agv-generator` → **New:** `/agnosticv:catalog-builder` (Mode 1: Full Catalog)

**Old:** `/generate-agv-description` → **New:** `/agnosticv:catalog-builder` (Mode 2: Description Only)

All functionality consolidated into one unified skill with improved workflow.

---

[← Back to Skills](index.html) | [Next: /agnosticv:validator →](agnosticv-validator.html)
