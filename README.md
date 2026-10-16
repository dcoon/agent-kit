# dcoon-agent-toolkit

A collection of agent skills, installable with the [skills CLI](https://skills.sh):

```bash
npx skills add dcoon/dcoon-agent-toolkit
```

To install one skill from this repo:

```bash
npx skills add dcoon/dcoon-agent-toolkit --skill example-skill
```

## Repository layout

```
.
├── README.md
└── skills/
    └── <skill-name>/
        ├── SKILL.md        # required: frontmatter + instructions
        └── ...             # optional: scripts, templates, references
```

Each skill lives in its own folder under `skills/`. The folder name should match the `name` field in its `SKILL.md`.

## Adding a skill

1. Create `skills/<skill-name>/`.
2. Add a `SKILL.md` with frontmatter:

   ```markdown
   ---
   name: <skill-name>
   description: What the skill does and when to use it.
   ---

   # Skill title

   Instructions for the agent.
   ```

3. Keep `SKILL.md` focused. Put long reference material in extra files in the same folder and link to them.
4. Test locally before pushing:

   ```bash
   npx skills add ./path/to/dcoon-agent-toolkit
   ```

## Conventions

- Lowercase, hyphenated names (`pdf-extract`, not `PDF Extract`).
- `description` is required and should say when to use the skill, since agents use it to decide whether to load it.
- Don't commit secrets or API keys.

## License

TBD
