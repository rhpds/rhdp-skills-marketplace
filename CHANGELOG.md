# Changelog

All notable changes to the RHDP Skills Marketplace will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v1.7.3] - 2026-02-02

### Changed - Updated description.adoc Template to Match Best Practices

**User Feedback:** "agd-v2.vllm-playground-aws.dev this is a good example of description"

**New Template Based on vllm-playground Example:**

Analyzed the vllm-playground catalog description.adoc and updated the skill template to match its excellent structure.

**Key Improvements:**

**Structure Changes:**
- OLD: = Title → Overview → Guide → Products → Agenda → Authors
- NEW: (No title - catalog system generates it) → Overview → Business Outcomes → Demo Options/Lab Duration → Environment → Products → Resources
- Removed title line (= Display Name) - the catalog system auto-generates this from common.yaml

**New Sections:**
1. **Business Outcomes** - What users achieve (business value, not just topics)
2. **Demo Options** - Time-based options for demos (15-20 min, 30-45 min, 60 min)
3. **Lab Duration** - Self-paced vs instructor-led timing for workshops
4. **Environment** - Specific versions and requirements (not mixed with products)
5. **Resources** - Links to guide, repository, documentation

**Writing Guidelines:**
- Start with product name, NOT "This workshop" or "This demo"
- Include business context (ACME Corp, real-world scenarios)
- Business Outcomes = what users achieve, not just learning objectives
- Separate demos (Demo Options) from workshops (Lab Duration)
- Specific version numbers in Environment section
- Use external link markers (^) for resources

**Example Output (Demo):**
```
= VLLM Playground

vLLM Playground is a management interface for deploying and managing vLLM inference servers...

This demo uses ACME Corporation customer scenario...

== Business Outcomes
* Deploy and manage vLLM servers using containers
* Configure structured outputs for reliable system integration
...

== Demo Options
* *15-20 min* - Executive brief (deployment + business value)
* *30-45 min* - Technical demo (structured outputs + tool calling)
...
```

**Example Output (Workshop):**
```
= Ansible Automation Platform with OpenShift AI

Ansible Automation Platform integrates with Red Hat OpenShift AI...

== Business Outcomes
* Integrate Ansible Automation Platform with OpenShift AI
* Build AI models for infrastructure decision-making
...

== Lab Duration
* *Self-paced*: 90 minutes
* *Instructor-led*: 2-3 hours
```

**Files Updated:**
- agnosticv/skills/agnosticv-catalog-builder/SKILL.md (Step 10.3 template)
- Added two complete examples (demo and workshop)
- Added key guidelines section

### Focus
This release improves description.adoc quality by using the proven vllm-playground format, which better communicates business value and provides flexible demo/workshop timing options.

## [v1.7.2] - 2026-02-02

### Added - Mode 2 Manual Entry Fallback

**User Request:** "Add fallback if showroom is not given"

**New Feature: Manual Entry Option for Mode 2**

When Showroom content is not available, Mode 2 now offers three choices:

**Step 1 Enhancement:**
- OLD: Exit with error if no Showroom found
- NEW: Offer 3 options when Showroom not found:
  1. Enter description details manually
  2. Create Showroom content first and come back
  3. Exit and use Mode 1 (Full Catalog) instead

**New Step 1a: Manual Entry Flow**

When user chooses manual entry, the skill asks for:
- Catalog display name
- Brief overview (2-3 sentences)
- Featured Red Hat products/technologies with versions
- Module/chapter titles (multi-line input)
- Optional: Author name (defaults to git config)
- Optional: GitHub Pages URL
- Optional: Warnings or special requirements

**Review and Confirmation:**
Shows all manually entered data for review before generating description.adoc

**Workflow:**
```
If Showroom found:
  → Step 2: Extract from ALL modules (v1.7.1 behavior)
  → Step 3: Review and confirm

If NO Showroom:
  → Step 1a: Manual entry
  → Step 3: Review manually entered data and confirm
  → Both paths converge at description.adoc generation
```

**Benefits:**
- Mode 2 works without Showroom content
- Users can create description.adoc before workshop content exists
- Supports early catalog planning
- Still validates and shows all data before generating

**Files Updated:**
- agnosticv/skills/agnosticv-catalog-builder/SKILL.md (Step 1, 1a, 2, 3 modified)
- Added HAS_SHOWROOM variable to track source
- Step 2 now conditional (only runs if Showroom exists)
- Step 3 handles both extraction and manual entry

### Focus
This patch adds flexibility to Mode 2 by supporting manual entry when Showroom content is not available, while maintaining the smart extraction workflow when Showroom exists.

## [v1.7.1] - 2026-02-02

### Fixed - AgnosticV Catalog Builder Mode 2 Improvements

**User Feedback Addressed:**
- "It asks lot of questions, like if I give showroom why it is asking for summary again"
- "Product detection was little bit wrong"
- "Sometimes you do not read all the modules"

