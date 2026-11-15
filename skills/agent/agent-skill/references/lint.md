---
name: lint
description: Validate AGENT, PROMPT, SKILLS, and references are formatted correctly and follow best practices for agent prompts. Use when user asks to lint a prompt or skill, or after editing a skill.
---

- INVARIANT[read-ref-rules]: Read [rules](references/rules.md)
- INVARIANT[read-only]: mode === "read-only" && forbid(edit, write, delete)

```makefile
# agent-lang v0.1
SHELL := false
.PHONY: report find-targets syntax frontmatter body size duplicates scripts links clarity

FILES ?=

report: find-targets $(FILES)
	Reply to the user with a unified report using `## Report Format` below.

find-targets:
	$(eval FILES :=$(resolveTarget(user.goal) -> user.mentionsSkill(s) ? allFilesIn(lookupSkillDir(s)) : user.mentionsDir(d) ? allFilesIn(d) : user.mentionsFiles(f) ? f : askClarification()))

# Run all check groups against each target file ($@ = current file)
$(FILES): syntax frontmatter body

syntax:
	exec(`uvx --offline lintlang scan $@`)

frontmatter:
	# Only enforce skill-root rules on SKILL.md (not references/*.md)
	if (basename($@) === "SKILL.md") {
		expect(basename(dirname($@))).toBe(stem($@)); // sev: must-fix
		expect(new Set(["name", "description"]).isSubsetOf(new Set(Object.keys($@.frontmatter)))).toBe(true); // sev: must-fix
		expect($@.frontmatter.description).toSpecifyWhatAndWhenWithTriggers(); // sev: should-fix
	}

body: size duplicates scripts links clarity

size:
	if (basename($@) === "SKILL.md") {
		expect(lineCount($@)).toBeLessThan(500); // sev: should-fix — move detailed guidance to references/
		if (lineCount($@) > 100) expect($@.hasTableOfContents()).toBe(true); // sev: nit
	}

duplicates:
	Flag redundant instructions or examples within and across skill files (`should-fix`); allow brief summaries or examples serving a distinct purpose.

scripts:
	Flag repeated deterministic steps that belong in `scripts/` (`should-fix`).
	Flag copied CLI/tool option lists where trusted tool help/docs can be referenced instead (`nit`).

links:
	Broken links (`must-fix`): verify all paths cited in `SKILL.md` and `references/` exist (resolve relative to containing file, or skill root if specified). Exclude illustrative examples and explicitly optional paths.
	Orphans (`should-fix`): flag any bundled file not linked anywhere in the skill as a possible orphan.
	Discoverability (`should-fix`): verify every file in `references/` and `scripts/` is linked from parent `SKILL.md` with guidance on when to read/use it (any heading/list/table format is valid).
	Purpose-fit (`nit`): operational reference files need clear actions and safety constraints; passive docs/specs/examples do not need workflow or frontmatter boilerplate.

clarity:
	Flag non-imperative phrasing like "You should run X" instead of "Run X" (`nit`).
	Flag bare all-caps ALWAYS/NEVER/MUST lacking a stated reason (`nit` or `should-fix`); allow strict wording on fragile or safety-critical steps when the reason is explained.
	Flag example-overfit rules that fail to generalize beyond one specific input (`should-fix`).
	Flag synonym drift where multiple terms refer to the same concept (`nit`).
	Flag missing exact output templates or Input/Output examples where output format matters (`should-fix`).
```

## Report Format

| # | Sev | Location | Evidence | Fix |
|---|---|---|---|---|
| 1 | should-fix | refactor.md:50-57 | empty table header and no filled row. | Add one filled example row. |

- Sev: `must-fix` (breaks spec/skill), `should-fix` (token waste/clarity), `nit` (minor polish).
- Verdict: `ship` (clean), `needs work` (correctable findings), `rewrite` (major structural rework).

## Additional Information

- [Documentation](https://github.com/hermes-labs-ai/lintlang): Troubleshooting lintlang.
