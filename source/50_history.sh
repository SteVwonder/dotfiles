# History settings

if is_bash; then
    # Allow use to re-edit a faild history substitution.
    shopt -s histreedit
    # History expansions will be verified before execution.
    shopt -s histverify
fi

# Entries beginning with space aren't added into history, and duplicate
# entries will be erased (leaving the most recent entry).
export HISTCONTROL="ignorespace"
# Common commands are ignored
export HISTIGNORE='ls:bg:fg:history:hist'
# Give history timestamps.
export HISTTIMEFORMAT="[%F %T] "
# Lots o' history.
export HISTSIZE=10000
export HISTFILESIZE=1000000

# Hist file for each terminal/day
HIST_DIR=${HOME}/.history
TODAYS_DIR=${HIST_DIR}/$(date "+%Y")/$(date "+%m")/$(date "+%d")
mkdir -p ${TODAYS_DIR}
if [ -z "$PS1" ] || ! tty -s; then
    MYTTY="noniter"
else
    MYTTY=$(basename `tty`)
fi

export HISTFILE=${TODAYS_DIR}/"$(date "+%H-%M-%S")_${MYTTY}.hist"

# record each command as it is executed, rather than at the end
export PROMPT_COMMAND='history -a'

# Easily re-execute the last history command.
# alias r="fc -s"

# Usage: hist regex [time_selector]
# time_selector is of the form [year[/month[/day]]]
hist() {
    if [[ -z "$2" ]]; then
        2=$(date "+%Y/%m/%d")
    fi
    if command -v rg &> /dev/null; then
        rg "$1" "${HIST_DIR}/$2"
    else
        grep -R "$1" "${HIST_DIR}/$2"
    fi
}
