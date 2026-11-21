---
name: obsidian-mcp
description: Read/write access to notebook using obsidian-mcp. Use when asked to read or write to "the notebook" via the obsidian-mcp server.
license: MIT
---
# obsidian-mcp

# Workflow

1. Verify obsidian-mcp MCP server is registered; if not, install it via Install section below.
2. Use obsidian-mcp tools to execute prompt then reply
## Guards

1. Always use mcp tools to read and write content; Never use shell tools to edit files directly
2. Minimize content size read and written to the notebook
	1. use search_query or search_simple to discovery notes; do not use vault_list
	2. use vault_append and vault_patch to write targeted changes; do not use vault_write unless creating a new note or replacing an entire existing note.
	3. do not read or load attachments (ie. images, PDFs) unless asked to do so

## Install

Use when obsidian-mcp server is not registered but https://127.0.0.1:27124/mcp/ is open port.

1. Register obsidian-mcp as remote HTTP MCP server with link: https://127.0.0.1:27124/mcp/
2. Verify MCP server is available and which version

## Additional Info

| Link                                                                                                                                      | Use When                                      |
| ----------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------- |
| [MCP Server Documentation]([https://github.com/rait-09/obsidian-agent-client](https://github.com/coddingtonbear/obsidian-local-rest-api)) | Troubleshooting install or use of MCP server. |


