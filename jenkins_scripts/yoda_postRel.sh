#!/bin/bash
Module_version=$1
Project=$2
cd $WORKSPACE/$Project
New_version=`grep version pom.xml | grep SNAPSHOT | cut -d ">" -f2 | cut -d "<" -f1`
Old_version=`grep $Module_version /d0/jenkins/workspace/Yoda_Pom_update/yoda-root/pom.xml |  cut -d ">" -f2 | cut -d "<" -f1`
cd /d0/jenkins/workspace/Yoda_Pom_update/yoda-root
git pull origin master
git checkout master
rm -f new_pom.xml
sed "s/$Old_version/$New_version/g" pom.xml > new_pom.xml
#Updating Self version
old_version=`grep yoda.version  pom.xml  | cut -d ">" -f2 | cut -d "<" -f1 | grep -v yoda`
incr=`echo $old_version | cut -d "." -f3`
new_incr=`expr $incr + 1`
new_version=`echo $old_version | sed -s s/$incr/$new_incr/`
sed "s/$old_version/$new_version/g" new_pom.xml > pom.xml
git add -- pom.xml
git status
git commit --verbose -F /d0/jenkins/scripts/yoda_commit.txt pom.xml
git push origin master
