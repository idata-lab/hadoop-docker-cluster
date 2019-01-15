FROM ubuntu:19.04

LABEL Author="bing.fxx@gmail.com"

# time zone set
ENV TIME_ZONE Asia/Shanghai
RUN echo "${TIME_ZONE}" > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

# install tools
RUN apt-get update
RUN apt-get install -y --no-install-recommends curl tar sudo rsync lsof tzdata vim \
    openssh-server openssh-client \
    inetutils-ping telnet net-tools && \
    rm -rf /var/lib/apt/lists/*

# passwordless ssh
RUN rm -f /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key /root/.ssh/id_rsa && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa && \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys && \
    echo 'Host *' >> /etc/ssh/ssh_config && \
    echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config && \
    echo 'UserKnownHostsFile /dev/null' >> /etc/ssh/ssh_config && \
    echo 'LogLevel quiet' >> /etc/ssh/ssh_config

# copy jdk
COPY jdk /tmp/jdk

# install java
ENV JAVA_HOME /usr/local/java
ENV PATH $PATH:$JAVA_HOME/bin

RUN mkdir -p $JAVA_HOME && \
    tar --strip-components 1 -xzf /tmp/jdk/jdk-*.tar.gz -C $JAVA_HOME

# clean tmp
RUN rm -rf /tmp/*
