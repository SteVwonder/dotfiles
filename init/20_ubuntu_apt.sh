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
  feh
  git-core
  htop
  id3tool
  i3
  libdbus-glib-1-dev
  libgtk2.0-dev
  libncurses-dev
  libssl-dev
  python-pip
  subversion
  tmux
  tree
  w3m

  # playerctl dependencies
  gtk-doc-tools
  gobject-introspection

  # emacs dependencies
  libx11-dev
  xaw3dg-dev
  libjpeg-dev
  libpng12-dev
  libgif-dev
  libtiff4-dev
  libxft-dev
  librsvg2-dev
  libmagickcore-dev
  libmagick++-dev
  libxml2-dev
  libgpm-dev
  libghc-gconf-dev
  libotf-dev
  libm17n-dev
  libgnutls-dev
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

# Install Playerctl
if [[ ! "$(type -P playerctl)" ]]; then
  e_header "Installing Playerctl"
  (
    cd $DOTFILES/vendor/playerctl &&
        ./autogen.sh &&
        ./configure --prefix=/usr/local &&
        make &&
        sudo make install
  )
fi

function install_emacs() {
    version="$1"

    if [ ! -d emacs-"$version" ]; then
        if [ ! -f emacs-"$version".tar.xz ]; then
            wget http://ftp.gnu.org/gnu/emacs/emacs-"$version".tar.xz
        fi
        tar xvf emacs-"$version".tar.xz
    fi

    cd emacs-"$version"
    ./configure \
        --with-xft \
        --with-x-toolkit=lucid \
        --prefix=/usr/local/
    make
    sudo make install
}

# Install Latest Emacs
e_header "Installing Emacs"
(
    cd $DOTFILES/vendor/ &&
        install_emacs "24.5"
)

# Install py3status
if [[ ! "$(type -P py3status)" ]]; then
  e_header "Installing Playerctl"
  (
      sudo pip install py3status
  )
fi
