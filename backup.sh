CONFIG_DIR="config_files"

NEOFETCH=~/.config/neofetch
KITTY=~/.config/kitty
ZSH=~/.config/zsh
XML=~/.config/xfce4/xfconf/xfce-perchannel-xml
GTK=~/.config/gtk-3.0/

# Make dirs
if [ ! -d $CONFIG_DIR/kitty ]; then
	mkdir $CONFIG_DIR/kitty
fi

if [ ! -d $CONFIG_DIR/neofetch ]; then
	mkdir $CONFIG_DIR/neofetch
fi

if [ ! -d $CONFIG_DIR/xfce4 ]; then
	mkdir $CONFIG_DIR/xfce4
fi


# neofetch
cp $NEOFETCH/*.txt $NEOFETCH/config.conf $CONFIG_DIR/neofetch

# kitty
cp $KITTY/*.conf $CONFIG_DIR/kitty

# zsh and bash
cp ~/.zshrc $CONFIG_DIR/zshrc.txt
cp ~/.bashrc $CONFIG_DIR/bashrc.txt

# XML
cp $XML/*.xml $CONFIG_DIR/xfce4 
rm $CONFIG_DIR/displays.xml $CONFIG_DIR/pointers.xml $CONFIG_DIR/parole.xml $CONFIG_DIR/ristretto.xml # Files that may contain not cool information for public (mouse and monitor names, home directory name)

# gtk
cp $GTK/gtk.css $CONFIG_DIR

