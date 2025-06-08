#!bin/bash

echo "Starting a GNOME environment configuration..."
echo "See script content for packages details"
sleep 10


echo -e "\n-> Configuring system"
sleep 3

# Set US International keyboard layout
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+intl')]"

# Hour format
gsettings set org.gnome.desktop.interface clock-format '24h'
# Tray icons
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
# User themes
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com

# Kitty default terminal
gsettings set org.gnome.desktop.default-applications.terminal exec 'kitty'
gsettings set org.gnome.desktop.default-applications.terminal exec-arg '-x'

# Set accent color
gsettings set org.gnome.desktop.interface accent-color 'red'

echo -e "\n-> Configuring shortcuts"
sleep 3

# gsettings list-recursively org.gnome.xxx
# gettings list-recursively org.gnome.settings-daemon.plugins

# gsettings set org.gnome.mutter overlay-key "['<Control><Shift>k']"S


# Search
gsettings set org.gnome.settings-daemon.plugins.media-keys search "['<Shift><Control>k']"

# Screenshot
gsettings set org.gnome.shell.keybindings show-screen-recording-ui "['<Super><Shift>r']"
gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Super><Shift>s']"
gsettings set org.gnome.shell.keybindings screenshot "['<Super><Shift>a']"
gsettings set org.gnome.shell.keybindings screenshot-window "['<Shift><Super>w']"

# Correct alt tab
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "[]"

echo -e "\n-> Configuring nautilus"
sleep 3

if [ ! -f /usr/bin/yay ]; then
	yay -S --noconfirm nautilus-open-any-terminal
	nautilus -q
	gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty
else
	echo "Please install yay first"
fi

