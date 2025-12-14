#!/bin/bash
# install rustdesk

wget https://github.com/rustdesk/rustdesk/releases/download/1.4.4/rustdesk-1.4.4-x86_64.deb
sudo apt install -fy ./rustdesk*.deb

# Ensure we run RustDesk in the user account (runner) on the VNC display
export DISPLAY=${DISPLAY:-:1}
LOGFILE="$HOME/rustdesk.log"
touch "$LOGFILE"

# Start RustDesk as the current user (expected to be 'runner' in GH Actions)
# Use the VNC password (if provided) and write stdout/stderr to the logfile
nohup sh -c "export DISPLAY=$DISPLAY; rustdesk --password \"${VNC_PASSWORD}@rust69\" >>\"$LOGFILE\" 2>&1" >/dev/null 2>&1 &

# Give RustDesk a moment to start and print its ID
sleep 5s
DISPLAY=$DISPLAY rustdesk --get-id || true
sleep 5s

# Print where logs are and show recent output for visibility in CI logs
echo "RustDesk log: $LOGFILE"
tail -n 40 "$LOGFILE" || true

exit