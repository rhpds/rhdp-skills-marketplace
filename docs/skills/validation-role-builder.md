---
layout: default
title: /validation-role-builder
---

# /validation-role-builder

Create Ansible validation roles for post-deployment health checks and verification.

---

## Before You Start

### Prerequisites

1. **Know what to validate:**
   - List of packages to verify
   - Services that should be running
   - Configuration files to check
   - Expected OpenShift resources
   - API endpoints to test

2. **Have your workload deployed:**
   ```bash
   # Know your deployment details:
   - OpenShift namespace
   - Deployed applications
   - Required resources
   ```

3. **AgnosticD repository access:**
   ```bash
   cd ~/work/code/agnosticd
   ```

### What You'll Need

- Workload name (matches your deployment workload)
- List of validation checks to perform
- Expected state for each check
- Failure conditions and error messages

---

## Quick Start

1. Navigate to AgnosticD repository
2. Run `/validation-role-builder`
3. Answer validation questions
4. Review generated role
5. Test validation role

---

## What It Creates

```
~/work/code/agnosticd/roles/ocp4_workload_<name>_validation/
├── defaults/main.yml          # Default variables
├── tasks/
│   ├── main.yml              # Main validation tasks
│   ├── pre_workload.yml      # Pre-checks
│   ├── workload.yml          # Core validation
│   └── post_workload.yml     # Post-checks
└── README.md                  # Documentation
```

---

## Common Validation Types

### Package Validation

Verify RPM packages are installed:
```yaml
- name: Verify package is installed
  package:
    name: "{{ package_name }}"
    state: present
  check_mode: yes
```

### Service Validation

Check systemd services are running:
```yaml
- name: Verify service is running
  systemd:
    name: "{{ service_name }}"
    state: started
    enabled: yes
```

### OpenShift Resource Validation

Verify pods, deployments, routes:
```yaml
- name: Verify deployment is ready
  kubernetes.core.k8s_info:
    kind: Deployment
    name: "{{ deployment_name }}"
    namespace: "{{ namespace }}"
```

---

## Tips

- Start simple - basic checks first
- Use clear error messages
- Test thoroughly on clean deployment
- Document what each check verifies
- Validation should not modify state

---

## Troubleshooting

**Skill not found?**
- Restart Claude Code or VS Code
- Verify installation: `ls ~/.claude/skills/validation-role-builder`

**Validation fails on working deployment?**
- Check timing - resources take time to be ready
- Add retries with delays
- Verify variable values are correct

---

## Related Skills

- `/agv-generator` - Create catalog with validation enabled
- `/agv-validator` - Validate catalog configuration

---

[← Back to Skills](index.html)
