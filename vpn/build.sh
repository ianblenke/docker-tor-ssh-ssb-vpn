#!/bin/bash -xe

yum -y update \
  && yum -y groupinstall "Development Tools" \
  && yum -y install readline-devel ncurses-devel openssl-devel

git clone --depth 1 https://github.com/SoftEtherVPN/SoftEtherVPN.git /usr/local/src/vpnserver

cd /usr/local/src/vpnserver

cp src/makefiles/linux_64bit.mak Makefile
make

find . -name vpnserver
find . -name hamcore.se2
find . -name vpncmd

cp -a bin/vpnserver/vpnserver /opt/vpnserver
cp -a bin/vpnserver/hamcore.se2 /opt/hamcore.se2
cp -a bin/vpncmd/vpncmd /opt/vpncmd

rm -rf /usr/local/src/vpnserver

gcc -o /usr/local/sbin/run /usr/local/src/run.c

rm /usr/local/src/run.c

yum -y remove readline-devel ncurses-devel openssl-devel \
  && yum -y groupremove "Development Tools" \
  && yum clean all

exit 0
