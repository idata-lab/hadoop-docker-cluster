#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f $DIR/../scripts/download-utils.sh ]; then
	. $DIR/../scripts/download-utils.sh
fi

# mkdir first
if [ ! -d $DIR/achives ]; then
	mkdir $DIR/achives
fi

# download hadoop
download_resource $DIR/achives \
		http://mirrors.shu.edu.cn/apache/hadoop/common/hadoop-3.1.1 \
		hadoop-3.1.1.tar.gz

docker build -t idata-lab/hadoop-base:latest $DIR
