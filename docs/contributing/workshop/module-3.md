---
layout: default
title: Module 3 - Use Claude to Create Skills
---

# Module 3: Use Claude to Create Your First Skill

Learn effective prompting techniques to have Claude create custom skills for your workflows.

---

## Overview

In this module, you'll learn:
- How to describe your workflow to Claude
- Effective prompting patterns
- How to iterate with Claude
- Real examples of successful prompts

**Time:** 30 minutes

---

## Prompting Pattern 1: Convert Existing Documentation

**Use when:** You have documentation, runbooks, or procedures you want to automate

### Step 1: Prepare Your Context

Gather what you have:
- Documentation files (markdown, wiki pages)
- Shell scripts
- Step-by-step procedures
- Ansible playbooks

### Step 2: Prompt Claude

**Effective Prompt Template:**

```
I have [type of documentation] for [task/workflow].

Can you create a Claude Code skill that automates this workflow?

Here's the documentation:
[paste your content or point to file]

The skill should:
1. [Key step 1]
2. [Key step 2]
3. [Key step 3]

Use patterns from [RHDP skill] as a reference.
Make it similar to how [existing skill] works.
```

### Example 1: Shell Script → Skill

```
I have this shell script that deploys applications to OpenShift:

```bash
#!/bin/bash
# deploy.sh - Deploy app to OpenShift

# Check if logged in
oc whoami || exit 1

# Get environment
read -p "Environment (dev/stage/prod): " ENV

# Deploy
oc project myapp-$ENV
oc apply -f manifests/$ENV/
oc rollout status deployment/myapp
```

Can you create a Claude Code skill that automates this deployment?

The skill should:
1. Validate user is logged into OpenShift
2. Ask which environment to deploy to
3. Confirm before deploying
4. Apply manifests
5. Show rollout status
6. Handle errors gracefully

Use patterns from agnosticv/skills/catalog-builder/SKILL.md for:
- Environment detection (Step 0)
- User questions (Step 2)
- Git workflow (optional)
- Validation and confirmation

Format the skill with:
- Proper YAML frontmatter
- Step-by-step workflow
- Bash commands that Claude can execute
- Clear error handling
```

**What Claude Will Do:**
1. Read the referenced skill for patterns
2. Analyze your shell script
3. Create SKILL.md with proper structure
4. Add validation and error handling
5. Format with frontmatter and steps

---

## Prompting Pattern 2: Describe Your Workflow

**Use when:** You don't have documentation written down yet

### Step 1: Describe What You Do

Think through your manual process:
1. What do you do first?
2. What information do you need?
3. What commands do you run?
4. What can go wrong?
5. How do you know it worked?

### Step 2: Prompt Claude

**Effective Prompt Template:**

```
I want to create a skill that helps with [task].

Current manual process:
1. [Step 1 with commands]
2. [Step 2 with commands]
3. [Step 3 with commands]

Information needed from user:
- [Input 1]
- [Input 2]

Common issues:
- [Issue 1 and how to handle]
- [Issue 2 and how to handle]

Can you create a Claude Code skill for this?
Use [RHDP skill] as a template for the structure.
```

### Example 2: GitOps Workflow → Skill

```
I want to create a skill that helps with GitOps application deployment.

Current manual process:
1. cd into GitOps repository
2. Create new app directory: apps/myapp/
3. Create base/ and overlays/ subdirectories
4. Copy template kustomization.yaml files
5. Edit with app-specific values
6. Git commit and push
7. Wait for ArgoCD to sync

Information needed from user:
- Application name
- Base container image
- Environment overlays needed (dev/stage/prod)
- ArgoCD project

Common issues:
- Repository not found
- Invalid YAML syntax
- ArgoCD not syncing (wrong project)

Can you create a Claude Code skill for this?
Use agnosticv/skills/catalog-builder/SKILL.md for structure:
- Multi-step workflow
- File generation from templates
- Git workflow
- Validation before proceeding

Use showroom/skills/blog-generate/SKILL.md for:
- File detection
- Template population
- Error handling
```

---

## Prompting Pattern 3: Extend Existing Skill

**Use when:** An RHDP skill does something similar to what you need

