---
layout: default
title: /agnosticv:validator
---

# /agnosticv:validator

Validate AgnosticV catalog configurations and best practices before creating pull request.

---

## Before You Start

### Prerequisites

1. **Have AgnosticV repository cloned:**
   ```bash
   cd ~/work/code/agnosticv
   ```

2. **Catalog files created:**
   ```bash
   # Your catalog should exist:
   agd_v2/your-catalog-name/
   ├── common.yaml
   ├── dev.yaml
   └── description.adoc
   ```

3. **Verify repository is up to date:**
   ```bash
   git checkout main
   git pull origin main
   ```

### What You'll Need

- Catalog files generated (typically from `/agnosticv:catalog-builder`)
- Current directory set to agnosticv repository
- Git branch for your changes

---

## Quick Start

1. Navigate to AgnosticV repository
2. Run `/agnosticv:validator`
3. Review validation results
4. Fix any issues found
5. Create pull request when clean

---

## What It Validates

The validator performs 17 comprehensive checks across your catalog:

### Check 1: File Structure

- **Required files**: common.yaml must exist
- **Recommended files**: dev.yaml, description.adoc, info-message-template.adoc
- **File paths**: Correct directory structure
- **Naming**: Follows catalog naming convention

### Check 2: UUID Compliance

- **Format**: RFC 4122 compliant UUID
- **Case**: Lowercase only (no uppercase)
- **Uniqueness**: Not used by other catalogs
- **Structure**: Proper hyphenation (8-4-4-4-12)

### Check 3: Category Validation

- **Valid values**: Must be exactly one of:
  - `Workshops` - Multi-user hands-on learning
  - `Demos` - Single-user presenter-led (MUST NOT be multi-user)
  - `Labs` - General learning environments
  - `Sandboxes` - Self-service playgrounds
  - `Brand_Events` - Events like Red Hat Summit, Red Hat One
- **Case-sensitive**: Must match exactly (plural)
- **Required**: Cannot be empty
- **Demo rules**:
  - Demos MUST be single-user (ERROR if multiuser: true)
  - Demos MUST NOT have workshopLabUiRedirect enabled (ERROR)

### Check 4-9: Core Validation

- **Check 4: Workloads** - Collection format, existence, dependencies, naming
- **Check 5: Authentication** - HTPasswd or LDAP configuration
- **Check 6: Showroom** - Content repository and workload setup
- **Check 7: Infrastructure** - CNV pools, AWS, or SNO configuration
- **Check 8: YAML Syntax** - Valid YAML, required fields, data types
- **Check 9: Best Practices** - Naming conventions, documentation

### Check 10: Stage Files Validation

- **dev.yaml**: Must have `purpose: development`
- **event.yaml**: Should have `purpose: events` (if exists)
- **prod.yaml**: Should have `purpose: production` (if exists)
- **scm_ref**: Validates deployment repository references

### Check 11: Multi-User Configuration (CRITICAL)

- **num_users parameter**: Required for multi-user catalogs
- **worker_instance_count**: Must scale with num_users
- **workshopLabUiRedirect**:
  - **WARNING** if not enabled for multi-user workshops
  - Multi-user workshops SHOULD enable this for per-user lab UI routing
- **Category compliance**: Workshops/Brand_Events must be multi-user

### Check 12: Bastion Configuration

- **Image version**: RHEL 9.4-10.0 recommended
- **Resources**: Minimum 2 cores, 4Gi memory
- **Configuration**: Proper bastion setup for CNV pools

### Check 13: Collection Versions

- **Git collections**: Must specify version (not allowed to omit)
- **Galaxy collections**: Version validation
- **Format**: Proper requirements_content structure

### Check 14: Deployer Configuration

- **scm_url**: Must point to agnosticd-v2 repository
- **scm_ref**: Deployment reference (main, tag, branch)
- **execution_environment**: Container image for deployment

### Check 14a: Reporting Labels (CRITICAL - ERROR if missing)

- **primaryBU**: **REQUIRED** for business unit tracking
  - Examples: `Hybrid_Platforms`, `Application_Services`, `Ansible`, `RHEL`
  - Used for tracking and reporting across RHDP
  - **ERROR severity** if missing

### Check 15: Component Propagation

- **Multi-stage catalogs**: Validates data flow between stages
- **propagate_provision_data**: Ensures proper variable passing
- **Component structure**: Validates __meta__.components configuration

### Check 16: AsciiDoc Templates

- **description.adoc**: Required catalog description
- **info-message-template.adoc**: Required user notification template
- **Variable substitutions**: Validates {variable} syntax usage
- **Content quality**: Checks for proper structure

---

## Common Workflow

### 1. Generate Catalog

```
/agnosticv:catalog-builder
→ Create catalog files
```

### 2. Validate Configuration

```
/agnosticv:validator
→ Check for issues
→ Get validation report
```

### 3. Fix Issues

```
# Fix reported issues in:
- common.yaml
- dev.yaml
- description.adoc
```

### 4. Re-validate

```
/agnosticv:validator
→ Confirm all issues resolved
```

### 5. Create Pull Request

```bash
git checkout -b add-your-catalog
git add agd_v2/your-catalog-name/
git commit -m "Add your-catalog catalog"
git push origin add-your-catalog
gh pr create --fill
```

---

## Example Validation Report

```
✅ UUID: Valid and unique (a1b2c3d4-e5f6-7890-abcd-ef1234567890)
✅ Category: Valid value (Workshops)
✅ Workloads: All collections found
⚠️  Description: Missing estimated time
❌ common.yaml: Invalid cloud_provider value
```

---

## Common Issues and Fixes

### UUID Issues

**Problem**: UUID contains uppercase letters
```yaml
# ❌ Wrong:
asset_uuid: A1B2C3D4-E5F6-7890-ABCD-EF1234567890
```

**Fix**: Convert to lowercase
```yaml
# ✅ Correct:
asset_uuid: a1b2c3d4-e5f6-7890-abcd-ef1234567890
```

### Category Issues

**Problem**: Wrong category name
```yaml
# ❌ Wrong:
category: Workshop  # Singular or wrong case
```

**Fix**: Use exact plural form
```yaml
# ✅ Correct:
category: Workshops  # Must be: Workshops, Demos, or Sandboxes
```

### Workload Issues

**Problem**: Incorrect workload format
```yaml
# ❌ Wrong:
workloads:
  - showroom  # Missing collection namespace
```

**Fix**: Use full collection path
```yaml
# ✅ Correct:
workloads:
  - rhpds.showroom.ocp4_workload_showroom
```

---

## Tips

- **Always validate** before creating PR
- Fix critical errors (❌) first
- Address warnings (⚠️) next
- Run validator multiple times as you fix issues
- Check against similar catalogs for patterns
- Keep common.yaml and dev.yaml in sync

---

## Troubleshooting

**Skill not found?**
- Restart Claude Code or VS Code
- Verify installation: `ls ~/.claude/skills/agnosticv-validator`

**Validation fails but looks correct?**
- Check for hidden characters or extra spaces
- Verify YAML indentation (use spaces, not tabs)
- Compare with working catalog examples

**Workload not found error?**
- Check `~/.claude/docs/workload-mappings.md`
- Verify collection is published
- Ensure namespace.collection.role format

---

## Related Skills

- `/agnosticv:catalog-builder` - Create/update catalog (unified skill)
- `/showroom:create-lab` - Create workshop content

---

[← Back to Skills](index.html) | [Next: /agnosticv:catalog-builder →](agnosticv-catalog-builder.html)
