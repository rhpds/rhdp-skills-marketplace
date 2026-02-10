# Skill Improvement TODOs

## ~~High Priority: Showroom Skills Content Quality~~ DONE

**Resolved in v2.5.0-tech-preview.**

Step 0 (reference repository prompt) was added then removed. The real fix was bundling quality templates directly into the plugin at `showroom/templates/demo/` (7 files, ~40KB) and `showroom/templates/workshop/` (15 files). Skills now read these bundled templates automatically in Step 8 -- no user interaction needed, no 404 failures, no cloning to `/tmp/`.

---

## Other Improvements

### TODO: Add auto-detection for AgnosticV repository
Similar pattern - check if `~/work/code/agnosticv` exists before running catalog-builder

### TODO: Add validation for required tools
Check if `ansible`, `git`, `gh` CLI are installed before running skills that need them

### TODO: Improve error messages
When WebFetch fails with 404, explain clearly that reference content is unavailable
