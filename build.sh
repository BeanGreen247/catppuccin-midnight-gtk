#!/bin/bash
# =============================================================================
# build.sh — Build the Midnight-Blue GTK theme
#
# Downloads catppuccin-mocha-blue v1.0.3 (final release of catppuccin/gtk,
# archived Jun 2024), applies the midnight navy/blue color patch, and
# produces a Midnight-Blue.tar.gz ready for installation or GitHub release.
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
PATCH="$SCRIPT_DIR/src/patch.sh"

INSTALL=false
if [[ "${1:-}" == "--install" ]]; then
    INSTALL=true
fi

# Dependencies check
for cmd in curl unzip; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "ERROR: '$cmd' is required but not installed." >&2
        exit 1
    fi
done

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "[1/4] Downloading catppuccin-mocha-blue v1.0.3..."
curl -fsSL "$BASE_URL" -o "$TMP/theme.zip"

echo "[2/4] Extracting..."
unzip -q "$TMP/theme.zip" -d "$TMP/extracted"
SRC="$(find "$TMP/extracted" -mindepth 1 -maxdepth 1 -type d | head -1)"

# Rename to Midnight-Blue
cp -r "$SRC" "$TMP/$THEME_NAME"

echo "[3/4] Applying midnight-blue color patch..."
bash "$PATCH" "$TMP/$THEME_NAME"

# Fix theme name in index.theme
sed -i \
    -e "s/Name=catppuccin-mocha-blue-standard+default/Name=$THEME_NAME/" \
    -e "s/GtkTheme=catppuccin-mocha-blue-standard+default/GtkTheme=$THEME_NAME/" \
    -e "s/MetacityTheme=catppuccin-mocha-blue-standard+default/MetacityTheme=$THEME_NAME/" \
    "$TMP/$THEME_NAME/index.theme"

if $INSTALL; then
    echo "[4/4] Installing to /usr/share/themes/$THEME_NAME..."
    if [ "$(id -u)" != "0" ]; then
        echo "ERROR: --install requires root. Run with sudo." >&2
        exit 1
    fi
    rm -rf "/usr/share/themes/$THEME_NAME"
    cp -r "$TMP/$THEME_NAME" "/usr/share/themes/$THEME_NAME"
    echo "✓ Installed to /usr/share/themes/$THEME_NAME"
else
    echo "[4/4] Packaging to $DIST_DIR/$THEME_NAME.tar.gz..."
    mkdir -p "$DIST_DIR"
    tar -czf "$DIST_DIR/$THEME_NAME.tar.gz" -C "$TMP" "$THEME_NAME"
    echo "✓ Built: $DIST_DIR/$THEME_NAME.tar.gz"
    echo ""
    echo "  Install with:"
    echo "    sudo tar -xzf dist/$THEME_NAME.tar.gz -C /usr/share/themes/"
    echo "  Or run:  sudo bash build.sh --install"
fi
