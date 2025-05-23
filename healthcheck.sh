#!/bin/sh

# Check if keepalived process is running
if ! pgrep keepalived > /dev/null; then
    echo "keepalived process not found"
    exit 1
fi

# Check if keepalived is responding
if ! killall -0 keepalived 2>/dev/null; then
    echo "keepalived not responding"
    exit 1
fi

echo "keepalived is healthy"
exit 0



