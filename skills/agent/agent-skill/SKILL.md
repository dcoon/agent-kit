---
name: agent-skill
description: Create, find, install, lint, refactor, and compress agent skills and SKILL.md files. Use when the user asks to create, find, install, review, or improve agent skills or a SKILL.md.
---


- INVARIANT[read-ref-rules]: Read [rules](reference/rules.md)
- INVARIANT[consent-before-install-01]: before install(tool) -> user.explicitlyConsents(edits)
- INVARIANT[consent-before-edits-01]: before edit() -> user.explicitlyConsents(edits)


```makefile
# agent-lang v0.1
SHELL := false
.PHONY: route


	
route:
	on(user.goal) -> sections.References.filter(r => r.UseWhen.matches(user.goal)).forEach(r => use(r.Ref) && invoke(r.Ref))

```

## References


| Ref | Use When                                                                                                                                                                                                                                               |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [npx-skills](references/npx-skills.md)     | The user asks to find, install, update, or remove agent skills or sync skills from package.json manifest.                                           |
| [lint](references/lint.md)                 | The user asks to lint or check a skill, prompt, or SKILL.md.                                                                                                                                                                |
| [refactor](references/refactor.md)         | The user asks to clean up, optimize, or fix an existing skill, or says a skill is too slow or too expensive.                                                                                                  |
| [compress](references/compress.md)         | The user asks to shrink, compress, or token-optimize a verbose SKILL.md or Markdown prompt into dense, agent-focused prose.                                                                                                                          |
| [template](references/template.md)         | The user asks to create a skill or SKILL.md, or needs the agent skills specification or frontmatter and section rules.                                                                                                                               |
