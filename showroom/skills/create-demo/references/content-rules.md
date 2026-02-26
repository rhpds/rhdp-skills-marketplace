# Content Rules and Demo Writing Best Practices (create-demo)

**CRITICAL: Content Originality - No Plagiarism**:
All generated content MUST be original. Never copy from external sources without proper attribution.

✅ **CORRECT - Original with attribution**:
```asciidoc
According to link:https://kubernetes.io/docs/...[Kubernetes documentation^],
Kubernetes is "an open-source system for automating deployment." Red Hat OpenShift
extends Kubernetes with enterprise features including integrated CI/CD and security.
```

❌ **WRONG - Copied without attribution**:
```asciidoc
Kubernetes is an open-source system for automating deployment, scaling,
and management of containerized applications.
```

**Prohibited**:
- Copying documentation verbatim from external sources
- Slightly rewording existing tutorials
- Presenting others' examples as original work

**Required**:
- Write original explanations
- Add Red Hat-specific context
- Use proper attribution with quotes and links

**CRITICAL: No Em Dashes**:
Never use em dashes (—). Use commas, periods, or en dashes (–) instead.

✅ **CORRECT**:
```asciidoc
OpenShift, Red Hat's platform, simplifies deployments.
The process is simple. Just follow these steps.
2020–2025 (en dash for ranges)
```

❌ **WRONG - Em dash used**:
```asciidoc
OpenShift—Red Hat's platform—simplifies deployments.
The process is simple—just follow these steps.
```

**Why**: Follows Red Hat Corporate Style Guide and improves readability.

See @showroom/docs/SKILL-COMMON-RULES.md for external link formatting (caret usage).

**CRITICAL: Bullets vs Numbers - Know vs Show**:
Knowledge sections use bullets (*). Task/step sections use numbers (.).

✅ **CORRECT - Bullets for knowledge, numbers for tasks**:
```asciidoc
=== Know

**Business Challenge:**

* Manual deployments take 8-10 weeks
* Security vulnerabilities discovered too late
* Infrastructure costs are too high

=== Show

**What I do:**

. Log into OpenShift Console at {openshift_console_url}
. Navigate to Developer perspective
. Click "+Add" → "Import from Git"
. Enter repository URL and click Create
```

❌ **WRONG - Mixed up bullets and numbers**:
```asciidoc
=== Know

**Business Challenge:**

. Manual deployments take 8-10 weeks  ← WRONG (should be bullets)
. Security vulnerabilities discovered too late
. Infrastructure costs are too high

=== Show

**What I do:**

* Log into OpenShift Console  ← WRONG (should be numbers)
* Navigate to Developer perspective
* Click "+Add" → "Import from Git"
```

**Rule**:
- Know sections → Use bullets (*) for business points, benefits, challenges
- Show sections → Use numbers (.) for sequential steps and tasks
- Verification → Use bullets (*) for success indicators

**Why**: Bullets indicate information to absorb; numbers indicate sequential actions to perform.

**CRITICAL: Demo Language - NO Learner Language**:
Demos are presenter-led, NOT learner-focused. Use the correct terminology.

**For index.adoc (Navigation Hub - if generating first demo)**:

✅ **CORRECT - Presenter-focused**:
```asciidoc
= OpenShift Platform Demo

**What This Demo Covers**

This demonstration shows how Red Hat OpenShift accelerates deployment cycles:

* Self-service developer platform capabilities
* Automated CI/CD pipeline integration
* Built-in security and compliance features
* Business ROI and cost reduction metrics
```

❌ **WRONG - Learner language**:
```asciidoc
= OpenShift Platform Demo

**What You'll Learn**

In this workshop, you will learn how to:
* Deploy applications to OpenShift
* Create CI/CD pipelines
* Configure security policies
```

**For 01-overview.adoc (Presenter Prep - if generating first demo)**:

