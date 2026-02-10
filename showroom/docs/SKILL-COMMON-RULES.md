# Skill Common Rules

**Version**: 1.0
**Last Updated**: 2026-01-03

## Purpose

This document defines shared contracts and rules used by all Showroom authoring skills (`/create-lab`, `/create-demo`, `/blog-generate`). These rules prevent drift and ensure consistency across skills.

## Shared Contracts

### 1. Version Pinning or Attribute Placeholders (REQUIRED)

**Rule**: Every module must handle versions explicitly.

**For first module of a lab/demo**:
- Ask:
  - OpenShift version (e.g., 4.18, 4.20)
  - Product versions (e.g., OpenShift Pipelines 1.12, OpenShift AI 2.8)
  - Cluster type (SNO or multinode)
  - Access level (admin only, or multi-user with keycloak/htpasswd)
- If provided: Use in content with attributes (e.g., `{ocp_version}`, `{pipelines_version}`)
- If NOT provided: Use attribute placeholders and avoid version-specific CLI/UI steps

**For subsequent modules**:
- Auto-detect from previous module
- Inherit version scope

**Example**:
```asciidoc
// Good - uses attribute
This lab is tested on OpenShift {ocp_version} with Pipelines {pipelines_version}.

// Bad - hardcoded version (unless explicitly provided by user)
This lab requires OpenShift 4.18 with Pipelines 1.14.
```

**Why**: Prevents "works on my cluster" modules that break in other environments.

---

### 2. Reference Enforcement (REQUIRED)

**Rule**: Every non-trivial claim must be backed by provided references or marked for follow-up.

**Pattern**:
- When making technical claim: Check if reference supports it
- If yes: Continue
- If no: Mark clearly: `**Reference needed**: <claim>`

**Mandatory References Section**:
Every lab/demo module must end with:
```asciidoc
== References

* link:https://docs.openshift.com/...[OpenShift Pipelines documentation] - Pipeline syntax and examples
* link:https://tekton.dev/...[Tekton documentation] - Task definitions
```

**Conflicting References**:
- If references conflict, call out the conflict
- Choose based on version relevance
- Note the decision in module comments

**Why**: Technical accuracy and traceability.

---

### 3. Attribute File Location (REQUIRED)

**Rule**: All reusable variables go in a shared attributes file.

**Location**: `content/modules/ROOT/partials/_attributes.adoc`

**Standard Attributes**:
```asciidoc
:console_url: {openshift_console_url}
:api_url: {openshift_api_url}
:user: {user_name}
:password: {user_password}
:namespace: {project_namespace}
:admin_user: {cluster_admin_user}
:bastion_host: {bastion_public_hostname}
:git_repo: {git_repository_url}
:registry_url: {container_registry_url}
:ocp_version: {openshift_version}
```

**If value unknown**:
- Keep as `{attribute}` placeholder
- List in "Attributes Needed" section at end of module

**Include in every module**:
```asciidoc
include::partial$_attributes.adoc[]
```

**Why**: Makes labs reusable across environments.

---

### 4. AsciiDoc List Formatting (REQUIRED)

**Rule**: All lists must have proper blank lines to render correctly.

**CRITICAL**: Improper list formatting causes text to run together when rendered, making content unreadable.

**Required blank lines**:
1. **Blank line BEFORE the list**
2. **Blank line AFTER the list** (before next content)
3. **Blank line after headings/bold text before lists**

**CORRECT formatting**:
```asciidoc
Some introductory text.

* First list item
* Second list item
* Third list item

Next paragraph or section.
```

**CORRECT with bold heading**:
```asciidoc
**Heading before list:**

* First item
* Second item
* Third item

Next content.
```

**CORRECT with numbered list**:
```asciidoc
Follow these steps:

. Step 1
. Step 2
. Step 3

After the steps, continue with...
```

**INCORRECT formatting** (causes rendering issues):
```asciidoc
❌ BAD:
Some text:* Item 1
* Item 2
Next paragraph

❌ BAD:
**Heading:*** Item 1
* Item 2

❌ BAD:
* Item 1
* Item 2
Next paragraph (no blank line)
```

