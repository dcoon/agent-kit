---
name: npx-skills
description: "Commands and structural protocols for discovering, installing, and maintaining reusable agent skills using the Open Skills CLI (npx skills). Use when: the user asks to find, install, update, or remove agent skills, mentions npx skills or skills.sh, asks where skills are stored, or asks to add or remove skill entries in an agents package.json manifest."
---

# NPX Skills Management

## Skill-wide rules

Rules in this reference govern route and the caller's approved apply; higher-priority permissions prevail. Read-only discovery does not require edit authorization.

- INVARIANT[consent-01]: Explicit consent is required separately before an `npx` package download and before each install, update, remove, or sync; confirm before sync. Download consent does not authorize skill operations. Ask before installing the CLI. Project scope is default; use global scope or a specific agent target only on request.
- Before using CLI flags, check version-matching `add` and `experimental_sync` help on a trusted installed CLI. If subcommand help shows only global help, use matching-version docs; use [upstream main docs](https://github.com/vercel-labs/skills/blob/main/docs/commands.md) only as a fallback and report flags unverified if matching-version evidence is unavailable. Verify CLI selector syntax; `@` in CLI examples is ambiguous. Select named skills unless the source has exactly one.
- `experimental_sync` handles manifest `skills` and already-installed npm dependencies; it can fetch git sources and remove unlisted synced skills, but does not install npm dependencies. `experimental_install` restores a lockfile and is not a sync prerequisite. Do not commit unless asked.
- INVARIANT[manifest-03]: Immediately after each manifest edit, parse JSON and verify unrelated fields and entries remain unchanged, including in the target project's manifest, even if no sync occurs. Before any sync, verify JSON parses.

For `agents/*/package.json` and `global/package.json`:

- Ask which target if multiple manifests exist and the request does not name a mode. Add or remove only requested entries; preserve unrelated entries and fields.
- INVARIANT[manifest-01]: Before add, `upstream.has(skill) && source.countVerified && (source.skillCount === 1 || entry.selects(skill))`. These predicates express evidence, not APIs: verify the exact skill and source count upstream without installing (e.g. `add --list`, after checking flags); reuse adequate prior verification or stop if unavailable. `entry.selects(skill)` means a flat `owner/repo@skill-name` entry selecting that skill.
- INVARIANT[manifest-02]: Before each edit or batch, `proposedManifest.skills.length <= 5`; if exceeded, stop and ask. The cap applies to each mode and `global/package.json`.
- To apply mode skills, copy the mode's `skills` array into the target project's `package.json`, run `experimental_sync` after confirmation, and include the updated lockfile as the project requires.

## Discovery and structure

Before installing, check existing placements (e.g. `~/.agents/skills/`). After installing, locate the skill using `list` or directory inspection and verify OpenCode discovery against the version's discovery and permission docs ([V2](https://opencode.ai/v2/docs/skills)). CLI `list` does not prove OpenCode advertises the skill; do not assume a project path has a global equivalent.

For portable `SKILL.md`, write YAML frontmatter with `name` and `description`. OpenCode V2 makes frontmatter optional, but needs `description` to advertise the skill to the model. Before running any skill script, obey actual permissions; do not assume a prompt will appear.

## Workflow

During the caller's `route`, follow `manage` and return findings and an ordered plan. The caller reports findings, then applies approved work once under its snapshot and concurrent-change guards.

Agent instructions, not a runnable Makefile: never submit the block to a shell; skip the sentinel.

```makefile
# agent-lang v0.1
.PHONY: manage

manage:
	@echo "agent-lang: not a runnable script. Agent follows this recipe." >&2; exit 1
	INVARIANT[route-01]: Route makes no project or skill-file edits and does not install, update, remove, or sync skills.
	Inspect the request. If the CLI is needed, check its version-specific Node requirement (help or package.json) against node --version before use. If the CLI or requirement is unavailable, report the blocker and ask how to proceed; do not use the CLI until its requirement is verified.
	Perform permitted read-only find, list, and discovery during route, including upstream verification needed for a proposed add. If discovery needs unavailable capability or consent, report the blocker and ask for authorization; wait before the blocked action, but continue other permitted discovery without deferring it to apply.
	Return findings and an ordered plan for the requested work, including applicable skill-wide rules and discovery postconditions.
```
