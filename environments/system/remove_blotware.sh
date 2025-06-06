#!/bin/bash
echo "================================="
echo -e "\033[1m~> Removing the following packages:\033[0m"
echo "- audacious: Media player"
echo "- parole: Media player"
echo "- qvidcap: Record webcam"
# echo "- qv4l2: video4linux interface tool" # simplescreenrecorder depends on qv4l2
echo "- xfburn: CD/DVD burning"
echo "- zam-plugins: Sound processing"
echo "- calfjackhost: Host application for JACK audio plugins"
echo "- v4l-utils: Utilities for video4linux devices (not a direct dependency)"
echo "- xfce4-sensors-plugin: Sensor plugin for XFCE"
echo "================================="
echo

sudo pacman -Rns audacious parole qvidcap xfburn zam-plugins calfjackhost xfce4-sensors-plugin
sudo pacman -Rdd v4l-utils

