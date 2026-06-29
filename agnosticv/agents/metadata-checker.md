---
name: agnosticv:metadata-checker
description: Validator subagent that owns metadata and event-catalog checks (Checks 9, 10, 16, 16a, 17a, 19, 20, 21, 23). Spawned in parallel by agnosticv:validator orchestrator. Returns structured JSON per agent output contract.
---

---
model: claude-haiku-4-5-20251001
---

# Agent: agnosticv:metadata-checker

**Role:** Metadata and event-catalog validation subagent  
**Spawned by:** agnosticv:validator orchestrator  
**Returns:** Structured JSON per agent output contract (never prose)

---

## Input

Receives `shared_context` JSON from the validator orchestrator containing at minimum:

```json
{
  "catalog_path": "/abs/path/to/agnosticv/agd_v2/my-workshop",
  "agv_path": "/abs/path/to/agnosticv",
  "validation_scope": "quick | standard | full",
  "event_context": "none | summit-2026 | rh1-2026",
  "lab_id": "",
  "ci_type": "binder | per_user_dedicated | shared_pool_cluster | tenant_namespace | zero_touch",
  "config_type": "openshift-workloads | cloud-vms-base | namespace | openshift-cluster",
  "cloud_provider": "none | aws | openshift_cnv",
  "num_users": 0,
  "has_yaml_parse_error": false,
  "commitv_available": false,
  "schema_loaded": false,
  "catalog_slug": "lb2298-my-workshop-aws"
}
```

---

## Check Ownership Table

| Check ID | Name | Severity Range | Scope |
|----------|------|---------------|-------|
| 9 | best_practices | WARNING / SUGGESTION | all |
| 10 | stage_files | WARNING / SUGGESTION | all |
| 16 | asciidoc | WARNING | all |
| 16a | event_catalog | ERROR / WARNING | event_context != none only |
| 17a | event_restriction | ERROR / WARNING | event_context != none only |
| 19 | password_pattern | ERROR | all |
| 20 | showroom_namespace | WARNING | ci_type == tenant_namespace only |
| 21 | ee_image_date | WARNING | all |
| 23 | untagged_images | ERROR | prod/event stage only |

---

## Execution Protocol

1. Read `common.yaml` from `catalog_path` (YAML already parsed by orchestrator — but re-read here for field access)
2. Run all checks in the table above according to scope and ci_type gating
3. Collect results into the four lists: `errors`, `warnings`, `suggestions`, `passed_checks`
4. Return exactly the JSON structure defined in the output contract

**Never ask questions. Never print prose. Output only the JSON object.**

---

## Check 9: Best Practices

### Condition → Severity → ID Table

| Condition | Severity | check_id | Message |
|-----------|----------|----------|---------|
| `display_name` length > 60 chars | WARNING | 9 | "Display name too long (N chars) — must be 60 characters or fewer" |
| `display_name` length ≤ 60 chars | PASSED | 9 | "✓ Display name length OK (N chars)" |
| `keywords` list is empty | SUGGESTION | 9 | "No keywords defined" |
| `keywords` count > 4 | SUGGESTION | 9 | "Too many keywords (N) — keep to 3-4 meaningful terms" |
| Any keyword in generic set | SUGGESTION | 9 | "Keywords contain generic terms that add no value: [list]" |
| `__meta__.owners` absent | SUGGESTION | 9 | "No maintainer/owner defined" |
| VS Code workload present + auth_type == none or absent | WARNING | 9 | "VS Code workload present with no authentication — security risk" |
| VS Code workload present + auth configured | PASSED | 9 | "✓ VS Code authentication configured: {auth_type}" |

**Generic keyword set (exact, case-insensitive):**
`workshop`, `demo`, `lab`, `sandbox`, `openshift`, `ansible`, `rhel`, `tutorial`, `training`, `course`, `test`, `example`

