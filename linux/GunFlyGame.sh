#!/bin/sh
printf '\033c\033]0;%s\a' GunFlyGame
base_path="$(dirname "$(realpath "$0")")"
"$base_path/GunFlyGame.x86_64" "$@"