✅ **CORRECT - Full business context for presenters**:
```asciidoc
= Demo Overview and Presenter Preparation

== Background

ACME inc is a retail company facing Black Friday deadlines with 10-week deployment cycles.
They need to accelerate feature delivery to remain competitive.

== Problem Breakdown

**Challenge 1: Slow deployment cycles** - Manual processes take 8-10 weeks
**Challenge 2: Security vulnerabilities** - 200+ CVEs discovered monthly
**Challenge 3: Infrastructure costs** - $2M annually on underutilized servers

== Solution Overview

Red Hat OpenShift provides self-service platform with automated security.

== Business Benefits

* 95% faster deployments (10 weeks → 30 minutes)
* 80% reduction in security vulnerabilities
* 60% lower infrastructure costs

== Common Customer Questions

**"How does this work with our existing tools?"**
→ Emphasize Jenkins integration path and existing tool enhancement
```

**Key Rules**:
1. index.adoc → Use "What This Demo Covers" (NOT "What You'll Learn")
2. index.adoc → Keep it brief (navigation hub)
3. index.adoc → No detailed problem statements
4. 01-overview.adoc → Complete business context for presenter preparation
5. 01-overview.adoc → Include all business benefits and customer Q&A
6. Never use "you will learn", "hands-on", "exercises" in demos

**CRITICAL: Demo Talk Track Separation**:
Demo modules MUST separate presenter guidance from technical steps:

**Required structure** for each Show section:
```asciidoc
=== Show

**What I say**:
"We're seeing companies like yours struggle with 6-8 week deployment cycles. Let me show you how OpenShift reduces that to minutes."

**What I do**:
. Log into OpenShift Console at {console_url}
. Navigate to Developer perspective
. Click "+Add" → "Import from Git"

**What they should notice**:
✓ No complex setup screens
✓ Self-service interface
✓ **Metric highlight**: "This used to take 6 weeks, watch what happens..."

**If asked**:
Q: "Does this work with our existing Git repos?"
A: "Yes, OpenShift supports GitHub, GitLab, Bitbucket, and private Git servers."

Q: "What about security scanning?"
A: "Built-in. I'll show that in part 2."
```

**Labs should NOT include talk tracks** - labs are for hands-on learners, not presenters.

**For each demo part**:

**Know Section**:
- Business challenge explanation
- Current state vs desired state
- Quantified pain points
- Stakeholder impact
- Value proposition

**Show Section**:
- **Optional visual cues** (recommended but not required)
- Step-by-step presenter instructions
- Specific commands and UI interactions
- Expected screens/outputs
- Image placeholders for key moments
- Business value callouts during demo
- Troubleshooting hints

**Example Structure**:
```asciidoc
== Part 1 — Accelerating Application Deployment

=== Know
_Customer challenge: Deployment cycles take 6-8 weeks, blocking critical business initiatives._

**Business Impact:**
* Development teams wait 6-8 weeks for platform provisioning
* Black Friday deadline in 4 weeks is at risk
* Manual processes cause errors and rework
* Competition is shipping features faster

**Value Proposition:**
OpenShift reduces deployment time from weeks to minutes through self-service developer platforms and automated CI/CD pipelines.

=== Show

**Optional visual**: Before/after deployment timeline diagram showing 6-8 weeks vs 2 minutes

* Log into OpenShift Console at {openshift_console_url}
  * Username: {user}
  * Password: {password}

* Navigate to Developer perspective → +Add

* Select "Import from Git" and enter:
  * Git Repo: `https://github.com/example/nodejs-ex`
  * Application name: `retail-checkout`
  * Deployment: Create automatically

* Click "Create" and observe:
  * Build starts automatically
  * Container image is built
  * Application deploys in ~2 minutes

image::deployment-progress.png[Deployment in Progress,link=self,window=blank,align="center",width=700,title="Deployment in Progress"]

* **Business Value Callout**: "What used to take your team 6-8 weeks just happened in 2 minutes. Developers can now deploy independently without waiting for infrastructure teams."

* Show the running application:
  * Click the route URL
  * Demonstrate the live application
  * Highlight the automatic scaling capability

* Connect to business outcome:
  "This self-service capability means your development team can meet the 4-week Black Friday deadline and ship updates daily instead of quarterly."
```

**Optional Visual Cues** (Recommended):

Add lightweight visual guidance without forcing asset creation:

```asciidoc
=== Show

**Optional visual**: Architecture diagram showing component relationships
**Optional slide**: Customer pain points - 6-8 week deployment cycles
**Optional visual**: Before/after comparison of manual vs automated workflow

