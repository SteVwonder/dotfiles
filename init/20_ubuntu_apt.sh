# Ubuntu-only stuff. Abort if not Ubuntu.
is_ubuntu || return 1

# Add git ppa
if command -v add-apt-repository &>/dev/null; then
  maybe_sudo add-apt-repository -y ppa:git-core/ppa
fi
# Update APT.
e_header "Updating APT"
maybe_sudo apt-get -qq update
maybe_sudo apt-get -qq dist-upgrade

# Install APT packages.
packages=(
  autoconf
  build-essential
  emacs
  git-core
  golang
  htop
  libncurses-dev
  libssl-dev
  python-pip
  tree
  zsh
)

packages=($(setdiff "${packages[*]}" "$(dpkg --get-selections | grep -v deinstall | awk '{print $1}')"))

if (( ${#packages[@]} > 0 )); then
  e_header "Installing APT packages: ${packages[*]}"
  for package in "${packages[@]}"; do
    maybe_sudo apt-get -qq install "$package"
  done
fi
