FROM debian:stretch

MAINTAINER Raoul Hecky "raoul.hecky@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

ENV HOME /opt
RUN mkdir -p $HOME /build /opt

#required packages
RUN apt-get update -qq && \
    apt-get install -y build-essential wget git curl libsigc++-2.0-dev libjansson-dev libcurl4-openssl-dev libluajit-5.1-dev libsqlite3-dev libcurl4-openssl-dev libusb-dev libow-dev imagemagick libev-dev unzip zip cmake automake autoconf libtool autopoint gettext libusb-1.0-0-dev

#required for OLA
RUN apt-get install -y libcppunit-dev bison flex uuid-dev libprotobuf-dev protobuf-compiler libprotoc-dev

#Build libuv
RUN cd /build && wget https://dist.libuv.org/dist/v1.19.2/libuv-v1.19.2.tar.gz && \
    tar xzvf libuv-v1.19.2.tar.gz && \
    cd libuv-v1.19.2 && \
    ./autogen.sh && \
    ./configure --prefix=/opt && \
    make -j 12 install-strip && \
    cd ..

#Build fmt
RUN cd /build && wget https://github.com/fmtlib/fmt/releases/download/4.0.0/fmt-4.0.0.zip && \
    unzip fmt-4.0.0.zip && mkdir -p fmt-4.0.0/build && \
    cd fmt-4.0.0/build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/opt && \
    make -j 12 install && \
    cd ..

#Build knxd
RUN cd /build && wget https://github.com/knxd/knxd/archive/v0.14.17.tar.gz && \
    tar xzvf v0.14.17.tar.gz && \
    cd knxd-0.14.17 && \
    ./bootstrap.sh && \
    ./configure --prefix=/opt --disable-systemd CPPFLAGS=-I/opt/include LDFLAGS=-L/opt/lib && \
    make -j12 install-strip && \
    cd ..

#build OLA
RUN cd /build && wget https://github.com/OpenLightingProject/ola/releases/download/0.10.5/ola-0.10.5.tar.gz && \
    tar xzvf ola-0.10.5.tar.gz && \
    cd ola-0.10.5 && \
    ./configure --prefix=/opt && \
    make -j12 install-strip && \
    cd ..

#build gtest
RUN cd /build && wget https://github.com/google/googletest/archive/release-1.8.0.zip && \
    unzip release-1.8.0.zip && \
    cd googletest-release-1.8.0/ && \
    mkdir build && cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/opt -DBUILD_SHARED_LIBS=ON -DCMAKE_SKIP_RPATH=ON && \
    make -j12 install && \
    cd ..

RUN apt-get install -y libmosquitto-dev libmosquittopp-dev

COPY scripts /scripts

COPY start.sh /
ENTRYPOINT ["/start.sh"]
CMD ["/start"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /build/*
