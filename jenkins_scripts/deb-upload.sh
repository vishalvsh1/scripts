#!/bin/bash

location=$1
project=$2
deb_dir=""

if [ "$project" == "warlock" ]; then
     deb_dir=segmentation-engine-mq
elif [ "$project" == "magneto" ]; then
     deb_dir=actions-server-web
elif [ "$project" == "professorx" ]; then
     deb_dir=events-handler-mq
elif [ "$project" == "storm" ]; then
     deb_dir=events-server-web
elif [ "$project" == "shadowcat" ]; then
     deb_dir=provisioning-thrift
elif [ "$project" == "cyclops" ]; then
     deb_dir=reporting-web
else
exit 0
fi

full_path=$location/$deb_dir/target
cd $full_path
echo $full_path
echo "uploading the debian NOW"
build-upload *.deb
