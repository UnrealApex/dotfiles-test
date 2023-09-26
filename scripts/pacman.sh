#!/bin/bash
sudo pacman -Syu --noconfirm
sudo pacman -S git --noconfirm --needed

# yay
mkdir --parents ~/Downloads/git
cd ~/Downloads/git
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
yes | makepkg -si

cd ~/.dotfiles

# enable multilib
sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
# enable parallel downloads
sudo sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 20/g' /etc/pacman.conf
# enable colorful pacman output
sudo sed -i '/# Color/s/^#//g' /etc/pacman.conf

# allocate more cpu cores to make
avail_cores=$(($(nproc) + 1))
sudo sed -i "s/# MAKEFLAGS=\"-j4\"/MAKEFLAGS=\"-j"$avail_cores"\"/g" /etc/makepkg.conf

sudo pacman -Syu --noconfirm

# install packages
yay -S --noconfirm --needed - < packages

