#!/bin/bash
Workspace=$1
Dir=$2
#commit jar to github Maven
cd $Workspace/$Dir
git config --local user.name inmobijenkins
git config --local user.email scm@inmobi.com
git config --local credential.helper store
git commit --verbose -F /d0/jenkins/scripts/github_commit.txt
git push origin master
