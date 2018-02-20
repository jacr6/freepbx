#!/bin/bash

wget  https://github.com/git/git/archive/v2.16.2.tar.gz
tar -zxf v2.16.2.tar.gz
cd git-2.16.2
make configure
./configure --prefix=/usr
make all doc info
sudo make install install-doc install-html install-info
