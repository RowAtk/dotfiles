sudo pacman -Syu --noconfirm

#base
echo -e "\n\n-------------------------------BASE PACKAGES-------------------------------------"
sudo pacman -S --noconfirm intel-ucode base-devel git linux-lts pulseaudio tint2 tlp arandr

# utility
echo -e "\n\n-------------------------------UTILITY PACKAGES-------------------------------------"
yay -S --noconfirm picom-git feh rxvt-unicode alacritty xterm volctl bpytop-git xfce4-power-manager htop pcmanfm gvfs xed

# applications
echo -e "\n\n-------------------------------APP PACKAGES-------------------------------------"
yay -S --noconfirm firefox-developer-edition geany discord google-chrome chromium spotify-dev libreoffice-still gimp thunderbird

#dev
echo -e "\n\n-------------------------------DEV PACKAGES-------------------------------------"
yay -S --noconfirm code nvm intellij-idea-community-edition postgresql postman-bin docker pgadmin4 jdk

#thematic
echo -e "\n\n-------------------------------THEMATIC PACKAGES-------------------------------------"
yay -S --noconfirm papirus-icon-theme-git

#multilib
echo -e "\n\n-------------------------------GAME PACKAGES-------------------------------------"
yay -S --noconfirm steam steam-fonts
