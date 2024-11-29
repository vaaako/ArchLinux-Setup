#!/bin/bash

BACKUP_DIR="backup_files"

NEOFETCH_DIR=~/.config/neofetch
KITTY_DIR=~/.config/kitty
ZSH_DIR=~/.config/zsh
XFCE4_DIR=~/.config/xfce4/xfconf/xfce-perchannel-xml
XFCE4PANEL_DIR=~/.config/xfce4/panel
GTK_DIR=~/.config/gtk-3.0

# TODO -- Put this on an array to make dirs dinamically
NEOFETCH_TARGET=$BACKUP_DIR/neofetch
KITTY_TARGET=$BACKUP_DIR/kitty
XFCE4_TARGET=$BACKUP_DIR/xfce4
XFCE4PANEL_TARGET=$BACKUP_DIR/xfce4-panel
GTK_TARGET=$BACKUP_DIR/gtk
DOTFILES_TARGET=$BACKUP_DIR/dotfiles
PACMAN_TARGET=$BACKUP_DIR/pacman

# Reset before backup
if [ "$1" == "-d" ]; then
	rm -rf $BACKUP_DIR

elif [ -n "$1" ]; then
	echo "Argument not recognized, possible argument is -d to delete backup folder before backup"
	exit
fi

# Check if is sudo
if [ "$EUID" -eq 0 ]; then
	echo "Please, do not run as sudo"
	exit
fi

# Make dirs
if [ ! -d $BACKUP_DIR ]; then
	mkdir $BACKUP_DIR
fi

if [ ! -d $KITTY_TARGET ]; then
	mkdir $KITTY_TARGET
fi

if [ ! -d $NEOFETCH_TARGET ]; then
	mkdir $NEOFETCH_TARGET
fi

if [ ! -d $XFCE4_TARGET ]; then
	mkdir $XFCE4_TARGET
fi

if [ ! -d $XFCE4PANEL_TARGET ]; then
	mkdir $XFCE4PANEL_TARGET
fi

if [ ! -d $GTK_TARGET ]; then
	mkdir $GTK_TARGET
fi

if [ ! -d $DOTFILES_TARGET ]; then
	mkdir $DOTFILES_TARGET
fi

if [ ! -d $PACMAN_TARGET ]; then
	mkdir $PACMAN_TARGET
fi



# NEOFETCH_DIR
cp $NEOFETCH_DIR/*.txt $NEOFETCH_DIR/config.conf $NEOFETCH_TARGET # Target

# KITTY_DIR
cp $KITTY_DIR/*.conf $KITTY_TARGET # Target

# ZSH_DIR and bash
cp ~/.zshrc $DOTFILES_TARGET
cp ~/.bashrc $DOTFILES_TARGET 


# XFCE4_DIR
cp $XFCE4_DIR/*.xml $XFCE4_TARGET
rm $XFCE4_TARGET/displays.xml \
	$XFCE4_TARGET/xfce4-power-manager.xml \
	$XFCE4_TARGET/xfce4-screenshooter.xml \
	$XFCE4_TARGET/xfce4-taskmanager.xml
	#$XFCE4_TARGET/pointers.xml \
	# $XFCE4_TARGET/parole.xml \
	# $XFCE4_TARGET/ristretto.xml

# why i need permission to delete these???
sudo rm $XFCE4_TARGET/parole.xml $XFCE4_TARGET/ristretto.xml

# XFCE4 PANEL
cp -r $XFCE4PANEL_DIR $XFCE4PANEL_TARGET

# GTK_DIR
cp $GTK_DIR/* $GTK_TARGET

# PACMAN
cp /etc/pacman.conf $PACMAN_TARGET


echo "Backup done!"