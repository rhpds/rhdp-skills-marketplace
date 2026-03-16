---
layout: default
title: Your First Hour with Claude Code
---

# Your First Hour with Claude Code

<div class="reference-badge">Workshop 1 · For Red Hatters</div>

<div class="callout callout-info">
<span class="callout-icon">🎯</span>
<div class="callout-body">
<strong>Who this is for:</strong> Any Red Hatter — sales engineer, solutions architect, developer, consultant, manager. You don't need a coding background.<br><br>
<strong>What you'll build:</strong> A working Claude Code setup that remembers your role, your writing style, and your preferences — so you stop re-explaining yourself every session.
</div>
</div>

---

## Before You Start

Verify Claude Code is installed:

```bash
claude --version
```

If that fails, go to [Claude Code Setup]({{ '/setup/claude-code.html' | relative_url }}) first. Takes 5 minutes.

---

## Module 1 — Your First Real Conversation

Open a terminal and start Claude Code in any directory you're working in:

```bash
mkdir ~/my-rh-workspace && cd ~/my-rh-workspace
claude
```

Don't overthink it. Just talk to it. Try this:

```text
I'm a Red Hat solutions architect. I have a customer call tomorrow
with a manufacturing company asking about OpenShift Virtualization.
What should I prepare?
```

Claude will suggest a prep plan. Now push further:

```text
Draft a 3-bullet executive summary of why they should move
from VMware to OpenShift Virtualization. Make it concise —
for a VP of Infrastructure, not a developer.
```

You just used Claude to do 20 minutes of prep work in 30 seconds.

<div class="callout callout-tip">
<span class="callout-icon">✅</span>
<div class="callout-body">
<strong>Checkpoint:</strong> Claude produced something useful without you setting up anything. But it doesn't know you're a Red Hatter, it doesn't know Red Hat's tone guidelines, and next session it will have forgotten this conversation entirely. The next modules fix that.
</div>
</div>

**Try the commands you'll use constantly:**

```text
/help
```

The ones you'll reach for daily:

| Command | Use it when |
|---|---|
| `/clear` | Switching to a different topic or task |
| `/compact` | Session is getting long — summarise to free space |
| `/model` | Switch to Opus for complex writing or analysis |
| `/rename` | Name the session so you can pick it up tomorrow |

---

## Module 2 — Give Claude Your Context

Right now Claude is helpful but generic. Let's make it know you.

**Create your global memory file:**

```bash
nano ~/CLAUDE.md
```

This file loads automatically in every session, every directory. Write in plain language — no special format needed:

```markdown
## Who I Am
I'm a Red Hat [your role — solutions architect / sales engineer /
consultant / developer].

I work with customers in [your region/segment — e.g. financial
services, public sector, EMEA].

## My Tone
- Direct and practical — not corporate
- Active voice, second person ("you will", not "we will")
- No buzzwords: avoid "leverage", "synergy", "robust", "game-changer"
- Red Hat style: use exact product names (OpenShift, not OCP)

## My Common Tasks
[Write what you actually do — e.g.]
- Prepare customer presentations and solution briefs
- Write technical comparisons for sales opportunities
- Create proof-of-concept documentation

## Red Hat Writing Rules
- Always use official product names: Red Hat OpenShift,
  Red Hat Ansible Automation Platform, Red Hat Enterprise Linux
- Sentence case for headings — not Title Case Every Word
- Oxford comma in lists of 3+
```

Save it. Now start a new session:

```bash
claude
```

```text
Who am I and how do I like to work?
```

Claude reads your CLAUDE.md and describes you back. Every session from now on starts with this context loaded automatically.

<div class="callout callout-tip">
<span class="callout-icon">✅</span>
<div class="callout-body">
<strong>Checkpoint:</strong> Claude now knows your role, your tone preferences, and your writing rules — without you saying a word. This is the difference between Claude feeling like a generic AI and feeling like a colleague who knows your work.
</div>
</div>

**Project-level memory (for specific repos or folders):**

If you work in a specific directory repeatedly — a customer folder, a project repo, a team shared drive — add a CLAUDE.md there too:

```bash
cd ~/work/customer-acme
nano CLAUDE.md
```

```markdown
## Acme Corp — Manufacturing Customer

Industry: Automotive manufacturing, 12,000 employees
Current stack: VMware vSphere 7, some AWS, legacy RHEL 7
Primary pain: VMware licensing costs after Broadcom acquisition
Champion: Jane Smith (VP Infrastructure), skeptical of cloud-native

## Key Messages for This Account
- OpenShift Virtualization = familiar VM management + modern platform
- Migration path: lift-and-shift first, modernise later — not big bang
- Proof point: Ford migrated 2,000 VMs, reduced infrastructure costs 40%
```

Now when you work in that folder, Claude knows the customer context without you re-explaining it every time.

---

## Module 3 — Write Faster with Claude

Here's where most Red Hatters immediately get value. Let's do a real writing task.

