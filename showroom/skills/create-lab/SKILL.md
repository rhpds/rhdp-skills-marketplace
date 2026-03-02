---
name: showroom:create-lab
description: This skill should be used when the user asks to "create a lab module", "write a workshop module", "build a Showroom lab", "convert docs to a lab", "write a hands-on exercise", "create an AsciiDoc module", or "turn this documentation into a lab exercise".
---

---
context: main
model: claude-opus-4-6
---

# Lab Module Generator

Guide you through creating a single Red Hat Showroom workshop module from reference materials (URLs, files, docs, or text) with business storytelling and proper AsciiDoc formatting.

## Workflow Diagram

![Workflow](workflow.svg)

## What You'll Need Before Starting

Have these ready before running this skill:

**Required:**
- 📁 **Target directory path** - Where to create modules (default: `content/modules/ROOT/pages/`)
- 📚 **Reference materials** - At least one of:
  - URLs to documentation, blogs, or guides
  - Local files with technical content
  - Text/notes describing what to build
- 🎯 **Learning objective** - What should learners accomplish?

**Helpful to have:**
- 🏢 **Company/scenario context** - Business story for the lab (e.g., "ACME Corp needs...")
- ⏱️ **Target duration** - How long should this module take? (e.g., 15 min, 30 min)
- 👥 **Audience level** - Beginner, Intermediate, or Advanced
- 📝 **Previous modules** - If continuing existing lab, know which module comes before this one

**Access needed:**
- ✅ Write permissions to the Showroom repository directory


## Shared Rules

See @showroom/docs/SKILL-COMMON-RULES.md for:
- Version pinning and attribute placeholders (REQUIRED)
- Reference enforcement (REQUIRED)
- Attribute file location and standard attributes (REQUIRED)
- AsciiDoc list formatting rules (REQUIRED)
- Image path conventions and clickable image syntax (REQUIRED)
- Navigation update expectations (REQUIRED)
- Failure-mode behavior patterns (REQUIRED)
- Quality gate integration
- Verification prompt file lists

## Arguments (Optional)

This skill supports optional command-line arguments for faster workflows.

**Usage Examples**:
```bash
/create-lab                                    # Interactive mode (asks all questions)
/create-lab <directory>                        # Specify target directory
/create-lab <directory> --new                  # Create new lab in directory
/create-lab <directory> --continue <module>    # Continue from specific module
```

**Parameters**:
- `<directory>` - Target directory for module files
  - Example: `/create-lab content/modules/ROOT/pages/`
  - If not provided, defaults to `content/modules/ROOT/pages/`
- `--new` - Flag to create new lab (generates index + overview + details + module-01)
- `--continue <module-path>` - Continue from specified previous module
  - Example: `/create-lab content/modules/ROOT/pages/ --continue content/modules/ROOT/pages/03-module-01-intro.adoc`
  - Reads previous module to detect story continuity

**How Arguments Work**:
- Arguments skip certain questions (faster workflow)
- You can still use interactive mode by calling `/create-lab` with no arguments
- Arguments are validated before use

## Workflow

**CRITICAL RULES**

### 1. Ask Questions SEQUENTIALLY

- Ask ONE question or ONE group of related questions at a time
- WAIT for user's answer before proceeding
- Do NOT ask questions from multiple steps together
- Do NOT skip workflows based on incomplete answers

### 2. File Generation Order (First Module ONLY)

**If this is the FIRST module of a NEW lab, you MUST generate files in this EXACT order:**

1. **index.adoc** - Learner landing page (NOT facilitator guide)
2. **01-overview.adoc** - Business scenario and learning objectives
3. **02-details.adoc** - Technical requirements and setup
4. **03-module-01-*.adoc** - First hands-on module

**NEVER skip index/overview/details for first module!**

**File naming convention**:
- index.adoc (no number prefix)
- 01-overview.adoc
- 02-details.adoc
- 03-module-01-*.adoc
- 04-module-02-*.adoc
- 05-module-03-*.adoc
- etc.

