## -*- mode: shell-script; sh-shell: bash;
# Arch-only stuff. Abort if not Arch.
is_arch || return 1

# Update the keying (to avoid signing issues) and then update the whole system
# https://wiki.archlinux.org/title/Pacman/Package_signing#Upgrade_system_regularly
e_header "Updating via Pacman"
sudo pacman -Sqy --needed archlinux-keyring &&
    sudo pacman -Squ || \
        e_header "Failed to update Arch system. Exiting." && return 1


# Install APT packages.
packages=(
#  acpilight
#  alacritty
  alsa-utils
  autoconf
  automake
#  bind
#  brightnessctl
  cmake
#  efibootmgr
  emacs-nativecomp
  eog
  firefox
  fish
  fisher
  htop
  i3-wm
  iotop
  j4-dmenu-desktop
  kitty
  libvterm
  make
  man-db
  mtr
  nano
  ncdu
#  network-manager-applet
  obsidian
  patch
  pkgconf
  py3status
  pyright
  redshift
  rofi
#  smartmontools
  starship
  syncthing
  thunar
  tree
  vlc
  xorg-server
  xorg-xinit
  xorg-xinput
  zsh
)

e_header "Installing Arch packages: ${packages[*]}"
sudo pacman -Sq --needed "${packages[@]}"

e_header "Installing Yay AUR Helper"
(
    cd $TMP
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si
)

aur_packages=(
  1password
  dmenu-frecency-git
  google-chrome
  nordvpn-bin
  spideroak-one
  syncthing-gtk
)

if type "yay" > /dev/null; then
    e_header "Installing AUR packages via yay: ${packages[*]}"
    yay -S --needed "${aur_packages[@]}"
else
    e_header "Unable to install AUR packages. Missing yay command"
fi
