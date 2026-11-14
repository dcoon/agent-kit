---
name: refactor
author: dcoon/agent-kit
description: Review and optimize an existing or newly scaffolded skill for token efficiency, agent clarity, and correct frontmatter. Use when asked to clean up, optimize, or fix a skill, or when the user says a skill is too slow or too expensive. Linting alone belongs to lint.
---
# Refactor

## Guards

These invariants and the caller's skill-wide invariants govern every phase of this workflow.

- INVARIANT[skill-identity-01]: Never change a skill's `name` or directory.
- INVARIANT[refactor-route-01]: This workflow does not write files.

## Workflow

These are agent instructions, not a runnable Makefile. Never submit this workflow to a shell. Follow `fixes`; complete each prerequisite successfully before its dependent recipe. Skip each recipe's first line, the safety sentinel. No subsequent line is a shell command. Follow recipe actions in order, including conditional stops.

Before each phase, read its invariants and the applicable skill-wide invariants. Check preconditions before relevant actions, maintain constraints during them, and verify postconditions afterward. All actions remain subject to applicable permissions and confirmations.

Use [lint](lint.md) for the lint phase.

```makefile
# agent-lang v0.1
.PHONY: lint findings fixes

lint:
	@echo "agent-lang: not a runnable script. Agent follows this recipe." >&2; exit 1
	Run lint on the given targets without writing files.

findings: lint
	@echo "agent-lang: not a runnable script. Agent follows this recipe." >&2; exit 1
	Report findings. Quote the files as evidence.

fixes: findings
	@echo "agent-lang: not a runnable script. Agent follows this recipe." >&2; exit 1
	Recommend fixes and prepare proposed edits.
	Present the recommended fixes and proposed edits to the user.
	If edits are requested but not explicitly authorized, ask the user for approval.
	If an approval response is pending, wait for it; silence is not approval.
	After the caller's findings phase, only its apply phase applies explicitly approved edits once, with pre-edit snapshots and concurrent-change checks.
	If editing is not explicitly authorized, the caller finishes with findings and no edits.
	Return the proposed edits to the caller's findings phase without editing.
```



