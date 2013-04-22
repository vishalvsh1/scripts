#!/bin/bash
# Linux bin paths, change this if it can't be autodetected via which command
CHOWN="$(which chown)"
CHMOD="$(which chmod)"
GZIP="$(which gzip)"

# Backup Dest directory, change this if you have someother location
DEST="/mnt/nexus_backup"

# Main directory where backup will be stored
MBD="$DEST/nexus_part"

# Get hostname
HOST="$(hostname)"

# Get data in dd-mm-yyyy format
NOW="$(date +"%d-%m-%Y")"
D="$(expr `date +%d` - 1)"
NewTime="$(date +"%Y-%m-$D")"

# File to store current backup file
FILE=""

[ ! -d $MBD ] && mkdir -p $MBD || :

# Only root can access it!
#$CHOWN 0.0 -R $DEST
#$CHMOD 0600 $DEST
FILE="$MBD/nexus.$HOST.$NOW.tgz"
#taking dump of media directory
tar --exclude=inmobi-old-release --after-date=${NewTime} -zcf $FILE /d0/sonatype-work/nexus/storage

#Removing Old files
for file in "$( find $MBD -type f -mtime +10 )"
do
  /bin/rm -f $file
done

if test -e /tmp/nexus_part.temp
then
  rm /tmp/nexus_part.temp
fi

#Mail send information
echo "Nexus Partial backup" > /tmp/nexus_part.temp
echo "Date and time:- $NOW" >> /tmp/nexus_part.temp
echo "From the date backup taken :- $NewTime" >> /tmp/nexus_part.temp
echo "Backup file :- $FILE" >> /tmp/nexus_part.temp
echo "List of backup files :-" >> /tmp/nexus_part.temp
ls -l $MBD >> /tmp/nexus_part.temp
mail -s "Nexus Partial backup $NOW" vishal.sahasrabuddhe@yahoo.com < /tmp/nexus_part.temp

