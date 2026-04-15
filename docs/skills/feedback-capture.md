---
layout: default
title: /aiops-skill:feedback-capture
---

# /aiops-skill:feedback-capture

<div class="reference-badge">💬 Feedback Capture</div>

Ask the user for feedback at the end of a skill invocation, categorize it, and store it as a structured record in `~/feedback.txt` with session tracking.

---

## When to Use

<div class="callout callout-tip">
<span class="callout-icon">💡</span>
<div class="callout-body">
<strong>This skill is typically called automatically</strong> by other skills (such as context-fetcher) at the end of an investigation. You can also invoke it directly:
<ul>
<li>After completing a root cause analysis session</li>
<li>When you want to record a note about the quality or accuracy of an investigation</li>
<li>To log a bug report or suggestion about skill behavior</li>
</ul>
</div>
</div>

**Example invocations:**

```
"Capture feedback for this session"
"Record my feedback"
"I want to leave feedback about this analysis"
```

---

## Prerequisites

No external services or environment variables are required. Feedback is written to the local filesystem at `~/feedback.txt`. The skill requires `scripts/formatting.py` to be present in the skill directory.

---

## 4-Step Workflow

<ol class="steps">
<li>
<div class="step-content">
<h4>Ask for Feedback <code>[Claude]</code></h4>
<p>Claude asks the user if they would like to provide feedback. The prompt is kept open-ended — any comment the user provides is treated as feedback.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>Select Category <code>[Claude]</code></h4>
<p>Claude reads the user's comment and selects the most appropriate feedback category from the standard list. Categories are not presented as options to the user — Claude infers the best fit.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>Summarize Context <code>[Claude]</code></h4>
<p>Claude creates two summaries: the user's feedback condensed into <code>users-feedback</code>, and a brief description of what happened during the session as <code>context</code>.</p>
</div>
</li>
<li>
<div class="step-content">
<h4>Store Feedback <code>[Python]</code></h4>
<p>Runs <code>scripts/formatting.py</code> with the categorized, structured feedback. The script appends a timestamped record to <code>~/feedback.txt</code>.</p>

```bash
python scripts/formatting.py \
  --category {Category} \
  --skill {Skill} \
  --feedback {users-feedback} \
  --context {summary-of-what-happened}
```

</div>
</li>
</ol>

---

## Feedback Categories

Claude selects one category per feedback entry based on the nature of the comment:

| Category | Use When |
|---|---|
| `Complexity` | The skill was too complex or had too many steps |
| `Clarity` | Output was unclear, confusing, or hard to interpret |
| `Accuracy` | Root cause or findings were incorrect or incomplete |
| `Performance` | The skill was slow or timed out |
| `Search Quality` | Search results were irrelevant or missed key content |
| `Interpretation` | Claude misunderstood the intent or scope |
| `Positive` | The investigation was helpful and worked well |

For feedback that fits a more specific label (e.g., "It keeps repeating the same solution"), Claude creates a short 1–2 word custom label (e.g., `Repetition`) instead.

---

## Storage Format

Feedback is appended to `~/feedback.txt`. Each record includes:

- **Timestamp** — When the feedback was captured
- **Session ID** — Links the feedback to the Claude Code session
- **Skill** — Which skill was being evaluated
- **Category** — The selected or inferred category
- **Feedback** — The user's comment, summarized
- **Context** — Brief description of what the skill did during the session

---

## Usage Guidelines

<div class="callout callout-info">
<span class="callout-icon">ℹ️</span>
<div class="callout-body">
<ul>
<li>Claude never presents the category list as options — it infers the category from context</li>
<li>Whatever the user says is treated as feedback; no follow-up questions are asked</li>
<li>The skill should only be invoked once per session — do not ask repeatedly</li>
<li>Feedback is local only; it is not automatically uploaded unless the parent skill (e.g., root-cause-analysis) runs an upload step</li>
</ul>
</div>
</div>

---

<div class="navigation-footer">
  <a href="{{ '/index.html' | relative_url }}" class="nav-button">← Back to Skills</a>
  <a href="{{ '/skills/context-fetcher.html' | relative_url }}" class="nav-button">← Context Fetcher</a>
</div>