[...presenter actions follow...]
```

**Cue Examples**:
- "Optional visual: Architecture diagram showing component relationships"
- "Optional slide: Customer pain points - 6-8 week deployment cycles"
- "Optional visual: Before/after comparison of manual vs automated workflow"
- "Optional diagram: Pipeline flow from commit to production"

**Guidelines**:
- Always mark as "Optional visual:" or "Optional slide:"
- Don't make demo depend on it
- Helps presenters prepare assets if they want
- Keeps demos tight without forcing asset creation

### Step 10: Validate

I'll automatically run:
- **workshop-reviewer** agent: Validates structure
- **style-enforcer** agent: Applies Red Hat style standards
- Verify Know/Show balance and business focus

### Step 11: Update Navigation (REQUIRED)

See @showroom/docs/SKILL-COMMON-RULES.md for navigation update requirements.

### Step 12: Deliver

**CRITICAL: Manage Output Tokens to Prevent Overflow**

**Token Management Rules**:
1. **Write files using Write tool** - Don't output full file contents to user
2. **Show brief confirmations only** - "✅ Created: file.adoc (X lines)"
3. **Provide summary at end** - List what was created, not the full content
4. **Never output entire demo content** - Files are already written
5. **Keep total output under 5000 tokens** - Brief summaries only

**Output Format**:

```
✅ Demo Module Generation Complete

**Files Created**:
- content/modules/ROOT/pages/demo-01-platform-value.adoc (312 lines)
- content/modules/ROOT/nav.adoc (updated)

**Demo Structure**:
- Know sections: 4 (business context, pain points, value props, ROI)
- Show sections: 3 (technical demonstrations)
- Presenter tips: 8
- Business metrics: 5 quantified benefits
- Troubleshooting scenarios: 4

**Assets**:
- Diagrams needed: 3 placeholders (architecture, before/after, ROI chart)
- Screenshots needed: 2 placeholders (UI demonstrations)
- Dynamic attributes used: {openshift_console_url}, {demo_app_url}

**Presenter Notes**:
- Estimated presentation time: 25 minutes
- Business talking points included in each Know section
- Technical demo scripts in each Show section
- Pause points for questions marked

**Next Steps**:
1. Review demo: content/modules/ROOT/pages/demo-01-platform-value.adoc
2. Prepare diagrams for business context sections
3. Capture screenshots for technical demonstrations
4. Practice demo flow and timing
5. Run: verify-content to check quality
6. Create next module: create-demo (continuing existing demo)

**Note**: All files have been written. Use your editor to review them.
```

**What NOT to do**:
- ❌ Don't show full demo content in response
- ❌ Don't output the entire file you just created
- ❌ Don't paste hundreds of lines of generated AsciiDoc
- ❌ Don't include long example sections in output

**What TO do**:
- ✅ Write files using Write tool
- ✅ Show brief "Created: filename (X lines)" confirmations
- ✅ Provide structured summary
- ✅ Give clear next steps for presenters
- ✅ Keep output concise (under 5000 tokens)

### Step 13: Generate Conclusion Module (MANDATORY)

**After delivering the final module, ask if this is the last module:**

```
Q: Is this the last module of your demo?

If YES, I will now generate the mandatory conclusion module that includes:
- Business impact recap and ROI summary
- Competitive advantages demonstrated
- ALL REFERENCES used across the entire demo
- Next steps for evaluation, pilot, and production
- Call-to-action for technical teams and decision makers
- Q&A guidance

If NO, you can continue creating more modules, and I'll generate the conclusion when you're done.

