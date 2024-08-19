all: link build secrets done

create_dirs:
	mkdir -p  ~/.local/bin ~/.local/share/themes ~/projects ~/Downloads/git ~/Pictures/Webcam ~/Pictures/Screenshots

link: create_dirs
	ln -sf ~/dotfiles/bash_profile ~/.bash_profile
	ln -sf ~/dotfiles/bashrc ~/.bashrc
	ln -sf ~/dotfiles/zshenv ~/.zshenv
	ln -sf ~/dotfiles/config/* ~/.config/
	ln -sf ~/dotfiles/bin/* ~/.local/bin/
	ln -sf ~/dotfiles/gtk/* ~/.local/share/themes

build: /usr/local/bin/dwm /usr/local/bin/st /usr/local/bin/dmenu /usr/local/bin/slock

~/.config/dwm:
	git clone https://git.sr.ht/~unrealapex/dwm ~/.config/dwm

~/.config/dwm/dwm: $(wildcard ~/.config/dwm/*.h) $(wildcard ~/.config/dwm/*.c) | ~/.config/dwm
	$(MAKE) -C ~/.config/dwm install

/usr/local/bin/dwm: ~/.config/dwm/dwm
	sudo $(MAKE) -C ~/.config/dwm clean install

~/.config/st:
	git clone https://git.sr.ht/~unrealapex/st ~/.config/st

~/.config/st/st: $(wildcard ~/.config/st/*.h) $(wildcard ~/.config/st/*.c) | ~/.config/st
	$(MAKE) -C ~/.config/st install

/usr/local/bin/st: ~/.config/st/st
	sudo $(MAKE) -C ~/.config/st clean install

~/.config/dmenu:
	git clone https://git.sr.ht/~unrealapex/dmenu ~/.config/dmenu

~/.config/dmenu/dmenu: $(wildcard ~/.config/dmenu/*.h) $(wildcard ~/.config/dmenu/*.c) | ~/.config/dmenu
	$(MAKE) -C ~/.config/dmenu install

/usr/local/bin/dmenu: ~/.config/dmenu/dmenu
	sudo $(MAKE) -C ~/.config/dmenu clean install

~/.config/slock:
	git clone https://git.sr.ht/~unrealapex/slock ~/.config/slock

~/.config/slock/slock: $(wildcard ~/.config/slock/*.h) $(wildcard ~/.config/slock/*.c) | ~/.config/slock
	$(MAKE) -C ~/.config/slock install

/usr/local/bin/slock: ~/.config/slock/slock
	sudo $(MAKE) -C ~/.config/slock clean install

secrets: ~/.config/git/gitconfig.local ~/.config/irssi/credentials

~/.config/git/gitconfig.local:
	cp -n ~/dotfiles/secrets/gitconfig.local ~/.config/git/gitconfig.local

~/.config/irssi/credentials:
	cp -n ~/dotfiles/secrets/irssi_credentials ~/.config/irssi/credentials

done:
	@echo "Makefile targets completed!"

.PHONY: all secrets

