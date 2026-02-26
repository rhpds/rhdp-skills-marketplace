# Conclusion Module Template (create-lab)

### Step 13: Generate Conclusion Module (MANDATORY)

**After delivering the final module, ask if this is the last module:**

```
Q: Is this the last module of your workshop?

If YES, I will now generate the mandatory conclusion module that includes:
- Summary of what learners accomplished
- Key takeaways from all modules
- ALL REFERENCES used across the entire workshop
- Next steps and resources
- Related workshops and certification paths

If NO, you can continue creating more modules, and I'll generate the conclusion when you're done.

Is this your last module? [Yes/No]
```

**If user answers YES (this is the last module)**:

1. Read ALL previous modules to extract:
   - All learning outcomes from each module
   - All references cited in each module
   - Key concepts and skills taught
   - Technologies and products covered

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

   I found these references used across your modules:
   1. https://docs.openshift.com/container-platform/4.18/... [OpenShift Documentation] - Used in: Modules 1, 3
   2. https://tekton.dev/docs/pipelines/ [Tekton Pipelines] - Used in: Module 2
   3. https://developers.redhat.com/... [Developer Guide] - Used in: Module 1
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
   https://docs.redhat.com/... - OpenShift documentation
   https://developers.redhat.com/... - Developer guides

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

3. Detect highest module number (e.g., if last module is 07-module-05, conclusion will be 08-conclusion.adoc)

4. Generate conclusion module using the embedded template below

5. Customize the template by:
   - Extracting all learning outcomes from previous modules
   - Listing 3-5 key takeaways from the workshop
   - **Using the curated reference list from step 2** (REQUIRED)
   - Providing next steps (related workshops, docs, practice projects)

6. Update nav.adoc with conclusion entry at the end

7. Provide brief confirmation

**If user answers NO (more modules to come)**:
- Note that conclusion will be generated after the last module
- User can invoke /create-lab again to add more modules
- When adding the final module, this question will be asked again

**Embedded Conclusion Template**:
```asciidoc
= Conclusion and Next Steps

Congratulations! You've completed the {{ workshop_name }} workshop.

== What You've Learned

Throughout this workshop, you've gained hands-on experience with:

* ✅ {{ learning_outcome_1 }}
* ✅ {{ learning_outcome_2 }}
* ✅ {{ learning_outcome_3 }}
* ✅ {{ learning_outcome_4 }}

You now have the skills to {{ primary_capability }}.

== Key Takeaways

The most important concepts to remember:

. **{{ key_concept_1 }}**: {{ brief_explanation_1 }}
. **{{ key_concept_2 }}**: {{ brief_explanation_2 }}
. **{{ key_concept_3 }}**: {{ brief_explanation_3 }}

== Next Steps

Ready to continue your journey? Here are some recommended next steps:

=== Recommended Workshops

Explore related workshops to expand your skills:

* link:{{ related_workshop_1_url }}[{{ related_workshop_1_name }}^] - {{ related_workshop_1_description }}
* link:{{ related_workshop_2_url }}[{{ related_workshop_2_name }}^] - {{ related_workshop_2_description }}

=== Documentation and Resources

Deepen your knowledge with these resources:

* link:{{ docs_url_1 }}[{{ product_name }} Official Documentation^]
* link:{{ docs_url_2 }}[{{ feature_name }} Guide^]
* link:{{ community_url }}[{{ product_name }} Community^]

=== Practice Projects

Put your new skills to work:

. **{{ project_idea_1 }}**: {{ project_description_1 }}
. **{{ project_idea_2 }}**: {{ project_description_2 }}
. **{{ project_idea_3 }}**: {{ project_description_3 }}

== References

**CRITICAL**: This section consolidates ALL references used across the entire workshop.

Read all previous modules and extract every reference cited, then organize them by category:

=== Official Documentation

* link:{{ docs_url_1 }}[{{ product_name }} Documentation^] - Used in: Modules {{ modules_list }}
* link:{{ docs_url_2 }}[{{ feature_name }} Guide^] - Used in: Modules {{ modules_list }}

=== Red Hat Resources

* link:{{ redhat_resource_1 }}[{{ resource_title_1 }}^] - Used in: Module {{ module_number }}
* link:{{ redhat_resource_2 }}[{{ resource_title_2 }}^] - Used in: Module {{ module_number }}

=== Community and Open Source

* link:{{ community_url_1 }}[{{ community_resource_1 }}^] - Used in: Module {{ module_number }}
* link:{{ community_url_2 }}[{{ community_resource_2 }}^] - Used in: Module {{ module_number }}

=== Additional Reading

* link:{{ additional_url_1 }}[{{ additional_title_1 }}^] - Background information
* link:{{ additional_url_2 }}[{{ additional_title_2 }}^] - Advanced topics

**Guidelines for References section**:
- Group references by category (Official Docs, Red Hat Resources, Community, etc.)
- Include which module(s) used each reference
- ALL external links must use `^` caret to open in new tab
- Provide brief context for each reference (what it covers)
- Ensure ALL references from ALL modules are included

== Share Your Feedback

Help us improve this workshop:

* What did you find most valuable?
* What could be improved?
* What topics would you like to see covered in future workshops?

Contact us: {{ feedback_contact }}

== Thank You!

Thank you for participating in this workshop. We hope you found it valuable and informative.

Keep building, keep learning! 🚀

---

**Workshop**: {{ workshop_name }} +
**Completed**: {localdate} +
**Platform**: Red Hat Showroom
```

**Conclusion Module Naming**:
- File: `0X-conclusion.adoc` (sequential number, e.g., 08-conclusion.adoc)
- Title: `= Conclusion and Next Steps`
- Nav entry: `* xref:0X-conclusion.adoc[Conclusion and Next Steps]`

**Content to Include** (ALL REQUIRED):
- ✅ "What You've Learned" - Extract from all module learning outcomes
- ✅ "Key Takeaways" - 3-5 most important concepts
- ✅ "Next Steps" - Related workshops, documentation, practice projects
- ✅ **"References"** - Consolidate ALL references from ALL modules (MANDATORY)
- ✅ "Share Your Feedback" - Feedback prompts
- ✅ "Thank You" - Closing message

**CRITICAL**: The References section MUST include every reference used across all modules, organized by category.

