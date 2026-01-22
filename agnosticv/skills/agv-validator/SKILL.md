# Skill: agv-validator

**Name:** AgnosticV Catalog Validator
**Description:** Validate AgnosticV configurations against best practices and deployment requirements  
**Version:** 1.0.0
**Last Updated:** 2026-01-22

---

## Purpose

Comprehensive validation of AgnosticV catalog configurations before deployment. Checks UUID format, YAML syntax, workload dependencies, category correctness, and best practices to prevent deployment failures.

---

## When to Use This Skill

Use `/agv-validator` when you need to:

- Validate a new catalog before creating PR
- Troubleshoot catalog deployment failures
- Check catalog quality before testing in RHDP
- Verify updates to existing catalogs
- Ensure best practices compliance

**Prerequisites:**
- AgnosticV repository cloned locally
- Catalog files exist (common.yaml minimum)
- Git configured and repository accessible

---

## Skill Workflow Overview

```
Step 1: Path Detection (Auto-detect or ask)
  ↓
Step 2: Validation Scope Selection
  ↓
Step 3: Run Validation Checks
  ↓
Step 4: Generate Report (Errors/Warnings/Suggestions)
  ↓
Step 5: Offer Follow-up Actions
```

---

## Step 1: Smart Path Detection (FIRST)

### Auto-detect Catalog Location

**Check current directory for AgV catalog structure:**

```bash
# Look for common.yaml in current directory or parent
if [ -f "common.yaml" ]; then
  CATALOG_PATH=$(pwd)
elif [ -f "../common.yaml" ]; then
  CATALOG_PATH=$(cd .. && pwd)
elif [ -f "../../common.yaml" ]; then
  CATALOG_PATH=$(cd ../.. && pwd)
fi

# Verify it's an AgV catalog
if [ -f "$CATALOG_PATH/common.yaml" ]; then
  # Extract catalog slug from path
  CATALOG_SLUG=$(basename $CATALOG_PATH)
  CATALOG_DIR=$(basename $(dirname $CATALOG_PATH))
fi
```

### Ask User

```
🔍 AgnosticV Catalog Validator

I'll validate your AgnosticV catalog configuration.

Current directory: {{ current_directory }}

{% if common_yaml_detected %}
✅ Detected catalog:
   Path: {{ detected_catalog_path }}
   Directory: {{ catalog_dir }}/{{ catalog_slug }}

Use this catalog? [Yes/No/Specify different path]
{% else %}
No catalog detected in current directory.

Options:
1. Specify catalog path (e.g., ~/work/code/agnosticv/agd_v2/my-catalog)
2. Validate entire AgnosticV repository (all catalogs)
3. Exit

Your choice: [1/2/3]
{% endif %}
```

### Path Validation

```python
import os

if os.path.exists(catalog_path):
  if os.path.isfile(f"{catalog_path}/common.yaml"):
    ✅ Valid catalog path
    Path: {{ catalog_path }}
    
    # Extract catalog information
    catalog_slug = os.path.basename(catalog_path)
    catalog_dir = os.path.basename(os.path.dirname(catalog_path))
    
    Files found:
    ✓ common.yaml
    {{ '✓ description.adoc' if os.path.exists(f"{catalog_path}/description.adoc") else '⚠ description.adoc (missing)' }}
    {{ '✓ dev.yaml' if os.path.exists(f"{catalog_path}/dev.yaml") else 'ℹ dev.yaml (optional, not found)' }}
    
  else:
    ❌ Path exists but no common.yaml found
    
    Expected file: {{ catalog_path }}/common.yaml
    
    Is this an AgV catalog directory? [Yes - Continue anyway / No - Try different path]
else:
  ❌ Path not found: {{ catalog_path }}
  
  Try again? [Yes/No]
```

**Store validated path** for validation checks.

---

## Step 2: Validation Scope Selection

```
Q: What level of validation do you want?

1. ⚡ Quick check (file structure, UUID, basic YAML)
   Duration: ~5 seconds
   Checks: Essential blocking issues only
   
2. ✅ Standard validation (recommended)
   Duration: ~15-30 seconds
   Checks: Files, UUID, YAML, workloads, schema, best practices
   
3. 🔬 Full validation (everything + GitHub API)
   Duration: ~30-60 seconds
   Checks: Standard + GitHub tag/branch validation, collection URLs

Recommended: 2 (Standard)

Your choice: [1/2/3]
```

