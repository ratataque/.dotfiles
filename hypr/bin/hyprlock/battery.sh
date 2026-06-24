#!/usr/bin/env bash

set -euo pipefail

battery_dir="$(find /sys/class/power_supply -maxdepth 1 -type d -name 'BAT*' | head -n 1 || true)"

if [[ -z "${battery_dir}" ]]; then
    exit 0
fi

capacity="$(cat "${battery_dir}/capacity" 2>/dev/null || true)"
status="$(cat "${battery_dir}/status" 2>/dev/null || true)"

if [[ -z "${capacity}" ]]; then
    exit 0
fi

case "${status}" in
    Charging)
        icon=""
        ;;
    Full)
        icon=""
        ;;
    *)
        if (( capacity >= 90 )); then
            icon=""
        elif (( capacity >= 60 )); then
            icon=""
        elif (( capacity >= 30 )); then
            icon=""
        elif (( capacity >= 10 )); then
            icon=""
        else
            icon=""
        fi
        ;;
esac

printf '%s %s%%\n' "${icon}" "${capacity}"
