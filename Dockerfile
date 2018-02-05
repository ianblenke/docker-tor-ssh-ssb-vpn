FROM debian:stretch

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y gnupg2 apt-transport-https net-tools \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN echo "deb https://deb.torproject.org/torproject.org stretch main" > /etc/apt/sources.list.d/tor.list \
 && gpg2 --keyserver keys.gnupg.net --recv 886DDD89 \
 && gpg2 --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add - \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y tor deb.torproject.org-keyring \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -d /home/tor -m tor \
 && chown -R tor /var/lib/tor \
 && chmod 1777 /var/lib/tor

ADD run.sh /run.sh

EXPOSE 9050

VOLUME /var/lib/tor

CMD /run.sh
