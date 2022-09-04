### 说明
#### zookeeper cluster for docker
描述：使用docker运行zookeeper集群服务  
```
# docker network create --driver bridge --subnet 172.19.0.0/16 zkC
# docker-compose -f zookeeper_cluster.yml start
```

#### zookeeper.service
描述：centos system管理zookeeper服务
```
使用说明:
# systemctl start zookeeper
# systemctl stop zookeeper
```