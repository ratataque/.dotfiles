#!/bin/bash
#
theme=~/.config/rofi/launchers/type-7/style-7.rasi
# theme=~/.config/rofi/todo/style-1.rasi

rofi -modi TODO:$HOME/.config/rofi/todo/list.sh -show TODO -theme $theme

exit 0
