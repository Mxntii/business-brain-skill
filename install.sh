#!/usr/bin/env bash
set -euo pipefail

COMMANDS_DIR=".claude/commands"
COMMAND_NAME="setup-business-brain.md"
LEGACY=false

usage() {
  cat <<'EOF'
Install the /setup-business-brain command.

Usage:
  ./install.sh
  ./install.sh --commands-dir /path/to/.claude/commands
  ./install.sh --legacy

Options:
  --commands-dir PATH   Override the install destination directory.
  --legacy              Force the legacy single-file download path.
  -h, --help            Show this help.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --commands-dir)
      COMMANDS_DIR="$2"
      shift 2
      ;;
    --legacy)
      LEGACY=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

mkdir -p "$COMMANDS_DIR"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$COMMANDS_DIR/$COMMAND_NAME"
RAW_URL="https://raw.githubusercontent.com/Mxntii/business-brain-skill/main/setup-business-brain.md"

if [[ -f "$SCRIPT_DIR/$COMMAND_NAME" && "$LEGACY" == false ]]; then
  cp "$SCRIPT_DIR/$COMMAND_NAME" "$TARGET"
  echo "Installed $TARGET from local checkout."
else
  curl -fsSL "$RAW_URL" -o "$TARGET"
  echo "Installed $TARGET from GitHub."
fi

cat <<EOF

Next:
1. Open Claude Code in the directory where you want the vault.
2. Run: /setup-business-brain
3. Follow the 5-question setup.
EOF

