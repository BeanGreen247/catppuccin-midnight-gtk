#!/bin/bash
# =============================================================================
# install.sh — One-liner installer for Midnight-Blue GTK theme
#
# Downloads the pre-built release tarball from GitHub and installs it.
# Installs to /usr/share/themes/ if run as root, else ~/.themes/
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/bean/catppuccin-midnight-gtk/main/install.sh | bash
#   # or
#   bash install.sh
# =============================================================================
set -e

THEME_NAME="Midnight-Blue"
REPO="bean/catppuccin-midnight-gtk"
RELEASE_URL="https://github.com/$REPO/releases/latest/download/$THEME_NAME.tar.gz"

for cmd in curl tar; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "ERROR: '$cmd' is required but not installed." >&2
        exit 1
    fi
done

if [ "$(id -u)" = "0" ]; then
    THEME_DIR="/usr/share/themes"
    echo "Installing system-wide to $THEME_DIR/$THEME_NAME"
else
    THEME_DIR="$HOME/.themes"
    echo "Installing for current user to $THEME_DIR/$THEME_NAME"
fi

mkdir -p "$THEME_DIR"
rm -rf "$THEME_DIR/$THEME_NAME"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "Downloading $THEME_NAME..."
curl -fsSL "$RELEASE_URL" -o "$TMP/$THEME_NAME.tar.gz"

echo "Extracting..."
tar -xzf "$TMP/$THEME_NAME.tar.gz" -C "$THEME_DIR"

echo ""
echo "✓ $THEME_NAME installed to $THEME_DIR/$THEME_NAME"
echo ""
echo "  Apply it:"
echo "    lxappearance           → Widget tab → $THEME_NAME"
echo "    gsettings set org.gnome.desktop.interface gtk-theme '$THEME_NAME'"
echo "    # or add to ~/.config/gtk-3.0/settings.ini:"
echo "    # gtk-theme-name=$THEME_NAME"
