#!/usr/bin/env bash
# Rewrite .agents/plugins/marketplace.json from .claude-plugin/marketplace.json.
# The Claude Code list is the one people and release automation edit. This copies its plugin
# names and sources (with their pins) into the Codex list and keeps each plugin's Codex-only
# fields (policy, category). A plugin new to the Codex list gets the default policy and the
# "Developer Tools" category; a plugin removed from the Claude Code list is removed here too.
# Usage: bash scripts/sync-codex-marketplace.sh [root]
set -euo pipefail
root="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
claude="$root/.claude-plugin/marketplace.json"
codex="$root/.agents/plugins/marketplace.json"
mkdir -p "$(dirname "$codex")"
[ -f "$codex" ] || echo '{"plugins":[]}' > "$codex"
tmp="$(mktemp)"
jq --indent 2 --slurpfile cx "$codex" '
  ($cx[0].plugins | map({key: .name, value: .}) | from_entries) as $old
  | {name: .name, interface: ($cx[0].interface // {displayName: "Sendbird"}),
     plugins: [.plugins[] | . as $p | ($old[$p.name] // {}) as $o
       | {name: $p.name, source: $p.source,
          policy: ($o.policy // {installation: "AVAILABLE", authentication: "ON_INSTALL"}),
          category: ($o.category // "Developer Tools")}]}' "$claude" > "$tmp"
if cmp -s "$tmp" "$codex"; then rm -f "$tmp"; echo "The Codex list already matches."; exit 0; fi
mv "$tmp" "$codex"; chmod 644 "$codex"
echo "Updated $codex from $claude."
