#!/bin/bash

: ${HADOOP_HOME:=/usr/local/hadoop}

$HADOOP_HOME/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

# start ssh
service ssh start

# start datanode
nohup $HADOOP_HOME/bin/hdfs datanode 2>>$HADOOP_LOG_DIR/datanode.err >>$HADOOP_LOG_DIR/datanode.out &

# start nodemanager
nohup $HADOOP_HOME/bin/yarn nodemanager 2>>$HADOOP_LOG_DIR/nodemanager.err >>$HADOOP_LOG_DIR/nodemanager.out &

if [[ $1 == "-d" ]]; then
	while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
	/bin/bash
fi
