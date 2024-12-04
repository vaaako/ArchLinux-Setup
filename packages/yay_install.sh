#!/bin/bash

echo "================================="
echo -e "\033[1m~> Installing the following packages:\033[0m"
echo "================================="
echo


echo -e "\033[1m~> UPDATING SYSTEM FIRST\033[0m"
sudo pacman -Syyu
echo

git clone "https://aur.archlinux.org/yay.git"
cd yay
makepkg -si
cd ..
sudo rm -rf yay
