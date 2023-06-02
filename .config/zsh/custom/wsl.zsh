if [[ $(grep -i Microsoft /proc/version) ]]; then
  export BROWSER=wslview
fi
