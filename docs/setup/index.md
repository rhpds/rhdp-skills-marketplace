---
layout: default
title: Setup Guide
---

# Setup Guide

Complete guide for installing and configuring RHDP Skills Marketplace.

---

## Plugin-Based Installation (Recommended)

### Quick Install

```bash
# Add marketplace
/plugin marketplace add https://github.com/rhpds/rhdp-skills-marketplace

# Install plugins
/plugin install showroom@rhdp-marketplace
/plugin install agnosticv@rhdp-marketplace  # RHDP internal only
/plugin install health@rhdp-marketplace     # RHDP internal only
```

**Restart Claude Code** after installation.

[Complete plugin installation guide →](claude-code.html)

---

## Understanding Plugin Scopes

Plugins can be installed at different scopes, affecting where they're available and how they're managed.

### User-Scoped Plugins (Default)

**What it is:** Plugins installed globally for your user account, available in all Claude Code sessions across all projects.

**Installation:**
```bash
/plugin install showroom@rhdp-marketplace
```

**Storage location:**
```
~/.claude/plugins/
├── cache/
│   └── rhdp-marketplace/
│       └── showroom/
│           └── 1.0.0/
│               ├── .claude-plugin/
│               │   └── plugin.json
│               └── skills/
│                   ├── create-lab/
│                   │   └── SKILL.md
│                   ├── create-demo/
│                   │   └── SKILL.md
│                   ├── blog-generate/
│                   │   └── SKILL.md
│                   └── verify-content/
│                       └── SKILL.md
├── marketplaces/
│   └── rhdp-marketplace/
│       └── (cloned marketplace repository)
└── installed_plugins.json  # Registry of installed plugins
```

**Benefits:**
- ✅ Available everywhere
- ✅ Install once, use in all projects
- ✅ Easy personal workflow
- ✅ Automatic updates with `/plugin update`

**Best for:**
- Personal use
- Individual developers
- Skills you use frequently across projects

### Project-Scoped Plugins

**What it is:** Plugins configured for a specific project, shared with your team through `.claude/settings.json`.

**Setup:**

1. Create `.claude/settings.json` in your project root:

```json
{
  "extraKnownMarketplaces": {
    "rhdp-marketplace": {
      "source": {
        "source": "github",
        "repo": "rhpds/rhdp-skills-marketplace"
      }
    }
  },
  "enabledPlugins": {
    "showroom@rhdp-marketplace": true,
    "agnosticv@rhdp-marketplace": true
  }
}
```

2. Commit to Git:

```bash
git add .claude/settings.json
git commit -m "Add RHDP skills marketplace configuration"
git push
```

3. Team members will be prompted to install when they open the project.

**Storage location:**

Plugins are still installed in the user's home directory, but the configuration is in the project:

```
your-project/
└── .claude/
    └── settings.json  # Version controlled, shared with team

~/.claude/plugins/
└── cache/
    └── rhdp-marketplace/
        └── showroom/1.0.0/...  # Actual plugin files
```

**How it works:**
- Configuration file (`.claude/settings.json`) lives in your project → shared via Git
- Plugin files themselves are cached in `~/.claude/plugins/` → not committed to Git
- When team members open the project, Claude Code sees the config and prompts to install
- Everyone gets the same plugins, but files are stored locally

**Benefits:**
- ✅ Team shares same plugin versions
- ✅ Consistent development environment
- ✅ Version controlled configuration
- ✅ Auto-suggested on project open
- ✅ No large plugin files in Git repository

**Best for:**
- Team projects
- Standardized workflows
- Ensuring everyone has same tools

### Comparison

| Feature | User-Scoped | Project-Scoped |
|---------|-------------|----------------|
| **Availability** | All projects | Specific project only |
| **Installation** | `/plugin install` | `.claude/settings.json` |
| **Sharing** | Manual | Automatic via Git |
| **Updates** | Manual per user | Coordinated by team |
| **Configuration** | `~/.claude/settings.json` | `.claude/settings.json` |

---

## Where Are Skills Stored?

Understanding where plugins and skills are stored helps with troubleshooting and managing your installation.

### Complete Directory Structure

```
~/.claude/
├── plugins/
│   ├── cache/                           # Installed plugin files
│   │   └── rhdp-marketplace/
│   │       ├── agnosticv/
│   │       │   └── 2.2.0/
│   │       │       ├── .claude-plugin/
│   │       │       │   └── plugin.json
│   │       │       └── skills/
│   │       │           ├── catalog-builder/
│   │       │           │   └── SKILL.md
│   │       │           └── validator/
│   │       │               └── SKILL.md
│   │       ├── showroom/
│   │       │   └── 1.0.0/
│   │       │       └── skills/
│   │       │           ├── create-lab/SKILL.md
│   │       │           ├── create-demo/SKILL.md
│   │       │           ├── blog-generate/SKILL.md
│   │       │           └── verify-content/SKILL.md
│   │       └── health/
│   │           └── 1.0.0/
│   │               └── skills/
│   │                   └── deployment-validator/SKILL.md
│   │
│   ├── marketplaces/                    # Cloned marketplace repositories
│   │   └── rhdp-marketplace/
│   │       ├── .claude-plugin/
│   │       │   └── marketplace.json
│   │       ├── agnosticv/
│   │       ├── showroom/
│   │       └── health/
│   │
│   ├── installed_plugins.json           # Registry of installed plugins
│   └── known_marketplaces.json          # Registry of added marketplaces
│
├── settings.json                        # User-level configuration
└── projects/                            # Per-project metadata
```

