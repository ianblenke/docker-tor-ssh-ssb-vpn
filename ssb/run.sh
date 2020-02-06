#!/bin/bash -e
echo '{ "allowPrivate":true}' > $HOME/.ssb/config
. $HOME/.nvm/nvm.sh
while [ ! -f /var/lib/tor/ssh-ssb/hostname ]; do
  echo "Waiting for ssh-ssb hidden service to start up..."
  sleep 5
done

export HOST=$(cat /var/lib/tor/ssh-ssb/hostname)

exec npm start
