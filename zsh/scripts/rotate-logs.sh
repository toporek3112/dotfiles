#!/bin/bash

SRC="$1"

if [ -z "$SRC" ] || [ ! -d "$SRC" ]; then
  echo "Usage: $0 /path/to/logfolder"
  exit 1
fi

STAMP=$(date +"%Y-%m-%d")

for LOG in "$SRC"/*.log; do
  [ -e "$LOG" ] || continue

  BASENAME=$(basename "$LOG" .log)
  GZ="$SRC/${BASENAME}-${STAMP}.log.gz"

  # gzip the log (keep original name inside .gz)
  gzip -c "$LOG" > "$GZ"

  # truncate the original log
  : > "$LOG"
done
