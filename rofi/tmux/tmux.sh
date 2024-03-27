#! /usr/bin/env bash

TERMINAL="kitty"

function tmux_sessions() {
    tmux list-session -F '#S'
}

theme=~/.config/rofi/launchers/type-6/style-7.rasi

TMUX_SESSION=$( (echo new; tmux_sessions) | rofi  -plugin-path /usr/lib/rofi/ -dmenu -p "󰆍  Tmux" -theme $theme)

if [[ x"new" = x"${TMUX_SESSION}" ]]; then
    $TERMINAL -e tmux -u new-session &
	exit 0
elif [[ -z "${TMUX_SESSION}" ]]; then
    exit 1
else
    $TERMINAL -e tmux -u attach -t "${TMUX_SESSION}" &
	exit 0
fi
