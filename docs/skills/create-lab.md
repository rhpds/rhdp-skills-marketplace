---
layout: default
title: /showroom:create-lab
---

# /showroom:create-lab

Create hands-on workshop content where customers follow along step-by-step.

---

## 🤔 Is This The Right Skill?

**Use `/showroom:create-lab` if:**
- ✅ Customers will DO things hands-on (click buttons, run commands)
- ✅ You want Know → Do → Check structure (teach, practice, verify)
- ✅ Multiple participants learning together

**Use `/showroom:create-demo` instead if:**
- ❌ YOU present and customers watch (like a PowerPoint)
- ❌ One-directional presentation

**Not sure?** Labs are more interactive. Demos are more presentational.

---

## Before You Start

### What You Need

Have these ready before running the skill:
- **Workshop topic** (e.g., "Getting started with OpenShift Pipelines")
- **Learning goals** (what should customers learn?)
- **Number of sections** you want (typically 3-5 modules)
- **Reference materials** (product docs, screenshots, etc.)

### What The AI Will Create

The skill generates:
- Navigation page (index.adoc)
- Module files (one per section)
- Know/Do/Check structure for each module
- Placeholder images and examples

**You DON'T need:**
- Git knowledge (the AI can help with that later)
- Coding experience
- AsciiDoc expertise (the AI writes that for you)

---

## Quick Start

1. Open Claude Code (or VS Code with Claude extension)
2. Type `/showroom:create-lab`
3. Answer the AI's questions:
   - Workshop title
   - Abstract (2-3 sentences)
   - Technologies used
   - Number of modules
   - Learning objectives
4. Review generated content
5. Edit and customize as needed

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
/showroom:create-lab
→ Enter workshop details
→ Skill generates module files
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

- `/showroom:verify-content` - Validate generated content
- `/showroom:create-demo` - Create presenter-led demos instead
- `/showroom:blog-generate` - Convert to blog post format

---

[← Back to Skills](../index.html) | [Next: /showroom:verify-content →](verify-content.html)
