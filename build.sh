#!/bin/bash
# =============================================================================
# build.sh — Build the Midnight-Blue GTK theme
#
# Uses the pre-patched Midnight-Blue/ directory in this repo to produce
# a Midnight-Blue.tar.gz ready for installation or GitHub release.
#
# If Midnight-Blue/ is missing (e.g. a bare CI clone without LFS), it falls
# back to downloading catppuccin-mocha-blue v1.0.3 and applying the patch.
#
# Usage:
#   bash build.sh              # outputs ./dist/Midnight-Blue.tar.gz
#   bash build.sh --install    # builds and installs to /usr/share/themes/
# =============================================================================
set -e

THEME_NAME="Midnight-Blue"
BASE_URL="https://github.com/catppuccin/gtk/releases/download/v1.0.3/catppuccin-mocha-blue-standard+default.zip"
DIST_DIR="$(pwd)/dist"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_THEME="$SCRIPT_DIR/$THEME_NAME"
PATCH="$SCRIPT_DIR/src/patch.sh"

INSTALL=false
if [[ "${1:-}" == "--install" ]]; then
    INSTALL=true
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

if [ -d "$LOCAL_THEME" ]; then
    echo "[1/2] Using local $THEME_NAME/ directory..."
    cp -r "$LOCAL_THEME" "$TMP/$THEME_NAME"
else
    echo "Local $THEME_NAME/ not found — falling back to download."

    for cmd in curl unzip; do
        if ! command -v "$cmd" &>/dev/null; then
            echo "ERROR: '$cmd' is required but not installed." >&2
            exit 1
        fi
    done

    echo "[1/4] Downloading catppuccin-mocha-blue v1.0.3..."
    curl -fsSL "$BASE_URL" -o "$TMP/theme.zip"

    echo "[2/4] Extracting..."
    unzip -q "$TMP/theme.zip" -d "$TMP/extracted"
    # The zip contains a single folder; use ls to get its name safely
    SRC_NAME="$(ls "$TMP/extracted" | head -1)"
    cp -r "$TMP/extracted/$SRC_NAME" "$TMP/$THEME_NAME"

    echo "[3/4] Applying midnight-blue color patch..."
    bash "$PATCH" "$TMP/$THEME_NAME"

    sed -i \
        -e "s/Name=.*/Name=$THEME_NAME/" \
        -e "s/GtkTheme=.*/GtkTheme=$THEME_NAME/" \
        -e "s/MetacityTheme=.*/MetacityTheme=$THEME_NAME/" \
        "$TMP/$THEME_NAME/index.theme"

    echo "[4/4] Packaging..."
fi

if $INSTALL; then
    echo "[2/2] Installing to /usr/share/themes/$THEME_NAME..."
    if [ "$(id -u)" != "0" ]; then
        echo "ERROR: --install requires root. Run with sudo." >&2
        exit 1
    fi
    rm -rf "/usr/share/themes/$THEME_NAME"
    cp -r "$TMP/$THEME_NAME" "/usr/share/themes/$THEME_NAME"
    echo "✓ Installed to /usr/share/themes/$THEME_NAME"
else
    echo "[2/2] Packaging to $DIST_DIR/$THEME_NAME.tar.gz..."
    mkdir -p "$DIST_DIR"
    tar -czf "$DIST_DIR/$THEME_NAME.tar.gz" -C "$TMP" "$THEME_NAME"
    echo "✓ Built: $DIST_DIR/$THEME_NAME.tar.gz"
    echo ""
    echo "  Install with:"
    echo "    sudo tar -xzf dist/$THEME_NAME.tar.gz -C /usr/share/themes/"
    echo "  Or run:  sudo bash build.sh --install"
fi
