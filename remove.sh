#!/usr/bin/env bash
IMAGES=images
TAGS=tags
IGNORE=ignore.txt
IGNORE_ID=ignore_id.txt

remove() {
	ITEM="$IMAGES/$1"
	if [[ -f "$ITEM" ]]; then
		echo "$ITEM"
		trash "$ITEM"
	fi
	find "$TAGS" -depth -name "$1" -print -delete
}

remove_id() {
	FILE=$(basename "$1")
	ID=$(echo "$FILE" | sed 's/,.*//')

	if ! grep -Fxq "$ID" "$IGNORE_ID"; then
		echo "$ID" >>"$IGNORE_ID"
	fi

	remove "$FILE"
}

remove_tag() {
	TAG=$(basename "$1")

	if ! grep -Fxq "$TAG" "$IGNORE"; then
		echo "$TAG" >>"$IGNORE"
	fi

	if [[ ! -d $TAGS/$TAG ]]; then
		return
	fi

	while read -r FILE; do
		remove "$(basename "$FILE")"
	done < <(ls -1 "$TAGS/$TAG")
}

while [[ $# -gt 0 ]]; do
	TYPE=$(basename $(dirname "$1"))
	case "$TYPE" in
		$IMAGES) remove_id "$1";;
		$TAGS) remove_tag "$1";;
	esac
	shift
done

find "$TAGS" -depth -empty -delete
sort -uo "$IGNORE" "$IGNORE"
sort -uo "$IGNORE_ID" "$IGNORE_ID"
