---
layout: default
title: Skills vs Agents
---

# Skills vs Agents

<div class="reference-badge">Concepts — understand before you build</div>

<div class="callout callout-info">
<span class="callout-icon">💡</span>
<div class="callout-body">
<strong>The one-sentence version:</strong> A <strong>Skill</strong> is a reusable workflow Claude follows in your conversation. An <strong>Agent</strong> is an isolated specialist that runs separately and returns a summary.
</div>
</div>

---

## The Mental Model

Think of it in Red Hat terms:

- A **Skill** is like a Standard Operating Procedure (SOP). Claude reads it when relevant and follows the steps — in your current context.
- An **Agent** is like a specialist you hand a ticket to. It goes away, does the work in its own environment, and comes back with results. Your main conversation stays clean.

<div class="vs-grid">
<div class="vs-card vs-card-skill">
<span class="vs-label">Skill</span>
<h3>📋 Standard Operating Procedure</h3>
<ul>
<li>Runs inside your current conversation</li>
<li>Invoked via <code>/namespace:name</code> command</li>
<li>Can ask you questions, generate files</li>
<li>Shares your context window</li>
<li>Best for interactive, guided workflows</li>
<li>Defined in a <code>SKILL.md</code> file</li>
</ul>
</div>

<div class="vs-card vs-card-agent">
<span class="vs-label">Agent</span>
<h3>🤖 Specialist on a Ticket</h3>
<ul>
<li>Gets its <strong>own isolated context window</strong></li>
<li>Does not see your conversation history</li>
<li>Returns only a summary to your session</li>
<li>Can run in parallel with other agents</li>
<li>Best for review, analysis, parallel work</li>
<li>Defined in an <code>.md</code> file under <code>agents/</code></li>
</ul>
</div>
</div>

---

## Full Comparison

<table>
<thead>
<tr><th></th><th>Skill</th><th>Agent</th></tr>
</thead>
<tbody>
<tr><td><strong>What it is</strong></td><td>Workflow instructions Claude follows</td><td>Isolated worker with its own context</td></tr>
<tr><td><strong>Context</strong></td><td>Shares your main conversation window</td><td>Gets a fresh, isolated context window</td></tr>
<tr><td><strong>Invocation</strong></td><td><code>/namespace:skill-name</code> or auto-loaded</td><td>Delegated by skill or by you directly</td></tr>
<tr><td><strong>Sees conversation history</strong></td><td>Yes</td><td>No — only what you pass it</td></tr>
<tr><td><strong>Returns</strong></td><td>Works directly in your session</td><td>A summary back to your main session</td></tr>
<tr><td><strong>Can modify files</strong></td><td>Yes (in your session)</td><td>Yes (in its own workspace)</td></tr>
<tr><td><strong>Spawns other agents</strong></td><td>No</td><td>No (prevents infinite nesting)</td></tr>
<tr><td><strong>File definition</strong></td><td><code>SKILL.md</code> in <code>skills/&lt;name&gt;/</code></td><td><code>.md</code> file in <code>agents/</code></td></tr>
<tr><td><strong>Best for</strong></td><td>Interactive step-by-step workflows</td><td>Review, validation, parallel tasks</td></tr>
</tbody>
</table>

---

## Red Hat Role Examples

Different people at Red Hat use skills and agents differently. Here's the breakdown by role.

### Sales Engineer

**Goal:** Automate pre-demo prep — research the customer, draft a briefing, find the right catalog item.

**Use a Skill** (`/sales:demo-brief`):

```text
> /sales:demo-brief
Customer: Acme Corp
Opportunity: OpenShift Virtualization migration, 500 VMs
Rep: Jane Smith
```

The skill asks follow-up questions and generates the briefing doc in your session. Interactive, guided — exactly what a skill is for.

**Not an Agent** — you want back-and-forth conversation, not a silently dispatched task.

---

### Frontend Developer

**Goal:** Automatically review every React component for accessibility, PatternFly compliance, and responsiveness.

**Use an Agent** (`frontend-reviewer`):

