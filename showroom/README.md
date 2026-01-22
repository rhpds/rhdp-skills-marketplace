# Showroom Namespace

AI-powered skills for creating Red Hat Showroom workshop and demo content.

---

## Overview

The **showroom** namespace provides content creation skills focused on building high-quality workshop labs and presenter-led demos for Red Hat Showroom. These skills generate AsciiDoc content following Red Hat's Know/Show pedagogical structure.

**Target Audience:** Content creators, technical writers, workshop developers, field teams

**Focus:** Pure content creation without infrastructure provisioning

---

## Included Skills

### /create-lab

Generate workshop lab modules with hands-on exercises and learning outcomes.

**Features:**
- Know/Show structure for effective learning
- Multi-module workshops with sequential flow
- Proper AsciiDoc formatting with validation
- Placeholder attributes for dynamic content
- Automatic navigation updates

**Use When:**
- Creating hands-on workshop content
- Building multi-module learning paths
- Need structured exercises with verification

**Output:** Complete lab module with exercises, verification steps, and learning outcomes

[📚 Documentation](https://rhpds.github.io/rhdp-skills-marketplace/skills/create-lab.html)

---

### /create-demo

Generate presenter-led demo content with Know/Show structure.

**Features:**
- Know-first approach for demonstrations
- Presenter notes and timing guidance
- Optional visual cues for slides/diagrams
- Business value emphasis
- Demo-appropriate pacing

**Use When:**
- Creating customer demonstrations
- Building technical briefing content
- Need presenter-led walkthroughs

**Output:** Demo module with presenter guidance and show steps

[📚 Documentation](https://rhpds.github.io/rhdp-skills-marketplace/skills/create-demo.html)

---

### /verify-content

AI-powered quality validation for workshop and demo content.

**Features:**
- AsciiDoc syntax checking
- Know/Show structure validation
- Exercise clarity and completeness
- Red Hat style guide compliance
- Accessibility checks

**Use When:**
- Before publishing content
- After editing existing modules
- Quality assurance reviews

**Output:** Validation report with errors, warnings, and suggestions

[📚 Documentation](https://rhpds.github.io/rhdp-skills-marketplace/skills/verify-content.html)

---

### /blog-generate

Transform completed lab or demo content into blog posts.

**Features:**
- Extracts key takeaways from modules
- Blog-appropriate formatting and tone
- Call-to-action generation
- Source attribution
- Red Hat Developer blog style

**Use When:**
- Publishing workshop as blog content
- Creating marketing content from demos
- Sharing technical knowledge externally

**Output:** Blog post ready for Red Hat Developer or internal blogs

[📚 Documentation](https://rhpds.github.io/rhdp-skills-marketplace/skills/blog-generate.html)

---

## Typical Workflows

### Creating a New Workshop

```
1. /create-lab
   └─ Answer prompts (name, abstract, technologies, module count)

2. Review generated content in your editor

3. /verify-content
   └─ Check for quality issues

4. Fix any issues identified

5. /verify-content (again)
   └─ Confirm all issues resolved

6. /blog-generate (optional)
   └─ Create promotional blog post

7. Publish to Showroom
```

### Creating a Demo

```
1. /create-demo
   └─ Answer prompts (name, abstract, technologies)

2. Review generated content

3. /verify-content
   └─ Quality check

4. Fix issues and verify again

5. Present or publish
```

### Updating Existing Content

```
1. Edit module content manually

2. /verify-content
   └─ Validate changes

3. Fix any new issues

4. Publish updated content
```

---

## Content Structure

### Generated Files

After running `/create-lab` or `/create-demo`, you'll have:

```
content/modules/ROOT/
├── pages/
│   ├── index.adoc                    # Workshop/demo home
│   ├── module-01-introduction.adoc   # First module
│   ├── module-02-core-concepts.adoc  # Second module
│   └── module-03-advanced.adoc       # Third module
│
├── partials/
│   └── _attributes.adoc              # Shared variables
│
└── nav.adoc                          # Navigation menu
```

### Module Format (Know/Show)

Each module follows this structure:

```asciidoc
= Module Title

== Know (Explanation)

Brief explanation of concepts (2-3 minutes)

== Show (Hands-on)

Hands-on exercise with clear steps (8-10 minutes)

.Procedure
. Step 1 with command
. Step 2 with verification
. Step 3 with outcome

.Verification
After completing, you should see...

== Learning Outcomes

* Understanding of concept A
* Ability to perform task B
* Knowledge of pattern C

== References

* Link to official docs
* Link to related content
```

---

## Placeholder Attributes

Skills use placeholder attributes for environment-specific values:

```asciidoc
:openshift_console_url: {openshift_console_url}
:user: {user}
:password: {password}
:api_url: {api_url}
:namespace: {user_namespace}
```

These are defined in `partials/_attributes.adoc` and replaced during deployment.

---

## Best Practices

### Content Creation

1. **Start with clear objectives** - Know what learners should achieve
2. **Keep modules focused** - One concept per module (20-40 minutes)
3. **Use active voice** - "Create a pipeline" not "A pipeline is created"
4. **Test exercises** - Ensure all steps work as documented
5. **Add verification** - Help learners confirm success

### Using Skills

1. **Be specific with prompts** - More detail = better output
2. **Iterate on content** - Run skills multiple times if needed
3. **Verify early** - Run `/verify-content` before extensive manual edits
4. **Leverage examples** - Ask skills for similar examples
5. **Follow Know/Show** - Keep explanation brief, focus on hands-on

### Quality

1. **Validate before publishing** - Always run `/verify-content`
2. **Check all xrefs** - Ensure navigation links work
3. **Test on clean environment** - Verify steps work for new users
4. **Get peer review** - Have colleague review content
5. **Update regularly** - Keep content current with product versions

---

## Common Rules

All skills follow shared contracts defined in:

**📄 `showroom/docs/SKILL-COMMON-RULES.md`**

Key rules:
- Version pinning or attribute placeholders (REQUIRED)
- Reference enforcement for technical accuracy
- Attribute file location (`partials/_attributes.adoc`)
- AsciiDoc list formatting with blank lines
- Image path conventions with clickable images
- Navigation updates for every module

---

## Troubleshooting

### Skills Not Working

**Symptom:** `/create-lab` not recognized

**Solution:**
1. Restart your editor (Claude Code or Cursor)
2. Verify installation: `ls ~/.claude/skills/` or `ls ~/.cursor/skills/`
3. Reinstall if needed

### Generated Content Has Issues

**Symptom:** `/verify-content` reports many errors

**Solution:**
1. Fix **errors** first (blocking issues)
2. Address **warnings** (best practices)
3. Consider **suggestions** (optional)
4. Re-run `/verify-content` after fixes

### Attributes Not Rendering

**Symptom:** `{openshift_console_url}` shows as literal text

**Solution:**
Ensure `partials/_attributes.adoc` exists and contains:

```asciidoc
:openshift_console_url: https://console.example.com
:user: user1
:password: openshift
```

And modules include it:

```asciidoc
include::partial$_attributes.adoc[]
```

---

## Support

- **Documentation:** https://rhpds.github.io/rhdp-skills-marketplace
- **GitHub Issues:** https://github.com/rhpds/rhdp-skills-marketplace/issues
- **Slack:** [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX)

---

## Related Namespaces

- [**agnosticv**](../agnosticv/README.md) - RHDP provisioning and infrastructure
- [**health**](../health/README.md) - Post-deployment validation and health checks
- [**automation**](../automation/README.md) - Intelligent automation and workflow orchestration

---

**Version:** v1.0.0
**Last Updated:** 2026-01-22
**Maintained By:** RHDP Team
