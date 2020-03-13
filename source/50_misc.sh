if is_bash; then
    # Case-insensitive globbing (used in pathname expansion)
    shopt -s nocaseglob

    # Check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize

    # SSH auto-completion based on entries in known_hosts.
    if [[ -e ~/.ssh/known_hosts ]]; then
        complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq | grep -v '[0-9]')" ssh scp sftp
    fi

    # Prevent ctrl+s from freezing the terminal
    # For more info: http://superuser.com/questions/124845/can-you-disable-the-ctrl-s-xoff-keystroke-in-putty
    if [ ! -z "$PS1" ] && tty -s; then
        stty -ixon
    fi

    # SSH auto-completion based on entries in known_hosts.
    if [[ -e ~/.ssh/known_hosts ]]; then
        complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq | grep -v '[0-9]')" ssh scp sftp
    fi
fi

alias grep="grep --color=auto"

# Prevent less from clearing the screen while still showing colors.
export LESS=-XR

# Set the terminal's title bar.
function titlebar() {
  echo -n $'\e]0;'"$*"$'\a'
}

alias htop="TERM=screen htop"
alias stripcolors='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g"'
