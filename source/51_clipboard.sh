# OSX already has pbcopy and pbpaste
is_osx && return 1

alias pbcopy="xclip -i -selection clipboard"
alias pbpaste="xclip -o -selection clipboard"

# Trim new lines and copy to clipboard
# alias c="tr -d '\n' | pbcopy"
