---
name: compress
description: Transforms existing, verbose Markdown skills into a terse, token-optimized format for LLM consumption.
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

# Process

1. Validate the SKILLS.md file and skill directory including optional files in references conform with [[template]].