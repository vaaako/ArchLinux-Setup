#!bin/bash

echo "Starting a GNOME minimal install..."
echo "See script content for packages details"
sleep 10


echo -e "\n-> Installing gnome"
sleep 3
sudo pacman -S --noconfirm --needed \
	gnome-shell \
	gdm \
	network-manager-applet


echo -> "\n-> Installing gnome packages"
sleep 3
sudo pacman -S --noconfirm --needed \
	gnome-backgrounds \
	gnome-calculator \
	gnome-calendar \
	gnome-clocks \
	gnome-control-center \
	gnome-disk-utility \
	gnome-font-viewer \
	gnome-keyring \
	gnome-logs \
	gnome-session \
	gnome-system-monitor \
	gnome-extensions \
	gnome-weather \
	gvfs \
	gvfs-google \
	gvfs-mtp \
	gvfs-nfs


echo -e "\n-> Installing additional packages"
sleep 3

# baobab: Graphical directory tree analyzer
# evince: Document viewer
# sushi: Previewer for nautilus
# snapshot: Screenshot tool
# tecla: Keyboard layout viewer
sudo pacman -S --noconfirm --needed \
	baobab \
	evince \
	nautilus sushi \
	tecla
