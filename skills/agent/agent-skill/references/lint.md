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

## Workflow

1. Identify targets
	1. If skill or SKILL.md given, targets are directory containing the skill, its SKILL.md, and all bundled files in subdirs including references/, scripts/, agents/, etc.
	2. If reference file given, target is just that file
2. For each target, run the following checklists:
	1. directory -> linter
	2. SKILL.md -> frontmatter, template, references, size, clarity 
	3. references/ or agents/ -> linter, template, size, clarity
	4. scripts/ -> size
3. Reply findings to user as unified report 

## Guards

1. Never edit files. 

## Checklists

### Linter

1. Exec `uvx --offline lintlang scan <path>` on the dir or filenames to be linted. If it fails because lintlang is not cached, report the blocker; do not download or install without explicit user authorization.

### Frontmatter

- YAML frontmatter is present and conforms with [template](template.md).
- `description` states what the skill does and when to use it, with concrete trigger phrases and keywords. Name and description are the metadata usually loaded up front for discovery, so keep them concise and specific enough to distinguish the skill from similar ones. Flag vague one-liners.

### Template

- Body conforms with [template](template.md).  Mandatory (not tagged #optional in template) must be present.

### References

- Every file in subdirs references/ and scripts/ must be linked to in parent SKILL.md file under section References.
### Size

- Keep `SKILL.md` under  500 lines, per the spec's guidance. This is a heuristic, not a requirement; judge by whether content is needed on activation.
- Simple skills may be self-contained in `SKILL.md`. Move detailed or conditional guidance to `references/` when that saves tokens on activation, and say when to read each file. 
- Files in `references/` longer than about 100 lines should start with a table of contents (Anthropic best-practice guidance).
- Use `scripts/` for deterministic, repeated work when the same steps recur across runs or must produce identical results.
- Remove redundant instructions and examples within and across skill files; retain brief summaries and examples that serve a distinct purpose.
- Prefer trusted, available tool help or documentation over copied option lists. Keep essential commands, workflow decisions, and project-specific constraints. If help is unavailable, report the limitation; do not download or install tools without authorization.
- Broken links: check that actual paths (files or directories) cited by `SKILL.md` or files in `references/` exist relative to the skill root; report missing ones. Exclude illustrative examples and explicitly optional paths.
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
