#!/bin/bash

set -x
WORKSPACE=$1
Package=$2
Project=$3
type=$4
version_type=-$type
Adnetwork()
{
cd $WORKSPACE
rm -rf Package* InMobi_Android_SDK_* *.jar
mkdir -p Package/libs
mkdir -p Package/Docs
if [ $type == "SNAPSHOT" ]; then
	cp $WORKSPACE/Android-SDK-IMAdNetwork/IMAdNetwork/target/InMobiAdNetwork-*${version_type}.jar Package/libs/.
	cp $WORKSPACE/Android-SDK-IMCommons/IMCommons/target/InMobiCommons-*${version_type}.jar Package/libs/.

	#Javadocs
	cp -r $WORKSPACE/Android-SDK-IMAdNetwork/IMAdNetwork/target/site/apidocs/*  Package/Docs/.

	#Sample app
	cp -r $WORKSPACE/Android-SDK-IMAdNetwork/IMAdNetworkSample Package/.
	#removing target folder from sample app
	rm -rf Package/IMAdNetworkSample/target
	#cp -r Package/libs/* $WORKSPACE/Android-SDK-IMAdNetwork/IMAdNetworkSample/libs/.
	cp -r Package/libs/* Package/IMAdNetworkSample/libs/.

	#Changelog
	cp $WORKSPACE/Android-SDK-IMAdNetwork/IMAdNetwork/ChangeLog.txt Package/.
	sleep 10
	Version=`ls Package/libs/InMobiAdNetwork-*${version_type}.jar | cut -d - -f2`
	mv Package InMobi_Android_SDK_${Version}${version_type}
	zip -r InMobi_Android_SDK_${Version}${version_type}.zip InMobi_Android_SDK_${Version}${version_type}
	/d0/jenkins/tools/Maven/apache-maven-3.0.4/bin/mvn deploy:deploy-file -DgroupId=com.inmobi.androidsdk -DartifactId=InMobi_Android_SDK -Dversion=${Version}-SNAPSHOT -Durl=http://maven.scm.corp.inmobi.com/content/repositories/snapshots/ -DrepositoryId=snapshot -Dfile=InMobi_Android_SDK_${Version}${version_type}.zip
else
	cp $WORKSPACE/Android-SDK-IMAdNetwork/IMAdNetwork/target/InMobiAdNetwork-*[0-9].jar Package/libs/.
	Version=`ls Package/libs/InMobiAdNetwork-*.jar  | cut -d - -f2 | sed  's/.jar//g'`
	wget http://maven.scm.corp.inmobi.com/content/repositories/releases//com/inmobi/commons/InMobiCommons/$Version/InMobiCommons-$Version.jar
	cp InMobiCommons-$Version.jar Package/libs/.
	#Javadocs
        cp -r $WORKSPACE/Android-SDK-IMAdNetwork/IMAdNetwork/target/site/apidocs/*  Package/Docs/.
	#Sample app
        cp -r $WORKSPACE/Android-SDK-IMAdNetwork/IMAdNetworkSample Package/.
        #removing target folder from sample app
        rm -rf Package/IMAdNetworkSample/target
        #cp -r Package/libs/* $WORKSPACE/Android-SDK-IMAdNetwork/IMAdNetworkSample/libs/.
        cp -r Package/libs Package/IMAdNetworkSample
       #Changelog
        cp $WORKSPACE/Android-SDK-IMAdNetwork/IMAdNetwork/ChangeLog.txt Package/.
        sleep 10
	mv Package InMobi_Android_SDK_${Version}
	zip -r InMobi_Android_SDK_${Version}.zip InMobi_Android_SDK_${Version}
  /d0/jenkins/tools/Maven/apache-maven-3.0.4/bin/mvn deploy:deploy-file -DgroupId=com.inmobi.androidsdk -DartifactId=InMobi_Android_SDK -Dversion=${Version} -Durl=http://maven.scm.corp.inmobi.com/content/repositories/releases/ -DrepositoryId=release -Dfile=InMobi_Android_SDK_${Version}.zip
fi
}

Adtracker()
{
cd $WORKSPACE
rm -rf Package* InMobiAdTracker_Android_SDK_* *.jar
mkdir -p Package/libs
mkdir -p Package/Docs
if [ $type == "SNAPSHOT" ]; then
        cp $WORKSPACE/Android-SDK-IMAdTracker/IMAdTracker/target/InMobiAdTracker-*${version_type}.jar Package/libs/.
        cp $WORKSPACE/Android-SDK-IMCommons/IMCommons/target/InMobiCommons-*${version_type}.jar Package/libs/.

        #Javadocs
        cp -r $WORKSPACE/Android-SDK-IMAdTracker/IMAdTracker/target/site/apidocs/*  Package/Docs/.

        #Sample app
        cp -r $WORKSPACE/Android-SDK-IMAdTracker/IMAdTrackerSampleApp Package/.
        #cp -r Package/libs/* $WORKSPACE/Android-SDK-IMAdNetwork/IMAdNetworkSample/libs/.
        cp -r Package/libs Package/IMAdTrackerSampleApp/.

        #Changelog
        cp $WORKSPACE/Android-SDK-IMAdTracker/IMAdTracker/ChangeLog.txt Package/.
        sleep 10
        Version=`ls Package/libs/InMobiAdTracker-*${version_type}.jar | cut -d - -f2`
        mv Package InMobiAdTracker_Android_SDK_${Version}${version_type}
        zip -r InMobiAdTracker_Android_SDK_${Version}${version_type}.zip InMobiAdTracker_Android_SDK_${Version}${version_type}
        /d0/jenkins/tools/Maven/apache-maven-3.0.4/bin/mvn deploy:deploy-file -DgroupId=com.inmobi.adtracker.androidsdk -DartifactId=InMobiAdTracker_Android_SDK -Dversion=${Version}-SNAPSHOT -Durl=http://maven.scm.corp.inmobi.com/content/repositories/snapshots/ -DrepositoryId=snapshot -Dfile=InMobiAdTracker_Android_SDK_${Version}${version_type}.zip
else
        cp $WORKSPACE/Android-SDK-IMAdTracker/IMAdTracker/target/InMobiAdTracker-*[0-9].jar Package/libs/.
        Version=`ls Package/libs/InMobiAdTracker-*.jar  | cut -d - -f2 | sed  's/.jar//g'`
        wget http://maven.scm.corp.inmobi.com/content/repositories/releases//com/inmobi/commons/InMobiCommons/$Version/InMobiCommons-$Version.jar
        cp InMobiCommons-$Version.jar Package/libs/.
        #Javadocs
        cp -r $WORKSPACE/Android-SDK-IMAdTracker/IMAdTracker/target/site/apidocs/*  Package/Docs/.
        #Sample app
        cp -r $WORKSPACE/Android-SDK-IMAdTracker/IMAdTrackerSampleApp Package/.
        #cp -r Package/libs/* $WORKSPACE/Android-SDK-IMAdNetwork/IMAdNetworkSample/libs/.
        cp -r Package/libs Package/IMAdTrackerSampleApp/.
       #Changelog
        cp $WORKSPACE/Android-SDK-IMAdTracker/IMAdTracker/ChangeLog.txt Package/.
        sleep 10
        mv Package InMobiAdTracker_Android_SDK_${Version}
        zip -r InMobiAdTracker_Android_SDK_${Version}.zip InMobiAdTracker_Android_SDK_${Version}
  /d0/jenkins/tools/Maven/apache-maven-3.0.4/bin/mvn deploy:deploy-file -DgroupId=com.inmobi.adtracker.androidsdk -DartifactId=InMobiAdTracker_Android_SDK -Dversion=${Version} -Durl=http://maven.scm.corp.inmobi.com/content/repositories/releases/ -DrepositoryId=release -Dfile=InMobiAdTracker_Android_SDK_${Version}.zip
fi
}

#Adtracker()
#{
#cd $WORKSPACE
#rm -rf Package* InMobiAdTracker_Android_SDK*
#mkdir -p Package/libs
#cp $WORKSPACE/Android-SDK-IMAdTracker/InMobiAdTracker/target/InMobiAdTracker-*SNAPSHOT.jar Package/libs/.
#cp $WORKSPACE/Android-SDK-IMCommons/InMobiCommons/target/InMobiCommons-*SNAPSHOT.jar Package/libs/.
#
##Sample app
#cp -r $WORKSPACE/Android-SDK-IMAdTracker/IMAdTrackerSampleApp Package/.
#
##Changelog
#cp $WORKSPACE/Android-SDK-IMAdTracker/IMAdTracker/ChangeLog.txt Package/.
#sleep 10
#Version=`ls Package/libs/InMobiAdTracker-*SNAPSHOT.jar | cut -d - -f2`
#mv Package InMobiAdTracker_Android_SDK_${Version}
#zip -r InMobiAdTracker_Android_SDK_${Version}.zip InMobiAdTracker_Android_SDK_${Version}
#}

if [ $Package == "Yes" ]; then

  if [ $Project == IMAdNetwork ]; then
    Adnetwork
  elif [ $Project == IMAdTracker ]; then
    Adtracker
  fi

#if [[ $Project == "Android-SDK-IceDataCollector" || $Project == "Android-SDK-IMCommons" ]]; then
#        Adnetwork
#       Adtracker
#elif [[ $Project == "Android-SDK-IMRenderingEngine" || $Project == "Android-SDK-IMAdNetwork" ]]; then
#        Adnetwork
#elif [ $Project == "Android-SDK-IMAdTracker" ]; then
#        Adtracker
#fi

fi


