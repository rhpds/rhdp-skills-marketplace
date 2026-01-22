---
layout: default
title: /generate-agv-description
---

# /generate-agv-description

Generate AgnosticV catalog description.adoc from Showroom workshop content.

---

## Before You Start

### Prerequisites

1. **Complete workshop content:**
   ```bash
   # Your Showroom repository with finished workshop:
   ~/work/code/your-workshop/content/modules/ROOT/pages/
   ```

2. **AgnosticV catalog created:**
   ```bash
   # Your catalog structure exists:
   ~/work/code/agnosticv/agd_v2/your-catalog-name/
   ├── common.yaml
   └── dev.yaml
   ```

3. **Both repositories accessible:**
   ```bash
   # Have both repos cloned:
   ~/work/code/
   ├── agnosticv/
   └── your-workshop/
   ```

### What You'll Need

- Path to workshop content repository
- Path to AgnosticV catalog directory
- Workshop metadata (title, abstract, modules)
- Catalog configuration (UUID, category, etc.)

---

## Quick Start

1. Navigate to AgnosticV repository
2. Run `/generate-agv-description`
3. Provide path to workshop content
4. Review generated description.adoc
5. Validate with `/agv-validator`

---

## What It Creates

```
~/work/code/agnosticv/agd_v2/your-catalog-name/
└── description.adoc         # Catalog description for RHDP
```

The description.adoc file includes:
- Workshop title and abstract
- Learning objectives from modules
- Technology stack and prerequisites
- Estimated completion time
- Module/section summaries

---

## Common Workflow

### 1. Create Workshop Content

```
# In workshop repository:
/create-lab
→ Generate workshop modules
```

### 2. Create Catalog Structure

```
# In agnosticv repository:
/agv-generator
→ Create common.yaml and dev.yaml
```

### 3. Generate Description

```
# In agnosticv repository:
/generate-agv-description
→ Extract from workshop content
→ Generate description.adoc
```

### 4. Validate Everything

```
/agv-validator
→ Ensure description meets standards
```

---

## Example Description Structure

```asciidoc
= Workshop Title from Showroom

== Overview

[Workshop abstract extracted from index.adoc]

== What You Will Learn

* Learning objective from module 1
* Learning objective from module 2
* Learning objective from module 3

== Prerequisites

* Technology requirement 1
* Technology requirement 2

== Estimated Time

60 minutes

== Modules

=== Module 1: [Title]
[Summary from module-01.adoc]

=== Module 2: [Title]
[Summary from module-02.adoc]
```

---

## Tips

- **Run after workshop is complete** - description pulls from finished content
- **Review generated description** - may need manual edits
- **Keep workshop and catalog in sync** - update description when workshop changes
- **Use clear module titles** - they appear in description
- **Write good abstracts** - they become catalog overview

---

## Common Customizations

### Add Custom Prerequisites

```asciidoc
== Prerequisites

* Basic OpenShift knowledge
* Familiarity with GitOps concepts
* Red Hat account for image registry
```

### Highlight Key Technologies

```asciidoc
== Technologies Used

* OpenShift 4.x
* Ansible Automation Platform 2.5
* Red Hat OpenShift GitOps
```

### Add Audience Information

```asciidoc
== Target Audience

This workshop is designed for:

* Platform engineers
* DevOps practitioners
* System administrators
```

---

## Troubleshooting

**Skill not found?**
- Restart Claude Code or VS Code
- Verify installation: `ls ~/.claude/skills/generate-agv-description`

**Can't find workshop content?**
- Provide full absolute path to workshop repository
- Verify workshop has content in `content/modules/ROOT/pages/`
- Check that AsciiDoc files exist

**Generated description is incomplete?**
- Ensure workshop modules have proper structure
- Check that module titles are in AsciiDoc format
- Verify workshop abstract exists in index.adoc

**Description doesn't match workshop?**
- Re-run after updating workshop content
- Manually edit description.adoc for custom changes
- Keep both repositories in sync

---

## Related Skills

- `/create-lab` - Create workshop content first
- `/agv-generator` - Create catalog structure
- `/agv-validator` - Validate final result

---

## Manual Editing

After generation, you can manually edit description.adoc to:
- Add screenshots or diagrams
- Customize learning objectives
- Add detailed prerequisites
- Include troubleshooting tips
- Add links to documentation

The file is AsciiDoc format - edit with any text editor.

---

[← Back to Skills](index.html) | [Next: /validation-role-builder →](validation-role-builder.html)
