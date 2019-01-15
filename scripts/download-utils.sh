#!/bin/bash

# download a sigal resource
download_resource() {
	# eg: /home/hadoop/hadoop-base/achives
	local WORK_DIR=$1
	# eg: http://mirrors.shu.edu.cn/apache/hadoop/common/hadoop-3.1.1
	local RESOURCE_URL=$2
	# eg: hadoop-3.1.1.tar.gz
	local RESOURCE_TAR_FILENAME=$3

	if [ ! -f $WORK_DIR/$RESOURCE_TAR_FILENAME ]; then
		wget -P $WORK_DIR $RESOURCE_URL/$RESOURCE_TAR_FILENAME
		if [ $? != 0 ]; then
			rm -f $WORK_DIR/$RESOURCE_TAR_FILENAME
			exit 1
		fi
	fi
}
