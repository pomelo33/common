#!/bin/bash
# tar包下载链接: http://download.redis.io/releases/redis-5.0.9.tar.gz
REDIS_TAR_NAME=$1
REDIS_NAME=$2
DOWNLOADURL=$3
PASSWD=$4
DOWNLOAD=/tmp/redis/
REDISDIR=/usr/local
REDIS_RENAME=redis
COUNT=`ps aux | grep "redis-server" | grep -v grep | wc -l`
PORT=`ps aux | grep "redis-server" | grep -v grep | awk '{print $12}' | cut -d : -f2 | sed -n '1p'`

PACKAGE(){
    if [ -e "/usr/bin/wget" ];then
        echo "命令已安装"
    else
        yum install -y wget 
    fi

    if [ -d "${DOWNLOAD}" ];then
        echo "该目录存在!"
        if [ -e "${DOWNLOAD}/${REDIS_TAR_NAME}" ];then
            echo "tar包已存在"
        else
            wget -P ${DOWNLOAD} ${DOWNLOADURL}
        fi
    else
            mkdir -p ${DOWNLOAD} && wget -P ${DOWNLOAD} ${DOWNLOADURL}
            echo "redis压缩包下载完成!"
    fi
}

INSTALL(){
    if [ -d "${DOWNLOAD}" ];then
        cd ${DOWNLOAD} && tar -xzf ${REDIS_TAR_NAME}
        mv ${REDIS_NAME} ${REDISDIR}/${REDIS_RENAME} && cd ${REDISDIR}/${REDIS_RENAME} && make 
        cd ${REDISDIR}/${REDIS_RENAME}/src/ && make install
        mkdir ${REDISDIR}/${REDIS_RENAME}/{bin,etc}/ -p && cp ${REDISDIR}/${REDIS_RENAME}/redis.conf ${REDISDIR}/${REDIS_RENAME}/etc/ && cd ${REDISDIR}/${REDIS_RENAME}/src/ && cp mkreleasehdr.sh redis-benchmark redis-check-aof redis-cli redis-server ${REDISDIR}/${REDIS_RENAME}/bin/
        # 简单配置redis
        sed -i 's/bind/#&/' ${REDISDIR}/${REDIS_RENAME}/etc/redis.conf
        sed -i '$i requirepass '"${PASSWD}"'' ${REDISDIR}/${REDIS_RENAME}/etc/redis.conf
        sed -i '/^daemonize/s/no/yes/' ${REDISDIR}/${REDIS_RENAME}/etc/redis.conf
        sed -i '/^protected-mode/s/yes/no/' ${REDISDIR}/${REDIS_RENAME}/etc/redis.conf
        if [ $? -eq 0 ];then
            echo "redis已安装并初始化!!!!"
        else
            echo "FALSE"
        fi
    else
        echo "${DOWNLOAD}目录不存在!!"
    fi
}

STARTUP(){
    if [ -d "${REDISDIR}/${REDIS_RENAME}" ];then
        if [ $COUNT != 0 ];then
            echo "redis已经运行"
        else
            ${REDISDIR}/${REDIS_RENAME}/bin/redis-server ${REDISDIR}/${REDIS_RENAME}/etc/redis.conf
            if [ $? -eq 0 ];then
                echo "redis已启动!!!"
            else
                echo "FALSE"
            fi
        fi
    else
        echo "FALSE"
    fi
}   

STOP(){
    if [ -e "${REDISDIR}/${REDIS_RENAME}/bin/redis-cli" ];then
        if [ $COUNT != 0 ];then
            while (( $COUNT>0 ))
            do
                ${REDISDIR}/${REDIS_RENAME}/bin/redis-cli -p $PORT -a ${PASSWD} shutdown 2> /dev/null
                let "COUNT--"
            done
            echo "redis已停止运行"
        else
            echo "redis未运行"
        fi
    else
        echo "FALSE"
    fi
}

UNINSTALL(){
    if [ -d "${REDISDIR}/${REDIS_RENAME}" ];then
        rm -rf ${REDISDIR}/${REDIS_RENAME}
        rm -rf ${DOWNLOAD}/
        rm -rf /usr/local/bin/redis-*
        echo "reis相关目录已删除"
    else
        echo "${REDISDIR}/${REDIS_RENAME}目录不存在"
    fi
}

main(){
    PACKAGE;
    INSTALL;
    STARTUP;
}

unmain(){
    STOP;
    UNINSTALL;
}

main
#unmain