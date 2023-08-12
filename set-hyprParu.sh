#!/bin/bash

#### Check for paru ####
ISParu=/sbin/paru
if [ -f "$ISParu" ]; then 
    echo -e "paru was located, moving on.\n"
    paru -Syu
else 
    echo -e "paru was not located, please install paru. Exiting script.\n"
    exit 
fi

###Check for updates###

paru -Syu

### Check Nvidia card ####
read -n1 -rep 'Do you have an nvidia card ? (y,n)' NVD
if [[ $NVD == "Y" || $NVD == "y" ]]; then
    paru -S --noconfirm hyprland-nvidia
else
     paru -S --noconfirm hyprland-git
fi

### Install all of the above packages ####
read -n1 -rep 'Would you like to install the packages? (y,n)' INST
if [[ $INST == "Y" || $INST == "y" ]]; then
    paru -S --noconfirm xdg-desktop-portal-hyprland
    check_command_status "paru -S xdg-desktop-portal-hyprland-git"
    paru -S --noconfirm hyprpicker-git waybar-hyprland-git dunst nwg-look wf-recorder wlogout wlsunset
    paru -S --noconfirm colord ffmpegthumbnailer gnome-keyring grimblast-git gtk-engine-murrine imagemagick kvantum pamixer playerctl polkit-kde-agent qt5-quickcontrols qt5-quickcontrols2 qt5-wayland qt6-wayland swaybg ttf-font-awesome tumbler ttf-jetbrains-mono ttf-icomoon-feather xdg-desktop-portal-hyprland-git xdotool xwaylandvideobridge-cursor-mode-2-git cliphist qt5-imageformats qt5ct
    paru -S --noconfirm btop cava neofetch noise-suppression-for-voice rofi-lbonn-wayland-git rofi-emoji starship zsh viewnior ocs-url
    paru -S --noconfirm brave-bin file-roller noto-fonts noto-fonts-cjk noto-fonts-emoji thunar thunar-archive-plugin 
    paru -S --noconfirm code code-features code-marketplace
    paru -S --noconfirm catppuccin-gtk-theme-macchiato catppuccin-gtk-theme-mocha papirus-icon-theme sddm-git swaylock-effects-git kvantum kvantum-theme-catppuccin-git
    paru -S --noconfirm obs-studio-rc ffmpeg-obs cef-minimal-obs-rc-bin pipewire pipewire-alsa pipewire-audio pipewire-pulse pipewire-jack wireplumber gst-plugin-pipewire pavucontrol rsync wezterm kitty

     # Clean out other portals
     
    echo -e "Cleaning out conflicting xdg portals...\n"
    paru -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk
fi

### Copy Config Files ###
read -n1 -rep 'Would you like to copy config files? (y,n)' CFG
if [[ $CFG == "Y" || $CFG == "y" ]]; then
    echo -e "Copying config files...\n"
    cd $HOME/Downloads/hyprland-dots/
    rsync -avxHAXP --exclude '.git*' .* ~/
fi

### Enable SDDM Autologin ###
read -n1 -rep 'Would you like to enable SDDM autologin? (y,n)' WIFI
if [[ $WIFI == "Y" || $WIFI == "y" ]]; then
    LOC="/etc/sddm.conf"
    echo -e "The following has been added to $LOC.\n"
    echo -e "[Autologin]\nUser = $(whoami)\nSession=hyprland" | sudo tee -a $LOC
    echo -e "\n"
    echo -e "Enable SDDM service...\n"
    sudo systemctl enable sddm
    sleep 3
fi

### Fonts ###
read -n1 -rep 'Would you like to install fonts? (y,n)' FONTS
if [[ $FONTS == "Y" || $FONTS == "y" ]]; then
mkdir -p $HOME/Downloads/nerdfonts/
cd $HOME/Downloads/
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.1/CascadiaCode.zip
unzip '*.zip' -d $HOME/Downloads/nerdfonts/
rm -rf *.zip
sudo cp -R $HOME/Downloads/nerdfonts/ /usr/share/fonts/
fi

### Script is done ###
echo -e "Script had completed.\n"
echo -e "You can start Hyprland by typing Hyprland (note the capital H).\n"
read -n1 -rep 'Would you like to start Hyprland now? (y,n)' HYP
if [[ $HYP == "Y" || $HYP == "y" ]]; then
    exec Hyprland
else
    exit
fi
