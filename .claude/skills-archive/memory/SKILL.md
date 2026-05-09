---
name: memory
description: Semantic memory and context - store and retrieve information with embeddings for similarity search. Use for long-term memory, context recall, and knowledge persistence.
---

# memory - Semantic Memory

Vector-based memory storage with embeddings for semantic similarity search.

## When to use memory

- Store important context for future sessions
- Recall relevant information from past conversations
- Build persistent knowledge about user preferences
- Semantic search across stored memories

## Available MCP tools

| Tool | Purpose |
|------|---------|
| `mcp__memory__store` | Store a memory |
| `mcp__memory__search` | Semantic similarity search |
| `mcp__memory__list` | List recent memories |
| `mcp__memory__delete` | Remove a memory |
| `mcp__memory__get_context` | Get relevant context |

## Common patterns

### Store a memory
```
mcp__memory__store(
  content="User prefers TypeScript over JavaScript for new projects",
  tags=["preferences", "programming"]
)
```

### Search memories
```
mcp__memory__search(query="What does the user prefer for web development?", limit=5)
```

### Get context for a topic
```
mcp__memory__get_context(topic="user's coding preferences")
```

### List recent memories
```
mcp__memory__list(limit=10)
```

## Best practices

1. **Store preferences** - When user expresses a preference, store it
2. **Store decisions** - Important decisions and their rationale
3. **Store context** - Project-specific context that spans sessions
4. **Search before assuming** - Check memory before making assumptions

## CLI commands (if MCP unavailable)

```bash
memory add "Content to remember" --tag preference
memory search "query"             # Semantic search
memory list                       # Recent memories
memory export -f markdown         # Export
```

## Data location

`~/.local/share/memory/memory.db` (SQLite with embeddings as BLOB, respects XDG_DATA_HOME)
