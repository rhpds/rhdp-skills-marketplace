---
layout: default
title: Cursor Setup
---

# Cursor Setup

> **✅ Cursor 2.4+ Supported**
>
> Cursor 2.4+ supports the [Agent Skills open standard](https://agentskills.io). RHDP skills work natively in Cursor using npx skills.

---

## Prerequisites

**Cursor Version:** 2.4 or later

Check your version:
1. Open Cursor
2. Click **Cursor** menu → **About Cursor**
3. Version should be **2.4.0** or higher

If you're on an older version, update Cursor first.

---

## Installation

### Install All Skills (Interactive)

```bash
npx skills add rhpds/rhdp-skills-marketplace
```

The interactive prompt will show all available skills:
- **showroom-create-lab** - Generate workshop lab modules
- **showroom-create-demo** - Create presenter-led demos
- **showroom-blog-generate** - Transform to blog posts
- **showroom-verify-content** - Quality validation
- **agnosticv-catalog-builder** - Create/update catalogs
- **agnosticv-validator** - Validate configurations
- **health-deployment-validator** - Create validation roles

Select which skills to install.

### Install Specific Skills

```bash
# Workshop and demo creation
npx skills add rhpds/rhdp-skills-marketplace/skills/showroom-create-lab
npx skills add rhpds/rhdp-skills-marketplace/skills/showroom-create-demo

# AgnosticV catalog work (RHDP internal)
npx skills add rhpds/rhdp-skills-marketplace/skills/agnosticv-catalog-builder
npx skills add rhpds/rhdp-skills-marketplace/skills/agnosticv-validator

# Deployment validation (RHDP internal)
npx skills add rhpds/rhdp-skills-marketplace/skills/health-deployment-validator
```

Skills are installed to:
- `~/.cursor/skills/`

**Restart Cursor** after installation to load the new skills.

---

## Usage

### Explicit Invocation

Type `/skill-name` in Cursor Agent chat:

```
/showroom:create-lab
/showroom:create-demo
/agnosticv:catalog-builder
```

### Natural Language

The agent will apply relevant skills automatically:

```
Help me create a workshop lab
Generate demo content for my presentation
Create an AgnosticV catalog
```

---

## Verification

After installation and restart, verify skills are loaded:

1. Open Cursor Agent chat (Cmd+L or Ctrl+L)
2. Type `/` to see available skills
3. You should see RHDP skills listed with their namespaces

---

## Updating Skills

```bash
# Update all skills
npx skills update

# Or remove and reinstall
npx skills remove rhpds/rhdp-skills-marketplace
npx skills add rhpds/rhdp-skills-marketplace
```

---

## Troubleshooting

### Skills Not Showing After Installation

1. **Restart Cursor completely** (quit and reopen)
2. Verify installation: `ls ~/.cursor/skills/`
3. Check Cursor version is 2.4.0+

### Permission Denied

Make sure you have write permissions:
```bash
ls -la ~/.cursor/
```

### Skills Not Working

1. Check Cursor version (must be 2.4+)
2. Verify skills are in `~/.cursor/skills/`
3. Restart Cursor
4. Try explicit invocation with `/skill-name`

---

## Additional Resources

- [Vercel Skills CLI](https://github.com/vercel-labs/skills)
- [Agent Skills Standard](https://agentskills.io)
- [RHDP Skills Documentation](https://rhpds.github.io/rhdp-skills-marketplace)
