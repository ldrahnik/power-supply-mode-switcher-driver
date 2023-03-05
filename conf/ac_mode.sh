#!/bin/sh

# set normal display brightness
FILE="/sys/class/backlight/intel_backlight/brightness";
echo "Display brightness change to"
echo "400" | tee $FILE

# intel_pstate
FILE="/sys/devices/system/cpu/intel_pstate"
echo "0" | tee $FILE/no_turbo

# elementary os Power management tool (https://gitlab.freedesktop.org/hadess/power-profiles-daemon)
powerprofilesctl set performance