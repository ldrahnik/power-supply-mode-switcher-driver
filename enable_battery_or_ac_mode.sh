#!/bin/bash

PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

AC=$(cat /sys/class/power_supply/AC0/online)

if [[ $AC = "1" ]]; then
    sh $PARENT_PATH/conf/ac_mode.sh
else
    sh $PARENT_PATH/conf/battery_mode.sh
fi
