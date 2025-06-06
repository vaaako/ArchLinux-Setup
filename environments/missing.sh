#!/bin/bash

echo "Starting missing packages install..."
echo "See script content for packages details"
sleep 10

# xdg: Utilities (open links in browser, create home folders etc)
# xsel: Get content of selection
echo -e "\n-> Installing utilities"
sudo pacman -S --noconfirm --needed \
	xdg-utils xdg-user-dirs \
	xsel

echo -e "\n-> Installing ffmpeg and audio codecs"
sleep 3
sudo pacman -S --noconfirm --needed \
	ffmpeg \
	gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-plugins-base\
	gst-libav gstreamer


echo -e "\n-> Installing pipewire"
sleep 3
sudo pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack pavucontrol
systemctl --user enable --now pipewire-pulse


echo -e "\n-> Installing bluetooth"
sleep 3
sudo pacman -S --noconfirm bluez bluez-libs bluez-plugins bluez-utils blueman
sudo systemctl enable bluetooth


echo -e "\n-> Installing firewall"
sleep 3
sudo pacman -S --noconfirm --needed ufw gufw
sudo systemctl enable --now ufw


echo -e "\n-> Installing fonts"
sleep 3
sudo pacman -S --noconfirm --needed \
	ttf-jetbrains-mono-nerd \
	ttf-ubuntu-font-family \
	ttf-liberation \
	ttf-cascadia-code \
	noto-fonts \
	noto-fonts-cjk \
	noto-fonts-emoji

