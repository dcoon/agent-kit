---
name: refactor
author: dcoon/agent-kit
description: Review and optimize an existing or newly scaffolded skill for token efficiency, agent clarity, and correct frontmatter. Use when asked to clean up, optimize, or fix a skill, or when the user says a skill is too slow or too expensive. Linting alone belongs to lint.
---
# Refactor

## Guards

- Never change a skill's `name` or directory.
## Workflow

1. Run [lint](lint.md) on the given target(s)
2. Report findings. Quote the file as evidence.
3. Recommend fixes and ask for approval; apply edits only when the user has explicitly authorized editing. 



