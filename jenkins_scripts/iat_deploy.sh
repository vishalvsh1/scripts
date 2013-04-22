#!/bin/bash
set -x

Project=$1
Debian=$2
Host=$3

if [ $Project == "all" ]; then
  Project_deploy="ui-portal-server ui-admin-server platform-server"
else
  Project_deploy=$Project
fi

if [ $Debian == "all" ]; then
  Debian_deploy="server static"
else
  Debian_deploy=$Debian
fi

for i in `echo $Project_deploy`
do
	#cd $i
	if [ $i == "platform-server" ]; then
	  Debian_deploy="server"
	fi
	for j in `echo $Debian_deploy`
	do
		Debian_name=`ls $i/*.deb | grep $j`
		/d0/jenkins/deploy.sh $i/$Debian_name $Host
	done
done
