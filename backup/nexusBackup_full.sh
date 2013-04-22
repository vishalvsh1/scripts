#!/bin/bash
# Linux bin paths, change this if it can't be autodetected via which command
CHOWN="$(which chown)"
CHMOD="$(which chmod)"
GZIP="$(which gzip)"

# Backup Dest directory, change this if you have someother location
DEST="/mnt/nexus_backup"

# Main directory where backup will be stored
MBD="$DEST/nexus_full"

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
#Release backup
for i in `ls /d0/sonatype-work/nexus/storage/releases | grep -v archetype-catalog.xml`
do
  for j in `ls /d0/sonatype-work/nexus/storage/releases/$i`
  do
    if [ $i == "com" ]; then
      for k in `ls /d0/sonatype-work/nexus/storage/releases/$i/$j/$k`
      do
        mkdir -p $MBD/releases/$i/$j/$k
        FILE="$MBD/releases/$i/$j/$k/nexus.releases.$i.$j.$k.$HOST.$NOW.tgz"
        tar -zcf $FILE /d0/sonatype-work/nexus/storage/releases/$i/$j/$k
      done
    else
      mkdir -p $MBD/releases/$i/$j
      FILE="$MBD/releases/$i/$j/nexus.releases.$i.$j.$HOST.$NOW.tgz"
#  tar --exclude=logs --exclude=inmobi-old-release --exclude=snapshots --exclude=indexer --exclude=timeline -zcf $FILE /d0/sonatype-work/nexus/
      tar -zcf $FILE /d0/sonatype-work/nexus/storage/releases/$i/$j
#  Snapshot="$MBD/nexus_snapshot.$HOST.$NOW.tgz"
#  tar -zcf $Snapshot /d0/sonatype-work/nexus/storage/snapshots
    fi
  done
done

#Snapshot backup
for i in `ls /d0/sonatype-work/nexus/storage/snapshots | grep -v archetype-catalog.xml`
do
  for j in `ls /d0/sonatype-work/nexus/storage/snapshots/$i`
  do
    if [ $i == "com" ]; then
      for k in `ls /d0/sonatype-work/nexus/storage/snapshots/$i/$j/$k`
      do
        mkdir -p $MBD/snapshots/$i/$j/$k
        FILE="$MBD/snapshots/$i/$j/$k/nexus.snapshots.$i.$j.$k.$HOST.$NOW.tgz"
        tar -zcf $FILE /d0/sonatype-work/nexus/storage/snapshots/$i/$j/$k
      done
    else
      mkdir -p $MBD/snapshots/$i/$j
      FILE="$MBD/snapshots/$i/$j/nexus.snapshots.$i.$j.$HOST.$NOW.tgz"
#  tar --exclude=logs --exclude=inmobi-old-release --exclude=snapshots --exclude=indexer --exclude=timeline -zcf $FILE /d0/sonatype-work/nexus/
      tar -zcf $FILE /d0/sonatype-work/nexus/storage/snapshots/$i/$j
#  Snapshot="$MBD/nexus_snapshot.$HOST.$NOW.tgz"
#  tar -zcf $Snapshot /d0/sonatype-work/nexus/storage/snapshots
    fi
  done
done

#Other public and 3rd party backup
for i in `ls /d0/sonatype-work/nexus/storage`
do
  if [ $i != "snapshots" ] && [ $i != "releases" ]; then
    mkdir -p $MBD/storage/$i
    FILE="$MBD/storage/$i/nexus.storage.$i.$HOST.$NOW.tgz"
    tar -zcf $FILE /d0/sonatype-work/nexus/storage/$i
  fi
done

#Removing Old files
for file in "$( find $MBD/releases -type f -mtime +10)"
do
  /bin/rm -f $file
done

for file in "$( find $MBD/snapshots -type f -mtime +10)"
do
  /bin/rm -f $file
done

for file in "$( find $MBD/storage -type f -mtime +10)"
do
  /bin/rm -f $file
done

if test -e /tmp/nexus.temp
then
  rm /tmp/nexus.temp
fi

#Mail send information
echo "Nexus backup" > /tmp/nexus.temp
echo "Date and time:- $NOW" >> /tmp/nexus.temp
echo "Backup file :- $FILE" >> /tmp/nexus.temp
echo "List of backup files :-" >> /tmp/nexus.temp
ls -l $MBD >> /tmp/nexus.temp
mail -s "Nexus Full backup $NOW" vishal.sahasrabuddhe@yahoo.com < /tmp/nexus.temp

