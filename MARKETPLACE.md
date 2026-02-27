# RHDP Skills Marketplace

Official Red Hat Demo Platform (RHDP) Claude Code marketplace for creating workshops, demos, and infrastructure automation.

## Installation

### Add the Marketplace

```bash
# If you have SSH keys configured (shorter)
/plugin marketplace add rhpds/rhdp-skills-marketplace

# If you don't have SSH configured (use this)
/plugin marketplace add https://github.com/rhpds/rhdp-skills-marketplace
```

This adds the RHDP marketplace to your Claude Code installation. You only need to do this once.

### Install Plugins

Once the marketplace is added, install the plugins you need:

```bash
# AgnosticV plugin (catalog builder + validator)
/plugin install agnosticv@rhdp-marketplace

# Showroom plugin (create-lab, create-demo, blog-generate, verify-content)
/plugin install showroom@rhdp-marketplace

# Health plugin (deployment validator)
/plugin install health@rhdp-marketplace
```

### Update Plugins

When new versions are released:

```bash
/plugin marketplace update
```

This updates all installed plugins to their latest versions.

---

## Available Plugins

### AgnosticV Plugin (v2.8.1)

**Plugin:** `agnosticv@rhdp-marketplace`

**Skills:**
- `/agnosticv:catalog-builder` - Create or update AgnosticV catalog files & Virtual CIs
  - Generates: common.yaml, dev.yaml, description.adoc, info-message-template.adoc
  - Auto-detects configuration from CLAUDE.md
  - Create Virtual CIs in published/ folder
  - Optional git workflow assistance

- `/agnosticv:validator` - Validate AgnosticV catalog configurations
  - Best practices checks
  - Deployment requirement validation

**Tags:** `agnosticv`, `catalog`, `infrastructure`, `workshop`, `demo`, `validation`

---

### Showroom Plugin (v1.0.0)

**Plugin:** `showroom@rhdp-marketplace`

**Skills:**
- `/showroom:create-lab` - Create Red Hat Showroom workshop modules
  - Business storytelling framework
  - Proper AsciiDoc formatting
  - Reference materials integration

- `/showroom:create-demo` - Create Red Hat Showroom demo modules
  - Know/Show structure for presenters
  - Presenter-led demonstration flow

- `/showroom:blog-generate` - Transform Showroom content into blog posts
  - Red Hat Developer blog format
  - Marketing platform integration

- `/showroom:verify-content` - Comprehensive quality verification
  - Red Hat standards validation
  - Multi-agent verification system

**Tags:** `showroom`, `workshop`, `lab`, `demo`, `asciidoc`, `content-creation`, `validation`, `blog`

---

### Health Plugin (v2.8.1)

**Plugin:** `health@rhdp-marketplace`

**Skills:**
- `/health:deployment-validator` - Create deployment health check validation roles
  - Post-deployment validation
  - Ansible-based health checks

- `/ftl:lab-validator` - Generate lab grader and solver playbooks for Showroom workshops
  - Reads .adoc module files to auto-detect checkpoints
  - Generates per-module grader and solver playbooks
  - Follows FTL three-play pattern with full grader role catalog
  - Supports multi-user and single-user lab patterns

**Tags:** `ansible`, `validation`, `health-check`, `deployment`, `ftl`, `grading`, `testing`

---

## Usage Examples

### Create a Workshop

```bash
# Install the showroom plugin
/plugin install showroom@rhdp-marketplace

# Use the create-lab skill
/showroom:create-lab
```

### Build an AgnosticV Catalog

```bash
# Install agnosticv plugin
/plugin install agnosticv@rhdp-marketplace

# Use the catalog-builder skill
/agnosticv:catalog-builder
```

### Verify Workshop Content

```bash
# Install showroom plugin (if not already installed)
/plugin install showroom@rhdp-marketplace

# Use the verify-content skill
/showroom:verify-content
```

---

## Plugin vs. Old File-Based Installation

### Old Way (Manual)
```bash
# Copy files manually
cp -r ~/work/code/rhdp-skills-marketplace/agnosticv/skills/catalog-builder ~/.claude/skills/

# Check for updates manually
# Re-copy files when updates available
```

### New Way (Marketplace)
```bash
# Install once
/plugin install agnosticv@rhdp-marketplace

# Update automatically
/plugin marketplace update
```

**Benefits:**
- ✅ Standard installation like dnf/brew
- ✅ Automatic updates
- ✅ Version pinning and rollback
- ✅ Clear dependency management
- ✅ Consistent UX across all plugins

---

## Migration from File-Based Installation

If you previously installed skills manually to `~/.claude/skills/`:

1. **Backup your old installation**
   ```bash
   mv ~/.claude/skills ~/.claude/skills.backup
   ```

2. **Add the marketplace**
   ```bash
   /plugin marketplace add rhpds/rhdp-skills-marketplace
   ```

3. **Install plugins you need**
   ```bash
   /plugin install agnosticv-catalog-builder@rhdp-marketplace
   /plugin install showroom-create-lab@rhdp-marketplace
   # ... etc
   ```

4. **Verify skills work**
   ```bash
   /agnosticv-catalog-builder
   /create-lab
   ```

5. **Remove backup (optional)**
   ```bash
   rm -rf ~/.claude/skills.backup
   ```

---

## Configuration

Plugins will check for configuration in:
- `~/CLAUDE.md` - Global user configuration
- `~/.claude/*.md` - Claude configuration directory

Example `~/CLAUDE.md`:
```markdown
# My RHDP Configuration

AgV Repository: ~/devel/git/agnosticv
Showroom Repository: ~/work/showroom
```

Plugins like `agnosticv-catalog-builder` auto-detect these paths.

---

## Support

### Marketplace Issues
- Repository: https://github.com/rhpds/rhdp-skills-marketplace
- Issues: https://github.com/rhpds/rhdp-skills-marketplace/issues

### Content Support
- Slack: #forum-demo-developers
- Email: rhdp-dev@redhat.com

### Environment Support
- RHDP Ticket: https://red.ht/rhdp-ticket
- Slack: #forum-demo-redhat-com

---

## Development

See [CONTRIBUTING.md](CONTRIBUTING.md) for plugin development guidelines.

---

**License:** Apache-2.0
**Maintainer:** Red Hat Demo Platform Team
**Version:** 1.9.0
