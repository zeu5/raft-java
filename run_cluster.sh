#!/usr/bin/env bash

EXAMPLE_TAR=raft-java-example.tar
ROOT_DIR=./.env
if [ -d "$ROOT_DIR" ]; then rm -Rf $ROOT_DIR; fi
mkdir -p $ROOT_DIR
cd $ROOT_DIR

mkdir example1
cd example1
cp -f ../../raft-java-example/build/distributions/$EXAMPLE_TAR .
tar --strip-components=1 -xvf $EXAMPLE_TAR
chmod +x ./bin/*.sh
nohup ./bin/run_server.sh ./data "127.0.0.1:8051:1,127.0.0.1:8052:2,127.0.0.1:8053:3" "127.0.0.1:8051:1" &
cd -

mkdir example2
cd example2
cp -f ../../raft-java-example/build/distributions/$EXAMPLE_TAR .
tar --strip-components=1 -xvf $EXAMPLE_TAR
chmod +x ./bin/*.sh
nohup ./bin/run_server.sh ./data "127.0.0.1:8051:1,127.0.0.1:8052:2,127.0.0.1:8053:3" "127.0.0.1:8052:2" &
cd -

mkdir example3
cd example3
cp -f ../../raft-java-example/build/distributions/$EXAMPLE_TAR .
tar --strip-components=1 -xvf $EXAMPLE_TAR
chmod +x ./bin/*.sh
nohup ./bin/run_server.sh ./data "127.0.0.1:8051:1,127.0.0.1:8052:2,127.0.0.1:8053:3" "127.0.0.1:8053:3" &
cd -

mkdir client
cd client
cp -f ../../raft-java-example/build/distributions/$EXAMPLE_TAR .
tar --strip-components=1 -xvf $EXAMPLE_TAR
chmod +x ./bin/*.sh
cd -
