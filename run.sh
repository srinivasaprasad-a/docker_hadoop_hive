sudo docker network rm -f hadoop-hive-network &> /dev/null
sudo docker network create \
		--driver bridge \
		hadoop-hive-network &> /dev/null

echo "start hadoop-hive container..."
sudo docker rm -f hadoop-hive &> /dev/null
sudo docker run -itd \
		-p 2222:2222 \
		-p 4040:4040 \
		-p 8020:8020 \
		-p 8088:8088 \
		-p 9001:9001 \
                -p 50070:50070 \
		-p 50090:50090 \
		-p 10000:10000 \
		-p 1527:1527 \
		--net=hadoop-hive-network \
                --name hadoop-hive \
                --hostname hadoop-master \
		hadoop_hive:latest &> /dev/null
echo "done."

