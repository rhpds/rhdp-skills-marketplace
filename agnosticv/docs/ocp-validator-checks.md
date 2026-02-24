# OCP Validator Checks

**Loaded by**: `agnosticv:validator` when `config:` is `openshift-workloads` or `openshift-cluster`.

Covers infrastructure, authentication, showroom, multi-user, component propagation, and LiteMaaS checks for OCP-based catalogs.

---

## Check 6B: OCP Infrastructure

```python
def check_ocp_infrastructure(config):
  """OCP pool-based infrastructure validation"""

  cloud_provider = config.get('cloud_provider', '')
  workloads = config.get('workloads', [])
  multiuser = config.get('__meta__', {}).get('catalog', {}).get('multiuser', False)

  # AWS approval warning
  if cloud_provider == 'aws':
    warnings.append({
      'check': 'infrastructure',
      'severity': 'WARNING',
      'message': 'AWS cloud provider — confirm RHDP team approval obtained',
      'location': 'common.yaml:cloud_provider',
      'recommendation': 'AWS requires prior approval due to cost.'
    })

  components = config.get('__meta__', {}).get('components', [])
  cluster_component = next(
    (c for c in components if 'openshift' in c.get('name', '').lower()), None
  )

  if not cluster_component:
    warnings.append({
      'check': 'infrastructure',
      'severity': 'WARNING',
      'message': 'No OpenShift cluster component found in __meta__.components',
      'location': 'common.yaml:__meta__.components',
      'recommendation': 'Add cluster component for openshift-workloads config'
    })
    return

  cluster_item = cluster_component.get('item', '')
  cluster_size = cluster_component.get('parameter_values', {}).get('cluster_size', '')
  ocp_version = str(cluster_component.get('parameter_values', {}).get('host_ocp4_installer_version', ''))

  # Component item must end with /prod in common.yaml
  if cluster_item and not cluster_item.endswith('/prod'):
    errors.append({
      'check': 'infrastructure',
      'severity': 'ERROR',
      'message': 'Component item must point to /prod pool in common.yaml',
      'location': 'common.yaml:__meta__.components',
      'current': cluster_item,
      'fix': f'Change to: {cluster_item.rstrip("/").rsplit("/", 1)[0]}/prod'
    })
  else:
    passed_checks.append(f"✓ Component item points to /prod pool: {cluster_item}")

  # OCP version must be a known available pool version
  known_ocp_versions = ['4.18', '4.20', '4.21']
  if ocp_version and ocp_version not in known_ocp_versions:
    warnings.append({
      'check': 'infrastructure',
      'severity': 'WARNING',
      'message': f'OCP version {ocp_version} may not have an available pool',
      'location': 'common.yaml:__meta__.components.parameter_values',
      'current': ocp_version,
      'available_pools': known_ocp_versions,
      'recommendation': f'Use one of: {", ".join(known_ocp_versions)}'
    })
  elif ocp_version:
    passed_checks.append(f"✓ OCP version {ocp_version} has available pool")

  # GPU workloads on non-AWS
  gpu_workloads = [w for w in workloads if 'gpu' in w.lower() or 'nvidia' in w.lower()]
  if gpu_workloads and cloud_provider != 'aws':
    warnings.append({
      'check': 'infrastructure',
      'severity': 'WARNING',
      'message': 'GPU workloads detected on non-AWS infrastructure',
      'workloads': gpu_workloads,
      'recommendation': 'GPU workloads typically require AWS with GPU instance types'
    })

  # Heavy workloads on SNO
  if cluster_size == 'sno':
    heavy_workloads = [w for w in workloads if any(t in w for t in ['openshift_ai', 'acs', 'service_mesh'])]
    if len(workloads) > 5 or heavy_workloads:
      warnings.append({
        'check': 'infrastructure',
        'severity': 'WARNING',
        'message': 'Heavy workloads on SNO (Single Node OpenShift)',
        'recommendation': 'SNO has limited resources — consider CNV multi-node for heavy workloads'
      })

  # Multi-user on SNO — hard error
  if multiuser and cluster_size == 'sno':
    errors.append({
      'check': 'infrastructure',
      'severity': 'ERROR',
      'message': 'Multi-user enabled on SNO — SNO cannot support concurrent users',
      'location': 'common.yaml',
      'fix': 'Change to CNV multi-node or set multiuser: false'
    })

  passed_checks.append(f"✓ OCP infrastructure: {cluster_size or 'multinode'} on {cloud_provider or 'cnv'}")
```

