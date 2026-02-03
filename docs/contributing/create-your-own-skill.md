---
layout: default
title: Create Your Own Skill & Plugin
---

# Workshop: Create Your Own Claude Code Skill & Plugin

Learn how to create custom skills and plugins for Claude Code by building a real example step-by-step.

---

## Workshop Overview

**What you'll build:** A working Claude Code skill that automates your daily tasks

**What you'll learn:**
1. How skills work by exploring real RHDP skills
2. Create your own skill following our patterns
3. Package it as a plugin
4. Share it with your team or contribute to RHDP marketplace

**Time:** 60-90 minutes self-paced

**Prerequisites:**
- Claude Code CLI or VS Code with Claude extension
- Basic markdown knowledge (headings, code blocks, lists)
- Git installed

**Official Resources:**
- 📚 [Claude Code Documentation](https://code.claude.com/docs) - Complete reference
- 🏛️ [Agent Skills Standard](https://agentskills.io) - Open standard for AI agent skills
- 🧑‍💻 [RHDP Marketplace GitHub](https://github.com/rhpds/rhdp-skills-marketplace) - Source code

---

## Your Learning Path

**Beginner** (never created a skill):
1. Start with Module 1 (Understanding)
2. Do Module 2 exercises (Learn from RHDP skills)
3. Complete Module 3 (Create your first skill)
4. Try Module 4 (Package as plugin)

**Intermediate** (created skills before):
1. Skim Module 1
2. Jump to Module 5 (Testing)
3. Explore Module 6 (Advanced features)
4. Review Module 8 (Best practices)

**Advanced** (contributing to RHDP):
1. Review Module 7 (Publishing)
2. Study Module 8 (Patterns)
3. Check Module 9 (Real-world examples)
4. See [CODEOWNERS](https://github.com/rhpds/rhdp-skills-marketplace/blob/main/.github/CODEOWNERS) for contribution rules

---

## 💡 Have Existing Documentation? Let Claude Help!

**You don't have to start from scratch!**

If you already have:
- Step-by-step documentation
- Runbooks or procedures
- Shell scripts or automation
- Team workflows

**Claude can help you convert it into a skill.**

### How to Get Help from Claude

**Option 1: Paste your existing docs**

```
I have this documentation for [task]. Can you help me convert it into a Claude Code skill?

[Paste your documentation here]
```

**Option 2: Point to your files**

```
I have a workflow in docs/deployment-process.md.
Can you read it and help me create a skill that guides users through this process?
```

**Option 3: Start a conversation**

```
I want to create a skill that helps with [task].
Here's what I currently do manually:
1. [Step 1]
2. [Step 2]
3. [Step 3]

Can you help me structure this as a skill?
```

**Claude will:**
- ✅ Analyze your workflow
- ✅ Suggest skill structure
- ✅ Write the SKILL.md file
- ✅ Add proper frontmatter and formatting
- ✅ Create examples and templates

**Try it now in this workshop!** As you read through the modules, ask Claude to help you create your skill based on your existing work.

### Effective Prompting Patterns

**Pattern 1: Convert existing documentation**
```
I have documentation for [task] in [file/URL].
Convert it into a Claude Code skill using RHDP patterns from the marketplace.
```

**Pattern 2: Create from description**
```
Create a Claude Code skill that [does task].
It should:
1. [Step 1]
2. [Step 2]
3. [Step 3]

Use patterns from showroom:blog-generate for inspiration.
```

**Pattern 3: Improve existing skill**
```
Read agnosticv/skills/catalog-builder/SKILL.md
Create a similar skill for [my use case] but simplified for [specific need].
```

**Pattern 4: Debug and fix**
```
This skill fails at Step 3 with error [error message].
Can you fix the bash command and add error handling?
```

---

## Module 1: Understanding Skills & Plugins

### What is a Skill?

A skill is a specialized instruction set that tells Claude how to help with a specific task. It's written in markdown with YAML frontmatter.

**Anatomy of a skill:**
```markdown
---
name: my-skill
description: What this skill does
version: 1.0.0
---

# Skill Instructions

[Detailed instructions for Claude on how to perform the task]
```

**Key components:**
1. **Frontmatter** - Metadata (name, description, version)
2. **Instructions** - Step-by-step guidance for Claude
3. **Examples** - Sample outputs and workflows
4. **Rules** - Constraints and best practices

### What is a Plugin?

A plugin packages one or more skills for distribution. It includes:
- `plugin.json` - Plugin metadata
- `skills/` - Directory containing skill files
- Optional: `docs/`, `templates/`, `prompts/`, `agents/`

**Plugin structure:**
```
my-plugin/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   ├── skill-one/
│   │   └── SKILL.md
│   └── skill-two/
│       └── SKILL.md
└── README.md
```

---

## Module 2: Learning from Real RHDP Skills

Let's explore actual skills from the RHDP marketplace. Clone the repository and open the skills to follow along.

### 🔧 Hands-On Setup

```bash
# Clone the RHDP marketplace
git clone https://github.com/rhpds/rhdp-skills-marketplace
cd rhdp-skills-marketplace

# Open in your editor
code .  # VS Code
# or just browse on GitHub
```

**📚 Official Documentation:** See [Skills Reference Guide](https://code.claude.com/docs/en/skills) for core concepts.

### 🚀 Try It Now: Test an Existing Skill

Before creating your own, let's run a real RHDP skill:

```bash
# Install the showroom plugin (if not already)
/plugin install showroom@rhdp-marketplace

# Restart Claude Code
# exit and restart

# Try the blog-generate skill
/showroom:blog-generate
```

**What to observe:**
1. How Claude asks questions
2. How it detects your environment
3. How it shows progress through steps
4. How it generates output

This is what YOUR skill will do!

### Exercise 1: Explore a Simple Skill

**🎯 Open this file:** `showroom/skills/blog-generate/SKILL.md`

This skill converts workshop content to blog posts. It's a great example of a focused, single-purpose skill.

**👀 What to observe:**

1. **Clear frontmatter:**
```yaml
---
name: showroom:verify-content
description: Run comprehensive quality verification on workshop content
---
```

2. **Secondary configuration block:**
```yaml
---
context: fork
model: sonnet
---
```

Options:
- `context: fork` - Run in isolated context
- `model: sonnet|opus|haiku` - Specify model preference

3. **When to Use section:**
- Clearly states what the skill does
- Lists what it DOESN'T do (prevents misuse)

4. **Step-by-step workflow:**
- Numbered steps with clear actions
- Uses bash commands Claude can execute
- Provides decision logic

### Exercise 2: Analyze a Multi-Step Workflow Skill

**🎯 Open this file:** `agnosticv/skills/catalog-builder/SKILL.md`

This is our most complex skill - it creates entire AgnosticV catalog structures. Let's see how it handles complexity.

**👀 What to observe:**

1. **Multi-mode operation:**
```markdown
## Modes

**Mode 1:** Full Catalog (common.yaml + dev.yaml + description.adoc + info template)
**Mode 2:** Description Only (extract from Showroom)
**Mode 3:** Info Template Only
```

2. **Variable management:**
```markdown
## Variables to Track

Track these throughout the workflow:
- `AGV_PATH`: Path to AgnosticV repository
- `CATALOG_NAME`: Name of the catalog
- `CATEGORY`: Workshop or Demo
```

3. **Conditional logic:**
```markdown
**If Showroom found:**
  → Step 2: Extract from modules

**If NO Showroom:**
  → Step 2a: Manual entry
```

4. **Templates and examples:**
```yaml
# Example common.yaml template
__meta__:
  deployer:
    scm_url: https://github.com/redhat-cop/agnosticd
    scm_ref: development
```

---

## Module 3: Hands-On - Use Claude to Create Your First Skill

Let's use Claude to create a practical skill: **README Generator**

This skill will help generate comprehensive README files for GitHub repositories.

**Important:** You're not writing this by hand! You'll use Claude to help you.

### Step 1: Set Up Your Workspace

```bash
mkdir -p ~/my-skills/readme-generator/skills/readme-generator
cd ~/my-skills/readme-generator
```

### Step 2: Ask Claude to Create the Skill

**Copy this prompt to Claude Code:**

```
I want to create a Claude Code skill that generates README files for GitHub projects.

The skill should:
1. Detect the repository name and language
2. Ask users for project details (description, features, installation method)
3. Generate a professional README.md with proper sections
4. Include badges, installation instructions, and usage examples

Can you create a SKILL.md file for this in skills/readme-generator/SKILL.md?

Use these patterns from RHDP skills:
- Detect environment first (git repo, language)
- Ask clear questions with examples
- Use bash commands for file operations
- Show output before writing files
- Ask for user confirmation

Format it with:
- YAML frontmatter (name, description, version)
- Context: fork
- Step-by-step workflow
- Examples and templates
```

**Claude will generate the SKILL.md file for you!**

### What Claude Creates

Claude will write something like this:

```markdown
---
name: readme-generator
description: Generate comprehensive README.md files for GitHub repositories with proper structure and best practices
version: 1.0.0
---

---
context: fork
model: sonnet
---

# README Generator Skill

Generate professional README.md files for GitHub repositories following best practices.

## When to Use

**Use this skill when you want to:**
- Create a new README for a project
- Improve an existing README with proper structure
- Add badges, installation instructions, and usage examples
- Generate contributor guidelines

**Don't use this for:**
- Code documentation → use inline comments or docs generators
- API documentation → use tools like Swagger/OpenAPI

## Workflow

### Step 1: Detect Repository Information

**Gather basic repository information:**

1. **Check if in git repository:**
   ```bash
   git rev-parse --show-toplevel
   ```

2. **Get repository name:**
   ```bash
   basename $(git rev-parse --show-toplevel)
   ```

3. **Get remote URL (if exists):**
   ```bash
   git remote get-url origin 2>/dev/null
   ```

4. **Detect primary language:**
   ```bash
   find . -name "*.py" -o -name "*.js" -o -name "*.go" -o -name "*.java" | head -5
   ```

**If not in git repo:**
- Ask user for project name
- Ask for primary programming language
- Ask for repository URL (if creating before pushing)

### Step 2: Ask Key Questions

**Required information:**

1. **Project title**
   - Use detected name as default
   - Ask: "Project name? [detected-name]"

2. **One-line description**
   - Ask: "What does this project do? (one sentence)"
   - Example: "Generates professional README files for GitHub repositories"

3. **Target audience**
   - Ask: "Who is this for? (developers/sysadmins/end-users)"
   - Multiple options: "developers, sysadmins, end users"

4. **Installation method**
   - Ask: "Installation method? (npm/pip/go/docker/manual)"
   - Determines which installation instructions to generate

5. **Main features**
   - Ask: "List 3-5 key features (one per line)"
   - Wait for multi-line input

6. **License**
   - Ask: "License? (MIT/Apache-2.0/GPL/Proprietary)"
   - Default: MIT for open source projects

**Optional features (ask with Y/n defaults):**

1. **Include badges?** `[Y/n]`
   - GitHub stars, license badge, build status

2. **Include screenshots/demo?** `[Y/n]`
   - Adds Screenshots section with placeholder

3. **Include contributing guidelines?** `[Y/n]`
   - Adds Contributing section with link to CONTRIBUTING.md

4. **Include code of conduct?** `[Y/n]`
   - Adds Code of Conduct section

### Step 3: Generate README Structure

**Create README.md with this structure:**

```markdown
# [Project Title]

[One-line description]

[Badges if requested]

## Features

- [Feature 1]
- [Feature 2]
- [Feature 3]

## Installation

[Installation instructions based on method]

## Usage

[Basic usage example with code blocks]

## Configuration

[Configuration options if applicable]

## Examples

[Real-world examples]

## Contributing

[Contributing guidelines if requested]

## License

[License information]

## Support

[Support channels - Issues, Slack, Email]
```

### Step 4: Add Badges (if requested)

**Generate appropriate badges:**

For GitHub repo:
```markdown
[![License](https://img.shields.io/github/license/OWNER/REPO)](LICENSE)
[![Stars](https://img.shields.io/github/stars/OWNER/REPO)](https://github.com/OWNER/REPO/stargazers)
[![Issues](https://img.shields.io/github/issues/OWNER/REPO)](https://github.com/OWNER/REPO/issues)
```

For npm package:
```markdown
[![npm version](https://badge.fury.io/js/PACKAGE.svg)](https://www.npmjs.com/package/PACKAGE)
[![Downloads](https://img.shields.io/npm/dm/PACKAGE.svg)](https://npmjs.org/package/PACKAGE)
```

### Step 5: Write Installation Instructions

**Based on installation method, provide:**

**npm:**
```bash
npm install package-name
```

**pip:**
```bash
pip install package-name
```

**Docker:**
```bash
docker pull user/image:tag
docker run -p 8080:8080 user/image:tag
```

**Manual:**
```bash
git clone https://github.com/user/repo
cd repo
make install
```

### Step 6: Add Usage Examples

**Create realistic code examples:**

1. Basic usage example
2. Common use case example
3. Advanced example (if applicable)

**Use proper code fencing:**
````markdown
```language
code example here
```
````

### Step 7: Review and Save

1. **Show generated README to user**
2. **Ask: Is this README accurate? [Y/n]**
   - If No: Ask what needs to be changed
   - If Yes: Save to README.md

3. **Write file:**
   ```bash
   cat > README.md <<'EOF'
   [generated content]
   EOF
   ```

4. **Confirm:**
   ```
   ✓ README.md created successfully!

   Next steps:
   - Review the content
   - Add screenshots if needed
   - Commit: git add README.md && git commit -m "Add README"
   ```

## Best Practices

**README Quality Rules:**
1. **Be concise** - README should be scannable in 2-3 minutes
2. **Show, don't tell** - Include code examples
3. **Start simple** - Basic example first, advanced later
4. **Keep current** - Update README when features change
5. **Think mobile** - Many developers read on phones

**Structure Rules:**
1. **Title + description first** - Reader knows what this is immediately
2. **Installation second** - Reader can try it quickly
3. **Usage third** - Reader learns how to use it
4. **Everything else fourth** - Contributing, license, etc.

**Writing Style:**
- Use present tense ("This tool generates..." not "This tool will generate...")
- Be specific ("Supports Python 3.8+" not "Supports modern Python")
- Include commands that work (test your install instructions!)
- Link to related docs/resources

## Templates

### Minimal README Template

```markdown
# Project Name

One-line description.

## Installation

\`\`\`bash
npm install project-name
\`\`\`

## Usage

\`\`\`javascript
const project = require('project-name');
project.doSomething();
\`\`\`

## License

MIT
```

### Complete README Template

```markdown
# Project Name

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

One-line description with key benefit.

## Features

- Feature 1
- Feature 2
- Feature 3

## Prerequisites

- Requirement 1
- Requirement 2

## Installation

\`\`\`bash
installation commands
\`\`\`

## Quick Start

\`\`\`bash
quick start commands
\`\`\`

## Usage

### Basic Example

\`\`\`language
basic code example
\`\`\`

### Advanced Example

\`\`\`language
advanced code example
\`\`\`

## Configuration

| Option | Description | Default |
|--------|-------------|---------|
| option1 | What it does | value |

## API Reference

[Link to full API docs]

## Examples

See [examples/](examples/) directory.

## Troubleshooting

**Problem:** Common issue
**Solution:** How to fix

## Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

This project is licensed under MIT - see [LICENSE](LICENSE).

## Support

- Issues: [GitHub Issues](https://github.com/user/repo/issues)
- Slack: #channel
- Email: support@example.com
```

## Error Handling

**If repository detection fails:**
- Fall back to manual questions
- Don't assume git repository exists
- Provide option to create README without git context

**If user answers are incomplete:**
- Provide sensible defaults
- Mark sections with TODO for user to fill in
- Don't leave blank sections

**If language detection fails:**
- Ask user directly
- Offer common options (JavaScript, Python, Go, Java, Rust)
- Default to generic language-agnostic examples
```

### Step 3: Review What Claude Created

**Ask Claude to explain the skill:**

```
Can you explain how this skill works? Walk me through each step.
```

**Ask for improvements:**

```
Can you add:
1. Detection of existing README (offer to update instead of replace)
2. More badge options (npm, PyPI, Docker)
3. A template for API documentation README
```

**Claude will iterate on the skill based on your feedback.**

### Step 4: Test Your Skill

**Test locally before packaging:**

1. **Ask Claude to install it:**
```
Can you copy this skill to ~/.claude/skills/ for testing?
```

2. **Restart Claude Code**

3. **Test the skill:**
```bash
cd ~/some-project
/readme-generator
```

4. **If it doesn't work, ask Claude to fix it:**
```
The skill failed at Step 2 when detecting the repository.
Can you fix the git detection logic?
```

### Step 5: Iterate with Claude

**Based on testing, keep improving:**

```
The README it generated is good, but can you:
- Add a troubleshooting section template
- Include example environment variables
- Add support for monorepos
```

**Claude will update the skill until it's perfect.**

---

## Module 4: Package Your Skill into a Plugin

Now let's turn our skill into a distributable plugin.

### Step 1: Create Plugin Metadata

Create `.claude-plugin/plugin.json`:

```json
{
  "name": "readme-tools",
  "version": "1.0.0",
  "description": "Tools for generating and maintaining README files",
  "author": {
    "name": "Your Name",
    "email": "your.email@example.com"
  },
  "license": "MIT",
  "homepage": "https://github.com/yourusername/readme-tools",
  "repository": {
    "type": "git",
    "url": "https://github.com/yourusername/readme-tools.git"
  },
  "tags": ["readme", "documentation", "github"],
  "skills": [
    {
      "path": "./skills/readme-generator/SKILL.md",
      "name": "readme-generator"
    }
  ]
}
```

**Plugin.json fields explained:**

- `name` - Plugin identifier (lowercase, hyphens)
- `version` - Semantic version (1.0.0)
- `description` - What the plugin provides
- `author` - Your contact information
- `license` - Open source license
- `repository` - Git repository URL
- `tags` - Search/discovery keywords
- `skills` - Array of skills this plugin provides

### Step 2: Add Plugin README

Create `README.md` in plugin root:

```markdown
# README Tools Plugin

Claude Code plugin for generating professional README files.

## Skills

- `/readme-generator` - Generate comprehensive README.md files

## Installation

\`\`\`bash
# Add to your Claude Code skills
/plugin install readme-tools@your-marketplace
\`\`\`

## Usage

\`\`\`bash
cd your-project
/readme-generator
\`\`\`

## License

MIT
```

### Step 3: Final Directory Structure

Your plugin should look like:

```
readme-tools/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   └── readme-generator/
│       └── SKILL.md
├── README.md
├── LICENSE
└── .gitignore
```

### Step 4: Create Git Repository

```bash
cd ~/my-skills/readme-tools
git init
git add .
git commit -m "Initial commit: README generator skill"
git branch -M main
git remote add origin https://github.com/yourusername/readme-tools.git
git push -u origin main
```

### Step 5: Add License

Create `LICENSE` file (MIT example):

```
MIT License

Copyright (c) 2026 Your Name

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

### Step 6: Add .gitignore

```
.DS_Store
*.swp
*~
.vscode/
.idea/
```

---

## Module 5: Testing and Validation

### Testing Checklist

**Functional Testing:**
- [ ] Skill loads without errors
- [ ] All workflow steps execute correctly
- [ ] File operations work (read/write)
- [ ] Git commands execute properly
- [ ] Questions are clear and complete
- [ ] Generated output is correct

**Edge Case Testing:**
- [ ] Works outside git repository
- [ ] Handles missing dependencies
- [ ] Graceful error messages
- [ ] Works with different file structures
- [ ] Handles user cancellation

**Quality Testing:**
- [ ] Instructions are clear
- [ ] Examples are realistic
- [ ] Templates are well-formatted
- [ ] Best practices are followed
- [ ] Documentation is complete

### Validation Commands

**Test installation:**
```bash
/plugin list
# Should show your plugin

/skills
# Should show your skill
```

**Test execution:**
```bash
# In a test project
/readme-generator
# Follow the workflow
```

**Test error handling:**
```bash
# In non-git directory
/readme-generator
# Should handle gracefully
```

---

## Module 6: Advanced Plugin Features

### Add Multiple Skills to One Plugin

**Example: README tools with multiple skills**

```
readme-tools/
├── .claude-plugin/plugin.json
├── skills/
│   ├── readme-generator/SKILL.md
│   ├── readme-validator/SKILL.md
│   └── readme-updater/SKILL.md
```

Update `plugin.json`:
```json
{
  "skills": [
    {
      "path": "./skills/readme-generator/SKILL.md",
      "name": "readme:generator"
    },
    {
      "path": "./skills/readme-validator/SKILL.md",
      "name": "readme:validator"
    },
    {
      "path": "./skills/readme-updater/SKILL.md",
      "name": "readme:updater"
    }
  ]
}
```

**Namespace pattern:**
- Use `namespace:skill-name` format
- Namespace groups related skills
- Makes it clear which plugin provides the skill

### Add Templates

Some skills benefit from templates:

```
readme-tools/
├── templates/
│   ├── minimal-readme.md
│   ├── complete-readme.md
│   └── api-readme.md
```

**In SKILL.md, reference templates:**
```markdown
## Step 3: Select Template

Ask user which template to use:
1. Minimal (quick start projects)
2. Complete (production projects)
3. API (library/framework projects)

Read template from:
```bash
cat ~/.claude/templates/readme-tools/[template-name].md
```
````

### Add Prompts

For complex validation or AI-assisted steps:

```
readme-tools/
├── prompts/
│   ├── validate-readme-quality.txt
│   └── improve-readme-clarity.txt
```

**Prompt example (`validate-readme-quality.txt`):**
```
Validate this README for quality and completeness:

Check for:
1. Clear project description
2. Installation instructions that work
3. Usage examples with code
4. Proper markdown formatting
5. Links that aren't broken
6. Consistent voice and tone

Report issues and suggest improvements.
```

### Add Agents

For specialized sub-tasks:

```
readme-tools/
├── agents/
│   └── readme-reviewer.md
```

**Agent example:**
```markdown
---
name: readme-reviewer
description: Expert README reviewer providing feedback
---

You are an expert at reviewing README files for open source projects.

Your role:
- Review README structure and completeness
- Check for clarity and accuracy
- Suggest improvements for discoverability
- Validate code examples
- Ensure best practices are followed

Provide specific, actionable feedback.
```

---

## Module 7: Publishing to Marketplace

### Option 1: Create Your Own Marketplace

**Structure:**
```
my-marketplace/
├── .claude-plugin/
│   └── marketplace.json
└── readme-tools/
    └── [plugin files]
```

**marketplace.json:**
```json
{
  "name": "my-marketplace",
  "owner": {
    "name": "Your Name",
    "email": "your.email@example.com"
  },
  "metadata": {
    "description": "My custom Claude Code plugins",
    "version": "1.0.0"
  },
  "plugins": [
    {
      "name": "readme-tools",
      "source": "./readme-tools",
      "version": "1.0.0",
      "description": "Tools for generating README files"
    }
  ]
}
```

**Users install with:**
```bash
/plugin marketplace add https://github.com/yourusername/my-marketplace
/plugin install readme-tools@my-marketplace
```

### Option 2: Contribute to RHDP Marketplace

**Steps:**

1. **Fork the marketplace:**
```bash
git clone https://github.com/rhpds/rhdp-skills-marketplace
cd rhdp-skills-marketplace
```

2. **Create your plugin directory:**
```bash
mkdir -p your-plugin/skills/your-skill
```

3. **Add to marketplace.json:**
```json
{
  "plugins": [
    ...existing plugins...,
    {
      "name": "your-plugin",
      "source": "./your-plugin",
      "version": "1.0.0",
      "description": "Your plugin description"
    }
  ]
}
```

4. **Create pull request**

5. **Get code owner approval** (from CODEOWNERS file)

---

## Module 8: Best Practices and Patterns

### Skill Writing Best Practices

**1. Clear Workflow Steps:**
```markdown
### Step 1: Detect Environment

**First, check the environment:**
1. Run command to detect
2. Handle success case
3. Handle failure case
```

**2. Bash Commands Claude Can Execute:**
```bash
# Good - simple, direct
ls -la

# Bad - interactive
vim file.txt

# Good - non-interactive alternative
cat file.txt
```

**3. Decision Logic:**
```markdown
**If condition A:**
  → Do action 1
  → Then action 2

**If condition B:**
  → Do action 3
  → Then action 4
```

**4. Variable Tracking:**
```markdown
## Variables to Track

Throughout this workflow, maintain:
- `PROJECT_NAME`: Detected or user-provided project name
- `LANGUAGE`: Primary programming language
- `HAS_GIT`: Boolean, true if git repository exists
```

**5. User Questions:**
```markdown
Q: What is the project name?
   Default: [detected-name]

Q: Installation method? [npm/pip/docker/manual]
   Validate: Must be one of the options
```

### Common Patterns

**Pattern: Detect → Ask → Generate → Review**
```markdown
1. Detect what you can automatically
2. Ask user for what you can't detect
3. Generate the output
4. Show user and ask for confirmation
5. Write the file
```

**Pattern: Multi-Mode Skills**
```markdown
## Modes

Ask user which mode:
1. Mode A - Full generation
2. Mode B - Update only
3. Mode C - Validation only

Based on selection, follow different workflow.
```

**Pattern: Template Selection**
```markdown
## Templates Available

1. Minimal (lines 1-50)
2. Standard (lines 51-150)
3. Complete (lines 151-300)

Ask user to select, then use template.
```

### Error Handling Patterns

**Pattern: Graceful Fallback**
```markdown
### Step 1: Try to Detect

```bash
result=$(git remote get-url origin 2>/dev/null)
```

**If detection succeeds:**
- Use detected value
- Show to user for confirmation

**If detection fails:**
- Ask user for manual input
- Provide example format
- Continue workflow normally
```

**Pattern: Validation with Retry**
```markdown
### Step 3: Validate Input

**Check if valid:**
```bash
test -f package.json
```

**If valid:**
- Proceed to next step

**If invalid:**
- Show error message
- Ask user to fix or provide alternative
- Retry validation
```

---

## Module 9: Real-World Examples

### Example 1: Changelog Generator Skill

```markdown
---
name: changelog-generator
description: Generate CHANGELOG.md from git commits following Keep a Changelog format
---

# Changelog Generator

Generate a CHANGELOG.md file from git commit history.

## Workflow

### Step 1: Get Version Tags

```bash
git tag --sort=-v:refname | head -10
```

### Step 2: Get Commits Between Tags

For each version:
```bash
git log v1.0.0..v1.1.0 --pretty=format:"%h %s"
```

### Step 3: Categorize Commits

Parse commit messages:
- `feat:` → Added section
- `fix:` → Fixed section
- `docs:` → Documentation section
- `breaking:` → Breaking Changes section

### Step 4: Generate CHANGELOG.md

Use Keep a Changelog format:
```markdown
# Changelog

## [1.1.0] - 2026-02-03

### Added
- New feature from commit

### Fixed
- Bug fix from commit
```

[Rest of skill workflow...]
```

### Example 2: API Documentation Skill

```markdown
---
name: api-docs-generator
description: Generate API documentation from OpenAPI/Swagger specifications
---

# API Documentation Generator

Convert OpenAPI spec to user-friendly documentation.

## Workflow

### Step 1: Find OpenAPI Spec

```bash
find . -name "openapi.yaml" -o -name "swagger.json"
```

### Step 2: Parse Endpoints

Extract:
- HTTP methods (GET, POST, PUT, DELETE)
- Paths (/api/users, /api/posts)
- Parameters
- Request/response schemas

### Step 3: Generate Markdown Docs

For each endpoint:
```markdown
## GET /api/users

Get list of users.

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| page | integer | No | Page number |

**Response:**
```json
{
  "users": [...]
}
```
```

[Rest of skill workflow...]
```

---

## Module 10: Testing Your Learning

### Capstone Exercise Options

Choose based on your use case:

#### Option A: RHDP Team - Showroom Enhancement Skill

**Create a "Workshop Metrics" skill that:**

Requirements:
1. Analyzes Showroom workshop modules
2. Counts learning objectives, steps, code blocks
3. Estimates completion time based on content
4. Generates a metrics report (JSON or markdown)
5. Suggests improvements (too long, too short, missing objectives)

**Why:** Helps workshop authors optimize content length and structure.

**Files to analyze:**
- `content/modules/*/pages/*.adoc` (Showroom structure)
- Count code blocks, lists, exercises
- Estimate reading + hands-on time

#### Option B: RHDP Team - AgnosticV Helper Skill

**Create a "Catalog Validator Plus" skill that:**

Requirements:
1. Extends `/agnosticv:validator` with additional checks
2. Validates naming conventions (no spaces, lowercase)
3. Checks for required metadata fields
4. Verifies deployer versions are current
5. Suggests catalog improvements

**Why:** Additional quality checks before PR submission.

#### Option C: General - License Generator Skill

**Create a "License Generator" skill that:**

Requirements:
1. Detects project language and dependencies
2. Asks user which license to use (MIT, Apache, GPL, BSD)
3. Generates LICENSE file with correct copyright year and name
4. Adds license badge to README if it exists
5. Updates package.json/setup.py with license field

**Bonus features:**
- Detect if project is open source or proprietary
- Suggest appropriate license based on dependencies
- Check for license compatibility

### Validation Checklist

Your skill should:
- [ ] Have proper YAML frontmatter
- [ ] Include clear workflow steps
- [ ] Use bash commands Claude can execute
- [ ] Handle errors gracefully
- [ ] Ask clear questions
- [ ] Generate correct output
- [ ] Provide user confirmation
- [ ] Include examples
- [ ] Document best practices

### Share Your Work

When ready, consider:
1. Publishing to GitHub
2. Creating your own marketplace
3. Contributing to RHDP marketplace
4. Sharing with community

---

## Resources

### Official Claude Code Documentation

**Core Concepts:**
- 📖 [Skills Overview](https://code.claude.com/docs/en/skills) - What skills are and how they work
- 🔧 [Plugin System](https://code.claude.com/docs/en/plugins) - Plugin architecture and installation
- 🏛️ [Agent Skills Standard](https://agentskills.io) - Open standard specification
- 💬 [MCP Integration](https://code.claude.com/docs/en/mcp) - Model Context Protocol for advanced features

**Advanced Topics:**
- 🎯 [Skill Frontmatter](https://code.claude.com/docs/en/skills/frontmatter) - Metadata options
- 🔄 [Context Management](https://code.claude.com/docs/en/skills/context) - Fork vs inherit
- 🤖 [Model Selection](https://code.claude.com/docs/en/skills/models) - Choosing sonnet/opus/haiku

### RHDP Marketplace

**Example Plugins:**
- [Showroom Plugin](https://github.com/rhpds/rhdp-skills-marketplace/tree/main/showroom) - Workshop/demo creation (4 skills)
- [AgnosticV Plugin](https://github.com/rhpds/rhdp-skills-marketplace/tree/main/agnosticv) - Infrastructure automation (2 skills)
- [Health Plugin](https://github.com/rhpds/rhdp-skills-marketplace/tree/main/health) - Deployment validation (1 skill)

**Documentation:**
- [RHDP Skills Docs](https://rhpds.github.io/rhdp-skills-marketplace) - Complete documentation site
- [Setup Guides](https://rhpds.github.io/rhdp-skills-marketplace/setup/) - Installation and configuration
- [Migration Guide](https://rhpds.github.io/rhdp-skills-marketplace/setup/migration.html) - From file-based to plugins

### Community

**Get Help:**
- GitHub Issues: [rhdp-skills-marketplace/issues](https://github.com/rhpds/rhdp-skills-marketplace/issues)
- Slack: [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX)

**Contribute:**
- See [CODEOWNERS](https://github.com/rhpds/rhdp-skills-marketplace/blob/main/.github/CODEOWNERS) for plugin ownership
- All contributions require code owner approval
- Submit PRs to add new skills or improve existing ones

---

## Summary

You've learned:
- ✅ Skill and plugin architecture
- ✅ How to analyze existing RHDP skills
- ✅ **How to use Claude to create skills** (not write them by hand!)
- ✅ Effective prompting patterns for skill creation
- ✅ Packaging skills into plugins
- ✅ Testing and validation
- ✅ Publishing to marketplace
- ✅ Advanced features (templates, prompts, agents)

## The Claude-Assisted Workflow

**Remember: You don't write skills by hand!**

1. **Start with your existing work**
   - Documentation, runbooks, scripts, workflows

2. **Ask Claude to help**
   - "Convert this documentation into a skill"
   - "Create a skill that automates [task]"
   - "Based on RHDP patterns, generate a skill for [use case]"

3. **Review and iterate**
   - Test the generated skill
   - Ask Claude to fix issues
   - Request improvements

4. **Package and share**
   - Claude can help create plugin.json
   - Claude can write README and documentation

**Example conversation:**

```
User: I have this shell script that deploys applications. Can you turn it into a skill?

Claude: [Reads script, creates SKILL.md with proper workflow steps]

User: Great! Can you add validation steps before deployment?

Claude: [Updates skill with pre-deployment checks]

User: Perfect. Now create the plugin.json for this.

Claude: [Creates plugin metadata]
```

**Next steps:**
1. Find a workflow you want to automate
2. Ask Claude to help create a skill
3. Test and iterate with Claude's help
4. Package and share with your team

Happy skill building with Claude! 🚀
