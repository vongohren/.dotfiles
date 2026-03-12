# MCP (Model Context Protocol) Knowledge

## Overview

MCP servers extend Claude Code with additional tools and capabilities. Each server can have its own authentication.

## Configuration Scopes

| Scope | Location | Purpose | Shared |
|-------|----------|---------|--------|
| **User** | `~/.claude.json` | Global, all projects | No |
| **Project** | `.mcp.json` (project root) | Team configs | Yes (git) |
| **Local** | `~/.claude.json` (per-project key) | Personal overrides | No |

### Precedence (highest to lowest)

1. Local - overrides everything for you in that project
2. Project - overrides user scope
3. User - baseline/fallback

**Note:** No merging - higher priority completely replaces lower priority for same-named servers.

## Adding MCP Servers

```bash
# User scope (global, all projects)
claude mcp add --scope user <name> -- <command>

# Project scope (shared via .mcp.json)
claude mcp add --scope project <name> -- <command>

# HTTP transport with auth header
claude mcp add --transport http secure-api https://api.example.com/mcp \
  --header "Authorization: Bearer <token>"

# With environment variables
claude mcp add my-server --env API_KEY=secret -- npx my-mcp-server
```

## Managing Servers

```bash
# List all configured servers
claude mcp list

# Get server details
claude mcp get <name>

# Remove a server
claude mcp remove <name>

# Reset project approval choices
claude mcp reset-project-choices
```

## Environment Variables in `.mcp.json`

Project configs support variable expansion for team sharing:

```json
{
  "mcpServers": {
    "my-server": {
      "command": "npx",
      "args": ["my-mcp-server"],
      "env": {
        "API_KEY": "${MY_API_KEY}",
        "DEBUG": "${DEBUG:-false}"
      }
    }
  }
}
```

- `${VAR}` - uses environment variable
- `${VAR:-default}` - uses default if not set

## Authentication Methods

1. **Bearer tokens** - via `--header` flag
2. **Environment variables** - via `--env` flag
3. **OAuth 2.0** - interactive via `/mcp` command in Claude Code

Each server maintains independent auth state.

## Security

- Project-scoped servers from `.mcp.json` require approval on first use
- Don't commit secrets to `.mcp.json` - use `${VAR}` expansion
- Local scope for sensitive/experimental configs

## Storage Locations

- User/Local configs: `~/.claude.json`
- Project configs: `.mcp.json`
- Enterprise managed: `managed-mcp.json` (system directories)

## Quick Reference

```bash
# Add Linear MCP globally
claude mcp add --scope user linear -- npx @linear/mcp-server

# Add project-specific server with auth
claude mcp add --scope project github \
  --env GITHUB_TOKEN='${GITHUB_TOKEN}' \
  -- npx @github/mcp-server

# Interactive OAuth setup
/mcp
```
