---
name: rhdp-publishing-house:worklog
description: This skill should be used when the user asks to "leave a note", "what's outstanding", "worklog", "resolve item", "what did we do last session", "add a worklog entry", "squash the worklog", or "session summary". It manages the human-context layer in publishing-house/worklog.yaml.
---

---
context: main
model: claude-sonnet-4-6
---

# RHDP Publishing House — Worklog Manager

You manage `publishing-house/worklog.yaml` — the human-context layer that bridges
sessions, people, and decisions. This is NOT a task tracker (the manifest tracks
structured progress). The worklog captures what falls between the cracks: decisions
pending, things to check with people, handoff notes, session summaries.

## Before Starting

1. Read `publishing-house/worklog.yaml` — if it doesn't exist, create it with an empty `entries: []` list
2. Read `publishing-house/manifest.yaml` for project context (name, current phase, owner)

## Commands

### View Open Items

When the user asks "what's outstanding?" or "worklog":

1. Read `worklog.yaml`
2. Filter entries with `status: open`
3. Present them grouped by type (decisions first, then actions, then notes):

> **Open Items (3):**
> - **Decision:** Need to decide on DataSphere vs Parksmap for module 2 demo app (Apr 15, sborenst)
> - **Action:** Check with Prakhar on CNV pool sizing (Apr 14, sborenst)
> - **Note:** Module 3 may need a different approach for the scaling exercise (Apr 13, sborenst)

### Add a Note

When the user says "leave a note about X" or "add to worklog":

1. Take the user's terse input
2. Expand it into a readable entry using LLM — add enough context that someone else (or the same person next week) can understand it without asking follow-up questions
3. Classify the type: `note`, `decision`, `handoff`, or `action`
4. Generate a unique ID: `YYYY-MM-DD-NNN` (date + sequence number for that day)
5. Write the entry to `worklog.yaml`
6. Commit and push: `git add publishing-house/worklog.yaml && git commit -m "worklog: <brief summary>" && git push`

**Example expansion:**
- User says: "check with prakhar on pool sizing"
- Skill writes:
  ```yaml
  - id: "2026-04-14-001"
    timestamp: "2026-04-14T10:00:00Z"
    author: "<github_username from manifest>"
    status: open
    type: action
    content: "Check with Prakhar on CNV pool sizing for multi-user deployments. The current common.yaml uses default pool settings, but this workshop supports 25 concurrent users which may need larger worker nodes."
  ```

### Resolve an Item

When the user says "resolve item X" or "that's done":

1. Find the entry by ID or by content match
2. Set `status: resolved`, `resolved_at: <now>`, `resolved_by: <github_username>`
3. Commit and push

### Session Summary

When the user says "session summary" or "I'm done for today" or at session end:

1. Read the manifest to see what changed this session (compare current phase/substep status)
2. Write a summary entry:
   ```yaml
   - id: "2026-04-15-session"
     timestamp: "2026-04-15T16:30:00Z"
     author: "<github_username>"
     status: resolved
     type: note
     content: "Session summary: Completed modules 1-3 drafts. Automation manifest reviewed and approved. Next session: start automation code (7c). Open decisions: DataSphere vs Parksmap for module 2."
   ```
3. Commit and push

### Squash Old Entries

When the user says "squash the worklog" or automatically when the file exceeds ~30 entries:

1. Find all resolved entries older than 1 week
2. Group them by week
3. Compress each week's resolved entries into a single summary entry:
   ```yaml
   - id: "summary-2026-04-10"
     timestamp: "2026-04-10T00:00:00Z"
     author: "system"
     status: resolved
     type: summary
     content: "April 10-14: Project created. Intake completed — 5-module workshop design approved. Spec refinement normalized design doc. Automation catalog and requirements completed. Resolved: CNV pool sizing confirmed with Prakhar."
   ```
4. Remove the individual resolved entries that were squashed
5. Commit and push

## Worklog File Format

```yaml
# Publishing House Worklog
# Human context, decisions, and notes that bridge sessions and people.
# Not a task tracker — the manifest tracks structured progress.

entries:
  - id: "2026-04-15-001"
    timestamp: "2026-04-15T14:30:00Z"
    author: "sborenst"
    status: open          # open | resolved
    type: decision        # note | decision | handoff | action | summary
    content: "Expanded, readable description of the item."
    # resolved entries also have:
    # resolved_at: "2026-04-15T09:00:00Z"
    # resolved_by: "sborenst"
```

## Entry Types

- `note` — general observation, context for future sessions
- `decision` — something that needs to be decided (open) or was decided (resolved)
- `handoff` — work being handed to someone else, includes context they need
- `action` — something that needs to be done outside of PH (check with someone, test something)
- `summary` — compressed history from squashing (always resolved)

## What You Do NOT Do

- Do not duplicate manifest state — if a module is "drafted", the manifest tracks that
- Do not create action items for PH phases — "write module 3" is a manifest concern, not a worklog item
- Do not store sensitive data (credentials, internal URLs) in worklog entries
- Do not modify the manifest — only the worklog file