**Exercise: Write a customer-ready one-pager**

```text
Write a one-page executive brief for Acme Corp explaining
why they should migrate from VMware to Red Hat OpenShift
Virtualization.

Audience: VP of Infrastructure
Tone: direct, business-focused — not technical deep dive
Length: 400 words max
Format: Problem → Solution → Why Red Hat → Next Step

Their main concern is cost and operational disruption.
Reference the Broadcom acquisition impact on VMware licensing.
```

Claude will generate a draft. Don't accept the first draft — iterate:

```text
The opening is too generic. Start with a specific number
about VMware licensing cost increase post-Broadcom.
```

```text
Change the "Why Red Hat" section to focus on migration
support services, not just the product features.
```

```text
Make the call to action more specific — propose a
free migration assessment workshop, not just "contact us".
```

**You just ran three revision cycles in two minutes.** The total time from blank page to polished draft: under 5 minutes.

<div class="callout callout-tip">
<span class="callout-icon">✅</span>
<div class="callout-body">
<strong>The pattern:</strong> Generate → critique → iterate. Don't try to get perfect output on the first prompt. Ask for a draft, then give specific feedback. Claude gets better with each round.
</div>
</div>

---

## Module 4 — Context Discipline

The #1 reason people give up on Claude Code is sessions that go wrong. Here's why it happens and how to prevent it.

**The context window fills up silently.** When it's full, Claude starts ignoring rules from earlier in the conversation — no warning, no error. It just gets worse.

**The fix is simple: clear between topics.**

```text
/clear
```

Use it whenever you finish one task and start another. It feels wasteful to start fresh, but it's faster than debugging why Claude is giving you generic output an hour in.

**For long sessions on a single task, compact proactively:**

```text
/compact Keep the customer context (Acme Corp, VMware migration),
the executive tone, and the one-pager structure we've established.
I still need to write the follow-up email and the slide deck outline.
```

Without instructions, `/compact` just summarises. With instructions, it keeps exactly what you need.

**Name sessions you want to continue later:**

```text
/rename acme-vmware-migration-prep
```

Tomorrow:

```bash
claude --resume acme-vmware-migration-prep
```

The whole conversation restores. You pick up exactly where you left off.

<div class="callout callout-warning">
<span class="callout-icon">⚠️</span>
<div class="callout-body">
<strong>Common mistake:</strong> Using one long session all day for different customers and tasks. By afternoon, Claude is mixing up customer names, using the wrong tone, and ignoring your style rules. Use <code>/clear</code> between customers and tasks — every time.
</div>
</div>

---

## Module 5 — Your Challenge

Pick one and do it now. Mix of serious and just-for-fun:

<div class="category-grid">
<div class="category-card">
<span class="category-icon">💼</span>
<h3>Prep for a real meeting</h3>
<p>Pick an upcoming customer call. Ask Claude:</p>

```text
I have a call tomorrow with a manufacturing company
asking about OpenShift Virtualization. They're worried
about migration risk. Give me the 5 hardest objections
and how to handle each — be specific, not generic.
```

</div>

<div class="category-card">
<span class="category-icon">🔥</span>
<h3>Roast your own README</h3>
<p>Point Claude at a README or doc you wrote:</p>

```text
Read @README.md and roast it. Be brutal — tell me
everything that would make a new contributor confused,
bored, or give up. Then rewrite the first paragraph
to actually be good.
```

</div>

<div class="category-card">
<span class="category-icon">🎯</span>
<h3>Explain something 3 ways</h3>
<p>Pick any Red Hat product or concept:</p>

```text
Explain Ansible Automation Platform three ways:
1. To a 10-year-old
2. To a CFO who only cares about cost
3. To a sysadmin who thinks they don't need it

Keep each under 50 words.
```

</div>

<div class="category-card">
<span class="category-icon">😄</span>
<h3>Something fun</h3>
<p>Ask Claude to write the release notes for your team's week — in the style of a dramatic movie trailer, a weather forecast, or a cooking recipe. Then send it in your team Slack.</p>

```text
Write our team's weekly update in the style of a
dramatic movie trailer. Key events this week:
[what actually happened]. Make it ridiculous.
```

</div>
</div>

---

## What You've Learned

- Claude reads your context and improves over time — it's not a one-shot tool
- CLAUDE.md is your persistent memory — global for your identity and style, local for project context
- Good Claude use is iterative: draft → specific feedback → revise
- Context discipline (`/clear` between tasks, `/compact` for long sessions) keeps quality high

**Next:** [Write Your First Skill →]({{ '/workshops/write-your-first-skill.html' | relative_url }}) — turn any repetitive workflow into a one-command skill.

<div class="navigation-footer">
  <a href="{{ '/workshops/index.html' | relative_url }}" class="nav-button">← Workshops</a>
  <a href="{{ '/workshops/write-your-first-skill.html' | relative_url }}" class="nav-button">Write Your First Skill →</a>
</div>
