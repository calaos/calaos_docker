FROM ubuntu:18.04

MAINTAINER Raoul Hecky "raoul.hecky@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

ENV HOME /home/ubuntu
RUN mkdir -p $HOME

#required packages
RUN dpkg --add-architecture i386 && \
    apt-get update -qq && \
    apt-get install -y build-essential wget git curl software-properties-common wine-stable wine32 unzip zip

#Innosetup
RUN mkdir -p "$HOME/.wine/drive_c/Program Files/" && \
    cd "$HOME/.wine/drive_c/Program Files/" && \
    wget https://calaos.fr/download/misc/InnoSetup5.zip && \
    unzip InnoSetup5.zip

#mingw+qt toolchain
RUN cd $HOME && \
    wget https://calaos.fr/download/misc/mxe_qt596.tar.xz && \
    tar xJf mxe_qt596.tar.xz

#codesign
RUN wget https://github.com/mooltipass/osslsigncode/releases/download/1.7.1/osslsigncode_amd64.tar.xz && \
    tar xJvf osslsigncode_amd64.tar.xz && rm osslsigncode_amd64.tar.xz && \
    chmod +x osslsigncode && \
    mv osslsigncode /usr/bin

COPY scripts /scripts

COPY start.sh /
ENTRYPOINT ["/start.sh"]
CMD ["/start"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
