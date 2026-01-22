# Cursor Rules for RHDP Skills

Reuse Claude Code skills in **Cursor IDE stable version** via `.cursorrules` files.

This is the recommended approach for **Cursor Enterprise** users who cannot access the Nightly channel.

---

## How It Works

Instead of Agent Skills (Nightly-only), we use Cursor's `.cursorrules` files to tell the AI to read and follow the skill instructions from `~/.cursor/skills/`.

**Flow:**
1. Skills are installed to `~/.cursor/skills/` (same as Claude Code)
2. `.cursorrules` file tells Cursor AI to read those skills
3. When user asks to "create a lab", Cursor reads `~/.cursor/skills/create-lab/SKILL.md`
4. Cursor follows the skill instructions step-by-step

**Advantages:**
- ✅ Works in Cursor stable (Enterprise compatible)
- ✅ Reuses exact same skills as Claude Code
- ✅ No duplication - single source of truth
- ✅ Easy to update (just git pull)

---

## Installation

### Step 1: Install Skills to Cursor

```bash
cd ~/work/code/rhdp-skills-marketplace
bash install.sh --platform cursor --namespace all
```

This installs skills to:
- `~/.cursor/skills/` - skill files
- `~/.cursor/docs/` - common rules

### Step 2: Copy .cursorrules to Your Project

Choose the namespace you need:

**For content creators (Showroom):**
```bash
cd ~/my-workshop-project
cp ~/work/code/rhdp-skills-marketplace/cursor-rules/.cursorrules.showroom .cursorrules
```

**For RHDP catalog creators (AgnosticV):**
```bash
cd ~/work/code/agnosticv
cp ~/work/code/rhdp-skills-marketplace/cursor-rules/.cursorrules.agnosticv .cursorrules
```

**For both (All namespaces):**
```bash
# Combine both rules
cd ~/my-project
cat ~/work/code/rhdp-skills-marketplace/cursor-rules/.cursorrules.showroom > .cursorrules
echo "" >> .cursorrules
cat ~/work/code/rhdp-skills-marketplace/cursor-rules/.cursorrules.agnosticv >> .cursorrules
```

### Step 3: Restart Cursor

Close and reopen Cursor in the project directory.

---

## Usage

With `.cursorrules` in your project, simply ask Cursor naturally:

**Instead of typing `/create-lab`, just ask:**

```
"I need to create a workshop lab about CI/CD with OpenShift Pipelines"
```

Cursor will:
1. Read `~/.cursor/skills/create-lab/SKILL.md`
2. Follow the workflow defined there
3. Ask you questions and guide you through creation

**Other examples:**

```
"Create a demo about OpenShift AI"
"Validate my workshop content"
"Generate a blog post from this lab"
"Create an AgnosticV catalog for this workshop"
```

---

## Available Skills

### Showroom (.cursorrules.showroom)

Skills for Red Hat Showroom content creation:

- **create-lab** - Workshop lab modules
- **create-demo** - Presenter-led demos
- **verify-content** - Quality validation
- **blog-generate** - Blog post generation

### AgnosticV (.cursorrules.agnosticv)

Skills for RHDP catalog provisioning:

- **agv-generator** - Create catalog items
- **agv-validator** - Validate configurations
- **generate-agv-description** - Generate descriptions

---

## Project-Specific vs Global

### Project-Specific (Recommended)

Each project has its own `.cursorrules`:

```
~/my-workshop/.cursorrules           # Showroom skills
~/work/code/agnosticv/.cursorrules   # AgnosticV skills
~/my-blog-project/.cursorrules       # Showroom skills
```

**Advantages:**
- Different projects can use different skill sets
- Team members get same skills when they clone the repo
- Version controlled with the project

### Global (Alternative)

Create a global `.cursorrules` in your home directory:

```bash
cp ~/work/code/rhdp-skills-marketplace/cursor-rules/.cursorrules.showroom ~/.cursorrules
```

**Note:** Project-level `.cursorrules` override global ones.

---

## Verification

Check installation:

```bash
# Verify skills are installed
ls -la ~/.cursor/skills/
# Should show: create-lab, create-demo, verify-content, etc.

# Verify docs are installed
ls -la ~/.cursor/docs/
# Should show: SKILL-COMMON-RULES.md, AGV-COMMON-RULES.md, etc.

# Verify .cursorrules in your project
cat .cursorrules
# Should show rules telling Cursor to read skills
```

Test in Cursor:
1. Open Cursor in a project with `.cursorrules`
2. Ask: "Create a workshop lab about Kubernetes"
3. Cursor should read the skill and start asking questions

---

## Updating

When skills are updated in the repository:

```bash
cd ~/work/code/rhdp-skills-marketplace
git pull origin main

# Reinstall skills
bash install.sh --platform cursor --namespace all

# .cursorrules files don't need updating
# (they just reference the skills, which are now updated)
```

---

## Troubleshooting

### Cursor doesn't follow the skill workflow

**Check:**
1. Is `.cursorrules` in the project root? `ls -la .cursorrules`
2. Did you restart Cursor after adding `.cursorrules`?
3. Are skills installed? `ls ~/.cursor/skills/`

**Fix:**
- Ensure `.cursorrules` points to correct paths
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

For Cursor stable, you MUST use the `.cursorrules` approach.

For Cursor Nightly, Agent Skills work natively (no `.cursorrules` needed).

---

## Comparison: Methods

| Method | Cursor Version | Setup | Best For |
|--------|---------------|-------|----------|
| **Agent Skills** | Nightly only | Install to `~/.cursor/skills/` | Cursor Nightly users |
| **.cursorrules (this)** | Stable ✅ | Install skills + copy `.cursorrules` | **Cursor Enterprise** |
| **Cursor Commands** | Stable | Copy to `~/.cursor/commands/` | Simple prompts only |

**Recommendation:** Use `.cursorrules` method (this approach) for Cursor stable/Enterprise.

---

## Example .cursorrules Files

### Showroom Only

```
# RHDP Showroom Content Creation

When user asks to create workshop lab content:
Read and follow: `~/.cursor/skills/create-lab/SKILL.md`

When user asks to create demo content:
Read and follow: `~/.cursor/skills/create-demo/SKILL.md`

Apply standards from: `~/.cursor/docs/SKILL-COMMON-RULES.md`
```

### AgnosticV Only

```
# RHDP AgnosticV Catalog Creation

When user asks to create AgnosticV catalog:
Read and follow: `~/.cursor/skills/agv-generator/SKILL.md`

Apply standards from: `~/.cursor/docs/AGV-COMMON-RULES.md`
```

---

## Support

- **Repository:** https://github.com/rhpds/rhdp-skills-marketplace
- **Issues:** https://github.com/rhpds/rhdp-skills-marketplace/issues
- **Slack:** #forum-rhdp or #forum-rhdp-content

---

**Version:** v1.0.0
**Last Updated:** 2026-01-22
**For:** Cursor IDE stable version (Enterprise compatible)
**Method:** Reuse Claude Code skills via .cursorrules
