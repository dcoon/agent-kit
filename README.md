# dcoon-agent-kit

Skills, mode profiles, and global rules for coding agents. Installed with the
[`skills` CLI](https://skills.sh).

## Layout

```
agents/
  <mode>/
    <mode>.md        # subagent prompt: how to work in this mode
    package.json     # skills to install into the project for this mode
global/
  AGENTS.md          # always-on rules (link into your harness config)
  package.json       # global skills, installed with -g
  bootstrap.sh       # installs them
skills/
  <name>/SKILL.md    # the skill library this repo ships
```

Rules and skills are separate on purpose:

- **`<mode>.md`** is the prompt. It does not list skills — `package.json` is the
  single source of truth, so the two can never drift.
- **`package.json`** is the skillset. `npx skills experimental_sync` reads the
  `skills` array in the *project's* `package.json` and links the results into
  `.agents/skills/`, tracked by `skills-lock.json`.

## Modes

| Mode | Use for |
|---|---|
| `developer` | features, bug fixes, refactors in a project |
| `reviewer` | read-only second pass on a diff or another agent's work |
| `researcher` | "should I adopt X", comparisons, doc lookups |
| `devops` | containers, compose, deploys, service config |
| `sysadmin` | hosts, disks, users, network, routing |
| `wiki` | Obsidian vault ingest, memory, schema |
| `business` | pricing, proposals, invoices, customer docs |

## Install a mode into a project

`experimental_sync` only reads the `package.json` in the directory you run it in,
and has no `--path` flag. So copy the skills array across — do not `cp` over a
project that already has dependencies.

```bash
cd ~/Projects/my-project
# copy the "skills" array from agents/devops/package.json into this package.json
npx skills experimental_sync --dry-run -y   # preview the plan
npx skills experimental_sync -y             # apply
```

`--dry-run` lists git sources but reports `No skills found` for them — it does not
enumerate remote skill names. That message is expected; trust the summary block.

Re-running with a different mode's array removes the skills the previous mode
added, because sync prunes what it previously tracked and leaves `skills add`
installs alone.

Commit `skills-lock.json`. It is the only thing making the install reproducible.
Pin git refs (`docker/skills#v1.2.0`) in `package.json` if you want that to
actually hold.

## Install global

```bash
./global/bootstrap.sh
ln -sfn "$PWD/global/AGENTS.md" ~/.config/opencode/AGENTS.md
```

`experimental_sync` has no `-g` flag, so global skills go through `skills add -g`.
Cap `global/package.json` at five skills. Every global skill is context paid in
every session, in every project, forever.

Rules belong in `global/AGENTS.md`, not in a global skill and not in a mode
profile — a subagent prompt only applies when that agent is selected.

## Add a mode

1. `agents/<mode>/<mode>.md` — frontmatter: `name`, `description`, `mode: subagent`,
   and `tools:` restrictions if it must not write.
2. `agents/<mode>/package.json` — `"skills": ["owner/repo@skill-name", ...]`.
   Keep it to 3–5. Verify each name exists upstream before committing.

## Add a skill

1. `skills/<name>/SKILL.md` with frontmatter `name` and `description` (the
   description is what the model matches on — say *when* to use it).
2. Long reference material goes in a sibling file and is linked from `SKILL.md`.
3. `npx skills add ./` to test locally.

## Conventions

- Lowercase, hyphenated names (`wiki-ingest`, not `Wiki Ingest`).
- The mode folder name, the prompt filename, the prompt `name`, and the folder
  name under `skills/` all match.
- No secrets, no API keys.
- Markdown is code: review and verify it like source.

## License

MIT
