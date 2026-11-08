
## Workflow

1. Always follow Conventions section when writing content
2. Write with concise, clear prose without adornments.
3. Assume changes were applied correctly; do not check or verify writes.
## Guards

1. Never overwrite/remove human-authored content unless user explicitly asks.
2. Retrieve minimal content using search and query tools
3. Make minimal changes using patch and append like tools
4. Agent created content (creation recorded in `## Provenance`) may be updated without asking; append Provenance per the rules below.
5. If unsure where to put content, default to today's Journal Entry.

## Conventions 
### Structure

1. root
	1. journal - user daily journal notes named `DATE`.md
	2. projects - top level folders contain projects
	3. wiki - agent maintained content ; ok to read/write
		1. graph - agent created notes with summaries of user content in shape of Karpathy LLM wiki.
	4. all other folders and notes - random user authored content.

### Assets

1. Store assets (non markdown files. ie. images, PDFs, etc) next to the note that imported/created it. 
2. Never copy assets; link to them.
### Dates

- Use ISO 8601 (`YYYY-MM-DD`) in notes, filenames, frontmatter, task metadata.


### Tasks

1. Never copy or duplicate tasks. Use Obsidian Task query to list them or link to individual tasks.
2. Task dates use Dataview inline fields: `[due:: YYYY-MM-DD]`, `[scheduled:: YYYY-MM-DD]`, `[completed:: YYYY-MM-DD]`.

### Links

- Internal links use `[[Note Name]]` wikilinks.
- External links use markdown `[text](url)`.

### Entities

Typed objects within the notebook. 
#### Types

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

#### Properties

- Properties are frontmatter or inline `[name:: value]`.
- Names and types are free-form; no schema restricts them.
- Values may be wikilinks.

### Audit

- **Citations**: Claims drawn from a source note carry a footnote marker in the prose (`[^1]`). Define footnotes at the bottom of the note, after `## Provenance` if present: `[^1]: "Quote from source text" — [[YYYY-MM-DD]]`. Reuse the same marker when one source backs several claims.
- **Minting**: Agent-created note → cite its claims with footnotes to the triggering notes. No `## Provenance` section needed.
- **Editing**: Agent edits a note it created → cite added claims; append the change reason and causing notes under `## Provenance`.
- **Human-Authored Notes**: Asked to change a note the agent did not create → add `## Provenance` at bottom with the reason; cite only the claims the agent added.

### Archiving

GUARD: Archive only when user asks.

- Retired/historical nodes get `archived: YYYY-MM-DD` in frontmatter and move to `wiki/archived/` via the rename operation.
- CHK: Moves are filesystem-level. After a move, query `wikilinks` (backlinks) on the new path to confirm links resolve.
- Agents treat archived nodes as inactive when answering about current focus or active projects.



### Journal Entry

Trigger: user says "record this in the journal for [note]" or "write this down".

- EXEC: Write to today's daily note (`journal/YYYY-MM-DD`) via `periodic` (daily).
- 
- EXEC: Upsert top-level heading `# [[Exact Note Name]]` for the source note. Exists → append under it. Else → add at end.
- Record discoveries and decisions as dated summaries (bullets or subheadings as fits).
- GUARD: Write only when user asks.
- CHK: User names source note exactly. No name → ask.
- User says "I don't know," "doesn't matter," or "just today" → use `# Today`.
- "The note we're working on" = note from current conversation. Unclear → ask.