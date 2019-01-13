#!/bin/bash

PROGNAME=$(basename $0)
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_usage() {
	echo "Usage: $0 [build|launch|restart|stop|destroy]"
	echo ""
	echo "    launch     : create and start hadoop cluster container on docker"
	echo "    restart  : Restart hadoop cluster container on docker"
	echo "    stop     : Stop hadoop cluster container on docker"
	echo "    destroy  : Kill and remove hadoop cluster container on docker, all data lose!!!"
	echo "    build    : Build docker images with local hadoop binary"
	echo ""
	echo "    Options:"
	echo "        -h,  --help      : Print usage"
	echo "        -s, --slaves : Specify the number of slaves"
	echo ""
}

download_resources() {
	# mkdir first
	if [ ! -d "$DIR/hadoop-base/achives" ]; then
		mkdir -p $DIR/hadoop-base/achives
	fi

	# download hadoop
	if [ ! -f $DIR/hadoop-base/achives/hadoop ]; then
		# rm -f $DIR/hadoop-base/achives/hadoop-3.1.1.tar.gz
		# wget -P $DIR/hadoop-base/achives 'http://mirrors.shu.edu.cn/apache/hadoop/common/hadoop-3.1.1/hadoop-3.1.1.tar.gz'
		# if [ $? != 0 ]; then
		# 	rm -f $DIR/hadoop-base/achives/hadoop-3.1.1.tar.gz
		# fi
		tar -xzf $DIR/hadoop-base/achives/hadoop-3.1.1.tar.gz -C $DIR/hadoop-base/achives
		mv $DIR/hadoop-base/achives/hadoop-3.1.1 $DIR/hadoop-base/achives/hadoop
	fi

	# download openjdk
	if [ ! -f $DIR/hadoop-base/achives/java ]; then
		# rm -f jdk-8u202-ea-bin-b03-linux-x64-07_nov_2018.tar.gz
		# wget -P $DIR/hadoop-base/achives 'https://download.java.net/java/early_access/jdk8/b03/BCL/jdk-8u202-ea-bin-b03-linux-x64-07_nov_2018.tar.gz'

		# if [ $? != 0 ]; then
		# 	rm -f jdk-8u202-ea-bin-b03-linux-x64-07_nov_2018.tar.gz
		# fi

		tar -xzf $DIR/hadoop-base/achives/jdk-8u202-ea-bin-b03-linux-x64-07_nov_2018.tar.gz -C $DIR/hadoop-base/achives
		mv $DIR/hadoop-base/achives/jdk1.8.0_202 $DIR/hadoop-base/achives/java
	fi
}

if [ $# -eq 0 ]; then
	print_usage
fi

DATANODE_NUM=3

for OPT in "$@"; do
	case "$OPT" in
	'-h' | '--help')
		print_usage
		exit 1
		;;
	'-s' | '--slaves')
		if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
			echo "$PROGNAME: option requires an argument -- $1" 1>&2
			exit 1
		fi
		DATANODE_NUM="$2"
		shift 2
		;;
	-*)
		echo "$PROGNAME: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
		exit 1
		;;
	*) ;;
	esac
done

# launch hadoop cluster
launch_cluster() {

	# create network
	if ! docker network inspect hadoop-cluster-network >/dev/null; then
		echo "Creating docker network hadoop-cluster-network"
		docker network create --driver bridge --subnet=172.22.0.0/16 hadoop-cluster-network
	fi

	# start hadoop master server
	echo "Launching hadoop master server"
	docker run -d \
		-p 9870:9870 -p 8088:8088 -p 19888:19888 -p 8188:8188 \
		--net hadoop-cluster-network \
		--name hadoop-cluster-master \
		--hostname hadoop-cluster-master \
		idata-lab/hadoop-master:latest

	# start hadoop slave server
	echo "Launching hadoop slave servers"
	for i in $(seq 1 $DATANODE_NUM); do
		docker run -d \
			-p 990${i}:9864 -p 804${i}:8042 \
			--name hadoop-cluster-slave${i} \
			--hostname hadoop-cluster-slave${i} \
			--net hadoop-cluster-network \
			idata-lab/hadoop-slave:latest
	done
}

# stop cluster
restart_cluster() {
	docker start hadoop-cluster-master
	for i in $(seq 1 $DATANODE_NUM); do
		docker start hadoop-cluster-slave${i}
	done
}

# destroy hadoop cluster
destroy_cluster() {
	docker kill hadoop-cluster-master
	docker rm hadoop-cluster-master
	for i in $(seq 1 $DATANODE_NUM); do
		docker kill hadoop-cluster-slave${i}
		docker rm hadoop-cluster-slave${i}
	done
	docker network rm hadoop-cluster-network
}

# stop cluster
stop_cluster() {
	docker kill hadoop-cluster-master
	for i in $(seq 1 $DATANODE_NUM); do
		docker kill hadoop-cluster-slave${i}
	done
}

# build images
build_images() {
	# prepare resources
	download_resources

	if [ $? != 0 ]; then
		echo 'build stopped due to download resources failed'
		exit 1
	fi

	cd $DIR/hadoop-base
	docker build -t idata-lab/hadoop-base:latest .
	cd $DIR/hadoop-master
	docker build -t idata-lab/hadoop-master:latest .
	cd $DIR/hadoop-slave
	docker build -t idata-lab/hadoop-slave:latest .
}

case $1 in
launch)
	launch_cluster
	;;
destroy)
	destroy_cluster
	;;
restart)
	restart_cluster
	;;
stop)
	stop_cluster
	;;
build)
	build_images
	;;
esac

exit 0