**Mode 2 (Description Only) Enhancements:**

**Smart Content Extraction:**
- Now reads ALL module files, not just index.adoc
- Combines content from entire workshop for comprehensive analysis
- Extracts overview from index.adoc automatically
- Shows all extracted data before asking for confirmation

**Before:**
```
Q: Brief overview (2-3 sentences, starting with product name):
Overview: [user has to type even though it's in Showroom]
```

**After:**
```
I've read ALL 5 modules and extracted the following:

Overview (from index.adoc):
[Automatically extracted content]

Q: Is this overview accurate? [Y to use as-is / N to provide custom]:
```

**Improved Product Detection:**
- OLD: grep for generic keywords (OpenShift, Ansible, AAP)
- NEW: grep for full Red Hat product names with versions
  - Red Hat OpenShift AI, Virtualization, GitOps, Pipelines, Data Foundation
  - Ansible Automation Platform, Ansible AI
  - Red Hat Enterprise Linux / RHEL 9
  - Red Hat Advanced Cluster Security, Quay, Service Mesh
  - Kubernetes version detection added

**Comprehensive Module Reading:**
- Reads ALL .adoc files: `cat pages/*.adoc`
- Extracts from combined content, not individual files
- Shows all module titles with filenames for verification
- Detects products/versions/topics across entire workshop

**What Gets Extracted from ALL Modules:**
- Module titles and structure
- Red Hat product names
- Version numbers (OpenShift 4.14, AAP 2.5, etc.)
- Technical topics (GitOps, CI/CD, Operators, Helm, etc.)
- Learning objectives

**User Experience:**
- Less repetitive questions
- More intelligent extraction
- Shows comprehensive data before asking
- Only asks for custom input if user says "No"
- Transparent about what modules were analyzed

**Files Updated:**
- agnosticv/skills/agnosticv-catalog-builder/SKILL.md (Mode 2 workflow, lines 1092-1252)
- Step 2: Read ALL modules and combine content
- Step 3: Show comprehensive extracted data with Y/N confirmation

### Focus
This patch release significantly improves Mode 2 (Description Only) by reading all workshop modules instead of just the overview, using smarter product detection, and reducing repetitive questions by extracting content from Showroom automatically.

## [v1.7.0] - 2026-01-28

### Changed - Full Cursor 2.4+ Support via Agent Skills Standard

**Installation Paths:**
- **Claude Code / VS Code with Claude**: Skills installed to `~/.claude/skills/`, docs to `~/.claude/docs/`
- **Cursor 2.4+**: Skills installed to `~/.cursor/skills/`, docs to `~/.cursor/docs/`
- Both platforms support auto-discovery from these standard directories
- Optional: Showroom namespace also installs templates to `~/.claude/templates/`, prompts to `~/.claude/prompts/`, and agents to `~/.claude/agents/`

**Cursor Platform Updates:**
- Removed "experimental" warnings from all documentation
- Updated to reflect Cursor 2.4+ native support for Agent Skills open standard
- Changed install.sh prompt from "Experimental" to "Cursor 2.4+"
- Updated success messages to reflect native auto-discovery from `~/.cursor/skills/`
- Made project-level `.cursor/rules/` installation optional (auto-discovery is primary method)

**Documentation Updates:**
- Completely rewrote `docs/setup/cursor.md` for Cursor 2.4+ support
  - Added prerequisites (Cursor 2.4.0+)
  - Added verification instructions (Cmd+Shift+J → Rules → Agent Decides)
  - Added "How It Works" section explaining Agent Skills standard
  - Added platform comparison table (Claude Code vs Cursor 2.4+)
  - Removed experimental warnings and workarounds
- Updated `docs/index.md` to remove experimental notice
- Updated `docs/setup/index.md` to show Cursor 2.4+ as fully supported
- Updated main `README.md`:
  - Changed platform list to include "Cursor 2.4+" without experimental notice
  - Rewrote Cursor section with native support instructions
  - Added Agent Skills standard references with link to agentskills.io
  - Removed experimental warnings and "still testing" notices

**Install Script Updates (install.sh):**
- Line 55: Changed help text from "cursor - Cursor IDE (experimental)" to "cursor - Cursor IDE (2.4+)"
- Line 99: Changed prompt from "2) Cursor (Experimental - Still testing)" to "2) Cursor 2.4+"
- Lines 495-518: Completely rewrote Cursor success message:
  - Removed experimental warnings
  - Added native Agent Skills support messaging
  - Updated instructions to use Cmd+Shift+J settings view
  - Added reference to agentskills.io open standard
  - Removed workaround instructions
- Lines 418-454: Updated Cursor rules installation to be optional
  - Added explanation that Cursor 2.4+ auto-discovers from `~/.cursor/skills/`
  - Made project-level rules optional with user prompt
  - Clarified that auto-discovery is the primary method

