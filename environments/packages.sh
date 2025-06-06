echo "Starting personal packages install..."
echo "See script content for packages details"
sleep 10


echo -e "\n-> Installing yay"
sleep 3
if [ ! -f /usr/bin/yay ]; then
	git clone "https://aur.archlinux.org/yay.git"
	cd yay
	makepkg -si
	cd ..
	sudo rm -rf yay
fi


echo -e "\n-> Installing terminal packages"
sleep 3
sudo pacman -S --noconfirm --needed \
	kitty \
	zsh \
	exa \
	zoxide

echo -e "\n-> Configuring zsh"
sleep 3
# Plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions
# Change default shell
chsh -s $(which zsh)

echo -e "\n-> Installing applications"
sleep 3
sudo pacman -S --noconfirm --needed \
	vlc \
	firefox

echo -e "\n-> Installing C++ dev tools"
sleep 3
sudo pacman -S --noconfirm --needed \
	base-devel git clang make cmake gdb valgrind bear mingw-w64-gcc

echo -e "\n-> Installing yay packages"
sleep 3
yay -S --noconfirm vesktop-bin
yay -S --noconfirm simplescreenrecorder


echo -e "\n-> Installing rclone"
sleep 3
sudo -v ; curl https://rclone.org/install.sh | sudo bash

echo "================================="
echo -e "\033[1m~> How to configure:\033[0m"
echo "1. Run: rclone config"
echo "2. Name as \"gdrive\" or whatever"
echo "3. Choose the Google Driver number (19)"
echo "4. Leave empty for client_id"
echo "5. Leave empty for client_secret"
echo "6. Choose 1 for full acess"
echo "7. Leave empty for service_account_file"
echo "8. Choose \"No\" for advanced config"
echo "9. Choose \"Yes\" for authenticate with a web browser"
echo "10. Choose \"No\" for Shared Drive"
echo "11. Choose \"Yes\" for confirm settings"
echo "12. Quit"
echo "================================="
echo

sleep 10

