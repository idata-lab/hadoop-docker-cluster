#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# create network
create_network() {
	if ! docker network inspect hadoop-cluster-network >/dev/null; then
		echo "Creating docker network hadoop-cluster-network"
		docker network create --driver bridge --subnet=172.4.0.0/16 hadoop-cluster-network
	fi
}

# launch hadoop master
launch_hadoop() {
	echo "Launching hadoop master"
	docker run -d \
		-p 9870:9870 -p 8088:8088 -p 19888:19888 -p 8188:8188 \
		--net hadoop-cluster-network \
		--name hadoop-cluster-master \
		--hostname hadoop-cluster-master \
		idata-lab/hadoop-master:latest

	echo "Launching hadoop slaves"
	for i in $(seq 1 $1); do
		docker run -d \
			-p 990${i}:9864 -p 804${i}:8042 \
			--name hadoop-cluster-slave${i} \
			--hostname hadoop-cluster-slave${i} \
			--net hadoop-cluster-network \
			idata-lab/hadoop-slave:latest
	done
}

# build all images
build_all_images() {
	chmod a+x $DIR/../**/build.sh

	# hadoop runtime
	$DIR/../hadoop-runtime/build.sh

	# hadoop base
	$DIR/../hadoop-base/build.sh

	# hadoop master
	$DIR/../hadoop-master/build.sh

	# hadoop slave
	$DIR/../hadoop-slave/build.sh
}

# launch hadoop cluster
launch_cluster() {
	# create network
	create_network

	# launch hadoop
	launch_hadoop $1
}

# restart cluster
restart_cluster() {
	# restart hadoop
	docker start hadoop-cluster-master
	for i in $(seq 1 $1); do
		docker start hadoop-cluster-slave${i}
	done
}

# destroy hadoop cluster
destroy_cluster() {
	# destroy hadoop
	docker kill hadoop-cluster-master >/dev/null
	docker rm hadoop-cluster-master
	for i in $(seq 1 $1); do
		docker kill hadoop-cluster-slave${i} >/dev/null
		docker rm hadoop-cluster-slave${i}
	done

	# remove network
	docker network rm hadoop-cluster-network
}

# stop cluster
stop_cluster() {
	# stop hadoop
	docker kill hadoop-cluster-master
	for i in $(seq 1 $1); do
		docker kill hadoop-cluster-slave${i}
	done
}
