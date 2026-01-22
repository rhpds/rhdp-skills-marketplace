---
layout: default
title: /create-lab
---

# /create-lab

Generate Red Hat Showroom workshop lab modules with Know/Do/Check structure.

---

## Before You Start

### Prerequisites

1. **Create your workshop repository from the template:**
   ```bash
   # Use the Red Hat Showroom template
   # Go to: https://github.com/rhpds/showroom_template
   # Click "Use this template" → "Create a new repository"
   ```

2. **Clone your new repository:**
   ```bash
   git clone git@github.com:yourusername/your-workshop.git
   cd your-workshop
   ```

3. **Have your content ready:**
   - Product documentation URLs
   - Architecture diagrams or screenshots
   - Learning objectives (what users will learn)

### What You'll Need

- Workshop title and abstract
- Number of modules (typically 3-5)
- Technology stack (OpenShift, AAP, etc.)
- Estimated completion time

---

## Quick Start

1. Open Claude Code in your workshop repository
2. Run `/create-lab`
3. Answer the guided questions
4. Review generated content

---

## What It Creates

```
content/modules/ROOT/
├── pages/
│   ├── index.adoc              # Navigation home
│   ├── module-01.adoc          # First module
│   ├── module-02.adoc          # Second module
│   └── module-03.adoc          # Third module
└── partials/
    └── _attributes.adoc        # Workshop metadata
```

---

## Common Workflow

### 1. Create Module Structure

```
/create-lab
→ Enter workshop details
→ Skill generates module files
```

### 2. Verify Content

```
/verify-content
→ Check quality and standards
```

### 3. Generate Blog Post (Optional)

```
/blog-generate
→ Transform to blog format
```

---

## Example Module Structure

Each module follows **Know → Do → Check** pattern:

**Know Section:**
- Explains the concept
- Provides context and background

**Do Section:**
- Hands-on exercise
- Step-by-step instructions
- Code examples with syntax highlighting

**Check Section:**
- Verification steps
- Expected results
- Troubleshooting tips

---

## Tips

- Start with 3-4 modules for new workshops
- Each module should take 10-15 minutes
- Keep Do sections focused on one main task
- Use screenshots sparingly (AsciiDoc format)

---

## Troubleshooting

**Skill not found?**
- Restart Claude Code or VS Code
- Verify installation: `ls ~/.claude/skills/create-lab`

**Generated content looks wrong?**
- Check your workshop template is up to date
- Verify you're in the correct directory

---

## Related Skills

- `/verify-content` - Validate generated content
- `/create-demo` - Create presenter-led demos instead
- `/blog-generate` - Convert to blog post format

---

[← Back to Skills](../index.html) | [Next: /verify-content →](verify-content.html)
