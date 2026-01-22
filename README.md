# RHDP Skills Marketplace

AI-powered skills for Red Hat Demo Platform content creation and provisioning.

Supports: **Claude Code** | **Cursor**

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Version](https://img.shields.io/badge/version-v1.0.0-green.svg)](https://github.com/rhpds/rhdp-skills-marketplace/releases)

**📚 [Full Documentation](https://rhpds.github.io/rhdp-skills-marketplace)** | [Changelog](CHANGELOG.md) | [Contributing](CONTRIBUTING.md)

---

## Quick Start

### Installation (One Command)

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | bash
```

The installer will:
1. Ask which platform you're using (Claude Code or Cursor)
2. Ask which namespace to install (showroom, agnosticv, or all)
3. Backup your existing skills
4. Install the selected skills

### For Content Creators (External Developers)

Install the **showroom** namespace for creating Red Hat Showroom workshop labs and demos:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | bash
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

Install the **agnosticv** namespace for AgnosticV catalog provisioning and validation:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | bash
# When prompted:
# 1. Select your platform (Claude Code or Cursor)
# 2. Select namespace: 2 (agnosticv) or 3 (all)
```

**Additional Skills:**
- `/agv-generator` - Create AgnosticV catalog items
- `/agv-validator` - Validate catalog configurations
- `/generate-agv-description` - Generate catalog descriptions from lab content
- `/validation-role-builder` - Create Ansible validation roles

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
| `agv-generator` | Create catalog items | Building new RHDP catalog entries |
| `agv-validator` | Validate configurations | Pre-deployment quality checks |
| `generate-agv-description` | Generate descriptions | Creating catalog descriptions |

**Workflow:**
```
/agv-generator → Test in RHDP → /create-lab (with UserInfo) → Deploy
```

**Documentation:** [agnosticv/README.md](agnosticv/README.md)

---

### 🏥 health (RHDP Internal/Advanced - Validation & Testing)

**Purpose:** Post-deployment validation, health checks, and automated testing

**Skills:**

| Skill | Description | Use Case |
|-------|-------------|----------|
| `validation-role-builder` | Create validation roles | Automated post-deploy health checks |

**Workflow:**
```
Deploy catalog → /validation-role-builder → Health checks → Verify readiness
```

**Documentation:** [health/README.md](health/README.md)

---

### 🤖 automation (RHDP Internal/Advanced - Intelligent Automation)

**Purpose:** Workflow automation, intelligent testing, and environment discovery

**Skills:**

| Skill | Description | Use Case |
|-------|-------------|----------|
| `ftl` (future) | Fast Track Learner | Environment discovery and intelligent testing |
| `automation` (future) | Workflow automation | Automated RHDP operations and orchestration |

**Workflow:**
```
/ftl → Discover environment → Generate tests → /automation → Orchestrate workflows
```

**Documentation:** [automation/README.md](automation/README.md)

---

## Updates

Check for and install updates:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/update.sh | bash
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
/agv-generator

# Answer the prompts:
# - Catalog name: "Agentic AI on OpenShift"
# - Infrastructure: CNV multi-node
# - Multi-user: Yes
# - Workloads: OpenShift AI, LiteLLM, Showroom

# Skill generates:
# ~/work/code/agnosticv/agd_v2/agentic-ai-openshift/
# ├── common.yaml
# ├── description.adoc
# └── dev.yaml
```

### Validating a Catalog

```bash
# In Claude Code or Cursor
/agv-validator

# Skill checks:
# ✓ UUID format and uniqueness
# ✓ YAML syntax
# ✓ Workload dependencies
# ✓ Infrastructure recommendations
# ⚠️ Best practice suggestions
```

---

## Platform Support

### Claude Code

Skills are installed to:
- Skills: `~/.claude/skills/`
- Docs: `~/.claude/docs/`

### Cursor

Skills are installed to:
- Skills: `~/.cursor/skills/`
- Docs: `~/.cursor/docs/`

The installer automatically detects your platform and sets the correct paths.

---

## Architecture

```
rhdp-skills-marketplace/
├── install.sh              # Platform-agnostic installer
├── update.sh               # Version checker and updater
├── VERSION                 # Current version (v1.0.0)
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
│   │   ├── agv-generator/
│   │   ├── agv-validator/
│   │   └── generate-agv-description/
│   └── docs/
│       ├── AGV-COMMON-RULES.md
│       ├── workload-mappings.md
│       └── infrastructure-guide.md
│
├── health/                 # Internal/Testing namespace
│   ├── README.md
│   ├── skills/
│   │   └── validation-role-builder/
│   └── docs/
│
├── automation/             # Internal/Advanced namespace
│   ├── README.md
│   ├── skills/
│   │   ├── ftl/ (future)
│   │   └── automation/ (future)
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

### Wrong platform detected

Specify platform explicitly:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | bash -s -- --platform claude
# or
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | bash -s -- --platform cursor
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
