---
layout: default
title: /showroom:create-demo
---

# /showroom:create-demo

Create presenter-led demo content where YOU present and customers watch.

---

## 🤔 Is This The Right Skill?

**Use `/showroom:create-demo` if:**
- ✅ YOU present while customers watch (like presenting PowerPoint)
- ✅ You want Know → Show structure (explain, then demonstrate)
- ✅ One presenter showing features

**Use `/showroom:create-lab` instead if:**
- ❌ Customers do hands-on activities (click buttons, run commands)
- ❌ Multiple participants following step-by-step instructions

**Not sure?** Demos are presentational (you drive). Labs are interactive (customers drive).

---

## Before You Start

### What You Need

Have these ready before running the skill:
- **Demo topic** (e.g., "OpenShift AI capabilities")
- **Key features** to highlight
- **Number of sections** you want (typically 3-4 segments)
- **Target audience** (technical, business, executive)
- **Screenshots or talking points** (optional, can add later)

### What The AI Will Create

The skill generates:
- Navigation page (index.adoc)
- Section files (one per demo segment)
- Know/Show structure for each section
- Presenter notes and customer-facing content

**You DON'T need:**
- Git knowledge (the AI can help with that later)
- Coding experience
- AsciiDoc expertise (the AI writes that for you)

---

## Quick Start

1. Open Claude Code (or VS Code with Claude extension)
2. Type `/showroom:create-demo`
3. Answer the AI's questions:
   - Demo title
   - Description (2-3 sentences)
   - Technologies/products to demo
   - Number of sections
   - Target audience level
4. Review generated content
5. Add your screenshots and customize

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
/showroom:create-demo
→ Enter demo details
→ Skill generates section files
```

### 2. Verify Content

```
/showroom:verify-content
→ Check quality and standards
```

### 3. Generate Blog Post (Optional)

```
/showroom:blog-generate
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
- Use `/showroom:create-demo` for presenter-led content (Know/Show)
- Use `/showroom:create-lab` for hands-on workshops (Know/Do/Check)

---

## Related Skills

- `/showroom:verify-content` - Validate generated content
- `/showroom:create-lab` - Create hands-on workshops instead
- `/showroom:blog-generate` - Convert to blog post format

---

[← Back to Skills](index.html) | [Next: /showroom:verify-content →](verify-content.html)
