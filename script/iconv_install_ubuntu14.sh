#!/bin/bash
set -e

cd /tmp

wget -q https://ftp.gnu.org/gnu/libiconv/libiconv-1.14.tar.gz && \
  tar -xzf ./libiconv-1.14.tar.gz

cd /tmp/libiconv-1.14

wget -q https://gist.githubusercontent.com/merqlove/eda0bd9511fce0d319e6efb152f8c68d/raw/b8e40037af5c882b3395372093b78c42d6a7c06e/gistfile1.txt > iconv.patch && \
  patch -p1 -i ./iconv.patch && \
  sed -i -- 's/(gets/(fgets/g' ./srclib/stdio.in.h

./configure --prefix=/usr/local --enable-silent-rules && \
  make V=0 && \
  make V=0 install && \
  touch /etc/ld.so.conf.d/libiconv.conf && \
  echo "/usr/local/lib" > /etc/ld.so.conf.d/libiconv.conf && \
  ldconfig && \
  libtool --finish /usr/local/lib
  