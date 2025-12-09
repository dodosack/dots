#!/bin/bash

STATE_FILE="$HOME/.config/hypr/local/own-scripts/current_theme"


themes=("theme_default" "theme_no_border" "theme_wide_no_border")

theme_default() {
    hyprctl --batch "
      hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"\
    notify-send "Gamemode activated" "Animations and blur disabled"\
   
    "
hyprctl reload
}

theme_no_border() {
    hyprctl --batch "
    keyword general:border_size 0;
    keyword general:gaps_out 4;
    keyword general:gaps_in 4;
    keyword general:col.active_border 0;
    keyword general:col.inactive_border 0.8;
    "
}

theme_wide_no_border() {
        hyprctl --batch "
    keyword general:border_size 0;
    keyword general:gaps_out 20;
    keyword general:gaps_in 20;
    keyword general:col.active_border 0;
    keyword general:col.inactive_border 0.8;
    "
}


if [ ! -f "$STATE_FILE" ]; then
    echo 0 > "$STATE_FILE"
fi

current=$(cat "$STATE_FILE")
echo "Current index read: $current"
next=$(( (current + 1) % ${#themes[@]} ))
echo "Next index calculated: $next"
echo "Applying theme: ${themes[$next]}"

"${themes[$next]}"

echo $next > "$STATE_FILE"
echo "New index saved: $next"

notify-send -t 1000 "Hyprland Theme" "Switched to: ${themes[$next]}"