---

## Check 7: Authentication Configuration

```python
def check_ocp_authentication(config):
  """OCP authentication workload validation"""

  workloads = config.get('workloads', [])
  auth_workloads = [w for w in workloads if 'authentication' in w]

  # Deprecated roles: must migrate to unified role
  deprecated_roles = [
    'ocp4_workload_authentication_htpasswd',
    'ocp4_workload_authentication_keycloak',
  ]
  rhsso_roles = [w for w in workloads if 'rhsso' in w.lower() or 'sso' in w.lower()]

  for w in auth_workloads:
    role_name = w.split('.')[-1]
    if role_name in deprecated_roles:
      errors.append({
        'check': 'authentication',
        'severity': 'ERROR',
        'message': f'Deprecated authentication role: {w}',
        'location': 'common.yaml:workloads',
        'fix': '''Replace with the unified authentication role:
  - agnosticd.core_workloads.ocp4_workload_authentication

Then set the provider:
  ocp4_workload_authentication_provider: htpasswd   # or keycloak'''
      })

  if rhsso_roles:
    errors.append({
      'check': 'authentication',
      'severity': 'ERROR',
      'message': f'RHSSO is not supported: {rhsso_roles}',
      'location': 'common.yaml:workloads',
      'fix': 'Use Keycloak (RHBK) instead: set ocp4_workload_authentication_provider: keycloak'
    })

  unified_role = 'ocp4_workload_authentication'
  has_unified = any(w.split('.')[-1] == unified_role for w in workloads)

  if not auth_workloads:
    errors.append({
      'check': 'authentication',
      'severity': 'ERROR',
      'message': 'No authentication workload configured',
      'location': 'common.yaml:workloads',
      'fix': 'Add: agnosticd.core_workloads.ocp4_workload_authentication'
    })
    return

  if has_unified:
    provider = config.get('ocp4_workload_authentication_provider', '')
    valid_providers = ['htpasswd', 'keycloak']

    if not provider:
      warnings.append({
        'check': 'authentication',
        'severity': 'WARNING',
        'message': 'ocp4_workload_authentication_provider not set — defaults to htpasswd',
        'location': 'common.yaml',
        'recommendation': 'Explicitly set: ocp4_workload_authentication_provider: htpasswd  # or keycloak'
      })
    elif provider not in valid_providers:
      errors.append({
        'check': 'authentication',
        'severity': 'ERROR',
        'message': f'Invalid provider: {provider}',
        'location': 'common.yaml:ocp4_workload_authentication_provider',
        'valid': valid_providers,
        'fix': f'Set to one of: {", ".join(valid_providers)}'
      })
    else:
      passed_checks.append(f"✓ Authentication: unified role, provider={provider}")
```

---

## Check 8: Showroom Integration (OCP)

