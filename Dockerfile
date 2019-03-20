FROM ruby:2.6.2

ENV DEBIAN_FRONTEND=noninteractive \
  LANG=C.UTF-8 \
  DISPLAY=:0

RUN apt-get update && \
  apt-get install -y \
    build-essential \
    chromedriver

WORKDIR /app
