#!/bin/bash

BACKUP_DIR="backup_files"

if [ ! -d "$BACKUP_DIR" ]; then
	echo "Backup folder \"$BACKUP_DIR/\" does not exist! Try running restore.sh from project's root"
	exit 1
fi

TARGETS=("neofetch" "" on \
	"kitty" "" on \
	"xfce4" "XFCE4 Configs" on \
	"xfce4-panels" "Top and bottom panels" on \
	"shell" ".zshrc and .bashrc" on)


# Display
SELECTED=$(whiptail --title "Restore backup" --backtitle "Use space to select" --checklist "Choose" 16 78 10 "${TARGETS[@]}" 3>&1 1>&2 2>&3)

# Convert to array
SELECTED_ARRAY=($(echo "$SELECTED" | tr -d '"'))

BACKUP=0 # False by default
if whiptail --title "Make backup before?" --yesno "This will apply the sufix .bak to the target file/folder at its location" 10 60; then
	BACKUP=1
fi

for TARGET in "${SELECTED_ARRAY[@]}"; do
	echo

	case "$TARGET" in
		"neofetch")
			if [ ! -d "$BACKUP_DIR/neofetch" ]; then
				echo "neofetch backup folder does not exist"
				exit 1
			fi

			if [ ! -f /usr/bin/neofetch ]; then
				echo "neofetch is not installed, skipping..."
				continue
			fi

			echo "Making neofetch restoration..."

			# Make a backup folder before and move all files to it
			if [ $BACKUP -eq 1 ]; then
				mkdir -p ~/.config/neofetch/backup
				cp -r ~/.config/neofetch/* ~/.config/neofetch/backup || { echo "Backup failed"; exit 1; }
			fi
			cp -r "$BACKUP_DIR/neofetch"/* ~/.config/neofetch || { echo "Restoration failed"; exit 1; }
			;;

		"kitty")
			if [ ! -d "$BACKUP_DIR/kitty" ]; then
				echo "kitty backup folder does not exist"
				exit 1
			fi

			if [ ! -f /usr/bin/kitty ]; then
				echo "kitty is not installed, skipping..."
				continue
			fi

			echo "Making kitty restoration..."

			# Make a backup folder before and move all files to it
			if [ $BACKUP -eq 1 ]; then
				mkdir -p ~/.config/kitty/backup
				cp -r ~/.config/kitty/* ~/.config/kitty/backup || { echo "Backup failed"; exit 1; }
			fi
			cp -r "$BACKUP_DIR/kitty"/* ~/.config/kitty || { echo "Restoration failed"; exit 1; }
			;;

		"xfce4")
			XFCE4_DIR=~/.config/xfce4/xfconf/xfce-perchannel-xml

			if [ ! -d "$BACKUP_DIR/xfce4" ]; then
				echo "xfce4 backup folder does not exist"
				exit 1
			fi

			echo "Making xfce4 restoration..."

			# Make a backup folder before and move all files to it
			if [ $BACKUP -eq 1 ]; then
				mv "$XFCE4_DIR" ~/.config/xfce4/xfconf/xfce-perchannel-xml.bak || { echo "Backup failed"; exit 1; }
				mkdir -p "$XFCE4_DIR"
			fi
			cp -r "$BACKUP_DIR/xfce4"/* "$XFCE4_DIR" || { echo "Restoration failed"; exit 1; }
			;;

		"xfce4-panels")
			if [ ! -d "$BACKUP_DIR/xfce4-panel" ]; then
				echo "xfce4-panel backup folder does not exist"
				exit 1
			fi

			echo "Making xfce4-panels restoration..."

			# Make a backup folder before and move all files to it
			if [ $BACKUP -eq 1 ]; then
				mv ~/.config/xfce4/panel ~/.config/xfce4/panel.bak || { echo "Backup failed"; exit 1; }
				mkdir -p ~/.config/xfce4/panel
			fi
			cp -r "$BACKUP_DIR/xfce4-panel"/* ~/.config/xfce4/panel || { echo "Restoration failed"; exit 1; }
			;;

		"shell")
			if [ ! -d "$BACKUP_DIR/shell" ]; then
				echo "shells backup folder does not exist"
				exit 1
			fi

			echo "Making shells restoration..."

			# Make a backup of shells
			if [ $BACKUP -eq 1 ]; then
				cp ~/.zshrc ~/.zshrc.bak || { echo "Backup failed"; exit 1; }
				cp ~/.bashrc ~/.bashrc.bak || { echo "Backup failed"; exit 1; }
			fi
			cp -r "$BACKUP_DIR/shell"/* ~/ || { echo "Restoration failed"; exit 1; }
			;;

		*)
			echo "Unknown selection: $TARGET"
			;;
	esac

	echo
done
