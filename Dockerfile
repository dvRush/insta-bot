FROM ruby:2.5.3

ENV DEBIAN_FRONTEND=noninteractive \
  PHANTOMJS_VERSION=2.1.1 \
  NODE_VERSION=8.9.1 \
  LANG=C.UTF-8 \
  DISPLAY=:0

RUN apt-get update && \
  apt-get install -y build-essential xvfb chromedriver

run curl -sSL "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2" | tar xfj - -C /usr/local && \
  ln -s /usr/local/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs

run curl -sSL "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" | tar xfJ - -C /usr/local --strip-components=1 && \
  npm install npm -g

WORKDIR /app