**Set validation scope:**

```python
if choice == 1:
  validation_scope = "quick"
  checks_to_run = ["file_structure", "uuid", "yaml_syntax"]
  
elif choice == 2:
  validation_scope = "standard"
  checks_to_run = ["file_structure", "uuid", "yaml_syntax", "workloads", 
                   "schema", "category", "infrastructure", "best_practices"]
  
elif choice == 3:
  validation_scope = "full"
  checks_to_run = ["file_structure", "uuid", "yaml_syntax", "workloads",
                   "schema", "category", "infrastructure", "best_practices",
                   "github_api", "collection_urls", "scm_refs"]
```

---

## Step 3: Run Validation Checks

### Initialize Error Collection

```python
errors = []         # ERRORS (must fix) - Block deployment
warnings = []       # WARNINGS (should fix) - May cause issues  
suggestions = []    # SUGGESTIONS (nice to have) - Best practices
passed_checks = []  # Passed checks for summary
```

### Check 1: File Structure

```python
def check_file_structure(catalog_path):
  """Required files validation"""
  
  required_files = ["common.yaml"]
  recommended_files = ["description.adoc", "dev.yaml"]
  
  # Check required
  for file in required_files:
    filepath = f"{catalog_path}/{file}"
    if os.path.exists(filepath):
      passed_checks.append(f"✓ Required file present: {file}")
    else:
      errors.append({
        'check': 'file_structure',
        'severity': 'ERROR',
        'message': f'Missing required file: {file}',
        'location': catalog_path,
        'fix': f'Create {file} in catalog directory'
      })
  
  # Check recommended
  for file in recommended_files:
    filepath = f"{catalog_path}/{file}"
    if not os.path.exists(filepath):
      warnings.append({
        'check': 'file_structure',
        'severity': 'WARNING',
        'message': f'Recommended file missing: {file}',
        'location': catalog_path,
        'fix': f'Create {file} for better catalog quality'
      })
```

### Check 2: UUID Format and Uniqueness

```python
import re
import yaml

def check_uuid(catalog_path, agv_repo_path):
  """UUID validation - CRITICAL"""
  
  # Load common.yaml
  with open(f"{catalog_path}/common.yaml") as f:
    config = yaml.safe_load(f)
  
  # Check if UUID exists
  if '__meta__' not in config:
    errors.append({
      'check': 'uuid',
      'severity': 'ERROR',
      'message': 'Missing __meta__ section',
      'location': 'common.yaml',
      'fix': 'Add __meta__ section with asset_uuid'
    })
    return
  
  if 'asset_uuid' not in config['__meta__']:
    errors.append({
      'check': 'uuid',
      'severity': 'ERROR',
      'message': 'Missing __meta__.asset_uuid',
      'location': 'common.yaml:__meta__',
      'fix': 'Generate UUID with: uuidgen'
    })
    return
  
  uuid = config['__meta__']['asset_uuid']
  
  # Validate UUID format (RFC 4122)
  uuid_pattern = r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
  
  if not re.match(uuid_pattern, str(uuid).lower()):
    errors.append({
      'check': 'uuid',
      'severity': 'ERROR',
      'message': f'Invalid UUID format: {uuid}',
      'location': 'common.yaml:__meta__.asset_uuid',
      'fix': 'Generate proper UUID with: uuidgen',
      'example': '5ac92190-6f0d-4c0e-a9bd-3b20dd3c816f'
    })
    return
  
  # Check for UUID collision
  collision = search_uuid_in_repo(uuid, agv_repo_path, current_catalog=catalog_path)
  
  if collision:
    errors.append({
      'check': 'uuid',
      'severity': 'ERROR',
      'message': f'UUID collision detected',
      'location': 'common.yaml:__meta__.asset_uuid',
      'details': f'UUID {uuid} already used in: {collision["path"]}',
      'catalog': collision["name"],
      'fix': 'Generate new unique UUID with: uuidgen'
    })
    return
  
  passed_checks.append(f"✓ UUID format valid: {uuid}")
  passed_checks.append(f"✓ UUID is unique")

def search_uuid_in_repo(uuid, repo_path, current_catalog):
  """Search for UUID in all catalogs"""
  import glob
  
  for catalog in glob.glob(f"{repo_path}/**/common.yaml", recursive=True):
    if os.path.dirname(catalog) == current_catalog:
      continue  # Skip current catalog
    
    with open(catalog) as f:
      try:
        config = yaml.safe_load(f)
        if config.get('__meta__', {}).get('asset_uuid') == uuid:
          return {
            'path': catalog,
            'name': config.get('__meta__', {}).get('catalog', {}).get('display_name', 'Unknown')
          }
      except:
        continue
  
  return None
```

