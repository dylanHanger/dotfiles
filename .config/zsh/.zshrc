# Lines configured by zsh-newuser-install
HISTFILE=$XDG_STATE_HOME/zsh/history
HISTSIZE=10000
SAVEHIST=50000
setopt autocd extendedglob notify
unsetopt beep nomatch
bindkey -v
# End of lines configured by zsh-newuser-install
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$XDG_DATA_HOME/oh-my-zsh"
export ZSH_COMPCACHE="$XDG_CACHE_HOME"/zsh
export ZSH_COMPDUMP="$ZSH_COMPCACHE"/zcompdump-$ZSH_VERSION

zstyle ':completion:*' cache-path "$ZSH_COMPCACHE"
autoload -Uz compinit 
if [[ -n ${ZSH_COMPDUMP}(#qN.mh+24) ]]; then
	compinit -d "$ZSH_COMPDUMP";
else
	compinit -C -d "$ZSH_COMPDUMP";
fi;

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"
#
# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$ZDOTDIR/custom

# NVM and NPM settings
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export NVM_DIR="$XDG_DATA_HOME/nvm"
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
# export NVM_LAZY_LOAD_EXTRA_COMMANDS=("nvim")

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-nvm
)

chpwd_functions=()

source $ZSH/oh-my-zsh.sh

# Starship prompt
source <(starship init zsh --print-full-init)

# User configuration

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# chpwd hooks
export chpwd_functions

# Editor
export EDITOR=nvim

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
