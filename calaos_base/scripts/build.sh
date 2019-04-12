#!/bin/env bash

set -ev

mkdir -p /build

export PKG_CONFIG_PATH="/opt/lib/pkgconfig"

cd /calaos_base
./autogen.sh

cd /build
../calaos_base/configure --prefix=/opt CPPFLAGS=-I/opt/include LDFLAGS=-L/opt/lib

make -j$(nproc --all)
make install-strip

tar cJvf /calaos_base/calaos_base.tar.xz /opt

