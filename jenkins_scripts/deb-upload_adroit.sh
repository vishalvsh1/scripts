#!/bin/bash

location=$1
project=$2
deb_dir=""

if [ "$project" == "rtfb-local-tracker" ] || [ "$project" == "rtfb-global-tracker" ]; then
     deb_dir=target
else
exit 0
fi

full_path=$location/$deb_dir
cd $full_path
echo $full_path
echo "uploading the debian NOW"
build-upload *.deb
