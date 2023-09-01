#
# ~/.zprofile
#


[[ -f ~/.zshrc ]] && . ~/.zshrc

# Autostart X at login
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  # exec startx
fi
