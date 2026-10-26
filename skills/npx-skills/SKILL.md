---
name: npx-skills
description: "Commands and structural protocols for discovering, installing, and maintaining reusable agent skills using the Open Skills CLI (npx skills). Use when: the user asks to find, install, update, or remove agent skills, mentions npx skills or skills.sh, asks where skills are stored, or asks to add or remove skill entries in an agents package.json manifest."
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

## Skill Manifests (agents/*/package.json)

Read this section when adding or removing pinned skills in an agent's package.json (e.g. `agents/sysadmin/package.json`). The manifest is consumed by the `skills-npm` prepare script (see `devDependencies` and `scripts` below); changes are applied with `npx skills experimental_install` (restores from skills-lock.json) and `npx skills experimental_sync` (syncs node_modules into agent dirs):

```json
{
  "private": true,
  "skills": [
    { "source": "tikoci/routeros-skills" },
    { "source": "iuliandita/skills", "skills": ["debian-ubuntu"] }
  ],
  "devDependencies": { "skills-npm": "*" },
  "scripts": { "prepare": "skills-npm" }
}
```

*   Whole repo: `{ "source": "owner/repo" }` pulls every skill in it.
*   Selected skills: `{ "source": "owner/repo", "skills": ["name"] }`.
*   **Add** ("add dcoon/agent-kit skill-reviewer to package.json"): if a `dcoon/agent-kit` entry exists, append `"skill-reviewer"` to its `skills` array, creating the array if missing; otherwise add `{ "source": "dcoon/agent-kit", "skills": ["skill-reviewer"] }`.
*   **Remove**: delete the name from the `skills` array; delete the whole source object once its `skills` array is empty or absent.
*   If the request does not name the file and several `agents/*/package.json` exist, ask which one.
*   After editing: confirm the JSON parses, then apply with `npx skills experimental_install` followed by `npx skills experimental_sync` — confirm with the user before running installs.

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