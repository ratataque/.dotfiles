#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$HOME/.config/"
BACKUP_ROOT="$SCRIPT_DIR/.config-backups"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
TARGET_DIR="$BACKUP_ROOT/$TIMESTAMP/"

mkdir -p "$TARGET_DIR"

RSYNC_FLAGS=(-a -v)

if [[ "${1:-}" != "--apply" ]]; then
  RSYNC_FLAGS+=(-n)
  printf '[dry-run] Use --apply to create the backup snapshot.\n'
fi

rsync "${RSYNC_FLAGS[@]}" "$SOURCE_DIR" "$TARGET_DIR"
printf 'Backup target: %s\n' "$TARGET_DIR"
