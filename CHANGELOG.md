# Changelog

All notable changes to the RHDP Skills Marketplace will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v1.4.0] - 2026-01-22

### Added
- **Sales-friendly documentation** - Major accessibility improvements for non-technical users
  - Added "I Want To..." quick start section in README.md for salespeople and content creators
  - Created comprehensive glossary (docs/reference/glossary.md) explaining all technical terms in plain language
  - Added decision trees to create-lab.md and create-demo.md for easier skill selection
  - Enhanced install.sh with clear namespace descriptions and examples

### Changed
- **Simplified all documentation** following "less is more" principle
  - Removed Git prerequisites from create-lab.md and create-demo.md
  - Emphasized no coding/Git knowledge required for workshop creation
  - Simplified docs/index.md with clearer audience sections (Most Users vs RHDP Team)
  - Removed all time estimates from documentation
  - Removed cost/pricing mentions - focus on capabilities only
  - Changed language from "free text editor" to "AI-powered text editor"
  - Consistently refer to "Claude Code (CLI) or VS Code with Claude extension"

### Focus
This release makes RHDP Skills Marketplace accessible to average salespeople and content creators who may not have technical backgrounds. Documentation now assumes zero Git knowledge and zero command line experience for Showroom skills.

## [v1.3.1] - 2026-01-22

### Changed
- **Renamed `/validation-role-builder` to `/deployment-health-checker`** for clarity
  - Better describes the skill's purpose: validating deployment health, not building validators
  - Updated skill name in SKILL.md frontmatter (added frontmatter for consistency)
  - Renamed skill directory: `health/skills/validation-role-builder/` → `health/skills/deployment-health-checker/`
  - Updated all documentation references across repository
  - Updated Cursor rules with new trigger phrases
  - Updated install.sh and all setup guides

### Migration
- **Old:** `/validation-role-builder` → **New:** `/deployment-health-checker`
- All functionality remains the same - only the name has changed
- New trigger phrases emphasize deployment health checking

## [v1.3.0] - 2026-01-22

### Changed
- **Renamed `/agv-validator` to `/agnosticv-validator`** for consistency and better discoverability
  - Updated skill name in SKILL.md frontmatter
  - Renamed skill directory: agv-validator → agnosticv-validator
  - Updated all documentation references across repository
  - Updated Cursor rules and trigger phrases
  - Updated install.sh and all setup guides

### Migration
- **Old:** `/agv-validator` → **New:** `/agnosticv-validator`
- All functionality remains the same, only the name has changed
- Both AgnosticV skills now use consistent naming:
  - `/agnosticv-catalog-builder` - Create/update catalogs
  - `/agnosticv-validator` - Validate catalogs

## [v1.2.2] - 2026-01-22

### Changed
- **Comprehensive documentation cleanup** - Removed all references to deprecated skills
  - Updated README.md with unified skill examples and workflows
  - Updated agnosticv/README.md to show new skill prominently
  - Updated all Cursor support files (cursor-rules/, cursor-commands/)
  - Updated all GitHub Pages documentation (setup, reference, skills)
- **Enhanced GitHub Pages docs** for `/agnosticv-catalog-builder`
  - Added detailed question-by-question workflow (17 steps for Mode 1, 6 for Mode 2, 5 for Mode 3)
  - Shows exact questions users will see
  - Includes expected answers and automatic steps
- **Cursor rules updated**
  - Removed old RULE.md files for deprecated skills
  - Created new agnosticv-catalog-builder/RULE.md with all trigger phrases
- **Install script** now shows correct skill names in all messages

### Fixed
- Removed lingering references to `/agv-generator` and `/generate-agv-description` across all documentation
- Updated troubleshooting guides with correct skill names
- Updated quick reference workflows to use unified skill

## [v1.2.1] - 2026-01-22

### Changed
- Renamed `/agv-catalog` to `/agnosticv-catalog-builder` for better discoverability
- Updated all documentation to reference new skill name

## [v1.2.0] - 2026-01-22

### Added
- **New unified `/agnosticv-catalog-builder` skill** - Consolidates `/agv-generator` and `/generate-agv-description`
  - Mode 1: Full Catalog (common.yaml, dev.yaml, description.adoc, info-message-template.adoc)
  - Mode 2: Description Only (extract from Showroom)
  - Mode 3: Info Template (agnosticd_user_info documentation)
  - Built-in git workflow (pull main, create branch without feature/ prefix)
  - Auto-commit functionality

### Changed
- AgnosticV workflow simplified - one skill for all catalog operations
- Git workflow now enforced in all AgnosticV skills (no feature/ prefix)
- Documentation updated to reference unified skill

### Deprecated
- `/agv-generator` - Use `/agnosticv-catalog-builder` Mode 1 instead
- `/generate-agv-description` - Use `/agnosticv-catalog-builder` Mode 2 instead

### Removed
- `/agv-generator` skill directory (replaced by /agnosticv-catalog-builder)
- `/generate-agv-description` skill directory (replaced by /agnosticv-catalog-builder)
- docs/skills/agv-generator.md documentation page (replaced by agnosticv-catalog-builder.md)
- docs/skills/generate-agv-description.md documentation page (replaced by agnosticv-catalog-builder.md)

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

[Unreleased]: https://github.com/rhpds/rhdp-skills-marketplace/compare/v1.2.1...HEAD
[v1.2.1]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.2.1
[v1.2.0]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.2.0
[v1.1.0]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.1.0
[1.0.0]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.0.0
