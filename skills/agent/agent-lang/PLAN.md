
A mini DSL for agent prompts and skills inspired by unix philosophy and tools.

# Goals

1. Minimize model drift through structured flow and invariant syntax native to LLMs (primary)
2. Readable and editable by a human solo developer, and parsed reliably by agents (primary)
3. Reduce token usage where it does not cost drift or readability (secondary)
4. Make the syntax obvious to LLMs without requiring additional schema or skill references (primary)

# Summary

1. Prompt and skill syntax
	1. Markdown per Agent Skill spec
	2. Minimize natural language
	3. Control flow: loose pseudo-Makefile in a markdown code block (this note). Strict Makefiles are covered by the make and shell skills, not here.
	4. Invariants: TypeScript-style expressions inside recipes
2. Linter: custom `npx langlint` (existing project; used as-is during refactor and testing, enhanced after syntax is frozen)
	1. Syntactic: langlint
	2. Semantic: agent-kit skill (location to be confirmed, see Tasks)

# Syntax (agent-lang v0.1)

A skill contains one fenced `makefile` block using Makefile target, prerequisite, and recipe structure. A target's recipe runs only after all its prerequisites complete successfully. Prose outside the block is natural language; `INVARIANT`, `SLOT`, and `HUMAN APPROVAL REQUIRED` are agent instructions within recipes.

## Rules

1. **Targets are phases.** `X: Y` means target X depends on Y. Complete all prerequisites successfully before running X's recipe; if a prerequisite fails, do not run X's recipe.
2. **Sentinel first.** The first recipe line of every target is the sentinel below. It makes any `make` run fail loudly.
3. **Tabs.** Recipe lines start with a tab, never spaces. Lintlang checks this.
4. **Comments.** A `#` line directly above an invariant gives one line: why the rule exists.
5. **Invariants.** One form: `INVARIANT[domain-NN]: <expression>`. Always spell out `INVARIANT`; do not abbreviate it to `INVAR`. One line. Expressions may be TypeScript-style code contracts or plain prose when no code contract fits. If a contract is long, put it in a reference file and name it in the invariant.
6. **Human approval.** `HUMAN APPROVAL REQUIRED: <what needs approval>` is a recipe instruction that pauses work for user approval. See Human approval protocol below.
7. **Shell.** `@<command>` only. The agent runs these after the target's invariants hold.
8. **Slots.** `SLOT[name]: <capability and intent>` requests a named capability without selecting its provider. See Slots below.
9. **Subset.** Allowed: targets, prerequisites, recipe lines, comments, `INVARIANT`, `SLOT`, `HUMAN APPROVAL REQUIRED`, `@` commands, sentinel. Not allowed: variables, functions, includes, pattern rules, `.ONESHELL`.
10. **Version.** Put `# agent-lang v0.1` as the first line of the block.

## Slots

A slot names a capability the skill needs while leaving the provider and its format unspecified until runtime. At its position in the recipe, use the caller's skill description and context to resolve it against available skills and tools, including MCP tools, then perform the requested action. Choose a suitable provider and use it as available; do not require provider changes or a shared schema.

Each slot line must explicitly tell the agent to use an available skill or tool to perform the action. Naming a capability alone may not trigger provider discovery. Do not encode a provider name or impose a format unless the caller's intent requires it. Resolve autonomously when one suitable provider is clear. A slot conveys the requested intent, but does not override provider permissions, safety rules, or required confirmation. Ask the user if no safe suitable provider is available or if the available choices materially change the outcome.

```makefile
	SLOT[record-memory]: Use an available skill or tool to persist this project's durable decision and rationale.
	SLOT[record-task]: Use an available skill or tool to record this actionable project task with its context.
```

## Sentinel

```makefile
	@echo "agent-lang: not a runnable script. Agent follows this recipe." >&2; exit 1
```

Under `make`, this line prints the message and fails. The agent does not execute it. It is the first line of every target.

## Human approval protocol

