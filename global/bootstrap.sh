#!/usr/bin/env bash
# Install the global skill set from global/package.json into every agent (~/ scope).
# experimental_sync has no -g flag, so global installs go through `skills add`.
set -euo pipefail
cd "$(dirname "$0")"

while IFS= read -r skill; do
  [ -n "$skill" ] || continue
  echo "==> $skill"
  npx skills add -g -y "$skill"
done < <(node -p "require('./package.json').skills.join('\n')")

echo "Done. Link global/AGENTS.md into your harness config, e.g.:"
echo "  ln -sfn \"$PWD/AGENTS.md\" ~/.config/opencode/AGENTS.md"