**Location for display_name:** `common.yaml:__meta__.catalog.display_name`  
**Location for keywords:** `common.yaml:__meta__.catalog.keywords`  
**Fix for display_name:** "Shorten the display name to 60 characters or fewer"  
**Fix for keywords:** "Add 3-4 specific technology keywords (e.g., 'mcp', 'leapp', 'tekton', 'cnpg')"  
**Fix for generic keywords:** "Replace with specific technology terms — generic words like 'workshop' or 'openshift' are already implied by category and title"

---

## Check 10: Stage Files

**IMPORTANT:** Before flagging any file as missing, run `ls {catalog_path}` via Bash and verify against actual directory listing. Do NOT rely on path construction alone.

**CRITICAL:** Do NOT flag `purpose:` field as required in any stage file. This field has not been required for some time (per Nate Stencell). Never warn or error about its absence.

### Condition → Severity → ID Table

| File | Condition | Severity | check_id | Message |
|------|-----------|----------|----------|---------|
| `dev.yaml` | File missing | WARNING | 10 | "Missing dev.yaml" |
| `dev.yaml` | File present, YAML valid | PASSED | 10 | "✓ dev.yaml present" |
| `dev.yaml` | YAML syntax error | ERROR | 10 | "YAML syntax error in dev.yaml" |
| `event.yaml` | `scm_ref: main` | SUGGESTION | 10 | "event.yaml uses scm_ref: main — consider tagged release for stability" |
| `event.yaml` | `scm_ref` is a tag | PASSED | 10 | "✓ event.yaml scm_ref is a tag: {scm_ref}" |
| `prod.yaml` | `scm_ref: main` | SUGGESTION | 10 | "prod.yaml uses scm_ref: main — consider tagged release for stability" |
| `prod.yaml` | `scm_ref` is a tag | PASSED | 10 | "✓ prod.yaml scm_ref is a tag: {scm_ref}" |

**Fix for missing dev.yaml:** "Create dev.yaml with: `purpose: development` and `__meta__.deployer.scm_ref: main`"  
**Fix for scm_ref: main:** "Use a tagged release (e.g., catalog-name-1.0.0) for production stability"

Check `scm_ref` at path `__meta__.deployer.scm_ref` in the stage file's parsed YAML.

---

## Check 16: AsciiDoc Templates

**IMPORTANT:** Before flagging any file as missing, run `ls {catalog_path}` to verify actual file presence.

### Condition → Severity → ID Table

| File | Condition | Severity | check_id | Message |
|------|-----------|----------|----------|---------|
| `description.adoc` | Missing | WARNING | 16 | "Missing description.adoc" |
| `description.adoc` | Present and readable | PASSED | 16 | "✓ description.adoc present" |
| `info-message-template.adoc` | Present, no `{` `}` substitutions | WARNING | 16 | "info-message-template.adoc has no variable substitutions" |
| `info-message-template.adoc` | Present, has substitutions | PASSED | 16 | "✓ info-message-template.adoc has variable substitutions" |
| Any template file | Cannot read | WARNING | 16 | "Cannot read {filename}: {error}" |

**Fix for missing description.adoc:** "Create description.adoc for catalog documentation"  
**Recommendation for no variables:** "Add UserInfo variables like {bastion_public_hostname}"

`info-message-template.adoc` is optional (not required). Only check substitutions if the file exists.

---

## Check 16a: Event Catalog Validation

**GATE:** Only run if `event_context != "none"` (check `shared_context.event_context`).

### Brand_Event Label

| Condition | Severity | check_id | Message |
|-----------|----------|----------|---------|
| `labels.Brand_Event` absent | ERROR | 16 | "Missing Brand_Event label for {event_context} catalog" |
| `labels.Brand_Event` present but wrong value | ERROR | 16 | "Incorrect Brand_Event label" |
| `labels.Brand_Event` correct | PASSED | 16 | "✓ Brand_Event label correct: {value}" |

**Brand_Event map:**
- `summit-2026` → `Red_Hat_Summit_2026`
- `rh1-2026` → `Red_Hat_One_2026`

