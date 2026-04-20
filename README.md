# RHDP Skills Marketplace

AI-powered skills for Red Hat Demo Platform content creation and provisioning.

Supports: **Claude Code** | **VS Code with Claude Extension** | **Cursor 2.4+**

> **✅ Note:** All platforms support the [Agent Skills open standard](https://agentskills.io). Skills work natively in **Claude Code**, **VS Code with Claude extension**, and **Cursor 2.4+**.

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Version](https://img.shields.io/badge/version-v2.13.4-green.svg)](https://github.com/rhpds/rhdp-skills-marketplace/releases)

**📚 [Full Documentation](https://rhpds.github.io/rhdp-skills-marketplace)** | [Changelog](CHANGELOG.md) | [Contributing](CONTRIBUTING.md)

> **PUBLIC REPOSITORY -- DO NOT COMMIT SENSITIVE DATA**
>
> This is a **public, world-readable** repository. Everything committed here -- skills, examples, templates, documentation -- is visible to anyone on the internet.
>
> **NEVER include** in any file (SKILL.md, examples, templates, docs, or code):
> - Passwords, API keys, tokens, or secrets (real or internal)
> - Internal hostnames, IP addresses, or non-public URLs
> - Customer names, account IDs, or PII
> - VPN endpoints, bastion addresses, or infrastructure details
> - Service account credentials or kubeconfig data
> - SSH keys, certificates, or private key material
>
> Use **placeholders** (e.g., `{password}`, `<your-api-key>`, `example.com`) instead. See the [Security Guidelines](#security-guidelines) section below.

---

## 🎯 I Want To...

**Create a customer demo or workshop?** → You want **Showroom** skills
- `/showroom:create-demo` - Build a presenter-led demo (you present, customers watch)
- `/showroom:create-lab` - Build a hands-on workshop (customers follow along step-by-step)

**What you need:**
1. Claude Code (CLI) or VS Code with Claude extension
2. This installer (see Quick Start below)
3. Your demo idea

**What you DON'T need:**
- No coding required
- No Git knowledge needed
- No command line experience required

**RHDP Internal Team?** → See [Advanced Setup](#for-rhdp-internaladvanced-users) for AgnosticV and Health skills

---

## Quick Start

### Installation (Marketplace Method - Recommended)

**Prerequisites:** Install Claude Code first from https://claude.com/claude-code

**Step 1:** Start Claude Code in your terminal:

```bash
claude
```

**Step 2:** In Claude Code chat (NOT in terminal), add the RHDP marketplace:

```bash
# If you have SSH keys configured (shorter)
/plugin marketplace add rhpds/rhdp-skills-marketplace

# If you don't have SSH configured (use this)
/plugin marketplace add https://github.com/rhpds/rhdp-skills-marketplace
```

**Step 3:** In Claude Code chat, install the plugins you need:

```bash
# For workshop/demo creation
/plugin install showroom@rhdp-marketplace

# For AgnosticV catalogs (RHDP internal)
/plugin install agnosticv@rhdp-marketplace

# For deployment health checks (RHDP internal)
/plugin install health@rhdp-marketplace
```

**Benefits:**
- ✅ Standard installation (like dnf/brew)
- ✅ Automatic updates with `/plugin marketplace update`
- ✅ Version management and rollback
- ✅ Clean uninstall

See [MARKETPLACE.md](MARKETPLACE.md) for complete plugin list and usage.

### Available Plugins

**Showroom Plugin** (`showroom@rhdp-marketplace`) - Workshop and demo creation:
- `/showroom:create-lab` - Generate workshop lab modules
- `/showroom:create-demo` - Generate presenter-led demo content
- `/showroom:verify-content` - AI-powered quality validation
- `/showroom:blog-generate` - Transform content into blog posts

**AgnosticV Plugin** (`agnosticv@rhdp-marketplace`) - RHDP infrastructure automation:
- `/agnosticv:catalog-builder` - Create/update AgnosticV catalog items & Virtual CIs
- `/agnosticv:validator` - Validate catalog configurations

**Health Plugin** (`health@rhdp-marketplace`) - Deployment validation:
- `/health:deployment-validator` - Create Ansible validation roles

**FTL Plugin** (`ftl@rhdp-marketplace`) - Full Test Lifecycle:
- `/ftl:rhdp-lab-validator` - Generate ZT runtime-automation playbooks for RHDP showroom labs (OCP/RHEL/AAP)

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
| `deployment-validator` | Create validation roles | Automated post-deploy health checks |

**Workflow:**
```
Deploy catalog → /deployment-validator → Health checks → Verify readiness
```

**Documentation:** [health/README.md](health/README.md)

---

### 🧪 ftl (RHDP Internal/Advanced - Full Test Lifecycle)

**Purpose:** Generate automated grader and solver playbooks for Showroom workshop labs

**Skills:**

| Skill | Description | Use Case |
|-------|-------------|----------|
| `lab-validator` | Generate FTL grade/solve playbooks | External container graders (grade_lab/solve_lab) |
| `rhdp-lab-validator` | Orchestrate 4 agents to write + test solve/validate | Inline Solve/Validate buttons — OCP tenant/dedicated, RHEL VM, AAP |
| `content-reader` | AsciiDoc reader agent — extracts `role="execute"` blocks, classifies steps | Feeds solve-writer + validate-writer |
| `solve-writer` | Generates solve.yml with intent-based Playwright scripts | Self-healing on UI version changes |
| `validate-writer` | Generates validate.yml using validation_check plugin | Durable outcome checks, async-safe |
| `env-connector` | Pushes to live Showroom, runs test cycle, collects screenshot evidence | Full test evidence with UI drift detection |

**Workflow:**
```
/ftl:rhdp-lab-validator
  → ftl:content-reader  (reads .adoc + vision analysis of screenshots)
  → ftl:solve-writer    (writes solve.yml with intent-based Playwright)
  → ftl:validate-writer (writes validate.yml with validation_check)
  → ftl:env-connector   (push → test → screenshot evidence → self-heal)
```

**Self-healing:** When UI changes break Playwright steps, env-connector takes a live screenshot, passes it to vision, and recovers the selector automatically.

**Documentation:** [ftl/README.md](ftl/README.md)

---

### 🤖 automation (RHDP Internal/Advanced - Intelligent Automation)

**Purpose:** Workflow automation, intelligent testing, and environment discovery

**Skills:**

| Skill | Description | Use Case |
|-------|-------------|----------|
| `automation` (future) | Workflow automation | Automated RHDP operations and orchestration |
| `field-automation-builder` (future) | Field content integration | Import field-sourced content to RHDP catalog |

**Workflow:**
```
/create-lab → /ftl:lab-validator (generate grader/solver) → Test workshop → Deploy to RHDP
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

### Cursor 2.4+

**⚠️ Workaround Installation:** Cursor supports Agent Skills but **not** the Claude Code plugin marketplace. This uses a direct install script.

**One-command install (run in your TERMINAL, not in Cursor chat):**

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install-cursor.sh | bash
```

Installs all 7 skills with prompts and templates bundled. **Restart Cursor** after installation.

**To update (run in your TERMINAL, not in Cursor chat):**

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/update-cursor.sh | bash
```

**How to use:**

1. **Explicit invocation:** `/showroom-create-lab`, `/agnosticv-catalog-builder` *(hyphens, not colons)*
2. **Natural language:** "Help me create a workshop lab"

**Note:** For full marketplace support with automatic updates, use [Claude Code](https://rhpds.github.io/rhdp-skills-marketplace/setup/claude-code.html) instead.

**Requirements:** Cursor 2.4.0+ • [Full Guide →](https://rhpds.github.io/rhdp-skills-marketplace/setup/cursor.html)

---

## Architecture

```
rhdp-skills-marketplace/
├── .claude-plugin/         # Claude Code plugin marketplace
│   └── marketplace.json
│
├── skills/                 # Flat structure for npx skills (Cursor)
│   ├── showroom-create-lab/
│   │   └── SKILL.md (symlink)
│   ├── showroom-create-demo/
│   │   └── SKILL.md (symlink)
│   ├── agnosticv-catalog-builder/
│   │   └── SKILL.md (symlink)
│   └── ... (7 total)
│
├── showroom/               # Plugin structure (Claude Code)
│   ├── .claude-plugin/plugin.json
│   ├── README.md
│   ├── skills/
│   │   ├── create-lab/SKILL.md
│   │   ├── create-demo/SKILL.md
│   │   ├── verify-content/SKILL.md
│   │   └── blog-generate/SKILL.md
│   └── docs/
│
├── agnosticv/              # Plugin structure (Claude Code)
│   ├── .claude-plugin/plugin.json
│   ├── README.md
│   ├── skills/
│   │   ├── catalog-builder/SKILL.md
│   │   └── validator/SKILL.md
│   └── docs/
│
├── health/                 # Plugin structure (Claude Code)
│   ├── .claude-plugin/plugin.json
│   ├── README.md
│   ├── skills/
│   │   └── deployment-validator/SKILL.md
│   └── docs/
│
├── VERSION                 # Current version
├── CHANGELOG.md            # Version history
└── docs/                   # GitHub Pages documentation
```

**Dual Installation Support:**
- **Claude Code:** Plugin marketplace (`/plugin marketplace add`)
- **Cursor:** npx skills (`npx skills add`)

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

## Security Guidelines

This is a **public repository**. All content is world-readable and indexed by search engines. Every contributor must follow these rules.

### What MUST NOT appear anywhere in this repo

| Category | Examples | Use Instead |
|----------|----------|-------------|
| Credentials | Passwords, API keys, tokens, secrets | `{password}`, `<your-api-key>`, `lookup('password', ...)` |
| Internal infrastructure | VPN endpoints, bastion IPs, internal hostnames | `{bastion_public_hostname}`, `example.internal` |
| Customer/user data | Real names, email addresses, account IDs | `user1@example.com`, `{user_name}` |
| Non-public URLs | Internal dashboards, staging environments, private repos | `https://example.com/dashboard` |
| Certificates & keys | SSH private keys, TLS certs, kubeconfig contents | Reference the file path, never the content |
| Cloud account details | AWS account IDs, subscription IDs, project IDs | `<your-account-id>`, `{cloud_account}` |

### Rules for skill authors

1. **Use attribute placeholders** -- all environment-specific values must use `{attribute}` or `<placeholder>` syntax, never real values.
2. **Examples must be synthetic** -- example YAML/config files must use `example.com`, `192.0.2.x` (RFC 5737), and dummy UUIDs.
3. **Credential patterns only** -- show the `lookup('password', ...)` pattern or `{password}` placeholder, never an actual credential.
4. **No internal URLs** -- references to `*.redhat.com` internal systems (not public-facing) must be removed or replaced with generic descriptions.
5. **Review before committing** -- scan your changes for anything that looks like a real credential, IP, hostname, or account identifier.

### If you find sensitive data

If you discover committed secrets or sensitive data, **do not just delete it in a new commit** (it remains in git history). Instead:
1. Contact the repository maintainers immediately.
2. Rotate any exposed credentials.
3. The maintainers will rewrite history if necessary.

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
- **Slack:** [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX)
- **Documentation:** https://rhpds.github.io/rhdp-skills-marketplace

---

## License

Apache License 2.0 - See [LICENSE](LICENSE) for details.

---

## Credits

**RHDP Development Team:**
- Wolfgang
- Tony Kay
- Tyrell Reddy
- Juliano Mohr
- Mitesh Sharma
- Judd Maltin
- Ritesh Shah

**Maintainers:**
- Prakhar Srivastava (@prakhar1985)
- Nate Stephany

---

## Related Projects

- [Red Hat Showroom](https://red.ht/showroom)
- [AgnosticD](https://github.com/redhat-cop/agnosticd)
- [AgnosticV](https://github.com/rhpds/agnosticv)
