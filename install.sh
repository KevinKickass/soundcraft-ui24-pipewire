#!/usr/bin/env bash
set -euo pipefail

CONF_NAME="soundcraft-ui24-stereo-pairs.conf"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$SCRIPT_DIR/$CONF_NAME"
TARGET_DIR="$HOME/.config/pipewire/pipewire.conf.d"
TARGET="$TARGET_DIR/$CONF_NAME"

if [[ ! -f "$SOURCE" ]]; then
    echo "Error: $CONF_NAME not found in $SCRIPT_DIR" >&2
    exit 1
fi

mkdir -p "$TARGET_DIR"

if [[ -f "$TARGET" ]]; then
    if diff -q "$SOURCE" "$TARGET" >/dev/null 2>&1; then
        echo "Already up to date."
        exit 0
    fi
    echo "Updating existing config..."
else
    echo "Installing config..."
fi

cp "$SOURCE" "$TARGET"
echo "Installed: $TARGET"

echo "Restarting PipeWire..."
systemctl --user restart pipewire pipewire-pulse

echo "Done. Verifying..."
sleep 1
SINKS=$(wpctl status 2>/dev/null | grep -c "soundcraft_out_pair.*Audio/Sink" || true)
SOURCES=$(wpctl status 2>/dev/null | grep -c "soundcraft_in_pair.*Audio/Source" || true)
echo "  $SINKS stereo sinks, $SOURCES stereo sources active."

if [[ "$SINKS" -eq 16 && "$SOURCES" -eq 16 ]]; then
    echo "All 32 stereo pairs loaded successfully."
else
    echo "Warning: Expected 16 sinks + 16 sources. Check 'wpctl status' for details." >&2
fi
