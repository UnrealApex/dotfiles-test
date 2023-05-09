#!/bin/bash
# TODO: Add color support
# TODO: Add yes no prompts for dangerous operations

sudo pacman -Syu --noconfirm

cd

git clone https://gitlab.com/unrealapex/dotfiles.git "$HOME"/.dotfiles && cd "$HOME"/.dotfiles || exit 1

# install packages
sudo pacman -S --noconfirm --needed - < packages

# yay
mkdir --parents ~/Downloads/git
cd ~/Downloads/git
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
yes | makepkg -si

backup() {
  if [ -f $1 ]
  then
    echo "Conflicting file found, moving it to $1.bak"
    mv --force $1 $1.bak 2>/dev/null

  # handle directories
  elif [ -d $1 ]
  then
    mv --force --resursive $1 $1.bak 2>/dev/null
    echo "Conflicting directory found, moving it to $1.bak"
  else
    :
  fi
}

backup ~/.bashrc
backup ~/.tmux.conf
backup ~/.gitconfig
backup ~/.vimrc
backup ~/.config/nvim/
backup ~/.config/i3/
backup ~/.config/picom/
backup ~/.config/kitty/
backup ~/.config/dunst/
backup ~/.config/flameshot/
backup ~/.config/fontconfig/conf.d/01-emoji.conf
backup ~/.config/lf/


# setting up symlinks
echo "Creating symlinks..."
stow */

# install jetbrains mono nerd font
if [ ! -f "/usr/share/fonts/truetype/JetBrains Mono Nerd Font Complete Regular.ttf" ]; then
  echo "Installing nerd font..."
  # make sure font directory exists
  sudo mkdir --parents /usr/share/fonts/truetype/
  cd /usr/share/fonts/truetype
  sudo curl --fail --location --output "JetBrains Mono Nerd Font Complete Regular.ttf" \
  https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf?raw=true
  sudo fc-cache -fv
  echo "Nerd Font installed"
  cd
  else
    echo "Nerd Font already installed, skipping..."
fi

# TODO: add multilib repository for steam

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

# install betterfox's fastfox and smoothfox user.js and merge it into one file
curl -o user.js https://raw.githubusercontent.com/yokoffing/Betterfox/master/Fastfox.js && \
curl https://raw.githubusercontent.com/yokoffing/Betterfox/master/Smoothfox.js >> user.js  && \
# ensure profiles directory is created
sleep 10 && killall firefox &
firefox -headless &
wait 
# move user.js to default firefox profile
mv user.js "$(find ~/.mozilla/firefox/ -type d -name "*.default-release")"

# set up Git commit information
echo "Setting Git commit information..."
echo -n "Enter the email address you want to use for commits: "
read commitemail
echo -n "Enter the name you want to use for commits: "
read commitname

echo "[user]" > ~/.gitconfig_local
eval "echo \"  name = ${commitname}\" >> ~/.gitconfig_local"
eval "echo \"  email = ${commitemail}\" >> ~/.gitconfig_local"
echo "Created file ~/.gitconfig_local with commit information"

# services
sudo systemctl enable mpd.service

printf "\n\nDotfiles installed!\n\n"

# show system information once finished installing
neofetch
