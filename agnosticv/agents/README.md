# AgnosticV Agents

Specialized review agent for validating AgnosticV skill workflow consistency.

## Agents

**`workflow-reviewer.md`** — AgnosticV Skill Workflow Reviewer
- Validates catalog-builder and validator are internally consistent
- Checks OCP vs cloud-vms-base split correctness (no cross-path bleed)
- Verifies everything the builder generates is checked by the validator
- Confirms @reference file routing and return signals are correct
- Detects orphaned content (checked but never generated, or generated but never checked)

## How to Invoke

```
Use the agnosticv:workflow-reviewer agent to review the skill workflow
```

Or invoke it directly when modifying any of these files:

- `agnosticv/skills/catalog-builder/SKILL.md`
- `agnosticv/skills/validator/SKILL.md`
- `agnosticv/docs/ocp-catalog-questions.md`
- `agnosticv/docs/cloud-vms-base-catalog-questions.md`
- `agnosticv/docs/ocp-validator-checks.md`
- `agnosticv/docs/cloud-vms-base-validator-checks.md`

## When to Run

Run the workflow-reviewer after any of these changes:

- Adding a new question to either infra path
- Adding a new validator check
- Changing a generated YAML field name or structure
- Adding a new infra type branch
- Modifying the Step 3 gate or validator Check 6 gate
