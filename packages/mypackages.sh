#!/bin/bash

# yay required
if [ ! -f /usr/bin/yay ]; then
	echo "================================="
	echo -e "\033[1m~> Please install yay before running this script\033[0m"
	echo "================================="
	exit
fi


apps=("zsh" "Shell" on \
	"exa" "Better ls" on \
	"zoxide" "Better cd" on \
	"devtools" "Tools for C/C++ Development" on \
	"kitty" "Terminal emulator" on \
	"rclone" "Connect to Google Drive" off \
	"vlc" "" on \
	"simplescreenrecorder" "" on \
	"firefox" "" on \
	"vesktop" "" on \
	"discord" "" off \
	"vencord" "" off)

# Display the checklist and capture the selected options
selected_apps=$(whiptail --title "mypackages packages" --backtitle "Use space to select" --checklist "Choose" 16 78 10 "${apps[@]}" 3>&1 1>&2 2>&3)

# Convert selected options to an array
selected_apps_array=($(echo "$selected_apps" | tr -d '"'))

echo -e "\033[1m~> UPDATING SYSTEM FIRST\033[0m"
sudo pacman -Syyu
echo

# Iterate through the selected options and process each one
for app in "${selected_apps_array[@]}"; do
	echo

	case "$app" in
		"zsh")
			echo "================================="
			echo -e "\033[1m~> Installing the following packages:\033[0m"
			echo "- zsh"
			echo "================================="
			echo

			sudo pacman -S zsh
			;;

		"exa")
			echo "================================="
			echo -e "\033[1m~> Installing the following packages:\033[0m"
			echo "- exa"
			echo "================================="
			echo

			sudo pacman -S exa
			;;

		"zoxide")
			echo "================================="
			echo -e "\033[1m~> Installing the following packages:\033[0m"
			echo "- zoxide"
			echo "================================="
			echo

			sudo pacman -S zoxide
			;;

		"kitty")
			echo "================================="
			echo -e "\033[1m~> Installing the following packages:\033[0m"
			echo "- kitty"
			echo "================================="
			echo

			sudo pacman -S kitty
			;;

		"vlc")
			echo "================================="
			echo -e "\033[1m~> Installing the following packages:\033[0m"
			echo "- vlc"
			echo "================================="
			echo

			sudo pacman -S vlc
			;;

		"firefox")
			echo "================================="
			echo -e "\033[1m~> Installing the following packages:\033[0m"
			echo "- firefox"
			echo "================================="
			echo

			sudo pacman -S firefox
			;;

		"discord")
			echo "================================="
			echo -e "\033[1m~> Installing the following packages:\033[0m"
			echo "- discord"
			echo "================================="
			echo

			sudo pacman -S discord
			;;

		"vesktop")
			echo "================================="
			echo -e "\033[1m~> Installing the following packages:\033[0m"
			echo "- vesktop"
			echo "================================="
			echo

			yay -S vesktop-bin
			;;

		"vencord")
			echo "================================="
			echo -e "\033[1m~> Installing the following packages:\033[0m"
			echo "- vencord"
			echo "================================="
			echo

			sh -c "$(curl -SyS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"
			;;

		# Penultimate because of the explanation
		"devtools")
			echo "================================="
			echo -e "\033[1m~> Installing the following packages:\033[0m"
			echo "- base-devel"
			echo "- git"
			echo "- lazygit"
			echo "- clang"
			echo "- make"
			echo "- cmake"
			echo "- gdb"
			echo "- valgrind"
			echo "- beark"
			echo "- mingw-w64-gcc"
			echo "================================="
			echo

			sudo pacman -S --needed base-devel git clang make cmake gdb valgrind bear mingw-w64-gcc

			# bear: bear -- make to make compile_commands.json
			# x86_64-w64-mingw32-g++ -o myexec.exe main.cpp
			echo "================================="
			echo -e "\033[1m~> Usage example:\033[0m"
			echo -e "\t\033[1m~> bear:\033[0m"
			echo -e "\t\t~> Generate compile_commands.json:"
			echo -e "\t\tbear -- make"
			echo
			echo -e "\t\033[1m~> mingw:\033[0m"
			echo -e "\t\t~> Compile with mingw:"
			echo -e "\t\tx86_64-w64-mingw32-g++ -o myexec.exe main.cpp"
			echo "================================="
			echo

			sleep 5
			;;

		# Last one because the explanation is big
		"rclone")
			echo "================================="
			echo -e "\033[1m~> Installing the following packages:\033[0m"
			echo "- rclone"
			echo "================================="
			echo

			sudo -v ; curl https://rclone.org/install.sh | sudo bash

			echo "================================="
			echo -e "\033[1m~> How to configure:\033[0m"
			echo "1. Run: rclone config"
			echo "2. Name as \"gdrive\" or whatever"
			echo "3. Choose the Google Driver number (19)"
			echo "4. Leave empty for client_id"
			echo "5. Leave empty for client_secret"
			echo "6. Choose 1 for full acess"
			echo "7. Leave empty for service_account_file"
			echo "8. Choose \"No\" for advanced config"
			echo "9. Choose \"Yes\" for authenticate with a web browser"
			echo "10. Choose \"No\" for Shared Drive"
			echo "11. Choose \"Yes\" for confirm settings"
			echo "12. Quit"
			echo "================================="
			echo

			sleep 10
			;;

		# Last because takes much time to install
		"simplescreenrecorder")
			echo "================================="
			echo -e "\033[1m~> Installing the following packages:\033[0m"
			echo "- simplescreenrecorder"
			echo "================================="
			echo

			yay -S simplescreenrecorder
			;;


		*)
			echo "Unknown selection: $app"
			;;

	esac

	echo
done

