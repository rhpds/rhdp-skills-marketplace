---
name: showroom:create-demo
description: This skill should be used when the user asks to "create a demo module", "write a Know/Show demo", "build a presenter demo", "create a Showroom demo", "write a facilitator guide", "build a demo script", or "create a presenter-led demo for RHDP".
---

---
context: main
model: claude-opus-4-6
---

# Demo Module Generator

Guide you through creating a Red Hat Showroom demo module using the Know/Show structure for presenter-led demonstrations.

## Workflow Diagram

![Workflow](workflow.svg)

## What You'll Need Before Starting

Have these ready before running this skill:

**Required:**
- 📁 **Target directory path** - Where to create modules (default: `content/modules/ROOT/pages/`)
- 📚 **Demo materials** - At least one of:
  - Product documentation or feature descriptions
  - URLs to technical guides or demos
  - Text describing what to demonstrate
- 🎯 **Demo objective** - What should the presenter show?

**Helpful to have:**
- 🏢 **Customer scenario** - Business context (e.g., "Financial services company needs...")
- 💼 **Value proposition** - Why does this matter to customers? What problem does it solve?
- ⏱️ **Target duration** - How long is the demo? (e.g., 10 min, 20 min)
- 👥 **Audience** - Who is watching? (Technical managers, developers, executives)
- 📝 **Previous modules** - If continuing existing demo, which module comes before this one

**Access needed:**
- ✅ Write permissions to the Showroom repository directory

## When to Use

Use this skill to create presenter-led demo content, transform technical documentation into business-focused demos, or add modules to existing demos.

## Shared Rules

**IMPORTANT**: This skill follows shared contracts defined in `@showroom/docs/SKILL-COMMON-RULES.md`:
- Version pinning or attribute placeholders (REQUIRED)
- Reference enforcement (REQUIRED)
- Attribute file location (REQUIRED)
- Image path conventions (REQUIRED)
- Navigation update expectations (REQUIRED)
- Failure-mode behavior (stop if cannot proceed safely)

See SKILL-COMMON-RULES.md for complete details.

## Know/Show Structure

Demos use a different format than workshops:

- **Know sections**: Business context, customer pain points, value propositions, why this matters
- **Show sections**: Step-by-step presenter instructions, what to demonstrate, expected outcomes

This separates what presenters need to **understand** (business value) from what they need to **do** (technical demonstration).

## Arguments (Optional)

This skill supports optional command-line arguments for faster workflows.

**Usage Examples**:
```bash
/create-demo                                   # Interactive mode (asks all questions)
/create-demo <directory>                       # Specify target directory
/create-demo <directory> --new                 # Create new demo in directory
/create-demo <directory> --continue <module>   # Continue from specific module
```

**Parameters**:
- `<directory>` - Target directory for demo files
  - Example: `/create-demo content/modules/ROOT/pages/`
  - If not provided, defaults to `content/modules/ROOT/pages/`
- `--new` - Flag to create new demo (generates index + overview + details + module-01)
- `--continue <module-path>` - Continue from specified previous demo module
  - Example: `/create-demo content/modules/ROOT/pages/ --continue content/modules/ROOT/pages/03-module-01-intro.adoc`
  - Reads previous module to detect story continuity

**How Arguments Work**:
- Arguments skip certain questions (faster workflow)
- You can still use interactive mode by calling `/create-demo` with no arguments
- Arguments are validated before use

## Workflow

**CRITICAL RULES**

### 1. Ask Questions SEQUENTIALLY

- Ask ONE question or ONE group of related questions at a time
- WAIT for user's answer before proceeding
- Do NOT ask questions from multiple steps together
- Do NOT skip workflows based on incomplete answers

### 2. Manage Output Tokens

- **NEVER output full demo content** - Use Write tool to create files
- **Show brief confirmations only** - "✅ Created: filename (X lines)"
- **Keep total output under 5000 tokens** - Summaries, not content
- **Files are written, not displayed** - User reviews with their editor
- **Token limit**: Claude Code has 32000 token output limit - stay well below it

**Example of WRONG approach**:
```
❌ Asking all at once:
1. Module file name?
2. UserInfo variables?
3. Presentation objective?
4. Number of demos?
```

**Example of CORRECT approach**:
```
✅ Ask sequentially:
Step 2: Complete overall demo story planning
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

**Pattern 1: `/create-demo <directory> --new`**
```
Parsing arguments: "<directory> --new"

✓ Target directory: <directory>
✓ Mode: Create new demo
✓ Will generate: index.adoc → 01-overview → 02-details → 03-module-01

