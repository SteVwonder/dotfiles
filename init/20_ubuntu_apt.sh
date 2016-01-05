# Ubuntu-only stuff. Abort if not Ubuntu.
is_ubuntu || return 1

# Update APT.
e_header "Updating APT"
sudo apt-get -qq update
sudo apt-get -qq dist-upgrade

# Install APT packages.
packages=(
  build-essential
  emacs24
  feh
  git-core
  htop
  id3tool
  i3
  libssl-dev
  tmux
  tree
  w3m
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
if [[ ! "$(type -P git-extras)" ]]; then
  e_header "Installing Volnoti"
  (
    cd $DOTFILES/vendor/volnoti &&
    bash prepare.sh &&
    ./configure --prefix=/usr/local &&
    make &&
    sudo make install
  )
fi
