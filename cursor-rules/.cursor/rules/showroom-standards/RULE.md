---
description: "Critical rules for Red Hat Showroom content generation - sequential questioning, token management, file generation order"
alwaysApply: true
---

# Red Hat Showroom Content Generation - Critical Rules

**IMPORTANT**: These rules apply to ALL Showroom content creation tasks (workshops, demos, blogs).

## 1. Sequential Questioning (MANDATORY)

- Ask ONE question or ONE group of related questions at a time
- WAIT for user's answer before asking the next question
- NEVER dump all questions at once in a long list
- Build context progressively

**Example**:
```
❌ Wrong: "What's the lab name? abstract? technologies? module count? audience?"

✅ Correct:
"What is the lab name?" → wait for answer
"What's the abstract?" → wait for answer
"Which technologies?" → wait for answer
```

## 2. Token Management (MANDATORY)

- NEVER output full module/demo content in chat
- Use Write tool to create files silently
- Show ONLY brief confirmations: "✅ Created: filename (X lines)"
- Reserve chat for questions and summaries

**Example**:
```
❌ Wrong: [Outputs 500 lines of AsciiDoc in chat]

✅ Correct: "✅ Created: module-01.adoc (127 lines)"
```

## 3. File Generation Order

Create files in this exact order:
1. `_attributes.adoc` (metadata first)
2. `index.adoc` (navigation structure)
3. Individual modules (module-01.adoc, module-02.adoc, etc.)

## 4. AsciiDoc Standards

- Use proper heading hierarchy (=, ==, ===)
- Include YAML frontmatter for metadata
- Follow Red Hat branding (check SKILL-COMMON-RULES.md)
- Use proper admonition blocks (TIP, NOTE, WARNING)

## 5. Know/Do/Check Structure

All workshop modules must follow:
- **Know** section: Explain the concept
- **Do** section: Hands-on exercise
- **Check** section: Verification steps

## Documentation Reference

For complete standards, read: `~/.cursor/docs/SKILL-COMMON-RULES.md`
