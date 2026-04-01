#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

"$REPO_ROOT/scripts/build-command.sh" >/dev/null

ARTIFACT="$REPO_ROOT/setup-business-brain.md"
README="$REPO_ROOT/README.md"

grep -q '\.business-brain\.json' "$ARTIFACT"
grep -q 'Memory/' "$ARTIFACT"
grep -q 'vault-roles\.yaml' "$ARTIFACT"
grep -q 'build-vaults\.sh' "$ARTIFACT"

if grep -q 'sensitivity: open' "$ARTIFACT"; then
  echo "Found deprecated sensitivity value in artifact." >&2
  exit 1
fi

if grep -q 'PRIVATE | Restricted' "$ARTIFACT"; then
  echo "Found deprecated PRIVATE/OPEN tier language in artifact." >&2
  exit 1
fi

grep -qi 'bootstrap install' "$README"
grep -qi 'manual single-file fallback' "$README"
grep -qi 'generated only when enabled' "$README"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

"$REPO_ROOT/install.sh" --commands-dir "$TMP_DIR/.claude/commands" >/dev/null
test -f "$TMP_DIR/.claude/commands/setup-business-brain.md"

"$REPO_ROOT/install.sh" --legacy --commands-dir "$TMP_DIR/.claude/legacy-commands" >/dev/null
test -f "$TMP_DIR/.claude/legacy-commands/setup-business-brain.md"

echo "Validation passed."