Validating directory...
[Check if directory exists, create if needed]

Skipping: Step 1 (mode already known: NEW demo)
Proceeding to: Step 2 (Plan Overall Demo Story)
```

**Pattern 2: `/create-demo <directory> --continue <module-path>`**
```
Parsing arguments: "<directory> --continue <module-path>"

✓ Target directory: <directory>
✓ Mode: Continue existing demo
✓ Previous module: <module-path>

Validating directory...
[Check if directory exists]

Reading previous module: <module-path>
[Extract story, business context, progression]

Skipping: Step 1 (mode already known: CONTINUE)
Skipping: Step 2 (story detected from previous module)
Proceeding to: Step 3 (Module-Specific Details)
```

**Pattern 3: `/create-demo <directory>`**
```
Parsing arguments: "<directory>"

✓ Target directory: <directory>

Validating directory...
[Check if directory exists]

Skipping: Target directory question
Proceeding to: Step 1 (still need to ask: new vs continue)
```

**Pattern 4: `/create-demo` (no arguments)**
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

### Step 2: Determine Context (New Demo vs Continuation)

**SKIP THIS STEP IF**:
- User provided `--new` flag in arguments (already know: NEW demo)
- User provided `--continue <module>` in arguments (already know: EXISTING demo)

**CRITICAL: DO NOT read any files or make assumptions before asking this question!**

**First, ask the user**:

```
Let's get started! I'll help you create amazing demo content.

Are you creating a new demo or continuing an existing one?

