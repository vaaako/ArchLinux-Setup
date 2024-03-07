CONFIG_DIR="config_files"

NEOFETCH="${HOME}/.config/neofetch"
KITTY="${HOME}/.config/kitty"
ZSH="${HOME}/.config/zsh"

cp $NEOFETCH/*.txt $NEOFETCH/config.conf $CONFIG_DIR/neofetch
cp $KITTY/*.conf $CONFIG_DIR/kitty
cp $HOME/.zshrc $CONFIG_DIR/zshrc.txt
cp $HOME/.bashrc $CONFIG_DIR/bashrc.txt
