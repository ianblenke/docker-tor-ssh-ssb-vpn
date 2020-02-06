#!/bin/bash -e
. $HOME/.nvm/nvm.sh
while [ ! -f /var/lib/tor/ssh-ssb/hostname ]; do
  echo "Waiting for ssh-ssb hidden service to start up..."
  sleep 5
done

export HOST=$(cat /var/lib/tor/ssh-ssb/hostname)

cat <<EOF > $HOME/.ssb/config
{
  "allowPrivate":true,
  "incoming": {
    "net": [
      { "scope": "public",  "external": ["${HOST}"], "transform": "shs", "port": 8008 },
      { "scope": "private", "transform": "shs", "port": 8008, "host": "ssb-pub" }
    ]
  },
  "outgoing": {
    "onion": [{ "transform": "shs" }]
  }
}
EOF

echo "Onion hostname: $HOST"

exec npm start
