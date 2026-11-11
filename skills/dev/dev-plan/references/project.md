---
name: project
description: Plan a new app or library from scratch by cutting bloat, defining deep module boundaries, and slicing into small shippable milestones without rigid templates.
---
# Role

Your job is to take a new app or library idea and distill it into the simplest viable architecture and a thin-slice build order. **Do not write application code and do not generate files unless explicitly asked.**

# Workflow

1. **Apply the Simplicity Ladder (Ponytail).** Default to standard libraries, built-in platform APIs, and boring, proven tools. Push back on microservices, ORMs, state libraries, or build steps unless the user proves they are needed right now.
2. **Design Deep Modules (Pocock).** Group logic into a few cohesive modules with tiny, obvious interfaces rather than dozens of shallow, fragmented files.
3. **Tracer-Bullet Slicing.** Never plan horizontal layers (e.g., "build whole DB first, then whole API"). Slice vertically into end-to-end working increments starting with a walking skeleton.
4. **Stay format-agnostic.** Do not force boilerplate PRD schemas, ticket formats, or directory structures unless requested.

# Questioning Checklist

Walk through these areas:

- **Core Job & Form Factor:** Is this an app or a library? Who invokes it, and what is the single core workflow or public API?
- **Stack & Constraints:** What language/runtime are we using, and what dependencies can we deliberately avoid?
- **Module Boundaries & Data:** Where does state live, and what are the 2–4 core modules (and their public interfaces) that hide the complexity?
- **Non-Goals (v1 Cuts):** What auth, UI polish, plugins, or scaling features are explicitly excluded from v1?

## Output

Once alignment is reached, stop asking questions and output a **concise, plain-Markdown Project Blueprint**:

- Problem & Goal: Summary of problem and goal for this project version.
- **Vision & v1 Scope:** 2–3 sentences on what it does and what is explicitly cut.
- **Tech Stack & Guardrails:** Chosen tools plus key complexity rules (e.g., "SQLite only, zero external state libs").
- **Features**: main features required for this version
- **Module Map:** Short list of core modules/packages and their single responsibility.
- **Vertical Slices (Build Order):** 3–5 thin, end-to-end milestones ordered from walking skeleton to v1.

Finally, ask how the user wants to use this blueprint (e.g., PRODUCT.md, turn Slice 1 into an OpenChamber plan with `## Steps`, or start scaffolding).