**If continuing existing lab**:
- Detect next file number from existing modules
- Generate: 0X-module-YY-*.adoc (where X = next sequential file number)
- Example: If existing has 03-module-01, 04-module-02, next is 05-module-03
- Skip index/overview/details (already exist)

### 3. Manage Output Tokens

- **NEVER output full module content** - Use Write tool to create files
- **Show brief confirmations only** - "✅ Created: filename (X lines)"
- **Keep total output under 5000 tokens** - Summaries, not content
- **Files are written, not displayed** - User reviews with their editor
- **Token limit**: Claude Code has 32000 token output limit - stay well below it

**Example of WRONG approach**:
```
❌ Asking all at once:
1. Module file name?
2. UserInfo variables?
3. Learning objective?
4. Number of exercises?
```

**Example of CORRECT approach**:
```
✅ Ask sequentially:
Step 2: Complete overall lab story planning
[WAIT for completion]

Step 3.1: Module file name?
[WAIT for answer]

Step 3.2: Reference materials?
[WAIT for answer]

etc.
```

---

### Step 1: Parse Arguments (If Provided)

**Check if user invoked skill with arguments**.

**Pattern 1: `/create-lab <directory> --new`**
```
Parsing arguments: "<directory> --new"

✓ Target directory: <directory>
✓ Mode: Create new lab
✓ Will generate: index.adoc → 01-overview → 02-details → 03-module-01

Validating directory...
[Check if directory exists, create if needed]

Skipping: Step 1 (mode already known: NEW lab)
Proceeding to: Step 2 (Plan Overall Lab Story)
```

**Pattern 2: `/create-lab <directory> --continue <module-path>`**
```
Parsing arguments: "<directory> --continue <module-path>"

✓ Target directory: <directory>
✓ Mode: Continue existing lab
✓ Previous module: <module-path>

Validating directory...
[Check if directory exists]

Reading previous module: <module-path>
[Extract story, company, progression]

Skipping: Step 1 (mode already known: CONTINUE)
Skipping: Step 2 (story detected from previous module)
Proceeding to: Step 3 (Module-Specific Details)
```

**Pattern 3: `/create-lab <directory>`**
```
Parsing arguments: "<directory>"

✓ Target directory: <directory>

Validating directory...
[Check if directory exists]

Skipping: Target directory question
Proceeding to: Step 1 (still need to ask: new vs continue)
```

**Pattern 4: `/create-lab` (no arguments)**
```
No arguments provided.

Using interactive mode.
Target directory: Will use default (content/modules/ROOT/pages/)

Proceeding to: Step 1 (Determine Context)
```

**Argument Validation**:
- If directory doesn't exist, ask user: "Directory not found. Create it? [Yes/No]"
- If `--continue` but module path invalid, fall back to asking for story recap
- All arguments are optional - skill always works in interactive mode

---

### Step 2: Determine Context (New Lab vs Existing Lab)

**SKIP THIS STEP IF**:
- User provided `--new` flag in arguments (already know: NEW lab)
- User provided `--continue <module>` in arguments (already know: EXISTING lab)

**CRITICAL: DO NOT read any files or make assumptions before asking this question!**

**First, ask the user**:

```
Welcome! Let's create your workshop together.

Are you starting a brand new lab or adding to an existing one?

1. 🆕 NEW lab (I'll create the whole thing: index → overview → details → first module)
2. ➕ EXISTING lab (I'll add the next module and continue your story)
3. 🤔 Something else (tell me what you need)

What's your situation? [1/2/3]
```

**ONLY AFTER user answers, proceed based on their response.**

### Step 2.5: Ask for Showroom Repository Path (if not provided as argument)

**SKIP THIS STEP IF**: User provided `<directory>` as argument

**Ask the user**:
```
What is the path to your cloned Showroom repository?

The RHDP team will have provided you with a Showroom repository to clone.
Provide the local path to that cloned repo.

Example: /Users/yourname/work/showroom-content/my-lab-showroom

Repo path:
```

Use `content/modules/ROOT/pages/` within that path as the target for lab files.

**If option 1 (NEW lab)**:
- Generate ALL workshop files: index.adoc, 01-overview.adoc, 02-details.adoc, 03-module-01-*.adoc
- Proceed to Step 2 (Plan Overall Lab Story)

