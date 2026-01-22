# Cursor Rules for RHDP Skills

**⚠️ Experimental Support**: Agent Skills in Cursor are not fully supported yet. For now, we're using the `.cursor/rules/` approach to reuse Claude Code skills. **Claude Code is the recommended platform.**

Reuse Claude Code skills in **Cursor IDE stable version** via `.cursor/rules/` directory.

This approach works for **Cursor Enterprise** users who cannot access the Nightly channel.

---

## How It Works

Instead of Agent Skills (Nightly-only), we use Cursor's `.cursor/rules/` directory with `RULE.md` files that reference skills from `~/.cursor/skills/`.

**Flow:**
1. Skills are installed to `~/.cursor/skills/` (same as Claude Code)
2. `.cursor/rules/` directory contains RULE.md files that tell Cursor AI when and how to use skills
3. When user asks to "create a lab", Cursor reads `~/.cursor/rules/create-lab/RULE.md`
4. The RULE.md file references `~/.cursor/skills/create-lab/SKILL.md`
5. Cursor follows the skill instructions step-by-step

**Advantages:**
- ✅ Works in Cursor stable (Enterprise compatible)
- ✅ Reuses exact same skills as Claude Code
- ✅ No duplication - single source of truth
- ✅ Easy to update (just git pull)
- ✅ Supports trigger commands and global standards

---

## Installation

### Step 1: Install Skills to Cursor

```bash
cd ~/work/code/rhdp-skills-marketplace
bash install.sh --platform cursor --namespace all
```

This installs:
- `~/.cursor/skills/` - skill files (SKILL.md)
- `~/.cursor/docs/` - common rules and documentation

### Step 2: Copy .cursor/rules to Your Project

Choose the namespace you need:

**For content creators (Showroom):**
```bash
cd ~/my-workshop-project
cp -r ~/work/code/rhdp-skills-marketplace/cursor-rules/.cursor/rules .cursor/
```

**For RHDP catalog creators (AgnosticV):**
```bash
cd ~/work/code/agnosticv
cp -r ~/work/code/rhdp-skills-marketplace/cursor-rules/.cursor/rules .cursor/
```

**Note**: The `.cursor/rules/` directory includes both showroom and agnosticv skills. Cursor only activates rules when triggered by user requests.

### Step 3: Restart Cursor

Close and reopen Cursor in the project directory.

---

## Directory Structure

After installation, your project will have:

```
my-project/
├── .cursor/
│   └── rules/
│       ├── create-lab/
│       │   └── RULE.md
│       ├── create-demo/
│       │   └── RULE.md
│       ├── verify-content/
│       │   └── RULE.md
│       ├── blog-generate/
│       │   └── RULE.md
│       ├── agv-generator/
│       │   └── RULE.md
│       ├── agv-validator/
│       │   └── RULE.md
│       ├── generate-agv-description/
│       │   └── RULE.md
│       ├── validation-role-builder/
│       │   └── RULE.md
│       ├── showroom-standards/
│       │   └── RULE.md (alwaysApply: true)
│       └── agnosticv-standards/
│           └── RULE.md (alwaysApply: true)
```

---

## Usage

With `.cursor/rules/` in your project, simply ask Cursor naturally using trigger phrases.

### Showroom Skills

**Create Lab:**
```
"create lab"
"create workshop"
"generate workshop module"
```

**Create Demo:**
```
"create demo"
"generate demo"
"new demo"
```

**Verify Content:**
```
"verify content"
"validate content"
"check content quality"
```

**Generate Blog:**
```
"generate blog"
"create blog post"
"convert to blog"
```

### AgnosticV Skills

**Generate Catalog:**
```
"create agv catalog"
"generate agnosticv"
"create catalog item"
```

**Validate Catalog:**
```
"validate agv"
"validate catalog"
"check agv catalog"
```

**Generate Description:**
```
"generate agv description"
"create catalog description"
```

### Health Skills

**Create Validation Role:**
```
"create validation role"
"build validation role"
"generate health check"
```

---

## How RULE.md Files Work

Each skill has a `RULE.md` file with YAML frontmatter:

```yaml
---
description: "Workshop module generation skill"
alwaysApply: false
---

# Lab Module Generator Skill

## Trigger Commands

When user says ANY of these phrases, invoke this skill:
- "create lab"
- "create workshop"
- "generate workshop module"

## Skill Execution

**Action**: Read and follow `~/.cursor/skills/create-lab/SKILL.md` completely.
```

**Key Properties:**
- `alwaysApply: false` - Only activates when trigger commands are detected
- `alwaysApply: true` - Always applies (used for global standards)

**Global Standards:**
- `showroom-standards/RULE.md` - Always applies to Showroom content creation
- `agnosticv-standards/RULE.md` - Always applies to AgnosticV catalog work

---

## Available Skills

### Showroom (Content Creation)

| Skill | Trigger Commands | Purpose |
|-------|-----------------|---------|
| create-lab | "create lab", "create workshop" | Workshop lab modules |
| create-demo | "create demo", "generate demo" | Presenter-led demos |
| verify-content | "verify content", "validate content" | Quality validation |
| blog-generate | "generate blog", "create blog post" | Blog post generation |

### AgnosticV (RHDP Provisioning)

