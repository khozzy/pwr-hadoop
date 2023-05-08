# Hadoop playground

## Hadoop Distributed File System (HDFS)

Name-node http://localhost:50070

## Setup HDFS

    docker-compose up

    docker cp data/sales5k.csv namenode:/root

    docker exec namenode hdfs dfs -mkdir -p /db/sales    
    docker exec namenode hdfs dfs -ls /db/sales
    docker exec namenode hdfs dfs -copyFromLocal /root/sales5k.csv /db/sales/
    docker exec namenode hdfs dfs -cat /db/sales/sales5k.csv | head

    dust /tmp/hdfs/*
