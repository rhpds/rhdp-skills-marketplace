---
description: Aggregates dimension scores from module-reviewer outputs across an entire lab. Compares against a baseline version to detect regressions. Called by showroom:eval. Returns structured JSON verdict. Self-contained — pure computation on JSON input, no file reads needed.
model: claude-haiku-4-5
tools: []
---

# showroom:score-aggregator

Aggregates dimension scores from multiple module-reviewer JSON outputs and produces a regression report.

**You receive via prompt:**
- `MODULE_RESULTS` — JSON array of module-reviewer outputs (one per module)
- `SKILL_VERSION` — version string of the skill being evaluated (e.g. `"v3.1.0"`)
- `BASELINE` — JSON object of baseline scores from a previous version, or `null` if no baseline

---

## Step 1 — Aggregate scores per dimension

Average the `dimensions.*.score` values across all modules for each dimension:
- `structure`
- `pedagogy`
- `style`
- `technical_accuracy`
- `intro_quality`

Weight intro_quality only from the first module (`01-overview.adoc` or `index.adoc`).

---

## Step 2 — Count findings by severity

Across all module findings:
- Count `Critical`, `High`, `Medium`, `Warning`, `Info`

---

## Step 3 — Compare against baseline

If `BASELINE` is not null:
- For each dimension, compute `delta = current - baseline`
- Flag as regression if `delta < -0.05` (5% drop)
- Flag as improvement if `delta > +0.05`

---

## Step 4 — Determine verdict

- `PASS` — no regressions, no Critical findings
- `WARN` — warnings or minor regressions (delta between -0.05 and -0.10)
- `REGRESSION` — any dimension drops more than 0.10, or Critical findings present
- `BLOCKER` — Critical findings present (blocks release regardless of scores)

---

## Step 5 — Output structured JSON only

```json
{
  "agent": "score-aggregator",
  "skill_version": "<SKILL_VERSION>",
  "lab_type": "<from first module_result.lab_type>",
  "modules_evaluated": 6,
  "finding_counts": {
    "Critical": 0,
    "High": 2,
    "Medium": 4,
    "Warning": 8,
    "Info": 1
  },
  "dimensions": {
    "structure":          {"current": 0.88, "baseline": 0.85, "delta": "+0.03", "status": "improved"},
    "pedagogy":           {"current": 0.72, "baseline": 0.78, "delta": "-0.06", "status": "regression"},
    "style":              {"current": 0.94, "baseline": 0.93, "delta": "+0.01", "status": "stable"},
    "technical_accuracy": {"current": 0.87, "baseline": 0.86, "delta": "+0.01", "status": "stable"},
    "intro_quality":      {"current": 0.91, "baseline": 0.84, "delta": "+0.07", "status": "improved"}
  },
  "verdict": "REGRESSION",
  "blocker": false,
  "summary": "pedagogy dimension regressed by 0.06 on ocp labs — review B.8/B.9 check changes"
}
```

If `BASELINE` is null, omit `baseline` and `delta` from dimension objects and set `status: "no-baseline"`.
