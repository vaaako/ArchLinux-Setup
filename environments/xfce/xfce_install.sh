#!bin/bash

echo "Starting a XFC  minimal install..."
echo "See script content for packages details"
sleep 10


echo -e "\n-> Installing xfce"
sleep 3
sudo pacman -S --noconfirm --needed \
	xorg \
	xfce4


echo -e "\n-> Installing xfce packages"
sleep 3
sudo pacman -S --noconfirm --needed \
	xfce4-clipman-plugin \
	xfce4-cpufreq-plugin \
	xfce4-cpugraph-plugin \
	xfce4-diskperf-plugin \
	xfce4-fsguard-plugin \
	xfce4-genmon-plugin \
	xfce4-mount-plugin \
	xfce4-netload-plugin \
	xfce4-notifyd \
	xfce4-places-plugin \
	xfce4-screensaver \
	xfce4-screensaver \
	xfce4-smartbookmark-plugin \
	xfce4-systemload-plugin \
	xfce4-taskmanager \
	xfce4-time-out-plugin \
	xfce4-timer-plugin \
	xfce4-wavelan-plugin \
	xfce4-xkb-plugin \
	xfce4-whiskermenu-plugin


echo -e "\n-> Installing additional packages"
sleep 3
	ristretto \
	thunar-archive-plugin thunar-media-tags-plugin file-roller gvfs gvfs-mtp \
	lightdm-gtk-greeter lightdm-gtk-greeter-settings
