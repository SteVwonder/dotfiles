# OSX-only stuff. Abort if not OSX.
is_osx || return 1

ITERM_APP="/Applications/iTerm.app"
ITERM_CONFIG_DIRECTORY="$DOTFILES/conf/osx/iterm2"
ITERM_SCRIPT_DIRECTORY="$HOME/Library/Application Support/iTerm2/Scripts/AutoLaunch"
THEME_NAME="Ghostty Default Style Dark"
THEME_FILE="$ITERM_CONFIG_DIRECTORY/$THEME_NAME.itermcolors"
THEME_SCRIPT="$ITERM_CONFIG_DIRECTORY/set-ghostty-default.py"
LEGACY_SCRIPT="$ITERM_SCRIPT_DIRECTORY/theme.py"

if [[ ! -d "$ITERM_APP" ]]; then
  e_error "iTerm2 is not installed."
  return 1
fi

mkdir -p "$ITERM_SCRIPT_DIRECTORY"

# Remove the obsolete OS-appearance watcher, but only when it belongs to this
# dotfiles checkout.
if [[ -L "$LEGACY_SCRIPT" \
    && "$(readlink "$LEGACY_SCRIPT")" == "$ITERM_CONFIG_DIRECTORY/theme.py" ]]; then
  rm "$LEGACY_SCRIPT"
fi

# This one-shot script applies the vendored palette to both the light and dark
# slots of the default profile (and the tmux profile, when present).
ln -sf "$THEME_SCRIPT" "$ITERM_SCRIPT_DIRECTORY/"

# Importing an .itermcolors file registers it as a named color preset. Avoid
# reopening iTerm when the exact preset is already installed.
ITERM_PREFERENCES="$HOME/Library/Preferences/com.googlecode.iterm2.plist"
if [[ ! -f "$ITERM_PREFERENCES" ]] \
    || ! plutil -extract "Custom Color Presets.$THEME_NAME" xml1 -o - \
      "$ITERM_PREFERENCES" >/dev/null 2>&1; then
  open -a "$ITERM_APP" "$THEME_FILE"
fi
