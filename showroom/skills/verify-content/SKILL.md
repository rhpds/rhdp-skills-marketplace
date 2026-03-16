---
name: showroom:verify-content
description: This skill should be used when the user asks to "verify my workshop content", "review my lab module", "check my Showroom content", "validate my AsciiDoc module", "quality check my demo", "review my workshop for Red Hat standards", or "run a content review on my lab".
---

---
context: main
model: claude-opus-4-6
---

# Content Verification Skill

Verify workshop or demo content against Red Hat quality standards, style guidelines, technical accuracy, and scaffold requirements. Runs all checks silently, then presents one consolidated findings table. User picks which issue to fix first.

## Workflow

### Phase 1 — Auto-detect (silent, no questions)

Check CWD for Showroom structure:

- `content/modules/ROOT/pages/` exists and contains `.adoc` files → use it, proceed silently

**If CWD is not a Showroom repo**, output:

```
📁 No Showroom content found in [CWD].

Provide a local path or GitHub URL:
```

Wait for user response:

- **Local path** (e.g. `~/work/showroom-content/my-lab-showroom`) → use it, proceed
- **GitHub URL** (e.g. `https://github.com/rhpds/my-lab-showroom`) → ask:
  ```
  Clone to /tmp/my-lab-showroom? Or enter a different path:
  ```
  User confirms or says nothing → clone to `/tmp/[repo-name]` and proceed.
  User provides a different path → clone there and proceed.

**Never scan directories or list repos from `~/CLAUDE.md` or `~/work/showroom-content/`.** The user knows what they want to verify — just let them say it.

Detect content type from file structure (no questions):
- Has `=== Verify` sections or numbered exercise steps → Workshop
- Has Know/Show structure, presenter notes → Demo
- Cannot determine → default to Workshop

Confirm detection in one line:
```
📋 Verified: Workshop content in content/modules/ROOT/pages/ (6 files). Running all checks...
```

Then run all checks silently.

---

### Phase 2 — Run All Checks (silent)

Run every check below without pausing or outputting intermediate results. Collect all findings. Output nothing until all checks are complete.

Scaffold checks run inline. Content quality checks delegate to three specialist agents — each returns findings as table rows so Phase 3 can merge everything into one table.

#### Scaffold Checks (S)

Check all scaffold files in repo root and `content/`. Collect findings — do NOT block or pause.

**S.1 — Antora playbook** (`site.yml` or `default-site.yml`):

| State | Severity |
|---|---|
| `site.yml` present | — proceed |
| `default-site.yml` only (no `site.yml`) | High — rename to `site.yml`: `mv default-site.yml site.yml` then update `.github/workflows/gh-pages.yml` |
| Both present | High — remove `default-site.yml` |
| Neither present | Critical — no playbook found |

Fields to check in whichever file exists:

| Field | Fail condition | Severity |
|---|---|---|
| `site.title` | Stale/template value (`Workshop Title`, `Lab Title`, `Showroom Template`, `Red Hat Showroom`, `My Workshop`, `Template`, `showroom_template_nookbag`, empty, or matches repo directory name) | High |
| `site.start_page` | Not `modules::index.adoc` | High |
| `ui.bundle.url` | Missing or empty | High |
| `ui.supplemental_files` | Not `./supplemental-ui` | High |
| `runtime.fetch` | Not `true` | Medium |

**S.2 — `ui-config.yml`**:

Detect infra type silently from content:
- Contains `console-openshift-console` or `rhods-dashboard` → OCP
- Contains `/wetty` with `port:` or AAP/Cockpit URLs → VM
- Cannot determine → note as Unknown, continue

| Field | Fail condition | Severity |
|---|---|---|
| File missing | — | Critical |
| `type: showroom` | Missing | High |
| `view_switcher.enabled` | Not `true` | High |
| `view_switcher.default_mode` | Not `split` | Medium |
| `persist_url_state` | Not `true` | Medium |
| tabs section | No uncommented tabs | High |

**S.3 — `content/antora.yml`**:

