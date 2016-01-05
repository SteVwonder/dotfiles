# Ubuntu-only stuff. Abort if not Ubuntu.
is_ubuntu || return 1

# Update APT.
e_header "Updating APT"
sudo apt-get -qq update
sudo apt-get -qq dist-upgrade

# Install APT packages.
packages=(
  autoconf
  build-essential
  emacs24
  feh
  git-core
  htop
  id3tool
  i3
  libdbus-glib-1-dev
  libgtk2.0-dev
  libncurses-dev
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

# Install Emacs
e_header "Installing Emacs"
(
    cd $DOTFILES/vendor/ &&
        wget http://mirror.lug.udel.edu/pub/gnu/emacs/emacs-24.5.tar.xz &&
        tar -xf ./emacs-24.5.tar.xz &&
        cd emacs-24.5 &&
        ./configure --prefix=/usr/local --without-x &&
        make -j4 &&
        sudo make install
)
