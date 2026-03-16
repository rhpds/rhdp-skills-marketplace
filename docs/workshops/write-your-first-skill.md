---
layout: default
title: Write Your First Skill
---

# Write Your First Skill

<div class="reference-badge">Workshop 2 · For Red Hatters</div>

<div class="callout callout-info">
<span class="callout-icon">🛠️</span>
<div class="callout-body">
<strong>Who this is for:</strong> Anyone who finished Workshop 1 and has a workflow they repeat more than once a week. You'll write a real skill — something you'll actually use.<br><br>
<strong>What you'll build:</strong> A working Claude Code skill that you can trigger with one command. We'll use a fun example (standup generator), then you'll swap in your own workflow.
</div>
</div>

---

## What Even Is a Skill?

A skill is a markdown file that tells Claude how to behave when you invoke it.

When you type `/my-skill`, Claude reads the file and follows the instructions inside it — asking you questions, generating output, creating files, whatever you defined.

That's it. No code. No APIs. Just a markdown file with instructions.

Here's the simplest possible skill:

```markdown
---
name: hello
description: Say hello to the user
---

# Hello Skill

Ask the user their name.
Then write a haiku about them.
```

Save that as `SKILL.md`, install it, type `/hello` — Claude asks your name and writes you a haiku. Done. That's a skill.

---

## The Skill We're Building

**The Standup Generator.**

Every morning you write a standup. It's always the same: what you did, what you're doing, any blockers. Except nobody reads them and you could write it in your sleep.

Let's make it interesting. This skill will:
1. Ask what you worked on, what's next, and any blockers
2. Generate your standup in **any style you want** — professional, haiku, movie trailer, pirate, Hemingway
3. Output something your team might actually read

---

## Module 1 — Understand the Anatomy

Every skill has two parts: **frontmatter** (the metadata) and **instructions** (what Claude does).

```markdown
---
name: standup              ← the command: /standup
description: Generate my daily standup in any style.
  Use when the user wants to write their daily standup.
context: main              ← runs in your main conversation
model: claude-opus-4-6    ← which model to use
---

# Instructions go here
```

The `description` is important — Claude reads it to decide when to invoke the skill automatically. Write it like you're describing the skill to a colleague.

The `name` becomes your slash command. Keep it short.

---

## Module 2 — Write the Instructions

This is the whole skill. Instructions are plain English — just tell Claude what to do:

```markdown
---
name: standup
description: Generate my daily standup update. Use when the user
  wants to write their standup, daily update, or team check-in.
context: main
model: claude-opus-4-6
---

# Daily Standup Generator

Help the user write their daily standup update.

## Step 1 — Gather Information

Ask these questions ONE AT A TIME. Wait for each answer before asking the next.

1. "What did you work on yesterday?"
2. "What are you working on today?"
3. "Any blockers or things you need from anyone?"
4. "What style? Options:
   - Normal (professional, concise)
   - Haiku (three lines, 5-7-5 syllables)
   - Movie trailer (dramatic, over the top)
   - Hemingway (short sentences, no fluff)
   - Pirate (arrr)
   - Or suggest your own style"

## Step 2 — Generate the Standup

Write the standup in the chosen style. Keep it under 100 words
for any style except movie trailer (which can be as dramatic as needed).

## Step 3 — Offer Alternatives

After generating, say:
"Want it in a different style? Just say which one."

## Rules
- Never ask all questions at once — one at a time, wait for answers
- Match the chosen style completely — if pirate, go full pirate
- Keep the actual content accurate — fun style, real information
```

**That's your complete skill.** Read it again — it's just instructions for Claude written in plain English. No code.

---

## Module 3 — Package and Install It

Create the directory structure:

```bash
mkdir -p ~/my-skills/.claude-plugin
mkdir -p ~/my-skills/skills/standup
```

Save your skill:

```bash
nano ~/my-skills/skills/standup/SKILL.md
# paste the content from Module 2
```

Create the plugin manifest:

```bash
nano ~/my-skills/.claude-plugin/plugin.json
```

```json
{
  "name": "my-skills",
  "version": "1.0.0",
  "description": "My personal Claude Code skills"
}
```

Install it locally (no git push needed):

```bash
claude --plugin-dir ~/my-skills
```

---

## Module 4 — Test It

You're now in Claude Code with your skill loaded. Type:

```text
/standup
```

Claude should ask: "What did you work on yesterday?"

Answer it. Then answer the next question. When it asks for style, say "pirate."

