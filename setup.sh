#!/bin/bash

#####
# VARS
#####

HEIGHT=15
WIDTH=30

CONFIG_FILES_PATH="$(pwd)/config_files"
XFCE_CONFIG_PATH="${CONFIG_FILES_PATH}/xfce"
KITTY_CONFIG_PATH="${CONFIG_FILES_PATH}/kitty"
NEOFETCH_CONFIG_PATH="${CONFIG_FILES_PATH}/neofetch"

BOLD="\033[1m"
NC="\033[0m"

#####
# UTILS
#####

# Display dialog menu box
function menu_box() {
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

# Display dialog yes/no box
function yesno_box() {
	local TITLE="$1"

	dialog --yesno \
	"${TITLE}" \
	8 $WIDTH \
	2>&1 >/dev/tty

	# Return response
	echo "$?"
	# echo "$CHOICE"
}



function install_aur() {
	git clone "https://aur.archlinux.org/$1.git"
	cd "$1"
	makepkg -si
	cd ..
	sudo rm -rf "$1"
}

function list_item() {
	local MAGENTA="\033[1;35m"
	local BLUE="\e[1;34m"

	echo -e "${BOLD}${BLUE}$1:${NC} $2"
}

function make_bold_blue() {
	local BLUE="\e[1;34m"

	echo -e "${BOLD}~> ${BLUE}$1${NC}\n"
}

function make_bold_red() {
	local RED="\e[1;31m"

	echo -e "${BOLD}~> ${RED}$1${NC}\n"
}

function make_yellow() {
	local YELLOW="\e[1;33m"

	echo -e "~> ${YELLOW}$1${NC}"
}



#####
# FUNCTIONS
#####

#
# Install #
#

function missing_packages() {
	make_bold_blue "Updating first"
	sudo pacman -Syu

	# Audio Stream
	make_bold_blue "Downloading pipewire and pavucontrol"
	# sudo pacman -S pulseaudio pavucontrol
	sudo pacman -Rdd pulseaudio # Remove pulseaudio if have
	sudo pacman -S pipewire-{jack, alsa, pulse}
	sudo pacman -S pavucontrol

	# Enable pipwire
	sudo systemctl --user enable --now pipewire pipewire-pulse

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
	#              Asian characters support font           Emoji font

	# e.g. open browser when click a link on discord and other features
	make_bold_blue "Downloading xdg-utils and xsel"
	echo "e.g. open browser when click a link on discord and other features"
	sudo pacman -S xdg-utils xsel

	# Firewall
	make_bold_blue "Downloading firewall"
	sudo pacman -S ufw gufw

	## Start firewall
	make_bold_blue "Enabling firewall"
	sudo systemctl enable ufw.service
	sudo systemctl start ufw.service

	# Mugshot
	make_bold_blue "Downloading mugshot"
	install_aur "mugshot"

	# If yes
	if [ $(yesno_box "Do you want to install bluetooth tools?") -eq 0 ]; then
		sudo pacman -S bluetoothctl bluez blueman
	fi
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

function xfce_install() {
	sudo pacman -S xorg xfce4 xfce4-terminal xfce4-goodies xfce4-whiskermenu-plugin lightdm lightdm-gtk-greeter
}

function vako_apps() {
	make_bold_blue "Updating first"
	sudo pacman -Syu

	local TITLE="What browser do you want?"
	local OPTIONS=(
		1 "Firefox"
		2 "Opera"
		3 "Both"
	)
	local CHOICE=$(menu_box "${TITLE}" "${OPTIONS[@]}")

	make_bold_blue "Downloading web browser"
	case $CHOICE in
		1)
			# Opera needs this codec to play spotify
			sudo pacman -S opera opera-ffmpeg-codecs 
			;;
		2)
			sudo pacman -S firefox
			;;
		3)
			sudo pacman -S opera opera-ffmpeg-codecs firefox
			;;
	esac

	make_bold_blue "Downloading some stuff"
	sudo pacman -S discord vlc

	# Vencord
	sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"

	install_aur "simplescreenrecorder"



	make_bold_blue "Downloading dev tools"
	# C/C++ Dev tools
	sudo pacman -S clang cmake gdb valgrind

}





#
# Config #
#
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

	make_bold_blue "To see the password you are typing, go to \"/etc/sudoers\" and type \"Defaults pwfeedback\", save"
}

