#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

# Generate ws-list
# counter=0
# i3-msg -t get_workspaces | tr ',' '\n' | sed -nr 's/"name":"([^"]+)"/\1/p' | while read -r name; do
#   printf 'ws-icon-%i = "%s;<insert-icon-here>"\n' $((counter++)) $name
# done

# Launch bar1 and bar2
# echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
# polybar bar1 >>/tmp/polybar1.log 2>&1 & disown
# polybar bar2 >>/tmp/polybar2.log 2>&1 & disown

# Launch example bar
# echo "---" | tee -a /tmp/example.log
# polybar example >>/tmp/example.log 2>&1 & disown

# Launch workspace bar
# echo "---" | tee -a /tmp/workspaces.bar.log /tmp/music.bar.log
# polybar workspaces >>/tmp/workspaces.bar.log 2>&1 & disown
# polybar music >>/tmp/music.bar.log 2>&1 & disown

# Launch waq bar
echo "---" | tee -a /tmp/waq.bar.log
polybar waq >>/tmp/waq.bar.log 2>&1 & disown

echo "Bars launched..."