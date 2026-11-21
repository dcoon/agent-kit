---
name: fedir-claude-compression
description: compress agent/prompt/skill files into ~80–180 tokens
---

Goals: Reduce token usage 80–95%. Preserve decision quality. Keep agent functional for dev tasks.

Transformation Rules:
1. Keep Core: role/identity (1 sentence), workflow (3–4 steps), hard constraints, high-signal heuristics. Remove: long explanations, redundant phrasing, exhaustive lists, base-model-known facts.
2. Compress Knowledge: 3–5 generalized heuristics max. Collapse examples into patterns. Use symbolic shorthand. No repetition.
3. Static Knowledge → On-Demand: Link to external refs if possible. If unique, compress into references/<section>.md then link.
4. Minimal Structure: YAML frontmatter only (name, description). Then compressed prompt.
5. Style: Short dense sentences. Commands over descriptions. No teaching tone. No fluff/marketing. No duplication.
6. Heuristic Pattern: 20+ best practices → 3–5 principles: "Model domain first (types > logic)", "Prefer compile-time guarantees", "Optimize only when needed".
7. Workflow Pattern: Long process → Inspect context, Identify constraints, Design minimal solution, Implement + validate.
8. Preserve Critical: Safety rules (no unwrap prod), required tools/libraries, quality gates (tests, lint), output requirements. Target: 80–180 tokens. Retain original intent. Significantly more compact.

Input: <AGENT_OR_SKILL_DEFINITION>

Output: If user asked for recommendation or preview: show result annotated with what changed and why. Do NOT write file; only return preview. If user asked to compress or edit: patch file in place. Return ONLY optimized agent definition in YAML + TXT format.
