---
layout: default
title: Use an Agent — Frontend Developers
---

# Using Agents as a Frontend Developer

<div class="reference-badge">Role guide — Frontend Developers</div>

<div class="callout callout-info">
<span class="callout-icon">🖥️</span>
<div class="callout-body">
<strong>Who this is for:</strong> Frontend developers building Red Hat web applications who want automated, context-aware code review without interrupting their flow — every time they save a component.
</div>
</div>

---

## Why an Agent, Not a Skill

When you edit a React component, you don't want to:
- Type `/review` manually after every change
- Wait through an interactive Q&A session
- Have the review output flood your main conversation

You want: **silent, automatic, specialist review** that only interrupts you when there's an actual problem.

That's exactly what an agent with a hook does.

```
You save DashboardCard.tsx
        │
        ↓
Hook fires automatically (PostToolUse on Edit)
        │
        ↓
frontend-reviewer Agent runs in isolation
        │
        ↓  (only if issues found)
Returns to your session: "3 issues — accessibility, responsive layout, PatternFly version"
```

---

## What You're Building

**1. A `frontend-reviewer` agent** that checks for:
- WCAG 2.1 AA accessibility violations
- PatternFly 5 component usage (not deprecated PF4 patterns)
- Responsive layout issues (missing breakpoints, fixed pixel widths)
- Red Hat brand compliance in copy and colour usage
- Missing `aria-label`, `role`, or keyboard navigation attributes

**2. A hook** that fires the agent automatically after every file edit on `.tsx`, `.css`, or `.html` files.

---

## Step 1 — Create the Agent File

Create `.claude/agents/frontend-reviewer.md` in your project:

```markdown
# Frontend Reviewer Agent

## Role
You are a senior frontend engineer specialising in Red Hat web applications.
You review React components and CSS for accessibility, PatternFly compliance,
and Red Hat brand standards. You are thorough but concise — report only
issues that genuinely matter, not style preferences.

## Review Checklist

### Accessibility (WCAG 2.1 AA)
- All interactive elements have accessible names (`aria-label`, `aria-labelledby`, or visible text)
- Keyboard navigation works: all actions reachable without a mouse
- Focus is visible and styled (not just browser default outline)
- Images have meaningful `alt` text (or `alt=""` if decorative)
- Form inputs have associated `<label>` elements
- Colour contrast meets 4.5:1 for normal text, 3:1 for large text
- No content relies on colour alone to convey meaning

### PatternFly Compliance
- Uses PatternFly 5 components (`@patternfly/react-core` v5+), not PF4
- No custom-styled `<button>` elements when `<Button>` component exists
- Uses `<Card>`, `<PageSection>`, `<Stack>`, `<Flex>` layout components
- No inline styles overriding PatternFly tokens
- Uses PatternFly CSS variables (`--pf-v5-global--*`) not hardcoded hex values

### Red Hat Brand
- Red Hat brand red (#EE0000) used only for primary actions and alerts
- No use of off-brand fonts (only Red Hat Display and Red Hat Text)
- Copy uses active voice and avoids corporate jargon ("leverage", "utilise")
- Product names spelled correctly: "OpenShift" not "Open Shift", "RHEL" not "Red Hat Linux"

### Responsive Layout
- No fixed pixel widths that break on mobile (<768px)
- Uses PatternFly grid or flex, not custom CSS grid with magic numbers
- Images use responsive sizing (`max-width: 100%` or PatternFly `<img>`)
- Touch targets are at least 44x44px

## Output Format

If no issues: respond with a single line: "✅ No issues found."

If issues exist, respond with:

```
## Review: [filename]

**[Issue type]** — [severity: Critical / Warning / Info]
- Problem: [what is wrong and why it matters]
- Location: [component name, line range if visible]
- Fix: [specific change to make]

[Repeat for each issue]

**Summary:** [N] issues — [N Critical, N Warning, N Info]
```

Do not comment on code style, formatting preferences, or anything not
on the checklist above. Only report issues you are confident about.

## Constraints
- Read only — do not modify any files
- Do not use WebFetch or web search
- If you cannot determine whether something is an issue, skip it
```

---

## Step 2 — Add the Hook

