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
  git-core
  global
  htop
  id3tool
  libncurses-dev
  libssl-dev
  python-pip
  subversion
  tmux
  tree
  zsh
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
