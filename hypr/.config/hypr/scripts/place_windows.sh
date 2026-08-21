#!/usr/bin/env bash

# Firefox windows
hyprctl clients -j | jq -r '.[] | select(.class=="firefox") | [.address,.title] | @tsv' |
	while IFS=$'\t' read -r addr title; do
		case "$title" in
		*AniWorld*)
			hyprctl dispatch "hl.dsp.window.move({ workspace = 3, follow = false, window = 'address:$addr' })"
			;;
		*Grafana* | *Thanos* | *Arch* | *Calendar*)
			hyprctl dispatch "hl.dsp.window.move({ workspace = 4, follow = false, window = 'address:$addr' })"
			;;
		*Netflix* | *YouTube* | *OnePiece*)
			hyprctl dispatch "hl.dsp.window.move({ workspace = 9, follow = false, window = 'address:$addr' })"
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
