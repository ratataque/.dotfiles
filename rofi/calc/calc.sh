#! /usr/bin/env bash

theme=~/.config/rofi/launchers/type-6/style-7.rasi

rofi -plugin-path /usr/lib/rofi/ -show calc -modi calc -no-show-match -no-sort -theme $theme -calc-command "echo -n '{result}' | wl-copy"
