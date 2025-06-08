#!bin/bash

echo "Starting a XFCE environment configuration..."
echo "See script content for packages details"
sleep 10

echo -e "\n-> Configuring system"
sleep 3

xfconf-query -c keyboard-layout \
	-p "/Default/XkbLayout" -n -t string -s "us"

xfconf-query -c keyboard-layout \
	-p "/Default/XkbVariant" -n -t string -s "intl"

xfconf-query -c xfce4-session -p /general/DefaultTerminal -s kitty

echo -e "\n-> Configuring shortcuts"
sleep 3
xfconf-query -c xfce4-keyboard-shortcuts \
	-p "/commands/custom/<Super><Shift>s" \
	-n -t string -s "xfce4-screenshooter -r"

xfconf-query -c xfce4-keyboard-shortcuts \
	-p "/commands/custom/<Super><Shift>w" \
	-n -t string -s "xfce4-screenshooter -w"

xfconf-query -c xfce4-keyboard-shortcuts \
	-p "/commands/custom/<Primary><Shift>k" \
	-n -t string -s "xfce4-appfinder"