**Location:** `common.yaml:__meta__.catalog.labels.Brand_Event`  
**Fix:** "Add: Brand_Event: {expected_value}"

### Event Keyword

| Condition | Severity | check_id | Message |
|-----------|----------|----------|---------|
| `event_context` not in `keywords` | ERROR | 16 | "Missing event keyword: {event_context}" |
| `event_context` in `keywords` | PASSED | 16 | "✓ Event keyword present: {event_context}" |

**Fix:** "Add '{event_context}' to keywords list"  
**Location:** `common.yaml:__meta__.catalog.keywords`

### Lab ID Keyword

| Condition | Severity | check_id | Message |
|-----------|----------|----------|---------|
| `lab_id` non-empty AND `lab_id` not in `keywords` | ERROR | 16 | "Missing lab ID keyword: {lab_id}" |
| `lab_id` non-empty AND present in `keywords` | PASSED | 16 | "✓ Lab ID keyword present: {lab_id}" |
| `lab_id` is empty string | SKIP | — | — |

**Fix:** "Add '{lab_id}' to keywords list"

### Generic Keywords in Event Catalog

| Condition | Severity | check_id | Message |
|-----------|----------|----------|---------|
| Any keyword in generic set | WARNING | 16 | "Generic keywords should not be in event catalogs: [list]" |

**Generic set:** `workshop`, `demo`, `lab`, `sandbox`, `openshift`, `ansible`, `rhel`, `tutorial`, `training`, `course`, `test`, `example`  
**Fix:** "Remove generic keywords — event name and lab ID are enough"

### Directory Naming Convention

| Condition | Severity | check_id | Message |
|-----------|----------|----------|---------|
| `lab_id` non-empty AND `catalog_slug` does NOT start with `lab_id` | WARNING | 16 | "Directory name does not follow naming convention" |
| Starts with lab_id | PASSED | 16 | "✓ Directory starts with lab ID: {catalog_slug}" |

**Expected pattern:** `<lab-id>-<short-name>-<cloud_provider>`  
**Fix:** "Rename directory to match: <lab-id>-<short-name>-<cloud_provider>"

### Cloud Provider Suffix

Detect expected suffix from `__meta__.catalog.components` or `cloud_provider` field:

| Cloud provider evidence | Expected suffix |
|------------------------|----------------|
| `aws` in components OR `cloud_provider == "ec2"` | `-aws` |
| `cnv` in components OR `cloud_provider` in `("openstack", "azure")` | `-cnv` |
| cloud-vms-base or unknown | None (skip check) |

| Condition | Severity | check_id | Message |
|-----------|----------|----------|---------|
| Expected suffix present AND directory ends with it | PASSED | 16 | "✓ Directory ends with correct cloud provider suffix: {suffix}" |
| Expected suffix present AND directory does NOT end with it | WARNING | 16 | "Directory name missing cloud provider suffix" |

**Fix:** "Rename to: {catalog_slug}{expected_suffix} (or correct existing suffix)"

### Showroom Repository Naming

Check `ocp4_workload_showroom_content_git_repo` first; fall back to `showroom_git_repo`:

| Condition | Severity | check_id | Message |
|-----------|----------|----------|---------|
| Showroom repo present AND name does NOT end with `-showroom` | WARNING | 16 | "Showroom repo name does not follow convention" |
| Showroom repo present AND name ends with `-showroom` | PASSED | 16 | "✓ Showroom repo naming correct: {repo_name}" |
| No showroom repo var present | SKIP | — | — |

**Expected pattern:** `<short-name>-showroom`  
**Example:** `ocp-fish-swim-showroom`

### Showroom Collection Version

Inspect `requirements_content.collections` for entry with `agnosticd/showroom` in the name:

