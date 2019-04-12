#/bin/env bash

set -ev

SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $SCRIPTDIR/funcs.sh

build_dir=/calaos_installer/build_win
build_mc_dir=/calaos_installer/build_win/mc
MXE_BIN=$HOME/mxe/usr/i686-w64-mingw32.shared.posix
WDIR=$HOME/.wine/drive_c/calaos_installer_build
PKDIR=/calaos_installer/packages
mkdir -p $PKDIR

cd /calaos_installer
VERSION="$(get_version .)"
FILENAME=calaos_installer_setup_$VERSION

mkdir -p $WDIR
cd $build_dir/..

for f in $MXE_BIN/bin/libgcc_s_sjlj-1.dll \
         $MXE_BIN/bin/libstdc++-6.dll \
         $MXE_BIN/bin/libwinpthread-1.dll \
         $MXE_BIN/bin/zlib1.dll \
         $MXE_BIN/bin/libcrypto-1_1.dll \
         $MXE_BIN/bin/libssl-1_1.dll \
         $MXE_BIN/bin/icudt56.dll \
         $MXE_BIN/bin/icuin56.dll \
         $MXE_BIN/bin/icuuc56.dll \
         $MXE_BIN/qt5/bin/Qt5Core.dll \
         $MXE_BIN/qt5/bin/Qt5Gui.dll \
         $MXE_BIN/qt5/bin/Qt5Network.dll \
         $MXE_BIN/qt5/bin/Qt5Widgets.dll \
         $MXE_BIN/qt5/bin/Qt5WebSockets.dll \
         $MXE_BIN/qt5/bin/Qt5Xml.dll \
         $MXE_BIN/qt5/bin/Qt5XmlPatterns.dll \
         $MXE_BIN/qt5/bin/Qt5PrintSupport.dll \
         $MXE_BIN/qt5/plugins/imageformats \
         $MXE_BIN/qt5/plugins/platforms \
         $MXE_BIN/qt5/plugins/printsupport \
         $MXE_BIN/qt5/plugins/styles \
         $build_dir/release/calaos_installer.exe \
         $build_mc_dir/release/calaos_machinecreator.exe
do
    cp -R $f $WDIR
done

find_and_sign $WDIR

pushd win32

echo "#define MyAppVersion \"$VERSION\"" > build.iss
cat installer.iss >> build.iss
chmod +x iscc
./iscc build.iss

sign_binary build/$FILENAME.exe
mv build/$FILENAME.exe $PKDIR

popd

