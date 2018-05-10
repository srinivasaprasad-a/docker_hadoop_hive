FROM hadoop_ubuntu:latest
MAINTAINER SrinivasaPrasadA

USER root

WORKDIR /programs/
RUN pwd

ENV HIVE_VERSION 2.2.0

RUN wget http://www-us.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz 
RUN gunzip /programs/apache-hive-$HIVE_VERSION-bin.tar.gz && \
    tar xf /programs/apache-hive-$HIVE_VERSION-bin.tar && \
    mv /programs/apache-hive-$HIVE_VERSION-bin /programs/hive && \
    rm /programs/apache-hive-$HIVE_VERSION-bin.tar

ENV DERBY_VERSION 10.13.1.1

RUN wget http://archive.apache.org/dist/db/derby/db-derby-$DERBY_VERSION/db-derby-$DERBY_VERSION-bin.tar.gz
RUN gunzip /programs/db-derby-$DERBY_VERSION-bin.tar.gz && \
    tar xf /programs/db-derby-$DERBY_VERSION-bin.tar && \
    mv /programs/db-derby-$DERBY_VERSION-bin /programs/derby && \
    rm /programs/db-derby-$DERBY_VERSION-bin.tar

ENV HIVE_HOME=/programs/hive
ENV PATH $PATH:$HIVE_HOME/bin

ENV DERBY_HOME=/programs/derby
ENV PATH $PATH:$DERBY_HOME/bin

ENV CLASSPATH $CLASSPATH:$HADOOP_HOME/lib/*:.
ENV CLASSPATH $CLASSPATH:$HIVE_HOME/lib/*:.

ADD hive-env.sh $HIVE_HOME/conf
ADD hive-site.xml $HIVE_HOME/conf
ADD jpox.properties $HIVE_HOME/conf

RUN $HADOOP_PREFIX/bin/hdfs namenode -format

ADD start_up.sh /etc/start_up.sh
RUN chown root:root /etc/start_up.sh && \
    chmod 700 /etc/start_up.sh

CMD ["/etc/start_up.sh", "-d"]
