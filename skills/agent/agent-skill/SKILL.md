---
name: agent-skill
description: Create, find, install, lint, refactor, and compress agent skills and SKILL.md files. Use when the user asks to create, find, install, review, or improve agent skills or a SKILL.md.
license: MIT
metadata:
  audience: developers
  workflow: prompt-optimization
  version: 1.0.0
  triggers: optimize skill, compress markdown prompt, token optimization
  requirements: "input_file: *.md"
  cache: true
  opencode/slash: true
  opencode/autoinvoke: false
---

# Guardrails

1. Read-only until the user explicitly consents to edits.
2. Do not download or install executable tools or packages without authorization.
3. Preserve reference-file metadata (frontmatter) by default. Change it only when explicitly requested or authorized.
# Workflow
 
1. Identify appropriate reference file based on `Use When` criteria then execute its workflow
2. Report concise numbered findings. 
3. If editing is authorized, apply approved changes in one coherent pass.
	1. Snapshot each target file before editing. If a target changes concurrently, stop and ask before reconciling.

# References

Paths are relative to this skill's root directory.

| Reference                                   | Use When                                                                                                                                                                                                                                                                                                                                                          |
| ------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [[npx-skills]] (`references/npx-skills.md`) | Commands and structural protocols for discovering, installing, and maintaining reusable agent skills using the Open Skills CLI (npx skills). Use when: the user asks to find, install, update, or remove agent skills, mentions npx skills or skills.sh, asks where skills are stored, or asks to add or remove skill entries in an agents package.json manifest. |
| [[lint]] (`references/lint.md`)             | Verify that a skill directory or SKILL.md file is formatted correctly. Use when asked to lint or check a skill.                                                                                                                                                                                                                                                   |
| [[refactor]] (`references/refactor.md`)     | User asks to review, audit, lint, critique, or improve an existing skill or SKILL.md file, says a skill wastes tokens or triggers unreliably, or right after scaffolding a new skill.                                                                                                                                                                             |
| [[compress]] (`references/compress.md`)     | Shrink a SKILL.md using dense, agent-focused prose                                                                                                                                                                                                                                                                                                                |
| [[template]] (`references/template.md`)     | Understand the agent skills specification or bootstrap a skill directory or SKILL.md                                                                                                                                                                                                                                                                              |
