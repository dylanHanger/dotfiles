if [[ -z $DISPLAY ]]; then
    VISUAL=code
else
    VISUAL=vim
fi

EDITOR=vim

export VISUAL
export EDITOR
