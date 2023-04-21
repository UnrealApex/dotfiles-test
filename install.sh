#!/bin/bash
# TODO: Add color support
# TODO: Add yes no prompts for dangerous operations

sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

cd

git clone https://www.gitlab.com/UnrealApex/dotfiles.git ~/.dotfiles && cd ~/.dotfiles

# FIXME: figure out why script crashes terminal emulator
# NOTE: perhaps use the testing version instead of stable? 
sudo echo "deb http://deb.debian.org/debian/ bullseye main contrib non-free" >> /etc/apt/sources.list
# debian backports
sudo echo "deb http://deb.debian.org/debian bullseye-backports main" >> /etc/apt/sources.list

# enable Multi-Arch
sudo dpkg --add-architecture i386
sudo apt update

# install packages
sudo apt install -y "$(cat packages)"

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
    echo "Unable to backup conflicting file/directory $1"
  fi
}

backup ~/.bashrc
backup ~/.tmux.conf
backup ~/.gitconfig
backup ~/.vimrc
backup ~/.config/nvim/
backup ~/.config/i3/
backup ~/.config/picom/
backup ~/.config/flameshot/

# setting up symlinks
echo "Creating symlinks..."
stow */

# homebrew
NONINTERACTIVE=1 /bin/bash -c "$(curl --fail --silent --show-error --location https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# TODO: commit ~/.profile

# add homebrew to path
echo "Adding Homebrew to path..."
grep --quiet --no-messages --fixed-strings 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' ~/.profile || (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# install some packages from Homebrew
brew install git-delta glow hyperfine lua neovim node

# install jetbrains mono nerd font
if [ ! -f "/usr/share/fonts/truetype/JetBrains Mono Nerd Font Complete Regular.ttf" ]; then
  echo "Installing nerd font..."
  # make sure font directory exists
  mkdir --parents /usr/share/fonts/truetype/
  cd /usr/share/fonts/truetype
  sudo curl --fail --location --output "JetBrains Mono Nerd Font Complete Regular.ttf" \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/complete/JetBrains%20Mono%20Nerd%20Font%20Complete%20Regular.ttf
  fc-cache -fv
  echo "Nerd Font installed"
  cd
  else
    echo "Nerd Font already installed, skipping..."
fi

# spotify
curl --silent --show-error https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt install -y spotify-client

# discord
curl --location --output discord.deb https://discord.com/api/download?platform=linux
sudo apt install -y ./discord.deb
rm discord.deb

# game mode
sudo apt install -y meson libsystemd-dev pkg-config ninja-build git libdbus-1-dev libinih-dev
git clone https://github.com/FeralInteractive/gamemode.git
cd gamemode
git checkout 1.7 # omit to build the master branch
./bootstrap.sh

# anaconda
echo "Installing Anaconda..."
echo "You will need to accept its licence agreement to install it"

# download install script from anaconda website and run it
lynx \
    --listonly \
    --nonumbers  \
    --dump https://www.anaconda.com/products/distribution |
    grep -m1 --fixed-strings 'Linux-x86_64.sh' |
    xargs wget --output-document anaconda-installer.sh
# execute like this to prevent errors since script is interactive
chmod +x anaconda-installer.sh
./anaconda-installer.sh
rm anaconda-installer.sh

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

printf "\n\nDotfiles installed!\n\n"

# show system information once finished installing
neofetch
