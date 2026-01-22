# Changelog

All notable changes to the RHDP Skills Marketplace will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v1.1.0] - 2026-01-22

### Added
- GitHub releases and version tagging system
- Install/update scripts now download from latest GitHub release
- Individual skill documentation pages with "Before You Start" sections
- Health namespace documentation added to GitHub Pages
- `/ftl` skill moved to Health namespace (automated workshop grader/solver)
- Comprehensive prerequisites for each skill
- Automated release creation script (`scripts/create-release.sh`)
- Release process documentation in `scripts/README.md`

### Changed
- Install script uses GitHub releases API instead of cloning main branch
- Update script checks latest release via GitHub API
- Improved fallback to main branch if releases unavailable
- Documentation structure reorganized for clarity

## [1.0.0] - 2026-01-22

### Added

#### Showroom Namespace (Public - Content Creation)
- `create-lab` - Generate Red Hat Showroom workshop lab modules with Know/Show structure
- `create-demo` - Generate presenter-led demo content for Red Hat Showroom
- `verify-content` - AI-powered quality validation for workshop and demo content
- `blog-generate` - Transform completed lab/demo content into blog posts

#### AgnosticV Namespace (RHDP Internal - Provisioning)
- `agv-generator` - Create AgnosticV catalog items with infrastructure provisioning
- `agv-validator` - Validate AgnosticV configurations and best practices
- `generate-agv-description` - Generate catalog descriptions from lab/demo content

#### Health Namespace (RHDP Internal - Post-Deployment Validation)
- `validation-role-builder` - Create Ansible validation roles for RHDP workloads
- `ftl` - Finish The Labs: Automated grader and solver generation for workshop testing

#### Installation System
- Platform-agnostic installation script with Claude Code and Cursor support
- Interactive namespace selection (showroom, agnosticv, or all)
- Automatic backup of existing skills before installation
- Version tracking and update mechanism
- Dry-run mode for safe testing

#### Documentation
- Comprehensive README with quick start guides
- Namespace-specific documentation (showroom, agnosticv)
- Workload mappings reference for AgnosticV
- Infrastructure decision guide (CNV/SNO/AWS selection)
- Example content for testing

### Changed
- **Breaking**: Separated AgnosticV logic from content creation skills
  - `create-lab` and `create-demo` now focus purely on content creation
  - AgnosticV provisioning moved to dedicated `agv-generator` skill
- Reorganized common rules into namespace-specific documentation

### Technical Details
- Repository: https://github.com/rhpds/rhdp-skills-marketplace
- Supported Platforms: Claude Code, Cursor (via installer detection)
- Namespace Architecture: showroom (public) / agnosticv (internal)
- Installation Method: One-command curl script with interactive prompts

[Unreleased]: https://github.com/rhpds/rhdp-skills-marketplace/compare/v1.1.0...HEAD
[v1.1.0]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.1.0
[1.0.0]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.0.0
