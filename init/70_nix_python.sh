export PYENV_ROOT="$DOTFILES/vendor/pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

echo "Installing pyenv"
"$DOTFILES/vendor/pyenv-installer/bin/pyenv-installer"
