#!/bin/bash
# TODO: Add color support
# TODO: Add yes no prompts for dangerous operations

# make sure script is not run as the root user
if [[ "$(id -u)" -eq 0 ]] 
then
  printf "%s\n" "please do not run this script as root" >&2  
  exit 1
fi

sudo pacman -Syu --noconfirm
sudo pacman -S git --noconfirm

cd

[ -d ~/.dotfiles ] || git clone https://gitlab.com/unrealapex/dotfiles.git ~/.dotfiles
cd ~/.dotfiles || exit 1

# yay
mkdir --parents ~/Downloads/git
cd ~/Downloads/git
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
yes | makepkg -si

cd ~/.dotfiles

# enable multilib
sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
sudo pacman -Syu --noconfirm

# install packages
yay -S --noconfirm --needed - < packages

# Detect CPU vendor and model
vendor=$(grep vendor_id /proc/cpuinfo | awk '{print $3}' | head -n 1)
model=$(grep "model name" /proc/cpuinfo | awk -F": " '{print $2}' | head -n 1)

# install microcode
# Check if the CPU is Intel or AMD
if [[ $vendor == "GenuineIntel" ]]; then
   echo "Detected CPU: Intel $model"
   
   # Install the Intel microcode package
   sudo pacman -Syu --noconfirm --needed intel-ucode
   
   # Activate the microcode update
   sudo grub-mkconfig -o /boot/grub/grub.cfg
   
elif [[ $vendor == "AuthenticAMD" ]]; then
   echo "Detected CPU: AMD $model"
   
   # Install the AMD microcode package
   sudo pacman -Syu --noconfirm --needed amd-ucode
   
   # Activate the microcode update
   sudo grub-mkconfig -o /boot/grub/grub.cfg
   
else
   echo "Unsupported CPU: $vendor $model"
fi

echo "Microcode package installed and activated successfully!"


backup_paths=(
  ~/.config/betterlockscreen
  ~/.config/bspwm
  ~/.config/dunst
  ~/.config/flameshot
  ~/.config/fontconfig/conf.d/01-emoji.conf
  ~/.config/kitty
  ~/.config/lf
  ~/.config/nvim
  ~/.config/picom
  ~/.config/pipewire
  ~/.config/polybar
  ~/.config/zsh
  ~/.bash_history
  ~/.bash_logout
  ~/.bash_profile
  ~/.bashrc
  ~/.gitconfig
  ~/.gitconfig_local
  ~/.tmux.conf
  ~/.vimrc
  ~/.xinitrc
  ~/.zprofile
  ~/.zsh_plugins.txt
  ~/.zshenv
  ~/.zshrc
)

for path in "${backup_paths[@]}"
do
  mv --force $path $path.bak 2>/dev/null
done

# setting up symlinks
echo "Creating symlinks..."
stow */

# create default user directories
xdg-user-dirs-update

# set default shell as zsh
chsh -s /bin/zsh

# on-demand rehash for new executables
sudo mkdir --parents /etc/pacman.d/hooks/ /var/cache/zsh
# create hook file
echo "[Trigger]
Operation = Install
Operation = Upgrade
Operation = Remove
Type = Path
Target = usr/bin/*
[Action]
Depends = zsh
When = PostTransaction
Exec = /usr/bin/install -Dm644 /dev/null /var/cache/zsh/pacman" | sudo tee /etc/pacman.d/hooks/zsh.hook

# TODO: do this after initial install
# modprobe btusb

# make sure bluetooth stuff start up after a restart
# sudo sed -i "s/AutoEnable=false/AutoEnable=true/" /etc/bluetooth/main.conf

# install neovim plugins
# TODO: check if Mason language servers get installed too
nvim --headless "+Lazy! sync" +qa

# anaconda
echo "Installing Anaconda..."
echo "You will need to accept its licence agreement to install it"

# download install script from anaconda website and run it
lynx \
    --listonly \
    --nonumbers  \
    --dump https://www.anaconda.com/products/distribution |
    grep -m1 --fixed-strings 'Linux-x86_64.sh' |
    xargs wget --output-document anaconda-installer.sh && \
# execute like this to prevent errors since script is interactive
chmod +x anaconda-installer.sh && \
./anaconda-installer.sh && \
rm anaconda-installer.sh && \
conda config --set auto_activate_base false

# cache lockscreen image
# FIXME: this has to be perfomred after initial setup
# betterlockscreen --update ~/.dotfiles/sakura.png

# set up Git commit information
echo "Setting Git commit information..."
echo -n "Enter the email address you want to use for commits: "
read commitemail
echo -n "Enter the name you want to use for commits: "
read commitname


if [ ! -z "$commitemail" ] && [ ! -z "$commitname" ]
then
  echo "[user]" > ~/.gitconfig_local
  eval "echo \"  name = ${commitname}\" >> ~/.gitconfig_local"
  eval "echo \"  email = ${commitemail}\" >> ~/.gitconfig_local"
  echo "Created file ~/.gitconfig_local with commit information"
else
  echo "Git commit credentials not provided, skipped"
fi

# services
systemctl enable mpd.service
systemctl --user disable pulseaudio.socket pulseaudio.service
systemctl --user enable pipewire.socket pipewire-pulse.socket wireplumber.service
systemctl enable bluetooth.service


printf "\n\nDotfiles installed!\n\n"

# show system information once finished installing
neofetch