```python
def check_ocp_showroom(config):
  """OCP Showroom workload validation — both workloads must be present together"""

  workloads = config.get('workloads', [])
  showroom_workloads = [w for w in workloads if 'ocp4_workload_showroom' in w
                        and 'ocp_console_embed' not in w]
  has_console_embed = any('ocp4_workload_ocp_console_embed' in w for w in workloads)

  if showroom_workloads:

    # Both OCP showroom workloads must be present together
    if not has_console_embed:
      warnings.append({
        'check': 'showroom',
        'severity': 'WARNING',
        'message': 'ocp4_workload_showroom present but ocp4_workload_ocp_console_embed missing',
        'location': 'common.yaml:workloads',
        'fix': 'Add: agnosticd.showroom.ocp4_workload_ocp_console_embed alongside ocp4_workload_showroom'
      })
    else:
      passed_checks.append('✓ Both OCP showroom workloads present together')

    # dev_mode must be "false" in common.yaml
    # dev_mode: "true" in dev.yaml is correct and expected — only common.yaml is checked here
    dev_mode = config.get('ocp4_workload_showroom_antora_enable_dev_mode', None)
    if dev_mode is None:
      warnings.append({
        'check': 'showroom',
        'severity': 'WARNING',
        'message': 'ocp4_workload_showroom_antora_enable_dev_mode not set in common.yaml',
        'location': 'common.yaml',
        'fix': 'Add: ocp4_workload_showroom_antora_enable_dev_mode: "false"\n'
               '     (dev.yaml should override this to "true" — that is correct)'
      })
    elif str(dev_mode).lower() == 'true':
      errors.append({
        'check': 'showroom',
        'severity': 'ERROR',
        'message': 'ocp4_workload_showroom_antora_enable_dev_mode is "true" in common.yaml',
        'location': 'common.yaml',
        'fix': 'Set to "false" in common.yaml — "true" belongs in dev.yaml only'
      })
    else:
      passed_checks.append('✓ Showroom dev mode: "false" in common.yaml (dev.yaml "true" is expected)')

    # Verify dev.yaml overrides dev_mode to "true"
    dev_yaml_path = f"{catalog_path}/dev.yaml"
    if os.path.exists(dev_yaml_path):
      with open(dev_yaml_path) as f:
        try:
          dev_config = yaml.safe_load(f) or {}
          dev_mode_override = dev_config.get('ocp4_workload_showroom_antora_enable_dev_mode')
          if dev_mode_override is None:
            warnings.append({
              'check': 'showroom',
              'severity': 'WARNING',
              'message': 'ocp4_workload_showroom_antora_enable_dev_mode not set in dev.yaml',
              'location': 'dev.yaml',
              'fix': 'Add: ocp4_workload_showroom_antora_enable_dev_mode: "true"'
            })
          elif str(dev_mode_override).lower() == 'true':
            passed_checks.append('✓ Showroom dev mode: "true" in dev.yaml (correct override)')
          else:
            warnings.append({
              'check': 'showroom',
              'severity': 'WARNING',
              'message': f'ocp4_workload_showroom_antora_enable_dev_mode is "{dev_mode_override}" in dev.yaml — expected "true"',
              'location': 'dev.yaml',
              'fix': 'Set to "true" in dev.yaml to enable Showroom dev mode during development'
            })
        except yaml.YAMLError:
          pass  # YAML syntax errors handled by Check 4

    showroom_vars = [k for k in config.keys() if k == 'ocp4_workload_showroom_content_git_repo']
    if not showroom_vars:
      errors.append({
        'check': 'showroom',
        'severity': 'ERROR',
        'message': 'Showroom workload present but no git repository configured',
        'location': 'common.yaml',
        'fix': 'Add ocp4_workload_showroom_content_git_repo variable'
      })
    else:
      repo_url = config.get(showroom_vars[0], '')
      if repo_url.startswith('git@github.com:'):
        warnings.append({
          'check': 'showroom',
          'severity': 'WARNING',
          'message': 'Showroom git repository uses SSH format — use HTTPS',
          'location': f'common.yaml:{showroom_vars[0]}',
          'current': repo_url,
        })
      else:
        passed_checks.append("✓ Showroom integration configured")
```

---

## Check 11: Multi-User Configuration (OCP)

