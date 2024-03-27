#! /usr/bin/env bash

TERMINAL="kitty"

function tmux_sessions() {
    tmux list-session -F '#S'
}

# theme=~/.config/rofi/tmux/style-1.rasi
theme=~/.config/wofi/config

TMUX_SESSION=$( (tmux_sessions) | wofi --show dmenu -p "󰆍  Tmux" -theme $theme)

if [[ x"new" = x"${TMUX_SESSION}" ]]; then
    $TERMINAL -e tmux -u new-session &
	exit 0
elif [[ -z "${TMUX_SESSION}" ]]; then
    exit 1
else
    $TERMINAL -e tmux -u attach -t "${TMUX_SESSION}" &
	exit 0
fi
