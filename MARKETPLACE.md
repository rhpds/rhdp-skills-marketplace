# RHDP Skills Marketplace

Official Red Hat Demo Platform (RHDP) Claude Code marketplace for creating workshops, demos, and infrastructure automation.

## Installation

### Add the Marketplace

```bash
/plugin marketplace add rhpds/rhdp-skills-marketplace
```

This adds the RHDP marketplace to your Claude Code installation. You only need to do this once.

### Install Plugins

Once the marketplace is added, install the plugins you need:

```bash
# AgnosticV plugins
/plugin install agnosticv-catalog-builder@rhdp-marketplace
/plugin install agnosticv-validator@rhdp-marketplace

# Showroom plugins
/plugin install showroom-create-lab@rhdp-marketplace
/plugin install showroom-create-demo@rhdp-marketplace
/plugin install showroom-blog-generate@rhdp-marketplace
/plugin install showroom-verify-content@rhdp-marketplace

# Health/Validation plugins
/plugin install health-deployment-validator@rhdp-marketplace
```

### Update Plugins

When new versions are released:

```bash
/plugin marketplace update
```

This updates all installed plugins to their latest versions.

---

## Available Plugins

### AgnosticV Namespace

**agnosticv-catalog-builder** (v2.1.0)
- Create or update AgnosticV catalog files
- Generates: common.yaml, dev.yaml, description.adoc, info-message-template.adoc
- Auto-detects configuration from CLAUDE.md
- Optional git workflow assistance
- Tags: `agnosticv`, `catalog`, `infrastructure`, `workshop`, `demo`

**agnosticv-validator** (v1.0.0)
- Validate AgnosticV catalog configurations
- Best practices checks
- Deployment requirement validation
- Tags: `agnosticv`, `validation`, `catalog`

### Showroom Namespace

**showroom-create-lab** (v1.0.0)
- Create Red Hat Showroom workshop modules
- Business storytelling framework
- Proper AsciiDoc formatting
- Reference materials integration
- Tags: `showroom`, `workshop`, `lab`, `asciidoc`, `content-creation`

**showroom-create-demo** (v1.0.0)
- Create Red Hat Showroom demo modules
- Know/Show structure for presenters
- Presenter-led demonstration flow
- Tags: `showroom`, `demo`, `presentation`, `asciidoc`, `content-creation`

**showroom-blog-generate** (v1.0.0)
- Transform Showroom content into blog posts
- Red Hat Developer blog format
- Marketing platform integration
- Tags: `showroom`, `blog`, `content`, `marketing`

**showroom-verify-content** (v1.0.0)
- Comprehensive quality verification
- Red Hat standards validation
- Multi-agent verification system
- Tags: `showroom`, `validation`, `quality`, `content`

### Health Namespace

**health-deployment-validator** (v1.0.0)
- Create deployment health check validation roles
- Post-deployment validation
- Ansible-based health checks
- Tags: `ansible`, `validation`, `health-check`, `deployment`

---

## Usage Examples

### Create a Workshop

```bash
# Install the lab creation plugin
/plugin install showroom-create-lab@rhdp-marketplace

# Use the skill
/showroom-create-lab
```

### Build an AgnosticV Catalog

```bash
# Install catalog builder
/plugin install agnosticv-catalog-builder@rhdp-marketplace

# Use the skill
/agnosticv-catalog-builder
```

### Verify Workshop Content

```bash
# Install content verification
/plugin install showroom-verify-content@rhdp-marketplace

# Use the skill
/showroom-verify-content
```

---

## Plugin vs. Old File-Based Installation

### Old Way (Manual)
```bash
# Copy files manually
cp -r ~/work/code/rhdp-skills-marketplace/agnosticv/skills/agnosticv-catalog-builder ~/.claude/skills/

# Check for updates manually
# Re-copy files when updates available
```

### New Way (Marketplace)
```bash
# Install once
/plugin install agnosticv-catalog-builder@rhdp-marketplace

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
