#!/bin/bash

SESSION_NAME="multi-node"
USER="toporek3112"

# Extract SSH hosts (excluding wildcards)
HOSTS=($(awk '/^Host / { for (i=2; i<=NF; i++) if ($i != "*" && $i !~ /^\*/) print $i }' ~/.ssh/config))

# Let user select one or more hosts via fzf
SELECTED=($(printf "%s\n" "${HOSTS[@]}" | fzf --multi --prompt="Select hosts > "))

if [ ${#SELECTED[@]} -eq 0 ]; then
  echo "No hosts selected."
  exit 1
fi

# Start tmux session with first selected host
tmux new-session -d -s "$SESSION_NAME" "ssh $USER@${SELECTED[0]}"

# Split for remaining hosts
for host in "${SELECTED[@]:1}"; do
  tmux split-window -v "ssh $USER@$host"
done

# Layout & attach
tmux select-layout even-vertical
tmux setw synchronize-panes on
tmux attach -t "$SESSION_NAME"
