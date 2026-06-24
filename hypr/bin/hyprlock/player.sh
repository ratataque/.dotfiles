#!/usr/bin/env bash

set -euo pipefail

field="${1:-}"

if ! command -v playerctl >/dev/null 2>&1; then
    exit 0
fi

case "${field}" in
    --arturl)
        playerctl metadata mpris:artUrl 2>/dev/null || true
        ;;
    --title)
        playerctl metadata title 2>/dev/null || true
        ;;
    --status)
        playerctl status 2>/dev/null || true
        ;;
    --source)
        playerctl metadata --format '{{ playerName }}' 2>/dev/null || true
        ;;
    --album)
        playerctl metadata album 2>/dev/null || true
        ;;
    --artist)
        playerctl metadata artist 2>/dev/null | head -n 1 || true
        ;;
    *)
        exit 1
        ;;
esac