```text
> Use the frontend-reviewer agent to review src/components/DashboardCard.tsx
```

The agent gets the file, checks it independently — your main conversation doesn't fill up with hundreds of lint lines. It returns: "3 issues found" with specifics.

**With a hook**, this fires automatically on every `.tsx` edit without you asking.

**Not a Skill** — you don't want to sit through an interactive Q&A for each file. You want a silent specialist that pings you only when there's a real problem.

---

### Solutions Architect

**Goal:** Validate that a demo environment is healthy after deployment.

**Use an Agent** (`health-validator`):

```text
> Use the health-validator agent to check the AAP deployment
```

The agent connects, runs checks, returns a pass/fail summary. Your main conversation stays focused on the customer conversation.

**Use a Skill** for the interactive part — `/health:deployment-validator` to *create* the validation role step by step, then the agent to *run* it.

---

### RHDP Engineer

**Goal:** Build a new workshop catalog item and have it independently reviewed.

**Use both together:**

1. `/showroom:create-lab` (Skill) — guides you through generating the AsciiDoc modules
2. `workshop-reviewer` (Agent) — independently reviews the output for quality issues
3. `style-enforcer` (Agent) — checks Red Hat naming conventions and inclusive language

The skill does the creation work in your session. The agents review independently, with fresh eyes, and return specific feedback.

---

## Decision Flowchart

```
Is it interactive? Do you need to answer questions?
├── YES → Skill
│         Do you want it invoked automatically or manually?
│         ├── Manually (you type /name) → Skill (default)
│         └── Automatically when relevant → Skill with model-invocable: true
│
└── NO → Is the task self-contained (review, analysis, validation)?
          ├── YES → Agent
          │         Does output need to stay out of your main context?
          │         ├── YES → Agent (isolated context window)
          │         └── NO → Skill with context: fork
          │
          └── NO → CLAUDE.md rule or Hook
```

---

## Using Skills and Agents Together

The real power comes from combining them. In the RHDP marketplace, every major workflow follows this pattern:

```
User invokes Skill (/showroom:create-lab)
     │
     ├── Skill generates AsciiDoc modules (in your session)
     │
     ├── Skill invokes workshop-reviewer Agent
     │       └── Agent checks learning objectives, exercise quality
     │       └── Returns: specific BEFORE/AFTER feedback
     │
     └── Skill invokes style-enforcer Agent
             └── Agent checks RH naming, inclusive language
             └── Returns: specific violations with file locations
```

The skill orchestrates. The agents specialise. Your main context only sees the final results.

---

## When to Use Agents Inside a Skill

Once you start building skills, you'll face a choice: should the skill do checks itself (inline), or delegate to an agent?

This is one of the most common design mistakes — using agents when inline is faster and simpler, or avoiding agents when they'd genuinely help.

### The Core Question

**Is the check the main purpose of the skill, or a secondary gate after heavy work?**

---

### Use Inline When

**Verification is the primary purpose of the skill** — like `/showroom:verify-content`. The skill exists to check things. There's no large pre-existing context. Running checks directly in the skill's own context is faster and produces consistent output.

```
/showroom:verify-content
  ↓
Reads prompt files
  ↓
Runs all checks inline (one context)
  ↓
Returns single findings table
```

**Also use inline when:**
- The check is short and focused (10 specific rules, not open-ended review)
- Speed matters — agents add sequential spin-up overhead
- You want deterministic, structured output (table rows, not narrative)
- The skill already has the content in context from prior steps

---

### Use Agents When

**The check is secondary — it runs after heavy generation work.** For example, `/showroom:create-lab` spends 9 steps generating content. At step 10, the context is large and the skill is almost done. An agent gets a fresh context and can review without bias from all the generation choices that came before.

```
/showroom:create-lab
  ↓
Steps 1–9: Heavy generation (large context builds up)
  ↓
Step 10: Ask workshop-reviewer agent to check
         → Fresh context, unbiased view
         → Returns specific feedback
  ↓
Apply fixes, deliver
```