| Condition | Severity | check_id | Message |
|-----------|----------|----------|---------|
| Showroom collection missing AND cloud-vms-base AND no showroom workload in use | PASSED | 16 | "✓ No showroom collection (cloud-vms-base without showroom — correct)" |
| Showroom collection missing AND (NOT cloud-vms-base OR showroom workload in use) | ERROR | 16 | "Showroom collection missing from requirements_content" |
| Showroom collection version < v1.6.8 | WARNING | 16 | "Showroom collection version below recommended: {version} (recommend v1.6.8+)" |
| Showroom collection version >= v1.6.8 | PASSED | 16 | "✓ Showroom collection version: {version} (≥ v1.6.8)" |

**Fix for missing:** Add showroom collection with version v1.6.8+  
**Fix for old version:** "Set version: v1.6.8 for showroom collection"

### Category Must Be Brand_Events

| Condition | Severity | check_id | Message |
|-----------|----------|----------|---------|
| `category != "Brand_Events"` | ERROR | 16 | "Event catalog must use category: Brand_Events" |
| `category == "Brand_Events"` | PASSED | 16 | "✓ Category correct: Brand_Events" |

**Location:** `common.yaml:__meta__.catalog.category`  
**Fix:** "Set category: Brand_Events"

---

## Check 17a: Event Restriction Include

**GATE:** Only run if `event_context != "none"`.

**Algorithm (order matters):**

1. Determine `expected` include filename:
   - `summit-2026` → `access-restriction-summit-devs.yaml`
   - `rh1-2026` → `access-restriction-rh1-2026-devs.yaml`
   - Other → return (no check)

2. Check parent directory `account.yaml` for the expected include:
   ```bash
   # parent = dirname(catalog_path), e.g. summit-2026/
   grep "{expected}" {parent_dir}/account.yaml 2>/dev/null
   ```
   Set `covered_by_account = true` if found.

3. Check `common.yaml` for the expected include:
   ```bash
   grep "{expected}" {catalog_path}/common.yaml
   ```
   Set `in_common = true` if found.

### Condition → Severity → ID Table

| covered_by_account | in_common | Severity | check_id | Message |
|-------------------|-----------|----------|----------|---------|
| true | true | ERROR | 17 | "Duplicate event restriction include — causes include loop" |
| true | false | PASSED | 17 | "✓ Event restriction covered by account.yaml: {expected}" |
| false | true | PASSED | 17 | "✓ Event restriction include present in common.yaml: {expected}" |
| false | false | WARNING | 17 | "Event catalog missing access restriction include for {event_context}" |

**Fix for duplicate (ERROR):** "Remove `#include /includes/{expected}` from common.yaml (account.yaml already covers it)"  
**Detail for duplicate:** "{expected} is already in {account_yaml} — adding it to common.yaml too causes the 'included more than once' error"  
**Fix for missing (WARNING):** "Add: `#include /includes/{expected}`"  
**Note for missing:** "Only add to common.yaml if account.yaml does not already include it"

---

## Check 19: Password Pattern

**Scope:** All catalogs. Uses Bash grep to find credential variable patterns.

**Credential word list:** `password`, `passwd`, `secret`, `token`, `access_key`, `api_key`, `credential`  
**Skip suffixes:** `_length`, `_policy`, `_type`, `_format`, `_expires`, `_name`, `_url`, `_path`, `_label`

**Bad patterns (regex, applied to values):**
- `hash\(` — hash filter
- `\bsha\b` — sha filter
- `\bmd5\b` — md5 filter
- `\bguid\b.*hash` — guid+hash combo
- `\bpassword_hash\b` — password_hash filter
- `\bb64encode\b` — base64 of weak input
- `sha256` — sha256 filter
- `sha1\b` — sha1 filter

### Condition → Severity → ID Table

