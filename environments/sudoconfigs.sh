#!/bin/bash

CONFS=("passwd" "View password stars" on \
	"pacman" "pacman.conf config" on \
	"lightdm" "" on \
	"fstab" "Auto mount /dev/sdb1" on)


# Display
SELECTED=$(whiptail --title "Make config of..." --backtitle "Use space to select" --checklist "Choose" 16 78 10 "${CONFS[@]}" 3>&1 1>&2 2>&3)

# Convert to array
SELECTED_ARRAY=($(echo "$SELECTED" | tr -d '"'))

for CONF in "${SELECTED_ARRAY[@]}"; do
	case "$CONF" in
		"passwd")
			echo "Enabling password stars"
			sudo sh -c "echo 'Defaults pwfeedback' >> /etc/sudoers"
			;;

		"pacman")
			FILE="/etc/pacman.conf"
			# Uncomment 'Color' and 'ParallelDownloads'
			sudo sed -i 's/^#Color/Color/' "$FILE"
			sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' "$FILE"

			echo "Color and ParallelDownloads uncommented successfully."
			;;

		"lightdm")
			sudo echo -e "[greeter]\ntheme-name = Adwaita-dark\nicon-theme-name = Adwaita" > /etc/lightdm/lightdm-gtk-greeter.conf
			;;

		"fstab")
			if [ ! -f /usr/bin/mkfs.ntfs ]; then
				echo "ntfs-3g not installed, installing"
				sudo pacman -S ntfs-3g --noconfirm
			fi

			# Make backup
			sudo cp /etc/fstab /etc/fstab.bak
			# Apply new config
			echo -e "\n/dev/sdb1 /mnt/WD-1TB ntfs-3g defaults,uid=1000,gid=1000,umask=022,x-gvfs-show 0 0" >> /etc/fstab
			# Restart and apply mounts
			sudo systemctl daemon-reload
			sudo mount -a
			;;

		*)
			echo "Unkown selection: $CONF"
			;;
	esac
done