Add this to `.claude/settings.json` in your project (create it if it doesn't exist):

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'file=\"$TOOL_INPUT_FILE_PATH\"; ext=\"${file##*.}\"; if [[ \"$ext\" == \"tsx\" || \"$ext\" == \"jsx\" || \"$ext\" == \"css\" || \"$ext\" == \"html\" ]]; then echo \"{\\\"decision\\\": \\\"invoke_agent\\\", \\\"agent\\\": \\\"frontend-reviewer\\\", \\\"message\\\": \\\"Review the file at $file for accessibility, PatternFly compliance, and Red Hat brand standards.\\\"}\" ; fi'"
          }
        ]
      }
    ]
  }
}
```

<div class="callout callout-warning">
<span class="callout-icon">⚠️</span>
<div class="callout-body">
<strong>Scope it to your component directories.</strong> If you only want review on files under <code>src/components/</code>, add a path filter: change the bash condition to also check <code>[[ "$file" == *"/components/"* ]]</code>.
</div>
</div>

---

## Step 3 — Test It

Edit any `.tsx` file and save. Claude will automatically dispatch the `frontend-reviewer` agent. You'll see:

```text
[Agent: frontend-reviewer] Reviewing src/components/DashboardCard.tsx...

## Review: DashboardCard.tsx

**Accessibility** — Critical
- Problem: The close button has no accessible name. Screen readers will
  announce "button" with no context.
- Location: <Button> on line 47
- Fix: Add aria-label="Close dashboard card" to the Button component.

**PatternFly Compliance** — Warning
- Problem: Uses hardcoded colour #CC0000 instead of PatternFly token.
- Location: className="error-state" in DashboardCard.css, line 12
- Fix: Replace with var(--pf-v5-global--danger-color--100)

**Summary:** 2 issues — 1 Critical, 1 Warning
```

If the file is clean:

```text
[Agent: frontend-reviewer] ✅ No issues found.
```

---

## Step 4 — Tune the Agent

After running for a week, you'll want to adjust the checklist. Common tuning:

**Too noisy?** Add to the Constraints section:

```markdown
## Constraints (additions)
- Do not report PatternFly version issues in files under src/legacy/
- Do not report colour contrast issues for placeholder/skeleton states
```

**Missing something?** Add to the checklist:

```markdown
### i18n (if your app supports multiple languages)
- All user-visible strings use i18n keys, not hardcoded English text
- Strings with variables use proper interpolation, not string concatenation
```

**Want it to auto-fix?** Remove the `Read only — do not modify any files` constraint and add fix instructions to the output format section.

---

## Invoke It Manually Too

The agent is also available on demand:

```text
> Use the frontend-reviewer agent to review all files under src/components/

> Use the frontend-reviewer agent to do a full accessibility audit of the
  navigation components before the accessibility review next Tuesday.
```

---

## Extend It: Add More Specialist Agents

Once you have the pattern down, add more agents in `.claude/agents/`:

| Agent | What it checks |
|---|---|
| `performance-reviewer.md` | Bundle size, unnecessary re-renders, missing `memo`/`useCallback` |
| `test-coverage-reviewer.md` | Missing unit tests, untested edge cases, test quality |
| `api-contract-reviewer.md` | API calls match OpenAPI spec, error states handled |
| `seo-reviewer.md` | Meta tags, semantic HTML, structured data |

Each agent is an independent specialist. You can invoke all of them in a single request:

```text
> Use the frontend-reviewer, performance-reviewer, and test-coverage-reviewer
  agents to fully audit the new checkout flow before we merge.
```

Claude runs all three in parallel and reports back.

---

## Connection to the RHDP Pattern

This is exactly how the Showroom marketplace uses agents internally. `/showroom:create-lab` generates content — then dispatches `workshop-reviewer` and `style-enforcer` agents to independently validate what it just created.

You're applying the same pattern to frontend development.

<div class="links-grid">
  <a href="{{ '/reference/skills-vs-agents.html' | relative_url }}" class="link-card">
    <h4>Skills vs Agents</h4>
    <p>Full conceptual guide</p>
  </a>
  <a href="{{ '/reference/best-practices.html' | relative_url }}" class="link-card">
    <h4>Best Practices</h4>
    <p>Hooks, context, and CLAUDE.md setup</p>
  </a>
  <a href="{{ '/contributing/for-sales.html' | relative_url }}" class="link-card">
    <h4>Sales Skill Walkthrough</h4>
    <p>Building a Skill instead of an Agent</p>
  </a>
  <a href="{{ '/contributing/plugin-dev-plugin.html' | relative_url }}" class="link-card">
    <h4>Plugin Dev Toolkit</h4>
    <p>Guided builder from Anthropic</p>
  </a>
</div>

<div class="navigation-footer">
  <a href="{{ '/contributing/for-sales.html' | relative_url }}" class="nav-button">← Sales Skill Guide</a>
  <a href="{{ '/contributing/plugin-dev-plugin.html' | relative_url }}" class="nav-button">Plugin Dev Toolkit →</a>
</div>
