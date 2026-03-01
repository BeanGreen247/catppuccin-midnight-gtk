#!/bin/bash
# =============================================================================
# Midnight-Blue color patch
# Remaps Catppuccin Mocha's purple-grey palette → midnight navy/blue palette.
#
# Catppuccin Mocha → Midnight-Blue
#   #1e1e2e  base window bg        → #0a1628
#   #181825  darker bg / borders   → #08101e
#   #11111b  crust / deepest bg    → #050a12
#   #313244  surface0 / selected   → #1a2a3a
#   #45475a  surface1 / hover      → #1e3d5c
#   #585b70  surface2              → #2a5a8a
#   #6c7086  overlay0 / muted fg   → #4a6a8a
#   #7f849c  overlay1              → #4a7ba7
#   #9399b2  overlay2              → #6a9bcf
#   #89b4fa  blue accent           → #58a6ff
#   #74c7ec  sapphire / sky        → #79c0ff
#   #cdd6f4  primary text          → #dce8f5
#   #bac2de  subtext1              → #b0c8e0
#   #a6adc8  subtext0              → #8ab0d0
#   #f38ba8  red                   → #ff5555
#   #a6e3a1  green                 → #3fb950
#   #f9e2af  yellow                → #e3b341
#   #fab387  peach / orange        → #ff9944
# =============================================================================
set -e

THEME_DIR="${1:?Usage: $0 <theme-dir>}"

if [ ! -d "$THEME_DIR" ]; then
    echo "ERROR: directory not found: $THEME_DIR" >&2
    exit 1
fi

echo "  Patching: $THEME_DIR"

find "$THEME_DIR" -name "*.css" | while read -r f; do
    sed -i \
        -e 's/#1e1e2e/#0a1628/gI' \
        -e 's/#181825/#08101e/gI' \
        -e 's/#11111b/#050a12/gI' \
        -e 's/#313244/#1a2a3a/gI' \
        -e 's/#45475a/#1e3d5c/gI' \
        -e 's/#585b70/#2a5a8a/gI' \
        -e 's/#6c7086/#4a6a8a/gI' \
        -e 's/#7f849c/#4a7ba7/gI' \
        -e 's/#9399b2/#6a9bcf/gI' \
        -e 's/#89b4fa/#58a6ff/gI' \
        -e 's/#74c7ec/#79c0ff/gI' \
        -e 's/#cdd6f4/#dce8f5/gI' \
        -e 's/#bac2de/#b0c8e0/gI' \
        -e 's/#a6adc8/#8ab0d0/gI' \
        -e 's/#f38ba8/#ff5555/gI' \
        -e 's/#a6e3a1/#3fb950/gI' \
        -e 's/#f9e2af/#e3b341/gI' \
        -e 's/#fab387/#ff9944/gI' \
        "$f"
done

echo "  Patch applied."
