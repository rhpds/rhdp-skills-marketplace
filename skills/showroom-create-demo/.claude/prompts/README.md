# Showroom Verification Prompts

This directory contains comprehensive verification prompts used by `/create-lab`, `/create-demo`, and `/verify-content` skills to ensure content meets Red Hat quality standards.

## Directory Contents

### Enhanced Verification Prompts

- **`enhanced_verification_demo.txt`** - Complete quality checklist for demos (51KB)
  - Know/Show structure validation
  - Technical accuracy checks
  - Red Hat style compliance
  - Accessibility requirements
  - Demo-specific guidelines

- **`enhanced_verification_workshop.txt`** - Complete quality checklist for workshops (45KB)
  - Learner-facing content validation
  - Hands-on exercise quality
  - Learning objective alignment
  - Workshop structure requirements
  - Pedagogical best practices

### Style and Branding

- **`redhat_style_guide_validation.txt`** - Red Hat branding and style rules
  - Product name capitalization
  - Trademark usage
  - Voice and tone guidelines
  - Terminology standards

### Accessibility Compliance

- **`verify_accessibility_compliance.txt`** - General WCAG compliance (5KB)
- **`verify_accessibility_compliance_demo.txt`** - Demo-specific accessibility (10KB)
- **`verify_accessibility_compliance_workshop.txt`** - Workshop-specific accessibility (10KB)
  - Image alt text requirements
  - Color contrast validation
  - Keyboard navigation
  - Screen reader compatibility

### Technical Accuracy

- **`verify_technical_accuracy_demo.txt`** - Technical accuracy for demos (16KB)
  - Command accuracy
  - Configuration validation
  - Version compatibility
  - Demo flow logic

- **`verify_technical_accuracy_workshop.txt`** - Technical accuracy for workshops (9KB)
  - Exercise correctness
  - Learning path coherence
  - Prerequisites validation
  - Expected outcomes verification

### Content Quality

- **`verify_content_quality.txt`** - General content quality standards (13KB)
  - Grammar and spelling
  - Clarity and conciseness
  - Logical flow
  - Audience appropriateness

### Workshop Structure

- **`verify_workshop_structure.txt`** - Workshop structural requirements (14KB)
  - Module organization
  - Time allocation
  - Learning objectives
  - Assessment criteria

## Installation

These prompts are automatically installed to `~/.claude/prompts/` when you install the Showroom namespace:

```bash
# Install using the install script
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | bash
```

## Usage

Skills that use these prompts:

- **`/create-lab`** - Applies verification criteria DURING content generation
- **`/create-demo`** - Applies verification criteria DURING content generation
- **`/verify-content`** - Runs comprehensive post-creation verification

### How Skills Use Prompts

1. **During Generation** (create-lab, create-demo):
   - Skills read prompts before generating content
   - Apply quality criteria as content is written
   - Ensure compliance from the start

2. **Post-Creation** (verify-content):
   - Reads all applicable prompts
   - Analyzes existing content against criteria
   - Generates detailed quality report with issues and recommendations

### Prompt Detection Priority

Skills automatically detect prompts from:
1. **Current git repo**: `.claude/prompts/` (highest priority - project-specific)
2. **Global home**: `~/.claude/prompts/` (default - user's global settings)

## Customization

To customize verification rules for a specific project:

1. Copy relevant prompts to your project's `.claude/prompts/` directory
2. Modify criteria for project-specific requirements
3. Skills will use project prompts instead of global prompts

Example use cases:
- Stricter requirements for partner content
- Relaxed rules for internal documentation
- Custom terminology for specific product lines

## Prompt File Format

All prompts are plain text (.txt) files containing:
- Structured validation criteria
- Red Hat standards and guidelines
- Quality benchmarks
- Common issues to check for
- Best practices and recommendations

## Source

Verification prompts sourced from [showroom_template_nookbag](https://github.com/rhpds/showroom_template_nookbag), representing battle-tested quality standards from the Red Hat Demo Platform team.

## Support

For questions or issues:
- Join [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX) on Red Hat Slack
- Open an issue on [GitHub](https://github.com/rhpds/rhdp-skills-marketplace/issues)
