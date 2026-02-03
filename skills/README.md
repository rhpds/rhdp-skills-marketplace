# RHDP Skills Directory

This directory contains Agent Skills in a flat structure for installation via `npx skills`.

## Structure

Each skill is a subdirectory containing a `SKILL.md` file:

```
skills/
├── showroom-create-lab/
│   └── SKILL.md (symlink)
├── showroom-create-demo/
│   └── SKILL.md (symlink)
├── agnosticv-catalog-builder/
│   └── SKILL.md (symlink)
└── ...
```

## Installation Methods

### Cursor / npx skills

Install all skills interactively:
```bash
npx skills add rhpds/rhdp-skills-marketplace
```

Install specific skill:
```bash
npx skills add rhpds/rhdp-skills-marketplace/skills/showroom-create-lab
```

### Claude Code / Plugin Marketplace

Use the plugin marketplace:
```bash
/plugin marketplace add rhpds/rhdp-skills-marketplace
/plugin install showroom@rhdp-marketplace
```

## Why Symlinks?

The SKILL.md files are symlinks to the canonical versions in plugin directories (e.g., `showroom/skills/create-lab/SKILL.md`). This ensures:
- Single source of truth
- No duplicate maintenance
- Changes propagate automatically

## Available Skills

**Showroom (4 skills)** - Workshop and demo creation:
- `showroom-create-lab` - Generate workshop modules
- `showroom-create-demo` - Create presenter-led demos
- `showroom-blog-generate` - Transform to blog posts
- `showroom-verify-content` - Quality validation

**AgnosticV (2 skills)** - Catalog automation:
- `agnosticv-catalog-builder` - Create/update catalogs
- `agnosticv-validator` - Validate configurations

**Health (1 skill)** - Deployment validation:
- `health-deployment-validator` - Create Ansible validation roles

## Documentation

- **Homepage:** https://rhpds.github.io/rhdp-skills-marketplace
- **Cursor Setup:** https://rhpds.github.io/rhdp-skills-marketplace/setup/cursor.html
- **Claude Code Setup:** https://rhpds.github.io/rhdp-skills-marketplace/setup/claude-code.html
