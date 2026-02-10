# RHDP Skills Marketplace - AI Use Case

## What It Is
AI-powered skills platform for RHDP content creation, catalog provisioning, and deployment validation using Claude (Anthropic). Built on Agent Skills open standard.

## How We Use AI

**The Challenge:** Creating RHDP workshops/demos/catalogs required both technical expertise AND RHDP tooling knowledge, creating barriers for field teams.

**The AI Solution:** Claude acts as an expert assistant that combines Red Hat domain knowledge with automated content generation through structured prompts (skills).

**Process:**
1. User provides: Subject matter expertise, requirements, technical details
2. AI provides: Structure, boilerplate, consistency, Red Hat standards compliance
3. AI generates: Complete YAML configs, AsciiDoc modules, Ansible playbooks
4. AI validates: Brand compliance, dependencies, infrastructure compatibility

## Concrete Results

- **Workshop creation**: 4-6 hours → 15 minutes
- **Catalog building**: 2-3 hours → 20 minutes
- **Quality validation**: 1-2 hours → 5 minutes

## Current Capabilities

**7 production skills across 3 domains:**
- Showroom: Workshop/demo creation, content validation, blog generation
- AgnosticV: Catalog builder, configuration validator
- Health: Deployment validation roles

## AI Techniques

- Prompt engineering with RHDP domain context
- Tool use (file operations, git, validation commands)
- Context injection (templates, documentation, best practices)
- Interactive requirements gathering

## Impact

- **Democratization**: Non-technical users can create RHDP content
- **Speed**: Hours → minutes for content creation
- **Quality**: Built-in Red Hat standards compliance
- **Consistency**: Automated best practices enforcement

## Technical Stack

- AI: Claude 3.5 Sonnet (Anthropic)
- Framework: Agent Skills open standard
- Platforms: Claude Code CLI, VS Code, Cursor
- Version: v2.4.3

## Links

- GitHub: https://github.com/rhpds/rhdp-skills-marketplace
- Docs: https://rhpds.github.io/rhdp-skills-marketplace
- Slack: #forum-demo-developers

---

**[Space for Nate: Success Stories and Metrics]**