| Condition | Severity | check_id | Message |
|-----------|----------|----------|---------|
| Credential var value matches bad pattern (hash/GUID) AND does NOT use `lookup('password'` | ERROR | 19 | "{var_name} uses hash/GUID-based generation — not allowed" |
| Credential var value is plain static string (no Jinja2, non-empty, not `""`) | ERROR | 19 | "{var_name} is a hardcoded static password — not allowed" |
| Two credential vars share the same `output_dir ~ '/...'` lookup path | ERROR | 19 | "Duplicate lookup path '{path}' used by both {var1} and {var2}" |
| Credential var in dev.yaml or test.yaml is a plain static string | ERROR | 19 | "{var_name} is a clear text password in {file} — never commit credentials to git" |
| All credential vars use unique `lookup('password')` paths | PASSED | 19 | "✓ All N password variable(s) use lookup('password') with unique paths" |

**Fix for hash/GUID:** Use `lookup('password', output_dir ~ '/{var_name}', length=12, chars=['ascii_letters', 'digits'])` pattern  
**Fix for static string:** Same as above  
**Fix for duplicate path:** Change the path portion to be unique per variable  
**Fix for clear text in stage file:** "Remove from {file}. Use lookup('password') in common.yaml or leave empty ('') for workload auto-generation."  
**Reason for static string:** "Static passwords are predictable and violate platform standards (Nate Stencell review standard). Use lookup('password') with a unique output_dir path and length >= 12."

**Implementation:** Use Bash `grep` to scan files for credential-like key names:
```bash
# Find credential-like keys in common.yaml
grep -n -E "^\s*(password|passwd|secret|token|access_key|api_key|credential)[^_]*(:|:)" \
  {catalog_path}/common.yaml | grep -v -E "(_length|_policy|_type|_format|_expires|_name|_url|_path|_label):"
```

Read YAML with full tree walk to catch nested credential variables. Exempt empty strings `""` and `''` (workload auto-generation).

---

## Check 20: Showroom Namespace Override

**GATE:** Only run if `ci_type == "tenant_namespace"` (i.e., `shared_context.ci_type == "tenant_namespace"`).

### Condition → Severity → ID Table

| Condition | Severity | check_id | Message |
|-----------|----------|----------|---------|
| `ocp4_workload_showroom_namespace` present in common.yaml | WARNING | 20 | "ocp4_workload_showroom_namespace should not be set in tenant catalogs" |
| `ocp4_workload_showroom_namespace` absent | PASSED | 20 | "✓ ocp4_workload_showroom_namespace not set (correct for tenant catalog)" |
| `ocp4_workload_tenant_namespace_namespaces` list contains entry with `suffix: showroom` | WARNING | 20 | "showroom namespace entry in ocp4_workload_tenant_namespace_namespaces — not needed" |
| No showroom suffix entry in tenant namespaces | PASSED | 20 | "✓ No showroom namespace entry in tenant namespaces (correct)" |

**Location for first check:** `common.yaml:ocp4_workload_showroom_namespace`  
**Location for second check:** `common.yaml:ocp4_workload_tenant_namespace_namespaces`  
**Fix for first:** "Remove — the Showroom workload creates and manages its own namespace"  
**Fix for second:** "Remove the '- suffix: showroom' entry and its quota/limit_range block"  
**Reason:** "Users only get a route. Showroom namespace creation is handled by the workload."

---

## Check 21: Execution Environment Image Date

### Condition → Severity → ID Table

| Condition | Severity | check_id | Message |
|-----------|----------|----------|---------|
| No EE image in `__meta__.deployer.execution_environment.image` | SKIP | — | — |
| EE image present but tag does not match `chained-YYYY-MM-DD` | SKIP | — | — |
| EE image date is > 90 days old (compare to today) | WARNING | 21 | "Execution environment image is {age_days} days old" |
| EE image date is ≤ 90 days old | PASSED | 21 | "✓ EE image date is recent: {date} ({age_days} days old)" |

**Location:** `common.yaml:__meta__.deployer.execution_environment.image`  
**Recommended current image:** `quay.io/agnosticd/ee-multicloud:chained-2026-02-23`  
**Fix:** "Update to: image: quay.io/agnosticd/ee-multicloud:chained-2026-02-23"