| Skill | Trigger Commands | Purpose |
|-------|-----------------|---------|
| agv-generator | "create agv catalog", "generate catalog" | Create catalog items |
| agv-validator | "validate agv", "validate catalog" | Validate configurations |
| generate-agv-description | "generate agv description" | Generate descriptions |

### Health (Post-Deployment Validation)

| Skill | Trigger Commands | Purpose |
|-------|-----------------|---------|
| validation-role-builder | "create validation role" | Create validation roles |

---

## Verification

Check installation:

```bash
# Verify skills are installed
ls -la ~/.cursor/skills/
# Should show: create-lab, create-demo, verify-content, agv-generator, etc.

# Verify docs are installed
ls -la ~/.cursor/docs/
# Should show: SKILL-COMMON-RULES.md, AGV-COMMON-RULES.md, etc.

# Verify .cursor/rules in your project
ls -la .cursor/rules/
# Should show: create-lab/, create-demo/, showroom-standards/, etc.

# Check a RULE.md file
cat .cursor/rules/create-lab/RULE.md
# Should show YAML frontmatter and trigger commands
```

Test in Cursor:
1. Open Cursor in a project with `.cursor/rules/`
2. Ask: "create lab about Kubernetes"
3. Cursor should read the RULE.md, then follow SKILL.md instructions

---

## Updating

When skills are updated in the repository:

```bash
cd ~/work/code/rhdp-skills-marketplace
git pull origin main

# Reinstall skills (updates ~/.cursor/skills/)
bash install.sh --platform cursor --namespace all

# Update project rules (copy new RULE.md files)
cd ~/my-project
cp -r ~/work/code/rhdp-skills-marketplace/cursor-rules/.cursor/rules .cursor/
```

---

## Troubleshooting

### Cursor doesn't follow the skill workflow

**Check:**
1. Is `.cursor/rules/` in the project root? `ls -la .cursor/rules/`
2. Did you restart Cursor after adding `.cursor/rules/`?
3. Are skills installed? `ls ~/.cursor/skills/`
4. Are RULE.md files present? `ls .cursor/rules/create-lab/`

**Fix:**
- Ensure `.cursor/rules/` directory structure is correct
- Restart Cursor completely (Cmd+Q, then reopen)
- Reinstall skills if needed

### Cursor can't find the SKILL.md files

**Check:**
```bash
ls ~/.cursor/skills/create-lab/SKILL.md
```

**Fix:**
```bash
cd ~/work/code/rhdp-skills-marketplace
bash install.sh --platform cursor --namespace all
```

### Skills work in Claude Code but not Cursor

This is expected! Claude Code has native Agent Skills support.

For Cursor stable, you MUST use the `.cursor/rules/` approach described here.

For Cursor Nightly, Agent Skills may work natively, but this is experimental.

---

## Comparison: Cursor Support Methods

| Method | Cursor Version | Setup | Reliability | Recommended |
|--------|---------------|-------|-------------|-------------|
| **Agent Skills** | Nightly only | Install to `~/.cursor/skills/` | Experimental | ❌ No |
| **.cursor/rules/** | Stable ✅ | Install skills + copy rules | Working | ✅ Yes |
| **.cursorrules** | Stable | Single file in root | Limited | ❌ No |

**Current Recommendation:** Use `.cursor/rules/` method (this approach) for Cursor stable/Enterprise.

**Long-term Recommendation:** Use **Claude Code** as the primary platform until Cursor fully supports Agent Skills.

---

## Example RULE.md File

Here's what a typical RULE.md looks like:

```yaml
---
description: "Workshop module generation skill - creates Red Hat Showroom workshop modules"
alwaysApply: false
---

# Lab Module Generator Skill

## Trigger Commands

When user says ANY of these phrases, invoke this skill:
- "create lab"
- "create workshop"
- "generate workshop module"
- "new lab"

## Skill Execution

**Action**: Read and follow `~/.cursor/skills/create-lab/SKILL.md` completely.

**OR if skills are in Claude directory**: Read and follow `~/.claude/skills/create-lab/SKILL.md` completely.

## What This Skill Does

Creates Red Hat Showroom workshop lab modules with:
- AsciiDoc formatted content
- Know/Do/Check structure
- Module-based organization
- Red Hat branding standards

## Documentation

Refer to: `~/.cursor/docs/SKILL-COMMON-RULES.md` for Red Hat Showroom standards.
```

---

## Global Standards (alwaysApply: true)

Two special rules always apply when working in Cursor:

### showroom-standards/RULE.md

Enforces:
- Sequential questioning (ask one question at a time)
- Token management (don't dump content in chat)
- AsciiDoc standards
- Know/Do/Check structure

### agnosticv-standards/RULE.md

Enforces:
- UUID validation (RFC 4122, uniqueness)
- Category exactness (Workshops, Demos, Sandboxes only)
- YAML standards
- Workload dependencies

These run automatically for all Showroom and AgnosticV work.

---

## Support

- **Repository:** https://github.com/rhpds/rhdp-skills-marketplace
- **Issues:** https://github.com/rhpds/rhdp-skills-marketplace/issues
- **Slack:** #forum-rhdp or #forum-rhdp-content

---

**Version:** v1.0.0
**Last Updated:** 2026-01-22
**For:** Cursor IDE stable version (Enterprise compatible)
**Method:** Reuse Claude Code skills via .cursor/rules/
**Status:** Experimental workaround until Cursor fully supports Agent Skills
**Recommended Platform:** **Claude Code**
