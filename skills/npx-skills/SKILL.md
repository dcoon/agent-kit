---
name: npx-skills
description: Commands and structural protocols for discovering, installing, and maintaining reusable agent instruction sets using the Open Skills CLI (npx skills).
category: Developer Tools
tags: [cli, npx, package-manager, open-skills, workflow]
author: OpenCode Contributor
version: 1.0.0
---

# NPX Skills Management

You are an expert at managing and executing AI agent behaviors via the open-source `npx skills` package manager. Use this instruction set to discover, install, verify, and maintain system behaviors for yourself and other project workflows.

## Core CLI Actions
When asked to manage tools or expand your skill sets, run the following `npx skills` commands via the shell:

*   **Search for skills:** `npx skills find [query]`
*   **Install to project:** `npx skills add <repository-shorthand-or-url>`
*   **Install globally:** `npx skills add <repository-shorthand-or-url> -g`
*   **Install specific skill from repo:** `npx skills add <user/repo> --skill <skill-name>`
*   **Target specific agent config:** `npx skills add <user/repo> --agent opencode`
*   **List installed skills:** `npx skills list`
*   **Execute one-off without installing:** `npx skills use <source>@<skill>`
*   **Update skills:** `npx skills update`
*   **Remove skills:** `npx skills remove <skill-name>`

## Discovery & Installation Path Rules
OpenCode automatically discovers behaviors structured as a `SKILL.md` file wrapped in a named parent folder. If `npx skills` installs behavior into a parallel agent folder (like `.claude/skills/`), OpenCode will natively scan and resolve it. 

Verify or manually link targets into any of these scanned directories:

| Scope | Standard Path | Alternative Path Compatibilities |
| :--- | :--- | :--- |
| **Project Local** | `.opencode/skills/<name>/SKILL.md` | `.claude/skills/` or `.agents/skills/` |
| **Global System** | `~/.config/opencode/skills/<name>/SKILL.md` | `~/.claude/skills/` or `~/.agents/skills/` |

## Operational Workflow

### 1. Verification of Ecosystem
Before installing any new behavior package, check if your environment meets the minimum prerequisites:
*   Ensure Node.js 22.20+ is active (`node --version`).
*   Check existing directory placements using `ls ~/.config/opencode/skills/`.

### 2. Behavior Optimization & Permissions
Unlike standard text instruction injections, OpenCode surfaces explicit skills to the core model framework as a **structured tool call**. 
*   Always structure custom entries with valid YAML frontmatter containing required `name` and `description` lines.
*   Be prepared for the user to face a permission confirmation prompt before any underlying automated script executes. 

