# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/dylan/.miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/dylan/.miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/dylan/.miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/dylan/.miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Supress Conda's VirtualEnv display
# TODO: There is definitely a cleaner way to do this
if $(conda config --show | grep changeps1 | awk '{ print tolower($2) }'); then
    conda config --set changeps1 False
fi

# Automatically activate conda environments when moving into a directory with a environment.yaml file
auto_activate_env() {
    if [[ -f "environment.yaml" ]]; then
        ENV=$(head -n1 environment.yaml | awk '{print $2}')
        
        eval "$(conda shell.zsh hook)"
        conda activate $ENV
    fi
}
chpwd_functions+=auto_activate_env