- At `HUMAN APPROVAL REQUIRED`, stop and ask the user to approve the named item.
- Do not continue the target's recipe until the user explicitly approves in this conversation.
- Silence or a related message is not approval.

## Naming

- `domain-NN`: lowercase kebab-case slug plus a two-digit number, e.g. `async-ui-01`, `storage-02`, `git-branch-01`.
- Descriptive slugs help the agent focus and give reviewers a citation handle.

## Example

```makefile
# agent-lang v0.1. Prerequisites run first. Read "X: Y" as "X needs Y".
.PHONY: finish push commit review impl approved-plan

finish: push
	@echo "agent-lang: not a runnable script. Agent follows this recipe." >&2; exit 1
	# Confirm clean workspace after landing
	@git status --short

push: commit
	@echo "agent-lang: not a runnable script. Agent follows this recipe." >&2; exit 1
	# Pushing to main skips review
	INVARIANT[git-branch-01]: branch.name !== "main"
	@git push -u origin HEAD

commit: review
	@echo "agent-lang: not a runnable script. Agent follows this recipe." >&2; exit 1
	@git diff --cached --stat

review: impl
	@echo "agent-lang: not a runnable script. Agent follows this recipe." >&2; exit 1
	# Fresh-context pass catches violations the author missed
	INVARIANT[review-01]: diff.violatesAnyInvariant() === false

impl: approved-plan
	@echo "agent-lang: not a runnable script. Agent follows this recipe." >&2; exit 1
	# Async UI callbacks must not touch unmounted components
	INVARIANT[async-ui-01]: after await f(), component.isAlive() before component.setState()
	# Evict cache only after durable write succeeds
	INVARIANT[storage-02]: cache.evict(key) only after durableIO.succeeded
	@npm test

approved-plan:
	@echo "agent-lang: not a runnable script. Agent follows this recipe." >&2; exit 1
	# Human approval gate: no code before an approved plan
	HUMAN APPROVAL REQUIRED: Approve the plan before implementation.
```

# Plan

1. Syntax
	1. Syntax section above is the v0.1 draft. Verify on the pilot, then freeze.
2. Write agent-lang skill and refs in dcoon/agent-kit:agent-lang
	1. references/langlint: use langlint for syntax; semantic checks via the agent-kit skill
	2. references/lang: agent-lang syntax and agent guidance
	3. references/lang-help: human guide (rarely loaded)
3. Test
	1. Define and test target gates: each gate stops, asks, and does not proceed without explicit approval
	2. Baseline: 5–10 tasks on current prose skills. Record drift and tokens.
	3. Pilot one skill in agent-lang. Run the same tasks. Compare.
	4. Refactor agent instructions with agent-skill without specifying a format. Expected: agent-lang.
	5. Refactor agent instructions with `use prose`. Expected: prose.
	6. Refactor agent instructions with `make it human-readable` alone. Expected: agent-lang.
4. Update agent-kit/agent-skill to use agent-lang
5. Use agent-skill to refactor other agent-kit skills, then re-run tests
6. Enhance langlint to check agent-lang format (only after syntax is frozen)
7. Slots: decide with the user (open)

## Eval (simple)

- **Drift:** count per task. A skipped step, a gate passed without approval, or an invariant violated in the output. Drift rate = tasks with drift / tasks run.
- **Human review:** per task, 1–3. Does the flow match intent? Could you edit it without re-reading the docs?
- **Tokens:** recorded per run. Secondary.

# Decisions

1. Primary audience is the agent. Humans must be able to read and edit easily.
2. Notation: one restricted Makefile-style block. Target/prerequisite dependencies and recipe ordering follow Makefile semantics; `INVARIANT`, `SLOT`, and `HUMAN APPROVAL REQUIRED` add agent instructions within recipes. The sentinel makes execution fail loudly under `make`.
3. Mixing: make/TypeScript for flow and invariants. Natural language for descriptions and prompts that don't fit flow or invariants.
4. Slots: `SLOT[name]: <capability and intent>` names a runtime capability request; at its recipe position, the agent resolves and performs it using available skill/tool descriptions and caller context, without assuming provider or format.
5. Compatible with the Agent Skills spec.
6. Metrics: drift rate and human review first, token counts second.
7. Linter is langlint (existing project). Use as-is during refactor and testing. Enhance after syntax is frozen.
8. `HUMAN APPROVAL REQUIRED` pauses a target recipe until explicit user approval.
9. Solo developer: avoid strict formalisms.

