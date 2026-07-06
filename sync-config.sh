#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$HOME/.config/"
TARGET_DIR="$SCRIPT_DIR/"
EXCLUDES_FILE="$SCRIPT_DIR/.rsync-config-excludes"

if [[ ! -f "$EXCLUDES_FILE" ]]; then
  printf 'Missing excludes file: %s\n' "$EXCLUDES_FILE" >&2
  exit 1
fi

RSYNC_FLAGS=(
  -a
  -v
  --exclude-from="$EXCLUDES_FILE"
)

if [[ "${1:-}" != "--apply" ]]; then
  RSYNC_FLAGS+=(-n)
  printf '[dry-run] Use --apply to perform the sync.\n'
fi

rsync "${RSYNC_FLAGS[@]}" "$SOURCE_DIR" "$TARGET_DIR"
