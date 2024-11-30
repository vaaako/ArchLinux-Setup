# Install zsh
sudo pacman -S zsh

# Install plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions

# Change default shell
chsh -s $(which zsh)

