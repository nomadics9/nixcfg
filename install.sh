#!/usr/bin/env bash
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
ENDCOLOR="\e[0m"
echo -e " $YELLOW
 _   _  ___  __  __    _    ____    _   _ _____  _____  ____    ___ _   _ ____ _____  _    _     _     _____ ____  
| \ | |/ _ \|  \/  |  / \  |  _ \  | \ | |_ _\ \/ / _ \/ ___|  |_ _| \ | / ___|_   _|/ \  | |   | |   | ____|  _ \ 
|  \| | | | | |\/| | / _ \ | | | | |  \| || | \  / | | \___ \   | ||  \| \___ \ | | / _ \ | |   | |   |  _| | |_) |
| |\  | |_| | |  | |/ ___ \| |_| | | |\  || | /  \ |_| |___) |  | || |\  |___) || |/ ___ \| |___| |___| |___|  _ < 
|_| \_|\___/|_|  |_/_/   \_\____/  |_| \_|___/_/\_\___/|____/  |___|_| \_|____/ |_/_/   \_\_____|_____|_____|_| \_\

$ENDCOLOR
                                 $BLUE https://github.com/nomadics9 $ENDCOLOR
           $RED TO MAKE SURE EVERYTHING RUNS CORRECTLY $ENDCOLOR $GREEN RUN AS ROOT '"sudo bash install.sh"' $ENDCOLOR 
"
echo 
echo

# Define the flake file path
flake_file="./flake.nix"
config_file="./hosts/unkown/configuration.nix"  # Specify the correct path for your host's configuration file
monitor_config_file="./home/nomad/unkown.nix"

# Prompt for username and hostname
read -p "Enter the new username: " new_user
read -p "Enter the new hostname: " new_hostname

# Replace the 'user' and 'hostname' values in the flake.nix file
sed -i "s/user = \".*\";/user = \"$new_user\";/" "$flake_file"
sed -i "s/hostname = \".*\";/hostname = \"$new_hostname\";/" "$flake_file"

# Function to handle yes/no or y/n input
ask_yes_no() {
    while true; do
        read -p "$1 (yes/no): " response
        case $response in
            [Yy]* ) echo "true"; break;;
            [Nn]* ) echo "false"; break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}


update_monitor_config() {
    # If the device is a laptop, keep eDP-1
    if [[ "$laptop_response" == "true" ]]; then
        monitor_config="\"eDP-1,1920x1080@60,0x0,1\""
        workspace_config="monitor:eDP-1"
    else
        # If it's not a laptop, change it to DP-1
        monitor_config="\"DP-1,1920x1080@60,0x0,1\""
        workspace_config="monitor:DP-1"
    fi

    # Replace the monitor configuration in the monitor configuration file
    sed -i "/monitor = \[/!b;n;c\        $monitor_config" "$monitor_config_file"
    # Replace the workspace configuration in the monitor configuration file
    sed -i "s/monitor:eDP-1/$workspace_config/g" "$monitor_config_file"
}



# Ask if the device is using Nvidia
nvidia_response=$(ask_yes_no "Is this device using Nvidia")
sed -i "s/hardware.nvidia.enable = .*/hardware.nvidia.enable = $nvidia_response;/" "$config_file"

# Ask if the device is a laptop
laptop_response=$(ask_yes_no "Is this device a laptop")
sed -i "s/hardware.battery.enable = .*/hardware.battery.enable = $laptop_response;/" "$config_file"
update_monitor_config

# Ask if the user wants Steam and Flatpak
steam_response=$(ask_yes_no "Do you want Steam to be enabled")
sed -i "s/common.services.steam.enable = .*/common.services.steam.enable = $steam_response;/" "$config_file"

flatpak_response=$(ask_yes_no "Do you want Flatpak to be enabled")
sed -i "s/services.flatpak.enable = .*/services.flatpak.enable = $flatpak_response;/" "$config_file"

vm_response=$(ask_yes_no "Do you want vm and virtmanager to be enabled")
sed -i "s/common.services.vm.enable = .*/common.services.vm.enable = $vm_response;/" "$config_file"


# Notify the user that the changes are complete
echo -e "$GREEN Configuration has been updated with your preferences $ENDCOLOR"
echo -e "$YELLOW Copying your hardware configurations $ENDCOLOR" 

 cp /etc/nixos/hardware-configuration.nix ./hosts/unkown/hardware-configuration.nix
 sleep 2
 sudo nixos-rebuild boot --flake .#unkown

 echo -e "$GREEN Reboot after completion your initial password is 4321 $ENDCOLOR"

