# Showroom Templates

This directory contains AsciiDoc templates used by `/create-lab` and `/create-demo` skills to generate consistent, high-quality content for Red Hat Showroom.

## Directory Structure

```
templates/
├── demo/          # Demo (presenter-led) templates
│   ├── 00-index.adoc
│   ├── 01-overview.adoc
│   ├── 02-details.adoc
│   ├── 03-module-01.adoc
│   ├── 04-module-02.adoc
│   ├── 05-module-03.adoc
│   └── 99-conclusion.adoc
└── workshop/      # Workshop (hands-on lab) templates
    ├── 99-conclusion.adoc
    ├── example/   # Example workshop content
    └── templates/ # Learner and facilitator templates
```

## Installation

These templates are automatically installed to `~/.claude/templates/` when you install the Showroom namespace:

```bash
# Install using the install script
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | bash
```

## Usage

Skills that use these templates:

- **`/create-lab`** - Uses workshop templates to generate multi-module hands-on labs
- **`/create-demo`** - Uses demo templates to generate presenter-led demonstrations

The skills automatically read these templates from:
1. Current git repo: `.claude/templates/` (if repo-specific templates exist)
2. Global home: `~/.claude/templates/` (default location)

## Template Purpose

### Demo Templates

- **00-index.adoc**: Main navigation index for demo
- **01-overview.adoc**: Introduction and demo overview
- **02-details.adoc**: Technical details and architecture
- **03-05-module-XX.adoc**: Demo module templates showing presenter script and actions
- **99-conclusion.adoc**: Demo wrap-up and next steps

### Workshop Templates

- **99-conclusion.adoc**: Standard conclusion for workshops
- **example/**: Complete example workshop for reference
- **templates/**: Learner-facing and facilitator-facing templates

## Customization

To customize templates for a specific project:

1. Copy templates to your project's `.claude/templates/` directory
2. Modify as needed for project-specific requirements
3. Skills will use project templates instead of global templates

## Source

Templates sourced from [showroom_template_nookbag](https://github.com/rhpds/showroom_template_nookbag), the official Red Hat Showroom template repository.

## Support

For questions or issues:
- Join [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX) on Red Hat Slack
- Open an issue on [GitHub](https://github.com/rhpds/rhdp-skills-marketplace/issues)
