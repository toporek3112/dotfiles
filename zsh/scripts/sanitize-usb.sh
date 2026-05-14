#!/bin/bash

set -euo pipefail

AUTO_CONFIRM=false

# Check for -y flag
if [[ "${1:-}" == "-y" ]]; then
  AUTO_CONFIRM=true
fi

echo "🔹 Detecting removable USB devices..."

# Get list of removable USB disks
USB_DEVICES=($(lsblk -dpno NAME,RM,SIZE | awk '$2==1 {print $1}'))

if [ ${#USB_DEVICES[@]} -eq 0 ]; then
  echo "⚠️  No removable USB devices found."
  exit 1
fi

echo ""
echo "Available USB devices:"
for i in "${!USB_DEVICES[@]}"; do
  echo "$i) ${USB_DEVICES[$i]}"
done

echo ""
read -p "Enter USB numbers to inspect (comma-separated, e.g., 0,2): " selection

# Convert to array
IFS=',' read -ra SELECTED_IDX <<< "$selection"

# Validate selection
for idx in "${SELECTED_IDX[@]}"; do
  if ! [[ "$idx" =~ ^[0-9]+$ ]] || [ "$idx" -ge "${#USB_DEVICES[@]}" ]; then
    echo "❌ Invalid selection: $idx"
    exit 1
  fi
done

inspect_and_sanitize_usb() {
  local USB="$1"
  echo ""
  echo "🔹 Selected USB: $USB"

  # Detect mountpoints
  MOUNTPOINTS=($(lsblk -lnpo NAME,MOUNTPOINT "$USB" | awk '$2!="" {print $2}'))

  # Show contents before formatting
  for mp in "${MOUNTPOINTS[@]}"; do
    echo ""
    echo "📂 Contents of $mp (before formatting):"
    ls -lha "$mp"
  done

  if [ "$AUTO_CONFIRM" = false ]; then
    read -p "Do you want to format/sanitize this USB? (y/n): " choice
    if [[ ! "$choice" =~ ^[Yy]$ ]]; then
      echo "⏭ Skipping $USB."
      return
    fi
  else
    echo "⚡ Auto-confirm enabled, formatting $USB..."
  fi

  # Unmount any existing partitions
  for part in $(lsblk -lnpo NAME "$USB" | tail -n +2); do
    if mount | grep -q "^$part"; then
      sudo umount "$part" || true
    fi
  done

  # Wipe partition table
  sudo wipefs -a "$USB"

  # Create new partition table and primary FAT32 partition
  sudo parted "$USB" --script mklabel msdos mkpart primary fat32 1MiB 100%
  local NEW_PART="${USB}1"

  # Format as FAT32
  sudo mkfs.fat -F 32 -n "USB_CLEAN" "$NEW_PART"

  # Temporary mount to show contents
  local TMP_MOUNT="/tmp/usb_check_$(basename "$USB")"
  mkdir -p "$TMP_MOUNT"
  sudo mount "$NEW_PART" "$TMP_MOUNT"

  echo ""
  echo "📂 Contents of freshly sanitized $USB:"
  ls -lha "$TMP_MOUNT"

  # Cleanup
  sudo umount "$TMP_MOUNT"
  rmdir "$TMP_MOUNT"

  echo "✅ $USB sanitized and ready to use!"
}

# Iterate over all selected USBs
for idx in "${SELECTED_IDX[@]}"; do
  inspect_and_sanitize_usb "${USB_DEVICES[$idx]}"
done

echo ""
echo "🎉 All selected USBs have been processed!"
