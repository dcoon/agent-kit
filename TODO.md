This is a strong, expressive blueprint—mixing Makefile dependency trees with pts and Vitest/Jest assertions makes the control flow crystal clear. However, there are several critical structural mismatches inside the makefile block (where Make syntax and pts collide) plus a few leftover abort() calls from our earlier discussion that will cause the agent to stop early or misroute rules.

1. Critical Bugs & Mismatches (High Impact on Execution)
Target Name Mismatch (find-targets vs. findtargets):
.PHONY declares find-targets (with a hyphen), report: depends on findtargets, and the rule itself is defined as findtargets: (without a hyphen). Also, orphans is listed as a prerequisite of body:, yet there is no orphans: target defined anywhere (orphan detection is buried inside links:).

Broken Make Pattern Wiring (%.md: lint vs. process):

findtargets calls $MAKE process FILES="..." (and uses $MAKE instead of $(MAKE)), but process is never defined as a target.

%.md: lint is backwards in Make syntax: in Make, target: prerequisite means %.md depends on lint, not that lint runs on every %.md file. Furthermore, lint: syntax frontmatter body is a phony target, so $@ inside syntax:, frontmatter:, and body: evaluates to "syntax", "frontmatter", and "body"—never the .md file path!

Leftover abort() Calls & Mixed Validation Paradigms:
findtargets, frontmatter, and size still call abort(...), while links and clarity use descriptive prose rules. As you noted earlier, abort() causes the agent to halt on the first error instead of collecting all findings for the ## Report Format table.

Imperative Prose Inside duplicates: and scripts::
Lines like "Remove redundant instructions..." and "Use scripts/ for deterministic..." read like refactoring/authoring instructions rather than lint checks. During a read-only lint pass, an LLM seeing "Remove redundant instructions" may attempt to rewrite files or output refactored prose instead of logging a table row.

Duplicate Read-Only Invariants:
INVARIANT[lint-safety-01] and INVARIANT[read-only] say the exact same thing in two formats, costing extra tokens. Also, INVARIANT[read-only] is missing its colon (INVARIANT[read-only]:).

Scope Over-Application (frontmatter: & size: run on all .md files):
basename(dirname($@)) === stem($@) and size($@) < 500 apply specifically to SKILL.md (or root skill files), not to files inside references/ (which legitimately have names like references/lint.md where dirname is references and stem is lint, and don't require name/description frontmatter—as your own links: rule explicitly notes!).

2. Recommended Refactor (Fixing the Wiring + Unifying on pts / Vitest)
To make Make's dependency graph and $@ target binding 100% accurate for an LLM, use a static pattern rule ($(FILES): %.md: syntax frontmatter body or lint-file) and swap abort() for expect(...) assertions that feed the ## Report Format table:

Markdown
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

# Run all check groups against each target file ($@ = current file)$(FILES): syntax frontmatter body

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
Report Format
One row per finding, with Location as a file path plus line or section (e.g. references/foo.md:12) and the problem quoted as evidence:

#	Sev	Location	Evidence	Fix
1	should-fix	refactor.md:50-57	empty table header and no filled row.	Add one filled example row.
Severity scale: must-fix (breaks the spec or the skill), should-fix (wastes tokens or hurts clarity), nit (minor polish).

End with a verdict (and wc -lc before → after only if edits were applied):

ship: no must-fix or should-fix findings.

needs work: correctable must-fix or should-fix findings.

rewrite: structural problems that need major rework.

Additional Information
Link	Use When
Documentation	Troubleshooting lintlang or looking up syntax rules.

---

### Summary of Improvements Made
1. **Fixed `$@` Scoping:** Bound `$(FILES): syntax frontmatter body` so `$@` accurately resolves to each file in `$(FILES)` instead of the phony target names.
2. **Prevented False Positives on `references/*.md`:** Guarded the directory-name, frontmatter, and 500-line checks with `if (basename($@) === "SKILL.md")` so reference docs aren't erroneously flagged for lacking `SKILL.md` frontmatter.
3. **Aligned Rules with Read-Only Reporting:** Reworded `duplicates`, `scripts`, `links`, and `clarity` from imperative edit commands ("Remove...", "Use...") to explicit `"Flag ... (sev)"` assertions, and mapped every check directly to your `must-fix` / `should-fix` / `nit` severity scale.
4. **Removed Unused `orphans` Target & Deduplicated Invariants:** Folded `orphans` cleanly under `links:` (matching `.PHONY`) and merged the two redundant read-only invariants.
