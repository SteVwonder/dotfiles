# Ubuntu-only stuff. Abort if not Ubuntu.
is_ubuntu || return 1

check_if_desktop (){
  IS_DESKTOP="false"

  displayManager=(
    'xserver-common' # X Window System (X.Org) infrastructure
    'xwayland' # Xwayland X server
  )
  for i in "${displayManager[@]}"; do
    dpkg-query --show --showformat='${Status}\n' $i 2> /dev/null | grep "install ok installed" &> /dev/null
    if [[ $? -eq 0 ]]; then
      IS_DESKTOP="true"
    fi
  done

  if [[ "$IS_DESKTOP" == "false" ]]; then
      return 1
  fi
}

# This file for desktop-only tools.
check_if_desktop

packages=(
  feh
  i3
  playerctl
  xclip

  # volnoti
  libdbus-glib-1-dev
  libgtk2.0-dev

  # dmenu-frecency dependency
  python-docopt
)

packages=($(setdiff "${packages[*]}" "$(dpkg --get-selections | grep -v deinstall | awk '{print $1}')"))

if (( ${#packages[@]} > 0 )); then
  e_header "Installing APT packages: ${packages[*]}"
  for package in "${packages[@]}"; do
    sudo apt-get -qq install "$package"
  done
fi

# Install Volnoti
if [[ ! "$(type -P volnoti)" ]]; then
  e_header "Installing Volnoti"
  (
    cd $DOTFILES/vendor/volnoti &&
        bash prepare.sh &&
        bash fix_headers.sh &&
        ./configure --prefix=/usr/local &&
        make &&
        sudo make install
  )
fi

# Install py3status
if [[ ! "$(type -P py3status)" ]]; then
  e_header "Installing Playerctl"
  (
      sudo pip install py3status
  )
fi
