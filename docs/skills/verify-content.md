---
layout: default
title: /verify-content
---

# /verify-content

Validate Showroom workshop or demo content for quality and Red Hat standards compliance.

---

## Before You Start

### Prerequisites

1. **Have workshop or demo content ready:**
   ```bash
   # Your Showroom repository with content in:
   content/modules/ROOT/pages/*.adoc
   ```

2. **Content should be complete:**
   - All module/section files created
   - Navigation structure in place
   - Images and diagrams included
   - Code examples added

### What You'll Need

- Completed workshop or demo content
- Current directory set to your Showroom repository
- All AsciiDoc files saved

---

## Quick Start

1. Navigate to your workshop repository
2. Run `/verify-content`
3. Review validation results
4. Fix any issues found

---

## What It Checks

### Content Quality

- **Structure**: Proper AsciiDoc formatting
- **Navigation**: Links and cross-references work
- **Code blocks**: Syntax highlighting and formatting
- **Images**: Proper paths and alt text

### Red Hat Standards

- **Terminology**: Correct product names
- **Voice**: Active, clear, direct language
- **Style**: Consistent formatting
- **Branding**: Red Hat guidelines compliance

### Technical Accuracy

- **Commands**: Valid syntax
- **Examples**: Working code snippets
- **Versions**: Current product versions
- **URLs**: Valid links to documentation

---

## Common Workflow

### 1. Create Content First

```
/create-lab or /create-demo
→ Generate initial content
```

### 2. Run Verification

```
/verify-content
→ Get quality report
→ See list of issues
```

### 3. Fix Issues

Review each issue and update content:
- Fix AsciiDoc formatting errors
- Update product terminology
- Correct code examples
- Add missing alt text

### 4. Re-verify

```
/verify-content
→ Confirm all issues resolved
```

---

## Example Validation Report

```
✅ Structure: All modules follow Know/Do/Check pattern
✅ Navigation: All links valid
⚠️  Terminology: Found "Openshift" (should be "OpenShift")
⚠️  Code blocks: Missing language identifier in module-02.adoc
❌ Images: Missing alt text for diagram.png
```

---

## Tips

- Run verification before creating pull requests
- Fix issues incrementally (don't batch)
- Use verification as a learning tool
- Check product name capitalization carefully
- Verify all code examples actually work

---

## Troubleshooting

**Skill not found?**
- Restart Claude Code or VS Code
- Verify installation: `ls ~/.claude/skills/verify-content`

**No issues found but content looks wrong?**
- Manual review is still important
- Skill checks common issues, not everything
- Have a colleague review

**Too many errors?**
- Start with critical issues (❌) first
- Then fix warnings (⚠️)
- Style suggestions (ℹ️) are optional

---

## Related Skills

- `/create-lab` - Generate workshop content
- `/create-demo` - Generate demo content
- `/blog-generate` - Convert to blog format

---

[← Back to Skills](index.html) | [Next: /blog-generate →](blog-generate.html)
