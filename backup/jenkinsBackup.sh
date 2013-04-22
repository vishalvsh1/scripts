#!/bin/bash
# Linux bin paths, change this if it can't be autodetected via which command
CHOWN="$(which chown)"
CHMOD="$(which chmod)"
GZIP="$(which gzip)"

# Backup Dest directory, change this if you have someother location
DEST="/mnt/jenkins_backup"

# Main directory where backup will be stored
MBD="$DEST/jenkins"

# Get hostname
HOST="$(hostname)"

# Get data in dd-mm-yyyy format
NOW="$(date +"%d-%m-%Y")"

# File to store current backup file
FILE=""

[ ! -d $MBD ] && mkdir -p $MBD || :

# Only root can access it!
#$CHOWN 0.0 -R $DEST
#$CHMOD 0600 $DEST
FILE="$MBD/jenkins.$HOST.$NOW.tgz"
#taking dump of media directory
tar --exclude=builds --exclude=modules --exclude=workspace --exclude=.* --exclude=identity.key -zcf $FILE /d0/jenkins/

#Removing Old files
for file in "$( find $MBD -type f -mtime +8 )"
do
  /bin/rm -f $file
done

if test -e /tmp/jenkins.temp
then
  rm /tmp/jenkins.temp
fi

#Mail send information
echo "Jenkins backup" > /tmp/jenkins.temp
echo "Date and time:- $NOW" >> /tmp/jenkins.temp
echo "Backup file :- $FILE" >> /tmp/jenkins.temp
echo "List of backup files :-" >> /tmp/jenkins.temp
ls -l $MBD >> /tmp/jenkins.temp
mail -s "Jenkins backup $NOW" vishal.sahasrabuddhe@yahoo.com < /tmp/jenkins.temp

