#!/bin/bash

: ${HADOOP_HOME:=/usr/local/hadoop}

$HADOOP_HOME/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

# start ssh
service ssh start

# start hdfs namenode
nohup $HADOOP_HOME/bin/hdfs namenode &
# start yarn resourcemanager
nohup $HADOOP_HOME/bin/yarn resourcemanager &
# start yarn timelineserver
nohup $HADOOP_HOME/bin/yarn timelineserver &
# start mapred historyserver
nohup $HADOOP_HOME/bin/mapred historyserver &

if [[ $1 == "-d" ]]; then
	while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
	/bin/bash
fi
