#!/usr/bin/env bash

# Firefox windows
hyprctl clients -j | jq -r '.[] | select(.class=="firefox") | [.address,.title] | @tsv' |
  while IFS=$'\t' read -r addr title; do
    case "$title" in
    *Netflix* | *YouTube* | *OnePiece* | *AniWorld* | *Prime* | *Disney* | *pdf*)
      hyprctl dispatch "hl.dsp.window.move({ workspace = 2, follow = false, window = 'address:$addr' })"
      ;;
    *Grafana* | *grafana* | *Thanos* | *Arch* | *Calendar* | *Google* | *DuckDuckGo*)
      hyprctl dispatch "hl.dsp.window.move({ workspace = 4, follow = false, window = 'address:$addr' })"
      ;;
    *WhatsApp* | *ChatGPT* | *Perplexity*)
      hyprctl dispatch "hl.dsp.window.move({ workspace = 7, follow = false, window = 'address:$addr' })"
      ;;
    esac
  done

# vs-code windows
hyprctl clients -j | jq -r '.[] | select(.class=="code-oss") | [.address,.title] | @tsv' |
  while IFS=$'\t' read -r addr title; do
    case "$title" in
    *faultlens* | *EDDI*)
      hyprctl dispatch "hl.dsp.window.move({ workspace = 2, follow = false, window = 'address:$addr' })"
      ;;
    esac
  done
