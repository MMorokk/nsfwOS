#!/bin/bash

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White

# Ensure script is not run as root
if [ "$EUID" -eq 0 ]; then
    echo "Do not run this script as root. Run as a normal user."
    exit 1
fi

# System packages
sudo pacman -S --noconfirm git
sudo pacman -S --noconfirm --needed base-devel

# Install paru (AUR helper) if not already installed
if ! which paru > /dev/null 2>&1; then
    echo "Installing paru..."
    git clone https://aur.archlinux.org/paru.git "$HOME/paru"
    cd "$HOME/paru"
    makepkg -si --noconfirm
    if [[ $? -ne 0 ]]; then
        printf "${BRed}ERROR WHILE INSTALLING PARU${Color_Off}"
        exit 1
    fi
    cd "$OLDPWD"
    rm -rf "$HOME/paru"
else
    echo "paru is already installed."
fi


# Check for NVIDIA GPU
if sudo lspci | grep -i nvidia > /dev/null; then
    echo "NVIDIA graphics card detected:"
    nvidia_info=$(lspci | grep -i nvidia | head -n 1)
    echo "$nvidia_info"
    echo ""

    # Prompt for driver choice
    echo "Which NVIDIA driver would you like to use?"
    echo -e "1) nvidia (proprietary driver - best performance and recommended) ${BGreen}[DEFAULT]${Color_Off}"
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
    echo -e "${Cyan}No NVIDIA graphics card was detected on this system.${BGreen}(Its good)${Color_Off}"
    echo -e "      ${Red}If you have NVIDIA graphics and still see this message please submit an issue on github.${Color_Off}"
    echo "Your graphics hardware:"
    lspci | grep -E 'VGA|3D|Display' | sed 's/^[^:]*: //'
    sleep 5
fi

printf "${Cyan}Installing fonts...${Color_Off}\n"
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
                    nerd-fonts

printf "${Cyan}Installing hyprland and related packages...${Color_Off}\n"
paru -S uwsm \
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
        hyprutils-git \
        hyprlang-git \
        hyprland-qtutils-git \
        aquamarine-git \
        rofi-wayland \
        wl-clip-persist-git \
        hypridle-git \
        nwg-look \
        qt5ct \
        qt6ct \
        qt4 \
        fnott \
        hyprland-qt-support-git \
        sddm-git

printf "${Cyan}Making sure pipewire installed properly...${Color_Off}\n"
paru -S --noconfirm pipewire \
                    lib32-pipewire \
                    wireplumber

printf "${Cyan}Neovim related stuff...${Color_Off}\n"
paru -S --noconfirm luarocks \
                    unzip \
                    imagemagick \
                    freetype2 \
                    pixman \
                    libpng

# Enable hypridle service
systemctl --user enable --now hypridle.service
# Enable polkit agent
systemctl --user enable --now hyprpolkitagent.service

# Hyprland plugins
hyprpm add https://github.com/pyt0xic/hyprfocus
hyprpm enable hyprfocus
hyprpm add https://github.com/hyprwm/hyprland-plugins
hyprpm enable csgo-vulkan-fix
hyprpm reload

# some code here

# Dotfiles installation
git clone https://github.com/MMorokk/.dotfiles $HOME/.dotfiles
bash $HOME/.dotfiles/install.sh
