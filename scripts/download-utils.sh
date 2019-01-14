#!/bin/bash

# download a sigal resource
download_resource() {
	# eg: /home/hadoop/hadoop-base/achives
	local work_dir=$1
	# eg: http://mirrors.shu.edu.cn/apache/hadoop/common/hadoop-3.1.1
	local resource_url=$2
	# eg: hadoop-3.1.1.tar.gz
	local resource_tar_filename=$3

	if [ ! -f $work_dir/$resource_tar_filename ]; then
		wget -P $work_dir $resource_url/$resource_tar_filename
		if [ $? != 0 ]; then
			rm -f $work_dir/$resource_tar_filename
			exit 1
		fi
	fi
}