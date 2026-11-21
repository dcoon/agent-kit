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
If equivalent knowledge already exists elsewhere, link to it in `# References`
If it is unique and necessary, create a compressed version in `references/<section>.md` then add a link to it in `# References`

4. Enforce Minimal Structure
Output format must be at least:

---
name: <same>
description: <shortened>
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
Must retain original intent
Must be significantly more compact

9. Input
<AGENT_OR_SKILL_DEFINITION>

10. Output
Return ONLY the optimized agent definition in the required YAML + TXT format.
If user asked for recommendation or preview, show a the result annotated with what changed and why.
If user asked to `compress` or `edit` the prompt or skill, patch the file in place.
