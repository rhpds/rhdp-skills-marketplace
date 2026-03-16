---
layout: default
title: Build a Skill — Sales & Pre-Sales
---

# Build a Skill as a Sales Engineer

<div class="reference-badge">Role guide — Sales &amp; Pre-Sales</div>

<div class="callout callout-info">
<span class="callout-icon">💼</span>
<div class="callout-body">
<strong>Who this is for:</strong> Red Hat sales engineers, account managers, and pre-sales specialists who repeat the same prep work before every customer demo — and want to stop doing it manually.
</div>
</div>

---

## The Problem

Before every OpenShift demo, you probably do some version of this:

1. Look up the customer's industry and current infrastructure
2. Pick the right catalog item from RHDP (or guess)
3. Write a briefing doc or slide bullets
4. Draft a "here's what you'll see today" intro for the customer
5. Prepare follow-up talking points

That's 30–60 minutes of prep for every demo. A skill automates it down to a single command.

---

## What You're Building

A skill called `/sales:demo-brief` that takes a few inputs and generates:

- A 1-page **customer briefing doc** (customer name, pain points, recommended demo path)
- A **recommended catalog item** from RHDP with rationale
- An **intro script** for the opening 2 minutes of the demo
- **Follow-up talking points** tailored to the opportunity

**The end result:**

```text
> /sales:demo-brief
```

Claude asks you 4 questions (customer, industry, opportunity type, deal stage), then generates everything above in under 2 minutes.

---

## Phase 1 — Document Your Current Process

Before writing any skill file, get your mental process into text. Claude is your interviewer.

Open Claude Code and paste this:

```text
I'm a Red Hat sales engineer. I want to automate my pre-demo prep workflow.

Here's what I currently do before each demo:
1. Research the customer's current infrastructure (VMware, bare metal, cloud)
2. Decide which RHDP catalog item to use based on their primary pain point
3. Write a 1-page briefing doc for my account team
4. Prepare a 2-minute intro script for the customer call
5. Draft 3-5 follow-up talking points

Can you interview me about each step so we can capture every decision,
default, and edge case? Start with the research step.
```

Let Claude interview you. It will surface things you do automatically:
- "What if the customer is already using Kubernetes?"
- "Do you approach financial services differently than manufacturing?"
- "What's the minimum info you need to pick a catalog item?"

Ask Claude to write up each section as a `.md` file as you go:

```text
Good. Now write that up as docs/sales-workflow/01-customer-research.md
```

<div class="callout callout-tip">
<span class="callout-icon">✅</span>
<div class="callout-body">
<strong>Already have documentation?</strong> Point Claude at it instead: <code>"Read the sales playbook at docs/sales-playbook.md and restructure it as step-by-step reference files."</code>
</div>
</div>

---

## Phase 2 — Convert Your Docs into a SKILL.md

Once you have reference files, point Claude at an existing RHDP skill to use as a pattern, then generate yours:

```text
Read the existing skill at showroom/skills/create-lab/SKILL.md — understand
the format and structure.

Now read my reference files:
- docs/sales-workflow/01-customer-research.md
- docs/sales-workflow/02-catalog-selection.md
- docs/sales-workflow/03-briefing-doc.md
- docs/sales-workflow/04-intro-script.md
- docs/sales-workflow/05-followup.md

Generate a SKILL.md for a skill called /sales:demo-brief that:
1. Asks the user 4 key questions (customer name, industry, opportunity type, deal stage)
2. Generates a customer briefing doc using my 01-customer-research format
3. Recommends a RHDP catalog item using my 02-catalog-selection logic
4. Generates an intro script using my 04-intro-script format
5. Generates follow-up talking points using my 05-followup format

Follow the same frontmatter structure as create-lab/SKILL.md.
```

---

## Phase 3 — The SKILL.md (Example)

Here is what a complete sales skill looks like. Use this as your starting template and replace the content with your actual workflow.

