---
name: rodeo
description: Access meme-rodeo MCP tools for searching, browsing, and analyzing memes. Use when the user asks about memes, wants to search for memes, get meme stats, or interact with the meme-rodeo platform.
---

# rodeo - Meme Rodeo CLI & MCP Proxy

Go CLI that connects to the meme-rodeo MCP server. Works as both a direct CLI tool and a local MCP stdio proxy for agents like OpenClaw and Claude Code.

## When to use rodeo

- User asks to search for memes
- User wants meme collection stats
- User wants random memes for inspiration
- User needs to configure or troubleshoot meme-rodeo access
- User wants to set up MCP proxy for meme tools

## Prerequisites

The rodeo binary must be built:

```bash
cd /Users/harper/Public/src/2389/meme-rodeo/cli && go build -o rodeo .
```

An API key must be configured (check with `rodeo config get api-key`). If not set:

```bash
rodeo config set api-key <key>
# or
rodeo login  # OAuth with Google
```

## CLI Commands

### List available tools

```bash
rodeo tools
```

Returns: search_memes, get_meme, random_memes, list_recent, meme_stats

### Call a tool directly

```bash
# Search memes by keyword
rodeo call search_memes '{"query":"cat","limit":5}'

# Get collection statistics
rodeo call meme_stats

# Get random memes
rodeo call random_memes '{"count":3}'

# Get a specific meme by ID
rodeo call get_meme '{"id":"abc123"}'

# List recently added memes
rodeo call list_recent '{"limit":10}'
```

### Configuration

```bash
rodeo config get api-key        # Check API key
rodeo config get server-url     # Check server URL (default: https://mcp.meme.rodeo)
rodeo config set api-key <key>  # Set API key
```

Config lives at `~/.config/rodeo/config.yaml`.

## MCP Proxy Mode

Start the stdio proxy server for use with OpenClaw or Claude Code:

```bash
rodeo serve
```

### Add to Claude Code `.mcp.json`

```json
{
  "mcpServers": {
    "memes": {
      "type": "stdio",
      "command": "/path/to/rodeo",
      "args": ["serve"]
    }
  }
}
```

This exposes all meme-rodeo tools (search_memes, get_meme, random_memes, list_recent, meme_stats) as local MCP tools that any agent can call.

## Auth Precedence

1. `--api-key` CLI flag
2. `RODEO_API_KEY` environment variable
3. OAuth token (from `rodeo login`)
4. API key from config file

## Troubleshooting

- **"no auth configured"**: Run `rodeo config set api-key <key>` or `rodeo login`
- **Connection errors**: Check `rodeo config get server-url` — default is `https://mcp.meme.rodeo`
- **"invalid JSON"**: Tool args must be valid JSON objects, e.g. `'{"query":"cat"}'`
