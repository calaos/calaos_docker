#/bin/env bash

set -ev

PATH=/mxe/usr/bin:$PATH
MXE_BASE=/mxe
build_dir=/calaos_installer/build_win
build_mc_dir=/calaos_installer/build_win/mc

sudo chown xclient:xusers /calaos_installer -R

rm -fr $build_dir && mkdir -p $build_mc_dir && cd $build_dir

$MXE_BASE/usr/i686-w64-mingw32.shared.posix/qt5/bin/qmake ../calaos_installer.pro
make -j$(nproc --all)

cd $build_mc_dir

$MXE_BASE/usr/i686-w64-mingw32.shared.posix/qt5/bin/qmake ../../machine_creator/machine_creator.pro
make -j$(nproc --all)

