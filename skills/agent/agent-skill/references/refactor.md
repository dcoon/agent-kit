---
name: refactor
repo: https://github.com/dcoon/agent-kit
---

# Refactor

Review and optimize an existing or newly scaffolded skill for token efficiency, agent clarity, and correct frontmatter.

## Guardrails

- Never change a skill's `name` or directory; renaming can break existing links or installed skill identifiers.
- Check bundled scripts only for existence and correct referencing; do not review their logic here.

## Process

1. Locate the target: the user gives a skill name or path. Scope the review by target:
   - Skill or `SKILL.md`: read `SKILL.md` fully and list the bundled files (typically under `scripts/`, `references/`, `assets/`).
   - Single reference file: read it fully. Inspect the parent `SKILL.md` or other files only when needed and the user's scope permits.
2. Measure with `wc -lc`: the target plus every other text file you actually inspect in this review. Skip binary assets. Bytes approximate size; they are not tokens.
3. Run the checklists that apply to the target. The SKILL.md-specific frontmatter requirements below apply only to an actual skill `SKILL.md`, not to reference files. Reference file YAML may still be checked for correctness when requested.
4. Report findings (template below). Quote the file as evidence; never rely on memory, since the file may have changed.
5. Report or propose edits only; apply them when the user has explicitly authorized editing. After editing, re-measure and report before → after.

## Frontmatter checks

Tags: `[spec]` is a hard Agent Skills requirement; a violation is `must-fix`. `[guidance]` is a recommendation; a miss is `should-fix` or `nit`, and `must-fix` only if it breaks the skill (e.g. a description too vague for discovery).

- `[spec]` YAML frontmatter is present and parses, with required `name` and `description`.
- `[spec]` `name`: 1–64 characters; lowercase letters, numbers, and hyphens only; no leading, trailing, or consecutive hyphens; matches the directory name.
- `[spec]` `description`: 1–1024 characters.
- `[guidance]` `description` states what the skill does and when to use it, with concrete trigger phrases and keywords. Name and description are the metadata usually loaded up front for discovery, so keep them concise and specific enough to distinguish the skill from similar ones. Flag vague one-liners.
- `[spec]` `compatibility` is optional; if present, it is 1–500 characters.
- `[guidance]` `compatibility`, if present, describes specific environment requirements (intended product, system packages, network access).

## Token checks

- Keep `SKILL.md` under about 500 lines, per the spec's guidance. This is a heuristic, not a requirement; judge by whether content is needed on activation.
- Simple skills may be self-contained in `SKILL.md`. Move detailed or conditional guidance to `references/` when that saves tokens on activation, and say when to read each file. Use `scripts/` for deterministic, repeated work when appropriate.
- Files in `references/` longer than about 100 lines should start with a table of contents (Anthropic best-practice guidance).
- Remove redundant instructions and examples within and across skill files; retain brief summaries and examples that serve a distinct purpose.
- Prefer trusted, available tool help or documentation over copied option lists. Keep essential commands, workflow decisions, and project-specific constraints. If help is unavailable, report the limitation; do not download or install tools without authorization.
- Broken links: check that actual paths (files or directories) cited by `SKILL.md` or files in `references/` exist relative to the skill root; report missing ones. Exclude illustrative examples and explicitly optional paths.
- Unreferenced files: a bundled file nothing in the skill points to may be an orphan. Report it as a possible orphan, since it may be used externally.

## Clarity checks

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
