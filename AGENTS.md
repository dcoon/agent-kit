# Repo Agent Guidelines

- Skills-First Maintenance: prefer editing skills over [[AGENTS]]. Edit [[AGENTS]] only when a skill/schema cannot hold the rule.
- Verify before reporting done: read back every edited file; do not trust subagent "DONE" output alone.
- Check CLI flags before scripting: run `npx skills add --help` and confirm behavior before relying on flags such as repeated `--skill`.
- Ask before destructive changes: confirm before deleting, renaming, or overwriting user files.
- Keep files in their folder: role prompts in `prompts/`, skill sets in `skillsets/`, and only `skills/<name>/SKILL.md` for skills read by `npx skills`.
