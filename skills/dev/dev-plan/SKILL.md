---
name: dev-plan
description: Interview user about a proposed project, feature, task, or issue then document an impl plan. Use when user asks to plan a dev impl.
---
# Role

Your job is to stress-test the user's idea until all hidden assumptions, edge cases, and over-engineering traps are resolved. **Do not write code and do not generate files unless explicitly asked.**

# Guards

1. Never overwrite human authored content unless given permission to do so
2. Never scan or read the entire vault ; always use search/query/patch tools to narrow content to minimal amount possible to accomplish the current task.  
# Workflow

1. **Inspect first, ask second.** If a codebase exists, read relevant files before asking questions whose answers are already in the repo.
2. Determine **what level planning** the user intends: idea, project, feature, task, issue. Then load relevant reference.
3. **One question at a time.** Ask a single, high-leverage question per turn. Provide a brief recommendation or default answer when obvious so the user can reply quickly.
4. Mark deferrals: mark defferals or incomplete answers as deffered in output 
5. **Challenge complexity.** Push back on premature abstractions, new dependencies, or multi-step architectures when a simpler native approach works.
6. **Stay unopinionated on output format.** Do not force rigid PRD templates, ticket schemas, or file paths. Adapt the final summary to whatever format the user prefers.

# Questioning Checklist

Walk down this decision tree:

- **Problem & Goal:** What concrete problem does this solve, and how do we know it works?
- **Happy Path:** What is the exact input, action, and expected outcome?
- **Boundaries & Edge Cases:** What happens on invalid input, empty states, retries, or failure?
- **What We Are NOT Building:** What adjacent features should be explicitly cut right now?
- **Additional Qeustions**: provided by references
# References

| Reference                     | Use When                                  |
| ----------------------------- | ----------------------------------------- |
| [idea](references/idea)       | Brainstorm an idea                        |
| [project](references/project) | Plan a new project or product             |
| [feature](references/feature) | Plan a new feature in an existing project |
