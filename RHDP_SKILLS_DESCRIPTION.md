# RHDP Skills Marketplace: AI-Powered Content Creation and Provisioning Agent

**RHDP Skills Marketplace** is an AI-powered skills platform for Red Hat Demo Platform (RHDP) content creation, catalog provisioning, and deployment validation. Built on the [Agent Skills open standard](https://agentskills.io), it provides specialized capabilities for workshop creation, demo development, AgnosticV catalog automation, and deployment health checks.

The project is available at https://github.com/rhpds/rhdp-skills-marketplace, with comprehensive documentation at https://rhpds.github.io/rhdp-skills-marketplace. Skills are distributed via Claude Code's plugin marketplace system for automatic updates, and also support direct installation for Cursor users.

## Current Capabilities

RHDP Skills Marketplace currently provides **7 production skills** across **3 namespaces**:

- **Showroom namespace** (Public - Content Creation):
  - `/showroom:create-lab` - Generate workshop lab modules with hands-on exercises
  - `/showroom:create-demo` - Create presenter-led demo content
  - `/showroom:verify-content` - AI-powered quality validation against Red Hat standards
  - `/showroom:blog-generate` - Transform workshops into blog posts

- **AgnosticV namespace** (RHDP Internal - Provisioning):
  - `/agnosticv:catalog-builder` - Create and update RHDP catalog items with guided workflows
  - `/agnosticv:validator` - Validate catalog configurations and dependencies

- **Health namespace** (RHDP Internal - Validation):
  - `/health:deployment-validator` - Generate Ansible validation roles for post-deployment health checks

## Platform Support

- **Claude Code CLI** (Recommended): Plugin marketplace with automatic updates
- **VS Code with Claude Extension**: Same marketplace integration as Claude Code
- **Cursor 2.4+**: Direct installation script (manual updates)

## Future Plans

The **automation namespace** is planned for Q1 2026, which will include:
- **FTL (Full Test Lifecycle)**: Automated grader/solver generation for workshop testing and validation
- **Field Automation Builder**: Import field-sourced content directly into RHDP catalog
- **Workflow Automation**: Automated RHDP operations and orchestration

Future improvements also include expanding AI-powered validation, supporting additional content formats, and enabling multi-language workshop generation.

## Key Links

- **GitHub Repository**: https://github.com/rhpds/rhdp-skills-marketplace
- **Documentation**: https://rhpds.github.io/rhdp-skills-marketplace
- **Latest Release**: https://github.com/rhpds/rhdp-skills-marketplace/releases (v2.4.3)
- **Slack Support**: [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX)
- **Installation Guide**: https://rhpds.github.io/rhdp-skills-marketplace/setup/claude-code.html

## Quick Start

```bash
# Install Claude Code from https://claude.com/claude-code
claude

# In Claude Code chat, add marketplace
/plugin marketplace add rhpds/rhdp-skills-marketplace

# Install plugins
/plugin install showroom@rhdp-marketplace
/plugin install agnosticv@rhdp-marketplace
/plugin install health@rhdp-marketplace
```

## Impact

RHDP Skills Marketplace has streamlined content creation for RHDP, enabling:
- Non-technical contributors to create workshop content without coding experience
- Automated AgnosticV catalog generation with best practices built-in
- AI-powered quality validation ensuring Red Hat standards compliance
- Rapid prototyping of demos and workshops (hours instead of days)

The platform follows Red Hat's AI principles by augmenting human expertise rather than replacing it, with AI handling boilerplate generation while subject matter experts focus on technical accuracy and learning outcomes.
