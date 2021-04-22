FROM ubuntu:20.04 as intermediate_builder

LABEL maintainer="raoul.hecky@gmail.com"
LABEL description="Ubuntu image with Qt5 build with mxe"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y autoconf \
    automake \
    autopoint \
    bash \
    bison \
    bzip2 \
    flex \
    gcc \
    g++ \
    g++-multilib \
    gettext \
    git \
    gperf \
    intltool \
    libc6-dev-i386 \
    libgdk-pixbuf2.0-dev \
    libltdl-dev \
    libssl-dev \
    libtool-bin \
    libxml-parser-perl \
    lzip \
    make \
    openssl \
    p7zip-full \
    patch \
    perl \
    python \
    ruby \
    sed \
    unzip \
    wget \
    xz-utils

WORKDIR /mxe

COPY mxe /mxe

RUN make dbus fontconfig freetds libmysqlclient openssl postgresql sqlite icu4c zstd -j4 JOBS=20
RUN make jpeg libwebp xz minizip jasper tiff assimp lcms libmng libxml2 libxslt openssl bzip2 zstd xz zlib -j4 JOBS=20

RUN make qtbase -j4 JOBS=20
RUN make qtimageformats -j4 JOBS=20
RUN make qtsvg -j4 JOBS=20
RUN make qtxmlpatterns -j4 JOBS=20
RUN make qtdeclarative -j4 JOBS=20
RUN make qtgamepad -j4 JOBS=20
RUN make qt3d -j4 JOBS=20
RUN make qtactiveqt -j4 JOBS=20
RUN make qtmultimedia -j4 JOBS=20
RUN make qtcharts -j4 JOBS=20
RUN make qtconnectivity -j4 JOBS=20
RUN make qtdatavis3d -j4 JOBS=20
RUN make qtgraphicaleffects -j4 JOBS=20
RUN make qtlocation -j4 JOBS=20
RUN make qtlottie -j4 JOBS=20
RUN make qtnetworkauth -j4 JOBS=20
RUN make qtpurchasing -j4 JOBS=20
RUN make qtquick3d -j4 JOBS=20
RUN make qtquickcontrols -j4 JOBS=20
RUN make qtquickcontrols2 -j4 JOBS=20
RUN make qtremoteobjects -j4 JOBS=20
RUN make qtscript -j4 JOBS=20
RUN make qtscxml -j4 JOBS=20
RUN make qtsensors -j4 JOBS=20
RUN make qtserialport -j4 JOBS=20
RUN make qtserialbus -j4 JOBS=20
RUN make qtspeech -j4 JOBS=20
RUN make qttools -j4 JOBS=20
RUN make qttranslations -j4 JOBS=20
RUN make qtvirtualkeyboard -j4 JOBS=20
RUN make qtwebsockets -j4 JOBS=20
RUN make qtwebchannel -j4 JOBS=20
RUN make qtwebview -j4 JOBS=20
RUN make qtwinextras -j4 JOBS=20

RUN make qt5 -j4 JOBS=20

#RUN make qtwebkit -j4 JOBS=20

RUN make karchive

#Install innosetup in another stage
FROM amake/wine:latest as inno
USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends procps xvfb \
    && rm -rf /var/lib/apt/lists/*

# get at least error information from wine
ENV WINEDEBUG -all,err+all

# Run virtual X buffer on this port
ENV DISPLAY :99

COPY opt /opt
RUN chmod +x /opt/bin/*
ENV PATH $PATH:/opt/bin
USER xclient

# Install Inno Setup binaries
RUN curl -SL "https://files.jrsoftware.org/is/6/innosetup-6.1.2.exe" -o is.exe && \
    wine-x11-run wine is.exe /SP- /VERYSILENT /ALLUSERS /SUPPRESSMSGBOXES && \
    rm is.exe

# Install unofficial languages
RUN cd "/home/xclient/.wine/drive_c/Program Files/Inno Setup 6/Languages" && \
    curl -L "https://api.github.com/repos/jrsoftware/issrc/tarball/is-6_1_2" | \
    tar xz --strip-components=4 --wildcards "*/Files/Languages/Unofficial/*.isl"

#Use multi-stage to not keep builds deps and file into the final image to reduce size
FROM ubuntu:20.04

COPY etc/apt-no-cache /etc/apt/apt.conf.d/02nocache
COPY etc/no-man /etc/dpkg/dpkg.cfg.d/01_nodoc

COPY --from=intermediate_builder /mxe/usr /mxe/usr

RUN addgroup --system xusers \
    && adduser \
    --home /home/xclient \
    --disabled-password \
    --shell /bin/bash \
    --gecos "user for running an xclient application" \
    --ingroup xusers \
    --quiet \
    xclient

# Install some tools required for creating the image
# Install wine and related packages
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends libc6:i386 && \
    apt-get install -y --no-install-recommends \
    wine \
    wine32 \
    osslsigncode \
    && rm -rf /var/lib/apt/lists/*

COPY opt /opt
RUN chmod +x /opt/bin/*
ENV PATH $PATH:/opt/bin

#Copy from intermediate Inno setup
COPY --chown=xclient:xusers --from=inno /home/xclient/.wine /home/xclient/.wine

RUN mkdir /work-iscc && chown xclient:xusers -R /work-iscc

#Install missing dev tools
RUN apt update && \
    DEBIAN_FRONTEND="noninteractive" apt install -y \
        make zip unzip wget xz-utils git bzip2 bash curl python sudo

RUN rm -fr /*.deb

# Wine really doesn't like to be run as root, so let's use a non-root user
# iscc must be started with sudo
RUN mkdir /work && \
    chown -R xclient:xusers /work

RUN echo "xclient ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER xclient
ENV HOME /home/xclient
ENV WINEPREFIX /home/xclient/.wine
ENV WINEARCH win32
RUN mkdir /home/xclient/bin
ENV PATH="$HOME/bin:${PATH}"

COPY scripts /scripts

COPY start.sh /
ENTRYPOINT ["/start.sh"]
CMD ["/start"]

