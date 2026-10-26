---
name: wiki-schema
description: 'Defines how to create, classify, and maintain notes within the Karpathy-style LLM Knowledge Wiki topology. Use when: creating, updating, classifying, archiving, or journaling notes in the wiki vault, minting entity notes, or applying wiki naming, tagging, typing, and provenance rules. Load before any write to the wiki vault; vault access goes through the obsidian MCP server.'
license: MIT
compatibility: opencode
metadata:
  audience: agents
  workflow: knowledge-wiki-management
  opencode/slash: true
  opencode/autoinvoke: false
---

# Knowledge Wiki Management Skill

> Purpose: create, classify, and maintain notes in the Karpathy-style LLM Knowledge Wiki.

## Access

*What it does: selects the backend for note operations.*

- EXEC: Run all note operations through the `obsidian` MCP server. Steps in this skill refer to abstract operations; resolve them via the table below.
- GUARD: Shell commands and scripts may touch the vault only when the user explicitly gives permission. Otherwise use `obsidian` tools.
- Frontmatter edits use `frontmatter`; note metadata (tags, headings, links) via `note_inspect`.

| Operation | obsidian-mcp tool |
|---|---|
| read note | `note_read` |
| create / overwrite | `note_create` / `note_write` |
| append / section edit | `note_insert` / `note_patch` |
| find / query | `search_text`, `search_regex`, `search_metadata`, `search_semantic` |
| rename / move | `note_move` |
| delete | `note_delete` (`confirm: true`) |
| stats | `vault_info` |
| daily / periodic notes | `periodic` (daily get/create) |
| link checks | `wikilinks` (backlinks / outgoing) |

## Writing Rules

*What it does: where and when agents may write.*

- GUARD: Never overwrite/remove human-authored content unless user explicitly asks.
- GUARD: Human-authored notes (journal, page notes): write only when user asks.
- Autonomy: notes the agent minted (creation recorded in `## Provenance`) may be updated without asking; append Provenance per the rules below.
- `wiki/memory/` is agent-owned; see the `wiki-memory` skill.

## Dates

*What it does: date format standard.*

- Use ISO 8601 (`YYYY-MM-DD`) in notes, filenames, frontmatter, task metadata.
- Task dates use Dataview inline fields: `[due:: YYYY-MM-DD]`, `[scheduled:: YYYY-MM-DD]`, `[completed:: YYYY-MM-DD]`.

## Journal Logging

*What it does: rules for writing to the daily journal.*

Trigger: user says "record this in the journal for [note]" or "write this down".

- EXEC: Write to today's daily note (`journal/YYYY-MM-DD`) via `periodic` (daily).
- EXEC: Upsert top-level heading `# [[Exact Note Name]]` for the source note. Exists → append under it. Else → add at end.
- Record discoveries and decisions as dated summaries (bullets or subheadings as fits).
- GUARD: Write only when user asks.
- CHK: User names source note exactly. No name → ask.
- User says "I don't know," "doesn't matter," or "just today" → use `# Today`.
- "The note we're working on" = note from current conversation. Unclear → ask.

## Assets

*What it does: where assets are stored.*

- Store asset next to the note that imported/created it.
- Asset imported solely for a new entity → store next to that entity.
- GUARD: Never copy assets. Link to them.

## Naming

*What it does: slug convention for graph nodes.*

- Graph nodes use the full official name as slug (e.g. `victron-energy`). Keep shorthand names in `aliases:`.

## Links

*What it does: link format conventions.*

- Internal links use `[[Note Name]]` wikilinks.
- External links use markdown `[text](url)`.

## Entity Typing with Tags

*What it does: how to type entities via tags.*

- Entity types = Obsidian tags named like schema.org types (e.g. `#person`, `#organization`, `#book`). No fixed list.
- CHK: Before creating a type tag, search vault for existing tags using the find / query operation. Reuse a fitting tag even if wording differs (e.g. `#organization` not `#company`). Create new only when none fits.
- GUARD: No overly general types (`#concept`, `#thing`, `#entity`) unless the user created them.
- `#idea` = evolving research topic. Add `#project` when it produces work product.

Two ways to type an entity:

- **Whole note is about the entity**: Add type tag in frontmatter. Note title = entity name.

  ``` yaml
  tags:
    - person
  ```

- **Only heading children are about the entity**: Tag the heading. Heading text = entity name, tag = type.

  ``` markdown
  # Bob Dole #person
  ```

## Entity Properties

*What it does: property conventions.*

- Properties are frontmatter or inline `[name:: value]`.
- Names and types are free-form; no schema restricts them.
- Values may be wikilinks.

## Workflow for Minting & Updating Entities

*What it does: gates and steps for creating/updating entity notes.*

GUARD: Mint only when user asks. Don't infer a mint request from a classification question.
Autonomy: updates to agent-minted notes (see Writing Rules) may proceed without asking; all other updates wait for the user.

- HALT: Blank or one-line content → don't mint. A one-line update to an existing entity → update it.
- HALT: Type can't be classified with confidence → don't mint.
- Heading-based ingestion (journal heading → entity note) follows the `wiki-ingest` skill; the link format is `# [[Name]] #type`.
- Link target missing → mint note with name matching the link, or update the source link. Human source notes need user approval before any link change.
- CHK: Clicking an unresolved link in Obsidian creates an empty note. After minting, check for it; delete if it duplicates the new note.

1. **Deduplicate**: CHK: Before minting, use the find operation to look for an existing note for the same entity. Exists → update, don't duplicate.
2. **Minting**: EXEC: Start new note with short summary/description of the entity; cite claims with footnotes (see Provenance). No mandatory sections.
3. **Additive Updates**:
   - GUARD: Human-authored content stays untouched (see Writing Rules).
   - GUARD: Never copy tasks (`- [ ]` / `- [x]`) into graph nodes. Tasks stay in source notes and surface via backlinks.
   - GUARD: Never copy source content. Link to it; short quotes or summaries OK.

## Provenance

*What it does: audit trail and citations for agent-made changes.*

- **Citations**: Claims drawn from a source note carry a footnote marker in the prose (`[^1]`). Define footnotes at the bottom of the note, after `## Provenance` if present: `[^1]: "Quote from source text" — [[YYYY-MM-DD]]`. Reuse the same marker when one source backs several claims.
- **Minting**: Agent-created note → cite its claims with footnotes to the triggering notes. No `## Provenance` section needed.
- **Editing**: Agent edits a note it created → cite added claims; append the change reason and causing notes under `## Provenance`.
- **Human-Authored Notes**: Asked to change a note the agent did not create → add `## Provenance` at bottom with the reason; cite only the claims the agent added.

## Archiving

*What it does: retiring nodes.*

GUARD: Archive only when user asks.

- Retired/historical nodes get `archived: YYYY-MM-DD` in frontmatter and move to `wiki/archived/` via the rename operation.
- CHK: Moves are filesystem-level. After a move, query `wikilinks` (backlinks) on the new path to confirm links resolve.
- Agents treat archived nodes as inactive when answering about current focus or active projects.
