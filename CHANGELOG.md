# Changelog

All notable changes to the RHDP Skills Marketplace will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v1.5.6] - 2026-01-22

### Changed - Complete Slack Migration & Credits Update

**Completed Slack Channel Migration:**
- Updated all remaining Slack references across the entire repository
- Added clickable links to #forum-demo-developers in all namespace READMEs
- Updated agnosticv-catalog-builder skill documentation
- Updated scripts (create-release.sh) and command documentation
- Total: 24 references across 10+ files now use correct channel

**Credits Updates:**
- Updated maintainers section: Prakhar Srivastava and Nate Stephany
- Added development team members: Ritesh Shah, Tony Kay, Wolfgang
- Removed position titles (Manager, Catalog Owner) as requested
- Removed Special Thanks section for cleaner credits

**Files Updated:**
- agnosticv/, showroom/, health/, automation/ namespace READMEs
- cursor-rules/, cursor-commands/ READMEs
- scripts/README.md and scripts/create-release.sh
- agnosticv/skills/agnosticv-catalog-builder/SKILL.md
- Main README.md

### Focus
This release completes the comprehensive Slack channel migration across all repository files and updates the project credits to reflect current maintainers and development team.

## [v1.5.5] - 2026-01-22

### Changed - README Slack Channel Update

**Completed Slack Channel Migration:**
- Updated main README.md Slack reference to #forum-demo-developers
- All repository files now use the correct community support channel
- Ensures consistency across documentation and root repository files

### Focus
This release completes the Slack channel migration by updating the main README.md file that was missed in v1.5.4.

## [v1.5.4] - 2026-01-22

### Changed - Slack Channel Updates

