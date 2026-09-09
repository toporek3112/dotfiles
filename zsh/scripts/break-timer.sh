#!/usr/bin/env bash

state_file="${XDG_RUNTIME_DIR:-/tmp}/tmux-break-timer-$UID"
now=$(date +%s)

case "${1:-status}" in
session | break)
	printf '%s %s\n' "$1" "$now" >"$state_file"
	exit 0
	;;

stop)
	rm -f "$state_file"
	exit 0
	;;

status)
	;;

*)
	printf 'Usage: %s {session|break|stop}\n' "$0" >&2
	exit 1
	;;
esac

if [[ ! -f "$state_file" ]]; then
	printf '#[fg=#808080]Idle#[default]'
	exit 0
fi

read -r mode started <"$state_file"

elapsed=$((now - started))
minutes=$((elapsed / 60))
started_at=$(date -d "@$started" '+%H:%M')

case "$mode" in
session)
	if ((minutes < 50)); then
		color="#5faf5f" # green
	elif ((minutes < 60)); then
		color="#ffd75f" # yellow
	elif ((minutes < 90)); then
		color="#ffaf00" # orange
	else
		color="#ff5f5f" # red
	fi

	printf '#[fg=%s]Focus %dm#[default]' \
		"$color" "$minutes"
	;;

break)
	printf '#[fg=#5fafff]Break %dm#[default]' \
		"$minutes"
	;;
esac
