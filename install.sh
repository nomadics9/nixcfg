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

# Prompt for username and hostname
read -p "Enter the new username: " new_user
read -p "Enter the new hostname: " new_hostname

# Define the flake file path and current user
flake_file="./flake.nix"
config_file="./hosts/$new_hostname/configuration.nix"
monitor_config_file="./home/$new_user/$new_hostname.nix"
current_user=$(logname)

# Check if source files exist
if [[ ! -f "./hosts/common/users/nomad.nix" && ! -d "./hosts/unkown/" ]]; then
  echo -e "$RED Source files nomad.nix or ./hosts/unkown directory does not exist! $ENDCOLOR"
  exit 1
fi

# Function to copy and configure the home.nix file for the user and hostname
setup_home_configuration() {
    local user_dir="./home/$new_user/$new_hostname"

    if [ ! -d "$user_dir" ]; then
        mkdir -p "$user_dir"
    fi

    # Copy the home.nix file and update the hostname path inside
    cp "./home/nomad/unkown/home.nix" "$user_dir/home.nix"
    cp "./home/nomad/unkown.nix" "./home/$new_user/$new_hostname.nix"
    cp -r "./home/nomad/dotfiles/" "./home/$new_user/"
    sed -i "s|unkown|$new_hostname|g" "./home/$new_user/$new_hostname.nix"

    chown -R $current_user:users "./home/$new_user"
    echo -e "$GREEN Home configuration for $new_user created and updated with hostname $new_hostname! $ENDCOLOR"
}

# Function to create or overwrite host configuration
setup_host_configuration() {
    if [ -d "./hosts/$new_hostname" ]; then
        read -p "Directory $new_hostname already exists. Overwrite contents? (y/n) " choice
        if [[ "$choice" != "y" && "$choice" != "yes" ]]; then
            echo -e "$YELLOW Skipping host configuration for $new_hostname... $ENDCOLOR"
            return
        fi
        echo -e "$YELLOW Overwriting Host configuration for $new_hostname... $ENDCOLOR"
        rm -r "./hosts/$new_hostname"
    else
        echo -e "$YELLOW Creating Host configuration for $new_hostname... $ENDCOLOR"
    fi

    cp -r "./hosts/unkown" "./hosts/$new_hostname"
    chown -R $current_user:users "./hosts/$new_hostname"
    echo -e "$GREEN Host configuration for $new_hostname created successfully! $ENDCOLOR"
}

# Function to create or overwrite user configuration
setup_user_configuration() {
    if [ -f "./hosts/common/users/$new_user.nix" ]; then
        read -p "File $new_user.nix already exists. Overwrite? (y/n) " choice
        if [[ "$choice" != "y" && "$choice" != "yes" ]]; then
            echo -e "$YELLOW Skipping user configuration for $new_user... $ENDCOLOR"
            return
        fi
        echo -e "$YELLOW Overwriting User configuration for $new_user... $ENDCOLOR"
    else
        echo -e "$YELLOW Creating User configuration for $new_user... $ENDCOLOR"
    fi

    cp "./hosts/common/users/nomad.nix" "./hosts/common/users/$new_user.nix"
    chown $current_user:users "./hosts/common/users/$new_user.nix"
    echo -e "$GREEN User configuration for $new_user created successfully! $ENDCOLOR"
}

# Call the functions to create configurations
setup_host_configuration
setup_user_configuration
setup_home_configuration

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

echo -e "$YELLOW Recommended to not enable vfio unless you know what you are doing $ENDCOLOR"
vfio_response=$(ask_yes_no "Do you want GPU-Passthrough to be enabled")
sed -i "s/common.services.vfio.enable = .*/common.services.vfio.enable = $vfio_response;/" "$config_file"


echo -e "$YELLOW If you want to use your repo make sure to fork mine to keep the same structure for hyprland stuff $ENDCOLOR"
read -p "Do you have a dotfiles URL? (y/n): " has_dotfiles
if [[ "$has_dotfiles" == "y" || "$has_dotfiles" == "yes" ]]; then
  read -p "Please paste the dotfiles URL: " dotfiles_url

  # Check if dotfiles URL is valid (basic check for http or git protocol)
  if [[ "$dotfiles_url" =~ ^(http|https|git):// ]]; then
    echo "Updating flake.nix with the new dotfiles URL..."

    # Use sed to replace the existing dotfiles URL with the new one
    sed -i "/dotfiles = {/,/};/s|url = \".*\";|url = \"$dotfiles_url\";|" "$flake_file"
    sleep 0.3
    nix flake lock --update-input dotfiles
    echo "flake.nix updated successfully!"
  else
    echo -e "$RED Invalid URL format. Please make sure to enter a valid git URL. $ENDCOLOR"
  fi
else
  echo -e "$GREEN Using Nomadics dotfiles $ENDCOLOR"
fi


# Notify the user that the changes are complete
echo -e "$GREEN Configuration has been updated with your preferences $ENDCOLOR"

 sleep 2
 git add .
 chown 
 nixos-rebuild switch --flake .#unkown

 echo -e "$GREEN Reboot after completion your initial password is 4321 $ENDCOLOR"

