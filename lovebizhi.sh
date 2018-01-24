#!/usr/bin/env bash
# AUTO='http://api.lovebizhi.com/macos_v4.php?a=autoWallpaper&uuid=d044e701cdd846278ca95398d5de5d03&retina=1&client_id=1008&device_id=74118386&screen_width=3360&screen_height=2100&bizhi_width=3360&bizhi_height=2100'
AUTO='http://api.lovebizhi.com/macos_v4.php?a=autoWallpaper&retina=1&screen_width=3360&screen_height=2100&bizhi_width=3360&bizhi_height=2100'
DATA='options={"loved":{"open":false},"category":{"open":true,"data":[1,2,3,4,5,6,7,8,10,797,798,1407,1546,1554,2097,2098,2180,21866]}}'

IMAGES=images
TAGS=tags
IGNORE=ignore.txt
IGNORE_ID=ignore_id.txt

json() {
	if [[ -z "$2" ]]; then
		echo "GET $1" >&2
		# wget -O- "$1"
		curl "$1"
	else
		echo "POST $1" >&2
		# wget --post-data="$2" -O- "$1"
		curl -d"$2" "$1"
	fi
}

download() {
	echo "DOWNLOAD $1"
	wget "$1" -O "$2"
}

filepath() {
	if [[ ! -d "$IMAGES" ]]; then
		mkdir -p "$IMAGES"
	fi
	echo "$IMAGES/$1"
}

link() {
	DIR="$TAGS/$1"
	if [[ ! -d "$DIR" ]]; then
		mkdir -p "$DIR"
	fi
	cd "$DIR" || return
	ln -sf "../../$IMAGES/$2"
	cd ../.. || return
}

remove() {
	find . -depth -name "$2" -delete
}

echo "******** START AT $(date) ********"

while read -r ID DETAIL URL URL2; do

	if grep -Fxq "$ID" "$IGNORE_ID"; then
		echo "******** Ignore '$ID' ********"
		continue
	fi

	if [[ $URL == null ]]; then
		URL=${URL2//.webp/.jpg}
	fi

	FILE=$(basename "$URL")

	while read -r TAG; do
		if grep -Fxq "$TAG" "$IGNORE"; then
			echo "******** Ignore '$ID' for '$TAG' ********"
			remove "$ID" "$FILE"
			continue 2
		fi
		link "$TAG" "$FILE"
	done < <(json "$DETAIL" | jq -r '.tags[] | .name')

	FILEPATH=$(filepath "$FILE")
	if [[ -s "$FILEPATH" ]]; then
		echo "******** Already download '$ID' ********"
		continue
	fi
	if ! download "$URL" "$FILEPATH"; then
		remove "$ID" "$FILE"
		continue
	fi
	touch "$FILEPATH"
	if [[ ! -s "$FILEPATH" ]]; then
		remove "$ID" "$FILE"
	fi

done < <(json "$AUTO" "$DATA" | jq -r '.[] | .file_id, .detail, .image.vip_original, .image.original' | paste - - - -)

find "$TAGS" -depth -empty -delete

echo "******** END AT $(date) ********"
