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


    docker exec namenode hdfs dfs -ls /db/sales
    
    docker exec namenode hdfs dfs -cat /app-logs/root/logs-tfile/application_1683553520089_0004/7515db599cea_38477

## MapReduce with Pydoop

    docker run --rm --network net_pwr --env-file hadoop.env -v $(pwd)/jobs:/jobs hadoop/pydoop "ls -l /jobs"
    docker run --rm --network net_pwr --env-file hadoop.env -v $(pwd)/jobs:/jobs hadoop/pydoop "hadoop jar /opt/hadoop-3.2.1/share/hadoop/tools/lib/hadoop-streaming-3.2.1.jar -mapper /jobs/wordcount.py -reducer /jobs/wordcount.py -file /jobs/wordcount.py"


