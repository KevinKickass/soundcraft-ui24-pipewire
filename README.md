# Soundcraft Ui24 - PipeWire Stereo Pairs

Splits the Soundcraft Ui24's 32-channel USB audio into 16 selectable stereo pairs for PipeWire.

## Problem

The Ui24 presents 32 input + 32 output channels as a single multichannel ALSA device. PipeWire exposes this as one 32-channel sink/source with AUX0-AUX31 positions. Apps like VLC can't handle this and map audio across random channels.

## Solution

Uses PipeWire's `module-loopback` to create 16 virtual stereo sinks and 16 virtual stereo sources, each mapped to a specific channel pair (1/2, 3/4, ..., 31/32).

## Install

```bash
./install.sh
```

## Uninstall

```bash
./uninstall.sh
```

## Verify

```bash
# Check devices
wpctl status | grep soundcraft

# Play test tone to pair 1/2
pw-play --target soundcraft_out_pair_01_02 /usr/share/sounds/freedesktop/stereo/bell.oga
```

## Requirements

- PipeWire (with pipewire-pulse)
- Soundcraft Ui24 connected via USB
