FROM buildpack-deps:xenial

# Support docker architectures other than x86_64
RUN uname -p | grep x86_64 \
      && echo "deb http://archive.ubuntu.com/ubuntu xenial main universe" >> /etc/apt/sources.list \
      || echo "deb http://ports.ubuntu.com/ubuntu-ports xenial main universe" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y curl libc6 libcurl3 zlib1g libtool autoconf libleveldb-dev

RUN git clone -b stable https://github.com/jedisct1/libsodium.git \
 && cd libsodium \
 && ./configure \
 && make check \
 && make install

ENV NPM_CONFIG_LOGLEVEL=info NODE_VERSION=8.10.0 HOME=/root

WORKDIR ${HOME}

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
ENV NVM_DIR=$HOME/.nvm
RUN . $NVM_DIR/nvm.sh \
 && nvm install $NODE_VERSION \
 && nvm alias default $NODE_VERSION \
 && mkdir app

WORKDIR app/

COPY package-lock.json .
COPY package.json .
RUN . $HOME/.nvm/nvm.sh \
 && npm install
COPY . .

RUN mkdir ${HOME}/.ssb

USER root

VOLUME ${HOME}/.ssb

EXPOSE 80
EXPOSE 8008
EXPOSE 8007

CMD ./run.sh
