#!bin/bash

echo "Starting a GNOME environment configuration..."
echo "See script content for packages details"
# sleep 10


echo -e "\n-> Configuring system"
sleep 3
gsettings set org.gnome.desktop.interface clock-format '24h'
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com

gsettings set org.gnome.desktop.default-applications.terminal exec 'kitty'
gsettings set org.gnome.desktop.default-applications.terminal exec-arg '-x'

echo -e "\n-> Configuring shortcuts"
sleep 3

# gsettings list-recursively org.gnome.xxx

# Set US International keyboard layout
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+alt-intl')]"

# Screenshot
gsettings set org.gnome.shell.keybindings show-screen-recording-ui "['<Super><Shift>R']"
gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Super><Shift>s']"
gsettings set org.gnome.shell.keybindings screenshot "['<Super><Shift>a']"
gsettings set org.gnome.shell.keybindings screenshot-window "['<Shift><Super>w']"

