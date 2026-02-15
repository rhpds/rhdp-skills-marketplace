---
layout: default
title: Create Your Own Skills
---

# Create Your Own Skills & Plugins

<div class="reference-badge">From idea to marketplace in 5 phases</div>

<div class="callout callout-info">
<strong>Who this is for:</strong> RHDP team members who want to automate a workflow as a reusable Claude Code skill. You don't write skills by hand -- you use Claude to help you build them step by step.
</div>

---

## The Real Workflow {#overview}

Creating a skill is a 5-phase process. Each phase builds on the previous one:

| Phase | What You Do | What You Get |
|-------|-------------|--------------|
| **1. Document** | Have Claude interview you about your manual process | Plain `.md` reference files capturing your workflow |
| **2. Convert** | Point Claude at your `.md` files + an existing RHDP skill | A working `SKILL.md` |
| **3. Package** | Create the plugin directory structure | A plugin ready for testing |
| **4. Test** | Install locally and run through your workflow | A validated, working skill |
| **5. Publish** | Push to a marketplace repo | Your team can install it |

<div class="callout callout-tip">
<strong>Key insight:</strong> Most people skip Phase 1 and jump straight to writing a SKILL.md. This fails because you can't articulate every step, edge case, and decision in a single prompt. The iterative documentation phase is where the real value creation happens.
</div>

---

## Phase 1: Document Your Workflow with Claude {#phase-1}

Before writing any skill, get your process out of your head and into written form. Claude is your interviewer.

### Start a conversation

Open Claude Code in your project directory and describe what you want to automate:

```text
I want to automate the process of [creating new catalog items / deploying workshops /
validating content / whatever you do manually].

Here's what I currently do:
1. [First thing]
2. [Second thing]
3. [Third thing]

Can you help me document this process? Ask me questions about each step
so we capture everything -- prerequisites, decisions, edge cases, and outputs.
```

### Build reference files iteratively

As Claude interviews you, ask it to write up each part as a separate `.md` file:

```text
Great, now write up what we've discussed about the prerequisites
as docs/my-workflow/01-prerequisites.md

Then write the deployment steps as docs/my-workflow/02-deployment.md

And the validation checks as docs/my-workflow/03-validation.md
```

### What your reference files should capture

Each `.md` file should cover:
- **Prerequisites** -- what must exist before this step
- **Decisions** -- choices the user makes (with defaults)
- **Commands** -- the actual bash commands or file operations
- **Edge cases** -- what to do when things fail
- **Outputs** -- what gets created or changed

<div class="callout callout-warning">
<strong>Don't rush this step.</strong> If you already have documentation, runbooks, shell scripts, or team wiki pages, point Claude at those instead: <code>"Read docs/deployment-process.md and help me restructure it as step-by-step reference files."</code>
</div>

---

## Phase 2: Convert Your Docs into a SKILL.md {#phase-2}

Now that you have reference files, point Claude at them along with an existing RHDP skill as a template.

### The conversion prompt

```text
Read my reference files:
- docs/my-workflow/01-prerequisites.md
- docs/my-workflow/02-deployment.md
- docs/my-workflow/03-validation.md

Also read this existing RHDP skill for patterns:
agnosticv/skills/catalog-builder/SKILL.md

Create a SKILL.md for my workflow in skills/my-skill/SKILL.md

Follow the same patterns:
- Two YAML frontmatter blocks (identity + execution context)
- "What You'll Need Before Starting" section
- "When to Use / Don't Use" section
- Numbered workflow steps (Step 1, Step 2, etc.)
- Ask questions SEQUENTIALLY -- one at a time, wait for answer
- Use bash commands for file operations
- Show output confirmations, not full file content
```

### What Claude will create

Claude generates a SKILL.md with this structure:

```markdown
---
name: my-plugin:my-skill
description: What this skill does in one sentence
---

---
context: main
model: claude-opus-4-6
---

# My Skill Title

One-line description.

## What You'll Need Before Starting

**Required:**
- Item 1
- Item 2

**Helpful to have:**
- Item 3

## When to Use

**Use this skill when you want to:**
- Use case 1
- Use case 2

**Don't use this for:**
- Wrong use case -> use `/other-skill`

## Workflow

### Step 1: Detect Environment
[Commands to check prerequisites]

### Step 2: Ask Questions
[Sequential questions with defaults]

### Step 3: Generate Output
[File creation steps]

### Step 4: Validate and Deliver
[Verification commands and summary]
```

### Understanding the frontmatter

Every SKILL.md has two YAML blocks separated by `---`:

**Block 1 -- Identity (required):**