### Check 3: Category Validation

```python
def check_category(config):
  """Category correctness validation"""
  
  valid_categories = ["Workshops", "Demos", "Sandboxes"]
  
  if '__meta__' not in config or 'catalog' not in config['__meta__']:
    errors.append({
      'check': 'category',
      'severity': 'ERROR',
      'message': 'Missing __meta__.catalog section',
      'location': 'common.yaml',
      'fix': 'Add __meta__.catalog section with category'
    })
    return
  
  category = config['__meta__']['catalog'].get('category')
  
  if not category:
    errors.append({
      'check': 'category',
      'severity': 'ERROR',
      'message': 'Missing __meta__.catalog.category',
      'location': 'common.yaml:__meta__.catalog',
      'fix': f'Add category: {valid_categories}'
    })
    return
  
  if category not in valid_categories:
    errors.append({
      'check': 'category',
      'severity': 'ERROR',
      'message': f'Invalid category: "{category}"',
      'location': 'common.yaml:__meta__.catalog.category',
      'current': category,
      'valid_options': valid_categories,
      'fix': f'Use one of: {", ".join(valid_categories)} (case-sensitive)'
    })
    return
  
  passed_checks.append(f"✓ Category valid: {category}")
  
  # Validate category alignment with configuration
  multiuser = config['__meta__']['catalog'].get('multiuser', False)
  
  if category == "Workshops" and not multiuser:
    warnings.append({
      'check': 'category',
      'severity': 'WARNING',
      'message': 'Category "Workshops" typically requires multiuser: true',
      'location': 'common.yaml:__meta__.catalog',
      'recommendation': 'Set multiuser: true for workshop catalogs'
    })
  
  if category == "Demos" and multiuser:
    warnings.append({
      'check': 'category',
      'severity': 'WARNING',
      'message': 'Category "Demos" typically uses multiuser: false',
      'location': 'common.yaml:__meta__.catalog',
      'recommendation': 'Demos are usually single-user or small groups'
    })
```

### Check 4: YAML Syntax

```python
def check_yaml_syntax(catalog_path):
  """YAML syntax validation"""
  
  files_to_check = ["common.yaml", "dev.yaml"]
  
  for filename in files_to_check:
    filepath = f"{catalog_path}/{filename}"
    
    if not os.path.exists(filepath):
      continue
    
    try:
      with open(filepath) as f:
        yaml.safe_load(f)
      passed_checks.append(f"✓ {filename} syntax valid")
    except yaml.YAMLError as e:
      errors.append({
        'check': 'yaml_syntax',
        'severity': 'ERROR',
        'message': f'YAML syntax error in {filename}',
        'location': f'{filename}:line {e.problem_mark.line if hasattr(e, "problem_mark") else "?"}',
        'details': str(e),
        'fix': 'Fix YAML syntax errors'
      })
```

### Check 5: Workload Dependencies

