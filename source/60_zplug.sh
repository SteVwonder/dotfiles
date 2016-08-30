is_zsh || return 1 # only run under zsh

export ZPLUG_HOME=${DOTFILES}/vendor/zplug
source ${ZPLUG_HOME}/init.zsh

#zplug "zplug/zplug"

#####
# Plugins
#####

# automatically sources (known/whitelisted) .autoenv.zsh files, typically used in project root directories
zplug "Tarrasch/zsh-autoenv"
# simple zsh calculator
zplug "arzzen/calc.plugin.zsh"
# turns off running lines of input during pastes
zplug "oz/safe-paste"
# enables highlighing of commands whilst they are typed at a zsh prompt into an interactive terminal
# must be sourced after all custom widgets have been created (i.e., after all zle -N calls and after running compinit)
zplug "zsh-users/zsh-syntax-highlighting", nice:10

#############
# Completions
#############

# completion for pip
zplug "srijanshetty/zsh-pip-completion"
# completion for docker
zplug "felixr/docker-zsh-completion"

########
# Themes
########

zplug "robbyrussell/oh-my-zsh", use:"lib/*.zsh", nice:14
zplug "oskarkrawczyk/honukai-iterm-zsh", nice:15

# Install plugins if there are plugins that have not been installed
if ! zplug check; then
    zplug install
fi

# Then, source plugins and add commands to $PATH
zplug load
