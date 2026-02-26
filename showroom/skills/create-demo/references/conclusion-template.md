# Demo Conclusion Module Template (create-demo)

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


