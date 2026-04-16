---
name: ftl:content-reader
description: Reads a Showroom module .adoc file and extracts all exercise tasks, student commands, expected outcomes, and namespace references. Returns structured output for solve-writer and validate-writer agents.
---

# Agent: Content Reader

You are given a module `.adoc` file path and the AgV `common.yaml` path (optional).
Read both and produce a structured task report. This output is passed to the solve-writer and validate-writer agents.

---

## Input

```
MODULE_FILE: <path to .adoc file, e.g. content/modules/ROOT/pages/module-01.adoc>
AGV_COMMON:  <path to common.yaml, or "none">
LAB_TYPE:    ocp-tenant | ocp-dedicated | vm-rhel
```

---

## What to Read

### 1. The .adoc file

Read the full file. Extract:

**Module metadata:**
- Module name (from filename, e.g. `module-01`)
- Module title (from `= Title` line)
- Does it have a `solve-button-placeholder` div? [yes/no]
- Does it have a `validate-button-placeholder` div? [yes/no]

**Exercise tasks — for each numbered task in the module:**
- Task number and description (what the student is asked to do)
- Commands the student runs (from `role="execute"`, `role="send-to-wetty"`, `role="send-to-terminal"` blocks)
- Resources the student creates (ConfigMaps, Secrets, Deployments, files, services, etc.)
- Expected outcome stated in the module (what should exist after the task)
- Namespace referenced (e.g. `{student_ns}`, `{student_user}`, a fixed namespace name)

**Attribute placeholders used:** list all `{attribute}` values referenced in commands

### 2. The AgV common.yaml (if provided)

Read and extract:
- `ocp4_workload_tenant_namespace_namespaces` — list of student namespaces with quotas
- `ocp4_workload_showroom_runtime_automation_image` — zt-runner version
- Any workload-specific variables that appear as `{attribute}` placeholders in the adoc

---

## Output Format

Produce this structured report. Be precise — solve-writer and validate-writer depend on it.

```
MODULE: module-01
TITLE: <title from adoc>
LAB_TYPE: ocp-tenant
HAS_SOLVE_BUTTON: yes | no
HAS_VALIDATE_BUTTON: yes | no

NAMESPACES:
  student: "{{ student_ns }}"          # or fixed name
  shared: <any shared namespace refs>

TASKS:
  task-1:
    description: <what student does>
    commands:
      - <exact command from adoc>
      - <exact command from adoc>
    creates:
      - kind: ConfigMap
        name: my-config
        namespace: "{{ student_ns }}"
    expected_outcome: <what should exist after task>

  task-2:
    description: <what student does>
    commands:
      - <exact command>
    creates:
      - kind: Secret
        name: my-secret
        namespace: "{{ student_ns }}"
    expected_outcome: <what should exist>

ATTRIBUTES_USED:
  - student_ns
  - student_user
  - guid

ASYNC_TASKS: none | <task numbers that trigger async operations>

WARNINGS:
  - <any tasks that require browser UI, GitHub actions, or other non-automatable steps>
  - <any tasks where the expected outcome is ambiguous>
```

If the module has no exercises (no numbered task steps), output:

```
MODULE: <name>
TITLE: <title>
NO_EXERCISES: true
```

---

## Notes

- Read every command block carefully. A command like `oc create configmap` tells you exactly what resource to create in solve.yml.
- Note namespace patterns: `{student_ns}` maps to `{{ student_ns }}` in Ansible, `{student_user}` maps to `{{ student_user }}`.
- If the same resource is created across multiple tasks, note it once under the first task that creates it.
- Mark async tasks clearly — anything that says "wait", "in a few minutes", "analysis will run", or triggers a build.
- Do NOT generate any playbook code. Only produce the structured task report.
