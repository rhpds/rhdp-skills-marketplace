---
layout: default
title: Personal Writing Style
---

# Personal Writing Style

All showroom content creation skills (`create-lab`, `create-demo`, `blog-generate`) support optional personal writing style profiles. When provided, the `file-generator` agent shapes all generated prose to match your style — sentence structure, vocabulary, tone — while still following Red Hat content standards.

---

## How to Provide Your Style

### Option A — Describe it

In the planning form, describe your style in a sentence or two:

```
Writing style: "Conversational and direct. Short sentences. Active voice always.
No jargon. Analogies for complex concepts. Developer-to-developer tone."
```

### Option B — Paste example paragraphs

Paste 1–3 paragraphs from your own writing:

```
Writing style example:
---
OpenShift Pipelines takes the complexity out of CI/CD. Instead of wrestling
with Jenkins configurations, you define pipelines as Kubernetes resources.
They live alongside your code, version-controlled, predictable.

In this module, you'll build a real pipeline — one that watches your repo,
runs tests automatically, and deploys to staging when they pass.
---
```

The skill extracts your patterns: sentence rhythm, how you introduce concepts, vocabulary level, use of analogies.

### Option C — Point to an existing module

Reference a file you've already written:

```
Writing style: ~/work/code/my-showroom/content/modules/ROOT/pages/03-module-01.adoc
```

### Option D — Save a persistent profile

Create `~/.claude/context/my-writing-style.md` once and reference it in every session:

**`~/.claude/context/my-writing-style.md`:**

```markdown
# My Writing Style

## Tone
Conversational, mentor-like. Writing for smart people who are new to this specific technology.
Never condescending. Never over-explaining. Trust the reader.

## Sentences
Short. Active voice. If a sentence needs a comma to finish the thought, split it.

## Technical depth
Show the command, explain why it works — not just what it does.
"Run `oc apply -f pipeline.yaml` — this creates the Tekton Pipeline resource
in your cluster's current namespace."

## Introductions
Bottom-up. Start with what the learner will build, not why the technology exists.
The motivation comes after they've seen the outcome.

## Things I avoid
- "Delve into" / "leverage" / "robust" / "powerful"
- Passive voice
- Numbered lists for concepts (bullets only — numbers imply sequence)
- Three-part thesis introductions

## Example paragraph (use this as style reference)
OpenShift Pipelines solves a specific problem: your CI/CD pipeline shouldn't
live in a different system from your application. When the pipeline is a
Kubernetes resource, it gets the same version control, RBAC, and multi-tenancy
as everything else. That's the idea. Let's build one.
```

**Reference it in any skill:**
```
Writing style: Use my saved profile at ~/.claude/context/my-writing-style.md
```

---

## What Gets Personalized

| Element | Personalized | Fixed (Red Hat standards) |
|---|---|---|
| Sentence length and rhythm | ✅ | — |
| Vocabulary and jargon level | ✅ | Red Hat product names always correct |
| How concepts are introduced | ✅ | — |
| Tone (formal, conversational, mentor) | ✅ | — |
| Use of analogies and examples | ✅ | — |
| AsciiDoc formatting | — | Always follows SKILL-COMMON-RULES |
| Version attribute placeholders | — | Always `{ocp_version}` etc. |
| Learning outcomes structure | — | Always required |
| Verify sections and exercise format | — | Always required |

---

## Auto-Humanizer

All content creation skills automatically run a humanizer pass on generated prose before writing to disk. No action needed.

The humanizer removes common AI writing patterns:

| AI pattern | Human alternative |
|---|---|
| "Delve into" | "explore" / "look at" |
| "Leverage" | "use" |
| "Furthermore" / "Moreover" | natural transition or removed |
| "It's worth noting that" | state the fact directly |
| "In conclusion" | removed or rephrased |
| Passive where active is clearer | rewritten |

**What the humanizer skips:** code blocks, AsciiDoc macros, command examples, expected output, quoted text.

---

## Model Efficiency

The skills use different Claude models per task to minimize token costs:

| Task | Model | Why |
|---|---|---|
| Orchestration, user conversation | **Sonnet 4.6** | Sufficient for routing + UX — hard reasoning is in agents |
| Content generation, semantic review | **Sonnet 4.6** | Quality matters; Opus not needed after agent refactor |
| Config file reading, deterministic checks | **Haiku 4.5** | Fast, cheap — no generation needed |
| Score aggregation, JSON computation | **Haiku 4.5** | Pure computation, no reasoning |

**Cost impact of the agent refactor:**

The previous monolithic skills ran everything in one Sonnet context window. After refactoring:
- Orchestrators (Sonnet) do coordination only — fewer tokens
- Scaffold checks (Haiku) cost ~3× less per check than Sonnet
- Score aggregation (Haiku) is pure computation
- Parallel agents finish faster → shorter wall time → fewer background tokens

The quality actually **improves** because each agent gets a fresh context window with no saturation from previous checks.
