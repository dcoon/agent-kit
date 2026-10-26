---
name: skill-reviewer
description: "Review existing skills for token efficiency, agent clarity, and correct frontmatter, then optimize them. Use when: the user asks to review, audit, lint, critique, or improve a skill or SKILL.md file, says a skill wastes tokens or triggers unreliably, or right after scaffolding a new skill. For creating skills from scratch use skill-creator instead — this reviews and optimizes what exists."
---

# Skill Reviewer

Audit an existing skill against the practices from Anthropic's skill-creator: frontmatter correctness, token efficiency via progressive disclosure, and agent clarity. Read-only by default; propose fixes, apply only on request.

## Process

1. Locate the target: user gives a skill name or path. Read `SKILL.md` fully and list bundled files (`scripts/`, `references/`, `assets/`).
2. Measure: `wc -c` and `wc -l` on SKILL.md and every bundled file. Sizes drive the token checks.
3. Run the three checklists. Each item gets pass, warn, or fail.
4. Report findings (template below). Verify claimed problems by quoting the file — never report from memory.
5. Apply edits only with explicit consent. After editing, re-measure and report bytes before → after.

## Frontmatter checks

- YAML frontmatter present and parses; contains `name` and `description`.
- `name` equals the directory name; lowercase, hyphenated.
- `description` states both what the skill does AND when to use it, with concrete trigger phrases ("Use when: ..."). All trigger info lives in the description — it is the only part always in context; body content cannot trigger the skill.
- Description is specific enough to win against competing skills and pushy enough to avoid undertriggering. Vague one-liners fail.
- Trigger phrasing targets tasks complex enough to need a skill — simple one-step queries do not trigger skills regardless of description quality.
- `compatibility` appears only when the skill needs unusual tools or dependencies.

## Token checks

- SKILL.md body under 500 lines. Warn when approaching; must-fix well beyond.
- The body is an overview plus pointers. Detail lives in `references/` (loaded on demand, with when-to-read guidance per file); repeated deterministic work lives in `scripts/` (run without loading).
- Reference files over 300 lines include a table of contents.
- No duplicated instructions or examples; one example per pattern.
- No orphan files: every referenced path exists and is relative to the skill directory.
- Name + description stay near 100 words — that is the always-billed metadata cost.

## Clarity checks

- Imperative instructions ("Run X", not "You should run X").
- Explains why instead of all-caps ALWAYS/NEVER/MUST — flag every instance as a yellow flag and rewrite with reasoning.
- General rules, not example-overfit; instructions make sense beyond the one input the author had.
- One term per concept; no synonym drift.
- Exact output templates where format matters; examples in Input/Output form.

## Report format

One row per finding:

| Sev | Location | Problem | Fix |
|---|---|---|---|

Severity: must-fix, should-fix, nit. End with a verdict: ship, needs work, or rewrite — plus byte counts before → after when edits were applied.

## Boundaries

- Read-only unless the user consents to edits.
- Never change a skill's `name` or directory — other config references it.
- Check bundled scripts only for existence and correct referencing; do not review their logic here.
- Creating a skill from scratch is skill-creator's job; this skill reviews and optimizes what exists.