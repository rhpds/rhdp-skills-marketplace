---
description: "Critical rules for AgnosticV catalog creation - UUID validation, category exactness, YAML standards"
alwaysApply: true
---

# AgnosticV Catalog Creation - Critical Rules

**IMPORTANT**: These rules apply to ALL AgnosticV catalog creation and validation tasks.

## 1. UUID Validation (MANDATORY)

All catalog items MUST have valid UUIDs:

**Format**: RFC 4122 compliant
```
Valid:   a1b2c3d4-e5f6-7890-abcd-ef1234567890
Invalid: A1B2C3D4-E5F6-7890-ABCD-EF1234567890 (uppercase)
Invalid: a1b2c3d4e5f67890abcdef1234567890 (no hyphens)
```

**Uniqueness**: Must be unique across entire AgnosticV repository
- Check against `agd_v2/` directory
- Search for UUID in all `common.yaml` files

**Generation**: Use Python `uuid.uuid4()` or `uuidgen` command

## 2. Category Validation (MANDATORY)

Category field MUST be EXACTLY one of:
- `Workshops`
- `Demos`
- `Sandboxes`

**Case-sensitive exact match required**. Common errors:
```
❌ Wrong: "Workshop", "workshop", "WORKSHOPS"
✅ Correct: "Workshops"

❌ Wrong: "Demo", "demo"
✅ Correct: "Demos"

❌ Wrong: "Sandbox", "sandbox"
✅ Correct: "Sandboxes"
```

## 3. YAML Standards

- Valid YAML syntax (no tabs, proper indentation)
- Required fields in `common.yaml`:
  - `asset_uuid`
  - `name`
  - `category`
  - `description`
  - `cloud_provider`
  - `sandbox_architecture`
  - `workloads`

## 4. Workload Dependencies

- Use `agnosticd_user_data` lookup for inter-workload communication
- Set data with `agnosticd_user_info` in first workload
- Retrieve with `lookup('agnosticd_user_data', 'variable_name')` in subsequent workloads
- Always include `| default('')` for graceful fallback

## 5. Infrastructure Recommendations

Consult these resources:
- Infrastructure patterns: `~/.cursor/docs/infrastructure-guide.md` or `~/.claude/docs/infrastructure-guide.md`
- Workload compatibility: `~/.cursor/docs/workload-mappings.md` or `~/.claude/docs/workload-mappings.md`

## 6. File Structure

Standard AgnosticV catalog structure:
```
~/work/code/agnosticv/agd_v2/<catalog-name>/
├── common.yaml        # Shared configuration
├── dev.yaml          # Development environment
└── description.adoc  # Catalog description
```

## Documentation Reference

For complete standards, read: `~/.cursor/docs/AGV-COMMON-RULES.md` or `~/.claude/docs/AGV-COMMON-RULES.md`
