#!/bin/bash
# install rustdesk

echo "Installing RustDesk..."
wget https://github.com/rustdesk/rustdesk/releases/download/1.4.4/rustdesk-1.4.4-x86_64.deb > /dev/null 2>&1
sudo apt install -fy ./rustdesk*.deb

# Ensure we run RustDesk in the user account (runner) on the VNC display
export DISPLAY=${DISPLAY:-:1}
LOGFILE="$HOME/rustdesk.log"
touch "$LOGFILE"
sleep 5s
# Set RustDesk password (if provided)
if [ -n "$VNC_PASSWORD" ]; then
	echo "Setting RustDesk password" >>"$LOGFILE"
	sudo rustdesk --password "${VNC_PASSWORD}@rust69" >>"$LOGFILE" 2>&1 || true
fi

# Start RustDesk in background as the user (use `rustdesk &` as requested)
export DISPLAY=$DISPLAY
rustdesk >>"$LOGFILE" 2>&1 &
RS_PID=$!
echo "RustDesk started (PID: $RS_PID)" >>"$LOGFILE"

# Give RustDesk a moment to start and print its ID
sleep 5s
DISPLAY=$DISPLAY rustdesk --get-id >>"$LOGFILE" 2>&1 || true
sleep 5s

# Print where logs are and show recent output for visibility in CI logs
echo "RustDesk log: $LOGFILE"
tail -n 40 "$LOGFILE" || true

exit