#!/bin/bash
# ABOUTME: Fetches current weather for Chicago from wttr.in
# ABOUTME: Used by waybar custom module, outputs JSON format

weather=$(curl -s --max-time 5 "wttr.in/Chicago?format=%c%t" 2>/dev/null | tr -d '+')
tooltip=$(curl -s --max-time 5 "wttr.in/Chicago?format=%C+%t+%w+%h" 2>/dev/null | tr -d '+')

if [ -z "$weather" ] || echo "$weather" | grep -qi "unknown\|sorry\|error"; then
    echo '{"text": "", "class": "hidden"}'
else
    echo "{\"text\": \"$weather\", \"tooltip\": \"$tooltip\"}"
fi
