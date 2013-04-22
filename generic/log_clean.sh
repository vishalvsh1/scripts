#!/bin/bash

cd /d0/sonatype-work/nexus/logs
for file in "$( find nexus.log.* -type f -mtime +10 | grep -v gz )"
do
 gzip $file
done

