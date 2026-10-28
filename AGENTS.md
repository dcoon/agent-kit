# Repo Agent Guidelines

Working rules for editing this repo.

## Layout is the contract

- `agents/<mode>/<mode>.md` — the mode prompt. One mode, one folder, one prompt.
- `agents/<mode>/package.json` — the skills for that mode. This is the **only**
  place skills are listed for a mode; never repeat the list in the prompt body.
- `skills/<name>/SKILL.md` — the skill library. Only skill folders live here.
- `global/` — `AGENTS.md` (rules) and `package.json` (skills installed with `-g`).
  It is not a mode and does not get a `<mode>.md`.

## Editing rules

- Skills-First Maintenance: prefer editing a skill over `global/AGENTS.md`. Edit
  the rules file only when no skill can hold the rule.
- Verify before reporting done: read back every edited file. A subagent "DONE" is
  not evidence.
- Verify every `skills` entry exists upstream before committing it. A mode with a
  dangling skill name loads silently missing instructions.
- **Always filter with `@skill-name`** unless the repo ships exactly one skill.
  An unfiltered source installs the whole repo: `juliusbrussee/caveman` drags in
  23 skills, `tikoci/routeros-skills` 18. Check the count with
  `npx skills add <owner/repo> -l -y` before adding a source.
- Check CLI flags before scripting: run `npx skills add --help` and
  `npx skills experimental_sync --help` before relying on a flag.
- Ask before destructive changes: confirm before deleting, renaming, or
  overwriting user files.
- No `bin/` scripts. Modes are installed by copying the `skills` array into the
  project and running `experimental_sync`.
- Markdown is code: treat `.md` prompts, skills, and schemas as source. Review,
  verify, and commit them with the same rigor as code changes.
- Keep `global/package.json` at five skills or fewer, and `agents/*/package.json`
  at five or fewer. Count is context cost.
