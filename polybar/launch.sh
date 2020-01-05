#!/bin/bash

## restart i3
if [[ $1 = "restart" ]]; then
	i3-msg restart
	sleep 1
fi

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log
polybar example >>/tmp/polybar1.log 2>&1 &

echo "Bars launched..."
