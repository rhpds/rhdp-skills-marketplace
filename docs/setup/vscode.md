---
layout: default
title: VS Code Setup
---

# VS Code with Claude Extension Setup

> **✅ VS Code with Claude Extension Supported**
>
> VS Code supports the [Agent Skills open standard](https://agentskills.io) through the Claude extension. Installation is identical to Claude Code.

---

## Prerequisites

**Requirements:**
- VS Code installed
- Claude extension for VS Code installed

**Install Claude Extension:**
1. Open VS Code
2. Go to Extensions (Cmd+Shift+X or Ctrl+Shift+X)
3. Search for "Claude"
4. Install the official Claude extension by Anthropic

---

## Installation

VS Code with Claude extension uses the **same plugin marketplace** as Claude Code.

### Add the RHDP Marketplace

```bash
/plugin marketplace add rhpds/rhdp-skills-marketplace
```

Or if you don't have SSH keys configured:

```bash
/plugin marketplace add https://github.com/rhpds/rhdp-skills-marketplace
```

### Install Plugins

Install the plugins you need:

```bash
# For workshop/demo creation
/plugin install showroom@rhdp-marketplace

# For AgnosticV catalogs (RHDP internal)
/plugin install agnosticv@rhdp-marketplace

# For deployment health checks (RHDP internal)
/plugin install health@rhdp-marketplace
```

---

## Available Plugins

**Showroom Plugin** (`showroom@rhdp-marketplace`):
- `/showroom:create-lab` - Generate workshop lab modules
- `/showroom:create-demo` - Generate presenter-led demo content
- `/showroom:verify-content` - AI-powered quality validation
- `/showroom:blog-generate` - Transform content into blog posts

**AgnosticV Plugin** (`agnosticv@rhdp-marketplace`):
- `/agnosticv:catalog-builder` - Create/update AgnosticV catalog items
- `/agnosticv:validator` - Validate catalog configurations

**Health Plugin** (`health@rhdp-marketplace`):
- `/health:deployment-validator` - Create Ansible validation roles

---

## Usage

Skills work exactly the same as in Claude Code:

```bash
# Create a workshop
/showroom:create-lab

# Create a demo
/showroom:create-demo

# Validate content
/showroom:verify-content

# Build catalog (RHDP internal)
/agnosticv:catalog-builder
```

---

## Updating

Check for and install updates:

```bash
/plugin marketplace update
```

The marketplace will:
- Check all installed plugins for updates
- Show changelog for available updates
- Prompt to install updates

---

## Benefits of Plugin Marketplace

- ✅ **Automatic Updates** - Get notified of new versions
- ✅ **Version Management** - Pin to specific versions, rollback if needed
- ✅ **Clean Uninstall** - Remove plugins cleanly
- ✅ **Shared Installation** - Same plugins work in Claude Code and VS Code

---

## Verification

After installation, verify skills are loaded:

1. Open Claude chat in VS Code
2. Type `/` to see available skills
3. You should see RHDP skills listed with their namespaces

---

## Troubleshooting

### Skills Not Showing

**Restart VS Code:**
- Close VS Code completely
- Reopen VS Code
- Open Claude chat and type `/`

**Check Installation:**

Skills are installed to `~/.claude/plugins/marketplaces/rhdp-marketplace/`

```bash
ls ~/.claude/plugins/marketplaces/rhdp-marketplace/
```

You should see:
- showroom/
- agnosticv/
- health/

### Permission Issues

Make sure you have write permissions:

```bash
ls -la ~/.claude/plugins/
chmod 755 ~/.claude/plugins/
```

---

## Differences from Cursor

| Feature | VS Code + Claude | Cursor |
|---------|------------------|--------|
| **Installation** | Plugin marketplace | Install script |
| **Updates** | Automatic | Manual |
| **Skill Names** | With colons (`:`) | With hyphens (`-`) |
| **Example** | `/showroom:create-lab` | `/showroom-create-lab` |

---

## Additional Resources

- [RHDP Skills Documentation](https://rhpds.github.io/rhdp-skills-marketplace)
- [Agent Skills Standard](https://agentskills.io)
- [Claude Extension for VS Code](https://marketplace.visualstudio.com/items?itemName=Anthropic.claude-vscode)
