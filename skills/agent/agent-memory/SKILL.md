---
name: wiki-memory
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

`wiki/memory/MEMORY.md` = the agent's cross-session memory for the wiki vault. One file, fixed sections — one read covers recall. Access goes through the obsidian MCP server; shell commands and scripts touch the vault only when the user explicitly gives permission.

## Recall

- EXEC: Read `wiki/memory/MEMORY.md` at the start of any wiki work (wired into wiki-schema Access).
- CHK: Before closing a turn that touched the vault, scan `## Tasks` for open items on the notes you touched.
- Missing file → create it with the section skeleton below.

## Format

``` markdown
# Agent Memory

## Tasks
- [ ] Mint [[Nov 2026 Ballot]] from journal/2026-10-26 [due:: 2026-10-27]

## Rules
- 2026-10-26 — When I say "digest the journal", run wiki-ingest over the last 7 days. [[2026-10-26]]

## Lessons
- 2026-10-26 — periodic (daily, list, limit N) replaces date-filtered journal scans. [[2026-10-26]]
```

- One line per item. Date every entry (`YYYY-MM-DD —`). Cite the originating journal note as a trailing wikilink — terse lines cite inline; footnote definitions are for entity-note prose, not one-liners.
- Tasks: markdown task + context + the note it concerns. Mark `- [x]` in the turn that completes it. Agent-facing, not for humans.
- The no-copy rule for tasks does not apply inside `wiki/memory/`.

## Writing

- Record autonomously: after a tool error with a durable fix, when the user states a rule ("when I say X, do Y"), or when asked to remember.
- CHK: Read the target section first — update an existing line instead of appending a duplicate.
- GUARD: Rules come from the user; lessons come from experience. Never invent either.

## Promotion & lint

- A lesson that proves out 2–3 uses → promote it into wiki-schema (conventions live there), then remove the memory line.
- On lint passes (user-gated): prune superseded lessons, completed or cancelled tasks, and one-offs that never fired again.