```python
def check_workload_dependencies(config):
  """Workload and collection dependency validation"""
  
  if 'workloads' not in config:
    errors.append({
      'check': 'workloads',
      'severity': 'ERROR',
      'message': 'No workloads defined',
      'location': 'common.yaml',
      'fix': 'Add workloads list'
    })
    return
  
  workloads = config.get('workloads', [])
  collections = config.get('requirements_content', {}).get('collections', [])
  
  # Extract collection names
  collection_names = []
  for coll in collections:
    if 'name' in coll:
      # Extract org/repo from GitHub URL or collection name
      if 'github.com' in coll['name']:
        # https://github.com/agnosticd/core_workloads.git → core_workloads
        repo_name = coll['name'].split('/')[-1].replace('.git', '')
        collection_names.append(repo_name)
      else:
        collection_names.append(coll['name'])
  
  # Check each workload format and dependencies
  for workload in workloads:
    # Validate format: namespace.collection.role
    parts = workload.split('.')
    
    if len(parts) < 3:
      errors.append({
        'check': 'workloads',
        'severity': 'ERROR',
        'message': f'Invalid workload format: {workload}',
        'location': 'common.yaml:workloads',
        'expected': 'namespace.collection.role_name',
        'example': 'agnosticd.core_workloads.ocp4_workload_authentication_htpasswd',
        'fix': 'Use fully qualified workload name'
      })
      continue
    
    namespace, collection, role = parts[0], parts[1], '.'.join(parts[2:])
    
    # Check if collection is in requirements
    if collection not in collection_names and collection not in ['showroom']:
      warnings.append({
        'check': 'workloads',
        'severity': 'WARNING',
        'message': f'Workload "{workload}" requires collection "{collection}"',
        'location': 'common.yaml:requirements_content.collections',
        'fix': f'Add collection to requirements_content.collections',
        'example': f'''
requirements_content:
  collections:
  - name: https://github.com/{namespace}/{collection}.git
    type: git
    version: main
'''
      })
  
  if workloads:
    passed_checks.append(f"✓ Workload format correct ({len(workloads)} workloads)")
```

### Check 6: Infrastructure Recommendations

```python
def check_infrastructure(config):
  """Infrastructure type validation and recommendations"""
  
  workloads = config.get('workloads', [])
  components = config.get('__meta__', {}).get('components', [])
  
  # Detect infrastructure type
  cluster_component = next((c for c in components if 'openshift' in c.get('name', '').lower()), None)
  
  if not cluster_component:
    warnings.append({
      'check': 'infrastructure',
      'severity': 'WARNING',
      'message': 'No OpenShift cluster component found',
      'location': 'common.yaml:__meta__.components',
      'recommendation': 'Add cluster component if OpenShift-based'
    })
    return
  
  cluster_item = cluster_component.get('item', '')
  cluster_size = cluster_component.get('parameter_values', {}).get('cluster_size', '')
  
  # Check GPU workloads on non-AWS
  gpu_workloads = [w for w in workloads if 'gpu' in w.lower() or 'nvidia' in w.lower()]
  
  if gpu_workloads and 'aws' not in cluster_item.lower():
    warnings.append({
      'check': 'infrastructure',
      'severity': 'WARNING',
      'message': 'GPU workloads detected but not using AWS infrastructure',
      'workloads': gpu_workloads,
      'current_infrastructure': cluster_item,
      'recommendation': 'GPU workloads require AWS with g6.4xlarge instances',
      'fix': 'Change to AWS infrastructure or remove GPU workloads'
    })
  
  # Check heavy workloads on SNO
  if cluster_size == 'sno':
    heavy_workloads = [w for w in workloads if any(tech in w for tech in ['openshift_ai', 'acs', 'service_mesh'])]
    
    if len(workloads) > 5 or heavy_workloads:
      warnings.append({
        'check': 'infrastructure',
        'severity': 'WARNING',
        'message': 'Heavy workloads on SNO (Single Node OpenShift)',
        'workloads': heavy_workloads if heavy_workloads else f'{len(workloads)} workloads',
        'recommendation': 'SNO best for lightweight demos, consider CNV multi-node',
        'resource_concern': 'SNO has limited resources (32Gi RAM, 16 cores)'
      })
  
  # Multi-user on SNO
  multiuser = config.get('__meta__', {}).get('catalog', {}).get('multiuser', False)
  
  if multiuser and cluster_size == 'sno':
    errors.append({
      'check': 'infrastructure',
      'severity': 'ERROR',
      'message': 'Multi-user enabled on SNO infrastructure',
      'location': 'common.yaml',
      'issue': 'SNO cannot support multiple concurrent users',
      'fix': 'Change to CNV multi-node or set multiuser: false'
    })
  
  passed_checks.append(f"✓ Infrastructure type: {cluster_size}")
```

### Check 7: Authentication Configuration

