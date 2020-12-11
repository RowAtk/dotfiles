#!/bin/sh

function scroll () {
	prefix="$1"
	scrolling="$2"
	temp="$(echo "$scrolling"| sed "s/^\(.\{20\}\)\(.*\)$/\1[\2]/"| sed "s/\[ *\]$//"| sed "s/\[.*\]$//")"
	suffix="$3"
	if [ "$(echo -n $scrolling |wc -c)" -gt 20 ]; then
		# echo "$prefix%{T7}$temp%{T-}$suffix"
		# sleep 0.5

		zscroll -l 20 \
            --delay 0.2 \
			--before-text "$prefix" \
			--after-text "$suffix" \
			--scroll-padding "     " \
            --update-check true "echo '$(get_info)'" &

		wait
	else
		echo "$prefix$(get_info)$suffix"
	fi
} #

function get_info () {
    echo "$(get_title) ~ $(get_album)"
}

function get_artist () {
	echo "$(playerctl -p spotify metadata --format "{{ artist }}"| sed -e "s/[[(]....*[])]*//g" | sed "s/ *$//"| sed "s/^\(.\{20\}[^ ]*\)\(.*\)$/\1[\2]/"| sed "s/\[ *\]$//"| sed "s/\[.*\]$/.../")"
} #

function get_title () {
	echo "$(playerctl -p spotify metadata --format "{{title}}" | sed 's/'\''/\\'\''/g')"
} #

function get_album () {
    echo "$(playerctl -p spotify metadata --format "{{album}}" | sed 's/'\''/\\'\''/g')"
}

[ ! -z "$(playerctl -p spotify status 2>/dev/null)" ] \
	&& artist=$(get_artist) \
	&& title=$(get_title) \
    && album=$(get_album) \
	&& ([ -z "$artist$title" ] && scroll "" "Spotify is not connected on this pc" "" || scroll "$artist %{F#FFB52A}| %{F-}" "$title {$album}" ) \
	|| exit 1