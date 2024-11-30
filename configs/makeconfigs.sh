#!/bin/bash

CONFS=("passwd" "View password stars" on \
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

		"lightdm")
			LIGHTDM_PATH=$(find . -name "lightdm-conf.txt" -print -quit)
			if [ -z "$LIGHTDM_PATH" ]; then
				echo "configs/lightdm-conf.txt not found!"
				exit
			fi

			sudo cp "$LIGHTDM_PATH" /etc/lightdm/lightdm-gtk-greeter.conf
			;;

		"fstab")
			FSTAB_PATH=$(find . -name "fstab-hd.txt" -print -quit)
			if [ -z $FSTAB_PATH ]; then
				echo "configs/fstab-hd.txt not found!"
				exit
			fi

			# Make backup
			sudo cp /etc/fstab /etc/fstab.bak
			# Apply new config
			sudo sh -c "cat $FSTAB_PATH >> /etc/fstab"
			# Restart and apply mounts
			sudo systemctl daemon-reload
			sudo mount -a
			;;

		*)
			echo "Unkown selection: $CONF"
			;;
	esac
done