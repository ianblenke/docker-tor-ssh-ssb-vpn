#!/bin/bash

default_gw="$(netstat -rn | grep -e '^0.0.0.0' | awk '{print $2}')"

ssh_host_ip=${ssh_host_ip:-$default_gw}
ssh_host_port=${ssh_host_port:-22}

echo "ssh_host_ip: ${ssh_host_ip}"
echo "ssh_host_port: ${ssh_host_port}"

[ ! -f /etc/tor/torrc ] && [ -f /etc/tor/torrc.sample ] && cp -f /etc/tor/torrc.sample /etc/tor/torrc

sed -i -e 's@^#%include /etc/torrc.d/@%include /etc/torrc.d/@' /etc/tor/torrc
if ! grep -e '^%include /etc/torrc.d/' /etc/tor/torrc ; then
  echo '%include /etc/torrc.d/' >> /etc/tor/torrc
fi

mkdir -p /etc/torrc.d

cat <<EOF > /etc/torrc.d/ssh-ssb
HiddenServiceDir /var/lib/tor/ssh-ssb/
HiddenServiceVersion 3
HiddenServicePort 22 ${ssh_host_ip}:${ssh_host_port}
HiddenServicePort 80 ssb-pub:80
HiddenServicePort 8008 ssb-pub:8008

SafeLogging 0
Log notice stdout
EOF

echo "Configuration:"
grep -v -e '^#\|^$' /etc/tor/torrc /etc/torrc.d/*

grep -r . /var/lib/tor/ssb-pub/

if [ -f /var/lib/tor/ssb-pub/hostname ]; then
  echo 'Onion Hostname:' $(cat /var/lib/tor/ssh-ssb/hostname)
fi

sed -i% -e 's%/sbin/nologin%/bin/bash%' /etc/passwd

chown -R tor /var/lib/tor
chmod 1777 /var/lib/tor
exec su - tor -c 'tor $@'