| Field | Purpose | Example |
|-------|---------|---------|
| `name` | Invocation name, format: `namespace:skill-name` | `showroom:create-lab` |
| `description` | One-line description shown in `/skills` list | Free text |

**Block 2 -- Execution context (optional):**

| Field | Purpose | Values |
|-------|---------|--------|
| `context` | How the skill runs | `main` (shares conversation), `fork` (isolated thread) |
| `model` | Which Claude model to use | `claude-opus-4-6`, `sonnet`, `haiku` |

<div class="callout callout-tip">
<strong>When to use <code>context: fork</code>:</strong> Use it for validation or analysis tasks that should not pollute the main conversation. The <code>verify-content</code> skill uses this. For skills that create files or need ongoing conversation context, use <code>context: main</code>.
</div>

### Iterate with Claude

Your first version won't be perfect. Iterate:

```text
This is good! Can you add:
1. Validation that the target directory exists before starting
2. A confirmation step before writing files
3. Error handling if the git command fails
```

```text
What happens if:
- The user cancels midway?
- The config file doesn't exist?
- The branch already exists?
Can you add error handling for these cases?
```

```text
Can you improve the UX by:
- Adding a summary at the end showing what was created
- Making the git workflow optional
- Adding a dry-run mode
```

### Which RHDP skills to use as templates

| If your skill does... | Study this skill | Why |
|----------------------|-----------------|-----|
| File generation | `agnosticv:catalog-builder` | Multi-mode, templates, YAML generation |
| Content creation | `showroom:create-lab` | Sequential questions, AsciiDoc output, reference repo pattern |
| Content transformation | `showroom:blog-generate` | Read input -> transform -> write output |
| Validation | `showroom:verify-content` | Fork context, verification prompts, reporting |
| Infrastructure | `health:deployment-validator` | Ansible role generation, test creation |

---

## Phase 3: Create the Plugin Structure {#phase-3}

A plugin packages your skill(s) for distribution. The minimum structure is two files.

### Minimum viable plugin

```text
my-plugin/
  .claude-plugin/
    plugin.json        # Plugin metadata (REQUIRED)
  skills/
    my-skill/
      SKILL.md         # Your skill (REQUIRED)
```

### Create plugin.json

Here is the actual `showroom/.claude-plugin/plugin.json` from the RHDP marketplace -- it's 7 lines:

```json
{
  "name": "showroom",
  "version": "1.0.0",
  "description": "Workshop and demo authoring tools",
  "author": {
    "name": "Your Name",
    "email": "you@example.com"
  }
}
```

| Field | Required | Purpose |
|-------|----------|---------|
| `name` | Yes | Plugin name; becomes the namespace prefix (e.g., `showroom:create-lab`) |
| `version` | Yes | Semver version; shown in `/plugin list` |
| `description` | Yes | Description shown in marketplace listings |
| `author` | No | Your contact info |

<div class="callout callout-warning">
<strong>Critical:</strong> The <code>name</code> in plugin.json becomes the namespace prefix for all your skills. If your plugin name is <code>my-tools</code> and your skill name is <code>deploy</code>, users will invoke it as <code>/my-tools:deploy</code>.
</div>

### Ask Claude to do it

You don't need to create this by hand:

```text
Create a plugin.json for my skill.
Plugin name: my-tools
Description: Deployment automation for my team
Put it in .claude-plugin/plugin.json
```

### Optional directories

As your plugin grows, you can add optional directories:

```text
my-plugin/
  .claude-plugin/
    plugin.json
  skills/
    skill-one/
      SKILL.md
    skill-two/
      SKILL.md
  agents/             # Specialized AI personas your skills can invoke
    reviewer.md
  docs/               # Shared documentation referenced by skills
    COMMON-RULES.md
  prompts/            # Verification/validation prompt files
    check-quality.txt
  templates/          # Content templates for file generation
    config.yaml
  README.md
```

| Directory | Purpose | Real example |
|-----------|---------|-------------|
| `agents/` | AI personas with specific expertise (editor, reviewer, style checker) | `showroom/agents/technical-writer.md` |
| `docs/` | Shared rules and reference docs that multiple skills use | `showroom/docs/SKILL-COMMON-RULES.md` |
| `prompts/` | Validation criteria files read before generating content | `showroom/prompts/redhat_style_guide_validation.txt` |
| `templates/` | Starter templates for file generation | `showroom/templates/workshop/` |

---

## Phase 4: Test Locally {#phase-4}

### Install your plugin

```bash
# Option 1: Install from local directory
/plugin marketplace add /path/to/your/plugin-directory

# Option 2: Install from GitHub
/plugin marketplace add yourusername/my-plugin-repo
```

Then install:

