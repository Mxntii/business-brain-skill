#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SRC_DIR="$REPO_ROOT/src"
OUT_FILE="$REPO_ROOT/setup-business-brain.md"

PARTS=(
  "00-overview.md"
  "10-preflight.md"
  "20-interview.md"
  "30-confirmation.md"
  "40-generation.md"
  "50-completion.md"
)

{
  printf '<!-- AUTO-GENERATED FILE. Edit src/*.md and run scripts/build-command.sh. -->\n\n'
  for part in "${PARTS[@]}"; do
    cat "$SRC_DIR/$part"
    printf '\n'
  done
} > "$OUT_FILE"

echo "Wrote $OUT_FILE"

