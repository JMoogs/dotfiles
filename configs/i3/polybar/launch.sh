#!/usr/bin/env bash

# Kill the bar(s)
pgrep polybar | xargs kill

# Launch on all monitors
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar desktop &
  done
else
  polybar desktop &
fi