### Step 1: Find Similar Skill

Browse RHDP marketplace:
- Showroom skills - Content generation, validation
- AgnosticV skills - Infrastructure, catalogs
- Health skills - Validation, testing

### Step 2: Prompt Claude

**Effective Prompt Template:**

```
Read [path to existing skill]

I want to create a similar skill but for [my use case].

Differences:
- Instead of [what existing skill does], do [what I need]
- Add [new feature]
- Change [aspect] to work with [my tools]

Keep the same:
- Overall workflow structure
- Question patterns
- Error handling approach
```

### Example 3: Extend catalog-builder

```
Read agnosticv/skills/catalog-builder/SKILL.md

I want to create a similar skill but for Ansible Galaxy roles.

The skill should:
- Detect if in an Ansible role directory
- Ask for role metadata (name, author, description)
- Generate role structure (tasks/, handlers/, defaults/, meta/)
- Create sample task files
- Generate meta/main.yml with dependencies
- Create README.md for the role

Keep the same:
- Multi-step workflow with clear steps
- Asking user questions with validation
- File generation patterns
- Review before writing files

Change:
- Instead of AgnosticV catalogs, work with Ansible roles
- Use Ansible Galaxy conventions
- Generate molecule/ tests directory
```

---

## Prompting Pattern 4: Combine Multiple Skills

**Use when:** You need functionality from several existing skills

### Step 1: Identify What to Combine

Look at:
- Workflow steps from skill A
- Questions pattern from skill B
- File generation from skill C
- Validation from skill D

### Step 2: Prompt Claude

**Effective Prompt Template:**

```
I want to create a skill that combines features from multiple RHDP skills:

From [skill 1]: [feature to use]
From [skill 2]: [feature to use]
From [skill 3]: [feature to use]

For my use case: [describe your workflow]

Can you read these skills and create a new one that:
1. [Combined feature 1]
2. [Combined feature 2]
3. [Combined feature 3]
```

### Example 4: Combine Showroom + AgnosticV

```
I want to create a skill for complete workshop+infrastructure setup.

From showroom/skills/create-lab/SKILL.md:
- Workshop content generation
- Module structure
- AsciiDoc formatting

From agnosticv/skills/catalog-builder/SKILL.md:
- Infrastructure catalog creation
- Environment detection
- Git workflow

For my use case: Create workshop + provision infrastructure in one workflow

Can you create a skill that:
1. Asks for workshop topic
2. Generates Showroom content (modules, labs)
3. Automatically creates AgnosticV catalog for the workshop
4. Links the two together (catalog → workshop URL)
5. Commits both to git
6. Creates PR for review

Use the question patterns from create-lab and file generation from catalog-builder.
```

---

## Iterating with Claude

Once Claude creates your initial skill, iterate to improve it.

### Iteration Pattern 1: Add Features

```
This is good! Can you add:
1. Validation that [prerequisite] exists before starting
2. A confirmation step before [critical action]
3. Progress indicators showing which step we're on
```

### Iteration Pattern 2: Handle Edge Cases

```
What happens if:
- The user cancels midway?
- [Command] fails?
- [File] doesn't exist?

Can you add error handling for these cases?
```

### Iteration Pattern 3: Improve UX

```
Can you improve the user experience by:
- Showing better examples in questions
- Adding a summary at the end showing what was created
- Making the git workflow optional
- Adding a dry-run mode
```

### Iteration Pattern 4: Add Templates

```
Can you add template options?

Like:
1. Minimal template (basic setup)
2. Standard template (production-ready)
3. Complete template (all features)

Let user choose at the start.
```

---

## Real Examples from RHDP

### Example: How catalog-builder Was Created

**Original prompt** (conceptual):
```
I need to automate AgnosticV catalog creation.

Manual process:
- Create dev.yaml, common.yaml, description.adoc
- Copy from existing catalogs
- Update deployer config
- Add to git

Create a skill with modes:
1. Full catalog creation
2. Description only (from Showroom)
3. Info template only

Use showroom patterns for content extraction.
```

**Iterations:**
1. Added Auto-detect AgV path from CLAUDE.md
2. Made git workflow optional
3. Added Virtual CI creation (Mode 4)
4. Improved description.adoc templates
5. Added validation before writing files

