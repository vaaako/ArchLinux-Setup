#!/bin/bash

BACKUP_DIR="backup_files"

# ===== LOCATION ===== #
NEOFETCH_DIR=~/.config/neofetch
KITTY_DIR=~/.config/kitty
XFCE4_DIR=~/.config/xfce4/xfconf/xfce-perchannel-xml
ZSH_DIR=~/.config/zsh

# ===== TARGET ===== #
NEOFETCH_TARGET="$BACKUP_DIR/neofetch"
KITTY_TARGET="$BACKUP_DIR/kitty"
XFCE4_TARGET="$BACKUP_DIR/xfce4"
XFCE4PANEL_TARGET="$BACKUP_DIR/xfce4-panel"
GTK_TARGET="$BACKUP_DIR/gtk"
SHELL_TARGET="$BACKUP_DIR/shell"

# Reset before backup
if [ "$1" == "-d" ]; then
	rm -rf "$BACKUP_DIR" || { echo "Failed to delete backup folder"; exit 1; }

elif [ -n "$1" ]; then
	echo "Argument not recognized, possible argument is -d to delete backup folder before backup"
	exit 1
fi

# Check if running as sudo
if [ "$EUID" -eq 0 ]; then
	echo "Please, do not run as sudo"
	exit 1
fi

TARGETS=(
	"$BACKUP_DIR"
	"$NEOFETCH_TARGET"
	"$KITTY_TARGET"
	"$XFCE4_TARGET"
	"$XFCE4PANEL_TARGET"
	"$GTK_TARGET"
	"$SHELL_TARGET"
)

# Make all target folders
for TARGET in "${TARGETS[@]}"; do
	if [ ! -d "$TARGET" ]; then
		mkdir -p "$TARGET" || { echo "Failed to create directory: $TARGET"; exit 1; }
	fi
done

# NEOFETCH_DIR
if [ ! -f /usr/bin/neofetch ]; then
	echo "neofetch is not installed, skipping..."
else
	echo "Making neofetch backup..."
	cp "$NEOFETCH_DIR"/*.txt "$NEOFETCH_DIR/config.conf" "$NEOFETCH_TARGET" || { echo "Failed to back up neofetch"; exit 1; }
fi

# KITTY_DIR
if [ ! -f /usr/bin/kitty ]; then
	echo "kitty is not installed, skipping..."
else
	echo "Making kitty backup..."
	cp "$KITTY_DIR"/*.conf "$KITTY_TARGET" || { echo "Failed to back up kitty"; exit 1; }
fi

# ZSH_DIR and bash
if [ ! -f /usr/bin/zsh ]; then
	echo "zsh is not installed, skipping..."
else
	echo "Making shell config files backup..."
	cp ~/.zshrc "$SHELL_TARGET" || { echo "Failed to back up .zshrc"; exit 1; }
	cp ~/.bashrc "$SHELL_TARGET" || { echo "Failed to back up .bashrc"; exit 1; }
fi

# === XFCE4 === #
# XFCE4_DIR
echo "Making xfce4 config files backup..."
cp "$XFCE4_DIR"/*.xml "$XFCE4_TARGET" || { echo "Failed to back up xfce4"; exit 1; }
rm "$XFCE4_TARGET"/displays.xml \
	"$XFCE4_TARGET"/xfce4-power-manager.xml \
	"$XFCE4_TARGET"/xfce4-screenshooter.xml \
	"$XFCE4_TARGET"/xfce4-taskmanager.xml 2> /dev/null # Ignore if not found
	# Uncomment below if needed with sudo
	# sudo rm "$XFCE4_TARGET"/parole.xml "$XFCE4_TARGET"/ristretto.xml

# XFCE4 PANEL
echo "Making xfce4 panel backup..."
cp -r ~/.config/xfce4/panel/* "$XFCE4PANEL_TARGET" || { echo "Failed to back up xfce4 panel"; exit 1; }
# === XFCE4 === #

# GTK_DIR
echo "Making gtk backup..."
cp ~/.config/gtk-3.0/* "$GTK_TARGET" || { echo "Failed to back up gtk"; exit 1; }

echo "Backup done!"

