---
name: lint
description: Validate AGENT, PROMPT, SKILLS, and references are formatted correctly and follow best practices for agent prompts.  Use when user asks to lint a prompt or skill or after editing a skill.
license: MIT
metadata:
  audience: developers
  version: 1.0.0
  opencode/slash: true
  opencode/autoinvoke: false
---

Contents: [Guards](#guards) · [Workflow](#workflow) · [Checklists](#checklists) · [Report format](#report-format) · [Additional information](#additional-information).

## Guards

This invariant governs every phase of this lint workflow and any workflow it invokes:

- INVARIANT[lint-safety-01]: Never edit files during this lint workflow.

The calling skill's skill-wide invariants also apply throughout this workflow.

## Workflow

Follow `report`: complete prerequisites successfully before dependent phases; a failed prerequisite blocks its dependent. Sibling prerequisites have no implied order. Skip each phase's first recipe line, the sentinel. These recipes are agent instructions, not a runnable Makefile; never submit them to a shell. Only subsequent `@` lines would be shell commands; this workflow has none.

Before phase actions, read all invariants declared in that phase and applicable skill-wide invariants. A phase invariant governs its whole phase, including earlier lines. Check preconditions before relevant actions, maintain constraints during them, and verify postconditions afterward; do not assume postconditions in advance.

```makefile
# agent-lang v0.1
.PHONY: identify check report

report: check
	@echo "agent-lang: not a runnable script. Agent follows this recipe." >&2; exit 1
	Reply to the user with a unified report using the report format below.

check: identify
	@echo "agent-lang: not a runnable script. Agent follows this recipe." >&2; exit 1
	For directories, apply the Linter checklist.
	For SKILL.md, apply Frontmatter, Template, References, Size, and Clarity.
	For reference files or files in agents/, apply Linter, purpose-appropriate Template, Size, and Clarity; classify each file by purpose first.
	For scripts/, apply Size.
	Record findings and blocked checks for the report; they do not themselves fail this phase. If inspection cannot proceed, stop and report the blocker.

identify:
	@echo "agent-lang: not a runnable script. Agent follows this recipe." >&2; exit 1
	If a skill or SKILL.md is given, target its skill directory, SKILL.md, and all bundled files in subdirectories, including references/, scripts/, and agents/.
	If a reference file is given, target only that file.
```

## Checklists

### Linter

- Run `uvx --offline lintlang scan <path>` on the directory or filenames only when it can run without installing, downloading, or editing files. Otherwise report the blocker. If lintlang is not cached, report the blocker; any installation or download requires explicit user authorization outside this read-only lint workflow.

### Frontmatter

- For SKILL.md, YAML frontmatter is present and conforms with [template](template.md). The directory-matching name rule applies to SKILL.md, not every reference.
- `description` states what the skill does and when to use it, with concrete trigger phrases and keywords. Name and description are the metadata usually loaded up front for discovery, so keep them concise and specific enough to distinguish the skill from similar ones. Flag vague one-liners.

### Template

- Check the body against the applicable guidance in [template](template.md). Accept semantic equivalents of workflows and scoped guards or invariants, including agent-lang; literal Workflow or Guards headings and numbered lists are not required.
- Classify references by purpose. Operational instructions need clear actions and applicable safety constraints; documentation, guides, specifications, and examples do not need workflow or frontmatter boilerplate merely because they are references.

### References

- Every file in subdirectories references/ and scripts/ must be linked from the parent SKILL.md with guidance on when to read or use it. Links and guidance must be discoverable; a particular heading or table is not required.

### Size

- Keep `SKILL.md` under  500 lines, per the spec's guidance. This is a heuristic, not a requirement; judge by whether content is needed on activation.
- Simple skills may be self-contained in `SKILL.md`. Move detailed or conditional guidance to `references/` when that saves tokens on activation, and say when to read each file. 
- Files in `references/` longer than about 100 lines should start with a table of contents (Anthropic best-practice guidance).
- Use `scripts/` for deterministic, repeated work when the same steps recur across runs or must produce identical results.
- Remove redundant instructions and examples within and across skill files; retain brief summaries and examples that serve a distinct purpose.
- Prefer trusted, available tool help or documentation over copied option lists. Keep essential commands, workflow decisions, and project-specific constraints. If help is unavailable, report the limitation; do not download or install tools without authorization.
- Broken links: check that actual paths (files or directories) cited by `SKILL.md` or files in `references/` exist; resolve links relative to the file containing them, or to the skill root when explicitly specified. Report missing ones. Exclude illustrative examples and explicitly optional paths.
- Unreferenced files: a bundled file nothing in the skill points to may be an orphan. Report it as a possible orphan, since it may be used externally.
- Measure with `wc -lc`: the target plus every other text file you actually inspect in this review. 

### Clarity

- Imperative instructions ("Run X", not "You should run X").
- Explains why instead of bare absolutes. Flag unjustified all-caps ALWAYS/NEVER/MUST (`nit` or `should-fix`) and rewrite with reasoning. Keep strict wording for fragile or safety-critical steps when the reason is stated; softening it there risks real harm.
- General rules, not example-overfit; instructions make sense beyond the one input the author had.
- One term per concept; no synonym drift.
- Exact output templates where format matters; examples in Input/Output form.

## Report format

One row per finding, with `Location` as a file path plus line or section (e.g. `references/foo.md:12`) and the problem quoted as evidence:

| #   | Sev        | Location          | Evidence                              | Fix                         |
| --- | ---------- | ----------------- | ------------------------------------- | --------------------------- |
| 1   | should-fix | refactor.md:50-57 | empty table header and no filled row. | Add one filled example row, |

Severity scale: `must-fix` (breaks the spec or the skill), `should-fix` (wastes tokens or hurts clarity), `nit` (minor polish).

End with a verdict and, when edits were applied, `wc -lc` before → after:

- `ship`: no `must-fix` or `should-fix` findings.
- `needs work`: correctable `must-fix` or `should-fix` findings.
- `rewrite`: structural problems that need major rework.

## Additional Information


| Link                                                        | Use When                                                 |
| ----------------------------------------------------------- | -------------------------------------------------------- |
| [Documentation](https://github.com/hermes-labs-ai/lintlang) | Troubleshooting lintlang tool or need more information . |
