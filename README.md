# About
These are scripts that I use to configure my **Arch Linux** environment


# Files
## root/
These scripts are in the root because then I can move anywhere easily

- [backup.sh](backup.sh): Make backup of `neofetch`, `kitty`, `zshrc` and `bashrc`, `xfce4` xml files and `gtk` css file. Use the `-d` flag to delete the backup folder before the backup *(a reset)*
- [restore.sh](restore.sh): Restore the backup files

## configs/
Configuration related

- [icons_and_themes.sh](configs/icons_and_themes.sh): Apply icons and themes
- [cant_script_these.sh](configs/cant_script_these.sh): Configurations that I can't make a script for, so I have to manually config

## packages/
Applications related scripts

- [blotware_remove.sh](configs/blotware_remove.sh): Remove *XFCE4* blotware
- [missing.sh](configs/missing.sh): Usefull applicattions that *XFCE4* should come with
- [mypackages.sh](configs/mypackages.sh): Packages that I use daily on my environment
- [yay_install.sh](configs/yay_install.sh): Install [`yay`](https://github.com/Jguer/yay)

## system/
Packages related to the Linux System

- [amd_gpu.sh](system/amd_gpu.sh): Install video driver and drivers for helping with the AMD GPU *(AMD has native support but whatever)*
- [xfce4_install.sh](system/amd_gpu.sh): Install *XFCE4* for when I am installing *Arch Linux*


