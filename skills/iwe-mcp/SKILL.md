---
name: iwe-mcp
description: Use IWE MCP tools for all vault reads, searches, and writes, and query and move notes safely.
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: iwe-vault-access
  opencode/slash: true
  opencode/autoinvoke: false
---

# IWE Query Skill

## 1. Vault Access

- Use IWE MCP tools for all vault reads, searches, and writes.
- Never use `grep`, `find`, `ls`, `dir`, `cat`, or scripts on vault files.
- To look up blocks, use `iwe_query` projecting `$blocks`.

## 2. Discovery

- Always use a projection mapping and a bounded `limit` (5–10). Never run an open-ended search.

- `iwe_query` (`find`):

  ``` yaml
  filter:
    $content:
      $contains:
        $text: "#person"
  project:
    key: $key
    title: $title
  limit: 10
  ```

- `iwe_find` takes `project` as a string, e.g. `"$key,$title"`.

- Use `iwe_retrieve` with 1–3 known keys for full content and references.

## 2b. Link Resolution

- Never guess a path. A wiki link names a note, not its folder.
- To resolve targets from a page, use `iwe_retrieve` with `expand: { references: 1 }` on the source key. `references` returns each outbound link with its resolved key.
- A link missing from `references` is unresolved. Check it before treating it as a new note.
- Do not use `fuzzy` search to resolve a link. Fuzzy search ranks by title similarity and can bury the right note under same-named journal entries.
- If `references` has no match, run an exact title lookup with `iwe_query`, filtered on `$title`, and report the results.
- If more than one note matches, ask the user. Don't pick one.
- Report "not found" only after both steps.

## 3. Known Quirks

- `project` in `iwe_query` must be a mapping. In `iwe_find` it must be a string.
- `$matches` takes a regex. Escape `!` and `[`. `$contains` takes plain text.
- IWE may rewrite wikilink embeds (`![[file.png]]`) into Markdown form. Check raw files to find embeds.
- IWE lags behind files changed outside IWE (by Obsidian, the file system, or the user). Renames, moves, and new notes may not appear until it polls. Check again before acting on a "not found" or creating a duplicate. Possible future fix: a PR to IWE for file-watch updates.
- Text search matches mentions as well as tags. Review results before reusing a tag.

## 4. Moving Notes

- Move notes with `iwe_rename`, not by copying or recreating them. IWE updates backlinks across the vault.
- Check for duplicates before moving to a new location.

## 5. Tool Reference

Operators, `expect` guards, and other syntax are in the IWE server's tool descriptions. Read them there.

## Batch Operations

- Retrieve candidate notes in parallel with `iwe_retrieve`, then transform them in memory.
- Run mutations in small concurrent chunks (5–10) with `Promise.all`. Avoid long sequential loops.
- Return a lean status array (`{ key, status }`), not document bodies.
