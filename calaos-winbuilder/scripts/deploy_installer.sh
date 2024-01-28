#!/bin/env bash

set -ev

SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $SCRIPTDIR/funcs.sh

upload_token=$1

PKDIR=/calaos_installer/packages
mkdir -p $PKDIR

if [ -z "$upload_token" ]
then
    echo "No upload token"
    exit 1
fi

export UPLOAD_KEY=$upload_token

cd /calaos_installer

upload_file $PKDIR/*.exe $(sha256sum $PKDIR/*.exe | cut -d' ' -f1) "experimental/calaos_installer/windows"

