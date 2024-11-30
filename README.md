# About
These are scripts that I use to configure my **Arch Linux** environment

# Files
## root/
Backup and Restore scripts

- [backup.sh](backup.sh): Make backup of `neofetch`, `kitty`, `zshrc` and `bashrc`, `xfce4` xml files, `xcfce4 panel` configuration, and `gtk` css file. Use the `-d` flag to delete the backup folder before the backup *(a reset)*
- [restore.sh](restore.sh): Restore the backup files

## configs/
Configuration related

- [makeconfigs.sh](configs/icons_and_themes.sh): Add my configuration to `sudoers` (show password stars), `lightdm` and `fstab`

## packages/
Applications related scripts

- [bloatware_remove.sh](configs/blotware_remove.sh): Remove *xfce4* bloatware packages
- [missing.sh](configs/missing.sh): Usefull packages that *xfce4* should come with
- [mypackages.sh](configs/mypackages.sh): Packages that I use daily on my environment
- [yay_install.sh](configs/yay_install.sh): Install [`yay`](https://github.com/Jguer/yay)
- [zsh_setup.sh](configs/yay_install.sh): Install and setup my `zsh` shell

## system/
Packages related to the Linux System

- [amd_gpu.sh](system/amd_gpu.sh): Install video driver and drivers for helping with the AMD GPU *(AMD has native support but whatever)*
- [xfce4_install.sh](system/amd_gpu.sh): Install *xfce4* for when I am installing *Arch Linux*


