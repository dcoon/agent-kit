---
name: agent-skill
description: Create, find, install, lint, refactor, and compress agent skills and SKILL.md files. Use when the user asks to create, find, install, review, or improve agent skills or a SKILL.md.
license: MIT
metadata:
  audience: developers
  version: 1.0.0
  opencode/slash: true
  opencode/autoinvoke: false
---

## Skill-wide invariants

These invariants apply throughout every phase and any referenced workflow.

- INVARIANT[consent-01]: Edits occur only after user.explicitlyConsents(edits).
- INVARIANT[tools-01]: Downloading or installing executable tools or packages requires authorization before the action.
- INVARIANT[reference-metadata-01]: Preserve reference-file metadata (frontmatter) unless its change is explicitly requested or authorized.
- INVARIANT[format-01]: When authoring or refactoring agent instructions, use agent-lang unless the user explicitly requests a different format (such as prose) or identifies humans as the primary audience.

A request for human readability alone does not select prose. Apply the selected format throughout the task and referenced workflows.

## Workflow

Agent instructions, not a runnable Makefile: never submit this block to a shell. Follow `apply`; complete each prerequisite successfully before its dependent recipe. Skip each recipe's first line (the safety sentinel). No subsequent line is a shell command.

Check preconditions before the relevant action, preserve ongoing constraints during it, and verify postconditions afterward; obey explicit timing within each invariant. Predicates describe required evidence, not executable APIs. Resolve each `SLOT` to an available skill or tool using caller context; retain normal permissions and confirmations, and ask if no safe suitable provider exists or the choice materially affects the outcome. Reference links supply task details; routing and edit safeguards are defined here.

```makefile
# agent-lang v0.1
.PHONY: route findings apply

route:
	@echo "agent-lang: not a runnable script. Agent follows this recipe." >&2; exit 1
	Select the appropriate reference below using its Use When criteria, then follow its workflow under the skill-wide invariants.

findings: route
	@echo "agent-lang: not a runnable script. Agent follows this recipe." >&2; exit 1
	Report concise numbered findings.

apply: findings
	@echo "agent-lang: not a runnable script. Agent follows this recipe." >&2; exit 1
	INVARIANT[editing-01]: each target has a pre-edit snapshot before its first edit.
	INVARIANT[editing-02]: if a target changes concurrently, stop and ask before reconciling.
	If editing is not authorized, finish with the findings and no edits; do not continue this recipe.
	SLOT[snapshot]: Use an available tool to snapshot each target file before editing it.
	Apply only approved changes in one coherent pass.
```

## References

Paths are relative to this skill's root directory.

| Reference                                  | Use When                                                                                                                                                                                                                                               |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [npx-skills](references/npx-skills.md)     | The user asks to find, install, update, or remove agent skills, mentions npx skills or skills.sh, asks where skills are stored, or asks to add or remove skill entries in an agents package.json manifest.                                           |
| [lint](references/lint.md)                 | The user asks to lint or check a skill, prompt, or SKILL.md, or after editing a skill.                                                                                                                                                                |
| [refactor](references/refactor.md)         | The user asks to clean up, optimize, or fix an existing skill, or says a skill is too slow or too expensive. Runs lint first, then recommends fixes.                                                                                                  |
| [compress](references/compress.md)         | The user asks to shrink, compress, or token-optimize a verbose SKILL.md or Markdown prompt into dense, agent-focused prose.                                                                                                                          |
| [template](references/template.md)         | The user asks to create a skill or SKILL.md, or needs the agent skills specification or frontmatter and section rules.                                                                                                                               |
