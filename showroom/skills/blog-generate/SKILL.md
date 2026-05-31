---
name: showroom:blog-generate
description: This skill should be used when the user asks to "turn this lab into a blog post", "write a blog post from this module", "generate a blog from my Showroom content", "convert my workshop to a blog", "write a Red Hat Developer blog post", or "create a blog post from my demo".
---

---
context: main
model: claude-sonnet-4-6
---

# Blog Generator

Orchestrates agents to transform completed Red Hat Showroom lab or demo content into blog posts for Red Hat Developer, internal blogs, or marketing platforms.

## Architecture

This skill is an orchestrator. Transformation and review are delegated to agents:
- `showroom:file-generator` (Sonnet) — reads source .adoc files, transforms to blog Markdown
- `showroom:module-reviewer` (Sonnet) — quality check on generated blog post

See `@showroom/docs/SKILL-COMMON-RULES.md` for source traceability and attribution rules.

---

## Phase 1 — Planning Form (ALL questions at once)

```
Let's set up your blog post. Answer what you know:

Source modules (file paths to completed .adoc modules — can be multiple):

Target platform:
  1. Red Hat Developer (developers.redhat.com)
  2. Internal Red Hat (Source, Memo, The Stack)
  3. Medium / dev.to / Hashnode
  4. Marketing / announcement

Blog type:
  1. Technical tutorial ("How to...")
  2. Product announcement ("Introducing...")
  3. Thought leadership ("Why...")
  4. Case study / success story
  5. Quick start guide

Technical depth:
  1. Highly technical (code-heavy, for developers)
  2. Moderately technical (balanced)
  3. Marketing-focused (business benefits, light on code)

Target word count: 500-800 / 1000-1500 / 2000+ (or leave blank for auto)

Showroom link for "Try it yourself" CTA (optional):
```

Confirm in one line:
```
📋 Blog plan: [type] for [platform] — [depth] — [word count]
Source: [N modules]

Generating blog post...
```

---

## Phase 2 — Spawn File Generator Agent

```
Task tool:
  subagent_type: showroom:file-generator
  prompt: |
    TARGET_FILE: <output path, e.g. blog-post.md>
    FILE_TYPE: blog
    CONTENT_TYPE: <workshop|demo>
    LAB_TYPE: <ocp|rhel|vm|ai|unknown>
    REPO_PATH: <repo root if known, else none>
    FULL_SPEC:
      source_files: [<list of .adoc paths>]
      blog_type: <tutorial|announcement|thought-leadership|case-study|quick-start>
      platform: <redhat-developer|internal|medium|marketing>
      technical_depth: <highly-technical|moderately-technical|marketing-focused>
      word_count: <500-800|1000-1500|2000+>
      showroom_link: <URL or null>
      lab_name: <auto-detected from source>
```

---

## Phase 3 — Inline Quality Check

The file-generator agent applies blog-specific quality checks internally. After it returns, verify:

- Tone is narrative and conversational — not a numbered step list
- Word count matches requested target (±20%)
- At least one code block is present for technical posts
- CTA appears at the end (if showroom_link was provided)
- All external links are valid references from source material
- Source attribution present (one of):
  - Red Hat Developer: "This post is based on the workshop [Lab Name](showroom_link)"
  - Internal: "Source: [original module path]"
  - Marketing: "Based on customer use cases from [reference]"

Fix any issues inline before delivering.

---

## Phase 4 — Deliver

```
✅ Blog post generated: <filename> (<word_count> words)

Quality: 0 Critical, 0 High, N Warnings
  [list warnings if any]

Platform guidance:
  Red Hat Developer: Submit at developers.redhat.com/write-for-us
  Internal: Post to Source or Memo
```

---

## Blog types reference

| Source | Blog type | What changes |
|---|---|---|
| Workshop | Tutorial | Exercises → narrative how-to, keep code |
| Workshop | Quick start | First module only, condensed |
| Demo Know | Announcement | Business value extraction |
| Demo Show | Case study | Capability walkthrough |
| Any | Thought leadership | Patterns + trends, minimal code |

---

## Related Skills

- `/showroom:create-lab` — create workshop content
- `/showroom:create-demo` — create demo content
- `/showroom:verify-content` — verify content quality
