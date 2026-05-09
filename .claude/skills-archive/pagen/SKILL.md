---
name: pagen
description: Personal CRM and contact management - manage contacts, relationships, and interactions. Use when the user discusses contacts, people, or relationship tracking.
---

# pagen - Personal CRM

Contact management with interaction tracking and relationship notes.

## When to use pagen

- User mentions a contact or person
- User wants to track relationships
- User needs contact information
- User discusses networking or connections

## Available features

- Contact storage with details
- Interaction logging
- Relationship notes
- Google Contacts sync
- Calendar integration

## CLI commands

```bash
pagen list                        # List contacts
pagen show <name>                 # Contact details
pagen add "Name" --email x@y.com  # Add contact
pagen note <name> "Met at conf"   # Add note
pagen sync                        # Sync with Google
pagen export --format markdown    # Export
pagen export --format yaml        # YAML export
```

## Data location

`~/.local/share/pagen/pagen.db` (SQLite, respects XDG_DATA_HOME via xdg library)

## Note

No MCP tools currently available for pagen. Use CLI commands via Bash tool.
