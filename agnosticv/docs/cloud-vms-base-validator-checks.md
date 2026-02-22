# Cloud VMs Base Validator Checks

**Loaded by**: `agnosticv:validator` when `config: cloud-vms-base` is detected.

Covers infrastructure, authentication skip, showroom (VM-only), and multi-user isolation checks for VM-based catalogs.

**Critical difference from OCP:** Do NOT flag missing `ocp4_workload_authentication` as an error. Do NOT require `ocp4_workload_ocp_console_embed`. These are OCP-specific and have no equivalent on cloud-vms-base.

---

## Check 6A: cloud-vms-base Infrastructure

```python
def check_vms_infrastructure(config):
  """VM-based infrastructure validation"""

  cloud_provider = config.get('cloud_provider', '')
  multiuser = config.get('__meta__', {}).get('catalog', {}).get('multiuser', False)

  # AWS approval warning (applies to all config types using AWS)
  if cloud_provider == 'aws':
    warnings.append({
      'check': 'infrastructure',
      'severity': 'WARNING',
      'message': 'AWS cloud provider — confirm RHDP team approval obtained',
      'location': 'common.yaml:cloud_provider',
      'recommendation': 'AWS requires prior approval due to cost.'
    })

  # instances: block must be defined
  if 'instances' not in config:
    errors.append({
      'check': 'infrastructure',
      'severity': 'ERROR',
      'message': 'cloud-vms-base config missing instances: definition',
      'location': 'common.yaml',
      'fix': 'Add instances: list with at least a bastion VM definition'
    })
  else:
    passed_checks.append("✓ cloud-vms-base: instances defined")

    # Validate bastion instance exists
    instances = config.get('instances', [])
    bastion = next((i for i in instances if i.get('name') == 'bastion'), None)
    if not bastion:
      warnings.append({
        'check': 'infrastructure',
        'severity': 'WARNING',
        'message': 'No bastion instance found in instances list',
        'location': 'common.yaml:instances',
        'recommendation': 'Add a bastion instance as the primary access point'
      })
    else:
      passed_checks.append("✓ Bastion instance defined")

      # Check bastion tags
      tags = {t['key']: t['value'] for t in bastion.get('tags', [])}
      if tags.get('AnsibleGroup') != 'bastions':
        warnings.append({
          'check': 'infrastructure',
          'severity': 'WARNING',
          'message': 'Bastion instance missing AnsibleGroup: bastions tag',
          'location': 'common.yaml:instances[bastion].tags',
          'fix': 'Add tag: key: AnsibleGroup, value: bastions'
        })

      # CNV: must have services + routes; AWS: must have security_groups
      if cloud_provider in ['openshift_cnv', ''] and 'services' not in bastion:
        warnings.append({
          'check': 'infrastructure',
          'severity': 'WARNING',
          'message': 'CNV bastion missing services: definition for port exposure',
          'location': 'common.yaml:instances[bastion]',
          'fix': 'Add services: list with port definitions'
        })
      if cloud_provider == 'aws' and 'security_groups' not in bastion:
        warnings.append({
          'check': 'infrastructure',
          'severity': 'WARNING',
          'message': 'AWS bastion missing security_groups: definition',
          'location': 'common.yaml:instances[bastion]',
          'fix': 'Add security_groups: list with ingress rules'
        })

  # Bastion image must be a supported RHEL version
  bastion_image = config.get('bastion_instance_image', config.get('default_instance_image', ''))
  valid_images = ['rhel-9.4', 'rhel-9.5', 'rhel-9.6', 'rhel-10', 'RHEL-10']
  if bastion_image and not any(img in bastion_image for img in valid_images):
    warnings.append({
      'check': 'infrastructure',
      'severity': 'WARNING',
      'message': f'Unusual bastion image for cloud-vms-base: {bastion_image}',
      'location': 'common.yaml:bastion_instance_image',
      'valid_images': valid_images,
      'recommendation': 'Use supported RHEL 9.x or 10.x image'
    })
  elif bastion_image:
    passed_checks.append(f"✓ Bastion image: {bastion_image}")

  # Multi-user isolation warning
  if multiuser:
    warnings.append({
      'check': 'infrastructure',
      'severity': 'WARNING',
      'message': 'cloud-vms-base with multiuser: true — verify isolation is handled by workload',
      'location': 'common.yaml:__meta__.catalog.multiuser',
      'recommendation': 'cloud-vms-base has no built-in per-user namespace isolation. '
                        'Ensure your Ansible roles explicitly create per-user accounts, '
                        'directories, or separate VMs.'
    })

  passed_checks.append(f"✓ Infrastructure type: cloud-vms-base ({cloud_provider or 'cnv'})")
```

---

## Check 7: Authentication — SKIP for cloud-vms-base

