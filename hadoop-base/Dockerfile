FROM ubuntu:19.04

LABEL Author="bing.fxx@gmail.com"

USER root

# install dev tools
ENV  TIME_ZONE Asia/Shanghai

RUN apt-get update && \
apt-get install -y curl tar sudo openssh-server openssh-client rsync lsof tzdata \
inetutils-ping \
telnet \
net-tools && \
echo "${TIME_ZONE}" > /etc/timezone && \ 
ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

# passwordless ssh
RUN rm -f /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key /root/.ssh/id_rsa && \
ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && \
ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa && \
cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# copy achives
COPY achives /tmp

# java
ENV JAVA_HOME /usr/java
ENV PATH $PATH:$JAVA_HOME/bin

RUN mkdir -p $JAVA_HOME && \
tar --strip-components 1 -xzf /tmp/jdk-* -C $JAVA_HOME

# hadoop
ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_COMMON_HOME /usr/local/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop
ENV HADOOP_MAPRED_HOME /usr/local/hadoop
ENV HADOOP_YARN_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV YARN_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV HADOOP_LOG_DIR /var/log/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin

# hadoop configuration
# backup first
RUN mkdir -p $HADOOP_HOME/input $HADOOP_LOG_DIR && \
tar --strip-components 1 -xzf /tmp/hadoop-* -C $HADOOP_HOME && \
cp $HADOOP_HOME/etc/hadoop/*.xml $HADOOP_HOME/input

ADD core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
ADD hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
ADD mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
ADD yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
ADD log4j.properties $HADOOP_HOME/etc/hadoop/log4j.properties
# format namenode
RUN $HADOOP_HOME/bin/hdfs namenode -format

# ssh
ADD ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config

# fix the 254 error code
RUN sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config && \
echo "UsePAM no" >> /etc/ssh/sshd_config && \
echo "Port 2122" >> /etc/ssh/sshd_config

# do some clean 
RUN rm -rf /tmp/*.tar.gz && \
apt-get clean && \
apt-get autoremove

# set work dir
WORKDIR /usr/local

# Hdfs ports
EXPOSE 9000 50010 50020 50070 50075 50090
# See https://issues.apache.org/jira/browse/HDFS-9427
EXPOSE 9871 9870 9820 9869 9868 9867 9866 9865 9864
# Mapred ports
EXPOSE 19888
# Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088 8188
# Other ports
EXPOSE 49707 2122
