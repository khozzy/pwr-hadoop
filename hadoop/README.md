# PWr Hadoop Sandbox
All examples are using Hadoop 3.2.1 version.

In this example we will be based on Shakespeare Sonnets data.
```bash
wget -q -O data/shakespeare.txt https://raw.githubusercontent.com/brunoklein99/deep-learning-notes/master/shakespeare.txt
```
    

## Infrastructure URLs

All Docker containers communicate within own network, you can create it by typing:
```bash
docker network create -d bridge net_pwr
```

## Exercise 1: Hadoop Distributed File System (HDFS) 

1. Start the _Namenode_ and one _Datanode_ containers.
   ```bash
   docker-compose up -d namenode datanode_1
   ```    

2. Visit HDFS Namenode homepage ([http://localhost:9870](http://localhost:9870))
3. Create basic directory layout

   ```bash
   docker exec namenode sh -c "hdfs dfs -mkdir -p /pwr/wc/input"
   docker exec namenode sh -c "hdfs dfs -mkdir -p /pwr/poems/input"
   ```
 
4. Move files to HDFS

   ```bash
   docker cp data/ namenode:/root/data
   docker exec namenode sh -c "hdfs dfs -copyFromLocal /root/data/input* /pwr/wc/input/"
   docker exec namenode sh -c "hdfs dfs -copyFromLocal /root/data/shakespeare.txt /pwr/poems/input/"
   ```

5. List and inspect files

   ```bash
   docker exec namenode sh -c "hdfs dfs -ls /pwr/"
   docker exec namenode sh -c "hdfs dfs -cat /pwr/poems/input/shakespeare.txt | head"
   ```

6. Inspect Docker container volumes 

   ```bash
   docker exec datanode_1 sh -c "ls /hadoop/dfs/data"
   ```

## Exercise 2: Start YARN application manager stack
1. Run whole infrastructure.

   ```bash
   docker-compose up -d resourcemanager
   docker-compose up -d nodemanager_1
   docker-compose up -d historyserver
   ```    

The command will run the HDFS infrastructure from previous exercise alongside with YARN components:

- **Resource Manager** (_Managing cluster resources and allocating them to different applications based on their requirements. It schedules and monitors the progress of applications, manages resource requests and allocations, and maintains a global view of cluster resources_),
- 1x **Node Manager** (⭐️) (_Managing resources on a single node in the cluster. It launches and monitors application containers, reports resource utilization to the ResourceManager, and manages the application's lifecycle on the node._)
- **History Server**

2. Inspect YARN Resource Manager homepage ([http://localhost:8088](http://localhost:8088))
3. Inspect YARN Node Manager homepage ([http://localhost:8042/node/](http://localhost:8042/node/))
4. Inspect YARN History Server homepage ([http://localhost:8188](http://localhost:8188))

## Exercise 3: Execute WordCount MapReduce job
Ensure that Java compiler is running JDK8.

```bash
echo $JAVA_HOME
export HADOOP_CLASSPATH=$JAVA_HOME/lib/tools.jar
```

1. Compile `WordCount` job
```bash
cd jobs
hadoop-3.2.1/bin/hadoop com.sun.tools.javac.Main WordCount.java
jar cf wc.jar WordCount*.class
```

2. Submit the job to Hadoop cluster

```bash
docker run \
  --rm \
  --network net_pwr \
  --env-file hadoop.env \
  -v $(pwd)/jobs:/jobs \
  bde2020/hadoop-base:2.0.0-hadoop3.2.1-java8 \
  "hadoop jar /jobs/wc.jar WordCount /pwr/wc/input /pwr/wc/output"
```

3. Inspect results
```bash
docker exec namenode sh -c "hdfs dfs -ls /pwr/wc/output"
docker exec namenode sh -c "hdfs dfs -cat /pwr/wc/output/part-r-00000"
```

4. Repeat exercise for the `poems/` directory

```bash
docker run \
  --rm \
  --network net_pwr \
  --env-file hadoop.env \
  -v $(pwd)/jobs:/jobs \
  bde2020/hadoop-base:2.0.0-hadoop3.2.1-java8 \
  "hadoop jar /jobs/wc.jar WordCount /pwr/poems/input /pwr/poems/output"
```

## Exercise 4: Data Warehousing with Hive
TBD