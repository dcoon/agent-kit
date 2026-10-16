---
name: skill-creator
description: Create or revise an agent skill (SKILL.md) that is well defined and triggers reliably. Use when the user asks to create, write, draft, improve, or fix a skill, or to turn a repeated workflow into a skill.
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: skill-authoring
  opencode/slash: true
  opencode/autoinvoke: false
---

# Skill Creator

> Purpose: create clear, scoped, easily triggered skills.

## Anatomy

```
skill-name/
├── SKILL.md        (required: frontmatter name+description, markdown instructions)
└── references/     (optional, loaded only when needed)
```

• GUARD: `name` = lowercase, hyphens only, matches folder name.
• GUARD: `description` = trigger. State what skill does + specific contexts that load it. All "when to use" detail goes here, not body. Lean slightly broad.

## Process

1. CHK: Confirm with user: what skill enables, when it triggers, expected output format. Pull answers from conversation first. Ask about gaps. HALT: await confirmation before drafting.
2. EXEC: Draft SKILL.md, ≤~200 lines. Move detail to `references/`; point to each with when-to-read guidance.
3. CHK: Write 2–3 realistic user prompts. Trace each using only the draft. Fix unclear or missing steps.
4. EXEC: Iterate on user feedback until satisfied.

## Writing Rules

• Imperative instructions.
• Explain why a rule matters; avoid stacked MUSTs/NEVERs.
• Output must be consistent → define a template. Format matters → add 1–2 short input→output examples.
• One skill = one job; split unrelated tasks.
• Keep rules general; no rules fitting only one example.
• GUARD: No content surprising relative to stated purpose.
• Long reference material lives in `references/`.