# Tasks

- [ ] Shorten the sentinel message (lower verbosity). Keep the `exit 1`.
- [ ] Verify the sentinel fails loudly under `make` for a real target.
- [ ] Pilot one skill in agent-lang and run the baseline comparison.
- [x] Align agent-skill `references/lint.md` and `references/template.md`:
  - Recognize semantic equivalents of workflows and skill-wide or phase-scoped guards, including agent-lang.
  - Require discoverable reference links with useful read guidance, not a mandatory table.
  - Classify reference docs by purpose so guides, specs, and examples do not require workflow or frontmatter boilerplate.
  - Clarify that the directory-matching name applies to `SKILL.md`, not every reference.
  - Preserve safety and progressive-disclosure checks.
- [ ] Evaluate lint behavior end-to-end on prose and agent-lang examples to avoid false positives. A focused manual rubric simulation found no format false positives; no linter or workflows were executed.
- [ ] Confirm the semantic linter location: `agent-kit/agent-skill:lang` or `dcoon/agent-kit:agent-lang/lint`. Pick one and update the Summary and Plan.
- [ ] Rewrite the Gemini section's "Why This Design Works" claims as testable hypotheses.
- [ ] Fix the translation matrix in the Gemini section (Swift and Python rows are incomplete).
- [ ] Retire the Gemini example once the revised example is used in the pilot.
- [x] Slots: design with the user.
- [ ] Move the Gemini session to its own note once the syntax is frozen.

# Gemini Session Below

---


# Declarative Makefile DAGs with Inline TypeScript Invariants

## 1. Overview (For Humans & Agents)

This specification defines a hybrid workflow format for AI coding agents (`SKILL.md` / `AGENTS.md`). It combines two high-familiarity notations inside a single self-contained `Makefile` block:

1. **Makefile Control-Flow DAG (`target: prerequisites`)**: Encodes execution order, phase dependencies, and human approval gates using standard GNU Make dependency topology.
2. **Inline TypeScript Invariants (`INVARIANT[id]`)**: Encodes non-negotiable code contracts directly inside the recipe of the target where they apply—replacing dense LaTeX math macros with familiar TypeScript/assertion syntax.

### Why This Design Works
* **Zero LaTeX Overhead**: TypeScript contract expressions (`after(await f) => assert(...) before ...`) sit near the top of every frontier LLM's pre-training distribution, activating formal precondition/postcondition reasoning without requiring LaTeX macro fluency or risking Markdown rendering errors.
* **Language-Agnostic Semantics**: Although written using TypeScript-style syntax, LLMs automatically generalize the abstract predicates (`await`, `isAlive()`, `mutateState()`) across Dart/Flutter, React/Vue, Swift, Kotlin, Python, and Go.
* **Context-Scoped Attention**: Placing an invariant directly inside its governing target's recipe ensures the rule is only active during that phase, avoiding global prompt bloat.
* **Built-In `/bin/sh` Fail-Fast Tripwire**: Because `INVARIANT[...]` lines inside a recipe are *not* prefixed with `#`, any agent that misunderstands the declarative contract and attempts to blindly execute the recipe via `/usr/bin/make` will immediately trigger a POSIX shell syntax/command error (`exit 2`), halting execution before tests or git commands run.

---

## 2. Syntax Specification

## Invariant
Use for concise causal or ordering constraints:

