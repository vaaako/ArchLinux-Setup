# Pre-Install
## UEFI
Before starting the installation, ensure that the **installation media** you're using is set to **UEFI mode**, as the installation will not work otherwise

## Internet
For *ethernet* connections, simply connect the cable.

First, check if it's blocked with `rfkill`:
```sh
rfkill
```

If it's *soft-blocked*, unblock it with the command below:
```sh
rfkill unblock wlan
```

Use the command below to check your wifi device:
```sh
iwctl
```

List all available devices:
```sh
[iwd]# device list
```

Then scan and connect to a network:
```sh
[iwd]# station device scan
[iwd]# station device get-networks
[iwd]# station device connect SSID
```
Where `device` is the name of your wifi device and `SSID` is the wifi name

Finally, store the password *(for automatic connection)*:
```sh
iwctl --passphrase passphrase station *device* connect *SSID*
```

Test the connection:
```sh
ping archlinux.org
```

## SSH
This section is for remote installation from the **installation media**

Check your computer's IP:
```sh
ip addr
```
Look for your wifi device's name *(usually starts with "wlan")* or ethernet interface name *(usually starts with "en")*.

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
Replace with the IP of the computer where the installation is taking place.

You'll know it worked when you see the welcome message from **Arch Linux** after entering the password.

## Partitions
### Separation
I used `cfdisk` instead of the recommended `fdisk` in the wiki because it's more intuitive and easier to use.

Run **cfdisk**:
```sh
cfdisk
```
Select **gpt** if asked for a label.

Delete all other partitions, leaving only **free Space**

> [!NOTE]
> If you're doing a `dual boot`, just ignore the other OS partitions.

### Boot Partition
Create a new partition with a size of **300Mb**

### Swap Partition
Create a new partition with a size of **4Gb**

### Main Partition
Finally, create a new partition with the remaining space and **write**

## Format
In this tutorial these are each partitions:
- `/dev/sda1`: Boot partition
- `/dev/sda2`: Swap partition
- `/dev/sda3`: Main partition

Use the `lsblk` command to see each partition; this will be useful to confirm everything is correct after each command below.

Format the *boot* partition to **FAT32**:
```sh
mkfs.fat -F 32 /dev/sda1
```

Format the *main partition* to **ext4**:
```sh
mkfs.ext4 /dev/sda3
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

To mount the boot partition, first, create the boot directory:
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
## Starting packages
This is the command I usually use to install all the necessary packages
```sh
pacstrap -K /mnt base linux linux-firmware sof-firmware base-devel grub efibootmgr networkmanager nano
```

- **base**: Base package
- **base-devel**: Packages like *sudo* and other useful packages
- **linux**: Linux kernel
- **linux-firmware**: Linux firmware
- **sof-firmware**: Supports newer sound cards
  + Not necessarily required, but is for precaution
- **grub**: Boot manager
- **efibootmgr:** *EFI* for grub
- **networkmanager**: Network Manager for system restarts
- A text editor, such as *vim* or *nano*, which will be necessary later on

Sometimes I also install `neovim`, but this can cause a package error, if this happens, restart all the installation

This installation will take some time...

## Configuring the system
Technically you can now just configure *fstab*, create a user, and install *grub*, and the installation is finished, but I like to configure some things before.

## Generate fstab
Generate the filesystem table to configure mount points:
```sh
genfstab -U /mnt > /mnt/etc/fstab
```

## Change root
Switch to the newly installed system:
```sh
arch-chroot /mnt
```

## Set system time
Set the correct timezone:
```sh
ln -sf /usr/share/zoneinfo/Brazil/East /etc/localtime
```

Synchronize the system clock:
```sh
hwclock --systohc
```

Check if it's correct with the command `date`

## Localization
Open the `/etc/locale.gen` file and uncomment the appropriate locales. Uncomment `en_US.UTF-8 UTF8` and any other needed locales.

Then generate the locales:
```
locale-gen
```

Set the system language by editing `/etc/locale.conf`:
```sh
echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

## Keyboard layout
To view available keyboard layouts:
```sh
localectl list-keymaps
```

Set your desired layout:
```
loadkeys us-acentos # Replace with your desired layout
```

Set the layout in `/etc/vconsole.conf`:
```sh
echo "KEYMAP=us-acentos" > /etc/locale.conf
```

## Hostname
Set the computer's hostname:
```sh
echo "myhostname" > /etc/hostname
```

Edit `/etc/hosts` and add the following lines:
```sh
127.0.0.1	localhost
::1		localhost
```

## Root password
Set the root password:
```sh
passwd
```

## Add user
To create a new user:
```sh
useradd -m -G wheel -s /bin/bash myusername
```

Where each argument means:
- `-m`: Create user's home directory
- `-G`: User's group
- `-s`: User's shell

Set the user's password:
```sh
passwd myusername
```

### Enable sudo for user
To allow the user to use `sudo`, run:
```sh
EDITOR=nano visudo
```

Go to last lines and uncomment the following:
```
%wheel ALL=(ALL) ALL
```

Now you can test if the user has `sudo`
```sh
su myusername
sudo pacman -Syu
```

> [!WARNING]
> Don't forget to execute the command `exit` before resuming the tutorial

# Reboot
## GRUB
Install the GRUB bootloader:
```sh
grub-install --target=x86_64-efi --recheck /dev/sda
```

This command may cause an **EFI error** or install 32-bit instead. If any case happens, you may have booted the **installation media** in legacy mode instead of UEFI mode, and you will need to restart the whole installation

Generate the GRUB configuration file:
```sh
grub-mkconfig -o /boot/grub/grub.cfg
```

## Enable NetworkManager
Enable `NetworkManager` to start with internet at boot:
```sh
systemctl enable NetworkManager
```

Unmount all partitions:
```sh
umount -a
```

Finally, reboot the system:
```sh
reboot
```

Remove the installation media and Arch Linux should boot

# Post-Installation
Once Arch Linux has rebooted, ensure that the internet is working by running `ping archlinux.org`. If there is an issue, use `sudo nmtui` to connect to a wifi

## Installing some Desktop Environment (XFCE4)
To install XFCE4 desktop environment run the script located at `system/xfce4-instal.sh`

Or run the command:
```sh
sudo pacman -S --needed xorg xfce4 kitty xfce4-goodies xfce4-whiskermenu-plugin lightdm-gtk-greeter lightdm-gtk-greeter-settings
```

Enable `lightdm` to manage the login screen:
```sh
systemctl enable lightdm
```

Reboot, and you should now have a functional XFCE4 environment

