---
name: wiki-memory
description: 'Rules for the agent-owned `wiki/memory/` directory in the knowledge wiki vault — agent-written tasks and durable memories for future turns or sessions. Use when: recording a lesson or durable fix, writing a task for a future agent turn, when the user says "remember this" or "when I say X, do Y", or after a tool error with a durable fix.'
license: MIT
compatibility: opencode
metadata:
  audience: agents
  workflow: knowledge-wiki-management
  opencode/slash: true
  opencode/autoinvoke: false
---

# Agent Memory Notes

`wiki/memory/` = notes the agent writes for itself for future turns or sessions. Access goes through the obsidian MCP server; shell commands and scripts touch the vault only when the user explicitly gives permission.

- **Tasks**: Agent-written tasks for the agent in a future turn. Not for humans. Format as markdown tasks (`- [ ]`) for human review; add `[due:: YYYY-MM-DD]` when relevant. One line each: no heading method, no provenance.
- **Memories**: Lessons, durable fixes, rules, in markdown. Agents record autonomously (e.g. after a tool error with a durable fix, or when user says "When I say X, do Y"). Include a `## Provenance` section.
- The rule against copying tasks into `wiki/graph/` does not apply to `wiki/memory/`.
