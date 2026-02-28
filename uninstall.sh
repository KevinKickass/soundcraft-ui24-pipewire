#!/usr/bin/env bash
set -euo pipefail

CONF_NAME="soundcraft-ui24-stereo-pairs.conf"
TARGET="$HOME/.config/pipewire/pipewire.conf.d/$CONF_NAME"

if [[ ! -f "$TARGET" ]]; then
    echo "Not installed."
    exit 0
fi

rm "$TARGET"
echo "Removed: $TARGET"

echo "Restarting PipeWire..."
systemctl --user restart pipewire pipewire-pulse
echo "Done. Stereo pairs removed."
