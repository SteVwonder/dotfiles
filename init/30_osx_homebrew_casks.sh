# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew casks need Homebrew to install." && return 1

# Ensure the cask keg and recipe are installed.
kegs=(caskroom/cask)
brew_tap_kegs
recipes=(brew-cask)
brew_install_recipes

# Exit if, for some reason, cask is not installed.
[[ ! "$(brew ls --versions brew-cask)" ]] && e_error "Brew-cask failed to install." && return 1

# Hack to show the first-run brew-cask password prompt immediately.
brew cask info this-is-somewhat-annoying 2>/dev/null

# Homebrew casks
casks=(
  alfred
  bluestacks
  crashplan
  dash
  firefox
  flux
  github-desktop
  google-chrome
  istat-menus
  iterm2
  java
  keepassx
  keka
  mactex
  mendeley-desktop
  nvalt
  osxfuse
  qtpass
  real-vnc
  selfcontrol
  skype
  slack
  spotify
  steam
  teamviewer
  texmaker
  the-unarchiver
  tigervnc-viewer
  unetbootin
  viscosity
  vlc
  vmware-fusion
  xquartz
)

# Install Homebrew casks.
casks=($(setdiff "${casks[*]}" "$(brew cask list 2>/dev/null)"))
if (( ${#casks[@]} > 0 )); then
  e_header "Installing Homebrew casks: ${casks[*]}"
  for cask in "${casks[@]}"; do
    brew cask install $cask
  done
  brew cask cleanup
fi
