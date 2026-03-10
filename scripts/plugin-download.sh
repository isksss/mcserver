#!/bin/bash

API="https://api.modrinth.com/v2/project"
PLUGIN_DIR="$SCRIPT_DIR/plugins"
mkdir -p "$PLUGIN_DIR"
if [ "$#" -eq 0 ]; then
	echo "Usage: $0 <plugin1> <plugin2> ..."
	exit 1
fi

for PROJECT in "$@"; do
	echo "Fetching $PROJECT (paper)..."

	DATA=$(curl -s -G \
		-H "User-Agent: plugin-downloader" \
		--data-urlencode 'loaders=["paper"]' \
		"https://api.modrinth.com/v2/project/$PROJECT/version")

	URL=$(echo "$DATA" | jq -r '.[0].files[0].url')
	NAME=$(echo "$DATA" | jq -r '.[0].files[0].filename')

	if [ "$URL" = "null" ]; then
		echo "Paper build not found: $PROJECT"
		continue
	fi

	echo "Downloading $NAME"
	curl -L "$URL" -o "$PLUGIN_DIR/$NAME"

done