**Also use agents when:**
- You want true specialisation — an agent focused entirely on one domain (style, structure, technical)
- The agent's knowledge is maintained separately and may be updated without touching the skill
- You need parallel independent checks (though Claude Code runs agents sequentially by default)

---

### The Speed Trade-off

Agents are **never faster** than inline. Each agent call is a separate context spin-up. If a skill invokes three agents in sequence, that's three round-trips instead of one.

The reason to use agents is **quality and maintainability**, not speed:
- Update `style-enforcer.md` once when the Red Hat style guide changes — every skill that uses it gets the update automatically
- The agent has no memory of what the skill just generated — it sees the output with fresh eyes

---

### Decision Table

<table>
<thead>
<tr><th>Situation</th><th>Use</th><th>Why</th></tr>
</thead>
<tbody>
<tr><td>Skill's main job is checking/validating</td><td><strong>Inline</strong></td><td>Faster, one context, structured output</td></tr>
<tr><td>Quick quality gate at end of generation</td><td><strong>Inline</strong></td><td>Content already in context, specific checklist</td></tr>
<tr><td>Post-generation review needing fresh eyes</td><td><strong>Agent</strong></td><td>Unbiased context, specialised knowledge</td></tr>
<tr><td>Specialist domain maintained separately</td><td><strong>Agent</strong></td><td>Update agent once, all skills benefit</td></tr>
<tr><td>Open-ended qualitative feedback</td><td><strong>Agent</strong></td><td>Agents are better at narrative, exploratory review</td></tr>
<tr><td>Structured table output needed</td><td><strong>Inline</strong></td><td>Easier to control output format precisely</td></tr>
</tbody>
</table>

### Real RHDP Examples

| Skill | Approach | Reason |
|---|---|---|
| `/showroom:verify-content` | Inline | Verification IS the skill. Reads prompts, runs all checks in one pass. |
| `/showroom:create-lab` Step 10 | Inline | Focused 10-item checklist on just-generated module. Fast, specific. |

---

## File Structure Reference

**Defining a Skill** (`showroom/skills/create-lab/SKILL.md`):

```markdown
---
name: showroom:create-lab
description: Create a Showroom workshop lab module. Invoke when the user
  wants to build hands-on workshop content for Red Hat Showroom.
context: main
model: claude-opus-4-6
---

# Create Lab Skill

[Step-by-step workflow instructions...]
```

**Defining an Agent** (`showroom/agents/workshop-reviewer.md`):

```markdown
# Workshop Reviewer Agent

## Role
You are a senior instructional designer specialising in Red Hat
technical workshops. You review content for learning effectiveness.

## Instructions
Review the provided modules for:
- Clear learning objectives (Know/Do/Check structure)
- Actionable lab exercises with verification steps
- Appropriate technical depth for the target audience

## Feedback Requirements
For each issue, provide:
- WHY it is a problem
- BEFORE: the current text
- AFTER: the improved version
- WHICH FILE and line to change
```

---

## Further Reading

<div class="links-grid">
  <a href="{{ '/contributing/for-sales.html' | relative_url }}" class="link-card">
    <h4>Sales Skill Walkthrough</h4>
    <p>Build a demo-prep skill from scratch</p>
  </a>
  <a href="{{ '/contributing/for-developers.html' | relative_url }}" class="link-card">
    <h4>Frontend Agent Guide</h4>
    <p>Build a code-review agent with hooks</p>
  </a>
  <a href="{{ '/contributing/create-your-own-skill.html' | relative_url }}" class="link-card">
    <h4>Create Your Own Skill</h4>
    <p>5-phase skill-building workshop</p>
  </a>
  <a href="{{ '/contributing/plugin-dev-plugin.html' | relative_url }}" class="link-card">
    <h4>Plugin Dev Toolkit</h4>
    <p>Anthropic's official builder toolkit</p>
  </a>
</div>

<div class="navigation-footer">
  <a href="{{ '/reference/best-practices.html' | relative_url }}" class="nav-button">← Best Practices</a>
  <a href="{{ '/contributing/create-your-own-skill.html' | relative_url }}" class="nav-button">Create a Skill →</a>
</div>
