# How RHDP Skills Marketplace Uses AI

## The Challenge

Creating RHDP content (workshops, demos, AgnosticV catalogs) requires deep technical knowledge but involves significant repetitive work:
- Structuring content according to Red Hat standards
- Writing boilerplate configuration files (YAML, AsciiDoc, Ansible)
- Ensuring consistency across catalog items
- Validating complex dependencies and configurations
- Converting technical content into multiple formats

Previously, this required both subject matter expertise AND proficiency with RHDP tooling, creating a barrier for field teams and product managers.

## The AI Solution

**RHDP Skills Marketplace uses Claude (Anthropic's AI) as an expert assistant that combines Red Hat domain knowledge with automated content generation.**

### How It Works

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

## Concrete Examples

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

## AI Techniques Used

1. **Prompt Engineering**: Skills contain domain-specific context (RHDP standards, catalog patterns)
2. **Few-Shot Learning**: Skills include example outputs to guide AI generation
3. **Tool Use**: AI reads/writes files, runs validation commands, creates git branches
4. **Context Injection**: Templates and documentation embedded in skill prompts
5. **Iterative Refinement**: AI asks questions until it has complete requirements

## Human-AI Collaboration Model

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

- **Democratization**: Field teams and PMs can now create workshops without DevOps expertise
- **Speed**: Catalog creation reduced from hours to minutes
- **Quality**: Built-in validation ensures Red Hat standards compliance
- **Consistency**: All content follows same patterns and conventions

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
- **2 platforms** supported (Claude Code, Cursor)
- **~50 users** (RHDP team, field contributors)

## Future AI Enhancements

- **FTL (Finish The Labs)**: AI-generated workshop graders/solvers for automated testing
- **Multi-language Support**: AI-powered translation of workshop content
- **Smart Recommendations**: AI suggests infrastructure sizing based on workload analysis
- **Automated Content Updates**: AI detects upstream changes and suggests content updates
