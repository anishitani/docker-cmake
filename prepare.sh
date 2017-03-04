#!/bin/sh -e

VERSIONS=$(cat versions)

for CMAKE_VERSION in $VERSIONS
do
  CMAKE_MAJOR=`echo $CMAKE_VERSION | cut -d. -f1`
  CMAKE_MINOR=`echo $CMAKE_VERSION | cut -d. -f2`
  CMAKE_URL="https://cmake.org/files/v$CMAKE_MAJOR.$CMAKE_MINOR/cmake-$CMAKE_VERSION.tar.gz"
  mkdir -p $CMAKE_VERSION
  cat << EOF > $CMAKE_VERSION/Dockerfile
  FROM alpine
  MAINTAINER André Nishitani <atoshio25@gmail.com>
  RUN wget $CMAKE_URL \\
      && mv cmake-$CMAKE_VERSION.tar.gz /tmp/ && cd /tmp \\
      && tar -xzf cmake-$CMAKE_VERSION.tar.gz \\
      && cd cmake-$CMAKE_VERSION \\
      && sh bootstrap \\
      && make \\
      && make install \\
      && cd / && rm -r /tmp/cmake-$CMAKE_VERSION
EOF
done
