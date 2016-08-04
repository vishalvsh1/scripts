#!/bin/bash -x
#
#    NAME
#      gitlab_backup.sh
#
#    DESCRIPTION
#      Script to create Gitlab Backup
#
#    Maintainer
#    Vishal Sahasrabuddhe	

#error check and exit
set -e

echo "-------------Backup Started-------------"

#setting up variables
Backup_Dir=/backup/gitlab/backups
Current=`date +%F`
Year=`date +%Y`
Month=`date +%m`
Date=`date +%d`
Hour=`date +%H`
echo "Backing up the Data Directory"

#gitlab-backup
echo "Initiating backup task ..."
#make sure you point to right path of gitlab-rake
/opt/gitlab/bin/gitlab-rake gitlab:backup:create PATH=/usr/bin:/opt/gitlab/embedded/bin:/usr/local/bin:/bin
echo "done"


#fetch the tar name for upload
cd $Backup_Dir
BACKUP_FILENAME=`ls -ltr | tail -1 | awk '{print $9}'`
if [ -z $BACKUP_FILENAME ];
	then
	echo "No Backup file available here; Exiting!!"
	exit 1
else
	echo "Backup file name: $BACKUP_FILENAME"
fi


#upload backup to S3 or anywhere you want
echo "Initiating S3 Upload task ..."
echo "Uploading backup Files to s3://gitlab-backup/"

aws s3 cp "$BACKUP_FILENAME" s3://gitlab-backup/$Year/$Month/$Date/$Hour/
echo "Backup done"

echo "removing older backups"
find -type f -mtime +5 -exec rm -f {} \;
pwd
echo "--------------Backup Finished-------------"
