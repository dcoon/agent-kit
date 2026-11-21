---
name: compress
description: compress agent/prompt/skill files into ~80–180 tokens
mode: "preview" | "edit" 
intents_required: true
---

Goals: Reduce token usage 80–95%. Preserve decision quality. Keep agent functional for dev tasks.

## Guardrails
- **Mode discipline**: `mode` must be `"preview"` or `"edit"`; default is `"preview"` when intent is ambiguous.
- **Preview-first**: If the user's request is ambiguous between "show compressed output" vs "compress this file", return a preview annotated with "what changed and why" then ask: "Shall I apply these changes to the file at PATH, or keep as preview?" Do NOT write any file until explicit consent.
- **Path validation**: If path is `.tmp_*` or clearly temporary, flag: "Did you mean to patch the original file at `PATH`?"
- **No silent writes**: Return annotated output only when `mode: "preview"`; file patches only when `mode: "edit"`.

Transformation Rules:
1. Keep Core: role/identity (1 sentence), workflow (3–4 steps), hard constraints, high-signal heuristics. Remove: long explanations, redundant phrasing, exhaustive lists, base-model-known facts.
2. Compress Knowledge: 3–5 generalized heuristics max. Collapse examples into patterns. Use symbolic shorthand. No repetition.
3. Static Knowledge → On-Demand: Link to external refs if possible. If unique, compress into references/<section>.md then link.
4. Minimal Structure: YAML frontmatter only (name, description, mode). Then compressed prompt.
5. Style: Short dense sentences. Commands over descriptions. No teaching tone. No fluff/marketing. No duplication.
6. Heuristic Pattern: 20+ best practices → 3–5 principles: "Model domain first (types > logic)", "Prefer compile-time guarantees", "Optimize only when needed".
7. Workflow Pattern: Long process → Inspect context, Identify constraints, Design minimal solution, Implement + validate.
8. Preserve Critical: Safety rules (no unwrap prod), required tools/libraries, quality gates (tests, lint), output requirements. Target: 80–180 tokens. Retain original intent. Significantly more compact.

Input: <AGENT_OR_SKILL_DEFINITION>

## Usage
```
compress { path, mode: "preview" }    → annotated output only, no file changes
compress { path, mode: "edit" }       → in-place patch of the given file
compress (no path)                    → ask user which file + which mode
```

## Dry-run / Preview
When `mode: "preview"` (or `--dry-run` / `--preview` flag):
- Return the compressed result as annotated text
- Show **What changed** (merged role+core, collapsed workflow, consolidated constraints)
- Show **Why** (transformation rule reference)
- Show **File affected**: "none (preview only)"
- Never write to filesystem

When `mode: "edit"`:
- Patch file in place at the given path
- If no path given, ask user for target file before editing

## Output Format (when mode = "preview")
### Compression Result

**What changed:**
- Role+core: merged from X sentences → 1 sentence
- Workflow: Y steps → Z steps  
- Constraints: N items → M items

**Why:** [concise rationale per transformation rule]

**File affected:** none (preview only)

Return ONLY optimized agent definition in YAML + TXT format when mode = "edit".