```python
def check_authentication(config):
  """Authentication workload validation"""
  
  workloads = config.get('workloads', [])
  
  auth_workloads = [w for w in workloads if 'authentication' in w]
  
  if not auth_workloads:
    errors.append({
      'check': 'authentication',
      'severity': 'ERROR',
      'message': 'No authentication workload configured',
      'location': 'common.yaml:workloads',
      'fix': 'Add authentication workload (htpasswd or keycloak)',
      'examples': [
        'agnosticd.core_workloads.ocp4_workload_authentication_htpasswd',
        'agnosticd.core_workloads.ocp4_workload_authentication_keycloak'
      ]
    })
    return
  
  if len(auth_workloads) > 1:
    warnings.append({
      'check': 'authentication',
      'severity': 'WARNING',
      'message': 'Multiple authentication workloads detected',
      'workloads': auth_workloads,
      'recommendation': 'Usually only one authentication method is needed'
    })
  
  # Check authentication variables
  if 'htpasswd' in auth_workloads[0]:
    required_vars = [
      'ocp4_workload_authentication_htpasswd_admin_user',
      'ocp4_workload_authentication_htpasswd_admin_password',
      'ocp4_workload_authentication_htpasswd_user_count'
    ]
    
    for var in required_vars:
      if var not in config:
        warnings.append({
          'check': 'authentication',
          'severity': 'WARNING',
          'message': f'Missing htpasswd variable: {var}',
          'location': 'common.yaml',
          'fix': f'Add {var} configuration'
        })
  
  passed_checks.append(f"✓ Authentication configured: {auth_workloads[0].split('.')[-1]}")
```

### Check 8: Showroom Integration

```python
def check_showroom(config):
  """Showroom workload and configuration validation"""
  
  workloads = config.get('workloads', [])
  
  showroom_workloads = [w for w in workloads if 'showroom' in w]
  
  if showroom_workloads:
    # Check for showroom repo configuration
    showroom_vars = [k for k in config.keys() if 'showroom_content_git_repo' in k]
    
    if not showroom_vars:
      errors.append({
        'check': 'showroom',
        'severity': 'ERROR',
        'message': 'Showroom workload present but no git repository configured',
        'location': 'common.yaml',
        'fix': 'Add ocp4_workload_showroom_content_git_repo variable',
        'example': 'ocp4_workload_showroom_content_git_repo: https://github.com/rhpds/repo.git'
      })
    else:
      repo_url = config.get(showroom_vars[0], '')
      
      # Check for SSH format (should be HTTPS)
      if repo_url.startswith('git@github.com:'):
        warnings.append({
          'check': 'showroom',
          'severity': 'WARNING',
          'message': 'Showroom git repository uses SSH format',
          'location': f'common.yaml:{showroom_vars[0]}',
          'current': repo_url,
          'recommendation': 'Use HTTPS format for user cloning',
          'suggested': repo_url.replace('git@github.com:', 'https://github.com/').replace('.git', '.git')
        })
      
      passed_checks.append(f"✓ Showroom integration configured")
```

### Check 9: Best Practices

```python
def check_best_practices(config):
  """Best practice recommendations"""
  
  # Check for display_name
  display_name = config.get('__meta__', {}).get('catalog', {}).get('display_name', '')
  
  if len(display_name) > 60:
    suggestions.append({
      'check': 'best_practices',
      'message': 'Display name is quite long',
      'current_length': len(display_name),
      'recommendation': 'Keep display names under 60 characters for better UX'
    })
  
  # Check for keywords
  keywords = config.get('__meta__', {}).get('catalog', {}).get('keywords', [])
  
  if len(keywords) < 3:
    suggestions.append({
      'check': 'best_practices',
      'message': 'Few keywords defined',
      'current': len(keywords),
      'recommendation': 'Add 3-5 keywords for better discoverability'
    })
  
  # Check for abstract
  if 'abstract' not in config.get('__meta__', {}).get('catalog', {}):
    suggestions.append({
      'check': 'best_practices',
      'message': 'No abstract defined in catalog metadata',
      'recommendation': 'Add abstract for catalog description'
    })
  
  # Check for owners/maintainers
  if 'owners' not in config.get('__meta__', {}):
    suggestions.append({
      'check': 'best_practices',
      'message': 'No maintainer/owner defined',
      'recommendation': 'Add __meta__.owners.maintainer for accountability'
    })
```

---

## Step 4: Generate Validation Report

### Interactive Report Format

