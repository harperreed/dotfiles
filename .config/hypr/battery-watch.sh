#!/bin/bash
# ABOUTME: Watches for AC/battery changes and toggles Hyprland effects
# ABOUTME: Runs as startup daemon, polls every 30s for power state changes

last_status=""

while true; do
    status=$(cat /sys/class/power_supply/BAT0/status)
    if [ "$status" != "$last_status" ]; then
        if [ "$status" = "Discharging" ]; then
            hyprctl keyword decoration:blur:enabled false
            hyprctl keyword decoration:shadow:enabled false
            hyprctl keyword animations:enabled false
        else
            hyprctl keyword decoration:blur:enabled true
            hyprctl keyword decoration:shadow:enabled true
            hyprctl keyword animations:enabled true
        fi
        last_status="$status"
    fi
    sleep 30
done
