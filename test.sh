#!/usr/bin/env bash
# AUTO='http://api.lovebizhi.com/macos_v4.php?a=autoWallpaper&uuid=d044e701cdd846278ca95398d5de5d03&retina=1&client_id=1008&device_id=74118386&screen_width=3360&screen_height=2100&bizhi_width=3360&bizhi_height=2100'
AUTO='http://api.lovebizhi.com/macos_v4.php?a=autoWallpaper&retina=1&screen_width=3360&screen_height=2100&bizhi_width=3360&bizhi_height=2100'
DATA='options={"loved":{"open":false},"category":{"open":true,"data":[1,2,3,4,5,6,7,8,10,797,798,1407,1546,1554,2097,2098,2180,21866]}}'

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

# curl -d"$DATA" "$AUTO" | jq
# wget --post-data="$DATA" -O- "$AUTO" | jq
json "$AUTO" "$DATA"