```python
def check_ocp_multiuser(config):
  """OCP multi-user specific validation"""

  multiuser = config.get('__meta__', {}).get('catalog', {}).get('multiuser', False)

  if not multiuser:
    passed_checks.append("✓ Single-user catalog (multiuser: false)")
    return

  parameters = config.get('__meta__', {}).get('catalog', {}).get('parameters', [])
  num_users_param = next((p for p in parameters if p.get('name') == 'num_users'), None)

  if not num_users_param:
    errors.append({
      'check': 'multiuser',
      'severity': 'ERROR',
      'message': 'Multi-user catalog missing num_users parameter',
      'location': 'common.yaml:__meta__.catalog.parameters',
      'fix': 'Add num_users parameter with min/max values'
    })
    return

  schema = num_users_param.get('openAPIV3Schema', {})
  if not schema:
    errors.append({
      'check': 'multiuser',
      'severity': 'ERROR',
      'message': 'num_users parameter missing openAPIV3Schema',
      'location': 'common.yaml:__meta__.catalog.parameters',
      'fix': 'Add openAPIV3Schema with type: integer, default, minimum, maximum'
    })
    return

  if 'worker_instance_count' in config:
    worker_formula = str(config['worker_instance_count'])
    if 'num_users' not in worker_formula:
      warnings.append({
        'check': 'multiuser',
        'severity': 'WARNING',
        'message': 'worker_instance_count does not scale with num_users',
        'location': 'common.yaml:worker_instance_count',
        'recommendation': 'Use formula based on num_users for multi-user scaling'
      })
    else:
      passed_checks.append("✓ Worker scaling formula includes num_users")

  catalog = config.get('__meta__', {}).get('catalog', {})
  category = catalog.get('category', '')
  workshop_ui_redirect = catalog.get('workshopLabUiRedirect', False)

  if category in ['Workshops', 'Brand_Events'] and multiuser and not workshop_ui_redirect:
    warnings.append({
      'check': 'multiuser',
      'severity': 'WARNING',
      'message': 'Multi-user workshop without workshopLabUiRedirect enabled',
      'location': 'common.yaml:__meta__.catalog',
      'fix': 'Add workshopLabUiRedirect: true to enable lab UI routing per user'
    })

  max_users = schema.get('maximum', 0)
  passed_checks.append(f"✓ Multi-user configuration present (max {max_users} users)")
```

---

## Check 15: Component Propagation (OCP)

```python
def check_ocp_component_propagation(config):
  """Validate multi-stage OCP catalog component data propagation"""

  components = config.get('__meta__', {}).get('components', [])

  if not components:
    return  # Not a multi-stage catalog

  for component in components:
    comp_name = component.get('name', 'unknown')
    propagate_data = component.get('propagate_provision_data', [])

    if not propagate_data:
      warnings.append({
        'check': 'components',
        'severity': 'WARNING',
        'message': f'Component "{comp_name}" has no propagate_provision_data',
        'location': 'common.yaml:__meta__.components',
        'recommendation': 'Add propagate_provision_data to pass info between stages'
      })
      continue

    if 'openshift' in comp_name.lower():
      required_propagations = [
        'openshift_api_url',
        'openshift_cluster_admin_token',
        'bastion_public_hostname'
      ]
      for req in required_propagations:
        if not any(p.get('name') == req for p in propagate_data):
          warnings.append({
            'check': 'components',
            'severity': 'WARNING',
            'message': f'Component "{comp_name}" missing common propagation: {req}',
            'location': 'common.yaml:__meta__.components',
            'recommendation': f'Add {req} to propagate_provision_data'
          })

  passed_checks.append(f"✓ Multi-stage catalog with {len(components)} component(s)")
```

---

## Check 17: LiteMaaS Configuration (OCP only)

```python
def check_litemaas(config):
  """Validate LiteMaaS workload configuration — OCP-only workload"""

  workloads = config.get('workloads', [])
  has_litellm_workload = any('litellm_virtual_keys' in w for w in workloads)

  if not has_litellm_workload:
    return  # Not using LiteMaaS

  models = config.get('ocp4_workload_litellm_virtual_keys_models', [])
  if not models:
    errors.append({
      'check': 'litemaas',
      'severity': 'ERROR',
      'message': 'ocp4_workload_litellm_virtual_keys present but no models defined',
      'location': 'common.yaml',
      'fix': 'Add ocp4_workload_litellm_virtual_keys_models list with at least one model'
    })
  else:
    passed_checks.append(f"✓ LiteMaaS models configured: {models}")

  duration = config.get('ocp4_workload_litellm_virtual_keys_duration', '')
  if not duration:
    warnings.append({
      'check': 'litemaas',
      'severity': 'WARNING',
      'message': 'ocp4_workload_litellm_virtual_keys_duration not set',
      'location': 'common.yaml',
      'recommendation': 'Set duration, e.g.: ocp4_workload_litellm_virtual_keys_duration: "7d"'
    })
  else:
    passed_checks.append(f"✓ LiteMaaS key duration: {duration}")

  # Includes check is handled by shared Check 17 in SKILL.md (applies to OCP + VM catalogs)
```


---

**↩ Return to `validator/SKILL.md` — continue with shared checks (Check 9 onward).**
