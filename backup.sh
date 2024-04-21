CONFIG_DIR="config_files"

NEOFETCH=~/.config/neofetch
KITTY=~/.config/kitty
ZSH=~/.config/zsh

# Remove old files
rm -rf $CONFIG_DIR/kitty $CONFIG_DIR/neofetch

# Make dirs
mkdir $CONFIG_DIR/kitty $CONFIG_DIR/neofetch

# Add new files
cp $NEOFETCH/*.txt $NEOFETCH/config.conf $CONFIG_DIR/neofetch
cp $KITTY/*.conf $CONFIG_DIR/kitty
cp ~/.zshrc $CONFIG_DIR/zshrc.txt
cp ~/.bashrc $CONFIG_DIR/bashrc.txt

# TODO -- Zip xfce4 config files
