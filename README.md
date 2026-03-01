# catppuccin-midnight-gtk

A custom GTK theme based on [Catppuccin Mocha Blue](https://github.com/catppuccin/gtk) (v1.0.3 — final release),
with the purple-grey palette replaced by a midnight navy/blue scheme to match
the [sway-setup-script](https://github.com/bean/sway-setup-script) waybar/rofi/sway color system.

> **Note:** `catppuccin/gtk` was permanently archived in June 2024.
> This repo maintains a patched fork of their last release.

---

## Colors

| Role | Catppuccin Mocha | Midnight-Blue |
|---|---|---|
| Window background | `#1e1e2e` | `#0a1628` |
| Deep background | `#181825` | `#08101e` |
| Crust | `#11111b` | `#050a12` |
| Selected / surface | `#313244` | `#1a2a3a` |
| Hover | `#45475a` | `#1e3d5c` |
| Surface2 | `#585b70` | `#2a5a8a` |
| Muted fg | `#6c7086` | `#4a6a8a` |
| Blue accent | `#89b4fa` | `#58a6ff` |
| Primary text | `#cdd6f4` | `#dce8f5` |
| Subtext | `#bac2de` | `#b0c8e0` |

---

## Install

### One-liner (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/bean/catppuccin-midnight-gtk/main/install.sh | bash
```

Installs to `/usr/share/themes/` if run as root, else `~/.themes/`.

### From release tarball

```bash
# Download latest release
curl -fsSL https://github.com/bean/catppuccin-midnight-gtk/releases/latest/download/Midnight-Blue.tar.gz \
  | sudo tar -xzf - -C /usr/share/themes/
```

### Build from source

```bash
git clone https://github.com/bean/catppuccin-midnight-gtk
cd catppuccin-midnight-gtk
sudo bash build.sh --install
```

---

## Apply

**lxappearance:** Widget tab → select `Midnight-Blue`

**gtk-3.0/settings.ini:**
```ini
[Settings]
gtk-theme-name=Midnight-Blue
```

**gsettings:**
```bash
gsettings set org.gnome.desktop.interface gtk-theme 'Midnight-Blue'
```

---

## Updating the color map

Edit `src/patch.sh` to change any color mapping, then run `build.sh` to rebuild.
Submit a PR if you want the change upstream.

---

## License

MIT — same as the upstream [catppuccin/gtk](https://github.com/catppuccin/gtk).
