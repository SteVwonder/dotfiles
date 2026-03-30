# Ubuntu desktop-only stuff. Abort if not an Ubuntu desktop.
is_ubuntu_desktop || return 1

packages=(
  feh
  i3
  playerctl
  xclip

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

# Install py3status
if [[ ! "$(type -P py3status)" ]]; then
  e_header "Installing py3status"
  (
      sudo pip install py3status
  )
fi