```python
def check_vms_authentication(config):
  """
  cloud-vms-base does NOT use ocp4_workload_authentication.
  Authentication is handled at the OS/bastion level by AgnosticD base config.

  DO NOT flag missing ocp4_workload_authentication as an error.
  DO NOT check for authentication provider variables.

  This check is a no-op for cloud-vms-base — it passes silently.
  """

  workloads = config.get('workloads', [])

  # Warn if someone accidentally added OCP auth workload to a VM catalog
  ocp_auth = [w for w in workloads if 'ocp4_workload_authentication' in w]
  if ocp_auth:
    warnings.append({
      'check': 'authentication',
      'severity': 'WARNING',
      'message': f'OCP authentication workload found in cloud-vms-base catalog: {ocp_auth}',
      'location': 'common.yaml:workloads',
      'recommendation': 'cloud-vms-base handles auth at OS level. '
                        'Remove ocp4_workload_authentication unless you have an OCP cluster component.'
    })
  else:
    passed_checks.append("✓ Authentication: cloud-vms-base — OS-level auth (no OCP auth workload needed)")
```

---

## Check 8: Showroom Integration (VM)

```python
def check_vms_showroom(config):
  """VM Showroom workload validation"""

  workloads = config.get('workloads', [])

  has_vm_showroom = any('vm_workload_showroom' in w for w in workloads)
  has_ocp_showroom = any('ocp4_workload_showroom' in w and 'ocp_console_embed' not in w
                         for w in workloads)
  has_console_embed = any('ocp4_workload_ocp_console_embed' in w for w in workloads)

  # ocp4_workload_ocp_console_embed must NOT be in a cloud-vms-base catalog
  if has_console_embed:
    errors.append({
      'check': 'showroom',
      'severity': 'ERROR',
      'message': 'ocp4_workload_ocp_console_embed found in cloud-vms-base catalog',
      'location': 'common.yaml:workloads',
      'fix': 'Remove ocp4_workload_ocp_console_embed — it requires an OCP cluster. '
             'Use agnosticd.showroom.vm_workload_showroom instead.'
    })

  # ocp4_workload_showroom (OCP version) in a VM catalog is suspicious
  if has_ocp_showroom:
    warnings.append({
      'check': 'showroom',
      'severity': 'WARNING',
      'message': 'OCP showroom workload (ocp4_workload_showroom) found in cloud-vms-base catalog',
      'location': 'common.yaml:workloads',
      'recommendation': 'For VM-based catalogs, use agnosticd.showroom.vm_workload_showroom instead'
    })

  if has_vm_showroom:
    # vm_workload_showroom uses showroom_git_repo / showroom_git_ref (no ocp4_ prefix)
    # There is no dev_mode variable for VM showroom — it is OCP-specific only
    showroom_git_repo = config.get('showroom_git_repo', '')
    if not showroom_git_repo:
      errors.append({
        'check': 'showroom',
        'severity': 'ERROR',
        'message': 'VM showroom workload present but showroom_git_repo not configured',
        'location': 'common.yaml',
        'fix': 'Add: showroom_git_repo: https://github.com/rhpds/<short-name>-showroom'
      })
    else:
      passed_checks.append(f"✓ VM showroom configured: {showroom_git_repo}")

    showroom_git_ref = config.get('showroom_git_ref', '')
    if not showroom_git_ref:
      warnings.append({
        'check': 'showroom',
        'severity': 'WARNING',
        'message': 'showroom_git_ref not set — defaults to main',
        'location': 'common.yaml',
        'fix': 'Add: showroom_git_ref: main'
      })
    else:
      passed_checks.append(f"✓ VM showroom ref: {showroom_git_ref}")

  elif not has_ocp_showroom and not has_vm_showroom:
    # No showroom at all — just informational
    passed_checks.append("✓ No showroom workload (not required for VM catalogs)")
```

---

## Check 11: Multi-User (VM)

```python
def check_vms_multiuser(config):
  """cloud-vms-base multi-user validation — isolation warning only"""

  multiuser = config.get('__meta__', {}).get('catalog', {}).get('multiuser', False)

  if not multiuser:
    passed_checks.append("✓ Single-user catalog (standard for cloud-vms-base)")
    return

  # Already warned in Check 6A — just verify num_users parameter exists if multiuser
  parameters = config.get('__meta__', {}).get('catalog', {}).get('parameters', [])
  num_users_param = next((p for p in parameters if p.get('name') == 'num_users'), None)

  if not num_users_param:
    warnings.append({
      'check': 'multiuser',
      'severity': 'WARNING',
      'message': 'Multi-user cloud-vms-base catalog missing num_users parameter',
      'location': 'common.yaml:__meta__.catalog.parameters',
      'fix': 'Add num_users parameter so RHDP knows how many users to provision for'
    })

  # No worker scaling formula for VMs — that is OCP-specific
  # No workshopLabUiRedirect for VMs — no per-user Showroom URL
  if config.get('__meta__', {}).get('catalog', {}).get('workshopLabUiRedirect'):
    warnings.append({
      'check': 'multiuser',
      'severity': 'WARNING',
      'message': 'workshopLabUiRedirect set on cloud-vms-base catalog',
      'location': 'common.yaml:__meta__.catalog',
      'recommendation': 'cloud-vms-base does not provision per-user Showroom URLs. '
                        'Remove workshopLabUiRedirect or verify your workload sets lab_ui_url per user.'
    })

  passed_checks.append("✓ Multi-user configuration present (verify workload handles isolation)")
```


---

**↩ Return to `validator/SKILL.md` — continue with shared checks (Check 9 onward).**
