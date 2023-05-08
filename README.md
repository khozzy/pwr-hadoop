# Hadoop Playground

## URLs

### HDFS
- Namenode ([http://localhost:9870](http://localhost:9870))

### YARN
- Resource Manager ([http://localhost:8088](http://localhost:8088))
- Single node Manager ([http://localhost:8042/node/](http://localhost:8042/node/))

## Hadoop Distributed File System (HDFS)

## Setup HDFS

    docker-compose up

    docker cp data/sales5k.csv namenode:/root

    docker exec namenode hdfs dfs -mkdir -p /db/sales
    docker exec namenode hdfs dfs -ls /db/sales
    docker exec namenode hdfs dfs -copyFromLocal /root/sales5k.csv /db/sales/
    docker exec namenode hdfs dfs -cat /db/sales/sales5k.csv | head
