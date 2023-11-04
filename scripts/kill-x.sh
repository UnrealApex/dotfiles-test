#!/bin/bash
echo '
Section "ServerFlags"
    Option "DontZap" "false"
EndSection

Section "InputClass"
    Identifier      "Keyboard Defaults"
    MatchIsKeyboard "yes"
    Option          "XkbOptions" "terminate:ctrl_alt_bksp"
EndSection' | sudo tee /etc/X11/xorg.conf.d/40-kill-x.conf

