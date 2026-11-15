---
name: dev-fel
description: Project management methodology that combines minimal agile loop with fractal eng WBS.
---

# Fractal Engineering Loop

ideate -> plan -> build -> verify -> deploy
    wbs = sub loop following same stages
    sub loops can be created from any stage: ideate|plan -> queue future work ; build -> queue wbs|defer tasks while iterating this loop ; verify|deploy -> queue additional test or devops creation

```makefile
SHELL := false
.PHONY

DOCDIR=user.prefs (ask or fallback to "`cwd`/docs")

loop: deploy
    
$(DOCDIR):

$(DOCDIR)/*.md:  $(DOCDIR)
    file.create(cwd/$@.md) from references/$@.md

init: $(DOCDIR)/plan|design|decisions|tasks.md

ideate: init
    
plan: ideate
    Define problem, hypothesis, and constraints
    for each goal, define verification criteria
    Lock `Goals` and `Validation Criteria` in `Plan_<scope>.md`
    
build: plan
    INVARIANT[verification-criteria-before-build]: before build(plan) -> for each plan.goal(matches(goal.verification-criteria))
    worktrees; git diff
    ide; serena
    
verify: build decisions.md
    INVARIANT[verification-complete]: for each (verification criteria) -> verify pass
    Prove `Validation Criteria` are met via automated tests, benchmarks, or manual checks.
    test runner -> pass
    
deploy: verify
    Merge, ship, or integrate the `<scope>` into its parent scope.
    git commit; push; pr?
    
task: tasks.md
    INVARIANT[tasks-create]: when future task needed to achieve target, tasks.md.append(timestamp, context, task.description)
    INVARIANT[tasks-complete]: before task.complete() -> verify(task.verificationCriteria) && tasks.md.findMatchingTask().markComplete() 

decision: decisions.md
    INVARIANT[decisions-record]: after user.decision -> "decisions.md".append(timestamp, context, user.decision, superceeds?)
    
subscope-enter:
    Create new child.scope in scope/<child.scope.name> dir
    Enforce parent constraints in child by reference
    Create task in parent.scope for child.scope
    Execute loop in child.scope

subscope-exit:
    review(child.decisions.tagged(upward imact)) -> adjust parent.plan if necessary && verify tasks and decisions still apply
    after successful review subscope->verify->deploy of child.scope -> mark parent.scope task for child.scope complete && exec loop in parent.scope
    

subscope-propagate-up:
    Child loops inherit constraints from their ancestors, **but reality overrides plans**. If a micro-loop uncovers a technical blocker, invalid assumption, or superior pattern during `BUILD`, `VERIFY`, or `OPERATE`
    if blocker, log(decision).tag(upward impact)
    

```

## References

- [plan](references/plan.md) - skills for `plan.md` target in makefile
- [design](references/design.md) - skills for `design.md` doc
- [decisions](references/decisions.md) - skills for `decisions.md` doc
- [tasks](references/tasks.md) - skills for `tasks.md` doc
- [template](references/template.md) - templates for plan|design|decisions|tasks docs


