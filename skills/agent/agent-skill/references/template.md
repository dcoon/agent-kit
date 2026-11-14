---
name: template
description: Template instructions for agents writing or editing skill dir or files
author: dcoon/agent-kit
tags:
  - skills
---
# Guardrails

- Directory structure and file formats must be a subset of the [agent skills spec](https://agentskills.io/specification)

# Applying this template

Follow `prepare`: complete prerequisites successfully before dependent phases; a failed prerequisite blocks its dependent. Sibling prerequisites have no implied order. Skip each phase's first recipe line, the sentinel. These recipes are agent instructions, not a runnable Makefile; never submit them to a shell. Only subsequent `@` lines would be shell commands; this workflow has none.

Before phase actions, read all invariants declared in that phase and applicable skill-wide invariants. A phase invariant governs its whole phase, including earlier lines. Check preconditions before relevant actions, maintain constraints during them, and verify postconditions afterward; do not assume postconditions in advance.

The calling skill's skill-wide invariants apply throughout. Preparing content does not authorize edits; the calling workflow handles approved edits, snapshots, and concurrent changes.

```makefile
# agent-lang v0.1
.PHONY: inspect prepare

prepare: inspect
	@echo "agent-lang: not a runnable script. Agent follows this recipe." >&2; exit 1
	Prepare the requested skill content or recommendations using the applicable guidance below and the file's purpose.

inspect:
	@echo "agent-lang: not a runnable script. Agent follows this recipe." >&2; exit 1
	Identify the requested skill or file, its purpose, existing content, and the user's scope and constraints.
```

# Directory Structure

skill-name/
├── SKILL.md          # Required: metadata + instructions
├── scripts/          # Optional: executable code
├── references/       # Optional: documentation and additional instructions
# SKILL.md

Use the guidance below for SKILL.md. Required content may use equivalent structures; these headings and a numbered list are not mandatory. Classify reference files by purpose: operational agent instructions need clear actions and applicable safety constraints, while documentation, guides, specifications, and examples do not need workflow or frontmatter boilerplate solely because they are references.
## Frontmatter

| Field         | Required | Constraints                                                                                                                        |
| ------------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `name`        | Yes      | Max 64 characters. Lowercase letters, numbers, and hyphens only. Must not start or end with a hyphen. Matches the skill directory name for SKILL.md, not every reference. |
| `description` | Yes      | Max 1024 characters. Non-empty. Describes what the skill does and when to use it.                                                  |
| `author`      | No       | Top-level field. Author of the skill, e.g. `dcoon/agent-kit`.                                                                      |
| `tags`        | No       | Top-level field. YAML list of tags, e.g. `- skills`.                                                                               |
| metadata      | No       | {"source": "https://github.com/dcoon/agent-kit"}                                                                                   |
## Workflow

Describe the actions to execute the skill; a numbered list, an agent-lang workflow, or another clear equivalent can express them. Actions may refer to Inputs and Outputs.
## Guards

Describe applicable guards and examples, or equivalent scoped invariants, including their scope and timing. Agent-lang skill-wide and phase-scoped invariants are valid equivalents.

## References #optional 

If the skill has bundled references or scripts, link each file from SKILL.md and say when to read or use it. Links and guidance must be discoverable; a particular heading or table is not required. This table is illustrative:

| Ref                        | Use When                                  |
| -------------------------- | ----------------------------------------- |
| Link to the reference/file | Description of when to use this reference |

## Inputs #optional

List of expected inputs to this skill which may include existing context, user prompt or intent, memories, or available files and tools.

## Outputs  #optional 

Expected output(s) of this skill, including examples.  If output format (ie. markdown, json) is not given, use context and workspace to infer; if unsure, ask.