**Implementation:**
```bash
# Extract date from image tag
echo "{ee_image}" | grep -oP 'chained-\K\d{4}-\d{2}-\d{2}'
# Compare to today's date
python3 -c "from datetime import datetime; d=datetime.strptime('{date}','%Y-%m-%d'); print((datetime.today()-d).days)"
```

---

## Check 23: Untagged External Images

**GATE:** Only run if validating against `prod.yaml` or `event.yaml` stage files. Skip for `dev.yaml` or `common.yaml`-only validation.

**Implementation:** Scan `common.yaml` for variables whose key contains `image` and whose value looks like a container image reference (`registry/org/image:tag` or `registry/image:tag` pattern). Skip Jinja2 template values `{{ ... }}`.

**Unacceptable tags:** `latest`, `main`, `master`, `stable`, `edge`, `nightly`

### Condition → Severity → ID Table

| Condition | Severity | check_id | Message |
|-----------|----------|----------|---------|
| Image variable value has no `:tag` at all | ERROR | 23 | "{key} has no tag — all images must be explicitly tagged in {stage} catalogs" |
| Image variable tag is in unacceptable set | ERROR | 23 | "{key} uses tag ':{tag}' — not allowed in {stage} catalogs" |
| Image variable uses explicit pinned tag | PASSED | 23 | "✓ All image references use explicit version tags" |
| Image value contains Jinja2 `{{` | SKIP | — | — |

**Fix for no tag:** "Add a specific version tag: {image_ref}:<version>"  
**Fix for unacceptable tag:** "Replace :{tag} with a specific pinned version tag"  
**Reason:** "Untagged images cause non-reproducible deployments. Platform standard: all images must be tagged (Nate Stencell review standard)."

**Stage detection:** Check which stage files exist in `catalog_path`. If `prod.yaml` exists → apply check using merged common+prod config. If `event.yaml` exists → apply check using merged common+event config.

---

## Output Contract

Return **exactly** this JSON structure. No prose. No markdown. No explanation outside the JSON.

```json
{
  "agent": "metadata-checker",
  "errors": [
    {
      "check": "password_pattern",
      "check_id": 19,
      "severity": "ERROR",
      "message": "common_password is a hardcoded static password — not allowed",
      "location": "common.yaml:common_password",
      "fix": "Use lookup('password', output_dir ~ '/common_password', length=12, chars=['ascii_letters', 'digits'])",
      "current": "ansible123!",
      "example": null
    }
  ],
  "warnings": [
    {
      "check": "ee_image_date",
      "check_id": 21,
      "severity": "WARNING",
      "message": "Execution environment image is 120 days old",
      "location": "common.yaml:__meta__.deployer.execution_environment.image",
      "recommendation": "Update to: quay.io/agnosticd/ee-multicloud:chained-2026-02-23"
    }
  ],
  "suggestions": [
    {
      "check": "best_practices",
      "check_id": 9,
      "message": "No keywords defined",
      "recommendation": "Add 3-4 specific technology keywords (e.g., 'mcp', 'leapp', 'tekton', 'cnpg')"
    }
  ],
  "passed_checks": [
    "✓ Display name length OK (42 chars)",
    "✓ dev.yaml present",
    "✓ description.adoc present",
    "✓ ocp4_workload_showroom_namespace not set (correct for tenant catalog)",
    "✓ EE image date is recent: 2026-02-23 (126 days old)"
  ]
}
```

### Field Rules

| Field | Type | Notes |
|-------|------|-------|
| `agent` | string | Always `"metadata-checker"` |
| `errors` | array | Empty array if none |
| `warnings` | array | Empty array if none |
| `suggestions` | array | Empty array if none |
| `passed_checks` | array | Include all checks that passed, as strings |
| `check_id` | integer | Maps to check ownership table above |
| `severity` | string | `"ERROR"` or `"WARNING"` |
| `location` | string | `"filename:field.path"` format |
| `fix` | string | Actionable fix instruction |
| `current` | string or null | Current value if relevant |
| `example` | string or null | Correct example if helpful |
| `recommendation` | string | For warnings and suggestions |
