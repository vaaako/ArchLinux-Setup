#!/bin/bash

echo "================================="
echo -e "\033[1m~> Installing the following packages:\033[0m"
echo "================================="
echo

git clone "https://aur.archlinux.org/yay.git"
cd yay
makepkg -si
cd ..
sudo rm -rf yay
