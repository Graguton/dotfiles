#!/usr/bin/env bash

#export XDG_SESSION_TYPE=wayland
#export XDG_RUNTIME_DIR=/run/user/$(id -u)
#export WAYLAND_DISPLAY=wayland-0
#export XDG_SESSION_DESKTOP=Hyprland
#export XDG_CURRENT_DESKTOP=Hyprland

export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1

export NIXOS_OZONE_WL=1

exec Hyprland
