#!/bin/bash

set -x

PomFile=$1/pom.xml
RepoID=$2
cd $1
FileName=`ls *.jar`
/d0/jenkins/tools/Maven/apache-maven-3.0.4/bin/mvn deploy:deploy-file -DpomFile=$PomFile -Dfile=$1/$FileName -DrepositoryId=$RepoID -Durl=http://maven.scm.corp.inmobi.com/content/repositories/${RepoID}s/
#mvn deploy:deploy-file -DgroupId=$gid -DartifactId=InMobiAdNetwork -Dversion=${RELEASE_VERSION}-SNAPSHOT -Durl=http://maven.scm.corp.inmobi.com/content/repositories/snapshots/ -DrepositoryId=snapshot -Dfile=target/InMobiAdNetwork-${RELEASE_VERSION}-SNAPSHOT.jar
