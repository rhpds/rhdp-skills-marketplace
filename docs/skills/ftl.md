---
layout: default
title: /ftl
---

# /ftl

Finish The Labs - Automated grader and solver generation for workshop testing and validation.

---

## Before You Start

### Prerequisites

1. **Have workshop content ready:**
   ```bash
   # Your Showroom workshop repository with modules:
   content/modules/ROOT/pages/
   ├── module-01.adoc
   ├── module-02.adoc
   └── module-03.adoc
   ```

2. **Understand FTL grading system:**
   - Review [FTL documentation](https://github.com/redhat-gpte-devopsautomation/FTL)
   - Know what actions need validation
   - Identify success criteria for each module

3. **Have test environment access:**
   ```bash
   # Access to OpenShift cluster for testing
   oc whoami
   oc project <test-namespace>
   ```

### What You'll Need

- Workshop module files with clear Do/Check sections
- List of expected student actions per module
- Success criteria for each validation
- Test data or fixtures (if needed)

---

## Quick Start

1. Navigate to your workshop repository
2. Run `/ftl`
3. Specify modules to generate graders for
4. Review generated grader and solver code
5. Test validation logic

---

## What It Creates

```
ftl/
├── graders/
│   ├── grade_module_01.yml     # Grader for module 1
│   ├── grade_module_02.yml     # Grader for module 2
│   └── grade_module_03.yml     # Grader for module 3
├── solvers/
│   ├── solve_module_01.yml     # Solver for module 1
│   ├── solve_module_02.yml     # Solver for module 2
│   └── solve_module_03.yml     # Solver for module 3
└── tests/
    └── integration_test.yml    # Full workshop test
```

---

## How It Works

### Graders

Graders validate that students completed tasks correctly:
- Check for created resources (pods, routes, etc.)
- Verify configuration values
- Test application functionality
- Award points for correct completion

### Solvers

Solvers automatically complete workshop modules:
- Execute all student tasks programmatically
- Verify each step succeeds
- Used for testing grader accuracy
- Ensure workshop is technically sound

---

## Common Workflow

### 1. Create Workshop Content

```
/create-lab
→ Generate workshop modules
→ Define clear success criteria
```

### 2. Generate FTL Graders and Solvers

```
/ftl
→ Analyze module tasks
→ Generate validation logic
→ Create solver automation
```

### 3. Test with Solver

```bash
# Run solver to complete workshop automatically:
ansible-playbook ftl/solvers/solve_module_01.yml
```

### 4. Validate with Grader

```bash
# Run grader to check if tasks completed correctly:
ansible-playbook ftl/graders/grade_module_01.yml
```

### 5. Integrate with Workshop

```yaml
# Add grading to workshop deployment:
ftl_grading_enabled: true
ftl_graders_path: "{{ workshop_path }}/ftl/graders"
```

---

## Example Grader

For a module that deploys a pod:

```yaml
---
# ftl/graders/grade_module_01.yml
- name: Grade Module 01 - Deploy Application
  hosts: localhost
  gather_facts: false
  tasks:
    - name: Check if namespace exists
      kubernetes.core.k8s_info:
        kind: Namespace
        name: student-app
      register: ns_check

    - name: Award points for namespace
      set_fact:
        points: "{{ points | default(0) | int + 10 }}"
      when: ns_check.resources | length > 0

    - name: Check if deployment exists
      kubernetes.core.k8s_info:
        kind: Deployment
        name: myapp
        namespace: student-app
      register: deploy_check

    - name: Award points for deployment
      set_fact:
        points: "{{ points | default(0) | int + 20 }}"
      when:
        - deploy_check.resources | length > 0
        - deploy_check.resources[0].status.readyReplicas > 0

    - name: Display final score
      debug:
        msg: "Module 01 Score: {{ points | default(0) }}/30"
```

---

## Example Solver

Corresponding solver for the same module:

```yaml
---
# ftl/solvers/solve_module_01.yml
- name: Solve Module 01 - Deploy Application
  hosts: localhost
  gather_facts: false
  tasks:
    - name: Create namespace
      kubernetes.core.k8s:
        kind: Namespace
        name: student-app
        state: present

    - name: Create deployment
      kubernetes.core.k8s:
        state: present
        definition:
          apiVersion: apps/v1
          kind: Deployment
          metadata:
            name: myapp
            namespace: student-app
          spec:
            replicas: 1
            selector:
              matchLabels:
                app: myapp
            template:
              metadata:
                labels:
                  app: myapp
              spec:
                containers:
                - name: myapp
                  image: registry.redhat.io/ubi9/httpd-24:latest

    - name: Wait for deployment to be ready
      kubernetes.core.k8s_info:
        kind: Deployment
        name: myapp
        namespace: student-app
      register: deploy_status
      until: deploy_status.resources[0].status.readyReplicas | default(0) > 0
      retries: 30
      delay: 10
```

---

## Tips

- **Start simple** - Basic validation before complex checks
- **Test solver first** - Ensure workshop tasks actually work
- **Clear success criteria** - Each task needs measurable outcome
- **Partial credit** - Award points for partial completion
- **Helpful feedback** - Graders should explain what's missing
- **Idempotent solvers** - Should be safe to run multiple times

---

## Integration with Health Namespace

FTL graders integrate with RHDP Health validation:

```yaml
# In AgnosticV catalog:
health_ftl:
  enabled: true
  graders_path: "{{ workshop_ftl_path }}/graders"
  schedule: "*/15 * * * *"  # Run every 15 minutes
  alert_on_failure: true
  min_score_threshold: 80  # Alert if score < 80%
```

This enables:
- Continuous workshop validation
- Automated testing of workshop functionality
- Early detection of broken labs
- Student progress tracking

---

## Troubleshooting

**Skill not found?**
- Restart Claude Code or VS Code
- Verify installation: `ls ~/.claude/skills/ftl`

**Grader fails but solver works?**
- Check grader logic matches solver actions
- Verify validation criteria are correct
- Add debug output to see what grader finds

**Solver fails on valid workshop?**
- Review module instructions for accuracy
- Check for timing issues (add waits)
- Verify resource names match exactly

**Points don't add up correctly?**
- Initialize points variable at start
- Use `| default(0)` for safety
- Debug each scoring section

---

## Related Skills

- `/create-lab` - Create workshop content first
- `/deployment-health-checker` - Create deployment validators
- `/verify-content` - Validate workshop quality

---

## FTL Resources

- [FTL Grading System](https://github.com/redhat-gpte-devopsautomation/FTL)
- [FTL Best Practices](https://github.com/redhat-gpte-devopsautomation/FTL/blob/main/docs/best-practices.md)
- Health Namespace Documentation

---

[← Back to Skills](index.html)
