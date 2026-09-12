#!/bin/sh
# power-draw: current power draw in watts from BAT0 (sysfs)

BAT=/sys/class/power_supply/BAT0

volts=$(cat "$BAT/voltage_now")
amps=$(cat "$BAT/current_now")

# Some batteries report µV/µA (large numbers), others mV/mA (small numbers).
# Detect scale by magnitude, then compute P = V * I and convert to watts.
awk -v v="$volts" -v a="$amps" 'BEGIN {
    v = (v < 0 ? -v : v)
    a = (a < 0 ? -a : a)
    scale = (v > 100000 || a > 100000) ? 1000000 : 1000
    printf "%.1f\n", (v * a) / (scale * scale)
}'
