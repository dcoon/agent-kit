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

## Guards

1. Read-only until the user explicitly consents to edits.
2. Do not download or install executable tools or packages without authorization.
3. Preserve reference-file metadata (frontmatter) by default. Change it only when explicitly requested or authorized.

## Workflow

1. Identify the appropriate reference file based on its `Use When` criteria, then execute its workflow.
2. Report concise numbered findings.
3. If editing is authorized, apply approved changes in one coherent pass.
	1. Snapshot each target file before editing. If a target changes concurrently, stop and ask before reconciling.

## References

Paths are relative to this skill's root directory.

| Reference                                  | Use When                                                                                                                                                                                                                                               |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [npx-skills](references/npx-skills.md)     | The user asks to find, install, update, or remove agent skills, mentions npx skills or skills.sh, asks where skills are stored, or asks to add or remove skill entries in an agents package.json manifest.                                           |
| [lint](references/lint.md)                 | The user asks to lint or check a skill, prompt, or SKILL.md, or after editing a skill.                                                                                                                                                                |
| [refactor](references/refactor.md)         | The user asks to clean up, optimize, or fix an existing skill, or says a skill is too slow or too expensive. Runs lint first, then recommends fixes.                                                                                                  |
| [compress](references/compress.md)         | The user asks to shrink, compress, or token-optimize a verbose SKILL.md or Markdown prompt into dense, agent-focused prose.                                                                                                                          |
| [template](references/template.md)         | The user asks to create a skill or SKILL.md, or needs the agent skills specification or frontmatter and section rules.                                                                                                                               |
