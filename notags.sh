#!/usr/bin/env bash

for FILE in images/*; do
	FILE=$(basename "$FILE")
	if ! find tags -name "$FILE" | grep -q '.*'; then
		echo "$FILE"
	fi
done
