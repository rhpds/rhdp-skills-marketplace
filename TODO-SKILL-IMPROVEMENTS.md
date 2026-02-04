# Skill Improvement TODOs

## High Priority: Showroom Skills Content Quality

### Issue
Generated content quality is poor because skills don't have access to real Showroom examples.

**Reported by:** Nate
**Date:** 2026-02-04
**Impact:** Users have to manually rewrite generated modules

### Root Cause
Skills attempt to fetch reference content from GitHub URLs that return 404:
```
https://raw.githubusercontent.com/rhpds/lb1726-mcp-showroom/main/content/modules/ROOT/pages/02-demo.adoc (404)
https://raw.githubusercontent.com/rhpds/lb1726-mcp-showroom/main/content/modules/ROOT/pages/03-mcp-server-admin.adoc (404)
https://raw.githubusercontent.com/rhpds/lb1726-mcp-showroom/main/content/modules/ROOT/pages/04-mcp-registry.adoc (404)
```

Without real examples, AI generates generic content that doesn't match Showroom quality.

### Solution

Add reference repository check to Showroom skills:

**Skills to Update:**
1. `showroom/skills/create-lab/SKILL.md`
2. `showroom/skills/create-demo/SKILL.md`
3. `showroom/skills/verify-content/SKILL.md`

**Implementation:**

Add this section at the beginning of each skill:

```markdown
## Step 0: Reference Repository Setup (IMPORTANT)

Before generating content, we need access to real Showroom examples for quality reference.

**Ask the user:**
"Do you have a Showroom repository cloned locally that I can reference for patterns and examples?"

**If YES:**
- Ask for the path (e.g., `~/work/showroom-content/my-workshop`)
- Use it to analyze:
  - Module structure and formatting
  - AsciiDoc patterns and syntax
  - Content depth and technical style
  - Navigation and include patterns

**If NO:**
- Offer to clone a public Showroom template:
  ```bash
  git clone https://github.com/rhpds/showroom-template /tmp/showroom-reference
  ```
- Use this reference for generating quality content

**With Reference Available:**
1. Read 2-3 example modules from `content/modules/ROOT/pages/*.adoc`
2. Analyze:
   - Section structure (= Title, == Heading, === Subheading)
   - Code block formatting and syntax highlighting
   - Admonition usage (TIP, NOTE, WARNING)
   - Image and diagram patterns
   - Navigation includes and xrefs
3. Generate new content matching these patterns

**Why This Matters:**
- Ensures generated content matches real Showroom quality
- Reduces manual rewrites from "crap" to usable content
- AI learns from actual examples, not generic patterns
- Faster iteration, fewer back-and-forth edits
```

### Expected Outcome

- **Before Fix:** Module 2 is "crap", requires manual rewrite with actual showroom docs
- **After Fix:** Modules generated with quality matching real Showroom content from first iteration

### Testing

1. Run `/showroom:create-lab` WITHOUT reference repo → Should offer to clone template
2. Run `/showroom:create-lab` WITH reference repo → Should analyze and match quality
3. Compare generated content quality before/after fix

### Priority: HIGH
This directly impacts user satisfaction and reduces rework time from 5 days to hours.

---

## Other Improvements

### TODO: Add auto-detection for AgnosticV repository
Similar pattern - check if `~/work/code/agnosticv` exists before running catalog-builder

### TODO: Add validation for required tools
Check if `ansible`, `git`, `gh` CLI are installed before running skills that need them

### TODO: Improve error messages
When WebFetch fails with 404, explain clearly that reference content is unavailable
