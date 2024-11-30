#!/bin/bash

apps=("parole" "Media player" on \
	"qvidcap" "Webcam recorder" on \
	"xfburn" "CD/DVD burner" on \
	"qv4l2" "video4linux interface tool" on)

# Display the checklist and capture the selected options
selected_apps=$(whiptail --title "Remove bloatware" --backtitle "Use space to select" --checklist "Choose" 16 78 10 "${apps[@]}" 3>&1 1>&2 2>&3)

# Convert selected options to an array
selected_apps_array=($(echo "$selected_apps" | tr -d '"'))

for app in "${selected_apps_array[@]}"; do
	echo "================================="
	echo -e "\033[1m~> Removing $app\033[0m"
	echo "================================="
	echo

	sudo pacman -Rncs $app
done

