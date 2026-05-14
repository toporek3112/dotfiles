#!/bin/bash
for f in *; do
  [ -f "$f" ] || continue
  new=$(echo "$f" | tr '[:upper:]' '[:lower:]' | sed 's/ /_/g; s/[^a-z0-9._-]//g')
  [ "$f" != "$new" ] && mv -v "$f" "$new"
done