**Agent Skills Standard:**
- All platforms (Claude Code, VS Code with Claude, Cursor 2.4+) now support the Agent Skills open standard
- Skills are auto-discovered from standard directories:
  - **Claude Code / VS Code with Claude**: `~/.claude/skills/` and `~/.claude/docs/`
  - **Cursor 2.4+**: `~/.cursor/skills/` and `~/.cursor/docs/`
- Progressive loading keeps context efficient
- Skills work with both `/skill-name` explicit invocation and natural language

**Impact:**
- Cursor users no longer see experimental warnings
- Clear instructions for Cursor 2.4+ users
- Both platforms have equal status and support
- Documentation reflects production-ready Cursor support

**Files Updated:**
- install.sh (4 sections: help text, prompts, success messages, rules installation)
- docs/setup/cursor.md (complete rewrite for 2.4+ support)
- docs/index.md (removed experimental notice)
- docs/setup/index.md (updated platform card)
- README.md (updated Cursor section and platform support notice)
- VERSION (bumped to v1.7.0)

### Focus
This release brings Cursor support to production-ready status with native Agent Skills standard support in Cursor 2.4+. No more experimental warnings or workarounds - both Claude Code and Cursor 2.4+ are first-class supported platforms.

## [v1.6.1] - 2026-01-23

### Fixed - Install and Update Scripts Simplified

**Non-Interactive Installation:**
- Removed unnecessary confirmation prompts from install.sh
- Removed "Continue? [Y/n]" prompt - if user runs the script, they want to install
- Removed --force flag entirely (unnecessary complexity)
- Scripts now work properly when piped from curl

**Automatic Updates:**
- update.sh now automatically updates without asking "Would you like to update now?"
- Removed --force flag from update.sh
- Update script detects namespace from existing installation
- Shows changelog and immediately updates

**Impact:**
- `curl ... | bash` patterns work reliably
- No `/dev/tty` errors in non-interactive environments
- Cleaner, simpler user experience
- Scripts do what users expect without extra prompts

**Files Updated:**
- install.sh (removed FORCE variable, removed confirmation prompt, simplified help text)
- update.sh (removed FORCE variable, removed confirmation prompt, auto-updates)
- VERSION (bumped to v1.6.1)

### Focus
This patch release fixes the installation and update experience by removing unnecessary prompts and complexity. Scripts now "just work" when run.

## [v1.6.0] - 2026-01-23

### Added - Templates, Prompts, and Agents for Showroom Skills

**Critical Infrastructure for Skills:**
- Added templates/ directory with demo and workshop templates
- Added prompts/ directory with verification and quality control prompts
- Added agents/ directory with specialized content creation agents
- Updated install.sh to automatically install these resources to ~/.claude/

**Templates Added (showroom/templates/):**
- **Demo templates**: 7 AsciiDoc templates (index, overview, details, 3 modules, conclusion)
- **Workshop templates**: Conclusion template + examples + learner/facilitator templates
- Templates are used by `/create-lab` and `/create-demo` skills for consistent content generation

**Prompts Added (showroom/prompts/):**
- `enhanced_verification_demo.txt` - Comprehensive demo quality checklist
- `enhanced_verification_workshop.txt` - Comprehensive workshop quality checklist
- `redhat_style_guide_validation.txt` - Red Hat style and branding rules
- `verify_accessibility_compliance_demo.txt` - Demo accessibility requirements
- `verify_accessibility_compliance_workshop.txt` - Workshop accessibility requirements
- `verify_accessibility_compliance.txt` - General accessibility standards
- `verify_content_quality.txt` - Content quality and pedagogical standards
- `verify_technical_accuracy_demo.txt` - Technical accuracy for demos
- `verify_technical_accuracy_workshop.txt` - Technical accuracy for workshops
- `verify_workshop_structure.txt` - Workshop structure requirements
- Total: 10 verification prompts for automated quality control

**Agents Added (showroom/agents/):**
- `accessibility-checker.md` - Validates WCAG compliance and accessibility
- `content-converter.md` - Converts between content formats
- `migration-assistant.md` - Helps migrate content to Showroom format
- `researcher.md` - Researches technical topics for accuracy
- `style-enforcer.md` - Enforces Red Hat style guidelines
- `technical-editor.md` - Reviews technical accuracy
- `technical-writer.md` - Assists with technical writing
- `workshop-reviewer.md` - Reviews workshop content quality
- Total: 8 specialized agents for content creation and verification

**Installation Behavior:**
- Templates, prompts, and agents are installed to `~/.claude/` (global)
- Only installed when showroom namespace is selected
- Backup functionality: Creates `.backup-TIMESTAMP/` before overwriting
- Skills can use local `.claude/` in git repos or global `~/.claude/` in home directory
- Dry-run mode shows what would be installed without making changes

