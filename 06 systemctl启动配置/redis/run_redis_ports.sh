#!/usr/bin/env bash
. /etc/rc.d/init.d/functions
BASEDIR='/usr/local/redis/bin'
CONFIG='/usr/local/redis/conf'


STARTREDIS(){
    if [ "${OPTION}" == "all" ];then
        local PORT=(50000 50039 50003 50031 50040)
        for i in ${PORT[@]};do
            ${BASEDIR}/redis-server ${CONFIG}/redis_${i}.conf
            if [ $? -eq 0 ];then
                action "Redis ${i} is OK."   /bin/true
            else
                action "Redis ${i} is Fail." /bin/false
            fi
        done
    else
        for i in ${OPTION[@]};do
            ${BASEDIR}/redis-server ${CONFIG}/redis_${i}.conf
            if [ $? -eq 0 ];then
                action "Redis ${i} is OK."   /bin/true
            else
                action "Redis ${i} is Fail." /bin/false
            fi
        done
    fi
}


STOPREDIS(){
    if [ "${OPTION}" == "all" ];then
        local PORT=(50000 50039 50003 50031 50040)
        for i in ${PORT[@]};do
            ${BASEDIR}/redis-cli -p ${i} shutdown
            if [ $? -eq 0 ];then
                action "Redis ${i} stop is OK."   /bin/true
            else
                action "Redis ${i} stop is Fail." /bin/false
            fi
        done
    else
        for i in ${OPTION[@]};do
            ${BASEDIR}/redis-cli -p ${i} shutdown
            if [ $? -eq 0 ];then
                action "Redis ${i} stop is OK."   /bin/true
            else
                action "Redis ${i} stop is Fail." /bin/false
            fi
        done
    fi
}

STATUS(){
    if [ "${OPTION}" == "all" ];then
        local PORT=(50000 50039 50003 50031 50040)
        for i in ${PORT[@]};do
            count=$(ps -ef | grep redis | grep -v grep | grep ${i} | wc -l)
            if [ ${count} -eq 1 ];then
                action "Redis ${i} is normal."   /bin/true
            else
                action "Redis ${i} is abnormal." /bin/false
            fi
        done
    else
        for i in ${OPTION[@]};do
            count=$(ps -ef | grep redis | grep -v grep | grep ${i} | wc -l)
            if [ ${count} -eq 1 ];then
                action "Redis ${i} stop is normal."   /bin/true
            else
                action "Redis ${i} stop is abnormal." /bin/false
            fi
        done
    fi
}


if [ $# -le 1 ];then
   echo "USAGE: start_redis.sh start|stop|status all or port!"
   exit 1
fi


case $1 in 
    start)
        echo "start redis service!"
        OPTION=(${@:2})
        STARTREDIS
        ;;
    stop)
        echo "stop redis service!"
        OPTION=(${@:2})
        STOPREDIS
        ;;
    status)
        OPTION=(${@:2})
        STATUS
        ;;
    *)
        echo "USAGE: start_redis.sh start|stop|status all or port!"
esac