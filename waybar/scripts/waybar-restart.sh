#!/bin/bash

# Kill any running Waybar processes
pkill -x waybar

# Wait briefly to ensure Waybar is fully terminated
sleep 1

# Start Waybar again
nohup waybar >/dev/null 2>&1 &

# Optional: Output message
echo "Waybar has been restarted."
