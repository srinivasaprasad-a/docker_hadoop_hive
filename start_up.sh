#!/bin/bash

: ${HADOOP_PREFIX:=/programs/hadoop}

$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

# start the services
service ssh start
$HADOOP_PREFIX/sbin/start-dfs.sh
$HADOOP_PREFIX/sbin/start-yarn.sh

# derby db data
mkdir $DERBY_HOME/data

# to resolve exception "java.lang.SecurityException: sealing violation" due to duplicate jars in classpath
rm $HIVE_HOME/lib/derby*.jar
cp $DERBY_HOME/lib/derby*.jar $HIVE_HOME/lib

# start derby db
nohup $DERBY_HOME/bin/startNetworkServer -h 0.0.0.0 &

# set up hive directories in hdfs
$HADOOP_HOME/bin/hadoop fs -mkdir /tmp 
$HADOOP_HOME/bin/hadoop fs -mkdir /user
$HADOOP_HOME/bin/hadoop fs -mkdir /user/hive
$HADOOP_HOME/bin/hadoop fs -mkdir /user/hive/warehouse
$HADOOP_HOME/bin/hadoop fs -chmod g+w /tmp 
$HADOOP_HOME/bin/hadoop fs -chmod g+w /user/hive/warehouse

# initialize schema
$HIVE_HOME/bin/schematool -dbType derby -initSchema

# start hive services
nohup $HIVE_HOME/bin/hive &
nohup $HIVE_HOME/bin/hive --service hiveserver2 &

# run bash, so that container doesnt stop after services are started
/bin/bash
