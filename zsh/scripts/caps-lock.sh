#!/usr/bin/env bash

if grep -qs '^1$' /sys/class/leds/input*::capslock/brightness 2>/dev/null; then
  printf 'CAPS'
fi
