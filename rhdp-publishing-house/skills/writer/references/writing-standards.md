# Publishing House Writing Standards

Standards for the writer agent when generating content via showroom skills.
These supplement the showroom skill's own rules — do not duplicate them.

## Module Outline as Starting Point

The approved module outline in `publishing-house/spec/modules/module-NN-*.md` is the
writer's primary input. When generating new content, every section in the outline should
appear in the generated content. Do not add major sections not in the outline. Do not
skip sections that are in the outline.

If the outline is ambiguous or incomplete, ask the user for clarification rather than
guessing. In `full` autonomy mode, make reasonable assumptions and note them in the
module's review notes for the editor to validate.

**However:** Both the outline and any existing content may have been modified by a human
since the last agent run. Always read the current version of files from disk. If existing
content diverges from the outline, the human's edits take precedence — build on what
exists rather than overwriting it. Note any divergence for the editor to review, but
do not treat human modifications as errors.

## Content Type Routing

The writer agent uses the manifest's `project.type` field to determine which
showroom skill to invoke:

| `project.type` | Showroom Skill | Content Structure |
|----------------|----------------|-------------------|
| `workshop`     | `showroom:create-lab` | Exercises with verification sections |
| `demo`         | `showroom:create-demo` | Know/Show presenter-led format |

## Showroom Skill Invocation

When invoking showroom skills, provide these inputs derived from the PH context:

### For `showroom:create-lab`
- **Directory:** `content/modules/ROOT/pages/` (or from manifest's showroom_repo path)
- **Reference materials:** The module outline file path — the showroom skill reads it as reference
- **Learning objectives:** Extracted from the module outline's "Learn" section
- **Business scenario:** Extracted from `publishing-house/spec/design.md` problem statement
- **Target duration:** From the module outline's "Audience and Time" section
- **Audience level:** From design.md's target audience
- **New vs continue:** First module uses `--new`, subsequent modules use `--continue <previous-module-path>`

### For `showroom:create-demo`
- **Directory:** `content/modules/ROOT/pages/`
- **Demo materials:** The module outline file path
- **Demo objective:** From the module outline's "Brief Overview"
- **Customer scenario:** From design.md's problem statement
- **Value proposition:** From design.md's learning objectives
- **Target duration:** From the module outline
- **Audience:** From design.md's target audience

## Module Numbering

Modules are numbered sequentially in the Showroom content directory:
- First module in the lab: `03-module-01-<title>.adoc` (after index, overview, details)
- Second module: `04-module-02-<title>.adoc`
- Pattern: `0{N+2}-module-{NN}-<title>.adoc`

The showroom skills handle this numbering. The writer agent provides the module
outline and lets the skill determine the correct file numbers.

## Post-Generation Checklist

After the showroom skill generates content, verify:

1. All sections from the module outline are represented in the generated content
2. Navigation (`nav.adoc`) was updated with the new module
3. The generated file exists at the expected path
4. No hardcoded credentials, URLs, or environment-specific values (use `{attributes}`)

## Manifest Module Status

Update the module's status in the manifest as work progresses:

| Status | When |
|--------|------|
| `pending` | Not yet started |
| `in_progress` | Showroom skill invoked, writing underway |
| `drafted` | Content generated and initial checks passed |
| `approved` | User approved the draft (or editor approved in semi/full) |

## What the Writer Does NOT Do

- Does not set up the Showroom scaffold (site.yml, ui-config.yml) — the showroom skill handles this on the first module
- Does not run editorial review — that is the editor agent's job
- Does not generate conclusion modules — generated after all modules are drafted, as the final writing step
- Does not update the manifest's phase-level status — only module-level status. The orchestrator manages phase transitions.