You should get something like:

```
Ahoy crew! Yesterday I sailed the treacherous waters of
customer demo prep, navigating the rocky shores of slide
deck revision. Today I chart a course for the prospect
call at 2pm — may the wind be in our sales. No blockers,
unless ye count the scurvy meeting that appeared at noon.
Arr.
```

If it works — congrats, you built a skill.

<div class="callout callout-tip">
<span class="callout-icon">✅</span>
<div class="callout-body">
<strong>Reload without restarting:</strong> If you edit the SKILL.md, type <code>/reload-plugins</code> in your Claude session. No need to restart Claude Code.
</div>
</div>

---

## Module 5 — Iterate and Improve

Skills get better when you use them. Here's how to improve yours:

**Problem: Claude asks all questions at once**
→ Add to your instructions: "CRITICAL: Ask ONE question at a time. Do NOT list all questions together."

**Problem: The styles aren't distinct enough**
→ Add examples: "Hemingway example: 'I fixed the bug. It took three hours. There was coffee.'"

**Problem: Output is too long**
→ Add a rule: "Keep ALL styles under 80 words. Movie trailer: under 60 words but maximum drama."

**Problem: It forgets to offer alternatives**
→ Make Step 3 more explicit: "ALWAYS end with: 'Type a style name for a different version.'"

This is the iteration loop: use → notice what's off → fix the instructions → reload. Most skills take 3-4 iterations to feel right.

---

## Module 6 — Now Build YOUR Skill

The standup example was just to teach the format. Now build something you actually need.

**What to pick:** Something you do more than once a week that involves:
- Answering the same questions
- Generating the same type of document
- Following the same process with slight variations each time

**Red Hat examples by role:**

<div class="category-grid">
<div class="category-card">
<span class="category-icon">💼</span>
<h3>Sales / Pre-Sales</h3>
<ul>
<li>Customer briefing doc generator</li>
<li>Objection handler for a specific product</li>
<li>Demo request formatter</li>
<li>"Why Red Hat" one-pager for a given industry</li>
</ul>
</div>

<div class="category-card">
<span class="category-icon">🏗️</span>
<h3>Solutions Architects</h3>
<ul>
<li>Architecture review checklist</li>
<li>Proof-of-concept scope doc</li>
<li>Technical comparison (product A vs B)</li>
<li>Customer success story template</li>
</ul>
</div>

<div class="category-card">
<span class="category-icon">💻</span>
<h3>Developers</h3>
<ul>
<li>PR description generator</li>
<li>Commit message formatter</li>
<li>ADR (Architecture Decision Record) writer</li>
<li>Bug report formatter</li>
</ul>
</div>

<div class="category-card">
<span class="category-icon">😄</span>
<h3>Just For Fun</h3>
<ul>
<li>Meeting agenda that people will actually read</li>
<li>Slack message translator (corporate → plain English)</li>
<li>Team award generator ("Most Heroic Firefighting of the Week")</li>
<li>Red Hat release notes in haiku</li>
</ul>
</div>
</div>

**The process — same as the standup:**

1. Write the instructions in plain English (`SKILL.md`)
2. Package it (`plugin.json`)
3. Install locally (`claude --plugin-dir`)
4. Test it — iterate 3-4 times
5. Share with your team

---

## Sharing With Your Team

Once your skill works, push it to a GitHub repo:

```bash
cd ~/my-skills
git init && git add . && git commit -m "Add standup skill"
gh repo create my-claude-skills --public --push --source=.
```

Your teammates install it with:

```bash
claude --plugin-dir github:yourhandle/my-claude-skills
```

Or they can add it to the RHDP Skills Marketplace — see the [Plugin Dev Toolkit]({{ '/contributing/plugin-dev-plugin.html' | relative_url }}) for how.

---

## What You've Learned

- A skill is a markdown file with instructions — no code required
- The frontmatter (`name`, `description`, `model`) defines the command and trigger
- Instructions are plain English — write them like you're briefing a colleague
- Iteration is normal: use → notice → fix → reload
- Any repetitive workflow is a skill candidate

**You built a standup generator in pirate voice. Now imagine what you'll automate next.**

<div class="navigation-footer">
  <a href="{{ '/workshops/claude-basics.html' | relative_url }}" class="nav-button">← Workshop 1</a>
  <a href="{{ '/contributing/create-your-own-skill.html' | relative_url }}" class="nav-button">Full Skill Guide →</a>
</div>
