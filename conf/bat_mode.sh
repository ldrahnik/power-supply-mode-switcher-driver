#!/bin/sh

# set lower display brightness
FILE="/sys/class/backlight/intel_backlight/brightness";
echo "Display brightness change to"
echo "92" | tee $FILE

# set backlight to lowest level when is backlight enabled and level is set up more intensive
CURRENT_KEYBOARD_BACKLIGHT="$(cat /sys/class/leds/asus::kbd_backlight/brightness)"
if [[ "$CURRENT_KEYBOARD_BACKLIGHT" > 1 ]]; 
then
    echo "1" | tee /sys/class/leds/asus::kbd_backlight/brightness
fi

# intel_pstate
FILE="/sys/devices/system/cpu/intel_pstate"
echo "1" | tee $FILE/no_turbo