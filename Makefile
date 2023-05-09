DOCKER_NETWORK = net_pwr
ENV_FILE = hadoop.env
IMG = bde2020/hadoop-base:2.0.0-hadoop3.2.1-java8

build_img:
	# docker network create -d bridge net_pwr
	docker build -t ${IMG} ./base

data_upload:
	docker cp data/sales5k.csv namenode:/root
	docker exec namenode hdfs dfs -mkdir -p /db/sales
	docker exec namenode hdfs dfs -copyFromLocal /root/sales5k.csv /db/sales/
	docker exec namenode hdfs dfs -cat /db/sales/sales5k.csv | head

wordcount:
	docker build -t hadoop-wordcount ./submit
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} $(IMG) hdfs dfs -mkdir -p /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} $(IMG) hdfs dfs -copyFromLocal -f /opt/hadoop-3.2.1/README.txt /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} $(IMG) hdfs dfs -cat /output/*
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} $(IMG) hdfs dfs -rm -r /output
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} $(IMG) hdfs dfs -rm -r /input
