#!/bin/bash
cd $1
if [ x$2 == "xiam-auth-client" ]; then
Dir="java"
cd $Dir
elif [ x$2 == "xidm-ui" ]; then
Dir="dynamic"
cd $Dir
fi
mvn release:rollback