```bash
/plugin install my-tools@my-marketplace
```

### Verify it loaded

```bash
# Check plugin is listed
/plugin list

# Check skill appears
# Your skill should show as my-tools:skill-name
```

### Run through the workflow

```bash
# Navigate to a test project
cd ~/test-project

# Run your skill
/my-tools:deploy
```

### Fix issues with Claude

When something doesn't work, tell Claude exactly what went wrong:

```text
My skill failed at Step 3. The error was:
[paste error message]

Can you fix the SKILL.md? The issue is that it tries to read
a file that doesn't exist yet at that step.
```

### Testing checklist

- [ ] Skill loads without errors (`/plugin list` shows it)
- [ ] All workflow steps execute in order
- [ ] Questions are clear and have sensible defaults
- [ ] File operations create the right output
- [ ] Error cases are handled (missing files, wrong directory, etc.)
- [ ] The skill works on a fresh project (not just your test directory)

---

## Phase 5: Publish {#phase-5}

### Option A: Standalone GitHub repo

Push your plugin to a GitHub repository. Anyone can install it:

```bash
# Initialize and push
cd my-plugin/
git init && git add . && git commit -m "Initial commit"
git remote add origin https://github.com/yourusername/my-plugin.git
git push -u origin main
```

Users install with:

```bash
/plugin marketplace add yourusername/my-plugin
/plugin install my-tools@my-plugin
```

### Option B: Contribute to RHDP marketplace

If your skill is useful for the wider RHDP team:

1. **Fork the marketplace:**
```bash
git clone https://github.com/rhpds/rhdp-skills-marketplace
cd rhdp-skills-marketplace
```

2. **Create your plugin directory** following the structure in Phase 3

