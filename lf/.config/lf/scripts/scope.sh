#!/bin/bash

# File preview handler for lf.

set -C -f
IFS="$(printf '%b_' '\n')"; IFS="${IFS%_}"

image() {
	if [ -f "$1" ] && [ -n "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] then
        # TODO: check if this works
        kitten icat --transfer-mode file --stdin no --place 41x22@39x1 "$1" < /dev/null > /dev/tty  
	else
		mediainfo "$6"
	fi
}


# Note that the cache file name is a function of file information, meaning if
# an image appears in multiple places across the machine, it will not have to
# be regenerated once seen.

case "$(file --dereference --brief --mime-type -- "$1")" in
	image/avif) CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/lf/thumb.$(stat --printf '%n\0%i\0%F\0%s\0%W\0%Y' -- "$(readlink -f "$1")" | sha256sum | cut -d' ' -f1)"
		[ ! -f "$CACHE" ] && convert "$1" "$CACHE.jpg"
		image "$CACHE.jpg" "$2" "$3" "$4" "$5" "$1" ;;
	image/*) image "$1" "$2" "$3" "$4" "$5" "$1" ;;
	text/html) lynx -width="$4" -display_charset=utf-8 -dump "$1" ;;
	text/troff) man ./ "$1" | col -b ;;
	text/* | */xml | application/json) bat --terminal-width "$(($4-2))" -f "$1" ;;
	audio/* | application/octet-stream) mediainfo "$1" || exit 1 ;;
	video/* )
		CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/lf/thumb.$(stat --printf '%n\0%i\0%F\0%s\0%W\0%Y' -- "$(readlink -f "$1")" | sha256sum | cut -d' ' -f1)"
		[ ! -f "$CACHE" ] && ffmpegthumbnailer -i "$1" -o "$CACHE" -s 0
		image "$CACHE" "$2" "$3" "$4" "$5" "$1"
		;;
	*/pdf)
		CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/lf/thumb.$(stat --printf '%n\0%i\0%F\0%s\0%W\0%Y' -- "$(readlink -f "$1")" | sha256sum | cut -d' ' -f1)"
		[ ! -f "$CACHE.jpg" ] && pdftoppm -jpeg -f 1 -singlefile "$1" "$CACHE"
		image "$CACHE.jpg" "$2" "$3" "$4" "$5" "$1"
		;;
	*/epub+zip|*/mobi*)
		CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/lf/thumb.$(stat --printf '%n\0%i\0%F\0%s\0%W\0%Y' -- "$(readlink -f "$1")" | sha256sum | cut -d' ' -f1)"
		[ ! -f "$CACHE.jpg" ] && gnome-epub-thumbnailer "$1" "$CACHE.jpg"
		image "$CACHE.jpg" "$2" "$3" "$4" "$5" "$1"
		;;
	application/*zip) atool --list -- "$1" ;;
	*opendocument*) odt2txt "$1" ;;
	application/pgp-encrypted) gpg -d -- "$1" ;;
esac
exit 1