### Example: How verify-content Was Created

**Original prompt** (conceptual):
```
Create skill to validate Showroom content.

Should check:
- Red Hat style guidelines
- Technical accuracy
- Accessibility (WCAG)
- Structure/completeness

Use prompts from ~/.claude/prompts/ for validation criteria.
```

**Iterations:**
1. Added detection of prompts location (repo vs global)
2. Let user select which validation prompts to run
3. Added detailed validation reports
4. Fork context for isolated validation

---

## Effective Prompting Tips

### 1. Be Specific About Structure

❌ Bad: "Create a skill for deployments"

✅ Good: "Create a skill that validates prerequisites, asks for environment, deploys with oc apply, and shows status. Use agnosticv:catalog-builder as a template."

### 2. Reference RHDP Skills

❌ Bad: "Make it work like other skills"

✅ Good: "Use the question pattern from showroom:create-lab step 2, and the file generation from agnosticv:catalog-builder step 10"

### 3. Specify What to Keep/Change

❌ Bad: "Similar to catalog-builder but different"

✅ Good: "Keep: step structure, git workflow. Change: Instead of YAML files, generate JSON. Instead of AgnosticV, use Terraform."

### 4. Provide Examples

❌ Bad: "Ask for configuration"

✅ Good: "Ask for configuration like: 'Environment? (dev/stage/prod)' with dev as default, similar to how catalog-builder asks for category"

### 5. Iterate Incrementally

❌ Bad: "Add 10 new features all at once"

✅ Good: "First add prerequisite validation. Then we'll add confirmation prompts. Then error handling."

---

## Exercise: Create Your Skill

**Now it's your turn!**

1. **Think of a workflow you want to automate**
   - Deployment process?
   - File generation?
   - Validation workflow?

2. **Choose a prompting pattern:**
   - Pattern 1: Have documentation to convert?
   - Pattern 2: Describe manual process?
   - Pattern 3: Extend existing skill?
   - Pattern 4: Combine multiple skills?

3. **Prompt Claude:**
   - Use one of the templates above
   - Reference RHDP skills
   - Be specific about requirements

4. **Iterate:**
   - Test what Claude creates
   - Ask for improvements
   - Add error handling
   - Refine UX

---

## Common Prompting Mistakes

### Mistake 1: Too Vague

```
❌ "Create a skill for my project"
```

Fix: Describe the workflow, reference examples, specify outputs

### Mistake 2: No Examples Referenced

```
❌ "Create a skill that asks questions"
```

Fix: "Use the question pattern from showroom:create-lab where it asks for workshop title with validation"

### Mistake 3: Too Many Changes at Once

```
❌ "Create skill with 15 features, 3 modes, templates, validation, git, tests, docs..."
```

Fix: Start with core functionality, iterate to add features one by one

### Mistake 4: Not Testing Between Iterations

```
❌ [Get skill from Claude] → [Ask for 5 more features] → [Ask for 3 more features]
```

Fix: Test after each iteration, report issues, then add more

---

## Next Steps

**You've learned how to prompt Claude to create skills!**

Now let's learn how to have Claude package your skill as a plugin.

[Continue to Module 4: Use Claude to Package as Plugin →](module-4.html)

---

## Quick Reference

**Basic Prompt Structure:**
```
I have/want [what you have or want to automate]

[Describe workflow or paste documentation]

Create a Claude Code skill that:
1. [Feature 1]
2. [Feature 2]
3. [Feature 3]

Use [RHDP skill] as a template for [specific aspect]
```

**Iteration Prompt Structure:**
```
[Test result or issue]

Can you [specific improvement]?
```

**Reference Skills:**
- `showroom/skills/create-lab/` - Content generation, questions
- `showroom/skills/blog-generate/` - File detection, transformation
- `agnosticv/skills/catalog-builder/` - Multi-mode, file generation, git
- `agnosticv/skills/validator/` - Validation, checks, error reporting
- `health/skills/deployment-validator/` - Templates, test generation

[← Back to Module 2](module-2.html) | [Continue to Module 4 →](module-4.html)