3. **Submit a pull request** -- requires [CODEOWNERS](https://github.com/rhpds/rhdp-skills-marketplace/blob/main/.github/CODEOWNERS) approval

<div class="callout callout-info">
<strong>RHDP marketplace users install with:</strong><br>
<code>/plugin marketplace add rhpds/rhdp-skills-marketplace</code><br>
<code>/plugin install my-tools@rhdp-marketplace</code>
</div>

---

## Reference: Patterns from Real Skills {#patterns}

These patterns appear in every well-built RHDP skill. Use them in yours.

### Pattern 1: Sequential questions

Ask one question at a time. Wait for the answer before asking the next one.

```markdown
### Step 2: Ask Questions

1. **Project name**
   - Ask: "What is the project name?"
   - Default: [detected from git repo]
   - WAIT for answer before proceeding

2. **Target environment**
   - Ask: "Which environment? (dev/stage/prod)"
   - Default: dev
   - WAIT for answer before proceeding
```

### Pattern 2: Detect first, ask second

Try to auto-detect information before asking the user:

```markdown
### Step 1: Detect Environment

1. Check if in git repository:
   ```bash
   git rev-parse --show-toplevel 2>/dev/null
   ```

2. **If git repo found:**
   - Use detected repo name as default
   - Show to user for confirmation

3. **If not in git repo:**
   - Ask user for project name
   - Ask for repository URL
```

### Pattern 3: Write files, don't display them

```markdown
### Step 5: Generate Output

Use the Write tool to create files. Show brief confirmations only:

"Created: config/deployment.yaml (45 lines)"
"Created: config/service.yaml (22 lines)"

Do NOT display full file content in the conversation.
```

### Pattern 4: Failure mode behavior

```markdown
**If [command] fails:**

**Cannot proceed safely**

**Blocking issue**: [specific problem]

**What I need**:
1. [specific fix 1]
2. [specific fix 2]

**Or**: Would you like to proceed with [fallback option]?
```

### Pattern 5: Cross-skill references

```markdown
**Don't use this for:**
- Creating workshop content -> use `/showroom:create-lab`
- Validating configurations -> use `/agnosticv:validator`
```

---

## Reference: RHDP Skills to Learn From {#examples}

All of these are in the [RHDP marketplace repo](https://github.com/rhpds/rhdp-skills-marketplace):

| Skill | Path | What to learn from it |
|-------|------|-----------------------|
| Create Lab | `showroom/skills/create-lab/SKILL.md` | Sequential questions, reference repo pattern, AsciiDoc generation |
| Create Demo | `showroom/skills/create-demo/SKILL.md` | Know/Show structure, presenter-led content |
| Blog Generate | `showroom/skills/blog-generate/SKILL.md` | Content transformation, platform-specific output |
| Verify Content | `showroom/skills/verify-content/SKILL.md` | Fork context, verification prompts, multi-agent validation |
| Catalog Builder | `agnosticv/skills/catalog-builder/SKILL.md` | Multi-mode operation, YAML templates, git workflow |
| Validator | `agnosticv/skills/validator/SKILL.md` | Validation rules, error reporting |
| Deployment Validator | `health/skills/deployment-validator/SKILL.md` | Ansible role generation, test creation |

---

## Prompting Tips {#tips}

### Be specific about structure

```text
# Bad
Create a skill for deployments

# Good
Create a skill that validates prerequisites (oc logged in, project exists),
asks for environment (dev/stage/prod), deploys with oc apply, and shows status.
Use agnosticv:catalog-builder as a template for the step structure.
```

### Reference specific skills

```text
# Bad
Make it work like other skills

# Good
Use the question pattern from showroom:create-lab Step 2,
and the file generation pattern from agnosticv:catalog-builder Step 10
```

### Specify what to keep and what to change

```text
# Bad
Similar to catalog-builder but different

# Good
Keep: step structure, git workflow, confirmation prompts
Change: Instead of YAML files, generate JSON configs.
Instead of AgnosticV paths, detect Terraform directories.
```

### Iterate incrementally

```text
# Bad
Add 10 new features all at once

# Good
First add prerequisite validation. Let me test that.
Then we'll add confirmation prompts. Then error handling.
```

---

## Resources {#resources}

<div class="links-grid">
  <a href="https://github.com/rhpds/rhdp-skills-marketplace" class="link-card">
    <h4>RHDP Marketplace</h4>
    <p>Source code with all skills and plugins</p>
  </a>
  <a href="../reference/best-practices.html" class="link-card">
    <h4>Claude Code Best Practices</h4>
    <p>CLAUDE.md setup, models, context, sessions</p>
  </a>
  <a href="../reference/quick-reference.html" class="link-card">
    <h4>Quick Reference</h4>
    <p>Commands, shortcuts, workflows at a glance</p>
  </a>
  <a href="../setup/claude-code.html" class="link-card">
    <h4>Claude Code Setup</h4>
    <p>First-time installation guide</p>
  </a>
</div>

**Community:**
- Slack: [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX)
- GitHub: [rhdp-skills-marketplace/issues](https://github.com/rhpds/rhdp-skills-marketplace/issues)

---

<div class="navigation-footer">
  <a href="../index.html" class="nav-button">Back to Home</a>
</div>

<style>
/* Page badge */
.reference-badge {
  display: inline-block;
  background: linear-gradient(135deg, #0969da 0%, #0550ae 100%);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  font-weight: 600;
  margin: 1rem 0;
}

/* Callout boxes */
.callout {
  padding: 1rem 1.25rem;
  margin: 1.5rem 0;
  border-radius: 6px;
  border-left: 4px solid;
}
.callout-warning {
  background: linear-gradient(135deg, #fff3cd 0%, #fff8e1 100%);
  border-left-color: #ffc107;
}
.callout-tip {
  background: linear-gradient(135deg, #d4edda 0%, #f0fff4 100%);
  border-left-color: #28a745;
}
.callout-info {
  background: linear-gradient(135deg, #e7f3ff 0%, #f0f7ff 100%);
  border-left-color: #0969da;
}
.callout-danger {
  background: linear-gradient(135deg, #f8d7da 0%, #fff5f5 100%);
  border-left-color: #dc3545;
}

/* Tables */
table {
  border-collapse: collapse;
  width: 100%;
  margin: 1.5em 0;
}
table th {
  background-color: #f6f8fa;
  border: 1px solid #e1e4e8;
  padding: 8px 12px;
  text-align: left;
  font-weight: 600;
}
table td {
  border: 1px solid #e1e4e8;
  padding: 8px 12px;
}
table tr:nth-child(even) {
  background-color: #f6f8fa;
}

/* Links grid */
.links-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin: 2rem 0;
}
.link-card {
  display: block;
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
  text-decoration: none;
  color: inherit;
  transition: all 0.2s ease;
}
.link-card:hover {
  border-color: #EE0000;
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
}
.link-card h4 {
  margin: 0 0 0.5rem 0;
  color: #24292e;
}
.link-card p {
  margin: 0;
  color: #586069;
  font-size: 0.875rem;
}

/* Navigation footer */
.navigation-footer {
  display: flex;
  justify-content: center;
  margin: 2rem 0;
  padding-top: 2rem;
  border-top: 1px solid #e1e4e8;
}
.nav-button {
  padding: 0.75rem 1.5rem;
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 8px;
  text-decoration: none;
  color: #24292e;
  font-weight: 600;
  transition: all 0.2s ease;
}
.nav-button:hover {
  border-color: #EE0000;
  color: #EE0000;
  transform: translateY(-2px);
}
</style>
