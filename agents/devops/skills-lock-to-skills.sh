jq '{
  "$schema": "https://json.schemastore.org/skills.json",
  "skills": [
    .skills | to_entries[] | {
      name: .key,
      source: .value.source,
      path: .value.skillPath
    }
  ]
}' 