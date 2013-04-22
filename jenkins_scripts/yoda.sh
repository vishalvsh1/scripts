#!/bin/bash
cd /d0/jenkins/workspace/Yoda_Pom_update/
new_version=`grep yoda.version  yoda-root/pom.xml  | cut -d ">" -f2 | cut -d "<" -f1 | grep -v yoda`
incr=`echo $new_version | cut -d "." -f3`
old=`expr $incr - 1`
old_version=`echo $new_version | sed -s s/$incr$/$old/`

for i in `ls | grep -v yoda-root`
do
cd $i
git checkout develop
rm -f new_pom.xml
sed "s/$old_version/$new_version/g" pom.xml > new_pom.xml
mv new_pom.xml pom.xml
git add -- pom.xml
git status
git commit --verbose -F /d0/jenkins/scripts/yoda_commit.txt pom.xml
git symbolic-ref HEAD
git push origin develop
cd ..
done
