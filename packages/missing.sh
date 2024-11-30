#!/bin/bash

apps=("Pulseaudio" "Pulseaudio, alsa and Pavucontrol" on \
	"Pipewire" "Pipeware and Pavucontrol" off \
	"Codecs" "Audio codecs" on \
	"Thunar" "Thunar plugins and File manager utilities" on \
	"Fonts" "" on \
	"xdg" "(Open browser when clicking a link and other utilities)" on \
	"calculator" "" on \
	"Firewall" "" on \
	"Mugshot" "" on)

# Display the checklist and capture the selected options
selected_apps=$(whiptail --title "Missing packages" --backtitle "Use space to select" --checklist "Choose" 16 78 10 "${apps[@]}" 3>&1 1>&2 2>&3)

# Convert selected options to an array
selected_apps_array=($(echo "$selected_apps" | tr -d '"'))

# Iterate through the selected options and process each one
for app in "${selected_apps_array[@]}"; do
	echo

	case "$app" in
		"Pulseaudio")
			echo "================================="
			echo -e "\033[1m~> [PULSEAUDIO] Installing the following packages:\033[0m"
			echo "- pulseaudio"
			echo "- pulseaudio-alsa"
			echo "- pavucontrol"
			echo "================================="
			echo

			sudo pacman -S pulseaudio pulseaudio-alsa pavucontrol

			# Enable pulseaudio
			pulseaudio --check
			pulseaudio -D
			;;

		"Pipewire")
			echo "================================="
			echo -e "\033[1m~> [PIPEWIRE] Installing the following packages:\033[0m"
			echo "- pipeware-jack"
			echo "- pipeware-alsa"
			echo "- pipeware-pulse"
			echo "- pavucontrol"
			echo -e "\033[1m~> Installing the following package:\033[0m"
			echo "- pulseaudio"
			echo "================================="
			echo

			sudo pacman -Rcns pulseaudio # Remove pulseaudio if have
			sudo pacman -S pipewire-jack pipewire-alsa pipewire-pulse pavucontrol

			# Enable pipewire
			systemctl enable --now --user pipewire-pulse
			;;

		"Codecs")
			echo "================================="
			echo -e "\033[1m~> [CODECS] Installing the following packages:\033[0m"
			echo "- ffmpeg"
			echo "- gstreamer"
			echo "- gst-libav"
			echo "- gst-plugins-good"
			echo "- gst-plugins-bad"
			echo "- gst-plugins-ugly"
			echo "- gst-plugins-base"
			echo "================================="
			echo

			sudo pacman -S ffmpeg gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-plugins-base gst-libav gstreamer
			;;

		"Thunar")
			echo "================================="
			echo -e "\033[1m~> [THUNAR] Installing the following packages:\033[0m"
			echo "- thunar-archive-plugin: Archive plugin"
			echo "- file-roller: Compress manager"
			echo "- gvfs: Trash manager"
			echo "- gvfs-mtp: Auto mount devices"
			echo "================================="
			echo

			sudo pacman -S thunar-archive-plugin file-roller gvfs gvfs-mtp
			;;

		"Fonts")
			echo "================================="
			echo -e "\033[1m~> [FONTS] Installing the following packages:\033[0m"
			echo "- ttf-jetbrains-mono-nerd: For terminal"
			echo "- ttf-ubuntu-font-family: For system"
			echo "- ttf-liberation: For github"
			echo "- ttf-cascadia-code: For code (Sublime and VSCode)"
			echo "- noto-fonts: For emoji"
			echo "- noto-fonts-cjk: For emoji"
			echo "- noto-fonts-emoji: For emoji"
			echo "================================="
			echo

			sudo pacman -S ttf-jetbrains-mono-nerd ttf-ubuntu-font-family ttf-liberation ttf-cascadia-code noto-fonts noto-fonts-cjk noto-fonts-emoji
			;;

		"xdg")
			echo "================================="
			echo -e "\033[1m~> [XDG] Installing the following packages:\033[0m"
			echo "- xdg-utils: Set of utilities for MIME applications"
			echo "- xdg-user-dirs: Make default home directories"
			echo "- xsel: Get content of selection"
			echo "================================="
			echo

			sudo pacman -S xdg-utils xdg-user-dirs xsel
			;;

		"calculator")
			echo "================================="
			echo -e "\033[1m~> [GALCULATOR] Installing the following packages:\033[0m"
			echo "- gnome-calculator: Some calculator"
			echo "================================="
			echo

			sudo pacman -S gnome-calculator
			;;

		"Firewall")
			echo "================================="
			echo -e "\033[1m~> [FIREWALL] Installing the following packages:\033[0m"
			echo "- ufw: Firewall"
			echo "- gufw: GUI for ufw"
			echo "================================="
			echo

			sudo pacman -S ufw gufw

			if whiptail --title "Enable firewall?" --yesno "Do you want to enable firewall?" 10 60; then
				sudo systemctl enable --now ufw
			fi
			;;

		"yay")
			echo "================================="
			echo -e "\033[1m~> [YAY] Installing the following packages:\033[0m"
			echo "- yay"
			echo "================================="
			echo

			# Not installed
			if [ ! -f /usr/bin/yay ]; then
				git clone "https://aur.archlinux.org/yay.git"
				cd yay
				makepkg -si
				cd ..
				sudo rm -rf yay
			fi
			;;

		"Mugshot")
			echo "================================="
			echo -e "\033[1m~> [MUGSHOT] Installing the following packages:\033[0m"
			echo "- mugshot"
			echo "================================="
			echo

			if [ -f /usr/bin/yay ]; then
				yay -S mugshot
			else
				git clone "https://aur.archlinux.org/mugshot.git"
				cd mugshot
				makepkg -si
				cd ..
				sudo rm -rf mugshot
			fi
			;;

		*)
			echo "Unknown selection: $app"
			;;
	esac

	echo
done

echo "================================="
echo -e "\033[1m~> Please restart the PC to apply some changes\033[0m"
echo "================================="

