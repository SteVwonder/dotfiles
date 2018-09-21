#!/bin/sh

export PYENV_ROOT="$DOTFILES/vendor/pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if [ -n "$(command -v pyenv)" ]; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
else
    echo "pyenv not installed"
    echo "- install on OSX with 'brew install pyenv-virtualenv'"
    echo "- otherwise visit: https://github.com/pyenv/pyenv-installer"
fi
