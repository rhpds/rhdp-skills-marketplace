---
layout: default
title: /agv-generator
---

# /agv-generator

Create AgnosticV catalog items with infrastructure provisioning configuration for RHDP.

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

3. **Have your workshop content ready:**
   - Workshop lab content (from `/create-lab`)
   - Infrastructure requirements (CNV, AWS, etc.)
   - Workload list (OpenShift AI, AAP, etc.)

### What You'll Need

- Catalog name (e.g., "Agentic AI on OpenShift")
- Category (Workshops, Demos, or Sandboxes)
- Infrastructure type (CNV multi-node, AWS, SNO, etc.)
- Workloads to deploy
- Multi-user requirements (yes/no)

---

## Quick Start

1. Navigate to AgnosticV repository
2. Run `/agv-generator`
3. Answer guided questions
4. Review generated files
5. Create pull request

---

## What It Creates

```
~/work/code/agnosticv/agd_v2/your-catalog-name/
├── common.yaml          # Shared configuration
├── dev.yaml            # Development environment
└── description.adoc    # Catalog description
```

---

## Common Workflow

### 1. Generate Catalog

```bash
cd ~/work/code/agnosticv
# Run in Claude Code:
/agv-generator
→ Answer configuration questions
→ Generates catalog files
```

### 2. Validate Catalog

```
/agv-validator
→ Checks UUID, category, workloads
→ Validates YAML syntax
```

### 3. Create Pull Request

```bash
git checkout -b add-your-catalog
git add agd_v2/your-catalog-name/
git commit -m "Add your-catalog catalog"
git push origin add-your-catalog
gh pr create --fill
```

---

## Configuration Details

### UUID Format

- Must be RFC 4122 compliant
- Lowercase only
- Unique across all catalogs
- Generated automatically by skill

### Category Rules

Must be **exactly** one of:
- `Workshops` (hands-on learning)
- `Demos` (presenter-led)
- `Sandboxes` (self-service environments)

### Infrastructure Options

- **CNV multi-node**: Standard OpenShift cluster
- **AWS**: Cloud-based deployment
- **SNO**: Single-node OpenShift
- **HCP**: Hosted control plane

---

## Example: Creating Workshop Catalog

```
Catalog name: "Ansible Automation Platform Self-Service"
Category: Workshops
Infrastructure: CNV multi-node
Multi-user: Yes
Workloads:
  - AAP 2.5
  - OpenShift GitOps
  - Showroom
```

Generated `common.yaml`:
```yaml
asset_uuid: a1b2c3d4-e5f6-7890-abcd-ef1234567890
name: Ansible Automation Platform Self-Service
category: Workshops
cloud_provider: equinix_metal
sandbox_architecture: standard
workloads:
  - rhpds.aap25.ocp4_workload_aap25
  - rhpds.openshift_gitops.ocp4_workload_openshift_gitops
  - rhpds.showroom.ocp4_workload_showroom
```

---

## Tips

- Always validate with `/agv-validator` before PR
- Use descriptive catalog names
- Check existing catalogs for workload naming
- Test in dev environment first

---

## Troubleshooting

**UUID conflict?**
- Skill checks uniqueness automatically
- If conflict, generates new UUID

**Category validation failed?**
- Must be exactly: Workshops, Demos, or Sandboxes
- Case-sensitive, plural form required

**Workload not found?**
- Check `~/.claude/docs/workload-mappings.md`
- Use exact workload collection names

---

## Related Skills

- `/agv-validator` - Validate catalog configuration
- `/generate-agv-description` - Generate catalog description
- `/create-lab` - Create workshop content first

---

[← Back to Skills](../index.html) | [Next: /agv-validator →](agv-validator.html)
