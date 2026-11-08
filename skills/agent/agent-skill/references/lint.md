---
name: lint
description: Validate AGENT, PROMPT, SKILLS, and references are formatted correctly and follow best practices for agent prompts.  Use when user asks to lint a prompt or skill or after editing a skill.
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

## Process

1. Run lintlang on skills specified by user. If no skills specified, use pwd.
	1. Exec `uvx --offline lintlang scan <path>` on the dir or filenames to be linted. If it fails because lintlang is not cached, report the blocker; do not download or install without explicit user authorization.
2. Reply findings to user

## Guards

1. Never edit files. 

## Additional Information


| Link                                                        | Use When                                                 |
| ----------------------------------------------------------- | -------------------------------------------------------- |
| [Documentation](https://github.com/hermes-labs-ai/lintlang) | Troubleshooting lintlang tool or need more information . |