```makefile

# inline INVARIANT
<target>: <prerequisites>
	# <1-line human explanation of the failure mode prevented>
	INVARIANT[<domain-id>]: <typescript-contract-expression>
	# Optional shell command, more INVARS, etc
	@<shell-command>
	
# block INVARIANT
<target>: <prerequisites>
	# <1-line human explanation of the failure mode prevented>
	INVAR[<domain-id>]
		<multiline-typescript-contract>
	END_INVAR
	@<shell-command>
	
```


### Naming Convention (`[<domain-id>]`)

- Use lowercase kebab-case domain slugs plus a sequence number: `[async-ui-01]`, `[storage-02]`, `[git-branch-01]`.
    
- Keep slugs semantically descriptive—subword tokens like `async-ui` or `storage` actively prime the agent's attention toward the relevant subsystem while providing a permanent citation handle for review logs.
    
- Preceding `#` comments must remain **one crisp line** explaining _why_ the rule exists for human readers.
    

## 3. Agent Execution Semantics

When parsing a `Makefile` DAG under this specification, an AI agent MUST obey the following rules:

1. **Topological Execution**: Resolve `target: prerequisites` strictly from left to right. Never skip an upstream prerequisite or human approval gate.
    
2. **Contract Enforcement (`INVARIANT[...]` / `INVAR[...] ... END_INVAR`)**:
    
    - Treat every `INVARIANT` or `INVAR` block inside a target's recipe as a **mandatory semantic precondition/postcondition** governing all code written, refactored, or reviewed during that target.
        
    - Map the contract's abstract operations (`isAlive()`, `mutateState()`, `durableWrite()`, `cacheEvict()`) to the idiomatic constructs of the repository's target language.
        
    - **NEVER** pass `INVARIANT[...]` or `INVAR[...]` lines to a shell interpreter. They are declarative specifications for the agent, not POSIX shell commands.
        
3. **Shell Execution (`@...`)**: Execute only valid shell commands (lines prefixed with `@` or standard CLI invocations) after satisfying all invariants in that target.


## 5. Cross-Language Translation Matrix (Agent Reference)

Agents must translate abstract TypeScript contract primitives into the idiomatic guard for the active language:

|**Contract Primitive**|**TypeScript / React**|**Dart / Flutter**|**Swift**|**Python**|
|---|---|---|---|---|
|`after(await f)`|`await fetch(...)`|`await future`|`try await task.value`|`await coro`|
|`assert(component.isAlive())`|`if (signal.aborted) return;`|`if (!mounted) return;`|`guard !Task.isCancelled else { return }`|`if self._closed: return`|
|`component.mutateState()`|`setState(next)`|`setState(() => ...)`|

# Example

```makefile
.PHONY: finish push commit adversarial-review implementation-diff approved-plan

# Terminal target: verify clean workspace after landing
finish: push
	@git status --short

# Push feature branch only after local commit and clean review
push: commit
	# Prevent pushing directly to main via accidental upstream tracking
	INVARIANT[git-branch-01]: branch.upstream !== "origin/main" && branch.name !== "main"
	@git push -u origin HEAD

# Atomic commit after adversarial review passes with zero blockers
commit: adversarial-review
	@git diff --cached --stat

# Fresh-context critic pass verifying diff against all phase invariants
adversarial-review: implementation-diff
	# Verify every invariant declared in implementation-diff holds across the diff
	INVARIANT[review-01]: diff.violatesAnyInvariant() === false
	@echo "Adversarial review gate ready"

# TDD implementation phase with inline domain invariants
implementation-diff: approved-plan
	# Guard async UI callbacks against unmounted/disposed components
	INVARIANT[async-ui-01]: after(await f) => assert(component.isAlive()) before component.mutateState()

	# Evict in-memory cache only after durable disk/network I/O succeeds
	INVARIANT[storage-02]: await durableIO() => cache.evict(key) after durableIO.succeeded

	# Ensure locks/busy flags always reset even if an exception is thrown
	INVAR[async-lock-03]
		acquireLock(resource) => {
			try {
				await work();
			} finally {
				releaseLock(resource);
			}
		}
	END_INVAR

	@npm test
```