**Impact:**
- `/create-lab` and `/create-demo` skills now work properly with templates
- `/verify-content` skill can use verification prompts for quality control
- Skills generate higher quality content using standardized templates
- Automated quality checks ensure Red Hat standards compliance
- Content creators get consistent, professional output
- Fixes errors where skills tried to read non-existent template files

**Source:**
- Templates, prompts, and agents sourced from proven showroom_template_nookbag repository
- Battle-tested in production Showroom content creation workflows
- Represents best practices from Red Hat Demo Platform team

**Files Added:**
- showroom/templates/demo/ (7 files)
- showroom/templates/workshop/ (3 directories with multiple templates)
- showroom/prompts/ (10 .txt files)
- showroom/agents/ (8 .md files)
- install.sh (updated to install templates, prompts, agents)

### Focus
This release adds essential infrastructure (templates, prompts, agents) that the showroom skills depend on. Without these files, skills would fail when trying to read templates or apply verification criteria. This is a critical update for anyone using `/create-lab`, `/create-demo`, or `/verify-content` skills.

## [v1.5.8] - 2026-01-23

### Fixed - Install Script & Refactored AGV Documentation

**Install/Update Script Fixes:**
- Fixed install.sh to properly override existing skills during updates
- Added backup functionality before overwriting (creates .backup-TIMESTAMP/)
- Skills and docs now correctly update when running update.sh
- Previously, `cp -r` without `-f` flag didn't force overwrite existing directories
- Now removes old files after backing them up to ensure clean installation

**Refactored AGV-COMMON-RULES.md:**
- Removed showroom-specific sections (lines 1-144) that caused unwanted AgV questions
- Preserved valuable AgV technical documentation (1208 lines of content)
- Changed scope from "Applies to: `/create-lab` and `/create-demo`" to "Applies to: `/agnosticv-catalog-builder` and `/agnosticv-validator`"
- File now serves as technical reference for AgV skills only
- Original file backed up to .archive/AGV-COMMON-RULES.md.backup-20260123
- Updated agnosticv-catalog-builder and agnosticv-validator SKILL.md to reference refactored file

**Content Preserved:**
- Access Check Protocol
- Catalog Search procedures
- Infrastructure Selection rules (CNV, SNO, AWS, CNV VMs)
- Workload Selection mappings
- Git Workflow patterns
- UUID Generation and collision detection
- Config File Generation templates
- UserInfo Variable Extraction patterns

**Impact:**
- Users running update.sh will now get the actual latest skill files
- No more stale skills after updates
- No more unwanted AgV questions in showroom skills
- AgV technical documentation preserved for agnosticv-catalog-builder and agnosticv-validator
- Cleaner, more predictable update experience

**Files Updated:**
- install.sh (added backup+override logic for skills and docs)
- agnosticv/docs/AGV-COMMON-RULES.md (refactored: removed lines 1-144, kept 1208 lines of technical content)
- agnosticv/skills/agnosticv-catalog-builder/SKILL.md (updated reference)
- agnosticv/skills/agnosticv-validator/SKILL.md (updated reference)

### Focus
This release fixes the update mechanism to ensure users get the latest versions, and refactors AGV-COMMON-RULES.md to remove showroom-specific workflow while preserving valuable AgV technical documentation.

## [v1.5.7] - 2026-01-23

### Changed - Removed AgnosticV Questions from Showroom Skills

**Simplified Skill Workflow:**
- Removed AgnosticV catalog workflow questions from create-lab skill
- Removed AgnosticV catalog workflow questions from create-demo skill
- Skills now focus solely on content creation without infrastructure provisioning interruptions
- Cleaned up 7 references in create-lab/SKILL.md
- Cleaned up 4 references in create-demo/SKILL.md

**Impact:**
- Skills no longer ask "Do you need help with AgnosticV catalog files?"
- Workflow proceeds directly from story planning (Step 2) to module details (Step 3)
- Users who need AgV setup use /agnosticv-catalog-builder separately
- Cleaner, more focused content creation experience

**Files Updated:**
- showroom/skills/create-lab/SKILL.md (42 insertions, 59 deletions)
- showroom/skills/create-demo/SKILL.md (42 insertions, 42 deletions)

### Focus
This release streamlines the showroom content creation workflow by removing infrastructure provisioning questions, allowing users to focus purely on creating lab and demo content.

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

[Unreleased]: https://github.com/rhpds/rhdp-skills-marketplace/compare/v1.7.3...HEAD
[v1.7.3]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.7.3
[v1.7.2]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.7.2
[v1.7.1]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.7.1
[v1.7.0]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.7.0
[v1.6.1]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.6.1
[v1.6.0]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.6.0
[v1.5.8]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.5.8
[v1.5.7]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/v1.5.7
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
