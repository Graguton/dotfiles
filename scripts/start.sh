#!/usr/bin/env bash

# Check if a command-line argument is provided
if [ -z "$1" ]; then
  exit 1
fi

WM=$1

# Function to set up environment variables for Wayland
setup_wayland_env() {
  export XDG_SESSION_TYPE=wayland
  export XDG_RUNTIME_DIR=/run/user/$(id -u)
  export WAYLAND_DISPLAY=wayland-0

  export MOZ_ENABLE_WAYLAND=1 # firefox
}

# Function to start Hyprland
start_hyprland() {
  setup_wayland_env

  export WLR_NO_HARDWARE_CURSORS=1
  export NIXOS_OZONE_WL=1
  exec Hyprland
}

# Function to start River
start_river() {
  setup_wayland_env
  exec river
}

# Start the specified window manager
case "${WM,,}" in
  Hyprland)
    start_hyprland
    ;;
  river)
    start_river
    ;;
  *)
    exec "$WM"
    ;;
esac
