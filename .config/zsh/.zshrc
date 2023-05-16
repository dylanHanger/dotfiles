# Lines configured by zsh-newuser-install
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=10000
SAVEHIST=50000
setopt autocd extendedglob notify
unsetopt beep nomatch
bindkey -v
# End of lines configured by zsh-newuser-install

export ZSH_COMPCACHE="$XDG_CACHE_HOME/zsh"
export ZSH_COMPDUMP="$ZSH_COMPCACHE/zcompdump-$ZSH_VERSION"

zstyle ':completion:*' cache-path "$ZSH_COMPCACHE"
autoload -Uz compinit 
if [[ -n ${ZSH_COMPDUMP}(#qN.mh+24) ]]; then
	compinit -d "$ZSH_COMPDUMP";
else
	compinit -C -d "$ZSH_COMPDUMP";
fi;

chpwd_functions=()

# Source all .zsh files in ./custom/
for f in "$ZDOTDIR/custom"/*.zsh; do
	source "$f"
done

# Enable autosuggestions
source "$ZDOTDIR/custom/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Starship prompt
source <(starship init zsh --print-full-init)
eval "$(zoxide init zsh)"

# User configuration
# Editor
export EDITOR=nvim

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# chpwd hooks
export chpwd_functions

export PATH="$XDG_BIN_HOME:$PATH"
