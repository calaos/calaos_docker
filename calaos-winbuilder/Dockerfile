FROM raoulh/mxe_qt6:qt6.2.3

LABEL maintainer="raoul.hecky@gmail.com"

#Fix host lrelease path
RUN sudo ln -s /mxe/usr/x86_64-pc-linux-gnu/qt6/bin/lrelease /mxe/usr/i686-w64-mingw32.shared.posix/qt6/bin/lrelease && \
    sudo ln -s /mxe/usr/x86_64-pc-linux-gnu/qt6/bin/lupdate /mxe/usr/i686-w64-mingw32.shared.posix/qt6/bin/lupdate && \
    sudo ln -s /mxe/usr/x86_64-pc-linux-gnu/qt6/bin/lrelease /mxe/usr/x86_64-w64-mingw32.shared.posix/qt6/bin/lrelease && \
    sudo ln -s /mxe/usr/x86_64-pc-linux-gnu/qt6/bin/lupdate /mxe/usr/x86_64-w64-mingw32.shared.posix/qt6/bin/lupdate

COPY scripts /scripts