### Key Directories Explained

| Directory | Purpose | Version Controlled? |
|-----------|---------|---------------------|
| `~/.claude/plugins/cache/` | Installed plugin files (actual skills) | No - user local |
| `~/.claude/plugins/marketplaces/` | Cloned marketplace repositories | No - user local |
| `~/.claude/plugins/installed_plugins.json` | Registry of what's installed | No - user local |
| `~/.claude/settings.json` | User-level plugin configuration | No - user local |
| `your-project/.claude/settings.json` | Project-level plugin config | Yes - team shared |

### File-Based Installation (Old)

For comparison, the old file-based installation looked like this:

```
~/.claude/
├── skills/                              # Old location
│   ├── create-lab/
│   │   └── SKILL.md
│   ├── create-demo/
│   │   └── SKILL.md
│   └── agnosticv-catalog-builder/
│       └── SKILL.md
└── docs/                                # Old documentation
    └── ...
```

**Key differences:**
- Old: Skills directly in `~/.claude/skills/`
- New: Skills in `~/.claude/plugins/cache/marketplace-name/plugin-name/version/`
- Old: No version management
- New: Versioned (can have multiple versions installed)
- Old: Manual updates
- New: Automatic updates with `/plugin update`

---

## Migration from File-Based Installation

If you previously used the old `install.sh` script that copied files to `~/.claude/skills/`, you should migrate to the plugin-based system.

[Complete migration guide →](migration.html)

**Quick migration:**

```bash
# Remove old file-based installation
rm -rf ~/.claude/skills/create-lab
rm -rf ~/.claude/skills/create-demo
rm -rf ~/.claude/skills/agnosticv-catalog-builder
rm -rf ~/.claude/docs

# Install plugin-based
/plugin marketplace add https://github.com/rhpds/rhdp-skills-marketplace
/plugin install showroom@rhdp-marketplace
/plugin install agnosticv@rhdp-marketplace

# Restart Claude Code
```

---

## Choose Your Platform

<div class="grid">
  <div class="card">
    <h3>🎯 Claude Code (Recommended)</h3>
    <p>Native plugin and Agent Skills support</p>
    <a href="claude-code.html">Claude Code Setup →</a>
  </div>

  <div class="card">
    <h3>💻 VS Code with Claude</h3>
    <p>Native plugin and Agent Skills support</p>
    <a href="claude-code.html">Same as Claude Code →</a>
  </div>

  <div class="card">
    <h3>✨ Cursor 2.4+</h3>
    <p>Agent Skills standard support</p>
    <a href="cursor.html">Cursor Setup →</a>
  </div>
</div>

---

## Choose Your Plugins

### 🎓 Showroom (Content Creation)

For workshop and demo creators.

**Plugin:** `showroom@rhdp-marketplace`

**Skills:**
- `/showroom:create-lab` - Create workshop lab modules
- `/showroom:create-demo` - Create presenter-led demos
- `/showroom:verify-content` - Quality validation
- `/showroom:blog-generate` - Transform to blog posts

[Showroom Guide →](showroom.html)

### ⚙️ AgnosticV (RHDP Provisioning)

For RHDP catalog creators.

**Plugin:** `agnosticv@rhdp-marketplace`

**Skills:**
- `/agnosticv:catalog-builder` - Create/update catalogs & Virtual CIs
- `/agnosticv:validator` - Validate configurations

**Prerequisites:** RHDP access, AgnosticV repo at `~/work/code/agnosticv`

[AgnosticV Guide →](agnosticv.html)

### 🏥 Health (Post-Deployment)

For RHDP validation roles.

**Plugin:** `health@rhdp-marketplace`

**Skills:**
- `/health:deployment-validator` - Create validation roles

---

## Verify Installation

Check installed plugins:

```bash
/plugin list
```

Check available skills:

```bash
/skills
```

You should see skills with namespace prefixes like:
- `/showroom:create-lab`
- `/agnosticv:catalog-builder`
- `/health:deployment-validator`

---

## Update Plugins

Keep your plugins current:

```bash
# Step 1: Update marketplace catalog
/plugin marketplace update
# Interactive UI: select marketplace and press 'u' to update

# Step 2: Update plugins
/plugin update showroom@rhdp-marketplace
# Interactive UI: navigate to "Update now" and press Enter

# Repeat for other plugins
/plugin update agnosticv@rhdp-marketplace
/plugin update health@rhdp-marketplace
```

**Note:** Both commands are interactive:
- Marketplace update: Select marketplace, press `u`
- Plugin update: Navigate to "Update now", press `Enter`

**Restart Claude Code** after updates to load new versions.

---

## Advanced Configuration

### Private Marketplace (Enterprise)

For organizations hosting private marketplaces:

```bash
/plugin marketplace add https://github.com/your-org/private-marketplace
```

### Multiple Marketplaces

You can add multiple marketplaces:

```bash
/plugin marketplace add https://github.com/rhpds/rhdp-skills-marketplace
/plugin marketplace add https://github.com/your-team/custom-skills
```

### Plugin Settings

Configure plugin behavior in `.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "showroom@rhdp-marketplace": true,
    "agnosticv@rhdp-marketplace": false  // Disable specific plugin
  }
}
```

---

## Need Help?

- [Troubleshooting Guide](../reference/troubleshooting.html)
- [Migration Guide](migration.html)
- [GitHub Issues](https://github.com/rhpds/rhdp-skills-marketplace/issues)
- Slack: [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX)

---

[← Back to Home](../)
