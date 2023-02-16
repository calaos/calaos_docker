FROM debian:latest as builder

ENV DEBIAN_FRONTEND noninteractive

ENV HOME /opt
RUN mkdir -p $HOME /build /opt

#required packages
RUN apt-get update -qq && \
    apt-get install -y build-essential wget git curl libsigc++-2.0-dev \
        libjansson-dev libcurl4-openssl-dev libluajit-5.1-dev libsqlite3-dev \
        libcurl4-openssl-dev libusb-dev libow-dev imagemagick libev-dev unzip \
        zip cmake automake autoconf libtool autopoint gettext libusb-1.0-0-dev \
        knxd googletest libuv1-dev libmosquitto-dev libmosquittopp-dev

#required for OLA
RUN apt-get install -y libcppunit-dev bison flex uuid-dev libprotobuf-dev \
        protobuf-compiler libprotoc-dev

#build OLA
RUN cd /build && wget https://github.com/OpenLightingProject/ola/releases/download/0.10.8/ola-0.10.8.tar.gz && \
    tar xzvf ola-0.10.8.tar.gz && \
    cd ola-0.10.8 && \
    ./configure --prefix=/opt && \
    make -j12 install-strip && \
    cd ..

ENV PKG_CONFIG_PATH="/opt/lib/pkgconfig"

RUN git clone https://github.com/calaos/calaos_base.git && \
    cd calaos_base && ./autogen.sh && \
    ./configure --prefix=/opt CPPFLAGS=-I/opt/include LDFLAGS=-L/opt/lib && \
    make -j$(nproc) && \
    make install-strip

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /build/*

FROM debian:stable-slim as runner

# RUN apt-get update -qq && \
#     apt-get install -y knxd libuv1 libsigc++-2.0 libjansson libcurl4-openssl \
#         libluajit-5.1 libsqlite3 libusb libow imagemagick libev unzip wip libusb-1.0.0 \
#         knxd libmosquitto libmosquittopp libuv1

COPY --from=builder /opt /opt
