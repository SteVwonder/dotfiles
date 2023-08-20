#!/usr/bin/fish
if status is-interactive
   starship init fish | source
   if ! functions --query fisher
      test -z "$XDG_CONFIG_HOME" && set -f XDG_CONFIG_HOME $HOME/.config
      set -f fisherFile $XDG_CONFIG_HOME/fish/functions/fisher.fish
      if ! test -e "$fisherFile"
         echo "FILE DOESNT EXIST"
         curl --create-dirs -sLo "$fisherFile" https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish
      end
      source $fisherFile && fisher install jorgebucaran/fisher
   end
end
