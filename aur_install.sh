AUR="$1"

if [ ! $AUR ]; then
	echo "No AUR provided!"
	exit
fi

git clone "https://aur.archlinux.org/${AUR}.git"
cd $AUR
makepkg -si
cd ..
sudo rm -rf $AUR
