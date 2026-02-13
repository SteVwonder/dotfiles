# History settings

if is_bash; then
    # Allow use to re-edit a faild history substitution.
    shopt -s histreedit
    # History expansions will be verified before execution.
    shopt -s histverify
fi

# Entries beginning with space aren't added into history
export HISTCONTROL="ignorespace"
# Common commands are ignored
export HISTIGNORE='ls:bg:fg:history:hist:set'
# Lots o' history.
export HISTSIZE=10000
export HISTFILESIZE=1000000

if [[ "$CURSOR_AGENT" == "1" ]]; then
    export HISTFILE="${HOME}/.hist_cursor"
else
    export HISTFILE="${HOME}/.hist"
fi

# record each command as it is executed, rather than at the end
export PROMPT_COMMAND='history -a'

