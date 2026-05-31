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

All checks run inline. Before running content checks, read the appropriate prompt files based on detected content type — these are the source of truth for each pass.

**For a workshop, read:**
- `@showroom/prompts/enhanced_verification_workshop.txt`
- `@showroom/prompts/verify_workshop_structure.txt`
- `@showroom/prompts/verify_technical_accuracy_workshop.txt`
- `@showroom/prompts/verify_accessibility_compliance_workshop.txt`
- `@showroom/prompts/redhat_style_guide_validation.txt`

**For a demo, read:**
- `@showroom/prompts/enhanced_verification_demo.txt`
- `@showroom/prompts/verify_technical_accuracy_demo.txt`
- `@showroom/prompts/verify_accessibility_compliance_demo.txt`
- `@showroom/prompts/redhat_style_guide_validation.txt`

Read all relevant prompts first, then run all checks in one pass. Collect every finding. Output nothing until Phase 3.

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
| `view_switcher.default_mode` | Not `split` | Warning — lab author may intentionally use full-screen mode |
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

**S.5a — `content/supplemental-ui/js/buttons.js`**:

| Condition | Severity |
|---|---|
| File missing AND adoc files contain `role="send-to-wetty"`, `role="send-to-terminal"`, `solve-button-placeholder`, or `validate-button-placeholder` | Critical — buttons will not work at runtime |
| File missing, no button roles used, and this is NOT a cluster provisioner showroom | **Warning** — E2E testing not set up yet; copy from reference repo when ready |
| File missing for a cluster provisioner showroom (display name contains "cluster") | Info only — cluster showrooms don't use E2E buttons |
| File present | ✓ |

If missing and needed, copy from: `https://github.com/rhpds/ocp-zt-dedicated-showroom/blob/main/content/supplemental-ui/js/buttons.js`

**S.5b — `runtime-automation/` directory (E2E testing)**:

Required when solve/validate button placeholders exist in adoc files.

| Condition | Severity |
|---|---|
| `solve-button-placeholder` or `validate-button-placeholder` in adoc but no `runtime-automation/` dir | Critical |
| `runtime-automation/` present but missing `validate.yml` or `solve.yml` for a module | High |
| Neither buttons nor `runtime-automation/` dir present, NOT a cluster showroom | **Warning** — E2E testing not configured; see reference: `https://github.com/rhpds/ocp-zt-dedicated-showroom` |
| Both present and consistent | ✓ |
| Summit/event lab has solve/validate button placeholders | **Warning** — remove from adoc files before tagging for summit/prod |

Reference structure:
```
runtime-automation/
  module-01/validate.yml
  module-01/solve.yml
  module-02/validate.yml
  module-02/solve.yml
  requirements.txt
  packages.txt
```

---

#### Pass B — Structure and Learning Design

Using criteria from the prompt files already read, check all `.adoc` files in the content path.

| ID | Check | Fail condition | Severity |
|---|---|---|---|
| B.1 | `index.adoc` exists | Missing | Critical |
| B.2 | Workshop: `index.adoc` is learner-facing. Demo: `index.adoc` is facilitator-facing (invert check) | Wrong framing for content type | High |
| B.3 | `01-overview.adoc` present with scenario/value framing appropriate to content type | Missing or no framing | High |
| B.4 | `02-details.adoc` present | Missing | High |
| B.5 | Workshop: at least one hands-on module (`03-*` or higher). Demo: at least one Know/Show module | None found | Critical |
| B.6 | `nav.adoc` lists all module files | Any `.adoc` not in nav | High |
| B.7 | Conclusion module exists | Missing | High |
| B.8 | Workshop: each module has ≥3 learning objectives. Demo: skip (Know sections provide context instead) | Missing or fewer than 3 | Warning |
| B.9 | Workshop: each module has ≥2 exercises. Demo: skip (Know/Show modules have no exercises by design) | Fewer than 2 | Warning |
| B.10 | Exercise steps use numbered lists (`.`) | Using bullets (`*`) for steps | Medium |
| B.11 | Learning objectives use bullets (`*`) | Using numbers for objectives | Medium |
| B.12 | Workshop: every exercise has a `=== Verify` section. Demo: skip (no exercises) | Missing after any exercise | High |
| B.13 | No `== References` in individual modules | Present in any module | Medium |
| B.14 | Conclusion has `== What You've Learned` | Missing | High |
| B.15 | Conclusion has `== References` | Missing | Medium |

