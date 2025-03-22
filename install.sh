#!/bin/bash

# Ensure script is not run as root
if [ "$EUID" -eq 0 ]; then
    echo "Do not run this script as root. Run as a normal user."
    exit 1
fi

# Vesktop installation prompt
shopt -s nocasematch
read -p "Do you want to install Vesktop? (Y/n): " response

if [[ "$response" =~ ^(yes|y)$ ]]; then
    vesktop_toggle = true
else
    vesktop_toggle = false
fi

shopt -u nocasematch

# System packages
sudo pacman -S --noconfirm git
sudo pacman -S --noconfirm --needed base-devel

# Install paru (AUR helper)
git clone https://aur.archlinux.org/paru.git "$HOME/paru"
cd "$HOME/paru"
makepkg -si --noconfirm
cd ..
rm -rf "$HOME/paru"

# Check for NVIDIA GPU
if [sudo lspci | grep -i nvidia > /dev/null]; then
    echo "NVIDIA graphics card detected:"
    nvidia_info=$(lspci | grep -i nvidia | head -n 1)
    echo "$nvidia_info"
    echo ""

    # Prompt for driver choice
    echo "Which NVIDIA driver would you like to use?"
    echo "1) nvidia (proprietary driver - best performance and recommended) [DEFAULT]"
    echo "2) nvidia-open (open source version of the proprietary driver)"
    echo "3) nouveau (fully open source driver - may have limited performance)"

    read -p "Enter your choice (1-3): " choice
    echo ""

    case "$choice" in
        1)
            echo "You've selected the proprietary NVIDIA driver."
            paru -S --noconfirm nvidia-dkms nvidia-utils nvidia-settings
            ;;
        2)
            echo "You've selected the NVIDIA open source driver."
            paru -S --noconfirm nvidia-open-dkms nvidia-utils nvidia-settings
            ;;
        3)
            echo "You've selected the Nouveau driver."
            paru -S --noconfirm xf86-video-nouveau mesa
            ;;
        *)
            echo "Installing recommended nvidia (proprietary driver - best performance and recommended)"
            paru -S --noconfirm nvidia-dkms nvidia-utils nvidia-settings
            ;;
    esac

    echo ""
    echo "After installation, reboot your system for changes to take effect."
else
    echo "No NVIDIA graphics card was detected on this system.(Its good)"
    echo "      If you have NVIDIA graphics and still see this message please submit an issue on github."
    echo "Your graphics hardware:"
    lspci | grep -E 'VGA|3D|Display' | sed 's/^[^:]*: //'
fi

# Hyprland and related packages
paru -S --noconfirm ttf-cm-unicode \
                    otf-cm-unicode \
                    otf-latin-modern \
                    otf-latinmodern-math \
                    gnu-free-fonts \
                    ttf-arphic-uming \
                    ttf-indic-otf \
                    ttf-symbola-free \
                    otf-openmoji \
                    ttf-noto-emoji-monochrome \
                    noto-fonts \
                    noto-fonts-cjk \
                    noto-fonts-emoji \
                    noto-fonts-extra \
                    nerd-fonts \
                    uwsm \
                    kitty \
                    hyprland-git \
                    xdg-desktop-portal-hyprland-git \
                    hyprpolkitagent-git \
                    qt6-wayland \
                    qt5-wayland \
                    eww-git \
                    hyprpaper-git \
                    wl-clipboard-rs-git \
                    hyprlock-git \
                    hyprsunset \
                    hyprcursor-git \
                    hyprutil-git \
                    hyprlang-git \
                    hyprland-qtutils-git \
                    aquamarine-git \
                    rofi-wayland \
                    wl-clip-persist-git \
                    hypridle-git \
                    nwg-look \
                    qt5ct \
                    qt6ct \
                    qt4ct


# Enable hypridle service
systemctl --user enable --now hypridle.service

# Fnott and dependencies
paru -S --noconfirm fnott freetype2 pixman libpng

#Toggles
if [$vesktop == true]; then
    paru -S --noconfirm vesktop-bin
fi
git clone https://github.com/MMorokk/.dotfiles $HOME/.dotfiles
cd $HOME/.dotfiles
bash install.sh
