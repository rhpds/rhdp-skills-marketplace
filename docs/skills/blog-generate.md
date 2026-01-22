---
layout: default
title: /blog-generate
---

# /blog-generate

Transform Red Hat Showroom workshop content into Red Hat Developer blog post format.

---

## Before You Start

### Prerequisites

1. **Complete workshop content:**
   ```bash
   # Your Showroom repository with finished workshop:
   content/modules/ROOT/pages/
   ├── index.adoc
   ├── module-01.adoc
   ├── module-02.adoc
   └── module-03.adoc
   ```

2. **Verify content quality:**
   ```
   # Run verification first:
   /verify-content
   ```

3. **Have blog metadata ready:**
   - Target publication date
   - Blog categories/tags
   - Author bio
   - Featured image (optional)

### What You'll Need

- Completed and verified workshop content
- Blog title (may differ from workshop title)
- Target audience for blog readers
- Call-to-action (try the workshop, sign up, etc.)

---

## Quick Start

1. Navigate to your workshop repository
2. Run `/blog-generate`
3. Answer blog-specific questions
4. Review generated blog post
5. Submit to Red Hat Developer blog team

---

## What It Creates

```
blog/
├── blog-post.md              # Blog post in Markdown
├── assets/
│   └── featured-image.png    # Hero image for post
└── metadata.yml              # Publication metadata
```

---

## Common Workflow

### 1. Create and Verify Workshop

```
/create-lab
→ Generate workshop content

/verify-content
→ Ensure quality
```

### 2. Generate Blog Post

```
/blog-generate
→ Transform to blog format
→ Add narrative flow
→ Include call-to-action
```

### 3. Review and Edit

- Read for blog audience (less technical)
- Add personal insights or experiences
- Include links to workshop and resources
- Add screenshots or diagrams

### 4. Submit for Publication

- Follow Red Hat Developer blog submission process
- Include metadata.yml
- Provide featured image
- Coordinate publication date

---

## Blog vs Workshop Differences

| Workshop | Blog Post |
|----------|-----------|
| Step-by-step instructions | Narrative explanation |
| Technical commands | Conceptual overview |
| Know/Do/Check structure | Story-driven flow |
| Complete procedures | Highlights and insights |
| For hands-on learning | For reading and inspiration |

---

## Tips

- Blog posts are **overview**, not full tutorial
- Focus on **why** and **what you learned**
- Include link to full workshop for details
- Make it personal - add your perspective
- Aim for 800-1200 words
- Use conversational tone
- Add a clear call-to-action at the end

---

## Troubleshooting

**Skill not found?**
- Restart Claude Code or VS Code
- Verify installation: `ls ~/.claude/skills/blog-generate`

**Generated blog is too technical?**
- Edit to focus on concepts over commands
- Add more narrative and context
- Simplify technical jargon

**Blog doesn't flow well?**
- Restructure sections for storytelling
- Add transitions between sections
- Focus on reader journey, not lab steps

---

## Related Skills

- `/create-lab` - Create workshop first
- `/verify-content` - Verify before generating blog
- `/create-demo` - Can also be transformed to blog

---

## Red Hat Developer Blog Resources

- [Red Hat Developer Blog](https://developers.redhat.com/blog)
- [Blog Submission Guidelines](https://developers.redhat.com/blog/write-for-us)
- Contact: developer-content@redhat.com

---

[← Back to Skills](index.html) | [Next: /agv-generator →](agv-generator.html)
