#!/bin/bash

PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

AC=$(cat /sys/class/power_supply/AC0/online)

if [[ $AC = "1" ]]; then
    echo $(date -u) "Enabling ac mode"
    sh $PARENT_PATH/conf/ac_mode.sh
else
    echo $(date -u) "Enabling battery mode"
    sh $PARENT_PATH/conf/bat_mode.sh
fi
