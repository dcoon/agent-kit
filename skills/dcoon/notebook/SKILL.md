---
name: notebook
description: How to read, edit, and process notes for dcoon's personal notebook. Use when asked to read or write to "the notebook".
license: MIT
metadata:
  audience: agents
  workflow: knowledge-wiki-management
  opencode/slash: true
  opencode/autoinvoke: false
---
# Notebook

## Workflow

1. Discover which notebook access method is available: in order of preference
	1. obsidian-mcp
	2. obsidian-cli
	3. obsidian-files.
2. Read [schema](references/schema) to understand how to read and write in the notebook
3. Reply by reading and/or writing as instructed by prompt

# Guards

1. Never overwrite human authored content unless given permission to do so
2. Never scan or read the entire vault ; always use search/query/patch tools to narrow content to minimal amount possible to accomplish the current task.  
# References

| Ref            | Use When                                                                                                                   |
| -------------- | -------------------------------------------------------------------------------------------------------------------------- |
| obsidian-mcp   | Obsidian-mcp server is registered or https://127.0.0.1:27124/mcp/ is open port.                                            |
| obsidian-cli   | Obsidian-mcp server is not available but obsidian cli tools are available in shell.                                        |
| obsidian-files | Obsidian-mcp and obsidian-cli are both unavailable. Ask user if ok to fallback to local markdown in the current workspace. |
| schema         | Before writing content in the notebook.                                                                                    |
| learn          | When asked by the user to learn from a prompt or existing notebook content.                                                |
