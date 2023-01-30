#!/bin/bash

if [[ $(id -u) != 0 ]]
then
	echo "Please, run this script as root (using sudo for example)"
	exit 1
fi

systemctl stop power_supply_mode_switcher
if [[ $? != 0 ]]
then
	echo "power_supply_mode_switcher.service cannot be stopped correctly..."
	exit 1
fi

systemctl disable power_supply_mode_switcher
if [[ $? != 0 ]]
then
	echo "power_supply_mode_switcher.service cannot be disabled correctly..."
	exit 1
fi

rm -f /lib/systemd/system/power_supply_mode_switcher.service
if [[ $? != 0 ]]
then
	echo "/lib/systemd/system/power_supply_mode_switcher.service cannot be removed correctly..."
	exit 1
fi

rm -rf /usr/share/power_supply_mode_switcher-driver/
if [[ $? != 0 ]]
then
	echo "/usr/share/power_supply_mode_switcher-driver/ cannot be removed correctly..."
	exit 1
fi

rm -rf /var/log/power_supply_mode_switcher-driver
if [[ $? != 0 ]]
then
	echo "/var/log/power_supply_mode_switcher-driver cannot be removed correctly..."
	exit 1
fi

rm -f /usr/lib/udev/rules.d/80-power-supply-mode-switcher.rules
if [[ $? != 0 ]]
then
	echo "/usr/lib/udev/rules.d/80-power-supply-mode-switcher.rules cannot be removed correctly..."
	exit 1
fi

echo "Power supply mode switcher driver uninstalled"
exit 0
