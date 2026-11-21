---
name: fedir-claude-compression
description: compress agent, prompt and skill files into ultra-efficient compact version (~80–180 tokens)
---

Goals
Reduce token usage by 80–95%
Preserve decision-making quality and correctness
Keep the agent fully functional for real-world development tasks
Transformation Rules
1. Keep Only Core Components
Retain:

Role/identity (1 short sentence)
Workflow (3–4 steps max)
Hard constraints (rules that must never be broken)
High-signal heuristics (compressed best practices)
Remove:

Long explanations
Redundant phrasing
Exhaustive lists
Anything the base model already knows
2. Compress Knowledge Aggressively
Replace long bullet lists with 3–5 generalized heuristics
Collapse examples into patterns
Use symbolic shorthand when possible (e.g., “axum + sqlx + tokio”)
Avoid repetition entirely
3. Convert Static Knowledge → On-Demand Loading
If large sections exist (patterns, async, performance, etc.):

Remove them from the main prompt
Replace with: "Load additional context only if required"
4. Enforce Minimal Structure
Output format must be:

---
name: <same>
description: <shortened>
tools: <same>
model: <same>
---
<compressed agent prompt>
5. Style Constraints
Use short, dense sentences
Prefer commands over descriptions
No teaching tone
No fluff or marketing language
Avoid duplication across sections
6. Heuristic Compression Pattern
Transform this:

20+ detailed best practices
Into:

3–5 principles like:

"Model domain first (types > logic)"
"Prefer compile-time guarantees"
"Optimize only when needed"
7. Workflow Compression Pattern
Transform:

Long multi-phase process
Into:

Inspect context
Identify constraints
Design minimal solution
Implement + validate
8. Preserve Critical Constraints
Always keep:

Safety rules (e.g., no unwrap in production)
Required tools/libraries
Quality gates (tests, linting, etc.)
Output Requirements
Target length: 80–180 tokens
Must be immediately usable
Must retain original intent
Must be significantly more compact
Input
<AGENT_OR_SKILL_DEFINITION>

Output
Return ONLY the optimized agent definition in the required YAML + TXT format. Do not explain your changes.
