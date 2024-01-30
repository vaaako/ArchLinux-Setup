#!/bin/bash

#####
# VARS
#####

HEIGHT=20
WIDTH=30

CONFIG_FILES_PATH="$(pwd)/config_files"
XFCE_CONFIG_PATH="${CONFIG_FILES_PATH}/xfce"
NEOFETCH_CONFIG_PATH="${CONFIG_FILES_PATH}/neofetch"

#####
# UTILS
#####

# Function to display an option box
function option_box() {
	local TITLE="$1"
	shift # Shift to take options
	local OPTIONS=("$@")

	local CHOICE=$(
		dialog --menu \
		"${TITLE}" \
		$HEIGHT $WIDTH ${#OPTIONS[@]} \
		"${OPTIONS[@]}" \
		2>&1 >/dev/tty
	)

	echo "$CHOICE"
}

function install_aur() {
	git clone "https://aur.archlinux.org/$1.git"
	cd "$1"
	makepkg -si
	cd ..
	sudo rm -rf "$1"
}

function list_item() {
	local BOLD="\033[1m"
	local MAGENTA="\033[1;35m"
	local BLUE="\e[1;34m"

	local NC="\033[0m"

	echo -e "${BOLD}${BLUE}$1:${NC} $2"
}

function make_bold_blue() {
	local BOLD="\033[1m"
	local BLUE="\e[1;34m"

	local NC="\033[0m"

	echo -e "${BOLD}~> ${BLUE}$1${NC}\n"
}

#####
# FUNCTIONS
#####

function missing_packages() {
	# Audio Stream
	make_bold_blue "Downloading pulseaudio"
	sudo pacman -S pulseaudio pavucontrol

	# Codecs
	make_bold_blue "Downloading Codecs"
	sudo pacman -S ffmpeg gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-plugins-base gst-libav gstreamer

	# Thunar
	make_bold_blue "Downloading Thunar essencial packages"
	sudo pacman -S exa thunar-archive-plugin file-roller
	#              Better LS, Archive plugin, Compress manager

	# Fonts
	make_bold_blue "Downloading Fonts"
	sudo pacman -S ttf-jetbrains-mono-nerd ttf-ubuntu-font-family ttf-liberation ttf-cascadia-code
	#              Nerd font               System font            Github Font    My favorite font for coding
	
	make_bold_blue "Downloading Noto Fonts"
	sudo pacman -S noto-fonts noto-fonts-cjk               noto-fonts-emoji
	#              Japanese and characters support font    Emoji font

	# e.g. open browser when click a link on discord and other features
	make_bold_blue "Downloading xdg-utils"
	echo "e.g. open browser when click a link on discord and other features"
	sudo pacman -S xdg-utils

	# Firewall
	make_bold_blue "Downloading firewall"
	sudo pacman -S ufw gufw

	## Start firewall
	make_bold_blue "Enabling firewall"
	sudo systemctl enable ufw.service
	sudo systemctl start ufw.service

	# sudo systemctl start bluetooth.service --now


	# Mugshot
	make_bold_blue "Downloading mugshot"
	install_aur "mugshot"
}


function essencial_packages() {
	make_bold_blue "Downloading git and wget"
	sudo pacman -S git wget

	# Manager of user directories (Downloads, Documents etc)
	# sudo pacman -S xdg-user-dirs

	make_bold_blue "Downloading bash completition for pacman"
	sudo pacman -S bash_completition

	# Trash and devices manager
	make_bold_blue "Downloading gvfs"
	sudo pacman -S gvfs

# Just run the command bellow if gvfs don't create the trash folder
# MNT=/; ID=$(id -u); sudo mkdir -p "$MNT/.Trash-$ID"/{expunged,files,info} \
#   && sudo chown -R $USER:$USER "$MNT/.Trash-$ID"/ \
#   && sudo chmod -R o-rwx "$MNT/.Trash-$ID"/

	clear
	make_bold_blue "Reboot the system to gvfs work"
}


function panel_css() {
	local GTK_PATH="${HOME}/.config/gtk-3.0/"

	if [ ! -d $GTK_PATH ]; then
		mkdir -p $GTK_PATH 
	fi

	cp "${XFCE_CONFIG_PATH}/gtk.css" $GTK_PATH
	xfce-panel -r
}


function xfce_xml() {
	# If not unziped
	if [ ! -d "${XFCE_CONFIG_PATH}" ]; then
		# If zip doesn't exist
		if [ ! -f "${XFCE_CONFIG_PATH}.zip" ]; then
			echo "~> Missing file ${XFCE_CONFIG_PATH}.zip"
			exit
		fi

		unzip "${XFCE_CONFIG_PATH}.zip" -d "${CONFIG_FILES_PATH}"
	fi

	# Copy all files
	cp "$XFCE_CONFIG_PATH"/*.xml "${HOME}/.config/xfce/xfconf/xfce-perchannel-xml"
}


function icons_and_themes() {
	local BOLD="\033[1m"
	local NC="\033[0m"

	echo "- Themes -"
	list_item "MacOS Dark" "https://www.xfce-look.org/p/1279806/"
	list_item "Catppuccin Theme (Mocha-B)" "https://www.xfce-look.org/p/1279806/"
	list_item "Catppuccin Icons (Choose mocha)" "https://www.xfce-look.org/p/1279806/"

	echo -e "\n- Icons -"
	list_item "Vimix" "https://www.opendesktop.org/p/1273372"
	list_item "Bibata Cursor" "https://www.xfce-look.org/p/1914825"

	echo -e "\n~> Move themes to ${BOLD}~/.themes${NC} and icons to ${BOLD}~/.icons${NC}"

	echo -e "(sorry, I am won't dowload all this and zip to github)"

# - Mocha: Purple
# 	- Alt: Orange
# 	- Alt2: Folder with black details
# - Macchiato: Orange
# - Frappe: Blue
# - Latte: Slightly dark blue
}



function terminal_theme() {
	local COLORSCHEME_PATH="${HOME}/.local/share/xfce/terminal/colorschemes"

	if [ ! -d $COLORSCHEME_PATH ]; then
		mkdir -p $COLORSCHEME_PATH
	fi

	# Copy theme to path
	wget https://raw.githubusercontent.com/endeavouros-team/endeavouros-xfce-terminal-colors/master/endeavouros.theme -P $COLORSCHEME_PATH

	make_bold_blue "Change the terminal background color to #101017"
}


function bashrc() {
	# Set completion ignore case sensitive

	# If ~/.inputrc doesn't exist yet: First include the original /etc/inputrc
	# so it won't get overriden
	if [ ! -a ~/.inputrc ]; then
		echo '$include /etc/inputrc' > ~/.inputrc
	fi

	# Add shell-option to ~/.inputrc to enable case-insensitive tab completion
	echo 'set completion-ignore-case On' >> ~/.inputrc

	# Insert bashr
	cat "${CONFIG_FILES_PATH}/bashrc.txt" >> "${HOME}/.bashrc"
}


function neofetch() {
	if [ ! -f "/usr/bin/neofetch" ]; then
		echo "~> You have Arch, why don't you have neofetch??"
		sudo pacman -S neofetch
	fi

	# If not unziped
	if [ ! -d "${NEOFETCH_CONFIG_PATH}" ]; then
		# If zip doesn't exist
		if [ ! -f "${NEOFETCH_CONFIG_PATH}.zip" ]; then
			echo "~> Missing file ${NEOFETCH_CONFIG_PATH}.zip"
			exit
		fi

		unzip "${NEOFETCH_CONFIG_PATH}.zip" -d "${CONFIG_FILES_PATH}"
	fi

	local NEOFETCH_PATH="${HOME}/.config/neofetch"

	# Make backup
	cp "${NEOFETCH_PATH}/config.conf" "${NEOFETCH_PATH}/config.conf.bak"

	# Copy files
	cp "$NEOFETCH_CONFIG_PATH"/*.txt "${NEOFETCH_CONFIG_PATH}/config.conf" "${NEOFETCH_PATH}"
}


function xfce_install() {
	sudo pacman -S xorg xfce4 xfce4-terminal xfce4-goodies xfce4-whiskermenu-plugin lightdm lightdm-gtk-greeter
}


function vako_apps() {
	make_bold_blue "Downloading Vako Apps"
	
	sudo pacman -S opera opera-ffmpeg-codecs discord vlc
	# opera needs this codec to play spotify

	# Vencord
	sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"

	# C/C++ Dev tools
	sudo pacman -S clang cmake gdb valgrind

	install_aur "simplescreenrecorder"
}




# pacman -R $(pacman -Qdtq)
# Remove all unrequired packages
# Q = Query
# d = Depths
# t = Unrequired
# q = Quiet

function main() {
	local TITLE="Arch Linux setup \nUse Arrows to move"
	local OPTIONS=(
		1 "Missing Packages"
		2 "Essencial Packages"
		3 "Panel CSS"
		4 "XFCE XMLs"
		5 "Icons and Themes"
		6 "Terminal theme"
		7 ".bashrc"
		8 "neofetch"
		9 "XFCE Install"
		10 "Vako Apps"
	)

	local CHOICE=$(option_box "${TITLE}" "${OPTIONS[@]}")


	clear
	case $CHOICE in
		1)
			missing_packages
			;;
		2)
			essencial_packages
			;;
		3)
			panel_css
			;;
		4)
			xfce_xml
			;;
		5)
			icons_and_themes
			;;
		6)
			terminal_theme
			;;
		7)
			bashrc
			;;
		8)
			neofetch
			;;

		# In case I git clone this script to install XFCE
		9)
			xfce_install
			;;

		10)
			vako_apps
			;;
	esac
}


#####
# BEFORE - START
#####

if [ ! -f "/usr/bin/dialog" ]; then
	echo "~> Please install whiptail to use this script"
	exit
fi

if [ $EUID == 0 ]; then
	# clear
	echo "~> Don't run as root, since some things cannot work!"
	exit
fi

main

# menu / yesno / inputbox / msgbox / checklist / radiolist
# Title
# Height and Width
# Number of items
# Menu items
# choice=$(whiptail --menu "Choose an option" 10 30 3 1 "Option 1" 2 "Option 2" 3 "Option 3")
# echo "You chose option $choice"



