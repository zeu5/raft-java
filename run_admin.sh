#!/usr/bin/env bash

EXAMPLE_TAR=raft-java-example.tar
ROOT_DIR=./.env
mkdir -p $ROOT_DIR
cd $ROOT_DIR

if [ -d admin ]; then rm -Rf admin; fi

mkdir admin
cd admin
cp -f ./raft-java-admin/build/distributions/$EXAMPLE_TAR .
tar --strip-components=1 -xvf $EXAMPLE_TAR
cp -f ./raft-java-admin/build/libs/raft-java-example.jar ./lib/

#begin adapt cygwin/mingw 
UNAME_STR=$(uname -a)
CURRENT_SYS=${var:0:5}
var=$(uname -a)
CURRENT_SYS=${var:0:5}
if [ $CURRENT_SYS == "MINGW" ]; then
	echo "--current system is mingw--"
elif [ $CURRENT_SYS == "CYGWI" ]; then
	echo "--current system is cygwin--"
fi
#end adapt cygwin/mingw

JMX_PORT=18101
GC_LOG=./logs/gc.log
#jvm config
JAVA_BASE_OPTS=" -Djava.awt.headless=true -Dfile.encoding=UTF-8 "

#JAVA_JMX_OPTS=" -Dcom.sun.management.jmxremote \
#-Dcom.sun.management.jmxremote.port=$JMX_PORT \
#-Dcom.sun.management.jmxremote.ssl=false \
#-Dcom.sun.management.jmxremote.authenticate=false "
JAVA_JMX_OPTS=""

JAVA_MEM_OPTS=" -server -Xms2g -Xmx2g -Xmn600m -XX:PermSize=128m \
-XX:MaxPermSize=128m -Xss256K \
-XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled \
-XX:+UseCMSCompactAtFullCollection -XX:LargePageSizeInBytes=128m \
-XX:+UseFastAccessorMethods -XX:+UseCMSInitiatingOccupancyOnly \
-XX:CMSInitiatingOccupancyFraction=70 "

JAVA_GC_OPTS=" -verbose:gc -Xloggc:$GC_LOG \
-XX:+PrintGCDetails -XX:+PrintGCDateStamps "

if [ $CURRENT_SYS == "MINGW" ] || [ $CURRENT_SYS == "CYGWI" ]; then
	JAVA_CP=" -cp conf;lib/* "
else
	JAVA_CP=" -cp conf:lib/* "
fi

JAVA_OPTS=" $JAVA_BASE_OPTS $JAVA_MEM_OPTS $JAVA_JMX_OPTS $JAVA_GC_OPTS $JAVA_CP"

RUNJAVA="$JAVA_HOME/bin/java"
MAIN_CLASS=com.github.wenweihu86.raft.admin.AdminMain
$CLUSTER="127.0.0.1:8051,127.0.0.1:8052,127.0.0.1:8053"

$RUNJAVA $JAVA_CP $MAIN_CLASS $CLUSTER conf get

$RUNJAVA $JAVA_CP $MAIN_CLASS $CLUSTER conf add "127.0.0.1:8054:4,127.0.0.1:8055:5"

$RUNJAVA $JAVA_CP $MAIN_CLASS $CLUSTER conf del "127.0.0.1:8054:4,127.0.0.1:8055:5"
