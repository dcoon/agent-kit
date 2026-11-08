---
name: refactor
author: https://github.com/dcoon/agent-kit
description: Review and optimize an existing or newly scaffolded skill for token efficiency, agent clarity, and correct frontmatter. Use when asked to clean up, optimize, or fix a skill. Or when user states skill is too slow or too expensive.
---

# Refactor

## Guards

- Never change a skill's `name` or directory.
## Workflow

1. Locate the target: user gives a skill name or path. Scope the review by target:
	- Skill or `SKILL.md`: process `SKILL.md`, the bundled files (typically under `scripts/`, `references/`, `assets/`), and dir structure.
	- Single reference file: Process the Inspect the parent `SKILL.md` or other files only when needed and the user's scope permits.
2. Run the checklists that apply to the target. 
	1. SKILL.md -> lint ; size ; frontmatter ; template ; references  ; clarity 
	2. reference/ -> lint ; size ;  template ; clarity
	3. script/ -> size
3. Report findings. Quote the file as evidence.
4. Recommend fixes and ask for approval; apply edits only when the user has explicitly authorized editing. 

## Checklists
### Frontmatter

Tags: `[spec]` is a hard Agent Skills requirement; a violation is `must-fix`. `[guidance]` is a recommendation; a miss is `should-fix` or `nit`, and `must-fix` only if it breaks the skill (e.g. a description too vague for discovery).

- YAML frontmatter is present and conforms with [[template]].
- `description` states what the skill does and when to use it, with concrete trigger phrases and keywords. Name and description are the metadata usually loaded up front for discovery, so keep them concise and specific enough to distinguish the skill from similar ones. Flag vague one-liners.

### Template

- Body conforms with [[template]].  Mandatory (not tagged #optional in template) must be present.

### References

- Every file in subdirs references/ and scripts/ must be linked to in parent SKILL.md file under section References.
### Size

- Keep `SKILL.md` under  500 lines, per the spec's guidance. This is a heuristic, not a requirement; judge by whether content is needed on activation.
- Simple skills may be self-contained in `SKILL.md`. Move detailed or conditional guidance to `references/` when that saves tokens on activation, and say when to read each file. Use `scripts/` for deterministic, repeated work when the same steps recur across runs or must produce identical results.
- Files in `references/` longer than about 100 lines should start with a table of contents (Anthropic best-practice guidance).
- Remove redundant instructions and examples within and across skill files; retain brief summaries and examples that serve a distinct purpose.
- Prefer trusted, available tool help or documentation over copied option lists. Keep essential commands, workflow decisions, and project-specific constraints. If help is unavailable, report the limitation; do not download or install tools without authorization.
- Broken links: check that actual paths (files or directories) cited by `SKILL.md` or files in `references/` exist relative to the skill root; report missing ones. Exclude illustrative examples and explicitly optional paths.
- Unreferenced files: a bundled file nothing in the skill points to may be an orphan. Report it as a possible orphan, since it may be used externally.
- Measure with `wc -lc`: the target plus every other text file you actually inspect in this review. Skip binary assets. Bytes approximate size; they are not tokens.


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
