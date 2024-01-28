# Pre-Install
## Keyboard
First, configure your keyboard layout for installation.

Use the command below to view all available layouts:
```sh
localectl list-keymaps
```
> Press "q" to exit

Then choose your desired layout with the following command:
```sh
loadkeys br-abnt2 # Replace with your desired layout
```

## Internet
First, check if it's blocked with `rfkill`:
```sh
rfkill
```

If it's *soft-blocked*, unblock it with the command below:
```sh
rfkill unblock wlan
```

For *Ethernet* connections, simply connect the cable.

Use the command below to check your Wi-Fi card:
```sh
iwctl
```

List all available devices:
```sh
[iwd]# device list
```

Then scan and connect to a network:
```sh
[iwd]# station *device* scan
[iwd]# station *device* get-networks
[iwd]# station *device* connect *SSID*
```
> *Device* represents your Wi-Fi card, and *SSID* is the Wi-Fi name.

Finally, store the password *(for automatic connection)*:
```sh
iwctl --passphrase passphrase station *device* connect *SSID*
```

Test the connection:
```sh
ping archlinux.org
```

<!--
# Time
Before moving to the partitioning part, I wanted to adjust the time just for fun.

Check the system time with:
```sh
timedatectl
```

Then find the command to list timezones and use **grep** to find Brazil's timezone:
```sh
timedatectl list-timezones | grep Brazil
```

Finally, set the correct timezone:
```sh
timedatectl set-timezone Brazil/East
```
-->

## SSH
This section is for remote installation.

Check your computer's IP:
```sh
ip addr
```
> Look for your Wi-Fi card's name *(usually starts with "wlan")* or Ethernet interface name *(usually starts with "en")*.

Enable **SSH**:
```sh
sudo systemctl start sshd
```

Set a password:
```sh
passwd
```

Now, from another computer, execute the command:
```sh
ssh root@192.168.18.8
```
> Replace with the IP of the computer where the installation is taking place.

You'll know it worked when you see the welcome message from **Arch Linux** after entering the password.

## Partitions
### Separation
> I used `cfdisk` instead of the recommended `fdisk` in the wiki because it's more intuitive and easier to use.

Run **cfdisk**:
```sh
cfdisk
```
> Select **gpt** if asked for a label.

Delete all other partitions, leaving only **Free Space**.

### Boot Partition
Create a new partition with a size of **300Mb** *(Click "new" and type "300M")*.

### Swap Partition
Create a new partition with a size of **4Gb** *(Click "new" and type "4G")*.

### Main Partition
Finally, create a new partition with the remaining space and select **Write** for the Main Partition.

## Format
Use the command `lsblk` to see each partition; this will be useful to confirm everything is correct after each command below.

Format the *main partition* to **Ext4**:
```sh
mkfs.ext4 /dev/sda3
```
> Make sure it's the correct partition.

Format the *boot* partition to **Fat32**:
```sh
mkfs.fat -F 32 /dev/sda1
```

Now create the *swap* partition with the following command:
```sh
mkswap /dev/sda2
```

## Mount
Now, mount the partitions, starting with the main partition:
```sh
mount /dev/sda3 /mnt
```
> You can use the `lsblk` command again to check if the partition was mounted correctly.

To mount *boot*, first create the boot directory:
```sh
mkdir -p /mnt/boot/efi
```

Now mount it with the same command:
```sh
mount /dev/sda1 /mnt/boot/efi
```

Finally, activate *swap*:
```sh
swapon /dev/sda2
```

If you run the `lsblk` command again, all partitions should be mounted correctly.

# Installation
Now for the fun part.

