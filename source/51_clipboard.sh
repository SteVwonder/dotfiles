# Use lemonade aliases on remote shells.
[[ -n "$SSH_TTY$SSH_CONNECTION$SSH_CLIENT" ]] || return 1
command -v lemonade >/dev/null 2>&1 || return 1

for name in xdg-open pbcopy pbpaste; do
  unalias "$name" 2>/dev/null || true
done

alias xdg-open="lemonade open"
alias pbcopy="lemonade copy"
alias pbpaste="lemonade paste"
