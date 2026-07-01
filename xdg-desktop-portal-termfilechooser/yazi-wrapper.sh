#!/bin/sh
set -eu

multiple="$1"
directory="$2"
save="$3"
path="$4"
out="$5"

cmd="/usr/bin/yazi"
termcmd="${TERMCMD:-/usr/bin/footclient}"

if [ -z "${path:-}" ]; then
    path="${HOME:-/tmp}"
fi

run_yazi() {
    command="$termcmd \"$cmd\""
    for arg in "$@"; do
        escaped=$(printf '%s' "$arg" | sed 's/"/\\"/g')
        command="$command \"$escaped\""
    done
    sh -c "$command"
}

if [ "$save" = "1" ]; then
    target="$path"
    dir=$(dirname "$target")
    base=$(basename "$target")

    mkdir -p "$dir"

    while [ -e "$target" ]; do
        target="${dir}/${base}_"
        base="$(basename "$target")"
    done

    printf '%s\n' \
'xdg-desktop-portal-termfilechooser save placeholder

Rename or move this file if you want.
Open/select this file in Yazi to confirm the save target.
If you quit/cancel, this placeholder will be deleted.' > "$target"

    tmpout="$(mktemp /tmp/termfilechooser-save.XXXXXX)"

    run_yazi --chooser-file="$tmpout" "$target"

    if [ -s "$tmpout" ]; then
        selected_file="$(head -n 1 "$tmpout")"
        printf '%s\n' "$selected_file" > "$out"
    else
        rm -f "$target"
    fi

    rm -f "$tmpout"
    exit 0
fi

if [ "$directory" = "1" ]; then
    run_yazi --chooser-file="$out" --cwd-file="$out" "$path"
elif [ "$multiple" = "1" ]; then
    run_yazi --chooser-file="$out" "$path"
else
    run_yazi --chooser-file="$out" "$path"
fi
