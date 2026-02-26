# Mode 4: Create Virtual CI (published/)

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

Known valid values (from `@agnosticv/docs/constants.md`):
- Hybrid_Platforms
- Application_Services
- Ansible
- RHEL
- Cloud_Services
- AI

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

