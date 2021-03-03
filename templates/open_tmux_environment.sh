#!/bin/bash
# Open test project with code and shell panes.

# ./script \
#  TMUX_SESSION_NAME \
#  CODE_PANE_DIRECTORY \
#  SHELL_PANE_DIRECTORY \
#  CODE_FILE

set -e

error() {
	echo -e "\e[1m\e[31m$@\e[0m" >&2
  exit 1
}

# Get arguments.
SESSION_NAME="$1"
CODE_PANE_DIRECTORY="$2"
SHELL_PANE_DIRECTORY="$3"
CODE_FILE="$4"

test -z "$SESSION_NAME"         && error "Session name is required!"
test -z "$CODE_PANE_DIRECTORY"  && error "Code pane directory is required!"
test -z "$SHELL_PANE_DIRECTORY" && error "Shell pane directory is required!"
test -z "$CODE_FILE"            && error "Code file is required!"


# Make two tmux panes.
if [ -n "$TMUX" ]; then
  if [ "$(tmux list-panes | wc -l)" -gt "1" ]; then
    tmux new-window
    tmux split-window -h
  else
    tmux split-window -h
  fi
else
  tmux new-session -d -s "$SESSION_NAME"
  tmux split-window -h
fi


# Open code file.
tmux select-pane -t 0
tmux send-keys "cd $CODE_PANE_DIRECTORY" Enter
tmux send-keys "clear" Enter

if [ -n "$CODE_FILE" ]; then
  sleep 0.4
  tmux send-keys "n $CODE_FILE" Enter
fi


# Open shell pane.
tmux select-pane -t 1
tmux send-keys "cd $SHELL_PANE_DIRECTORY" Enter
tmux send-keys "clear" Enter
tmux select-pane -t 0


# Attach to tmux.
if [ -z "$TMUX" ]; then
  tmux attach-session -d -t "$SESSION_NAME"
fi
