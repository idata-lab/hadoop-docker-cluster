# hadoop-docker-cluster

Hadoop docker cluster for bigdata developer.

## Supported Version
Hadoop: 3.1.1  
OpenJdk: 1.8.0_202

## Usage
### Step 1: Prepare JDK and hadoop
Download [hadoop-3.1.1.tar.gz](http://mirrors.shu.edu.cn/apache/hadoop/common/hadoop-3.1.1/hadoop-3.1.1.tar.gz) and [jdk-8u202-ea-bin-b03-linux-x64-07_nov_2018.tar.gz](https://download.java.net/java/early_access/jdk8/b03/BCL/jdk-8u202-ea-bin-b03-linux-x64-07_nov_2018.tar.gz) , then put them into folder `hadoop-base/achives`

### Step 2: Build images
```bash
./hadoop-docker-cluster.sh build
```

### Step 3: Cluster start
- Use `launch` to create and start containers
```bash
./hadoop-docker-cluster.sh launch
```
- Use `restart` to start exist containers
```
./hadoop-docker-cluster.sh restart
```

### Step 4: Cluster login 

- login into hadoop master
```bash
docker exec -it hadoop-cluster-master bash
```

- login into hadoop slave 1
```bash
docker exec -it hadoop-cluster-slave1 bash
```

### Step 5: Cluster stop
- Use `destory` to remove the container
```bash
./hadoop-docker-cluster.sh destory
```
- Use `stop` to kill the container
```bash
./hadoop-docker-cluster.sh stop
```

## Urls
- Hadoop info of nodemaster.
http://172.22.0.2:8088/cluster

- DFS Health of nodemaster.
http://172.22.0.2:9870

## License
MIT