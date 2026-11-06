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

# References

Paths are relative to this skill's root directory.

| Reference                                      | Use When                                                                                                                                                                               |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [[npx-skills]] (`references/npx-skills.md`)    | You need to find or install skills                                                                                                                                                     |
| [[lint]] (`references/lint.md`)                | Verify that a skill directory or SKILL.md file is formatted correctly                                                                                                                  |
| [[refactor]] (`references/refactor.md`)        | User asks to review, audit, lint, critique, or improve an existing skill or SKILL.md file, says a skill wastes tokens or triggers unreliably, or right after scaffolding a new skill." |
| [[compress]] (`references/compress.md`)        | Shrink a SKILL.md using dense, agent-focused prose                                                                                                                                     |
| [[template]] (`references/template.md`)        | Understand the agent skills specification or bootstrap a skill directory or SKILL.md                                                                                                   |
