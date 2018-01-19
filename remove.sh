#!/usr/bin/env bash
GREP=/usr/local/bin/grep

IMAGES=images
TAGS=tags
IGNORE=ignore.txt
IGNORE_ID=ignore_id.txt

remove_id() {
	FILE=$(basename "$1")
	ID=$(echo "$FILE" | sed 's/,.*//')

	if ! $GREP -Fxq "$ID" "$IGNORE_ID"; then
		echo "$ID" >>"$IGNORE_ID"
	fi

	find . -depth -name "$FILE" -print -delete
}

remove_tag() {
	TAG=$(basename "$1")

	if ! $GREP -Fxq "$TAG" "$IGNORE"; then
		echo "$TAG" >>"$IGNORE"
	fi

	if [[ ! -d $TAGS/$TAG ]]; then
		return
	fi

	ls -1 $TAGS/$TAG | while read -r FILE; do
		FILE=$(basename "$FILE")
		find . -depth -name "$FILE" -print -delete
	done
}

while [[ $# -gt 0 ]]; do
	case "$1" in
		$IMAGES/*) remove_id "$1";;
		$TAGS/*) remove_tag "$1";;
	esac
	shift
done

find "$TAGS" -depth -empty -delete
sort -uo "$IGNORE" "$IGNORE"
sort -uo "$IGNORE_ID" "$IGNORE_ID"
