# Neat tricks
alias path='echo ${PATH:gs/\:/\\n}'

# Better commands
alias ls="exa --grid --icons --color=auto"
alias lsa="exa --icons --color=auto -la"
alias la="exa --grid --icons --color=auto -la"
alias ll="exa --long --icons --color=auto"
alias tree="exa --tree --icons --color=auto"

alias cat="bat --style=plain --paging=never"

alias cd="z"

alias lazyyadm='lazygit --use-config-file="$HOME/.config/yadm/lazygit.yml,$HOME/.config/lazygit/config.yml" --work-tree="$HOME" --git-dir="$HOME/.local/share/yadm/repo.git"'
