---
name: tasks
description: template Tasks.md for dev-fse
---

**Parent Scope:** [Link to Parent Tasks] | 

## 1. Execution Queue (Ordered)
*Rule: Work top-to-bottom. If a task takes > 1 session or carries high risk, promote it to a child scope.*

- [ ] **T1:** <Atomic action> *(e.g., Define SQLite schema in `db.sql`)*
- [ ] **T2 [SUB-SCOPE]:** <Complex feature> -> `./scopes/01a-<sub-scope>/Loop_<sub-scope>.md`
- [ ] **T3:** <Atomic action> *(e.g., Wire API route to service layer)*

## 2. Verification & Closure Checklist
*Rule: Must match `Validation Criteria` in `Plan_<scope>.md` before moving to DEPLOY.*

- [ ] **V1:** All sub-scopes in Section 1 are marked `DEPLOYED`.
- [ ] **V2:** <Test or benchmark> *(e.g., Run `pytest` — 100% pass, < 100ms latency)*
- [ ] **V3:** Merge/integrate work into parent scope.

## 3. Active Blockers / Escalations
*Rule: If a blocker invalidates a parent rule, log `[UPWARD-IMPACT]` in `Decisions_<scope>.md` and pause.*

- **None** *(or `- [!] T2 blocked by [issue] -> Escalated to Parent Architecture`)*
