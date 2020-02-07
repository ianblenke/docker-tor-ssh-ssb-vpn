FROM centos:centos7

MAINTAINER Ian Blenke <ian@blenke.com>

COPY run.c /usr/local/src/

RUN yum -y update \
 && yum -y groupinstall "Development Tools" \
 && yum -y install readline-devel ncurses-devel openssl-devel cmake

RUN mkdir -p /usr/local/src \
 && git clone https://github.com/SoftEtherVPN/SoftEtherVPN.git /usr/local/src/vpnserver \
 && cd /usr/local/src/vpnserver \
 && git submodule update --init --recursive

RUN yum -y install epel-release
RUN yum -y install cmake3 \
 && alternatives --install /usr/local/bin/cmake cmake /usr/bin/cmake 10 \
--slave /usr/local/bin/ctest ctest /usr/bin/ctest \
--slave /usr/local/bin/cpack cpack /usr/bin/cpack \
--slave /usr/local/bin/ccmake ccmake /usr/bin/ccmake \
--family cmake \
 && alternatives --install /usr/local/bin/cmake cmake /usr/bin/cmake3 20 \
--slave /usr/local/bin/ctest ctest /usr/bin/ctest3 \
--slave /usr/local/bin/cpack cpack /usr/bin/cpack3 \
--slave /usr/local/bin/ccmake ccmake /usr/bin/ccmake3 \
--family cmake

RUN cd /usr/local/src/vpnserver \
 && ./configure \
 && mkdir builder \
 && cd builder \
 && cmake .. \
 && make \
 && make install \
 && ln -s /usr/local/libexec/softether/vpnserver/vpnserver /opt/vpnserver \
 && ln -s /usr/local/libexec/softether/vpnclient/hamcore.se2 /opt/hamcore.se2 \
 && ln -s /usr/local/libexec/softether/vpncmd/vpncmd /opt/vpncmd \
 && ln -s /usr/local/libexec/softether/vpncmd/vpnbridge /opt/vpnbridge \
 && gcc -o /usr/local/sbin/run /usr/local/src/run.c \
 && rm /usr/local/src/run.c \
 && cd / \
 && rm -fr /usr/local/src/vpnserver

RUN yum -y remove readline-devel ncurses-devel openssl-devel \
 && yum -y groupremove "Development Tools" \
 && yum clean all

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /opt

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 500/udp 4500/udp 1701/tcp 1194/udp

CMD ["/usr/local/sbin/run"]
