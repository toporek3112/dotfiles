#!/usr/bin/env bash

set -euo pipefail

FLAGS="\
--collector.rapl \
--collector.hwmon \
--collector.cpufreq \
--collector.thermal_zone \
--collector.powersupplyclass \
--collector.textfile.directory=/var/lib/node_exporter/textfile"

source /etc/os-release

case "$ID" in
  ubuntu | debian)
    sudo apt update
    sudo apt install -y prometheus-node-exporter

    sudo tee /etc/default/prometheus-node-exporter >/dev/null <<EOF
ARGS="$FLAGS"
EOF
    ;;

  arch | cachyos)
    sudo pacman -S --needed prometheus-node-exporter

    sudo tee /etc/conf.d/prometheus-node-exporter >/dev/null <<EOF
NODE_EXPORTER_ARGS="$FLAGS"
EOF
    ;;

  *)
    echo "Unsupported distribution: $ID"
    exit 1
    ;;
esac

sudo mkdir -p /var/lib/node_exporter/textfile

sudo systemctl enable --now prometheus-node-exporter
sudo systemctl restart prometheus-node-exporter

systemctl status prometheus-node-exporter --no-pager