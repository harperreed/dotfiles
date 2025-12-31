---
name: remember
description: Use when you learn something worth preserving, complete a project milestone, discover user preferences, or need to recall past context - search before create, tag consistently, verify retrieval
---

# Remember: Systematic Memory Management

**Core principle:** Memories are for retrieval, not storage. If you can't find it, you didn't remember it.

## The Iron Law

```
NO MEMORY WITHOUT SEARCH FIRST. NO MEMORY WITHOUT VERIFICATION AFTER.
```

## The Protocol

### 1. Search First

```python
mem_search(query="<what you want to remember>", limit=5)
```

Found similar? Update or link to it. Don't create duplicates.

### 2. Write Specific Text

```
BAD:  "User likes Python"
GOOD: "Doctor Biz prefers uv for all Python package management. Never use pip, poetry, or easy_install."

BAD:  "Fixed a bug"
GOOD: "SQLite datetime gotcha: Use datetime(column) for comparisons, not raw column."
```

Include keywords you'd search for later.

### 3. Tag Consistently

**Primary (pick one):** `project`, `preference`, `architecture`, `gotcha`, `solution`, `milestone`, `location`

**Secondary:** project names, tech stack, status (`project-complete`, `in-progress`, `deprecated`)

### 4. Verify Retrieval

```python
mem_search(query="<natural language query>", limit=3)
```

Can't find it? Fix the text or tags now. Don't move on until it's findable.

## Quick Reference

| Action | Command |
|--------|---------|
| Search | `mem_search(query="...", limit=10)` |
| Add text | `mem_add_text(text="...", tags=[...])` |
| Add file | `mem_add_file(path="...", tags=[...])` |
| Link | `mem_link(source_id="...", target_id="...", relation_type="...")` |
| Delete | `mem_delete(id="...")` |

## When to Remember

| Yes | No |
|-----|-----|
| Project milestones | Temporary debug notes (use journal) |
| User preferences | Things findable via grep |
| Architecture decisions | Vague "might be useful" ideas |
| Debugging breakthroughs | Raw file dumps without context |
| API gotchas | Duplicates of existing memories |

## Red Flags

- "I'll search later" → Search now
- "Tags don't matter" → They're how you browse
- "Close enough" → Verify or it's lost
- "Might be useful someday" → Too vague, don't save it

## Self-Correction

**Created without searching?** Search now. Delete duplicates.

**Can't find it?** Fix text/tags now. Don't move on.

**Found conflicts?** Resolve immediately. Use `supersedes` relation.

## Session Workflow

```
Starting:  Search for project context, gotchas, architecture decisions
During:    Journal for reflection, note things worth remembering
Ending:    Create memories, verify all are findable
```
