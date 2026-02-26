# AsciiDoc Writing Rules (create-lab)

**CRITICAL: Image Syntax Enforcement**:
When generating ANY image reference in the module content, you MUST include `link=self,window=blank`:

✅ **CORRECT - Always use this format**:
```asciidoc
image::filename.png[Description,link=self,window=blank,width=700]
image::pipeline-view.png[Pipeline Execution,link=self,window=blank,width=700,title="Pipeline Running"]
```

❌ **WRONG - Never generate images without link parameter**:
```asciidoc
image::filename.png[Description,width=700]
image::pipeline-view.png[Pipeline Execution,width=700]
```

**Why**: This makes images clickable to open full-size in new tab, preventing learners from losing their place in the workshop.

**CRITICAL: AsciiDoc List Formatting Enforcement**:

See @showroom/docs/SKILL-COMMON-RULES.md for AsciiDoc list formatting rules with examples.

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

**CRITICAL: External Links Must Open in New Tab**:
All external links MUST use `^` caret to open in new tab, preventing learners from losing their place.

✅ **CORRECT - External links with caret**:
```asciidoc
According to link:https://docs.redhat.com/...[Red Hat Documentation^], OpenShift provides...
See the link:https://www.redhat.com/guides[Getting Started Guide^] for more details.
```

❌ **WRONG - Missing caret**:
```asciidoc
According to link:https://docs.redhat.com/...[Red Hat Documentation], OpenShift provides...
See the link:https://www.redhat.com/guides[Getting Started Guide] for more details.
```

**Internal links (NO caret)**:
```asciidoc
✅ CORRECT - Internal navigation without caret:
Navigate to xref:04-module-02.adoc[Next Module] to continue.
See xref:02-details.adoc#prerequisites[Prerequisites] section.
```

**Why**: External links without caret replace current tab, causing learners to lose their place in the workshop. Internal xrefs should NOT use caret to keep flow within the workshop.

**CRITICAL: Bullets vs Numbers - Knowledge vs Tasks**:
Knowledge/information sections use bullets (*). Task/step sections use numbers (.).

✅ **CORRECT - Bullets for knowledge, numbers for tasks**:
```asciidoc
== Learning Objectives

By the end of this module, you will understand:

* How Tekton tasks encapsulate CI/CD steps
* The relationship between tasks and pipelines
* Best practices for pipeline design

== Exercise 1: Create Your First Pipeline

Follow these steps:

. Open the OpenShift Console at {openshift_console_url}
. Navigate to Pipelines → Create Pipeline
. Enter the pipeline name: my-first-pipeline
. Add a task from the catalog
. Click Create

=== Verify

Check that your pipeline was created successfully:

* Pipeline appears in the list
* Status shows "Not started"
* All tasks are configured correctly
```

❌ **WRONG - Mixed up bullets and numbers**:
```asciidoc
== Exercise 1: Create Your First Pipeline

Follow these steps:

* Open the OpenShift Console  ← WRONG (should be numbers)
* Navigate to Pipelines
* Click Create

=== Verify

. Pipeline appears in the list  ← WRONG (should be bullets)
. Status shows "Not started"
```

**Rule**:
- Learning objectives → Use bullets (*) for concepts to understand
- Exercise steps → Use numbers (.) for sequential actions
- Verification → Use bullets (*) for success indicators
- Prerequisites → Use bullets (*) for requirements list
- Benefits/features → Use bullets (*) for information points

**Why**: Bullets indicate information to absorb; numbers indicate sequential actions to perform.

