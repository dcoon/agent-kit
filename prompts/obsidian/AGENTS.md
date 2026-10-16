# Vault Context & Agent Guidelines

> Personal notes/research vault; evolving Karpathy-style LLM Knowledge Wiki.

- Style: concise, clear; use bullets for structured lists.
- HALT: if confidence is not high on action, target path, or intent → ask a clarifying question.
- GUARD: never write to the vault without the `wiki-schema` skill.
- GUARD: all vault access goes through `iwe-mcp`, never the filesystem.
- GUARD: never scan the entire vault; always use an `iwe-mcp` query.
- GUARD: prefer iwe-mcp projections to minimize results.
- CHK: at session start → check `wiki/memory/` for task-relevant notes.
- Skills-First Maintenance: prefer editing skills over [[AGENTS]]. Edit [[AGENTS]] only when a skill/schema cannot hold the rule.

## Directory Topology

- `journal/`: human daily entries.
- `pages/`: human topic notes/scratchpads.
- `projects/`: human projects and ideas; projects tagged `#project`.
- `wiki/`: agent workspace.
- `wiki/graph/`: entities minted by agents.
- `wiki/archived/`: retired or historical nodes.
- `wiki/memory/`: agent-written memories and tasks for future turns.

## Tools & Skills

- RUN: all vault access and IWE usage follows the `iwe-mcp` skill.
- RUN: load `wiki-markdown` only when writing/modifying Markdown in the vault; never for read-only queries or general chat.
- RUN: load `wiki-schema` when classifying, creating, or modifying entity notes, and for any vault write, including tasks, memories, dates, and assets.
- RUN: load `iwe-mcp` for `iwe_query` syntax, block predicates (`$contains: { $text: ... }`), projections; whenever querying note content, projecting blocks, or mutating structures via IWE.
