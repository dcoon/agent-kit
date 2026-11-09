---
name: npx-skills
description: "Commands and structural protocols for discovering, installing, and maintaining reusable agent skills using the Open Skills CLI (npx skills). Use when: the user asks to find, install, update, or remove agent skills, mentions npx skills or skills.sh, asks where skills are stored, or asks to add or remove skill entries in an agents package.json manifest."
---

# NPX Skills Management

Use the `npx skills` CLI to find, install, verify, and maintain skills for yourself and other project workflows.

## Guards

*   **Check flags first:** read the help of the trusted, already-installed CLI for `add` and `experimental_sync` before relying on any flag. Subcommand help may print only global help; then use docs matching the installed version. Upstream `main` docs (https://github.com/vercel-labs/skills/blob/main/docs/commands.md) may differ, so treat them as a fallback only. If no matching-version evidence exists, report the flags as unverified.
*   **Consent:** `npx` may download code. Prefer an already-installed, trusted CLI. Get explicit user consent before any `npx` run that downloads the package, and before any install, update, remove, or sync.
*   **Scope:** project scope by default; global scope or a specific agent target only when the user asks.
*   **Filtering:** install named skills, not whole repos. Select requested skills with the installed CLI's documented selector, unless the source ships exactly one skill. An `@` suffix in CLI examples can be ambiguous; verify the installed CLI's syntax before relying on it. `package.json` entries follow the manifest `@skill-name` rules below.

## Core CLI Actions

*   **`experimental_sync`:** handles `package.json` `skills` entries and skills from already-installed npm dependencies; it does not install npm dependencies. It may fetch git sources remotely and remove synced skills no longer listed (covered by the consent rule above).
*   **`experimental_install`:** restores skills from the lockfile. It is not a prerequisite for `experimental_sync`.

## Skill Manifests (agents/*/package.json)

Read this section when adding or removing skills in an agent-kit mode manifest (e.g. `agents/sysadmin/package.json`) or `global/package.json`. Each entry is a flat string, `owner/repo@skill`:

```json
{
  "private": true,
  "skills": [
    "owner/repo@skill-a",
    "owner/other-repo@skill-b"
  ]
}
```

*   **Resolve the target:** if the request does not name a mode and several manifests exist, ask which one.
*   **Add or remove only the requested entry.** Preserve unrelated entries and other fields.
*   **Cap:** each mode manifest and `global/package.json` holds at most five skills. Stop and ask if an add would exceed five.
*   **Filter every entry with `@skill-name`** unless the source repo ships exactly one skill. Never add an unfiltered source that installs a whole multi-skill repo.
*   **Verify upstream before adding:** list the source's skills without installing (`add --list`, after checking supported flags in help) and confirm the skill exists and how many the repo ships. Listing may download, so get consent first.
*   After editing, confirm the JSON parses.
*   **Apply:** modes install by copying the mode's `skills` array into the target project's `package.json` and running `experimental_sync`, then including the updated lockfile as the project requires. Confirm with the user before running it. Do not commit unless asked.

## Discovery & Installation Paths

Installation does not guarantee discovery: the CLI writes to agent directories, but OpenCode uses only the locations it scans. Find where the skill was installed (`list` or directory inspection), then compare that location with the discovery and permission docs for the OpenCode version in use (V2: https://opencode.ai/v2/docs/skills). `list` shows locations only and cannot prove OpenCode advertises the skill. Do not assume a project path has a global equivalent.

## Workflow

### 1. Verify the environment
*   Check the installed CLI's Node requirement (its help or `package.json`) and compare it to `node --version`. The requirement is version-specific.
*   Check existing placements (e.g. `ls ~/.agents/skills/`) before installing.

### 2. Skill structure and permissions
*   **Portable spec:** `SKILL.md` requires YAML frontmatter with `name` and `description` per the Agent Skills spec. Always write both.
*   **OpenCode V2 runtime:** frontmatter is optional there. A `description` is needed for the model to be told the skill is available automatically.
*   Obey the actual permission policy before running any skill script. Do not assume a prompt will appear.