**Common scenarios that need blank lines**:
- After colons (`:`) before lists
- After bold text (`**Text:**`) before lists
- Between list and next heading
- Between list and next paragraph
- Between different list types (unordered to ordered)

**Nested lists**:
```asciidoc
* Parent item
** Nested item 1
** Nested item 2
* Second parent item
```

**Definition lists** (also need blank lines):
```asciidoc
Term 1::
Description for term 1

Term 2::
Description for term 2

Next content.
```

**Why**: AsciiDoc requires blank lines for proper rendering. Without them, content runs together and becomes unreadable.

---

### 5. Image Path Conventions (REQUIRED)

**Rule**: All images go in the assets/images directory.

**Path**: `content/modules/ROOT/assets/images/`

**Example**:
- Module: `module-01-pipelines-intro.adoc`
- Screenshot: `content/modules/ROOT/assets/images/pipeline-execution-1.png`

**AsciiDoc Syntax** (REQUIRED):
```asciidoc
image::pipeline-execution-1.png[Tekton pipeline showing three tasks executing in sequence,link=self,window=blank,width=700,title="Pipeline Execution in Progress"]
```

**CRITICAL - Clickable Images** (Based on team feedback from Nate Stephany):
- **ALWAYS** include `link=self,window=blank` in image syntax
- This makes images clickable and opens full-size version in new tab
- Details are often too hard to see in inline version
- Users can click to see full resolution without losing their place

**Required for every image**:
1. **Meaningful alt text** (accessibility)
2. **Clickable link** (`link=self,window=blank`)
3. **Width guidance** (500-800px typical, or width=100% for full-width)
4. **Descriptive filename** (no `image1.png`)

**Placeholders**:
If image doesn't exist yet:
```asciidoc
// TODO: Add screenshot
image::create-task-screenshot.png[OpenShift console showing task creation form,link=self,window=blank,width=600,title="Creating a Tekton Task"]
```

**Assets Needed List**:
```asciidoc
== Assets Needed

. `content/modules/ROOT/assets/images/pipeline-execution-1.png` - Screenshot of pipeline running in OpenShift console (clickable full-size)
. `content/modules/ROOT/assets/images/task-definition.png` - YAML editor showing task definition (clickable full-size)
```

**Why**: Accessibility, organization, maintainability.

---

### 6. Navigation Update Expectations (REQUIRED for /create-lab and /create-demo)

**Rule**: nav.adoc update is REQUIRED. Modules won't appear in Showroom without it.

**What to do**:
1. Read existing `content/modules/ROOT/nav.adoc`
2. Maintain sequential ordering of modules
3. Keep `index.adoc` at top if exists
4. Add new module in correct position based on module number

**Pattern**:
```asciidoc
* xref:index.adoc[Home]

* xref:module-01-intro.adoc[Module 1: Introduction]
** xref:module-01-intro.adoc#exercise-1[Exercise 1: Setup]
** xref:module-01-intro.adoc#exercise-2[Exercise 2: First Pipeline]

* xref:module-02-advanced.adoc[Module 2: Advanced Topics]  ← NEW MODULE
** xref:module-02-advanced.adoc#exercise-1[Exercise 1: Git Integration]
```

**Conflict Handling**:
- If module number conflicts with existing file, warn user
- Suggest next available number
- Do NOT overwrite without confirmation

**Why**: Without nav entry, module is invisible in Showroom.

---

## Failure-Mode Behavior

**Rule**: When skill cannot safely proceed, STOP and list blocking issues instead of producing partial content.

### Blocking Conditions

**Missing References**:
- User didn't provide any reference materials
- All provided URLs are inaccessible
- **Action**: Stop and ask for valid references

**Conflicting Versions**:
- References mention different incompatible versions (e.g., OpenShift 4.12 vs 4.16 with breaking changes)
- **Action**: Stop, call out conflict, ask user which version to target

