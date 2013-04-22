#!/bin/sh
set -x
exitOnError()
{
    exit_status=$1
    if [ $exit_status -gt 0 ];
    then
        echo "ERROR:: Exiting due to previous error"
        exit $exit_status;
    fi
}

PROJECT_REPO_URL=$1
BRANCH_MERGE_INTO=$2
BRANCH_MERGE_FROM=$3
DIRECTORY_TO_MERGE=$4

echo "Testing if we can auto-merge branch *$BRANCH_MERGE_FROM* into *$BRANCH_MERGE_INTO* for project repo($PROJECT_REPO_URL)"
tmp_dir=`mktemp -u`
echo "******************************************* Git Clone log start ********************************************"
echo "Cloning $PROJECT_REPO_URL  to dir $tmp_dir"
git clone --quiet $PROJECT_REPO_URL $tmp_dir
exitOnError $?

###Checkout both the branches
cd $tmp_dir
git checkout --quiet $BRANCH_MERGE_FROM
exitOnError $?
git checkout --quiet $BRANCH_MERGE_INTO
exitOnError $?
git checkout --quiet $BRANCH_MERGE_FROM $DIRECTORY_TO_MERGE
exitOnError $?
echo "******************************************* Git Clone log end ********************************************"


#Start merging
echo "********************************************* Git Merge Log Start **********************************************"
git add -A
git commit -a -m "Automated merging from jenkins during release from $BRANCH_MERGE_FROM to $BRANCH_MERGE_INTO for directory DIRECTORY_TO_MERGE"
auto_merge=$?
exitOnError $auto_merge
echo "********************************************* Git Merge Log End ************************************************"


if [ $auto_merge -eq 0 ];
then
    echo "Auto merge possible? YES"
    echo "Proceeding with pushing merged changes to branch *$BRANCH_MERGE_INTO/$DIRECTORY_TO_MERGE"
else
    echo "Auto merge is NOT possible. Manual merge required, not prceeding any further."
    exit $auto_merge
fi

echo "********************************************* Git Push log start **********************************************"
echo "Pushing merged branch *$BRANCH_MERGE_INTO* to it's remote repo"
git push origin $BRANCH_MERGE_INTO
final_status=$?
exitOnError $final_status
echo "********************************************* Git Push log end **********************************************"

echo "Merge and push successful (Exit code):  $final_status"

##Deleting temp dirs
rm -rf $tmp_dir
