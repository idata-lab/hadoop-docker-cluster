#!/bin/bash
PROGNAME=$(basename $0)
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f $DIR/scripts/download-utils.sh ]; then
	. $DIR/scripts/download-utils.sh
fi

if [ -f $DIR/scripts/docker-utils.sh ]; then
	. $DIR/scripts/docker-utils.sh
fi

# print the usage of this shell
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

if [ $# -eq 0 ]; then
	print_usage
fi

SLAVES_NUM=3

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
		SLAVES_NUM="$2"
		shift 2
		;;
	-*)
		echo "$PROGNAME: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
		exit 1
		;;
	*) ;;
	esac
done

case $1 in
launch)
	launch_cluster $SLAVES_NUM
	;;
destroy)
	destroy_cluster $SLAVES_NUM
	;;
restart)
	restart_cluster $SLAVES_NUM
	;;
stop)
	stop_cluster $SLAVES_NUM
	;;
build)
	build_all_images
	;;
esac

exit 0
