---
layout: default
title: /create-demo
---

# /create-demo

Generate Red Hat Showroom presenter-led demo content with Know/Show structure.

---

## Before You Start

### Prerequisites

1. **Create your demo repository from the template:**
   ```bash
   # Use the Red Hat Showroom template
   # Go to: https://github.com/rhpds/showroom_template
   # Click "Use this template" → "Create a new repository"
   ```

2. **Clone your new repository:**
   ```bash
   git clone git@github.com:yourusername/your-demo.git
   cd your-demo
   ```

3. **Have your content ready:**
   - Demo script or flow
   - Key talking points
   - Screenshots or diagrams to show
   - Product features to highlight

### What You'll Need

- Demo title and description
- Number of sections (typically 3-4)
- Technology stack (OpenShift, AAP, etc.)
- Estimated presentation time
- Target audience (technical, business, etc.)

---

## Quick Start

1. Open Claude Code in your demo repository
2. Run `/create-demo`
3. Answer the guided questions
4. Review generated content

---

## What It Creates

```
content/modules/ROOT/
├── pages/
│   ├── index.adoc              # Navigation home
│   ├── section-01.adoc         # First section
│   ├── section-02.adoc         # Second section
│   └── section-03.adoc         # Third section
└── partials/
    └── _attributes.adoc        # Demo metadata
```

---

## Common Workflow

### 1. Create Demo Structure

```
/create-demo
→ Enter demo details
→ Skill generates section files
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

## Example Section Structure

Each section follows **Know → Show** pattern:

**Know Section:**
- Explains what you'll demonstrate
- Provides context and business value
- Sets up the "why"

**Show Section:**
- Step-by-step demo script
- What to click/type/show
- Expected results and talking points
- Screenshots with annotations

---

## Tips

- Start with 3-4 sections for new demos
- Each section should take 5-10 minutes
- Keep Show sections focused on one main feature
- Include presenter notes for timing
- Use screenshots to guide the flow

---

## Troubleshooting

**Skill not found?**
- Restart Claude Code or VS Code
- Verify installation: `ls ~/.claude/skills/create-demo`

**Generated content looks wrong?**
- Check your demo template is up to date
- Verify you're in the correct directory

**Demo vs Lab confusion?**
- Use `/create-demo` for presenter-led content (Know/Show)
- Use `/create-lab` for hands-on workshops (Know/Do/Check)

---

## Related Skills

- `/verify-content` - Validate generated content
- `/create-lab` - Create hands-on workshops instead
- `/blog-generate` - Convert to blog post format

---

[← Back to Skills](index.html) | [Next: /verify-content →](verify-content.html)