```
╔═══════════════════════════════════════════════════════════╗
║         AgV Catalog Validation Report                     ║
╚═══════════════════════════════════════════════════════════╝

Catalog: {{ catalog_display_name }}
Location: {{ catalog_path }}
Validation Level: {{ validation_scope }}
Timestamp: {{ current_timestamp }}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{% if errors %}
ERRORS (must fix before deployment):

{% for error in errors %}
❌ {{ error.message }}
   Location: {{ error.location }}
   {% if error.current %}Current: {{ error.current }}{% endif %}
   {% if error.fix %}Fix: {{ error.fix }}{% endif %}
   {% if error.example %}Example: {{ error.example }}{% endif %}

{% endfor %}
{% endif %}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{% if warnings %}
WARNINGS (should fix to avoid issues):

{% for warning in warnings %}
⚠️  {{ warning.message }}
   Location: {{ warning.location }}
   {% if warning.recommendation %}Recommendation: {{ warning.recommendation }}{% endif %}
   {% if warning.fix %}Fix: {{ warning.fix }}{% endif %}

{% endfor %}
{% endif %}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{% if suggestions %}
SUGGESTIONS (nice to have):

{% for suggestion in suggestions %}
💡 {{ suggestion.message }}
   {% if suggestion.recommendation %}Why: {{ suggestion.recommendation }}{% endif %}

{% endfor %}
{% endif %}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PASSED ({{ passed_checks|length }} checks):

{% for check in passed_checks %}
{{ check }}
{% endfor %}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SUMMARY:
  {% if errors %}❌ {{ errors|length }} error(s) (must fix){% endif %}
  {% if warnings %}⚠️  {{ warnings|length }} warning(s) (should fix){% endif %}
  {% if suggestions %}💡 {{ suggestions|length }} suggestion(s) (nice to have){% endif %}
  ✓ {{ passed_checks|length }} check(s) passed

STATUS: {% if errors %}❌ FAILED - Fix errors before deploying to RHDP{% elif warnings %}⚠️ PASSED WITH WARNINGS{% else %}✅ PASSED{% endif %}

Next steps:
{% if errors %}
1. Fix the {{ errors|length }} error(s) listed above
2. Run validation again: /agv-validator
3. Address warnings for better quality
4. Test in RHDP Integration environment
{% elif warnings %}
1. Review and address warnings for better quality
2. Test in RHDP Integration environment
3. Create PR when ready
{% else %}
1. Catalog looks good! Test in RHDP Integration
2. Create PR for review
3. Request merge after successful testing
{% endif %}
```

---

## Step 5: Follow-up Actions

```
Would you like me to:

1. 💾 Create validation report file (validation-report.txt)
2. 🔧 Show detailed fix instructions for errors
3. 🔄 Re-run validation after you fix issues
4. 📋 Generate checklist for manual review
5. ❌ Exit

Your choice: [1/2/3/4/5]
```

### Option 1: Create Report File

```bash
cat > {{ catalog_path }}/validation-report.txt << 'EOF'
{{ full_validation_report }}
EOF

✅ Validation report saved

File: {{ catalog_path }}/validation-report.txt

You can:
- Review offline
- Share with team
- Attach to PR
- Track fixes over time
```

### Option 2: Detailed Fix Instructions

```
🔧 Detailed Fix Instructions

{% for i, error in enumerate(errors) %}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Error {{ i+1 }}: {{ error.message }}

Location: {{ error.location }}

Problem:
{{ error.details if error.details else error.message }}

How to fix:

1. Open file: {{ error.location.split(':')[0] }}

2. {% if 'UUID' in error.message %}
   Generate new UUID:
   $ uuidgen
   
   Update common.yaml:
   __meta__:
     asset_uuid: <paste-uuid-here>

{% elif 'category' in error.message %}
   Update category to valid option:
   __meta__:
     catalog:
       category: {{ error.valid_options[0] if error.valid_options else 'Workshops' }}
   
   Valid options: {{ error.valid_options|join(', ') }}

{% elif 'workload' in error.message %}
   Add missing collection:
   requirements_content:
     collections:
     - name: {{ error.example if error.example else 'https://github.com/agnosticd/collection.git' }}
       type: git
       version: main

{% else %}
   {{ error.fix }}
{% endif %}

3. Save file

4. Re-run validation: /agv-validator

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
{% endfor %}
```

### Option 3: Re-validation Loop

```
Re-run validation now? [Yes/No]

{% if Yes %}
🔄 Re-validating catalog...

(Re-run all validation checks from Step 3)

{% endif %}
```

### Option 4: Manual Review Checklist