## Starting packages
The following command will install the *base package*, *Linux Kernel*, and *common hardware firmware* to the main partition:
```sh
pacstrap -K /mnt base linux linux-firmware
```
> Check this part of the [wiki](https://wiki.archlinux.org/title/Installation_guide#Install_essential_packages) for useful information before running the command.

> Read the entire content of this section *(from **2.2** to **3**)*.

However, other recommended packages are:
- *sof-firmware*: Supports newer sound cards
  + Not necessarily required, but for precaution
- *base-devel*: Packages like *sudo* and other useful packages
- *grub*: Boot manager
- *efibootmgr:* *EFI* for grub
- *networkmanager*: Network Manager for system restarts
- A text editor, such as *vim* or *nano*, which will be necessary later on

So the final command will be:
```sh
pacstrap -K /mnt base linux linux-firmware sof-firmware base-devel grub efibootmgr networkmanager nano
```

This will take some time...

## Configuring the system
### File System
Check the mounted *file systems* in */mnt/* with the following command:
```sh
genfstab /mnt
```

Once you confirm everything is correct, create a file named *fstab* with the information from the above command:
```sh
genfstab /mnt > /mnt/etc/fstab
```

## Change root
Now, you can switch to the system:
```sh
arch-chroot /mnt
```

All configurations will now be done within the system.

### Hour
With the following command, you can configure the system's time.

Within the */usr/share/zoneinfo* path are all available timezones, so create a symbolic link to `etc/localtime`:
```sh
ln -sf /usr/share/zoneinfo/Brazil/East /etc/localtime
```

Check if the time is correct with the `date` command and synchronize the system clock:
```sh
hwclock --systohc
```

### Localization
Open the file containing all localizations and **uncomment** the line with `en_US.UTF-8 UTF-8` and any others needed, like `pt_BR.UTF-8 UTF-8`:
```sh
nano /etc/locale.gen
```

Save and generate all localizations:
```sh
locale-gen
```

You also need to add to the *locale.conf* file because some programs check the location through it.

This will be the system language:
```
LANG=en_US.UTF-8
```

### Keyboard layout
The file to set the keyboard layout is present in */etc/vconsole.conf*:
```sh
nano /etc/vconsole.conf
```

Specify the same layout you chose at the beginning, for example:
```
KEYMAP="br-abnt2"
```

Also, run the following command to configure the layout:
```sh
localectl set-x11-keymap br abnt2
```
> Replace with your desired layout

You can check if the changes were made with the `localectl` command.

### Hostname
Choose a name for your computer and add it to the */etc/hostname* file:
```sh
nano /etc/hostname
```

```
name_of_your_computer
```

### Root password
Choose the password for your root:
```sh
passwd
```
> Also used for **SSH** connections, so choose a strong password

### User
To add a new user, use the following command:
```sh
useradd -m -G wheel -s /bin/bash username
```
> **-m**: Add home directory
>
> **-G**: Add to a group *(wheel)*
>
> **-s**: Shell *(/bin/bash)*

Now create a password for this user:
```sh
passwd username
```
> Use different passwords

### Sudo
This user will not be on the root user list.

To add the user to the *sudo* user list, run the following command:
```sh
EDITOR=nano visudo
```
> Change nano to the text editor you downloaded

This specifies the text editor you want to use to edit the *sudo* user list.

*Uncomment* the line that says `%wheel ALL=(ALL:ALL) ALL`, which will make all users in the *wheel* group sudoers.

That's why the created user was added to the *wheel* group.

Now log in with the user you created and try running a *sudo* command:
```sh
su username
sudo pacman -Syu
```

> Then switch back to the *root* user with the *exit* command.

# Reboot
Before rebooting, enable `networkmanager` so that the internet works:
```sh
systemctl enable NetworkManager
```

## Microcode
You may also want to install *intel-ucode* or *amd-ucode*; this will speed up some processes:
```sh
sudo pacman -S intel-ucode
```
> This installation needs to be done before configuring **grub**.

## GRUB
Finally, configure the bootloader.

Install **grub** on the *HD* with *Arch Linux*:
```sh
grub-install /dev/sda --efi-directory=/boot/efi
```
> Make sure this is the correct disk if you have multiple HDs.

### Silent boot
If you don't want a silent boot *(no green OK wall appearing)*, open the */etc/default/grub*,
 file and change the value of the `GRUB_CMDLINE_LINUX_DEFAULT` line:
```
GRUB_CMDLINE_LINUX_DEFAULT=""
```

### Config
Make the **grub** config:
```sh
grub-mkconfig -o /boot/grub/grub.cfg
```

### OS-PROEBER
If you get the following warning: *"Warning: os-prober will **not** be executed to detect other bootable partitions [...]"*,
 and want to seet **os-prober** to detect other boot partitions, check bellow, otherwhise jump to the next session

Install **os-prober**
```sh
sudo pacman -S os-prober
```

Open **grub** config file
```sh
sudo nano /etc/default/grub
```

Run **os-prober** to detect other boot
```sh
sudo os-prober
```

Uncomment the line `GRUB_DISABLE_OS_PROBER=false` *(at the end of the file)*

Now try to configure **grub** again
```sh
grub-mkconfig -o /boot/grub/grub.cfg
```

Now you should get the following warning: *"Warning: os-prober will be executed [...]"*


## Final configurations
- Use the `exit` command to return to the iso terminal.
- Execute the `umount -R /mnt` command to unmount all partitions.

Now you can finally restart with the `reboot` command.

- When the Arch installation screen appears again, select `System shutdown`.
- Access the boot settings *(usually by pressing **F2** when turning on)* and remember to adjust the boot order.

Congratulations, your Arch Linux is installed.

# Post-Installation
Ensure that the internet is working with a `ping`; if `ping` returns an error, run the `sudo nmtui` command *(installed with NetworkManager)* and connect to a Wi-Fi network.



# Interface
## Internet
Firstly, check if your internet is working with the `ping archlinux.org` command. If not, run the `sudo nmtui` command and connect to a Wi-Fi network or plug in the Ethernet cable.

## Install
In this case, I'll install the `XFCE4` interface.

Start *Arch Linux*, log in, and run the following command to install all the necessary packages for *XFCE4* along with **lightdm**:
```sh
sudo pacman -S xorg xfce4 xfce4-terminal xfce4-goodies xfce4-whiskermenu-plugin lightdm lightdm-gtk-greeter
```

This will only download the necessary packages for *XFCE4* to function, so you may miss some packages. Check another tutorial to download necessary packages.

Enable *lightdm* or *gdm*:
```sh
systemctl enable lightdm
```

Now just restart the system, and *XFCE4* will be installed.

<!-- echo "setxkbmap -model abnt2 -layout br -variant abnt2" > ~/.xinitrc -->