| Field | Fail condition | Severity |
|---|---|---|
| File missing | — | Critical |
| `title` | Stale/template value | High |
| `name` | Not `modules` | High |
| `start_page` | Not `index.adoc` | High |
| `nav` | Doesn't reference `modules/ROOT/nav.adoc` | High |
| `asciidoc.attributes.lab_name` | Missing or stale | High |

**S.4 — `.github/workflows/gh-pages.yml`**:

| State | Severity |
|---|---|
| File missing | Critical |
| Workflow references wrong playbook filename | Critical |

Also note: GitHub Pages must be enabled in repo Settings → Pages → Source: GitHub Actions.

**S.5 — `content/supplemental-ui/`**:

Missing `css/site-extra.css` or `partials/head-meta.hbs` → High.

---

#### Content Checks — Agent Delegation

After scaffold checks, delegate to the three specialist agents. Each agent reads the content files already located in Phase 1 and returns findings as table rows.

**Instruction to give each agent:**

> Read all `.adoc` files under `[content path]`. For each issue found, return a table row with these exact columns: `ID | Issue | Severity | Location`. Use IDs prefixed with your pass letter (e.g. B.3, C.7). Severity is one of: Critical, High, Medium, Low. Location is `filename:line` where possible. Return only failing items — no PASS rows needed.

---

**Ask the `workshop-reviewer` agent** to check structure and learning design (Pass B) and demo quality if applicable (Pass F):

```
Ask the workshop-reviewer agent:
Review [content path] for workshop structure and learning design quality.
[If demo: also check Know/Show structure, business value framing, and presenter guidance.]
Return findings as table rows: ID | Issue | Severity | Location
Use IDs starting with B (structure) and F (demo-specific, if applicable).
```

---

**Ask the `technical-editor` agent** to check AsciiDoc formatting (Pass C) and technical accuracy (Pass E):

```
Ask the technical-editor agent:
Review [content path] for AsciiDoc formatting and technical accuracy.
Return findings as table rows: ID | Issue | Severity | Location
Use IDs starting with C (formatting) and E (technical accuracy).
```

---

**Ask the `style-enforcer` agent** to check Red Hat style compliance (Pass D):

```
Ask the style-enforcer agent:
Review [content path] for Red Hat style guide compliance.
Return findings as table rows: ID | Issue | Severity | Location
Use IDs starting with D.
```

---

Collect all rows returned by the three agents. Add scaffold findings (S). Proceed to Phase 3.

---

### Phase 3 — Present Findings Table

After all checks complete, output **one table** containing every finding. Nothing else before this table.

Format:

```
## Verification Results

| # | ID | Issue | Severity | Location |
|---|---|---|---|---|
| 1 | S.1 | site.title is a template default — update to your lab name | High | site.yml:3 |
| 2 | B.5 | No hands-on module found (no 03-*.adoc or higher) | Critical | pages/ |
| 3 | C.5 | Code block missing language identifier | High | module-01.adoc:47 |
| 4 | D.2 | "AAP" used without first-use expansion | High | 01-overview.adoc:12 |
| 5 | E.4 | Hardcoded cluster URL found | Critical | module-02.adoc:88 |
...

**Total: X issues — Y Critical, Z High, N Medium, M Low**
```

Sort order: Critical first, then High, Medium, Low. Within each severity, scaffold (S) before content (B–F).

If zero findings:
```
✅ No issues found. Content passes all checks.
```

Then ask:

```
Which issue do you want to fix first? (Enter the number, e.g. "3")
Or say "all critical" to fix all Critical issues, "all high" for all High, or "skip" to finish.
```

---

### Phase 4 — Fix Loop

When the user picks an issue:

1. Show the specific fix:
   - What the current content is (BEFORE)
   - What it should be (AFTER)
   - Why the change is needed (one sentence)
2. Apply the fix
3. Confirm: "Fixed #3. X issues remaining."
4. Re-show the remaining table (with fixed items removed)
5. Ask: "Which one next?"

Repeat until the user says "done", "skip", or there are no issues left.

**Never fix multiple issues at once unless the user explicitly says "all critical" or similar.**

---

## Related Skills

- `/showroom:create-lab` — Create new workshop modules
- `/showroom:create-demo` — Create presenter-led demo content
- `/showroom:blog-generate` — Transform workshop to blog post
