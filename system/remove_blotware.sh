#!/bin/bash
echo "================================="
echo -e "\033[1m~> Removing the following packages:\033[0m"
echo "- audacious: Media player"
echo "- parole: Media player"
echo "- qvidcap: Record webcam"
echo "- xfburn: CD/DVD burning"
echo "- zam-plugins: Sound processing"
echo "- calfjackhost: Host application for JACK audio plugins"
echo "- v4l-utils: Utilities for video4linux devices (not a direct dependency)"
echo "================================="
echo

sudo pacman -Rns audacious parole qvidcap xfburn zam-plugins calfjackhost
sudo pacman -Rdd v4l-utils

