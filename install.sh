#!/bin/bash

# Checking if the script is runned as root (via sudo or other)
if [[ $(id -u) != 0 ]]; then
    echo "Please run the installation script as root (using sudo for example)"
    exit 1
fi

cp power_supply_mode_switcher.service /etc/systemd/system/
cp power_supply_mode_switcher_suspend.service /etc/systemd/system/

mkdir -p /var/log/power_supply_mode_switcher-driver
mkdir -p /usr/share/power_supply_mode_switcher-driver/conf
cp -r conf /usr/share/power_supply_mode_switcher-driver
cp enable_battery_or_ac_mode.sh /usr/share/power_supply_mode_switcher-driver/
chmod +x /usr/share/power_supply_mode_switcher-driver/enable_battery_or_ac_mode.sh

echo "Installing udev rules to /usr/lib/udev/rules.d/"

cp udev/80-power-supply-mode-switcher.rules /usr/lib/udev/rules.d/
echo "Added 80-power-supply-mode-switcher.rules"

sudo udevadm control --reload-rules
echo "Reloaded udev rules"

systemctl enable power_supply_mode_switcher

if [[ $? != 0 ]]; then
    echo "Something went wrong when enabling the power_supply_mode_switcher.service"
    exit 1
else
    echo "Power supply mode switcher driver service enabled"
fi

systemctl enable power_supply_mode_switcher_suspend

if [[ $? != 0 ]]; then
    echo "Something went wrong when enabling the power_supply_mode_switcher_suspend.service"
    exit 1
else
    echo "Power supply mode switcher driver suspend service enabled"
fi

systemctl restart power_supply_mode_switcher
if [[ $? != 0 ]]; then
    echo "Something went wrong when enabling the power_supply_mode_switcher.service"
    exit 1
else
    echo "Power supply mode switcher driver service started"
fi

systemctl restart power_supply_mode_switcher_suspend
if [[ $? != 0 ]]; then
    echo "Something went wrong when enabling the power_supply_mode_switcher_suspend.service"
    exit 1
else
    echo "Power supply mode switcher driver suspend service started"
fi

exit 0