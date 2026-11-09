---
name: template
description: Template instructions for agents writing or editing skill dir or files
author: dcoon/agent-kit
tags:
  - skills
---
# Guardrails

- Directory structure and file formats must be a subset of the [agent skills spec](https://agentskills.io/specification)
# Directory Structure

skill-name/
├── SKILL.md          # Required: metadata + instructions
├── scripts/          # Optional: executable code
├── references/       # Optional: documentation and additional instructions
# SKILL.md

Sections to include in SKILL.md and references files. Sections not tagged #optional are required.
## Frontmatter

| Field         | Required | Constraints                                                                                                                        |
| ------------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `name`        | Yes      | Max 64 characters. Lowercase letters, numbers, and hyphens only. Must not start or end with a hyphen.  Matches the directory name. |
| `description` | Yes      | Max 1024 characters. Non-empty. Describes what the skill does and when to use it.                                                  |
| `author`      | No       | Top-level field. Author of the skill, e.g. `dcoon/agent-kit`.                                                                      |
| `tags`        | No       | Top-level field. YAML list of tags, e.g. `- skills`.                                                                               |
| metadata      | No       | {"source": "https://github.com/dcoon/agent-kit"}                                                                                   |
## Workflow

Numbered list of actions to take to execute this skill.  May refer to Inputs and Outputs.
## Guards

List of guards for the skill, including examples.

## References #optional 

Table of sub skill instructions and scripts in this skill directory.

| Ref                        | Use When                                  |
| -------------------------- | ----------------------------------------- |
| Link to the reference/file | Description of when to use this reference |

## Inputs #optional

List of expected inputs to this skill which may include existing context, user prompt or intent, memories, or available files and tools.

## Outputs  #optional 

Expected output(s) of this skill, including examples.  If output format (ie. markdown, json) is not given, use context and workspace to infer; if unsure, ask.