---

#### Pass C — AsciiDoc Formatting

| ID | Check | Fail condition | Severity |
|---|---|---|---|
| C.1 | `image::` macros include `link=self,window=blank` | Any image without it — use check E.3-img | Warning |
| C.2 | All images have descriptive alt text | Blank, "image", or filename | Warning |
| C.3 | External links use `^` (new tab) | Missing caret | Medium |
| C.4 | Internal `xref:` links do NOT use `^` | Caret on xref | Medium |
| C.5 | Code blocks use `[source,<lang>]` or `[source,role="execute"]` | Bare `----` block that is NOT an expected output block following a command | High |
| C.6 | No em dashes (`—`) | Any em dash | Medium |
| C.7 | Lists have blank line before and after | Lists adjacent to text | Medium |
| C.8 | Document title uses `= ` (single equals) | Wrong heading level | High |
| C.9 | Headings are sentence case | Title Case headings | Warning |
| C.10 | No broken `include::` references | Any unresolved include | Critical |

---

#### Pass D — Red Hat Style Guide

Using criteria from `redhat_style_guide_validation.txt` already read.

| ID | Check | Fail condition | Severity |
|---|---|---|---|
| D.1 | No "the Red Hat OpenShift Platform" | Present | Warning |
| D.2 | Acronyms expanded on first use | Bare OCP/AAP/RHOAI without expansion | Warning |
| D.3 | No vague terms: "robust", "powerful", "leverage", "synergy" | Present | Medium |
| D.4 | No unsupported superlatives without citation | "best", "leading", "most" | Medium |
| D.5 | No non-inclusive terms (whitelist/blacklist, master/slave) | Present | Warning — policy violation, lab is not broken |
| D.6 | Numbers 0–9 as numerals, not words | "three steps" instead of "3 steps" | Medium |
| D.7 | Oxford comma in lists of 3+ | Missing | Low |
| D.8 | No em dashes (style rule) | Present | Medium |
| D.9 | Gender-neutral pronouns (they/them) | he/she used | Warning |
| D.10 | Version numbers match env or use `{ocp_version}` | Hardcoded mismatched version | Warning |

---

#### Pass E — Technical Accuracy

| ID | Check | Fail condition | Severity |
|---|---|---|---|
| E.1 | `oc` commands use lowercase subcommands | `oc Get Pods` style | High |
| E.2 | YAML blocks have consistent 2-space indent | Mixed tabs/spaces | High |
| E.3 | Expected output after every command | `[source,role="execute"]` block with no following plain `----` output block | High |
| E.3-img | `image::` macros with `link=self,window=blank` | Any image without it — non-clickable but lab works | Warning |
| E.3a | All executable command blocks (student or presenter) have `role="execute"` | `[source,<lang>]` block with an executable language identifier missing `role="execute"` — Showroom will not render the copy/execute button. **Only flag blocks with executable languages: `bash`, `sh`, `shell`, `console`, `terminal`, `tty`, `wetty`.** Do NOT flag `[source,text]`, `[source,yaml]`, `[source,json]`, `[source,asciidoc]`, `[source,python]`, or other non-shell languages — these are prose, config, or reference examples that learners are not expected to run. Common in repos cloned from nookbag before the standard was introduced — use bulk fix. | High — copy/execute button missing, lab still usable |
| E.3b | Commands using `role="send-to-wetty"` or `role="send-to-terminal"` also have `role="execute"` combined | `role="send-to-wetty"` without `role="execute"` — send button appears but no copy button | Warning — send still works, copy button missing |
| E.4 | No hardcoded cluster URLs, usernames, passwords | Literal values instead of `{user}`, `{password}` | High — lab loads, but wrong values shown to learner |
| E.5 | All `{attribute}` placeholders defined in `antora.yml` or `_attributes.adoc` | Undefined attribute | High |
| E.6 | All images have alt text | Empty first bracket in `image::` | High |
| E.7 | No skipped heading levels | `=` then `===` skipping `==` | High |
| E.8 | No deprecated UI paths for current OCP version | Outdated menu references | High |
| E.9 | Code examples are syntactically valid | Invalid YAML/JSON/bash | High — confusing to learner, but lab renders |

