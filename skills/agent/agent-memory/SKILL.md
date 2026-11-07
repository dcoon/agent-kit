---
name: agent-memory
description: 'Agent memory for the knowledge wiki vault: `wiki/memory/MEMORY.md` — tasks for future turns, user-stated rules, and durable lessons. Use when: recording a lesson or durable fix, writing a task for a future agent turn, when the user says "remember this" or "when I say X, do Y", after a tool error with a durable fix, or when starting wiki work (read MEMORY.md first).'
license: MIT
compatibility: opencode
metadata:
  audience: agents
  workflow: knowledge-wiki-management
  opencode/slash: true
  opencode/autoinvoke: false
---

# Agent Memory

## Scope

Session
Workspace


## Writing

- Record autonomously: after a tool error with a durable fix, when the user states a rule ("when I say X, do Y"), or when asked to remember.
- CHK: Read the target section first — update an existing line instead of appending a duplicate.
- GUARD: Rules come from the user; lessons come from experience. Never invent either.

## Promotion & lint

- A lesson that proves out 2–3 uses → promote it into wiki-schema (conventions live there), then remove the memory line.
- On lint passes (user-gated): prune superseded lessons, completed or cancelled tasks, and one-offs that never fired again.
