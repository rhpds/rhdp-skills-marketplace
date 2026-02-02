---
layout: default
title: Showroom Namespace Setup
---

# Showroom Namespace Setup

Complete setup guide for content creation skills.

---

## Overview

The **showroom** namespace provides AI-powered skills for creating Red Hat Showroom workshop and demo content. These skills focus purely on content creation without infrastructure provisioning.

**Target Audience:** Content creators, technical writers, workshop developers

---

## Installation

Install the showroom namespace:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | bash
# Select: showroom namespace
```

---

## Included Skills

### /showroom:create-lab

Generate workshop lab modules with Red Hat Showroom structure.

**Features:**
- Know/Show pedagogical structure
- Multi-module workshops
- Proper AsciiDoc formatting
- Placeholder attributes for dynamic content

[View detailed documentation →](../skills/create-lab.html)

### /showroom:create-demo

Generate presenter-led demo content.

**Features:**
- Know/Show demo structure
- Presenter notes
- Show-first approach
- Time estimates per section

[View detailed documentation →](../skills/create-demo.html)

### /showroom:verify-content

AI-powered quality validation for workshop and demo content.

**Features:**
- AsciiDoc syntax checking
- Know/Show structure validation
- Exercise clarity checks
- Red Hat style guide compliance

[View detailed documentation →](../skills/verify-content.html)

### /blog-generate

Transform completed lab/demo content into blog posts.

**Features:**
- Blog-appropriate formatting
- Key takeaways extraction
- Call-to-action generation
- Red Hat Developer blog style

[View detailed documentation →](../skills/blog-generate.html)

---

## Prerequisites

### Required

- **Claude Code** or **Cursor** installed
- Basic understanding of AsciiDoc (helpful but not required)

### Optional

- Red Hat Showroom template repository
- GitHub account for publishing
- Red Hat Developer account (for blog publishing)

---

## Typical Workflow

```
1. /showroom:create-lab or /create-demo
   ↓
2. Review and edit generated content
   ↓
3. /verify-content
   ↓
4. Fix any issues identified
   ↓
5. /showroom:blog-generate (optional)
   ↓
6. Publish to Showroom and/or blog
```

---

## Example: Creating a Workshop Lab

### Step 1: Run /create-lab

```
In Claude Code or Cursor:
/showroom:create-lab

Answer prompts:
- Lab name: "CI/CD with OpenShift Pipelines"
- Abstract: "Learn cloud-native CI/CD using Tekton pipelines on OpenShift"
- Technologies: Tekton, OpenShift, Pipelines
- Module count: 3
```

### Step 2: Generated Structure

```
content/modules/ROOT/
├── pages/
│   ├── index.adoc
│   ├── module-01.adoc
│   ├── module-02.adoc
│   └── module-03.adoc
├── partials/
│   └── _attributes.adoc
└── nav.adoc
```

### Step 3: Verify Quality

```
/showroom:verify-content

Reviews:
✓ AsciiDoc syntax
✓ Know/Show structure
✓ Exercise clarity
⚠️ Suggestions for improvement
```

### Step 4: Generate Blog

```
/showroom:blog-generate

Creates:
- Blog post from workshop content
- Introduction and conclusion
- Key takeaways
- Call-to-action
```

---

## Content Structure

### Module Format (Know/Show)

Each module follows this structure:

```asciidoc
= Module Title

== Know (2 minutes)

Brief explanation of the concept...

== Show (8 minutes)

Hands-on exercise:

.Procedure
. Step 1
. Step 2
. Step 3

.Verification
After completing...you should see...
```

### Placeholder Attributes

Use these in your content:

```asciidoc
Console URL: {openshift_console_url}
Username: {user}
Password: {password}
Namespace: {user_namespace}
API URL: {api_url}
```

Defined in `partials/_attributes.adoc`

---

## Tips & Best Practices

### Content Creation

1. **Start with clear objectives** - Know what learners should achieve
2. **Keep modules focused** - One concept per module
3. **Use active voice** - "Create a pipeline" not "A pipeline is created"
4. **Test exercises** - Ensure steps work as documented
5. **Add verification** - Help learners confirm success

### Using Skills

1. **Be specific with prompts** - More detail = better output
2. **Iterate on content** - Run /showroom:create-lab multiple times if needed
3. **Verify early** - Run /showroom:verify-content before extensive edits
4. **Leverage examples** - Ask skills for similar examples

---

## Troubleshooting

### Skill Not Found

**Problem:** `/showroom:create-lab` not recognized

**Solution:**
1. Restart your editor
2. Verify installation: `ls ~/.claude/skills/` or `ls ~/.cursor/skills/`
3. Reinstall if needed

### Generated Content Has Issues

**Problem:** Content doesn't meet quality standards

**Solution:**
1. Run `/showroom:verify-content` to identify specific issues
2. Edit content based on suggestions
3. Re-verify after changes

### Attributes Not Rendering

**Problem:** `{openshift_console_url}` shows as literal text

**Solution:**
Ensure `_attributes.adoc` is defined in `partials/`:

```asciidoc
:openshift_console_url: https://console-openshift-console.apps.cluster.example.com
:user: user1
:password: openshift
```

---

## Next Steps

- [View all skill documentation](../skills/)
- [Read quick reference guide](../reference/quick-reference.html)
- [Check troubleshooting guide](../reference/troubleshooting.html)

---

[← Back to Setup](index.html) | [AgnosticV Setup →](agnosticv.html)
