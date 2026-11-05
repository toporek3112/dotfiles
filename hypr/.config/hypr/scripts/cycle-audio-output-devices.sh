#!/usr/bin/env bash

mapfile -t sinks < <(pactl list short sinks | cut -f2)
((${#sinks[@]} > 0)) || exit 1

current=$(pactl get-default-sink)

for i in "${!sinks[@]}"; do
  [[ "${sinks[i]}" == "$current" ]] && break
done

next=${sinks[$(((i + 1) % ${#sinks[@]}))]}

pactl set-default-sink "$next"

# Move existing PulseAudio-compatible playback streams
while read -r id; do
  pactl move-sink-input "$id" "$next"
done < <(pactl list short sink-inputs | cut -f1)

notify-send "Audio output" "$next"
