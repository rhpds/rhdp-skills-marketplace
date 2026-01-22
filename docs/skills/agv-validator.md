---
layout: default
title: /agv-validator
---

# /agv-validator

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

- Catalog files generated (typically from `/agv-generator`)
- Current directory set to agnosticv repository
- Git branch for your changes

---

## Quick Start

1. Navigate to AgnosticV repository
2. Run `/agv-validator`
3. Review validation results
4. Fix any issues found
5. Create pull request when clean

---

## What It Validates

### UUID Compliance

- **Format**: RFC 4122 compliant UUID
- **Case**: Lowercase only (no uppercase)
- **Uniqueness**: Not used by other catalogs
- **Structure**: Proper hyphenation (8-4-4-4-12)

### Category Validation

- **Valid values**: Must be exactly one of:
  - `Workshops`
  - `Demos`
  - `Sandboxes`
- **Case-sensitive**: Must match exactly (plural)
- **Required**: Cannot be empty

### Workload Validation

- **Collection format**: `namespace.collection.role_name`
- **Existence**: Workload must exist in collections
- **Dependencies**: Proper ordering if dependencies exist
- **Naming**: Follows convention (e.g., `ocp4_workload_*`)

### YAML Syntax

- **Valid YAML**: No syntax errors
- **Required fields**: All mandatory fields present
- **Data types**: Correct types for each field
- **Indentation**: Consistent spacing

### File Structure

- **Required files**: common.yaml, dev.yaml, description.adoc
- **File paths**: Correct directory structure
- **Naming**: Follows catalog naming convention

---

## Common Workflow

### 1. Generate Catalog

```
/agv-generator
→ Create catalog files
```

### 2. Validate Configuration

```
/agv-validator
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
/agv-validator
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
- Verify installation: `ls ~/.claude/skills/agv-validator`

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

- `/agv-generator` - Generate catalog first
- `/generate-agv-description` - Create catalog description
- `/create-lab` - Create workshop content

---

[← Back to Skills](index.html) | [Next: /agv-catalog →](agv-catalog.html)
