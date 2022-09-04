#!/usr/bin/env bash
. /etc/rc.d/init.d/functions
BASEDIR="/usr/local/mongodb"
MONGOD="/usr/local/mongodb/bin/mongod"
MONGOS="/usr/local/mongodb/bin/mongos"
config_configfile="/usr/local/mongodb/conf/config.conf"
shard1_configfile="/usr/local/mongodb/conf/shard1.conf"
shard2_configfile="/usr/local/mongodb/conf/shard2.conf"
shard3_configfile="/usr/local/mongodb/conf/shard3.conf"
mongos_configfile="/usr/local/mongodb/conf/mongos.conf"

if [ $# -ne 1 ];then
    echo "Usage: mongo start|stop"
    exit 1
fi

start_config(){
    ${MONGOD} -f ${config_configfile}
    if [ $? -eq 0 ];then
        action "config_server start is ok!" /bin/true
    else
        action "config_server stop is fail!" /bin/false
    fi
} 

start_shard1(){
    ${MONGOD} -f ${shard1_configfile}
    if [ $? -eq 0 ];then
        action "shard1_server start is ok!" /bin/true
    else
        action "shard1_server stop is fail!" /bin/false
    fi
}

start_shard2(){
    ${MONGOD} -f ${shard2_configfile}
    if [ $? -eq 0 ];then
        action "shard2_server start is ok!" /bin/true
    else
        action "shard2_server stop is fail!" /bin/false
    fi
}

start_shard3(){
    ${MONGOD} -f ${shard3_configfile}
    if [ $? -eq 0 ];then
        action "shard3_server start is ok!" /bin/true
    else
        action "shard3_server stop is fail!" /bin/false
    fi
}

start_mongos(){
    ${MONGOS} -f ${mongos_configfile}
    if [ $? -eq 0 ];then
        action "router_server start is ok!" /bin/true
    else
        action "router_server is fail!" /bin/false
    fi
}

stop_mongos(){
    echo -e "\033[33mstop mongo cluster...\033[0m"
    killall mongod
    killall mongos
    sleep 3
    mongod_count=$(ps -ef | grep mongod | grep -v grep | wc -l)
    mongos_count=$(ps -ef | grep mongos | grep -v grep | wc -l)
    if [ ${mongod_count} -eq 0  -a ${mongos_count} -eq 0 ];then
        action "Mongos stop is normal!" /bin/true
        action "Mongod stop is normal!" /bin/true
    else
        action "Mongos stop is abnormal!" /bin/false
        action "Mongod stop is norabnormalmal!" /bin/false
    fi
}

start_all(){
    echo -e "\033[33mstart mongo cluster...\033[0m"
    start_config;
    start_shard1;
    start_shard2;
    start_shard3;
    start_mongos;
}
case $1 in
    start)
        start_all
    ;;
    stop)
        stop_mongos
    ;;
    *)
    echo "Usage: mongo start|stop"
esac
