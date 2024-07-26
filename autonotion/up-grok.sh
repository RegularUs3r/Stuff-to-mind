#!/bin/bash


ngrok http 80 > /dev/null & 
python3 -m http.server 80 --directory /media/<SOME-SECRET-FOLDER>/Sprint-2 &
sleep 1 && ng=$(curl -sS http://localhost:4040/api/tunnels | jq -r .tunnels[0].public_url | awk -F// '{print $2}')
echo "Here's your ngrok address $ng"

