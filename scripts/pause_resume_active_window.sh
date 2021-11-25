#!/bin/bash

# Get active window pid.
ACTIVE_WINDOW_PID=$(xdotool getactivewindow getwindowpid)
if $? ; then
  echo "Unable to get active window pid"
  exit 1
fi

# Get active window status.
WINDOW_STATUS=$(ps -q "$ACTIVE_WINDOW_PID" -o state --no-headers)

# Toggle active window (pause <--> continue)
if [ "$WINDOW_STATUS" = "T" ]; then
  kill -CONT "$ACTIVE_WINDOW_PID"
else
  kill -STOP "$ACTIVE_WINDOW_PID"
fi