**Community Support Channel:**
- Updated all Slack references from `#forum-rhdp` to `#forum-demo-developers`
- Added clickable links to Slack channel (https://redhat.enterprise.slack.com/archives/C04MLMA15MX)
- Updated docs/_config.yml with Slack channel information in site description
- Improved accessibility with direct Slack channel links throughout documentation

**Documentation Files Updated:**
- docs/index.md - Support section
- docs/skills/index.md, ftl.md - Getting Help sections
- docs/reference/glossary.md, quick-reference.md, troubleshooting.md
- docs/setup/index.md, agnosticv.md

**Install Script:**
- Removed `/ftl` from available skills list (correctly marked as coming soon)

### Focus
This release improves community access by providing direct links to the correct Slack support channel and ensures install.sh only lists actually available skills.

## [v1.5.3] - 2026-01-22

### Changed - Documentation Updates

**FTL Skill Status:**
- Marked `/ftl` skill as "Coming Soon" in all documentation
- Moved from available Health skills to Coming Soon section
- Added preview notice to ftl.md documentation page
- Updated skills index with status column showing availability

**User Accessibility:**
- Updated AgnosticV and Health skill labels from "RHDP Team" to "RHDP Team or Advanced Users"
- Clarifies that advanced users can leverage these skills, not just internal team members
- Makes the platform more accessible to power users

### Focus
This release improves documentation accuracy by correctly marking in-development skills as "coming soon" and clarifying that AgnosticV and Health skills are available to advanced users.

## [v1.5.2] - 2026-01-22

### Changed - Showroom Template Reference Update
Updated `/agnosticv-catalog-builder` skill to reference the correct Showroom template:

**Template Change:**
- Changed from `showroom-cookiecutter` to `showroom_template_nookbag`
- Updated repository URL to https://github.com/rhpds/showroom_template_nookbag
- Removed cookiecutter-specific instructions
- Simplified example to directly reference the nookbag template

### Focus
This release ensures users are directed to the correct and currently maintained Showroom template when creating new repositories.

## [v1.5.1] - 2026-01-22

### Changed - AgnosticV Catalog Builder Refinement
Minor refinements to `/agnosticv-catalog-builder`:

**Template Updates:**
- Kept tag variable in common.yaml template (tag: main with override pattern)
- Simplified catalog details questions (Step 8) - removed extra questions about collections and showroom repos
- Maintained focus on core file generation: dev.yaml, common.yaml, description.adoc, info-message-template.adoc

**Validation:**
- Validator already comprehensively checks all core files
- Check 1: File structure (common.yaml required, dev.yaml and description.adoc recommended)
- Check 10: Stage files (dev.yaml purpose validation)
- Check 14: Deployer configuration in common.yaml
- Check 16: AsciiDoc templates (description.adoc and info-message-template.adoc)

### Focus
This release refines the catalog-builder workflow to focus on the 4 core files (dev, common, description, info) while keeping the tag variable pattern for version management.

## [v1.5.0] - 2026-01-22

### Changed - AgnosticV Skills Major Update
Based on analysis of real production catalogs, significantly enhanced both AgnosticV skills:

**`/agnosticv-validator` Enhancements:**
- Added 8 new comprehensive validation checks (total: 17 checks)
- **Check 10:** Stage files validation (dev.yaml, event.yaml, prod.yaml)
- **Check 11:** Multi-user configuration validation (num_users parameter, worker scaling, SalesforceID, workshopLabUiRedirect)
- **Check 12:** Bastion configuration validation (image versions, resource requirements)
- **Check 13:** Collection versions validation (ensures git collections have versions)
- **Check 14:** Deployer configuration validation (scm_url, scm_ref, execution_environment)
- **Check 14a:** Reporting labels validation (primaryBU for business unit tracking - CRITICAL)
- **Check 15:** Component propagation validation (multi-stage catalog data flow)
- **Check 16:** AsciiDoc template validation (variable substitutions)
- Updated category validation to include "Labs" and "Brand_Events"
- **Critical rule:** Demos MUST NOT be multi-user (ERROR level)
- **Critical rule:** Demos MUST NOT have workshopLabUiRedirect enabled (ERROR level)
- **Critical rule:** reportingLabels.primaryBU MUST be present for business unit tracking (ERROR level)
- **New rule:** Multi-user workshops SHOULD enable workshopLabUiRedirect (WARNING level)

**`/agnosticv-catalog-builder` Enhancements:**
- Updated category list to include "Labs" and "Brand_Events"
- Modernized infrastructure selection with CNV pools (agd-v2/ocp-cluster-cnv-pools)
- Added 4th infrastructure option: CNV VMs for RHEL demos and edge appliances
- Updated authentication workloads to use correct collection names (agnosticd.core_workloads)
- Completely rewritten common.yaml template matching 2026 best practices:
  - #include statements for shared configuration
  - Proper __meta__ structure with components and propagate_provision_data
  - Modern worker scaling formulas based on num_users
  - Proper bastion configuration (image, cores, memory)
  - Requirements_content with git collections and versions
  - Tower timeout configuration for complex deployments
  - Deployer configuration with execution_environment
  - **reportingLabels.primaryBU for business unit tracking (CRITICAL)**
- Auto-sets multiuser and workshopLabUiRedirect based on category
- Worker scaling formulas for multi-user catalogs
- Simplified dev.yaml to match real catalog patterns (purpose + scm_ref only)

### Focus
This release brings AgnosticV skills in line with 2026 production catalog standards. All templates and validation rules now match real catalogs deployed in RHDP.

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

[Unreleased]: https://github.com/rhpds/rhdp-skills-marketplace/compare/v1.5.6...HEAD
[v1.5.6]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.5.6
[v1.5.5]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.5.5
[v1.5.4]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.5.4
[v1.5.3]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.5.3
[v1.5.2]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.5.2
[v1.5.1]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.5.1
[v1.5.0]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.5.0
[v1.4.0]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.4.0
[v1.3.1]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.3.1
[v1.3.0]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.3.0
[v1.2.2]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.2.2
[v1.2.1]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.2.1
[v1.2.0]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.2.0
[v1.1.0]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.1.0
[1.0.0]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.0.0