function kitty_terminal() {
	if ! command -v "kitty" &> /dev/null; then
		make_bold_red "Kitty terminal is not installed"

		case $(yesno_box "Kitty is not installed \nDo you want to install kitty?") in
			0)
				sudo pacman -S kitty
				exit
				;;

			# No/Cancel
			1 | 255)
				exit
				;;
		esac
	fi

	# If not unziped
	if [ ! -d "${KITTY_CONFIG_PATH}" ]; then
		# If zip doesn't exist
		if [ ! -f "${KITTY_CONFIG_PATH}.zip" ]; then
			echo "~> Missing file ${KITTY_CONFIG_PATH}.zip"
		fi

		unzip "${KITTY_CONFIG_PATH}.zip" -d "${CONFIG_FILES_PATH}"
	fi

	local KITTY_PATH="${HOME}/.config/kitty"

	# Make backup
	cp "${KITTY_PATH}/kitty.conf" "${KITTY_PATH}/kitty.conf.bak"

	# Copy files
	cp "${KITTY_CONFIG_PATH}"/*.conf "${KITTY_PATH}"

}

function neofetch() {
	if ! command -v "neofetch" &> /dev/null; then
		make_bold_red "~> You have Arch, why don't you have neofetch??"
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

function pacman_conf() {
	make_bold_blue "Go to \"/etc/pacman.conf\" and uncomment the following options"
	make_yellow "Color"
	make_yellow "CheckSpace"
	make_yellow "ParallelDownloads = 5"
}








#
# Themes #
#
function xfce-terminal() {
	local COLORSCHEME_PATH="${HOME}/.local/share/xfce/terminal/colorschemes"

	if [ ! -d $COLORSCHEME_PATH ]; then
		mkdir -p $COLORSCHEME_PATH
	fi

	# Copy theme to path
	wget https://raw.githubusercontent.com/endeavouros-team/endeavouros-xfce-terminal-colors/master/endeavouros.theme -P $COLORSCHEME_PATH

	make_bold_blue "Change the terminal background color to #101017"
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
	
	echo -e "\n"
	make_bold_blue "Move themes to ${BOLD}~/.themes${NC} and icons to ${BOLD}~/.icons${NC}"

	make_bold_red "(sorry, I am won't dowload all this and zip to github)"

	make_yellow "Catpuccin Theme colors:"
	list_item "- Mocha" "Purple"
	list_item "   - Alt" "Orange"
	list_item "   - Alt2" "Folder with black details"
	list_item "- Macchiato" "Orange"
	list_item "- Frappe" "Blue"
	list_item "- Latte" "Slightly dark blue"
}


# Some useful packages:
# - haguichi (AUR)
# 	+ Hamachi GUI

#####
# Sections
#####
function main() {
	local TITLE="Arch Linux setup \nChoose a section \nUse Arrows to move"
	local OPTIONS=(
		1 "Install"
		2 "Configs"
		3 "Themes"
		4 "Exit"
	)
	local CHOICE=$(menu_box "${TITLE}" "${OPTIONS[@]}")

	case $CHOICE in
		1)
			install_sec
			;;
		2)
			config_sec
			;;
		3)
			theme_sec
			;;
		4)
			clear
			exit
			;;
	esac
}

function install_sec() {
	local TITLE="Arch Linux setup \nChoose a action"
	local OPTIONS=(
		1 "Missing Packages" # Not actual missing packages, but I don't know how to call this
		2 "Essencial Packages"
		3 "Vako Apps"
		4 "XFCE Install"
		5 "Back"
	)
	local CHOICE=$(menu_box "${TITLE}" "${OPTIONS[@]}")

	clear
	case $CHOICE in
		1)
			missing_packages
			;;
		2)
			essencial_packages
			;;
		3)
			vako_apps
			;;
		4)
			xfce_install
			;;
		5)
			main
			;;
	esac
}

function config_sec() {
	local TITLE="Arch Linux setup \nChoose a action"
	local OPTIONS=(
		1 ".bashrc"
		2 "Kitty Terminal"
		3 "neofetch"
		4 "Panel CSS"
		5 "XFCE XMLs"
		6 "Pacman"
		7 "Back"
	)
	local CHOICE=$(menu_box "${TITLE}" "${OPTIONS[@]}")

	clear
	case $CHOICE in
		1)
			bashrc
			;;
		2)
			kitty_terminal
			;;
		3)
			neofetch
			;;
		4)
			panel_css
			;;
		5)
			xfce_xml
			;;
		6)
			pacman_conf
			;;
		7)
			main
			;;
	esac
}

function theme_sec() {
	local TITLE="Arch Linux setup \nChoose a action"
	local OPTIONS=(
		1 "Icons and Themes"
		2 "xfce-terminal theme"
		3 "Back"
	)
	local CHOICE=$(menu_box "${TITLE}" "${OPTIONS[@]}")

	clear
	case $CHOICE in
		1)
			icons_and_themes
			;;
		2)
			xfce-terminal
			;;
		3)
			main
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