**Incomplete Story for Continuation**:
- User says "continuing existing lab" but:
  - Cannot provide previous module path
  - Cannot paste previous module content
  - Won't answer story recap questions
- **Action**: Stop and explain: "I need previous module context to continue the story"

**Invalid File Paths**:
- User provides non-existent AgnosticV catalog path
- **Action**: Stop, list what was searched, ask for correction

**Navigation Conflicts**:
- Module number already exists in nav.adoc
- User doesn't confirm overwrite or renumber
- **Action**: Stop and list available module numbers

### Failure Response Pattern

```markdown
❌ **Cannot proceed safely**

**Blocking issue**: [specific problem]

**What I need**:
1. [specific fix 1]
2. [specific fix 2]

**Or**: Would you like to proceed with [fallback option]?
```

**Why**: Preserves trust. Partial/guessed content is worse than no content.

---

## Explicit Non-Goals

### What Skills Are NOT Responsible For

**All skills** (`/create-lab`, `/create-demo`, `/blog-generate`):
- ❌ **Provisioning automation**: Skills generate content, not infrastructure
- ❌ **Exact UI pixel accuracy**: Screenshots are placeholders with descriptions
- ❌ **Real-time version checking**: Use provided references, not live docs
- ❌ **Multi-language translation**: English only
- ❌ **Video script generation**: Text-based content only

**`/create-lab` and `/create-demo` specifically**:
- ❌ **Roadmap positioning**: Don't make claims about future product direction
- ❌ **Competitive analysis**: Don't compare to other vendors unless in references
- ❌ **Performance benchmarking**: Don't invent metrics
- ❌ **SLA guarantees**: Don't promise uptime or support levels

**`/blog-generate` specifically**:
- ❌ **SEO keyword stuffing**: Natural language only
- ❌ **Social media posts**: Blog content only, not tweets/LinkedIn
- ❌ **Press release format**: Marketing blog ≠ official PR
- ❌ **Lead generation forms**: Content only, not CTA implementation

**Why**: Prevents scope creep and sets clear expectations.

---

## Skill-Specific Rules

### `/create-lab` - Workshop Module Generator

**Learning Outcomes Checkpoint** (REQUIRED):

Every module must include a "Learning Outcomes" section that confirms pedagogical understanding, not just technical validation.

**Pattern**:
```asciidoc
== Learning Outcomes

By completing this module, you should now understand:

* ✓ How Tekton tasks encapsulate reusable CI/CD steps
* ✓ The relationship between tasks, pipelines, and pipeline runs
* ✓ How to troubleshoot failed pipeline executions using logs and status
* ✓ When to use sequential vs parallel task execution patterns
```

**Guidelines**:
- 3-5 bullet outcomes
- Tied back to original learning objective
- Focus on understanding ("understand how X works") not just doing ("created X")
- Use outcomes later for blog transformation

**Why**: Helps reviewers, instructors, and makes blog generation cleaner.

---

### `/create-demo` - Demo Content Generator

**Slide or Diagram Cue** (OPTIONAL but RECOMMENDED):

Add lightweight visual cues without forcing asset creation.

**Pattern**:
```asciidoc
=== Show

**Optional visual**: Before/after pipeline deployment diagram

* Log into OpenShift Console at {console_url}
* Navigate to Developer perspective
...
```

**Cue Examples**:
- "Optional visual: Architecture diagram showing component relationships"
- "Optional slide: Customer pain points - 6-8 week deployment cycles"
- "Optional visual: Before/after comparison of manual vs automated workflow"

**Guidelines**:
- Always mark as "Optional visual:" or "Optional slide:"
- Don't make demo depend on it
- Helps presenters prepare assets if they want

**Why**: Keeps demos tight without forcing assets. Helps presentation preparation.

---

### `/blog-generate` - Content Transformation

**Source Traceability** (REQUIRED):

Every generated blog must include attribution to prevent over-claiming and confusion.

**Pattern for Red Hat Developer Blog**:
```markdown
---

**About this tutorial**: This post is based on a hands-on workshop created for Red Hat field demonstrations. [Try the full lab on Red Hat Showroom](https://showroom.example.com/...).
```

