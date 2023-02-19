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

AC_MODE_FILE="/usr/share/power_supply_mode_switcher-driver/conf/ac_mode.sh"
BAT_MODE_FILE="/usr/share/power_supply_mode_switcher-driver/conf/bat_mode.sh"

AC_MODE_CONFIG_DIFF=""
if test -f "$AC_MODE_FILE"; then
    AC_MODE_CONFIG_DIFF=$(diff <(grep -v '^#' conf/ac_mode.sh) <(grep -v '^#' $AC_MODE_FILE))
fi

BAT_MODE_CONFIG_DIFF=""
if test -f "$BAT_MODE_FILE"; then
    BAT_MODE_CONFIG_DIFF=$(diff <(grep -v '^#' conf/bat_mode.sh) <(grep -v '^#' $BAT_MODE_FILE))
fi

if [ "$AC_MODE_CONFIG_DIFF" != "" ] || [ "$BAT_MODE_CONFIG_DIFF" != "" ]
then
    read -r -p "Installed config scripts contain modifications compared to the default ones. Do you want remove them for each mode [y/N]" response
    case "$response" in [yY][eE][sS]|[yY])
		rm -rf /usr/share/power_supply_mode_switcher-driver/
		if [[ $? != 0 ]]
		then
			echo "/usr/share/power_supply_mode_switcher-driver/ cannot be removed correctly..."
			exit 1
		fi
        ;;
    *)
		shopt -s extglob
		rm -rf /usr/share/power_supply_mode_switcher-driver/!(conf)
		if [[ $? != 0 ]]
		then
			echo "/usr/share/power_supply_mode_switcher-driver/ cannot be removed correctly..."
			exit 1
		fi
		echo "Config scripts in /usr/share/power_supply_mode_switcher-driver/conf/* have not been removed and remain in system:"
        ls /usr/share/power_supply_mode_switcher-driver/conf
        ;;
    esac
else
	rm -rf /usr/share/power_supply_mode_switcher-driver/
	if [[ $? != 0 ]]
	then
		echo "/usr/share/power_supply_mode_switcher-driver/ cannot be removed correctly..."
		exit 1
	fi
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
