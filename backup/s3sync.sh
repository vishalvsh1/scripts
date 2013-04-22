#!/bin/bash
if test -e /tmp/sync.log
  then
  rm /tmp/sync.log
fi
s3cmd sync --delete-removed /mnt/jenkins_backup s3://inmobi-scm//backup/jenkins_backup/  > /tmp/sync.log

mail -s "Jenkins sync job" vishal.sahasrabuddhe@yahoo.com < /tmp/sync.log
