---
name: agent-lang
description: "Author, read, and review agent-lang prompts and skills: Markdown with Makefile-style workflows, phase-scoped invariants, approval gates, and provider-neutral capability slots."
---

# agent-lang

Use agent-lang for instructions followed by an agent, not scripts executed by `make`. Keep each workflow understandable without loading this skill or its references.

## Read

- Identify the requested target. Complete its prerequisites successfully before its recipe; failed prerequisites block dependent recipes. Use standard Make dependency ordering, not invented serial ordering of sibling prerequisites.
- Skip the exact first recipe line, the sentinel. Only subsequent `@` lines are shell commands; never submit agent instructions or an entire workflow to a shell.
- Interpret plain natural-language recipe actions in order, including conditional stops. All actions remain subject to applicable permissions and confirmations.
- Before phase actions, read all invariants declared anywhere in the phase and applicable skill-wide invariants. `INVARIANT[domain-NN]: expression` governs the whole declaring phase, not just following lines, and applicable code changes. Explicitly named skill-wide invariants govern every phase and referenced workflow throughout; they cannot override higher-priority instructions or authorize prohibited actions. Check preconditions before relevant actions, preserve constraints during them, and verify postconditions afterward; do not require postconditions to be true beforehand. Abstract expressions require evidence; declaring a condition is not proof that it holds.
- At `HUMAN APPROVAL REQUIRED: <named item>`, stop and ask for explicit human approval of that item in this conversation; wait before continuing the recipe. Silence or a related message is not approval.
- At `SLOT[name]: <capability and intent>`, use an available skill or tool. Resolve provider and format at runtime from the caller's skill description and context; ask if no safe suitable provider exists or choices materially affect the outcome.

## Author

- Use Markdown with one main fenced `makefile` workflow. Smaller syntax snippets are permitted. Start the workflow with `# agent-lang v0.1`; indent recipes with tabs.
- Use targets and prerequisites for phases. `.PHONY` declarations are valid. Put the exact sentinel below first in every target's recipe; `.PHONY` is a declaration, not a phase needing a recipe.
- Write ordinary recipe actions as tab-indented natural language, including conditional stops where needed. Use a slot only when a capability needs runtime provider discovery.
- Spell out `INVARIANT`, never `INVAR`. Use one line per invariant, with a lowercase kebab-case domain and two-digit number. Prefer pseudo-TypeScript for concise conditions; use prose when clearer. Abstract properties and predicates are semantic shorthand: they need not be existing APIs or be implemented, but their meaning and scope must be clear locally. Do not present shorthand as a real API.
- Explicitly named skill-wide invariants may appear outside the workflow, for example as Markdown bullets under `## Skill-wide invariants` with a sentence saying they govern every phase and referenced workflow throughout. They cannot override higher-priority instructions or authorize prohibited actions.
- Use familiar boolean, comparison, and method notation. `before`, `after`, and `only after` express timing, not executable TypeScript; `&&` does not impose temporal order. Avoid ambiguous `=>`. Require no types, schemas, multiline invariant blocks, runtime, or compiler. A preceding one-line `#` comment can explain why.
- Put approval gates on standalone recipe lines, never inside invariants. Include the approval rule above once in every authored skill so gates remain self-contained. Gates apply where declared; agent-lang does not itself require commit or push approval.
- Every slot line must explicitly direct use of an available skill or tool and state capability plus intent. Do not require provider/schema/type changes or impose a provider or format unless caller intent requires it.
- Include enough local explanation to distinguish agent instructions from shell commands and describe dependency order, action order and stops, invariant scope and timing, applicable permissions, and any slot resolution. Keep references optional; use them for long contracts or extra detail, not basic workflow meaning.
- Exclude Make variables, functions, includes, pattern rules, and `.ONESHELL`.

Minimal workflow skeleton (replace the illustrative condition with the actual contract):

```makefile
# agent-lang v0.1
.PHONY: verify

verify:
	@echo "agent-lang: not a runnable script. Agent follows this recipe." >&2; exit 1
	INVARIANT[verification-01]: Before reporting completion, evidence supports every claimed result.
	Inspect the relevant check results.
	If required evidence is missing, stop and ask the user.
```

Read [core specification](references/lang), [human help](references/help), or [worked example](references/example) only when needed.