**Pattern for Internal Blogs**:
```markdown
---

**Source**: Adapted from the "OpenShift Pipelines" demo used in customer technical briefings.
```

**Pattern for Marketing Blogs**:
```markdown
---

**About**: This article is based on technical demonstrations shown at Red Hat Summit and customer events.
```

**Rules**:
- Always include a short "Based on" or "Derived from" note
- Link to full lab if publishing externally
- Use "adapted from" or "based on" language, not "official documentation"
- Place at end of blog post, before tags/metadata

**Why**: Avoids accidental over-claiming, clarifies authoritative docs vs narrative content.

---

## Quality Gate Integration

All skills must pass these gates before delivering content:

**1. AsciiDoc Sanity Checks**:
- ✓ All code blocks have proper syntax: `[source,bash]`
- ✓ No broken includes
- ✓ All attributes defined or listed in "Attributes Needed"
- ✓ Image paths follow convention
- ✓ No unclosed blocks

**2. Navigation Check** (lab/demo only):
- ✓ nav.adoc contains the new module
- ✓ Module numbering is sequential
- ✓ All xrefs are valid

**3. Instruction Clarity Checks**:
- ✓ Each step has a clear reason ("why this matters")
- ✓ Commands are copy/pasteable (no unexplained placeholders)
- ✓ Expected output shown for verification steps
- ✓ Learning outcomes present (lab/demo)
- ✓ Source traceability present (blog)

**4. Module Sizing Check** (lab/demo only):
- ✓ Module targets 20-40 minutes
- ✓ Module has 1-2 major outcomes, not 5
- ✓ If module >50 min estimated, flag for split

**If gates fail**: List specific issues, suggest fixes, allow user to proceed anyway or regenerate.

---

## Shared Templates and Resources

All skills reference these files:

**Templates** (bundled with plugin):
- `.claude/templates/workshop/templates/03-module-01.adoc`
- `.claude/templates/workshop/templates/README-TEMPLATE-GUIDE.adoc`
- `.claude/templates/workshop/example/03-module-01.adoc`
- `.claude/templates/demo/03-module-01.adoc`

**Style Guides**:
- `showroom/prompts/redhat_style_guide_validation.txt`
- `showroom/prompts/enhanced_verification_workshop.txt`

**Verification Prompts** (READ BEFORE generating content):

**For Lab Modules (`/create-lab`)**:
1. `showroom/prompts/enhanced_verification_workshop.txt` - Complete quality checklist
2. `showroom/prompts/redhat_style_guide_validation.txt` - Red Hat style rules
3. `showroom/prompts/verify_workshop_structure.txt` - Structure requirements
4. `showroom/prompts/verify_technical_accuracy_workshop.txt` - Technical accuracy standards
5. `showroom/prompts/verify_accessibility_compliance_workshop.txt` - Accessibility requirements
6. `showroom/prompts/verify_content_quality.txt` - Content quality standards

**For Demo Modules (`/create-demo`)**:
1. `showroom/prompts/enhanced_verification_demo.txt` - Complete demo quality checklist
2. `showroom/prompts/redhat_style_guide_validation.txt` - Red Hat style rules
3. `showroom/prompts/verify_technical_accuracy_demo.txt` - Technical accuracy for demos
4. `showroom/prompts/verify_accessibility_compliance_demo.txt` - Accessibility requirements
5. `showroom/prompts/verify_content_quality.txt` - Content quality standards

**CRITICAL: How to Use Verification Prompts**:
- Skills MUST read ALL verification prompts BEFORE generating content
- Apply criteria DURING generation (not after)
- Generate content that ALREADY passes all checks
- No separate validation step - content is validated during creation

---

## Update Protocol

When updating these rules:

1. Update this file first
2. Update all 3 skill files to reference changes
3. Update `.claude/skills/README.md` to document changes
4. Commit with message: "Update shared skill rules: [what changed]"

---

**Last Updated**: 2026-01-03
**Maintained By**: Red Hat Technical Marketing
