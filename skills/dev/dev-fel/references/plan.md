---
name: plan
description: Plan stage for dev-fel
---


```makefile

SHELL
.PHONY


loop:
    while !$(MAKE) test -> $(MAKE) plan

plan: goals constraints scope verification
    Lock `Goals` and `Validation Criteria` in `Plan_<scope>.md`

goals:
    Define problem, hypothesis, and constraints
    
constraints:
    list of constraints (ie. response metrics, target platforms, test coverage)
    
scope:
    list of scope boundaries and non-goals
    

verifification:
    for each goal, define verification criteria

     
test:
    1-5 goals stating precise targets
    clear verification criteria for each goal
    clear constraints and scope
    

```

# Template

**Parent Scope:** [Link to Parent Plan] | **Status:** IDEATE / PLAN / BUILD / VERIFY / DEPLOY / OPERATE

## 1. Objective & Hypothesis

1. What problem does this solve, and why does it matter to the parent scope?

## 2. Non-Goals (Scope Guardrails)
What are we explicitly NOT building right now?

## 3. Validation Criteria (Definition of Done)
- [ ] Criterion 1 (e.g., API responds in < 100ms under 50 concurrent requests)
- [ ] Criterion 2 (e.g., Unit test coverage > 90% on core state machine)

## 4. Additional Documentation

1. [Decision Record](./decisions.md) - timestamped records of decisions made in this scope
2. [Tasks](./tasks.md) - tasks required to impl plan objectives and validation
3. [Design](./design.md) - design rules, stack, and architecture for this scope 
