#!/usr/bin/env bash

icons() {
  active=$(hyprctl activeworkspace -j | jq '.id')
  occupied=$(hyprctl workspaces -j | jq '[.[].id]')

  out=""
  for i in 1 2 3 4 5; do
    icon=""
    [ "$i" = "1" ] && icon=""
    [ "$i" = "2" ] && icon=""
    [ "$i" = "3" ] && icon=""
    [ "$i" = "4" ] && icon=""
    [ "$i" = "5" ] && icon=""

    class="empty"
    echo "$occupied" | jq -e ". | index($i)" >/dev/null && class="occupied"
    [ "$i" = "$active" ] && class="active"

    out="$out <span class='$class'>$icon</span>"
  done

  jq -nc --arg text "$out" '{"text": $text, "tooltip": "Workspaces"}'
}

icons
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - \
  | while read -r _; do
      icons
    done