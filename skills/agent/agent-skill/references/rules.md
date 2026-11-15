---
name: rules
description: Common rules for agent-skill ref files
---


# Invariants


INVARIANTS apply throughout all workflows and calls


# Makefile Code Blocks

1. Agent instructions, not runnable Makefile: never submit this block or target recipes to a shell
2. Complete each target prerequisite successfully before dependent recipe
3. First recipe line is NOOP sentinal; ignore
4. Recipes use pseudo typescript instructions for agents; pseudo typescript is not executable or API
5. before action() -> check(preconditions) && preserve(constraints) -> check(postconditions)
6. slot(name, intent) -> find()