```
📋 Manual Review Checklist

Save this checklist for comprehensive review:

## Catalog Information
- [ ] Display name is clear and descriptive
- [ ] Abstract explains purpose (starts with product name)
- [ ] Category is correct (Workshops/Demos/Sandboxes)
- [ ] Keywords are relevant (3-5 keywords)
- [ ] UUID is unique and valid format

## Infrastructure
- [ ] Infrastructure type matches requirements (CNV/SNO/AWS)
- [ ] Cluster size appropriate for workload
- [ ] GPU configuration if needed (AWS only)
- [ ] Multi-user setting aligns with category

## Workloads
- [ ] All required workloads included
- [ ] Authentication workload present
- [ ] Showroom workload for content delivery
- [ ] Technology-specific workloads match abstract
- [ ] All workload collections in requirements

## Configuration
- [ ] Showroom git repository URL is HTTPS format
- [ ] All workload variables defined
- [ ] No hardcoded values (use variables)
- [ ] dev.yaml exists for development overrides

## Testing
- [ ] Tested in RHDP Integration
- [ ] All workloads provision successfully
- [ ] Showroom content loads correctly
- [ ] UserInfo variables available
- [ ] Exercises work as documented

## Documentation
- [ ] description.adoc explains catalog purpose
- [ ] Prerequisites listed
- [ ] Learning outcomes defined
- [ ] Environment details specified
- [ ] User access instructions (if multi-user)

## Git & PR
- [ ] Branch created (no feature/ prefix)
- [ ] Files committed with clear message
- [ ] PR created with test plan
- [ ] PR description includes test results
- [ ] Ready for RHDP team review
```

---

## Error Handling

### Catalog Not Found

```
❌ Catalog Validation Failed

I couldn't find an AgnosticV catalog at: {{ provided_path }}

Common issues:
- Wrong path provided
- Not in an AgV catalog directory
- Missing common.yaml file

Try:
1. Navigate to catalog directory: cd {{ agv_path }}/agd_v2/<catalog-name>
2. Verify common.yaml exists: ls -la
3. Run validator again: /agv-validator

Exit or try again? [Try again/Exit]
```

### YAML Parse Error

```
❌ Cannot Parse YAML

File: {{ file_path }}

Error: {{ yaml_error_message }}

This usually means:
- Incorrect indentation
- Missing colons or quotes
- Invalid YAML syntax

Recommendations:
1. Use YAML validator online
2. Check indentation (spaces, not tabs)
3. Validate quotes and special characters

Continue validation anyway (will skip YAML checks)? [Yes/No]
```

### Repository Access Error

```
⚠️  Cannot Access Full Repository

I can validate this catalog but cannot check UUID uniqueness across all catalogs.

Reason: {{ access_error }}

Validation will continue with reduced scope.

Limited checks:
✓ File structure
✓ YAML syntax (local catalog only)
✓ Workload format
✓ Category validation

Skipped checks:
⊘ UUID uniqueness across repository
⊘ Collection URL validation

Continue? [Yes/No]
```

---

## Skill Exit

```
{% if errors %}
❌ Validation Complete - ERRORS FOUND

You have {{ errors|length }} error(s) that must be fixed before deployment.

Next steps:
1. Review errors above
2. Fix issues in catalog files
3. Run /agv-validator again
4. Repeat until all errors resolved

{% elif warnings %}
⚠️  Validation Complete - WARNINGS FOUND

Catalog will deploy but has {{ warnings|length }} warning(s).

Recommended:
1. Review warnings for quality improvements
2. Fix what makes sense
3. Test in RHDP Integration

{% else %}
✅ Validation Complete - ALL CHECKS PASSED

Catalog is ready for deployment!

Next steps:
1. Commit changes (if any)
2. Test in RHDP Integration
3. Create PR with test results
4. Request merge after successful testing

{% endif %}

👋 Exiting /agv-validator
```

---

## References

- [AGV Common Rules](../../docs/AGV-COMMON-RULES.md) - Full AgV configuration contract
- [babylon_checks.py](https://github.com/rhpds/agnosticv/blob/main/.tests/babylon_checks.py) - Validation patterns
- [Workload Mappings](../../docs/workload-mappings.md) - Technology to workload reference
- [Infrastructure Guide](../../docs/infrastructure-guide.md) - CNV/SNO/AWS decision tree

---

**Last Updated:** 2026-01-22
**Maintained By:** RHDP Team
**Version:** 1.0.0
