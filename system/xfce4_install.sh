#!/bin/bash

# Install packages
echo "================================="
echo -e "\033[1m~> Installing the following packages:\033[0m"
echo "- xorg: X Window System"
echo "- xfce4: XFCE desktop environment"
echo "- kitty: Terminal emulator"
# echo "- xfce4-terminal: XFCE terminal emulator"
echo "- xfce4-goodies: Additional XFCE goodies"
echo "- xfce4-whiskermenu-plugin: Whisker menu plugin for XFCE"
echo "- lightdm-gtk-greeter: GTK greeter for LightDM"
echo "- lightdm-gtk-greeter-settings: Settings manager for LightDM GTK greeter"
echo "================================="
echo

sudo pacman -S --needed xorg xfce4 kitty xfce4-goodies xfce4-whiskermenu-plugin lightdm-gtk-greeter lightdm-gtk-greeter-settings

