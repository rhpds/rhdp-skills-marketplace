# RHDP Skills Marketplace

AI-powered skills for Red Hat Demo Platform content creation and provisioning.

Supports: **Claude Code (Recommended)** | **VS Code with Claude Extension** | **Cursor (Experimental - Still Testing)**

> **⚠️ Note:** Agent Skills work natively in **Claude Code** and **VS Code with Claude extension**. Cursor support is experimental and still being tested - skills may not work reliably in Cursor.

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Version](https://img.shields.io/badge/version-v1.3.1-green.svg)](https://github.com/rhpds/rhdp-skills-marketplace/releases)

**📚 [Full Documentation](https://rhpds.github.io/rhdp-skills-marketplace)** | [Changelog](CHANGELOG.md) | [Contributing](CONTRIBUTING.md)

---

## Quick Start

### Installation

Download and run the installer:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh -o /tmp/rhdp-install.sh
bash /tmp/rhdp-install.sh
```

The installer will:
1. Ask which platform you're using (Claude Code or Cursor)
2. Ask which namespace to install (showroom, agnosticv, or all)
3. Backup your existing skills
4. Install the selected skills

### For Content Creators (External Developers)

Install the **showroom** namespace for creating Red Hat Showroom workshop labs and demos:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh -o /tmp/rhdp-install.sh
bash /tmp/rhdp-install.sh
# When prompted:
# 1. Select your platform (Claude Code or Cursor)
# 2. Select namespace: 1 (showroom)
```

**Available Skills:**
- `/create-lab` - Generate workshop lab modules with Know/Show structure
- `/create-demo` - Generate presenter-led demo content
- `/verify-content` - AI-powered quality validation
- `/blog-generate` - Transform content into blog posts

### For RHDP Internal/Advanced Users

Install additional namespaces for AgnosticV provisioning, validation, and health checks:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh -o /tmp/rhdp-install.sh
bash /tmp/rhdp-install.sh
# When prompted:
# 1. Select your platform (Claude Code or Cursor)
# 2. Select namespace:
#    - 2 (agnosticv) - Catalog provisioning
#    - 3 (health) - Post-deployment validation
#    - 4 (all) - All namespaces
```

**AgnosticV Skills:**
- `/agnosticv-catalog-builder` - Create/update AgnosticV catalog items (unified skill with 3 modes)
- `/agnosticv-validator` - Validate catalog configurations

**Health Skills:**
- `/deployment-health-checker` - Create Ansible validation roles

---

## Namespaces

### 🎓 showroom (Public - Content Creation)

**Purpose:** Create high-quality workshop and demo content for Red Hat Showroom

**Skills:**

| Skill | Description | Use Case |
|-------|-------------|----------|
| `create-lab` | Generate workshop lab modules | Building hands-on learning content |
| `create-demo` | Generate presenter-led demos | Creating Know/Show demo modules |
| `verify-content` | Quality validation | Ensuring Red Hat standards |
| `blog-generate` | Transform to blog posts | Publishing to Red Hat Developer |

**Workflow:**
```
/create-lab → Write content → /verify-content → /blog-generate
```

**Documentation:** [showroom/README.md](showroom/README.md)

---

### ⚙️ agnosticv (RHDP Internal/Advanced - Provisioning)

**Purpose:** Manage RHDP catalog infrastructure provisioning and validation

**Skills:**

| Skill | Description | Use Case |
|-------|-------------|----------|
| `agnosticv-catalog-builder` | Create/update catalogs (unified) | Building new RHDP catalog entries |
| `agnosticv-validator` | Validate configurations | Pre-deployment quality checks |

**Workflow:**
```
/agnosticv-catalog-builder → Test in RHDP → /create-lab (with UserInfo) → Deploy
```

**Documentation:** [agnosticv/README.md](agnosticv/README.md)

---

### 🏥 health (RHDP Internal/Advanced - Validation & Testing)

**Purpose:** Post-deployment validation, health checks, and automated testing

**Skills:**

| Skill | Description | Use Case |
|-------|-------------|----------|
| `deployment-health-checker` | Create validation roles | Automated post-deploy health checks |

**Workflow:**
```
Deploy catalog → /deployment-health-checker → Health checks → Verify readiness
```

**Documentation:** [health/README.md](health/README.md)

---

### 🤖 automation (RHDP Internal/Advanced - Intelligent Automation)

**Purpose:** Workflow automation, intelligent testing, and environment discovery

**Skills:**

| Skill | Description | Use Case |
|-------|-------------|----------|
| `ftl` (future) | Finish The Labs | Automated grader/solver generation for workshop testing |
| `automation` (future) | Workflow automation | Automated RHDP operations and orchestration |
| `field-automation-builder` (future) | Field content integration | Import field-sourced content to RHDP catalog |

**Workflow:**
```
/create-lab → /ftl (generate grader/solver) → Test workshop → Deploy to RHDP
```

**Documentation:** [automation/README.md](automation/README.md)

---

## Updates

Check for and install updates:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/update.sh -o /tmp/rhdp-update.sh
bash /tmp/rhdp-update.sh
```

The updater will:
- Detect your current installation
- Check for newer versions
- Show changelog
- Prompt to update if available

---

## Usage Examples

### Creating a Workshop Lab

```bash
# In Claude Code or Cursor
/create-lab

# Answer the prompts:
# - Lab name: "CI/CD with OpenShift Pipelines"
# - Abstract: "Learn cloud-native CI/CD with Tekton"
# - Technologies: Tekton, OpenShift, Pipelines
# - Module count: 3

# Skill generates:
# ├── content/modules/ROOT/
# │   ├── pages/
# │   │   ├── index.adoc
# │   │   ├── module-01.adoc
# │   │   ├── module-02.adoc
# │   │   └── module-03.adoc
# │   └── partials/
# │       └── _attributes.adoc
```

### Creating an AgnosticV Catalog

```bash
# In Claude Code or Cursor
/agnosticv-catalog-builder

# Choose mode: 1 (Full Catalog)
# Git workflow runs automatically (pull main, create branch)
# Answer the prompts:
# - Catalog name: "Agentic AI on OpenShift"
# - Infrastructure: CNV multi-node
# - Multi-user: Yes
# - Workloads: OpenShift AI, LiteLLM, Showroom

# Skill generates and auto-commits:
# ~/work/code/agnosticv/agd_v2/agentic-ai-openshift/
# ├── common.yaml
# ├── description.adoc
# ├── dev.yaml
# └── info-message-template.adoc
```

### Validating a Catalog

```bash
# In Claude Code or Cursor
/agnosticv-validator

# Skill checks:
# ✓ UUID format and uniqueness
# ✓ YAML syntax
# ✓ Workload dependencies
# ✓ Infrastructure recommendations
# ⚠️ Best practice suggestions
```

---

## Platform Support

### Claude Code (Recommended)

Skills are installed to:
- Skills: `~/.claude/skills/`
- Docs: `~/.claude/docs/`

**Native Agent Skills support** - skills work out of the box with `/skill-name` commands.

### VS Code with Claude Extension

Skills are installed to:
- Skills: `~/.claude/skills/`
- Docs: `~/.claude/docs/`

**Native Agent Skills support** - same installation as Claude Code, skills work with `/skill-name` commands in VS Code.

### Cursor (Experimental - Still Testing)

**⚠️ Experimental:** Agent Skills in Cursor are not fully supported yet. The Cursor team stated it's "not ready for primetime" ([source](https://forum.cursor.com/t/support-for-claude-skills/148267)).

**Current approach for Cursor:**

We're testing a workaround using `.cursor/rules/` directory:

1. Install skills: `bash install.sh --platform cursor --namespace all`
2. Rules automatically installed to `.cursor/rules/` in current directory
3. Use trigger phrases like "create lab" or "validate agv"

**Status:**
- **Still testing** - may not work reliably
- Uses `.cursor/rules/RULE.md` files to reference skills from `~/.cursor/skills/`
- Experimental workaround until Cursor fully supports Agent Skills
- See: [cursor-rules/README.md](cursor-rules/README.md)

**Recommendation:** Use Claude Code for best experience. Cursor support is experimental and still being tested.

---

## Architecture

```
rhdp-skills-marketplace/
├── install.sh              # Platform-agnostic installer
├── update.sh               # Version checker and updater
├── VERSION                 # Current version (v1.2.1)
├── CHANGELOG.md            # Version history
│
├── showroom/               # Public namespace
│   ├── README.md
│   ├── skills/
│   │   ├── create-lab/
│   │   ├── create-demo/
│   │   ├── verify-content/
│   │   └── blog-generate/
│   └── docs/
│       └── SKILL-COMMON-RULES.md
│
├── agnosticv/              # Internal/Advanced namespace
│   ├── README.md
│   ├── skills/
│   │   ├── agnosticv-catalog-builder/
│   │   └── agnosticv-validator/
│   └── docs/
│       ├── AGV-COMMON-RULES.md
│       ├── workload-mappings.md
│       └── infrastructure-guide.md
│
├── health/                 # Internal/Advanced namespace
│   ├── README.md
│   ├── skills/
│   │   └── deployment-health-checker/
│   └── docs/
│
├── automation/             # Internal/Advanced namespace
│   ├── README.md
│   ├── skills/
│   │   ├── ftl/ (future)
│   │   ├── automation/ (future)
│   │   └── field-automation-builder/ (future)
│   └── docs/
│
└── examples/
    ├── showroom-lab-example/
    └── agv-catalog-example/
```

---

## Prerequisites

- **Claude Code** or **Cursor** installed
- **Git** installed
- For AgnosticV skills:
  - RHDP access
  - AgnosticV repository cloned to `~/work/code/agnosticv`

---

## Troubleshooting

### Installation fails

```bash
# Run with verbose output
bash -x <(curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh)
```

### Skills not showing up

1. Restart your editor (Claude Code or Cursor)
2. Verify installation:
   ```bash
   # For Claude Code
   ls ~/.claude/skills/

   # For Cursor
   ls ~/.cursor/skills/
   ```

### Specify platform and namespace

You can skip interactive prompts by using command-line flags:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh -o /tmp/rhdp-install.sh
bash /tmp/rhdp-install.sh --platform claude --namespace showroom

# or for Cursor
bash /tmp/rhdp-install.sh --platform cursor --namespace all
```

---

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Development Setup

```bash
# Clone repository
git clone git@github.com:rhpds/rhdp-skills-marketplace.git
cd rhdp-skills-marketplace

# Test installation locally
./install.sh --dry-run
```

---

## Support

- **Issues:** [GitHub Issues](https://github.com/rhpds/rhdp-skills-marketplace/issues)
- **RHDP Team:** Slack #forum-rhdp or #forum-rhdp-content
- **Documentation:** https://rhpds.github.io/rhdp-skills-marketplace

---

## License

Apache License 2.0 - See [LICENSE](LICENSE) for details.

---

## Credits

**Maintainer:** Prakhar Srivastava (@prakhar1985), Manager – Technical Marketing, Red Hat

**RHDP Development Team:**
- Tyrell Reddy
- Juliano Mohr
- Mitesh Sharma
- Judd Maltin

**Special Thanks:**
- Nate Stephany (RHDP Catalog Owner)
- Red Hat Demo Platform Team
- Red Hat Showroom Community

---

## Related Projects

- [Red Hat Showroom](https://red.ht/showroom)
- [AgnosticD](https://github.com/redhat-cop/agnosticd)
- [AgnosticV](https://github.com/rhpds/agnosticv)
