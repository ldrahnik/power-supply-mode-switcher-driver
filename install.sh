#!/bin/bash

# Checking if the script is runned as root (via sudo or other)
if [[ $(id -u) != 0 ]]; then
    echo "Please run the installation script as root (using sudo for example)"
    exit 1
fi

cp power_supply_mode_switcher.service /etc/systemd/system/

mkdir -p /var/log/power_supply_mode_switcher-driver
mkdir -p /usr/share/power_supply_mode_switcher-driver/conf
cp enable_bat_or_ac_mode.sh /usr/share/power_supply_mode_switcher-driver/
chmod +x /usr/share/power_supply_mode_switcher-driver/enable_bat_or_ac_mode.sh

AC_MODE_FILE='/usr/share/power_supply_mode_switcher-driver/conf/ac_mode.sh'
BAT_MODE_FILE='/usr/share/power_supply_mode_switcher-driver/conf/bat_mode.sh'

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
    read -r -p "Overwrite existing config scripts for each mode [y/N]" response
    case "$response" in [yY][eE][sS]|[yY])
        echo "Used default config files. Config may be edited here /usr/share/power_supply_mode_switcher-driver/conf"
        cp -r conf /usr/share/power_supply_mode_switcher-driver    
        ;;
    *)
        echo "Used last config files."
        ;;
    esac
else
    echo "Used default config files. Config may be edited here /usr/share/power_supply_mode_switcher-driver/conf"
    cp -r conf /usr/share/power_supply_mode_switcher-driver
fi

echo "Installing udev rules to /usr/lib/udev/rules.d/"

cp udev/80-power-supply-mode-switcher.rules /usr/lib/udev/rules.d/
echo "Added 80-power-supply-mode-switcher.rules"

udevadm control --reload-rules
echo "Reloaded udev rules"

systemctl enable power_supply_mode_switcher

if [[ $? != 0 ]]; then
    echo "Something went wrong when enabling the power_supply_mode_switcher.service"
    exit 1
else
    echo "Power supply mode switcher driver service enabled"
fi

systemctl restart power_supply_mode_switcher
if [[ $? != 0 ]]; then
    echo "Something went wrong when enabling the power_supply_mode_switcher.service"
    exit 1
else
    echo "Power supply mode switcher driver service started"
fi

exit 0