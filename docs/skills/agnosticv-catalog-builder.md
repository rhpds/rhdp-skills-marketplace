---
layout: default
title: /agnosticv-catalog-builder
---

# /agnosticv-catalog-builder

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
   - Workshop lab content (from `/create-lab`)
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
2. Run `/agnosticv-catalog-builder`
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

## Common Workflows

### Workflow 1: Create Full Catalog from Scratch

```
/agnosticv-catalog-builder
→ Mode: 1 (Full Catalog)
→ Git: Pull main, create branch (no feature/ prefix)
→ Search similar catalogs
→ Select infrastructure and workloads
→ Generate all 4 files
→ Auto-commit to branch
```

Then validate and create PR:
```
/agv-validator
→ Check configuration

git push origin your-branch
gh pr create --fill
```

### Workflow 2: Update Description After Content Changes

```
/agnosticv-catalog-builder
→ Mode: 2 (Description Only)
→ Point to Showroom repo
→ Auto-extracts modules and technologies
→ Generates description.adoc
→ Auto-commits to branch
```

### Workflow 3: Add Info Template for User Data

```
/agnosticv-catalog-builder
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

Extracts from Showroom:
- Module titles for agenda
- Technologies mentioned
- Git author from config
- GitHub Pages URL from remote

Generates clean AsciiDoc following RHDP standards.

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

From `agd_v2/vllm-playground-aws/description.adoc`:

```asciidoc
= VLLM Playground

vLLM Playground is a management interface for deploying and managing vLLM inference servers using containers.

== Business Outcomes

* Deploy and manage vLLM servers using containers
* Configure structured outputs for reliable system integration
* Implement tool calling to extend AI capabilities

== Demo Options

* **15-20 min** - Executive brief
* **30-45 min** - Technical demo
* **60 min** - Full deep dive

== Products

* Red Hat AI
* Red Hat Enterprise Linux 10
* vLLM Playground
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
- **Validate before PR** - Always run `/agv-validator`
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

- `/agv-validator` - Validate catalog before PR
- `/create-lab` - Create Showroom workshop first
- `/ftl` - Create automated graders/solvers

---

## Migration from Old Skills

If you used `/agv-generator` or `/generate-agv-description`:

**Old:** `/agv-generator` → **New:** `/agnosticv-catalog-builder` (Mode 1: Full Catalog)

**Old:** `/generate-agv-description` → **New:** `/agnosticv-catalog-builder` (Mode 2: Description Only)

All functionality consolidated into one unified skill with improved workflow.

---

[← Back to Skills](index.html) | [Next: /agv-validator →](agv-validator.html)
