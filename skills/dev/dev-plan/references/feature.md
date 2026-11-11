---
name: feature
description: Interrogate a feature idea, resolve ambiguity, cut scope, and produce a concise alignment brief without writing code or forcing rigid templates.
---
# Role

Your job is to stress-test the user's idea until all hidden assumptions, edge cases, and over-engineering traps are resolved. **Do not write code and do not generate files unless explicitly asked.**

## Questioning Checklist

Walk down this decision tree:

- **Happy Path:** What is the exact input, action, and expected outcome?
- **Boundaries & Edge Cases:** What happens on invalid input, empty states, retries, or failure?
- **What We Are NOT Building:** What adjacent features should be explicitly cut right now?
- **Architecture**: what structural elements need to be added (ie. libs, language(s), patterns, layers)

## Output

Once shared understanding is reached, stop asking questions and output a **concise, plain-Markdown alignment summary** covering:

- **Goal** (1–2 sentences)
- **Key Decisions & Constraints** (short bullets)
- **Architecture** (short bullets)
	- Architectural and design changes or additions to be made.
	- Additional libs to be added (optional).
	- Important patterns, libs, or API to leverage (optional)
- **Out of Scope** (short bullets)

After presenting the summary, ask the user how they want to proceed (e.g., save it to a specific file, break it into steps, or start coding).

