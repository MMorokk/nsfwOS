#! /bin/bash
sudo pacman -S uwsm kitty git
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git $HOME/paru
cd $HOME/paru
makepkg -si
rm -rf $HOME/paru
# Docs for eww: https://elkowar.github.io/eww/configuration.html
paru -S xdg-desktop-portal-hyprland-git hyprpolkitagent-git qt6-wayland qt5-wayland eww-git hyprpaper-git wl-clipboard-rs-git hyprlock-git hyprsunset hyprcursor-git hyprutil-git hyprlang-git hyprland-qtutils-git aquamarine-git rofi-wayland wl-clip-persist-git
systemctl --user enable --now hypridle.service

# Fnott docs:
# https://codeberg.org/dnkl/fnott
# https://codeberg.org/dnkl/fnott/src/branch/master/doc/fnott.ini.5.scd
paru -S fnott freetype2 pixman libpng # Dependencies for fnott

# Vesktop
shopt -s nocasematch
read -p "Do you want to install Vesktop? (Y/n): " response
if [[ "$response" =~ ^(no|n)$ ]]; then
    echo "Skipping vesktop installation."
else
    paru -S vesktop
fi
shopt -u nocasematch
