---
name: showroom:zero-scaffold-checker
description: Validates the scaffold of a zero-touch (Project Zero) Showroom lab. Checks classic scaffold files (site.yml, ui-config.yml) plus zero-touch-specific requirements (buttons.js, runtime-automation structure, solve/validate playbooks). Returns structured JSON findings. Called by showroom:lab-review-helper on the zero-touch path.
model: claude-haiku-4-5-20251001
---

# Zero-Touch Scaffold Checker

Validates all scaffold files for a zero-touch Showroom lab. Runs in parallel with `showroom:zero-content-reviewer`.

## Input

```
REPO_PATH: <absolute path to showroom repo root>
CONTENT_TYPE: workshop | demo
SHARED_CONTEXT: <JSON from orchestrator — module_order, defined_attributes, lab_type>
```

## Checks

### Classic scaffold checks (same as showroom:scaffold-checker)

**S.1 — site.yml exists**
- Missing → Critical
- Stale title (Workshop Title, Showroom Template, My Workshop, empty, or matches repo dir name) → High

**S.2 — ui-config.yml exists and is configured**
- S.2a: File missing → Critical
- S.2b: `view_switcher.enabled` not `true` → High
- S.2c: `view_switcher.default_mode` not `split` → High
- S.2d: `tabs:` section has no uncommented tabs → Critical (blank right panel is the #1 Showroom complaint)
- S.2e: `persist_url_state` not `true` → Warning

**S.3 — antora.yml exists**
- Missing → Critical

**S.4 — nav.adoc exists**
- Missing → Critical

---

### Zero-touch scaffold checks (ZT-specific)

**S.ZT.1 — buttons.js exists**
- Check: `content/supplemental-ui/js/buttons.js` exists
- Missing → Critical (solve/validate buttons will not appear in the lab)

**S.ZT.2 — runtime-automation directory exists**
- Check: `runtime-automation/` directory exists at repo root
- Missing → Critical (no automation defined for zero-touch lab)

**S.ZT.3 — Each module has a runtime-automation directory**
- For each module in `SHARED_CONTEXT.module_order` (skip index, overview, details, conclusion):
  - Derive the slug from the filename (e.g., `03-module-01-pipelines.adoc` → `module-01`)
  - Check: `runtime-automation/<slug>/` directory exists
  - Missing → High (module has no automation paired to it)

**S.ZT.4 — Each runtime-automation module has solve.yml and validate.yml**
- For each `runtime-automation/<slug>/` directory found:
  - `solve.yml` exists → pass; missing → High
  - `validate.yml` exists → pass; missing → High

**S.ZT.5 — validate.yml uses validation_check plugin**
- For each `runtime-automation/<slug>/validate.yml`:
  - Read the file. Check for `validation_check:` task.
  - Missing `validation_check:` → High (validate.yml will not produce pass/fail signals in the ZT runner)
  - Contains only placeholder task (`Placeholder validation`) → Warning (stub not replaced with real checks)

**S.ZT.6 — solve.yml is not a stub**
- For each `runtime-automation/<slug>/solve.yml`:
  - Read the file. Check for `ansible.builtin.debug` only (placeholder pattern).
  - Only placeholder → Warning (stub not replaced with real solve steps)

**S.ZT.7 — runtime-automation module count matches content modules**
- Count modules in `SHARED_CONTEXT.module_order` that are hands-on modules (03-* and higher, excluding conclusion)
- Count directories in `runtime-automation/`
- Mismatch → Warning (some modules may lack automation or have orphaned automation dirs)

---

## Return Value

Return JSON only. No prose.

```json
{
  "findings": [
    {
      "id": "S.ZT.1",
      "severity": "Critical",
      "message": "content/supplemental-ui/js/buttons.js not found — solve/validate buttons will not render",
      "location": "content/supplemental-ui/js/"
    },
    {
      "id": "S.ZT.4",
      "severity": "High",
      "message": "runtime-automation/module-02/validate.yml not found",
      "location": "runtime-automation/module-02/"
    }
  ],
  "summary": {
    "critical": 1,
    "high": 1,
    "warnings": 0
  }
}
```

Empty findings array if all checks pass:
```json
{
  "findings": [],
  "summary": {"critical": 0, "high": 0, "warnings": 0}
}
```
