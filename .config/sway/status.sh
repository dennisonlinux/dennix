#!/usr/bin/env zsh

# Send the standard i3bar protocol header
echo '{"version":1}'
echo '['
echo '[]'

while true; do
    # 1. NixOS Logo (Pine: #3e8fb0)
    LOGO='{"full_text": " NixOS", "color": "#3e8fb0"}'

    # 2. Battery Widget (Gold: #f6c177)
    BATTERY='{"full_text": ""}'
    bat_path=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n 1)
    if [ -n "$bat_path" ] && [ -f "$bat_path/capacity" ]; then
        bat_status=$(cat "$bat_path/status" 2>/dev/null)
        bat_capacity=$(cat "$bat_path/capacity" 2>/dev/null)
        
        if [ "$bat_status" = "Charging" ]; then
            bat_icon="󱐋 "
        else
            bat_icon=""
        fi
        if [ -n "$bat_capacity" ]; then
            BATTERY='{"full_text": "[ '"$bat_icon"' '"$bat_capacity"'% ]", "color": "#f6c177"}'
        fi
    fi

    # 3. Time Widget (Iris: #c4a7e7)
    time_string=$(date +'%Y-%m-%d 󱑎 %H:%M:%S')
    TIME='{"full_text": "󰃭 '"$time_string"'", "color": "#c4a7e7"}'

    # 4. Power Menu Reminders (Love: #eb6f92)
    POWER='{"full_text": "[ 󰍃 Exit | 󰑓 Reboot | 󰐥 Poweroff ]", "color": "#eb6f92"}'

    # Output the JSON array
    echo ",[$LOGO, $BATTERY, $TIME, $POWER]"

    sleep 1
done
