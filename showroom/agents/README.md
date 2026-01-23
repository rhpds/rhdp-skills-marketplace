# Showroom Specialized Agents

This directory contains specialized AI agents that assist with content creation, quality control, and migration tasks for Red Hat Showroom content.

## Available Agents

### Quality Assurance Agents

**`accessibility-checker.md`** - WCAG Compliance Validator
- Validates images have proper alt text
- Checks color contrast ratios
- Verifies keyboard navigation
- Ensures screen reader compatibility
- Reviews heading hierarchy
- Validates link text clarity

**`style-enforcer.md`** - Red Hat Style Guide Enforcer
- Enforces Red Hat product naming conventions
- Validates trademark usage
- Checks voice and tone consistency
- Ensures terminology standards
- Reviews capitalization rules
- Validates branding guidelines

**`workshop-reviewer.md`** - Workshop Content Quality Reviewer
- Reviews learning objectives alignment
- Validates hands-on exercise quality
- Checks time estimates and pacing
- Ensures pedagogical best practices
- Reviews assessment criteria
- Validates prerequisite clarity

### Content Creation Agents

**`technical-writer.md`** - Technical Writing Assistant
- Assists with clear, concise technical writing
- Provides structure and organization guidance
- Suggests improvements for clarity
- Ensures audience-appropriate language
- Reviews logical flow
- Validates completeness

**`technical-editor.md`** - Technical Accuracy Reviewer
- Reviews technical accuracy of commands
- Validates configuration correctness
- Checks version compatibility
- Ensures code examples work
- Reviews architectural diagrams
- Validates technical explanations

**`researcher.md`** - Technical Research Specialist
- Researches accurate product information
- Finds current version numbers
- Locates official documentation
- Verifies technical specifications
- Discovers best practices
- Identifies relevant examples

### Migration and Conversion Agents

**`content-converter.md`** - Format Conversion Specialist
- Converts between content formats
- Migrates Markdown to AsciiDoc
- Transforms legacy content to Showroom format
- Preserves formatting and structure
- Handles images and media
- Maintains cross-references

**`migration-assistant.md`** - Content Migration Helper
- Assists with Showroom migration projects
- Identifies content structure patterns
- Suggests organizational improvements
- Maps old structure to new format
- Validates migration completeness
- Documents migration decisions

## Installation

These agents are automatically installed to `~/.claude/agents/` when you install the Showroom namespace:

```bash
# Install using the install script
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | bash
```

## Usage

Skills that invoke these agents:

- **`/create-lab`** - May invoke technical-writer, researcher agents during generation
- **`/create-demo`** - May invoke technical-writer, researcher agents during generation
- **`/verify-content`** - Invokes accessibility-checker, style-enforcer, workshop-reviewer
- **`/blog-generate`** - Invokes technical-editor, style-enforcer for blog post quality

## How to Use Agents

### Within Skills (Automatic)

Skills automatically invoke relevant agents when needed:

```
/create-lab my-workshop-content.md
# Skill may invoke:
# - researcher.md to find accurate product information
# - technical-writer.md to improve clarity
# - accessibility-checker.md to ensure compliance
```

### Manually (Direct Invocation)

You can also use agents directly in your conversations:

```
Can you use the technical-editor agent to review my demo script for accuracy?
```

```
Please run the accessibility-checker agent on my workshop content.
```

```
Use the style-enforcer agent to ensure this content follows Red Hat guidelines.
```

## Agent File Format

All agents are Markdown (.md) files containing:
- **Agent identity** - Role, expertise, responsibilities
- **Capabilities** - What the agent can do
- **Guidelines** - How the agent operates
- **Quality criteria** - Standards the agent applies
- **Output format** - How the agent presents findings

## Customization

To create project-specific agents:

1. Copy an agent to your project's `.claude/agents/` directory
2. Modify the agent's guidelines and criteria
3. Reference the agent by name in your project

Example use cases:
- Product-specific technical reviewers
- Custom style guides for specific teams
- Specialized migration patterns for legacy content

## Agent Invocation Patterns

### Quality Review Pattern
```markdown
Please invoke the following agents to review my content:
1. accessibility-checker - Validate WCAG compliance
2. style-enforcer - Check Red Hat style guidelines
3. technical-editor - Review technical accuracy
```

### Content Creation Pattern
```markdown
I need help writing a technical overview.
Use the technical-writer agent to ensure clarity and structure.
Then use the researcher agent to verify product information.
```

### Migration Pattern
```markdown
I'm migrating old workshop content to Showroom format.
Use the migration-assistant agent to guide the process.
Then use the content-converter agent to transform the format.
```

## Best Practices

1. **Combine agents** - Use multiple agents for comprehensive review
2. **Invoke early** - Run quality agents during creation, not just after
3. **Document findings** - Save agent feedback for improvement tracking
4. **Customize criteria** - Adjust agent guidelines for your specific needs
5. **Iterate** - Use agents multiple times as content evolves

## Source

Specialized agents sourced from [showroom_template_nookbag](https://github.com/rhpds/showroom_template_nookbag), representing proven content creation patterns from the Red Hat Demo Platform team.

## Support

For questions or issues:
- Join [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX) on Red Hat Slack
- Open an issue on [GitHub](https://github.com/rhpds/rhdp-skills-marketplace/issues)
