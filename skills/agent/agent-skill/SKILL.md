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

- Read-only until the user explicitly consents to edits.
- Preserve reference-file metadata (frontmatter) by default, since Obsidian or other tooling may depend on it. Change it only when explicitly requested or authorized.

# Workflow

1. Before editing, verify task-relevant facts against repo conventions and, when those do not resolve them, trusted version-matched help or docs. Resolve conflicts or report what remains unverified. Do not download or install executable tools or packages without authorization.
2. Report concise numbered findings. Once editing is authorized, apply approved changes in one coherent pass.
3. Snapshot each target file before editing. If a target changes concurrently, stop and ask before reconciling.
4. After editing, read back each file and compare it with the snapshot for unexpected changes. Report unexplained differences without assuming who caused them; ask before reconciling concurrent edits.

# References

Paths are relative to this skill's root directory.

| Reference                                   | Use When                                                                                                                                                                                                                                                                                                                                                          |
| ------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [[npx-skills]] (`references/npx-skills.md`) | Commands and structural protocols for discovering, installing, and maintaining reusable agent skills using the Open Skills CLI (npx skills). Use when: the user asks to find, install, update, or remove agent skills, mentions npx skills or skills.sh, asks where skills are stored, or asks to add or remove skill entries in an agents package.json manifest. |
| [[lint]] (`references/lint.md`)             | Verify that a skill directory or SKILL.md file is formatted correctly                                                                                                                                                                                                                                                                                             |
| [[refactor]] (`references/refactor.md`)     | User asks to review, audit, lint, critique, or improve an existing skill or SKILL.md file, says a skill wastes tokens or triggers unreliably, or right after scaffolding a new skill.                                                                                                                                                                             |
| [[compress]] (`references/compress.md`)     | Shrink a SKILL.md using dense, agent-focused prose                                                                                                                                                                                                                                                                                                                |
| [[template]] (`references/template.md`)     | Understand the agent skills specification or bootstrap a skill directory or SKILL.md                                                                                                                                                                                                                                                                              |
