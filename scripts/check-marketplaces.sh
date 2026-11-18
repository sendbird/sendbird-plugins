#!/usr/bin/env bash
# Claude Code reads .claude-plugin/marketplace.json; Codex reads .agents/plugins/marketplace.json
# when it exists and then ignores the Claude Code file. Both must list the same plugins with the
# same source and pin, or Codex users would install a different release than Claude Code users.
# Run it before you push a change to either file: bash scripts/check-marketplaces.sh [root]
set -euo pipefail
root="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
claude="$root/.claude-plugin/marketplace.json"
codex="$root/.agents/plugins/marketplace.json"
pick='[.plugins[] | {name, source}] | sort_by(.name)'
if [ "$(jq -c "$pick" "$claude")" != "$(jq -c "$pick" "$codex")" ]; then
  echo "The plugin lists differ. Change .claude-plugin/marketplace.json and .agents/plugins/marketplace.json together:" >&2
  diff <(jq "$pick" "$claude") <(jq "$pick" "$codex") >&2 || true
  exit 1
fi
[ "$(jq -r .name "$claude")" = "$(jq -r .name "$codex")" ] || { echo "The marketplace names differ." >&2; exit 1; }
missing="$(jq -r '.plugins[] | select(.policy.installation == null or .policy.authentication == null or .category == null) | .name' "$codex")"
[ -z "$missing" ] || { echo "Codex entries need policy.installation, policy.authentication, and category: $missing" >&2; exit 1; }
echo "Both marketplace files list the same $(jq '.plugins | length' "$claude") plugins with the same sources."
