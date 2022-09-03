#!/bin/sh

# set lower display brightness
FILE="/sys/class/backlight/intel_backlight/brightness";
echo "Display brightness change to"
echo "92" | sudo tee $FILE