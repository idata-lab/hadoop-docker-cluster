#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f $DIR/../scripts/download-utils.sh ]; then
	. $DIR/../scripts/download-utils.sh
fi

# mkdir first
if [ ! -d $DIR/jdk ]; then
	mkdir $DIR/jdk
fi

# download openjdk
download_resource $DIR/jdk \
	https://download.java.net/java/early_access/jdk8/b03/BCL \
	jdk-8u202-ea-bin-b03-linux-x64-07_nov_2018.tar.gz

docker build -t idata-lab/hadoop-runtime:latest $DIR
