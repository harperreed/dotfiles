---
name: granola-to-obsidian
description: Use when asked to import, sync, or add Granola meeting notes into the Obsidian vault. Triggers on "meeting notes", "Granola", "import meetings", "add notes from this week", or any request to move meeting content into Obsidian.
---

# Granola to Obsidian

Import Granola meeting notes into the 2389 Obsidian vault with correct formatting.

## When to Use

- User asks to import/sync/add meeting notes from Granola
- User references specific dates and wants notes created
- User says "grab my meetings from last week" or similar

## Critical: Read Before You Write

**NEVER guess the format.** Before creating any meeting note, read 2-3 existing files in `Meeting Notes/` to confirm current conventions. Formats evolve.

## Step-by-Step Process

### 1. Confirm Date Range

- Use the **current year** (check today's date, do NOT default to 2025)
- If user gives day-of-week names, verify they match the actual calendar
- `custom_end` should be the day AFTER the last date (exclusive upper bound)

### 2. List Meetings from Granola

```
mcp__granola__list_meetings
  time_range: "custom"
  custom_start: "YYYY-MM-DD"
  custom_end: "YYYY-MM-DD"   # day after last date
```

### 3. Get Full Meeting Details

```
mcp__granola__get_meetings
  meeting_ids: ["id1", "id2", ...]   # max 10 per call
```

### 4. Read Existing Notes for Format Reference

```
Glob: Meeting Notes/*.md
Read: 2-3 recent files to confirm frontmatter and body format
```

### 5. Check for Duplicates

Search by meeting title in existing filenames:
```
Glob: Meeting Notes/*{partial-title}*
```
If a file with a matching title exists, **ask the user** before overwriting.

### 6. Create the Note Files

## File Format Template

**Filename:** Date prefix with hyphen-separated title: `YYYY-MM-DD-Title.md`
- `Meeting Notes/2026-01-30-Camp Sessions.md` (correct)
- `Meeting Notes/Camp Sessions.md` (WRONG — older files use this, but new notes get the date prefix)

**Content structure:**

```markdown
---
Created by: Harper Reed
Created time: YYYY-MM-DDTHH:MM:SS
Event time: YYYY-MM-DD
Type: <see type list>
Attendees:
  - Name One
  - Name Two
---
# Meeting Title

Day, DD Mon YY · location-or-participant-emails

### Section Heading

- Bullet point content
  - Nested detail
- Another point

### Another Section

- Content follows Granola's summary structure directly
```

## Frontmatter Fields

| Field | Value | Source |
|---|---|---|
| `Created by` | `Harper Reed` | Always (note creator) |
| `Created time` | ISO 8601 timestamp | From Granola meeting datetime |
| `Event time` | ISO 8601 date only | From Granola meeting date |
| `Type` | See below | Classify from content |
| `Attendees` | YAML list of names | From Granola participants |

**Do NOT add:** `notion-id`, `base`, `Last edited by`, `Last edited time` (those are legacy Notion migration artifacts on older files).

## Type Classification

| Type | When to Use |
|---|---|
| `Investors` | VC meetings, fundraising discussions |
| `Tactical` | Internal team planning, standups |
| `Training` | Research, experiments, learning sessions |
| `Camp` | External events, camp sessions |
| `Brainstorm` | Ideation, product exploration |
| `Strategy` | Company direction, GTM, partnerships |
| `Product Demo` | Product demonstrations, demos |
| `Meetup` | Community events, group gatherings |
| `1:1` | One-on-one conversations |

If unsure, omit the Type field rather than guessing wrong.

## Body Date Format

Use: `Day, DD Mon YY · context`

Examples:
- `Wed, 28 Jan 26 · Betaworks`
- `Thu, 29 Jan 26 · dylan@2389.ai, harper@2389.ai`
- `Fri, 30 Jan 26`

The context after `·` is optional. Use location if known, participant emails if it's a small meeting, or omit.

## Body Content

- Use the Granola summary sections directly as H3 (`###`) headings
- Keep bullet-point structure from Granola
- Do NOT invent sections like "Key Decisions" or "Action Items" with checkbox syntax unless Granola's summary actually contains them
- Do NOT add `- [ ]` task checkboxes unless the source has them
- Preserve Granola's summary structure faithfully

## Private Notes

If Granola returns `private_notes`, do NOT include them in the Obsidian file by default. Ask the user if they want private notes included.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Using the wrong year | Always check `today's date` for current year |
| Missing date prefix in filename | New notes use `YYYY-MM-DD-Title.md` format (older files without prefix are legacy) |
| Inventing frontmatter fields | Use only: Created by, Created time, Event time, Type, Attendees |
| Adding Notion legacy fields | `notion-id` and `base` are only on migrated files |
| Checkbox action items | Don't add `- [ ]` unless source has them |
| Guessing format without reading | Always read 2-3 existing notes first |
| Bold labels in body | Don't use `**Date:**` patterns, use the date line format |
| Overwriting existing notes | Always check for duplicates by title first |