1. 🆕 Creating a NEW demo (I'll help you plan the whole story)
2. ➡️  Continuing an EXISTING demo (I'll pick up where you left off)
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

Example: /Users/yourname/work/showroom-content/my-demo-showroom

Repo path:
```

Use `content/modules/ROOT/pages/` within that path as the target for demo files.

**If continuing existing demo**:
- Provide path to previous module (I'll read and auto-detect the story)

### Step 3: Plan Overall Demo Story (if new demo)

Great! Let's plan your demo together. I'll ask you a few questions to understand what you're trying to achieve.

**IMPORTANT**: Ask these as **conversational, open-ended questions**. Do NOT provide multiple choice options.

**Question 1 - The Big Picture**:
```
What's the main message you want to deliver in this demo?

Think about: What should your audience remember after seeing this?

Example: "Show how OpenShift accelerates application deployment for enterprises"

Your answer:
```

**Question 2 - Know Your Audience**:
```
Who will be watching this demo?

Examples: C-level executives, Sales engineers, Technical managers, Partners

Your audience:

And what matters most to them right now? (their business priorities)

Examples: Cost reduction, faster time-to-market, competitive advantage

Their priorities:
```

**Question 3 - The Transformation Story**:
```
Let's create the before-and-after narrative.

What's the customer challenge you're solving?

What's painful about their current state?

What does the ideal future state look like?

Your story:
```

**Question 4 - Customer Scenario**:
```
What company or industry should we feature in this demo?

Examples: "RetailCo" (retail), "FinanceCorp" (banking), "HealthTech" (healthcare)
Or create your own!

Company/industry:

What specific business challenge is driving urgency for them?

Their urgent challenge:
```

**Question 5 - Show the Impact**:
```
What quantifiable improvements will you highlight?

Examples:
- "6 weeks → 5 minutes deployment time"
- "80% reduction in infrastructure costs"
- "10x faster developer productivity"

Your key metrics:
```

**Question 6 - Timing**:
```
How long should the complete demo take?

Typical options: 15min, 30min, 45min

Your target duration:
```

**Then I'll recommend**:
- Suggested module/section breakdown
- Know/Show structure for each section
- Business narrative arc across modules
- Key proof points and "wow moments"
- Competitive differentiators to emphasize

**You can**:
- Accept the recommended flow
- Adjust sections and messaging
- Change business emphasis

---

### Step 3.1: Showroom Setup (Recommended for new demos)

**For NEW demos only. Skip if adding a module to an existing demo.**

Two files to create or fix:
1. **`site.yml`** — correct title and ui-bundle theme URL. If `default-site.yml` exists → rename to `site.yml` + update gh-pages.yml.
2. **`ui-config.yml`** — split view enabled, correct tabs for OCP or VM

→ Full questions, file templates, AgnosticV workload vars: `@showroom/skills/create-demo/references/showroom-scaffold.md`

---

### Step 4: Gather Module-Specific Details

Now for this specific module:

1. **Module file name**:
   - Module file name (e.g., "03-demo-intro.adoc", "04-platform-demo.adoc")
   - Files go directly in `content/modules/ROOT/pages/`
   - Pattern: `[number]-[topic-name].adoc`

2. **Reference materials** (optional but recommended):
   - URLs to Red Hat product documentation
   - Marketing materials, solution briefs
   - Local files (Markdown, AsciiDoc, PDF)
   - Pasted content
   - **Better references = better business value extraction**
   - If not provided: Generate from templates and common value propositions

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

4. **Target audience**:
   - Sales engineers, C-level executives, technical managers, developers

5. **Business scenario/challenge**:
   - Auto-detect from previous module (if exists)
   - Or ask for customer scenario (e.g., "RetailCo needs faster deployments")

6. **Technology/product focus**:
   - Example: "OpenShift", "Ansible Automation Platform"

7. **Number of demo parts**:
   - Recommended: 2-4 parts (each with Know/Show sections)

8. **Key metrics/business value**:
   - Example: "Reduce deployment time from 6 weeks to 5 minutes"

9. **Diagrams, screenshots, or demo scripts** (optional):
   - Do you have architecture diagrams, demo screenshots, or scripts?
   - If yes: Provide file paths or paste content
   - I'll save them to `content/modules/ROOT/assets/images/`
   - And reference them properly in Show sections

### Step 5: Get UserInfo Variables (if applicable)

If UserInfo variables weren't already provided in Step 3, I'll ask for them now.

**RECOMMENDED: Get from Deployed Environment (Primary Method)**

I'll ask: "Do you have access to a deployed environment on demo.redhat.com or integration.demo.redhat.com?"

**If YES** (recommended):
```
Please share the UserInfo variables from your deployed service:

1. Login to https://integration.demo.redhat.com (or demo.redhat.com)
2. Go to "My services" → Find your service
3. Click on "Details" tab
4. Expand "Advanced settings" section
5. Copy and paste the output here
```

This shows all available variables like:
- `openshift_cluster_console_url` → For showing presenter where to log in
- `openshift_api_server_url` → For API demonstrations
- `openshift_cluster_admin_username` → For admin access demos
- `openshift_cluster_admin_password` → For demo credentials
- `gitea_console_url` → For Git server demos
- `gitea_admin_username`, `gitea_admin_password` → For Gitea access
- Custom workload-specific variables → Product-specific endpoints

**If NO** (fallback):
I'll use common placeholder variables:
- `{openshift_console_url}`
- `{openshift_api_url}`
- `{user}`
- `{password}`
- `{bastion_public_hostname}`

**Alternative**: Clone collections from AgV catalog
- Read `common.yaml` from user-provided AgV path
- Clone collections from any repository (agnosticd, rhpds, etc.)
- Read workload roles to find `agnosticd_user_info` tasks
- Extract variables from `data:` sections
- Note: Less reliable than deployed environment output

**Result**: I'll use these in Show sections for precise presenter instructions with actual URLs and credentials.

### Step 6: Handle Diagrams, Screenshots, and Demo Scripts (if provided)

If you provided visual assets or scripts:

See @showroom/docs/SKILL-COMMON-RULES.md for image path conventions and clickable image syntax.

**For demo scripts or commands**:
- Format in code blocks with syntax highlighting
- Add presenter notes about what to emphasize:
  ```asciidoc
  [source,bash]
  ----
  oc new-app https://github.com/example/nodejs-ex
  ----

  [NOTE]
  ====
  **Presenter Tip:** Emphasize how this single command eliminates 3-5 days of manual setup.
  ====
  ```

**For before/after comparisons**:
- Save both images: `before-manual-deployment.png`, `after-automated-deployment.png`
- Use side-by-side or sequential placement
- Highlight business transformation visually

**Recommended image naming for demos**:
- Business context: `customer-challenge-overview.png`, `transformation-roadmap.png`
- UI walkthroughs: `step-1-login-console.png`, `step-2-create-project.png`
- Results: `deployment-success.png`, `metrics-dashboard.png`
- Comparisons: `before-state.png`, `after-state.png`


### Step 7: Fetch and Analyze References

Based on your references, I'll:
- Fetch URLs and extract technical capabilities
- Read local files
- Identify business value propositions
- Extract metrics and quantifiable benefits
- Map technical features to business outcomes
- Combine with AgnosticV variables (if provided)
- Integrate provided diagrams and screenshots strategically

**Reference Tracking** (for conclusion generation):
- Track all references used across all modules
- Store reference URLs, titles, and which modules used them
- References will be consolidated in the conclusion module, NOT in individual modules
- Each module can cite sources inline (e.g., "According to Red Hat's Total Economic Impact study...") but the formal References section will only appear in the conclusion

### Step 8: Read Templates and Verification Criteria (BEFORE Generating)

**CRITICAL: Read templates BEFORE generating any content.**

**Template source — check the Showroom repo first:**

The user's Showroom repo may contain a `templates/` directory with up-to-date patterns. Always prefer these over the marketplace's built-in templates.

```bash
# Check if user's Showroom repo has demo templates
ls {showroom_repo_path}/examples/demo/templates/ # if exists use examples/ 2>/dev/null
```

**If `examples/demo/templates/` exists in the Showroom repo — read from there:**
- `{showroom_repo_path}/examples/demo/templates/index.adoc` — **Facilitator/presenter guide** (output as `index.adoc`)
- `{showroom_repo_path}/examples/demo/templates/01-overview.adoc`
- `{showroom_repo_path}/examples/demo/templates/02-details.adoc`
- `{showroom_repo_path}/examples/demo/templates/03-module-01.adoc` — **Uses Know/Show structure**
- `{showroom_repo_path}/examples/demo/templates/99-conclusion.adoc`

**If `examples/demo/templates/` does NOT exist — use bundled plugin templates:**
- `@showroom/templates/demo/00-index.adoc` — Facilitator/presenter guide
- `@showroom/templates/demo/03-module-01.adoc` — Know/Show structure
- `@showroom/templates/demo/01-overview.adoc` — Business context overview
- `@showroom/templates/demo/99-conclusion.adoc` — Conclusion template

**Key rules from the templates:**
- Demo `index.adoc` is a **facilitator/presenter guide** — NOT learner-facing (opposite of workshop)
- All demo modules follow **Know/Show structure**: `=== Know` (background, business value, why) then `=== Show` (step-by-step presenter actions)
- Both output files are named `index.adoc` regardless of template source filename

The user's `examples/` directory reflects the latest nookbag patterns and may be more current than the marketplace copies. Always use the repo's own templates when available.

See @showroom/docs/SKILL-COMMON-RULES.md for verification prompt file lists and usage.

### Step 9: Generate Demo Module (Using Verification Criteria)

**IMPORTANT: Use the bundled demo templates read in Step 8 as quality references.**

Apply patterns from the bundled templates to new demo content:
- Know/Show structure and separation
- Business value messaging style
- Presenter guidance and talk track format ("What I say", "What I do")
- Code block formatting and syntax highlighting
- Image references (link=self,window=blank)
- List formatting (blank lines before/after)
- External links (^ caret for new tabs)

**This ensures generated demo content matches real Showroom demo quality instead of generic templates.**

I'll create a module with Know/Show structure:

See @showroom/docs/SKILL-COMMON-RULES.md for image syntax and AsciiDoc list formatting rules.

**CRITICAL: Content rules** (originality, em dashes, Know/Show bullets vs numbers, demo language, talk track):
See `@showroom/skills/create-demo/references/content-rules.md` for all rules with correct/incorrect examples.

### Step 10: Validate (Run Agents)

After generating the demo module, run both review agents:

**1. Ask the workshop-reviewer agent** to validate the Know/Show structure, business focus, and presenter guidance:
```
Ask: Review this demo module for structure and business focus quality
```

**2. Ask the style-enforcer agent** to check Red Hat style compliance:
```
Ask: Check this demo module for Red Hat style guide compliance
```

Apply any fixes the agents flag before delivering to the user.

---

### Step 11: Update Navigation (REQUIRED)

See @showroom/docs/SKILL-COMMON-RULES.md for navigation update requirements.

---

### Step 12: Deliver

**CRITICAL: Manage Output Tokens to Prevent Overflow**

Write files using Write tool — show brief confirmations only. Keep total output under 5000 tokens.

---

## Integration Notes

**Templates used** (from Showroom repo `templates/demo/templates/` or marketplace fallback):
- `index.adoc` (facilitator/presenter guide)
- `01-overview.adoc`, `02-details.adoc`
- `03-module-01.adoc` (Know/Show structure)
- `99-conclusion.adoc`

**Agents invoked at Step 10**:
- `workshop-reviewer` — validates Know/Show structure and business focus
- `style-enforcer` — applies Red Hat style standards

**Files created**:
- Demo module: `content/modules/ROOT/pages/<module-file>.adoc`
- Assets: `content/modules/ROOT/assets/images/`

**Files modified** (with permission):
- `content/modules/ROOT/nav.adoc` - Adds navigation entry

## Related Skills

- `/showroom:verify-content` -- Run quality checks on generated demo content
- `/showroom:blog-generate` -- Convert demo content into blog posts
