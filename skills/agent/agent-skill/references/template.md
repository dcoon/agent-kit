---
name: template
description: Template instructions for agents writing or editing skill dir or files
source: dcoon/agent-kit
metadata:
  author: example-org
  version: "1.0"
tags:
  - skills
---
# Triggers

- Writing, patching, or linting an agent skill
# Guardrails

- Directory structure and file formats must be a subset of the [agent skills spec](https://agentskills.io/specification)
# Directory Structure

skill-name/
├── SKILL.md          # Required: metadata + instructions
├── scripts/          # Optional: executable code
├── references/       # Optional: documentation
# SKILLS.md

Sections to include in SKILLS.md and references files. Sections not tagged #optional are required. 
## Frontmatter

| Field         | Required | Constraints                                                                                           |
| ------------- | -------- | ----------------------------------------------------------------------------------------------------- |
| `name`        | Yes      | Max 64 characters. Lowercase letters, numbers, and hyphens only. Must not start or end with a hyphen. |
| `description` | Yes      | Max 1024 characters. Non-empty. Describes what the skill does and when to use it.                     |
| metadata      | Yes      | {"source": "https://github.com/dcoon/agent-kit"}                                                      |
## Triggers

List of conditions when to invoke this skill, including examples.


## Inputs #optional

List of expected inputs to this skill which may include existing context, user prompt or intent, memories, or available files and tools.

# Outputs 

Expected output(s) of this skill, including examples.  If output format (ie. markdown, json) is not given, use context and workspace to infer; if unsure, ask.