```markdown
---
name: sales:demo-brief
description: Generate pre-demo preparation materials for a Red Hat customer
  demo. Invoke when a user needs a customer briefing, catalog recommendation,
  demo intro script, or follow-up talking points before a customer call.
context: main
model: claude-opus-4-6
---

# Sales Demo Brief

## Purpose
Generate complete pre-demo prep materials in a single workflow.
Ask questions sequentially — one at a time, wait for each answer.

## Step 1 — Gather Context

Ask these questions one at a time:

1. "What is the customer name and industry? (e.g., Acme Corp — Financial Services)"
2. "What is their primary pain point? (e.g., VMware cost, app modernisation, edge computing)"
3. "What type of opportunity is this? (New logo / Expand / Renew)"
4. "What stage is the deal? (Discovery / Demo / Proof of Concept / Close)"

## Step 2 — Select the Right Catalog Item

Based on the primary pain point, recommend one of these catalog items:

| Pain Point | Recommended Catalog Item |
|---|---|
| VMware migration / cost | OCP Virtualization — VM Migration from VMware |
| App modernisation | OpenShift Dev Spaces |
| AI/ML workloads | OpenShift AI (RHOAI) |
| Edge computing | MicroShift / Single Node OpenShift |
| Ansible automation | AAP Self-Service Intro |
| Hybrid cloud management | RHACM Multi-Cluster |

Provide a 2-sentence rationale for the recommendation.

## Step 3 — Generate Customer Briefing Doc

Use this format:

---
**Customer:** [name] | **Industry:** [industry] | **Date:** [today's date]

**Opportunity:** [opportunity type] — [deal stage]

**Primary Pain Point:** [in customer's words, not Red Hat's]

**Recommended Demo:** [catalog item name]

**Why This Demo:** [2 sentences connecting their pain to what they'll see]

**Key Metrics to Mention:**
- [relevant Red Hat proof point for their industry]
- [relevant customer story if applicable]

**What NOT to Demo:** [anything out of scope or likely to confuse]
---

## Step 4 — Write the Intro Script

Write a 2-minute verbal intro (approx. 200 words) that:
- Opens by reflecting their pain point back to them
- States what they will see and do today
- Sets the expectation that they'll have hands-on access (if sandbox)
- Does NOT open with "So let me tell you about Red Hat..."

## Step 5 — Draft Follow-up Talking Points

Write 4–5 bullet points for after the demo:
- Each addresses a likely objection or question
- Each connects to a Red Hat proof point or reference customer
- Keep each under 30 words
```

---

## Phase 4 — Package It as a Plugin

Create the directory structure:

```bash
mkdir -p my-sales-skills/.claude-plugin
mkdir -p my-sales-skills/skills/demo-brief
```

Create `my-sales-skills/.claude-plugin/plugin.json`:

```json
{
  "name": "sales",
  "version": "1.0.0",
  "description": "Red Hat sales engineering skills for pre-demo preparation",
  "author": {
    "name": "Your Name",
    "email": "you@redhat.com"
  }
}
```

Save your `SKILL.md` as `my-sales-skills/skills/demo-brief/SKILL.md`.

---

## Phase 5 — Test Locally

```bash
# Load your plugin without installing it
claude --plugin-dir ~/my-sales-skills

# In Claude Code, test it:
> /sales:demo-brief
```

Verify that:
- Claude asks questions one at a time (not all at once)
- The briefing doc uses your format
- The catalog recommendation matches your selection logic
- The intro script doesn't start with "Let me tell you about Red Hat..."

Fix any issues by editing `SKILL.md` and reloading:

```text
> /reload-plugins
```

---

## What's Next

<div class="callout callout-tip">
<span class="callout-icon">🚀</span>
<div class="callout-body">
<strong>Share it with your team.</strong> Push your plugin to a GitHub repo and share the install command — your whole sales team can install it in one command: <code>claude --plugin-dir github:yourhandle/my-sales-skills</code>
</div>
</div>

More skills you can add to the same `sales` namespace:

- `/sales:objection-prep` — Generate likely objections and responses for a given customer profile
- `/sales:sow-draft` — Draft a Statement of Work outline based on deal type
- `/sales:competitive-brief` — Pull together a competitive comparison for a specific deal

---

<div class="links-grid">
  <a href="{{ '/reference/skills-vs-agents.html' | relative_url }}" class="link-card">
    <h4>Skills vs Agents</h4>
    <p>Understand when to use each</p>
  </a>
  <a href="{{ '/contributing/plugin-dev-plugin.html' | relative_url }}" class="link-card">
    <h4>Plugin Dev Toolkit</h4>
    <p>Anthropic's guided skill builder</p>
  </a>
  <a href="{{ '/contributing/create-your-own-skill.html' | relative_url }}" class="link-card">
    <h4>Full Skill Guide</h4>
    <p>5-phase skill building workshop</p>
  </a>
</div>

<div class="navigation-footer">
  <a href="{{ '/reference/skills-vs-agents.html' | relative_url }}" class="nav-button">← Skills vs Agents</a>
  <a href="{{ '/contributing/for-developers.html' | relative_url }}" class="nav-button">Frontend Agent Guide →</a>
</div>