Is this your last module? [Yes/No]
```

**If user answers YES (this is the last module)**:

1. Read ALL previous modules to extract:
   - All business value points and ROI metrics
   - All references cited in each module
   - Key technical capabilities demonstrated
   - Competitive differentiation points

2. Ask about references:

   **First, extract all references from previous modules:**
   - Read all module files (index.adoc, 01-overview.adoc, 02-details.adoc, 03-module-01-*.adoc, etc.)
   - Extract all external links found in the content
   - Identify reference materials provided during module creation (Step 3 question 2)
   - Compile a comprehensive list with:
     - URL
     - Link text/title
     - Which module(s) referenced it

   **Then ask the user:**
   ```
   Q: How would you like to handle references in the conclusion?

   I found these references used across your demo modules:
   1. https://www.redhat.com/... [Red Hat OpenShift Platform] - Used in: Modules 1, 3
   2. https://docs.redhat.com/... [Product Documentation] - Used in: Module 2
   3. https://customers.redhat.com/... [Customer Success Story] - Used in: Module 1
   {{ additional_references_if_found }}

   Options:
   1. Use these references as-is (I'll organize them by category)
   2. Let me provide additional references to include
   3. Let me curate the reference list (add/remove specific items)

   Your choice? [1/2/3]
   ```

   **If option 1**: Use extracted references, organize by category

   **If option 2**: Ask user to provide additional references:
   ```
   Q: Please provide additional references to include in the conclusion.

   Format: URL and description, one per line
   Example:
   https://www.redhat.com/... - Red Hat solution brief
   https://customers.redhat.com/... - Customer case study

   Your additional references:
   ```

   **If option 3**: Ask user which references to keep/remove/add:
   ```
   Q: Let's curate the reference list.

   Current references:
   {{ numbered_list_of_references }}

   Options:
   - Type numbers to REMOVE (e.g., "3, 5, 7")
   - Type "add" to add new references
   - Type "done" when finished

   Your action:
   ```

3. Detect highest module number (e.g., if last module is 05-module-03, conclusion will be 06-conclusion.adoc)

4. Generate conclusion module using the embedded template below

5. Customize the template with Know/Show structure:
   - File: `0X-conclusion.adoc` (where X = next sequential number)
   - **Know**: Business impact recap, ROI summary, competitive advantages
   - **Show**: Demo capabilities recap, technical highlights
   - Next steps: Workshops, POC, deep dives
   - **References**: Consolidated references from all modules (REQUIRED)
   - Call to action for decision makers and technical teams
   - Q&A guidance with common questions

6. Update nav.adoc with conclusion entry at the end

7. Provide brief confirmation

**If user answers NO (more modules to come)**:
- Note that conclusion will be generated after the last module
- User can invoke /create-demo again to add more modules
- When adding the final module, this question will be asked again

**Embedded Demo Conclusion Template**:
```asciidoc
= Demo Conclusion and Next Steps

*Presenter Note*: Use this concluding section to wrap up the demonstration, reinforce key messages, and provide clear next steps for the audience.

== Summary

=== Know

**Business Impact Recap**

You've just seen how {{ product_name }} addresses the critical business challenges we discussed:

* **{{ business_challenge_1 }}**: Solved with {{ solution_1 }}
* **{{ business_challenge_2 }}**: Solved with {{ solution_2 }}
* **{{ business_challenge_3 }}**: Solved with {{ solution_3 }}

**ROI and Value**

The solution demonstrated today delivers:

* {{ roi_metric_1 }} - {{ benefit_1 }}
* {{ roi_metric_2 }} - {{ benefit_2 }}
* {{ roi_metric_3 }} - {{ benefit_3 }}

**Competitive Advantages**

What sets this apart:

. {{ differentiator_1 }}
. {{ differentiator_2 }}
. {{ differentiator_3 }}

=== Show

**What We Demonstrated**

In this demo, you saw:

. ✅ {{ demo_capability_1 }}
. ✅ {{ demo_capability_2 }}
. ✅ {{ demo_capability_3 }}
. ✅ {{ demo_capability_4 }}

**Key Technical Highlights**

The most impressive technical capabilities:

* **{{ technical_highlight_1 }}**: {{ why_it_matters_1 }}
* **{{ technical_highlight_2 }}**: {{ why_it_matters_2 }}
* **{{ technical_highlight_3 }}**: {{ why_it_matters_3 }}

== Next Steps for Your Organization

=== Immediate Actions

Help your audience get started:

. **Try It Yourself**: {{ workshop_url }} - Hands-on workshop based on this demo
. **Request POC**: {{ poc_contact }} - Proof of concept in your environment
. **Schedule Deep Dive**: {{ schedule_url }} - Technical architecture session

=== Recommended Path

**Phase 1: Evaluate** (Weeks 1-2)::
* Attend hands-on workshop
* Review technical documentation
* Assess fit for your use cases

**Phase 2: Pilot** (Weeks 3-6)::
* Deploy proof of concept
* Test with representative workloads
* Measure performance and ROI

**Phase 3: Production** (Months 2-3)::
* Roll out to production environment
* Train teams
* Scale across organization

=== Resources

**Documentation**:

* link:{{ product_docs_url }}[{{ product_name }} Documentation^]
* link:{{ architecture_guide_url }}[Architecture Guide^]
* link:{{ best_practices_url }}[Best Practices^]

**Workshops and Training**:

* link:{{ workshop_url }}[Hands-on Workshop^] - Based on this demo
* link:{{ training_url }}[{{ product_name }} Training^]

**Support and Community**:

* link:{{ community_url }}[Community Forums^]
* link:{{ support_url }}[Enterprise Support^]
* link:{{ blog_url }}[Technical Blog^]

== Call to Action

*Presenter Guidance*: Tailor this section based on your audience (technical vs executive, evaluation vs purchase stage).

=== For Technical Teams

**Ready to build?**

. Access the hands-on workshop: {{ workshop_url }}
. Clone the demo repository: {{ demo_repo_url }}
. Join the community: {{ community_url }}

=== For Decision Makers

**Ready to transform your operations?**

. Schedule a custom demo: {{ custom_demo_url }}
. Request ROI analysis: {{ roi_analysis_contact }}
. Speak with an architect: {{ architect_contact }}

== Questions and Discussion

*Presenter Note*: Leave 5-10 minutes for Q&A. Common questions and answers:

**Q: How long does deployment take?**::
A: {{ deployment_time }} with our guided process. Proof of concept can be running in {{ poc_time }}.

**Q: What's the learning curve?**::
A: {{ learning_curve }}. Workshop participants are productive within {{ productivity_time }}.

**Q: Integration with existing tools?**::
A: {{ integration_summary }}. We support {{ integration_list }}.

**Q: Support and SLAs?**::
A: {{ support_summary }}. Enterprise support includes {{ sla_details }}.

== Presenter Action Items

*For Sales Engineers / Solution Architects*: Follow these steps after the demo:

=== Immediate Follow-up (Within 24 hours)

. **Send Demo Recording**: Email recording link with key timestamps
. **Share Resources**: Send links to documentation, workshop, and trial access
. **Schedule Next Meeting**: Book follow-up for deeper technical discussion or POC planning
. **Internal Notes**: Log demo feedback, questions asked, and objections in CRM

=== Within One Week

. **Proposal or ROI Analysis**: Send customized proposal based on their requirements
. **Technical Deep Dive**: Offer architecture review session with specialist
. **POC Proposal**: Outline proof-of-concept scope, timeline, and success criteria
. **Connect with Product Team**: Loop in product specialists if needed

=== Qualification Checkpoints

Based on this demo, assess:

* **Budget**: Do they have budget allocated or need justification?
* **Timeline**: When do they need to make a decision?
* **Authority**: Who else needs to be involved in the decision?
* **Need**: Is this a critical priority or nice-to-have?

== References

**CRITICAL**: This section consolidates ALL references used across the entire demo.

Read all previous modules and extract every reference cited, then organize them by category:

=== Product Documentation

* link:{{ product_docs_url }}[{{ product_name }} Documentation^] - Used in: Modules {{ modules_list }}
* link:{{ feature_docs_url }}[{{ feature_name }} Guide^] - Used in: Modules {{ modules_list }}

=== Red Hat Resources

* link:{{ redhat_resource_1 }}[{{ resource_title_1 }}^] - Used in: Module {{ module_number }}
* link:{{ solution_brief_url }}[{{ solution_brief_title }}^] - Used in: Module {{ module_number }}

=== Customer Success Stories

* link:{{ customer_story_1 }}[{{ customer_name_1 }} Case Study^] - Used in: Module {{ module_number }}
* link:{{ customer_story_2 }}[{{ customer_name_2 }} Success Story^] - Used in: Module {{ module_number }}

=== Industry Research and Analysis

* link:{{ analyst_report_url }}[{{ analyst_report_title }}^] - Market research
* link:{{ industry_study_url }}[{{ study_title }}^] - Industry benchmarks

**Guidelines for References section**:
- Group references by category (Product Docs, Red Hat Resources, Customer Stories, Research)
- Include which module(s) used each reference
- ALL external links must use `^` caret to open in new tab
- Provide brief context for each reference (what it covers)
- Ensure ALL references from ALL modules are included

== Thank You

Thank you for your time and attention. We're excited to help you {{ primary_value_proposition }}.

**Contact Information**:

* Sales: {{ sales_contact }}
* Technical: {{ technical_contact }}
* Support: {{ support_contact }}

---

**Demo**: {{ demo_name }} +
**Presented**: {localdate} +
**Platform**: Red Hat Showroom
```

**Conclusion Module Naming**:
- File: `0X-conclusion.adoc` (sequential number, e.g., 06-conclusion.adoc)
- Title: `= Demo Conclusion and Next Steps`
- Nav entry: `* xref:0X-conclusion.adoc[Conclusion and Next Steps]`

**Content to Include** (ALL REQUIRED):
- ✅ **Know**: Business impact recap, ROI metrics, competitive advantages
- ✅ **Show**: Demo capabilities summary, technical highlights
- ✅ "Next Steps for Your Organization" - Evaluation path, pilot, production
- ✅ "Resources" - Documentation, workshops, community
- ✅ "Call to Action" - Tailored for technical teams vs decision makers
- ✅ "Q&A Guidance" - Common questions with suggested answers
- ✅ **"References"** - Consolidate ALL references from ALL modules (MANDATORY)
- ✅ "Presenter Action Items" - Follow-up guidance for sales engineers
- ✅ "Thank You" - Contact information and closing

**CRITICAL**: The References section MUST include every reference used across all demo modules, organized by category (Product Docs, Red Hat Resources, Customer Stories, Research).


## Know Section Best Practices

Good Know sections include:

**Business Challenge**:
- Specific customer pain point
- Current state with metrics
- Why it matters now (urgency)

**Current vs Desired State**:
- "Now: 6-8 week deployment cycles"
- "Goal: Deploy multiple times per day"

**Stakeholder Impact**:
- Who cares: "VP Engineering, Product Managers"
- Why: "Missing market windows, losing to competitors"

**Value Proposition**:
- Clear benefit statement
- Quantified outcome
- Business language, not tech jargon

## Show Section Best Practices

Good Show sections include:

**Clear Instructions**:
- Numbered steps
- Specific UI elements ("Click Developer perspective")
- Exact field values to enter

**Expected Outcomes**:
- What presenters should see
- Screenshots of key moments
- Success indicators

**Business Callouts**:
- Connect each technical step to business value
- Use phrases like "This eliminates..." or "This reduces..."
- Quantify where possible

**Presenter Tips**:
- Common questions to expect
- Troubleshooting hints
- Pacing suggestions

## Tips for Best Results

- **Specific metrics**: "6 weeks → 5 minutes" not "faster deployments"
- **Real scenarios**: Base on actual customer challenges
- **Visual emphasis**: Demos need more screenshots than workshops
- **Business language**: Executives care about outcomes, not features
- **Story arc**: Build narrative across parts

## Quality Standards

Every demo module will have:
- ✓ Know/Show structure for each part
- ✓ Business context before technical steps
- ✓ Quantified metrics and value propositions
- ✓ Clear presenter instructions
- ✓ Image placeholders with descriptions
- ✓ Business value callouts during Show
- ✓ External links with `^` to open in new tab
- ✓ Dynamic variables as placeholders (not replaced with actual values)
- ✓ Target audience appropriate language
- ✓ Red Hat style compliance

## Common Demo Patterns

**Executive Audience**:
- More Know, less Show
- Focus on business outcomes
- High-level demonstrations
- Emphasize strategic value

**Technical Audience**:
- Balanced Know/Show
- Show depth and capabilities
- Include architecture discussions
- Technical credibility focus

**Sales Engineers**:
- Detailed Show sections
- Competitive differentiators
- Objection handling
- ROI calculations

