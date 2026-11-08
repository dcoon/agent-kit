---
name: markdown
license: MIT
metadata:
  audience: agents
  workflow: knowledge-wiki-management
  opencode/slash: true
  opencode/autoinvoke: false
---

# Guardrails

- GUARD: Rules come from the user; lessons come from experience. Never invent either.

# Workflow

## Session Start

1. MEMORY.md is the agent's cross-session memory. 
2. Check workspace for existing MEMORY file; Use shell `find` (or equiv existing tool) to scan workspace; if it doesn't exist, create it in the workspace root.
3. Read MEMORY at session start and after each spawn of a subagent who is aware of MEMORY.
## Writing

- Follow Format section when writing in each section
- Use terse, very dense 

| Section | Write When                                                                     | Autonomous |
| ------- | ------------------------------------------------------------------------------ | ---------- |
| Task    | when work item needs to be remembered across sessions or (sub) agents          | Yes        |
| Rule    | when the user states a rule ("when I say X, do Y"), or when asked to remember. | No         |
| Lesson  | after a tool error with a durable fix                                          | Yes        |

## Linting

- A lesson that proves out 2–3 uses → promote it by wrapping with **bold**.
- Prune superseded lessons, cancelled tasks, and one-offs that never fired again by wrapping with ~~strikethrough~~.

# Format

``` markdown
# Agent Memory

## Tasks
- [ ] Mint [[Nov 2026 Ballot]] from journal/2026-10-26 [due:: 2026-10-27] [completed:: 2026-11-4]

## Rules
- 2026-10-26 — When I say "digest the journal", run wiki-ingest over the last 7 days. [[2026-10-26]]

## Lessons
- 2026-10-26 — periodic (daily, list, limit N) replaces date-filtered journal scans. [[2026-10-26]]
```

- One line per item. Date every entry (`YYYY-MM-DD —`). Cite  — terse lines cite inline; footnote definitions are for entity-note prose, not one-liners.
- Tasks: markdown task + context + the note it concerns. Mark `- [x]` in the turn that completes it. Agent-facing, not for humans.

