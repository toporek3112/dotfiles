#!/usr/bin/env bash

sleep 10

# Firefox windows
hyprctl clients -j | jq -r '.[] | select(.class=="firefox") | [.address,.title] | @tsv' |
	while IFS=$'\t' read -r addr title; do
		case "$title" in
		*Netflix* | *YouTube* | *AniWorld* | *OnePiece*)
			hyprctl dispatch "hl.dsp.window.move({ workspace = 9, follow = false, window = 'address:$addr' })"
			;;
		*WhatsApp* | *ChatGPT* | *Perplexity*)
			hyprctl dispatch "hl.dsp.window.move({ workspace = 7, follow = false, window = 'address:$addr' })"
			;;
		*Grafana* | *Thanos* | *Arch*)
			hyprctl dispatch "hl.dsp.window.move({ workspace = 4, follow = false, window = 'address:$addr' })"
			;;
		esac
	done

# vs-code windows
hyprctl clients -j | jq -r '.[] | select(.class=="code-oss") | [.address,.title] | @tsv' |
	while IFS=$'\t' read -r addr title; do
		case "$title" in
		*faultlens*)
			hyprctl dispatch "hl.dsp.window.move({ workspace = 2, follow = false, window = 'address:$addr' })"
			;;
		esac
	done
