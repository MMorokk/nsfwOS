#!/bin/bash

# Ensure script is not run as root
if [ "$EUID" -eq 0 ]; then
    echo "Do not run this script as root. Run as a normal user."
    exit 1
fi

# System packages
sudo pacman -S --noconfirm uwsm kitty git
sudo pacman -S --noconfirm --needed base-devel

# Install paru (AUR helper)
git clone https://aur.archlinux.org/paru.git "$HOME/paru"
cd "$HOME/paru"
makepkg -si --noconfirm
cd ..
rm -rf "$HOME/paru"

# Hyprland and related packages
paru -S --noconfirm xdg-desktop-portal-hyprland-git hyprpolkitagent-git qt6-wayland qt5-wayland eww-git hyprpaper-git wl-clipboard-rs-git hyprlock-git hyprsunset hyprcursor-git hyprutil-git hyprlang-git hyprland-qtutils-git aquamarine-git rofi-wayland wl-clip-persist-git

# Enable hypridle service
systemctl --user enable --now hypridle.service

# Fnott and dependencies
paru -S --noconfirm fnott freetype2 pixman libpng

# Vesktop installation prompt
shopt -s nocasematch
read -p "Do you want to install Vesktop? (Y/n): " response

if [[ "$response" =~ ^(yes|y)$ ]]; then
    paru -S --noconfirm vesktop
else
    echo "Skipping vesktop installation."
fi

shopt -u nocasematch
