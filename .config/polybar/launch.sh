#!/usr/bin/env bash

# kill existing bars
killall -q polybar

# wait for them to die
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

echo "--------------------------------------------------------------------------------" | tee -a /tmp/polybar.log
polybar main --config="$XDG_CONFIG_HOME"/polybar/config.ini 2>&1 | tee -a /tmp/polybar.log & disown

echo "Bar launched"
