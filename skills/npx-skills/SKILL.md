---
name: npx-skills
description: "Commands and structural protocols for discovering, installing, and maintaining reusable agent skills using the Open Skills CLI (npx skills). Use when: the user asks to find, install, update, or remove agent skills, mentions npx skills or skills.sh, or asks where skills are stored."
---

# NPX Skills Management

Use the `npx skills` CLI to find, install, verify, and maintain skills for yourself and other project workflows.

## Core CLI Actions
When asked to find, install, or maintain skills, run the following `npx skills` commands via the shell:

*   **Search for skills:** `npx skills find [query]`
*   **Install to project:** `npx skills add <repository-shorthand-or-url>`
*   **Install globally:** `npx skills add <repository-shorthand-or-url> -g`
*   **Install specific skill from repo:** `npx skills add <user/repo> --skill <skill-name>`
*   **Target specific agent config:** `npx skills add <user/repo> --agent opencode`
*   **List installed skills:** `npx skills list`
*   **Generate a one-off prompt without installing:** `npx skills use <source>@<skill>`
*   **Update skills:** `npx skills update` (scope with `-g`, `-p`, or `-y`)
*   **Remove skills:** `npx skills remove <skill-name>`
*   **Restore skills from lockfile:** `npx skills experimental_install` (then sync into agent dirs with `npx skills experimental_sync`)

## Discovery & Installation Path Rules
OpenCode automatically discovers skills structured as a `SKILL.md` file wrapped in a named parent folder. If `npx skills` installs skills into a parallel agent folder (like `.claude/skills/`), OpenCode will natively scan and resolve it.

Verify or manually link targets into a scanned directory. Observed working paths in this environment:

| Scope | Observed working path | Unverified alternatives |
| :--- | :--- | :--- |
| **Project Local** | `.agents/skills/<name>/SKILL.md` | `.opencode/skills/`, `.claude/skills/` |
| **Global System** | `~/.agents/skills/<name>/SKILL.md` | `~/.config/opencode/skills/` |

## Operational Workflow

### 1. Verification of Ecosystem
Before installing any new skill package, check that the environment meets the minimum prerequisites:
*   Ensure Node.js 22.20+ is active (`node --version`).
*   Check existing directory placements using `ls ~/.agents/skills/`.

### 2. Skill Optimization & Permissions
OpenCode loads each skill's `name` and `description` into model context and registers the skill for invocation via the skill tool.
*   Structure every custom skill with valid YAML frontmatter containing the required `name` and `description` lines.
*   Expect a permission confirmation prompt before any underlying automated script executes.