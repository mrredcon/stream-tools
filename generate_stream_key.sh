#!/bin/bash

mydate=$(date +%s)
nextyear=$((60 * 60 * 24 * 365 + mydate))
nextyearmillis=$((nextyear * 1000))

if [[ ! -f 'streamkey.txt' ]]; then
	echo 'Missing streamkey.txt'
	exit 1
fi
streamkey=$(<streamkey.txt)

if [[ -z $1 ]]; then
	echo "Usage: $0 stream_name"
	exit 1
fi

echo 'Give this to the user for OBS: '
$HOME/signed_policy_url_generator.sh "$streamkey" "rtmp://goon.network:1935/app/$1" 'signature' 'policy' '{"url_expire":'"$nextyearmillis"'}'

echo 'Put this on the website: '
url=$($HOME/signed_policy_url_generator.sh "$streamkey" "wss://goon.network:3334/app/$1" 'signature' 'policy' '{"url_expire":'"$nextyearmillis"'}' | head -n 1 | sed 's/\[URL\] //')
echo '{ "label": "'"$1"'", "type": "webrtc", "file": "'"$url"'" }'
