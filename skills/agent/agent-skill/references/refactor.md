---
name: refactor
description: Review and optimize an existing or newly scaffolded skill for token efficiency, agent clarity, and correct frontmatter. Use when asked to clean up, optimize, or fix a skill, or when the user says a skill is too slow or too expensive. Linting alone belongs to lint.
---

- INVARIANT[skill-identity-01]: Never change a skill's `name` or directory.
- INVARIANT[consent-before-edits-01]: forbid(write, edit) unless user.explicitlyConsents(edits)
- INVARIANT[format-selection]: user.requests("prose") ? naturalLanguage(edits) : useSkill("agent-lang", edits)

```makefile
# agent-lang v0.1
SHELL := false
.PHONY: refactor lint findings fixes apply

refactor: fixes apply

lint:
	invoke("lint", targets)

findings: lint
	Flag token bloat, structural clutter, clarity issues, and lint findings.

fixes: findings
	Prepare proposed edits and token comparisons (`wc -lc` before → after).
	Present the proposal to the user.
	if (!user.explicitlyConsents(edits)) askApproval(edits) && awaitApproval();

apply: fixes
	if (!user.explicitlyConsents(edits)) abort("Edits not authorized");
	SLOT[snapshot]: Snapshot each target before editing.
	Apply approved changes in one coherent pass.
	Verify results: read back all modified files and report final `wc -lc`.
```

## Proposal Format

Present proposed refactorings with evidence, token impact, and clear diffs:

- Summary of optimizations (structural changes, clarity improvements, token savings).
- Before → After stats: `wc -lc <target>` before → after (projected or applied).
- Proposed edits or diffs awaiting user confirmation.
