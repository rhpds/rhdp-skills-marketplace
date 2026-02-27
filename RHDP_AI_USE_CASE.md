# RHDP Skills Marketplace: AI-Powered Content Creation and Provisioning

## Overview

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

## The Challenge

Creating RHDP content (workshops, demos, AgnosticV catalogs) requires deep technical knowledge but involves significant repetitive work:
- Structuring content according to Red Hat standards
- Writing boilerplate configuration files (YAML, AsciiDoc, Ansible)
- Ensuring consistency across catalog items
- Validating complex dependencies and configurations
- Converting technical content into multiple formats

Previously, this required both subject matter expertise AND proficiency with RHDP tooling, creating a barrier for field teams and product managers.

## How We Use AI

**RHDP Skills Marketplace uses Claude (Anthropic's AI) as an expert assistant that combines Red Hat domain knowledge with automated content generation.**

### The AI Solution

1. **Structured Prompts (Skills)**
   - Each skill is a markdown file (SKILL.md) containing detailed instructions
   - Prompts include: Red Hat standards, RHDP best practices, file templates, validation rules
   - AI reads these prompts and executes multi-step workflows

2. **Interactive Guidance**
   - AI asks clarifying questions to gather requirements (catalog name, technologies, module count)
   - User provides: Subject matter expertise, technical details, learning objectives
   - AI provides: Structure, boilerplate, consistency, best practice enforcement

3. **Content Generation**
   - AI generates complete file sets: YAML configs, AsciiDoc modules, Ansible playbooks
   - Uses context from templates, existing catalog patterns, Red Hat documentation
   - Applies brand guidelines, naming conventions, metadata standards automatically

4. **Quality Validation**
   - AI analyzes generated content against Red Hat standards
   - Checks: UUID uniqueness, dependency conflicts, infrastructure compatibility
   - Provides actionable feedback for improvements

### Concrete Examples

**Example 1: Workshop Creation (`/showroom:create-lab`)**
- User input: "OpenShift Pipelines workshop, 3 modules, beginner level"
- AI output: Complete AsciiDoc structure, navigation, metadata, module templates
- Time saved: 4-6 hours → 15 minutes

**Example 2: Catalog Building (`/agnosticv:catalog-builder`)**
- User input: Catalog name, infrastructure type, workload list
- AI output: common.yaml, dev.yaml, description.adoc with correct UUIDs, dependencies
- Validation: Auto-checks for conflicts, suggests infrastructure sizing
- Time saved: 2-3 hours → 20 minutes

**Example 3: Quality Validation (`/showroom:verify-content`)**
- User input: Existing workshop directory
- AI analysis: Red Hat brand compliance, technical accuracy, accessibility, formatting
- Output: Scored report with specific recommendations
- Time saved: 1-2 hours manual review → 5 minutes

### AI Techniques Used

1. **Prompt Engineering**: Skills contain domain-specific context (RHDP standards, catalog patterns)
2. **Few-Shot Learning**: Skills include example outputs to guide AI generation
3. **Tool Use**: AI reads/writes files, runs validation commands, creates git branches
4. **Context Injection**: Templates and documentation embedded in skill prompts
5. **Iterative Refinement**: AI asks questions until it has complete requirements

### Human-AI Collaboration Model

**Humans provide:**
- Subject matter expertise
- Technical requirements
- Learning objectives
- Final validation and approval

**AI provides:**
- Structural consistency
- Boilerplate generation
- Best practice enforcement
- Standards compliance checking
- Format conversion

**The result:** Non-technical contributors can create RHDP content without learning complex tooling, while technical experts save hours on repetitive tasks.

## Impact

RHDP Skills Marketplace has streamlined content creation for RHDP, enabling:
- **Democratization**: Field teams and PMs can now create workshops without DevOps expertise
- **Speed**: Catalog creation reduced from hours to minutes
- **Quality**: Built-in validation ensures Red Hat standards compliance
- **Consistency**: All content follows same patterns and conventions
- **Rapid Prototyping**: Demos and workshops created in hours instead of days

The platform follows Red Hat's AI principles by augmenting human expertise rather than replacing it, with AI handling boilerplate generation while subject matter experts focus on technical accuracy and learning outcomes.

## Alignment with Red Hat AI Principles

- **Augmentation, not replacement**: AI handles boilerplate, humans provide expertise
- **Transparency**: All AI-generated content is reviewable and editable
- **Control**: Users validate outputs, AI doesn't auto-deploy
- **Open Standards**: Built on open Agent Skills standard (agentskills.io)

## Technical Stack

- **AI Model**: Claude 3.5 Sonnet (Anthropic)
- **Framework**: Agent Skills open standard
- **Distribution**: Claude Code plugin marketplace
- **Platforms**: Claude Code CLI, VS Code, Cursor
- **Language**: Markdown-based skill definitions (SKILL.md)

## Current Scale

- **7 production skills** across 3 domains
- **v2.4.3** (active development since v1.0.0 in Sep 2024)
- **Multiple platforms** supported (Claude Code, VS Code, Cursor)
- **RHDP team and field contributors** actively using

## Future Plans

The **automation namespace** is planned for Q1 2026, which will include:
- **FTL (Full Test Lifecycle)**: Automated grader/solver generation for workshop testing and validation
- **Field Automation Builder**: Import field-sourced content directly into RHDP catalog
- **Workflow Automation**: Automated RHDP operations and orchestration

Future improvements also include:
- Expanding AI-powered validation
- Supporting additional content formats
- Enabling multi-language workshop generation
- Smart infrastructure sizing recommendations
- Automated content updates based on upstream changes

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

---

**[Space for Nate: Success Stories and Detailed Metrics]**
