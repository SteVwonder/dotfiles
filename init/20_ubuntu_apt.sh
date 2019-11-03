# Ubuntu-only stuff. Abort if not Ubuntu.
is_ubuntu || return 1

# Add git ppa
sudo add-apt-repository -y ppa:git-core/ppa
# Update APT.
e_header "Updating APT"
sudo apt-get -qq update
sudo apt-get -qq dist-upgrade

# Install APT packages.
packages=(
  autoconf
  build-essential
  emacs
  feh
  git-core
  global
  htop
  id3tool
  i3
  libncurses-dev
  libssl-dev
  python-pip
  subversion
  tmux
  tree
  xclip
  zsh

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

# Install Git Extras
if [[ ! "$(type -P git-extras)" ]]; then
  e_header "Installing Git Extras"
  (
    cd $DOTFILES/vendor/git-extras &&
    make &&
    sudo make install
  )
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
