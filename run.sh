#!/bin/bash
grep . /var/lib/tor/*/hostname

default_gw="$(netstat -rn | grep -e '^0.0.0.0' | awk '{print $2}')"

ssh_host_ip=${ssh_host_ip:-$default_gw}
ssh_host_port=${ssh_host_port:-22}

echo "ssh_host_ip: ${ssh_host_ip}"
echo "ssh_host_port: ${ssh_host_port}"

sed -i -e 's@^#%include /etc/torrc.d/@%include /etc/torrc.d/@' /etc/tor/torrc

mkdir -p /etc/torrc.d

cat <<EOF > /etc/torrc.d/ssh
HiddenServiceDir /var/lib/tor/ssh/
HiddenServiceVersion 3
HiddenServicePort 22 ${ssh_host_ip}:${ssh_host_port}

SafeLogging 0
Log notice stdout
EOF

exec tor $@
