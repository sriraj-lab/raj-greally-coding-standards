# Recommended MCPs (Model Context Protocol Servers)

## What Are MCPs?

Model Context Protocol (MCP) servers let AI tools like Claude Code access external data sources and services. Instead of relying on the AI's training data (which may be outdated or hallucinated), MCPs provide real-time access to documentation, APIs, and other resources.

**Tier requirement:** MCPs are for Tier 2+ users only. They run as local servers and interact with your AI tooling, so you need the experience to understand what they're doing.

## Recommended: Context7

**What it does:** Looks up real API documentation for libraries and frameworks. This prevents AI from hallucinating function signatures, deprecated APIs, or non-existent parameters.

**Why it matters:** AI tools frequently generate code using API signatures that look correct but are slightly wrong (wrong parameter names, deprecated methods, incorrect defaults). Context7 gives the AI access to actual current documentation.

**Setup:**

1. Install via npm (or see [Context7 documentation](https://github.com/upstash/context7) for latest instructions):
   ```bash
   npm install -g @upstash/context7-mcp
   ```

2. Add to your Claude Code MCP configuration (`.mcp.json` in your project root or `~/.claude/mcp.json` globally):
   ```json
   {
     "mcpServers": {
       "context7": {
         "command": "npx",
         "args": ["-y", "@upstash/context7-mcp@latest"]
       }
     }
   }
   ```

3. Restart Claude Code to pick up the new MCP server.

**Usage:** Once configured, Claude Code will automatically use Context7 to look up documentation when generating code that uses external libraries.

## General MCP Notes

- MCPs run as local processes on your machine -- they do not send your data to external services (beyond the specific API they connect to).
- Keep MCP servers updated to get the latest documentation indices.
- If an MCP server is causing issues, you can disable it by removing its entry from `.mcp.json`.
- For the latest MCP ecosystem and available servers, see the [MCP specification](https://modelcontextprotocol.io/).