---

#### Pass F — Demo-specific (skip entirely if workshop)

| ID | Check | Fail condition | Severity |
|---|---|---|---|
| F.1 | Know section before Show section | Missing Know/Show structure | High — demo structure broken, but content renders |
| F.2 | Business value stated per section | No ROI/outcome framing | High |
| F.3 | Presenter notes present | No `[NOTE]` or aside blocks | High |
| F.4 | No hands-on exercises requiring participant input | Participant steps found | High |
| F.5 | Key talking points highlighted | No callout blocks | Medium |

---

### Severity Definitions

Use these definitions strictly. When in doubt, go lower — a false Critical blocks labs unnecessarily.

| Severity | Meaning | Examples |
|---|---|---|
| **Critical** | Lab is broken — learner cannot proceed or content does not render | site.yml missing, antora.yml missing, broken include:: reference, index.adoc missing, buttons.js missing when button roles used |
| **High** | Key functionality broken or significantly degraded — lab loads but something important doesn't work | E.3a missing role="execute" (no copy/execute button), hardcoded cluster values (E.4), invalid code syntax (E.9), broken nav, missing runtime-automation when placeholders exist |
| **Warning** | Standards violation — lab works fine, but doesn't meet Red Hat quality bar | Images without `link=self,window=blank`, non-inclusive terms, style guide violations, missing learning objectives, heading case, E.3-img |
| **Info** | Nice to have — optional quality improvement | Missing conclusion, suggested wording, best practice recommendations |

**Status impact:** Only Critical and High issues mark a lab as "not ready". Warnings and Info are flagged for awareness but do not block the lab from being shown as ready.

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

#### Special fix — E.3a: missing `role="execute"` (bulk replace)

This issue is common in repos originally cloned from `showroom_template_nookbag` before the `role="execute"` standard was introduced. The fix is a bulk find/replace across all module files.

When E.3a is selected:

**Only flag and fix blocks with executable shell languages: `bash`, `sh`, `shell`, `console`, `terminal`, `tty`, `wetty`.**
Do NOT flag or touch `[source,text]`, `[source,yaml]`, `[source,json]`, `[source,asciidoc]`, `[source,python]`, or any non-shell language — these are prose examples or config snippets, not student commands.

1. Inform the user:
   ```
   This fix will replace [source,bash] / [source,sh] / [source,shell] / [source,console] / [source,terminal] / [source,tty] / [source,wetty]
   → [source,role="execute"] across all .adoc files in content/modules/ROOT/pages/.

   It will NOT touch [source,text], [source,yaml], [source,json], [source,asciidoc],
   or any other non-shell language blocks.

   Apply bulk fix to all module files? [Y/n]
   ```

2. If YES — use the Edit tool to replace in each module file:
   - Target: `[source,bash]`, `[source,sh]`, `[source,shell]`, `[source,console]`, `[source,terminal]`, `[source,tty]`, `[source,wetty]` on their own line
   - Replacement: `[source,role="execute"]`
   - Skip any `.adoc` files where the line appears inside a `[source,asciidoc]----...----` fence

3. Report:
   ```
   Fixed: replaced [source,bash] → [source,role="execute"] in N files (M occurrences).
   ```

---

## Related Skills

- `/showroom:create-lab` — Create new workshop modules
- `/showroom:create-demo` — Create presenter-led demo content
- `/showroom:blog-generate` — Transform workshop to blog post
