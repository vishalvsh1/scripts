#!/bin/bash

Artifact=$1
host=$2
ArtName=`basename $Artifact`

scp -P 2222 $Artifact $host:/opt/deploy/debians/.
#ssh -p 2222 $host "/opt/deploy/deploy.sh $ArtName"
