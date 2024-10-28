# 🌺 dotfiles

[![screenshot of rice](rice.png)](https://wallhaven.cc/w/gpmv73)
```
wm: dwl
launcher: mew
terminal: foot
shell: yash
editor: vis
notifications: dunst
```

### ✨ about ✨
my dotfiles for gentoo, managed using git and make. my intent is to keep my
dotfiles as minimal as possible and to follow the [suckless
philsophy](https://suckless.org/philosophy/). i, like the suckless developers
believe writing quality software is important and strive to set an example with
my dotfiles.

### 💿 install
```sh
git clone https://git.sr.ht/~unrealapex/dotfiles ~/dotfiles
cd ~/dotfiles
make
```

### 🗒️ notes
this rice isn't intended for use by other people, but i don't mind if you do.
for documentation's sake, this section of the readme has useful information
below about my dotfiles.

my builds of dwl, mew, and wlock are stored in separate git
repositories. my makefile has a target to build them.

**extras**

window decorations should be turned off for gui apps that have the option. this
can be done in most apps by enabling the "use system titlebars" option.

skeleton files for programs that have secrets(git) are in `secrets`.

🌈 color palette
```css
* {
  --bg-color: "darkgray";
  --fg-color: "white";
  --main-color: "maroon";
}
```
