#!/bin/bash

# Schwellenwerte
WARN_HIGH=80       # normale Warnung
WARN_MED=50        # mittlere Warnung
WARN_CRIT=15       # kritische Warnung
WARN_LOW=5         # sehr kritische Warnung

# Batterie auslesen
CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)
STATUS=$(cat /sys/class/power_supply/BAT0/status)

# Statusdateien für Mehrfachwarnungen
WARN_FILE_HIGH="/tmp/battery_warned_high"
WARN_FILE_MED="/tmp/battery_warned_med"
WARN_FILE_CRIT="/tmp/battery_warned_crit"
WARN_FILE_LOW="/tmp/battery_warned_low"

# Sehr kritische Warnung (≤5%)
if [[ "$CAPACITY" -le "$WARN_LOW" && "$STATUS" == "Discharging" && ! -f "$WARN_FILE_LOW" ]]; then
    notify-send -t 15000 "💀 Akku extrem niedrig" "Batterie bei $CAPACITY%"
    touch "$WARN_FILE_LOW"
elif [[ "$CAPACITY" -gt "$WARN_LOW" && -f "$WARN_FILE_LOW" ]]; then
    rm -f "$WARN_FILE_LOW"
fi

# Kritische Warnung (≤15%)
if [[ "$CAPACITY" -le "$WARN_CRIT" && "$CAPACITY" -gt "$WARN_LOW" && "$STATUS" == "Discharging" && ! -f "$WARN_FILE_CRIT" ]]; then
    notify-send -t 10000 "🚨 Akku kritisch" "Batterie bei $CAPACITY%"
    touch "$WARN_FILE_CRIT"
elif [[ "$CAPACITY" -gt "$WARN_CRIT" && -f "$WARN_FILE_CRIT" ]]; then
    rm -f "$WARN_FILE_CRIT"
fi

# Mittlere Warnung (≤50%)
if [[ "$CAPACITY" -le "$WARN_MED" && "$CAPACITY" -gt "$WARN_CRIT" && "$STATUS" == "Discharging" && ! -f "$WARN_FILE_MED" ]]; then
    notify-send -t 7000 "⚠️ Akku niedrig" "Batterie bei $CAPACITY%"
    touch "$WARN_FILE_MED"
elif [[ "$CAPACITY" -gt "$WARN_MED" && -f "$WARN_FILE_MED" ]]; then
    rm -f "$WARN_FILE_MED"
fi

# Normale Warnung (≤80%)
if [[ "$CAPACITY" -le "$WARN_HIGH" && "$CAPACITY" -gt "$WARN_MED" && "$STATUS" == "Discharging" && ! -f "$WARN_FILE_HIGH" ]]; then
    notify-send -t 5000 "⚠️ Akku niedrig" "Batterie bei $CAPACITY%"
    touch "$WARN_FILE_HIGH"
elif [[ "$CAPACITY" -gt "$WARN_HIGH" && -f "$WARN_FILE_HIGH" ]]; then
    rm -f "$WARN_FILE_HIGH"
fi

if [[ "$STATUS" == "Charging" ]]; then
    rm -f "$WARN_FILE_HIGH" "$WARN_FILE_MED" "$WARN_FILE_CRIT" "$WARN_FILE_LOW"
fi
