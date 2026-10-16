---
name: wiki-ingest
description: Ingest tagged entity headings from journal entries into the wiki. Load when the user names a journal entry or says "journal" or "journal entry", or asks to scan journal entries modified in the last N days (default 7) for entities. Looks for headings with a wiki link and a type tag (e.g. "# [[Name]] #project"), then upserts the linked note with information from beneath the heading. Writes via iwe-mcp.
---

# Wiki Ingest

## Purpose
Turn tagged entity headings in journal entries into up-to-date entity notes. The heading is the backlink; the content beneath it is the new information.

## Scope
- "Journal" or "journal entry" = `journal/YYYY-MM-DD` notes (e.g. [[2026-10-15]]).
- Entry points:
  1. **Named entry:** the journal note the user mentions, or the one currently open.
  2. **Scan N days:** all `journal/` notes modified in the last N days (default 7), via `iwe_query` with a date filter and a title/modified projection. Never scan the whole vault.

## Guards
- Load `iwe-mcp` for vault reads and `wiki-schema` before any write (AGENTS.md). Follow its naming, typing, provenance, and archive rules.
- Write only when the user asks.
- Never copy tasks (`- [ ]` / `- [x]`) into entity notes. Tasks stay in the journal and surface via backlinks.
- Never copy assets (images, attachments). Link to them instead.
- Never copy verbatim. Understand the new information and update the right section or frontmatter.
- Target notes have no H1 title. The filename is the title, so never add a `# Title` heading when creating a note.
- Never overwrite or delete human-authored content unless the user explicitly asks.

## Heading qualification
A heading is processed only if it has both of these, at any heading level:
1. A wiki link as the heading text, e.g. `# [[Name]]` or `# [[target|Alias]]`.
2. Content beneath it (up to the next heading of the same or higher level) that is not only tasks.

The type tag (e.g. `#project`, `#person`, `#asset`, `#idea`) is optional:
- New entity: the tag is the type hint. No tag and no existing note → ask the user for the type before creating.
- Existing entity: the tag may be omitted. Use the existing note's type.

Skip silently any heading with no link or no content beneath. These are backlink-only.

## Target location
- `#project` → `projects/<Name>.md`.
- All other types → `wiki/graph/<Name>.md`.
- Existing notes are updated wherever they already live. Use this location only for new notes.

## Existing targets

- Frontmatter and tags may be added or updated.
- If the note has no Summary section, prepend one: a short description of the entity, written from the note's content.
- Never erase or rewrite human content.

## Procedure
1. **Qualify** each heading as above. Record the link target, type tag, and the content beneath it, minus tasks.
2. **Type check:** if the tag doesn't match the type the content implies (e.g. `#person` on a project plan), ask the user before proceeding. Do not guess.
3. **Find target:** `iwe_find` the link target. Exists → update. Missing → create with the link name as the title, following wiki-schema naming and the location rule above. Add tags:
   - Entity type tag (e.g. `#project`, `#person`), matching the heading tag.
   - Keyword tags where they fit the content (e.g. a project about a home lab gets `#homelab`). Reuse existing tags found via wiki-schema's tag search before creating new ones.
4. **Map the information:**
   - Attributes and state (status, archived, phone, email, address, dates) → frontmatter. Use inline `[name:: value]` fields only for non-state attributes, like `[husband:: Mike]`. Example: "archive this project" → `archived: YYYY-MM-DD` in frontmatter. Move to `wiki/archived/` only if the user asks.
   - Narrative, decisions, and context → the matching section, or a new section if none fits. Add sections as needed.
   - If the target exists or has human content, never erase or rewrite it. Only add. Frontmatter updates are allowed.
   - Skip anything already present in the target.
5. **Provenance:** append the reason and a citation under `## Provenance`, e.g. `"Invited us for dinner on or around Oct 24" — [[2026-10-15]]`.
6. **Confirm:** present proposed changes as a list (note → change) before applying, unless the user asked to apply directly.

## Brain Dump list

When a journal heading links to `[[Brain Dump]]`:

- Use only the top-level bullets of that section. Ignore child bullets.
- Maintain a table at the top of `pages/Brain Dump` with two columns: `Item` and `Latest`. `Latest` is a link to the journal note being processed, e.g. `[[2026-10-05]]`.
- Put a blank line before the table.
- New items go at the top of the table, linked to the current journal note.
- An item already in the table (case-insensitive match) gets its `Latest` link updated and moves to the top.
- Don't remove or rewrite existing human content. The user reviews and deletes it.

## Facts vs. research

Journal content under an entity heading is often long background or research. It is already linked to the entity through its backlink, so don't copy it.

- **Facts and intent** → update the target. Examples: "license: foobar", "phone number is 415-290-2054", "update status to done", "archive this project". Put the fact in frontmatter or an inline field, or in the matching section. Replace the old value when the new one is explicit.
- **Research and background** → add a short, terse summary under a section such as `## Research` or `## Notes`, and cite the source journal note in its provenance line. Keep it to a few bullets. Don't reproduce the research.
- **Mixed content** → apply both rules. Update the facts. Summarize the research.

Example: the "Mindstream phase1" and "Super Minimal Architecture" text under `# [[PKMS]]` on `2026-10-12` is research. It becomes a short summary plus a citation to `[[2026-10-12]]`. A new fact in the same block would still be recorded.

## Example
Input (journal `2026-10-15`):
```
# [[Lisa - Martin Lane Neighbor]] #person
- Invited us for dinner on or around Oct 24.
	- [ ] Check with angela and rsvp 📅 2026-10-16
```
Output (proposed): add to `wiki/graph/Lisa - Martin Lane Neighbor.md` under Notes: "Invited us for dinner on or around Oct 24", with provenance `[[2026-10-15]]`. The RSVP task is skipped.

Input: "Lisa Martin's phone number is 415-290-2054" under `# [[Lisa - Martin Lane Neighbor]] #person`
Output (proposed): set `phone: 415-290-2054` in frontmatter, replacing any previous value, and note the change under Provenance.
