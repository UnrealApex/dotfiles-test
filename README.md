# dotfiles

<!-- todo: insert image of rice here -->
```
asciinema      > terminal recording
bat            > a cat(1) clone with wings
delta          > better git syntax highlighting
fzf            > fuzzy finder 
gh             > github cli
glow           > markdown parser
htop           > process viewer
hyperfine      > performance testing
lua            > lua language
lynx           > text based browser
neofetch       > show system information
neovim         > text editor
node           > nodejs
openjdk        > java language
ripgrep        > better grep
shellcheck     > shell script linter
stow           > symlink farm manager
tmux           > terminal multiplexer
```

### ✨ About ✨
Like most dotfiles, the files in this repository include the configurations that make my system fit my needs.

You're free to clone my config but it is generally [frowned upon](https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/#dotfiles-are-not-meant-to-be-forked) because dotfiles tend be something really personal. Rather, if you are interested in using my config, I suggest copying whatever you like and putting it in your own config.
That being said, suggestions are definitely open! This config will only work on Debian based systems. It will not run without Curl and a stable internet connection. Additional dependencies are installed if not found.


### 👨‍💻 Usage
My dotfiles are managed using Git and GNU Stow. I use Git to manage version history and Stow to symlink everything to the directories my dotfiles need to be in. Most of my packages are installed using Apt, but for certain ones that are not up to date in Ubuntu and Debian repositories or more tedious to install, I use Homebrew. This GitHub repository has multiple branches, each for a separate *Nix system. Each branches README has the appropriate one liner to install that branch's config. This branch is for Linux(Debian) and Windows Subsystem for Linux.

### 💿 Install
My dotfiles can be installed with this one liner:

```sh
source <(curl -s https://gitlab.com/UnrealApex/dotfiles/-/raw/master/install.sh)
```
