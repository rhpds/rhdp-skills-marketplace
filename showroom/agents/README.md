# Showroom Agents

Three specialized review agents that skills invoke for independent quality checks after content generation.

## Agents

**`workshop-reviewer.md`** - Workshop & Demo Quality Reviewer
- Validates learning objectives, hands-on exercise quality, Know/Show structure
- Checks pacing, prerequisite clarity, business context
- Reviews storytelling tone (professional, not marketing)

**`style-enforcer.md`** - Red Hat Style Guide Enforcer
- Enforces Red Hat product naming, capitalization (sentence case), terminology
- Catches prohibited language ("robust", "leverage", "whitelist")
- Validates inclusive language, Oxford commas, numeral formatting

**`technical-editor.md`** - Technical Accuracy Reviewer
- Verifies CLI commands, code snippets, configuration correctness
- Checks AsciiDoc syntax, cross-references, link validity
- Standardizes formatting and terminology consistency

## How They're Used

Skills invoke these agents automatically during their validation step:

| Skill | Agents Invoked |
|---|---|
| `/showroom:create-lab` | workshop-reviewer, style-enforcer |
| `/showroom:create-demo` | workshop-reviewer, style-enforcer |
| `/showroom:verify-content` | workshop-reviewer, style-enforcer, technical-editor |
| `/showroom:blog-generate` | technical-editor, style-enforcer |

You can also invoke them directly:

```
Use the workshop-reviewer agent to review my module-03.adoc
```

## Source

From [showroom_template_nookbag](https://github.com/rhpds/showroom_template_nookbag).
