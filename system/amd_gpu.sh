#!/bin/bash

# Video drivers
if whiptail --title "Install video drivers?" --yesno "Do you want to install some packages for video driver support?" 10 60; then
	echo "================================="
	echo -e "\033[1m~> Installing the following packages:\033[0m"
	echo "- mesa: Common driver"
	# echo "- mesa-amber: For older drivers"
	# echo "- lib32-mesa: 32-bit support"
	echo "- libva-mesa-driver: Mesa accelerated video decoding for VA-API"
	# echo "- lib32-libva-mesa-driver: 32-bit support for VA-API"
	echo "- mesa-vdpau: Mesa accelerated video decoding for VDPAU"
	# echo "- lib32-mesa-vdpau: 32-bit support for VDPAU"
	echo "================================="
	echo

	# sudo pacman -S --needed mesa lib32-mesa libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau
	sudo pacman -S --needed mesa libva-mesa-driver mesa-vdpau

	echo
	echo -e "\033[1m~> Trying to install the 32-bis support for these packages:\033[0m"
	echo
	sudo pacman -S --needed lib32-mesa lib32-libva-mesa-driver lib32-mesa-vdpau
fi

# AMD drivers
if whiptail --title "Install AMD GPU packages?" --yesno "Do you want to install some packages for AMD GPU? AMD has native support, but just in case" 10 60; then
	echo
	echo "================================="
	echo -e "\033[1m~> Installing the following packages:\033[0m"
	echo "- xf86-video-amdgpu: base 2D Xorg driver"
	echo "- vulkan-radeon: Vulkan support"
	# echo "- lib32-vulkan-radeon: 32-bit Vulkan support"
	echo "- amdvlk: Alternative Vulkan driver"
	# echo AUR "- vulkan-amdgpu-pro: Alternative Vulkan driver"
	# echo "- lib32-amdvlk: 32-bit support for AMDVLK"
	echo "- vulkan-swrast: Rasterizer"
	echo "================================="
	echo

	# sudo pacman -S --needed xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon amdvlk lib32-amdvlk
	sudo pacman -S --needed xf86-video-amdgpu vulkan-radeon amdvlk vulkan-swrast

	echo
	echo "================================="
	echo -e "\033[1m~> Trying to install the 32-bis support for these packages\033[0m"
	echo "================================="
	echo
	sudo pacman -S --needed lib32-vulkan-radeon amdvlk lib32-amdvlk lib32-vulkan-swrast

fi

echo
echo "================================="
echo -e "\033[1m~> If the packages were not found, please add multilib to /etc/pacman.conf\033[0m"
echo "================================="
