FROM idata-lab/hadoop-runtime:latest

LABEL Author="bing.fxx@gmail.com"

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

# copy hadoop
COPY hadoop/hadoop-*.tar.gz /tmp

# hadoop configuration
RUN mkdir -p $HADOOP_HOME/input $HADOOP_LOG_DIR && \
tar --strip-components 1 -xzf /tmp/hadoop-*.tar.gz -C $HADOOP_HOME && \
cp $HADOOP_HOME/etc/hadoop/*.xml $HADOOP_HOME/input

ADD hadoop/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
ADD hadoop/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
ADD hadoop/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
ADD hadoop/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
ADD hadoop/log4j.properties $HADOOP_HOME/etc/hadoop/log4j.properties

# clean tmp
RUN rm -rf /tmp/*

# format namenode
RUN $HADOOP_HOME/bin/hdfs namenode -format

# set work dir
WORKDIR $HADOOP_HOME

# Hdfs ports
EXPOSE 9000 50010 50020 50070 50075 50090
# See https://issues.apache.org/jira/browse/HDFS-9427
EXPOSE 9871 9870 9820 9869 9868 9867 9866 9865 9864
# Mapred ports
EXPOSE 19888
# Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088 8188
# Other ports
EXPOSE 49707 22
