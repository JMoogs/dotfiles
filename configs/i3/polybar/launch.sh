#!/usr/bin/env bash

# Kill the bar(s)
pgrep polybar | xargs kill

# Launch the bar
polybar desktop &