**If option 2 (EXISTING lab)**:
- Detect next file number from existing modules
- Generate ONLY next module: 0X-module-YY-*.adoc
- Skip Step 2 (already have overall story)
- Ask for previous module path or story recap

**If continuing existing lab**:
- Option 1: Provide path to previous module (I'll read and auto-detect story)
- Option 2: If previous module not available, I'll ask for story recap:
  - Company name and scenario
  - What was completed in previous modules
  - Current learning state
  - What comes next in progression

**Fallback behavior**:
- If user says "continuing" but cannot provide previous module content or workspace access:
  - Ask user to paste content of last module (or key sections)
  - OR ask short "Story Recap" questions:
    1. Company/scenario name?
    2. What topics were covered in previous modules?
    3. What skills have learners gained so far?
    4. What's the current state in the story?
  - This prevents broken continuity

### Step 3: Plan Overall Lab Story (if first module)

Awesome! Let's design your workshop together. I'll ask you some questions to build the perfect learning experience.

**IMPORTANT**: Ask these as **conversational, open-ended questions**. Do NOT provide multiple choice options.

**Question 1 - What Should We Call This?**:
```
What's the name of your workshop?

Example: "Building AI/ML Workloads on OpenShift AI"

I'll use this to set up your lab title and generate a clean URL-friendly slug.

Your lab name:

[After user provides title, I'll suggest a slug like "building-ai-ml-workloads-openshift-ai"]
```

**Question 2 - The Learning Goal**:
```
What's the main goal of this lab?

What should learners be able to do when they finish?

Example: "Learn to build and deploy AI/ML workloads on OpenShift AI"

Your lab goal:
```

**Question 3 - Who's Learning?**:
```
Who is this lab designed for?

Examples: Developers, Architects, SREs, Data Scientists, Platform Engineers

Your target audience:

What's their experience level?
- Beginner (new to the technology)
- Intermediate (some hands-on experience)
- Advanced (production experience)

Their level:
```

**Question 4 - The Learning Journey**:
```
By the end of this lab, what should learners understand and be able to do?

List the key skills they'll gain:

Your learning outcomes:
```

**Question 5 - Make It Real**:
```
What company or business scenario should we use to make this relatable?

Examples: "ACME Corp", "RetailCo", "FinTech Solutions"
Or create your own!

Company name:

What business challenge are they facing that drives this learning?

Their challenge:
```

**Question 6 - How Long?**:
```
How much time should learners budget for the complete lab?

Typical options: 30min, 1hr, 2hr

Your target duration:
```

**Question 7 - Technical Environment**:
```
Let's nail down the technical details:

OpenShift version? (e.g., "4.18", "4.20", or I can use {ocp_version} placeholder)

Product versions? (e.g., "OpenShift Pipelines 1.12, OpenShift AI 2.8")

Cluster type? (SNO or multinode)

Access level? (admin only, or multi-user with keycloak/htpasswd)

Your environment details:

Note: If you're not sure, I'll use placeholders that work across versions.
```

**Then I'll recommend**:
- Suggested module breakdown (how many modules, what each covers)
- Progressive learning flow (foundational → intermediate → advanced)
- Story arc across modules
- Key milestones and checkpoints

**You can**:
- Accept the recommended flow
- Adjust module count and topics
- Change the progression

### Step 3.1: Showroom Setup (Recommended for new labs)

**For NEW labs only. Skip if adding a module to an existing lab.**

Two files to create or fix:
1. **`site.yml`** (repo root) — correct title and ui-bundle theme URL. If `default-site.yml` exists → rename to `site.yml` + update `.github/workflows/gh-pages.yml` reference.
2. **`ui-config.yml`** (repo root) — split view enabled (`view_switcher.enabled: true`, `default_mode: split`) and correct tabs for OCP or VM

Ask OCP vs VM type first (OCP needs `ocp4_workload_ocp_console_embed` + `ocp4_workload_showroom`; VM needs `vm_workload_showroom`), then which consoles to embed.

→ Full questions, file templates, AgnosticV workload vars: `@showroom/skills/create-lab/references/showroom-scaffold.md`

---

### Step 4: Gather Module-Specific Details

Now for this specific module:

1. **Module file name and numbering**:
   - **Naming convention**: `0X-module-YY-<slug>.adoc` (e.g., `03-module-01-pipelines-intro.adoc`)
   - **Title convention**: `= Module X: <Title>` (e.g., `= Module 1: Pipeline Fundamentals`)
   - Files go in `content/modules/ROOT/pages/`
   - **Number prefix**: 03 for first module, 04 for second, etc. (after 01-overview, 02-details)
   - **Conflict detection**: If file exists, suggest next available number
   - **Warning**: Don't overwrite existing modules without confirmation

2. **Reference materials** (optional but recommended):
   - URLs to Red Hat product documentation
   - Local file paths (Markdown, AsciiDoc, text, PDF)
   - Pasted content
   - **Better references = better content quality**
   - If not provided: Generate from templates and common patterns

3. **UserInfo variables** (optional, for accurate showroom content):
   - **I must ask the user:**

   ```
   Q: Do you have access to a deployed environment on demo.redhat.com or integration.demo.redhat.com?

   If YES (RECOMMENDED - easiest and most accurate):
   Please share the UserInfo variables from your deployed service:

   1. Login to https://demo.redhat.com (or integration.demo.redhat.com)
   2. Go to "My services" → Your service
   3. Click "Details" tab
   4. Expand "Advanced settings" section
   5. Copy and paste the output here

   This provides exact variable NAMES like:
   - openshift_cluster_console_url
   - openshift_cluster_admin_username
   - gitea_console_url
   - [custom workload variables]

   CRITICAL: I will use these to know WHICH variables exist, NOT to replace them with actual values!
   Variables will stay as placeholders: {openshift_cluster_console_url}
   Showroom replaces these at runtime with actual deployment values.

   If NO:
   Q: Would you like to use placeholder attributes for now?

   If YES:
   I'll use placeholders: {openshift_console_url}, {user}, {password}
   You can update these later when you get Advanced settings.

   If NO (RHDP internal team only):
   I can extract variables from AgnosticV repository if you have it cloned locally.
   This requires AgV path and catalog name.
   Note: Less reliable than Advanced settings.
   ```

4. **Main learning objective**:
   - Example: "Create and run a CI/CD pipeline with Tekton"

5. **Business scenario**:
   - Auto-detect from previous module (if exists)
   - Or ask for company name (default: ACME Corp)

6. **Technology/product focus**:
   - Example: "OpenShift Pipelines", "Podman"

7. **Number of exercises**:
   - Recommended: 2-3

8. **Diagrams, screenshots, or code blocks** (optional):
   - Do you have diagrams, screenshots, or code examples to include?
   - If yes: Provide file paths or paste content
   - I'll save them to `content/modules/ROOT/assets/images/`
   - And reference them properly in AsciiDoc

9. **Troubleshooting section** (optional):
   ```
   Q: Would you like to include a troubleshooting section in this module?

   A troubleshooting section helps learners solve common issues they may encounter.

   Options:
   1. Yes, include troubleshooting (Recommended for production workshops)
   2. No, skip it for now (I'll add it later if needed)

   Your choice? [1/2]
   ```

   **When to recommend "Yes"**:
   - Production-ready workshops
   - Complex technical modules with many potential failure points
   - Modules involving external dependencies (registries, APIs, networks)

   **When "No" is acceptable**:
   - Simple introductory modules
   - Proof-of-concept content
   - Modules with very straightforward steps

### Step 5: UserInfo Variables

UserInfo variables are collected in Step 4, item 3. If skipped there, use placeholder attributes (`{openshift_console_url}`, `{user}`, `{password}`) and proceed.

### Step 6: Handle Diagrams, Screenshots, and Code Blocks (if provided)

If you provided visual assets or code:

**For images (diagrams, screenshots)**:

See @showroom/docs/SKILL-COMMON-RULES.md for image path conventions and clickable image syntax.

**For code blocks**:
- If you provide code snippets: Format them in AsciiDoc
- Detect language (bash, yaml, python, etc.)
- Add proper syntax highlighting:
  ```asciidoc
  [source,bash]
  ----
  oc create deployment my-app --image=myimage:latest
  ----
  ```


### Step 7: Fetch and Analyze References

Based on your references, I'll:
- Fetch URLs with WebFetch
- Read local files (supports PDF)
- Extract procedures, commands, concepts
- Identify hands-on opportunities
- Combine with AgnosticV variables (if provided)
- Integrate provided code blocks and diagrams

**Reference Enforcement**:

See @showroom/docs/SKILL-COMMON-RULES.md for reference enforcement patterns.

**Reference Tracking** (for conclusion generation):
- Track all references used across all modules
- Store reference URLs, titles, and which modules used them
- References will be consolidated in the conclusion module, NOT in individual modules
- Each module can cite sources inline (e.g., "According to the Red Hat documentation...") but the formal References section will only appear in the conclusion

**IMPORTANT: External Link Format**:
- ALL external links MUST use `^` caret to open in new tab
- Format: `link:https://example.com[Link Text^]`
- The `^` ensures users don't lose their place in the workshop
- Internal xrefs (module navigation) should NOT use `^`
- Examples:
  - External: `link:https://docs.redhat.com/...[Red Hat Documentation^]`
  - Internal: `xref:03-module-02-next.adoc[Next Module]` (no caret)

### Step 8: Read Templates and Verification Criteria (BEFORE Generating)

**CRITICAL: Read templates BEFORE generating any content.**

**Template source — check the Showroom repo first:**

The user's Showroom repo may contain a `templates/` directory with up-to-date patterns. Always prefer these over the marketplace's built-in templates.

```bash
# Check if user's Showroom repo has templates
ls {showroom_repo_path}/examples/workshop/templates/ # if exists use examples/ 2>/dev/null
```

**If `examples/workshop/templates/` exists in the Showroom repo — read from there:**
- `{showroom_repo_path}/examples/workshop/templates/index.adoc` — **Learner-facing index** (output as `index.adoc`)
- `{showroom_repo_path}/examples/workshop/templates/03-module-01.adoc` — Module template
- `{showroom_repo_path}/examples/workshop/example/01-overview.adoc` — Overview example
- `{showroom_repo_path}/examples/workshop/example/02-details.adoc` — Details example
- `{showroom_repo_path}/examples/workshop/example/03-module-01.adoc` — Module example

**If `examples/workshop/templates/` does NOT exist — use bundled plugin templates:**
- `@showroom/templates/workshop/templates/00-index-learner.adoc` — Learner-facing index
- `@showroom/templates/workshop/templates/03-module-01.adoc` — Module template
- `@showroom/templates/workshop/example/01-overview.adoc` — Filled overview example
- `@showroom/templates/workshop/example/02-details.adoc` — Filled details example
- `@showroom/templates/workshop/example/03-module-01.adoc` — Filled module example
- `@showroom/templates/workshop/templates/README-TEMPLATE-GUIDE.adoc` — Storytelling patterns

**Key rules from the templates:**
- Workshop `index.adoc` is **learner-facing** — NOT a facilitator guide (use `index.adoc` template, output as `index.adoc`)
- Modules use numbered exercises with verification checkpoints


The user's `examples/` directory reflects the latest nookbag patterns and may be more current than the marketplace copies. Always use the repo's own templates when available.

See @showroom/docs/SKILL-COMMON-RULES.md for verification prompt file lists and how to use them.

### Step 9: Generate Files (Using Verification Criteria)

**IMPORTANT: Use the bundled workshop templates read in Step 8 as quality references.**

Apply patterns from the bundled templates to new content:
- Section structure (= Title, == Heading, === Subheading)
- Code block formatting and syntax highlighting
- Admonition usage (TIP, NOTE, WARNING, IMPORTANT)
- Image references (link=self,window=blank)
- List formatting (blank lines before/after)
- External links (^ caret for new tabs)
- Business scenario integration

**CRITICAL: If this is the FIRST module of a NEW lab, generate files in this order:**

#### Step 9.1: Generate index.adoc (First Module Only)

**Purpose**: Learner-facing landing page - NOT a facilitator guide

**Content**:
```asciidoc
= {{ Workshop Title }}

Welcome to the {{ workshop name }} workshop!

== What you'll learn

In this workshop, you will:

* {{ Learning objective 1 }}
* {{ Learning objective 2 }}
* {{ Learning objective 3 }}
* {{ Learning objective 4 }}

== Who this is for

This workshop is designed for {{ target audience }} who want to {{ main goal }}.

== Prerequisites

Before starting this workshop, you should have:

* {{ Prerequisite 1 }}
* {{ Prerequisite 2 }}
* Access to {{ environment/tools }}

== Workshop environment

{{ Brief description of the lab environment }}

* OpenShift cluster: {openshift_console_url}
* Login credentials will be provided

== Let's get started!

Click on the next section to begin the workshop.
```

**What NOT to do**:
- ❌ Don't copy facilitator guide template from workshop/examples/templates/index.adoc
- ❌ Don't include facilitator instructions
- ❌ Don't write "This guide helps workshop facilitators..."

**What TO do**:
- ✅ Write for LEARNERS, not facilitators
- ✅ Simple welcome and what they'll learn
- ✅ Prerequisites and environment info
- ✅ Encouragement to get started

#### Step 9.2: Generate 01-overview.adoc (First Module Only)

**Purpose**: Business scenario and learning objectives

**Content**: See workshop/example/01-overview.adoc for pattern
- Business scenario/story
- Detailed learning objectives
- Expected outcomes
- Estimated time

#### Step 9.3: Generate 02-details.adoc (First Module Only)

**Purpose**: Technical requirements and setup

**Content**: See workshop/example/02-details.adoc for pattern
- Module timing breakdown
- Technical requirements
- Environment details
- Authors/contact

#### Step 9.4: Generate 03-module-01-*.adoc (Always)

I'll create a complete module with:

**CRITICAL: Image Syntax Enforcement**:
Always include `link=self,window=blank` on every image — makes images clickable to open full-size in new tab.

**CRITICAL: AsciiDoc rules** (em dashes, originality, external links, bullets vs numbers):
See `@showroom/skills/create-lab/references/asciidoc-rules.md` for all rules with correct/incorrect examples.

**Required Structure**:
- Learning objectives (3-4 items)
- Business introduction with scenario
- 2-3 progressive exercises
- Step-by-step instructions with commands
- **Verification checkpoints** (REQUIRED - see below)
- Image placeholders
- **Troubleshooting section** (OPTIONAL - if user requested in Step 3, see below)
- **Learning outcomes checkpoint** (REQUIRED - see below)
- Module summary

**Note**: References are NOT included in individual modules. All references will be consolidated in the mandatory conclusion module.

**Mandatory: Verification Checkpoints**:
Each major step must include:
```asciidoc
=== Verify

Run the following to confirm success:

[source,bash]
----
oc get pods
----

Expected output:
----
NAME                     READY   STATUS    RESTARTS   AGE
my-app-xxxxx-xxxxx      1/1     Running   0          2m
----

✓ Pod status is "Running"
✓ READY shows 1/1
```

**Optional: Troubleshooting Section (If Requested)**:
If the user requested troubleshooting in Step 3, include this section:
```asciidoc
== Troubleshooting

**Issue**: Pod stuck in "ImagePullBackOff"
**Solution**:
. Check image name: `oc describe pod <pod-name>`
. Verify registry credentials
. Common fix: `oc set image-lookup <deployment>`

**Issue**: Permission denied errors
**Solution**:
. Verify you're in correct project: `oc project`
. Check RBAC: `oc whoami` and `oc auth can-i create pods`

**Issue**: Command not found
**Solution**:
. Verify OpenShift CLI installed: `oc version`
. Expected version: {ocp_version}
```

**Guidelines for troubleshooting section**:
- Include 3-5 common issues specific to the module's technology
- Provide clear, actionable solutions
- Use real commands and expected outputs
- Tailor scenarios to the module's exercises
- If user declined troubleshooting, skip this section entirely

**Mandatory: Learning Outcomes Checkpoint**:

See @showroom/docs/SKILL-COMMON-RULES.md for Learning Outcomes Checkpoint requirements.

**Optional but Recommended: Cleanup**:
If module changes shared state:
```asciidoc
== Cleanup (Optional)

To reset your environment:

[source,bash]
----
oc delete project my-project
----
```

**Quality**:
- Valid AsciiDoc syntax
- Proper Red Hat product names
- Sentence case headlines
- Second-person narrative
- Code blocks with syntax highlighting

### Step 10: Final Quality Check (Run Agents)

After generating the module, run both review agents:

**1. Ask the workshop-reviewer agent** to validate structure, learning objectives, and hands-on exercise quality:
```
Ask: Review this lab module for structure and learning design quality
```

**2. Ask the style-enforcer agent** to check Red Hat style compliance:
```
Ask: Check this lab module for Red Hat style guide compliance
```

Apply any fixes flagged before delivering. See also @showroom/docs/SKILL-COMMON-RULES.md for quality gate checks (AsciiDoc syntax, navigation, instruction clarity, module sizing).

### Step 11: Update Navigation (REQUIRED)

See @showroom/docs/SKILL-COMMON-RULES.md for navigation update rules and conflict handling.

### Step 12: Deliver

**CRITICAL: Manage Output Tokens to Prevent Overflow**

**Token Management Rules**:
1. **Write files using Write tool** - Don't output full file contents to user
2. **Show brief confirmations only** - "✅ Created: file.adoc (X lines)"
3. **Provide summary at end** - List what was created, not the full content
4. **Never output entire module content** - Files are already written
5. **Keep total output under 5000 tokens** - Brief summaries only

**Output Format for FIRST module**:

```
✅ Workshop Generation Complete

**Files Created**:
- content/modules/ROOT/pages/index.adoc (32 lines) - Learner landing page
- content/modules/ROOT/pages/01-overview.adoc (85 lines) - Business scenario
- content/modules/ROOT/pages/02-details.adoc (67 lines) - Technical details
- content/modules/ROOT/pages/03-module-01-intro.adoc (234 lines) - First hands-on module
- content/modules/ROOT/nav.adoc (updated)
```

**Output Format for CONTINUATION modules**:

```
✅ Module Generation Complete

**Files Created**:
- content/modules/ROOT/pages/04-module-02-advanced.adoc (198 lines)
- content/modules/ROOT/nav.adoc (updated)

**Module Structure**:
- Learning objectives: 4 items
- Exercises: 3
- Verification checkpoints: 3
- Troubleshooting scenarios: 5 (if included)
- Learning outcomes: 4 items

**Assets**:
- Images needed: 2 placeholders (see module for TODO comments)
- Dynamic attributes used: {openshift_console_url}, {user}, {password}

**Next Steps**:
1. Review module: content/modules/ROOT/pages/04-module-02-advanced.adoc
2. Capture screenshots for placeholder images
3. Test commands in your environment
4. Run: verify-content to check quality
5. Create next module: create-lab (continuing existing lab)
6. Enable GitHub Pages (if not done yet): repo Settings → Pages → Source: GitHub Actions

**Note**: All files have been written. Use your editor to review them.
```

**What NOT to do**:
- ❌ Don't show full module content in response
- ❌ Don't output the entire file you just created
- ❌ Don't paste hundreds of lines of generated AsciiDoc
- ❌ Don't include long example sections in output

**What TO do**:
- ✅ Write files using Write tool
- ✅ Show brief "Created: filename (X lines)" confirmations
- ✅ Provide structured summary
- ✅ Give clear next steps
- ✅ Keep output concise (under 5000 tokens)

### Step 13: Generate Conclusion Module (MANDATORY)

After the final module, ask if this is the last module. If YES: read all previous modules to extract learning outcomes and references, then generate a conclusion module (`0X-conclusion.adoc`) consolidating all references from all modules organized by category.

→ Full conclusion template and reference curation workflow: `@showroom/skills/create-lab/references/conclusion-template.md`

## Related Skills


- `/showroom:verify-content` -- Run quality checks on generated content before publishing
- `/showroom:blog-generate` -- Convert workshop modules into blog posts

