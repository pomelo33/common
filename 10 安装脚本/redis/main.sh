#!/bin/bash
FILE=$1

# 检查是否存在jq
command -v  jq >> /dev/null 2>&1
if [ "$?" -ne 0 ]; then
    yum install epel-release -y
    yum install jq -y
    sleep 60
fi

#获取配置参数
CurrentDir=$(dirname $(readlink -f "$0"))
EXECUTE_NEXT_STEP_FLAG=0
USER=$(jq -r ".redis_user" $FILE)
GROUP=$(jq -r ".redis_group" $FILE)
redis_basedir=$(jq -r ".redis_basedir" $FILE)
version=$(jq -r ".version" $FILE)
cluster_install=$(jq -r ".cluster_install" $FILE)
redis_port=$(jq -r ".software_config.redis_port" $FILE)
redis_pidfile=$(jq -r ".software_config.redis_pidfile" $FILE)
redis_daemonize=$(jq -r ".software_config.redis_daemonize" $FILE)
redis_logfile=$(jq -r ".software_config.redis_logfile" $FILE)
redis_bind=$(jq -r ".software_config.redis_bind" $FILE)
redis_rdbcompression=$(jq -r ".software_config.redis_rdbcompression" $FILE)
redis_rdbchecksum=$(jq -r ".software_config.redis_rdbchecksum" $FILE)
redis_appendonly=$(jq -r ".software_config.redis_appendonly" $FILE)
redis_dbfilename=$(jq -r ".software_config.redis_dbfilename" $FILE)
redis_dir=$(jq -r ".software_config.redis_dir" $FILE)
redis_password=$(jq -r ".software_config.redis_requirepass" $FILE)
redis_replica_serve_stale_data=$(jq -r ".software_config.redis_replica_serve_stale_data" $FILE)
redis_replica_read_only=$(jq -r ".software_config.redis_replica_read_only" $FILE)
redis_repl_diskless_sync=$(jq -r ".software_config.redis_repl_diskless_sync" $FILE)
redis_repl_diskless_sync_delay=$(jq -r ".software_config.redis_repl_diskless_sync_delay" $FILE)
redis_repl_disable_tcp_nodelay=$(jq -r ".software_config.redis_repl_disable_tcp_nodelay" $FILE)
redis_replica_priority=$(jq -r ".software_config.redis_replica_priority" $FILE)
redis_protected_mode=$(jq -r ".software_config.redis_protected_mode" $FILE)
redis_tcp_backlog=$(jq -r ".software_config.redis_tcp_backlog" $FILE)
redis_timeout=$(jq -r ".software_config.redis_timeout" $FILE)
redis_tcp_keepalive=$(jq -r ".software_config.redis_tcp_keepalive" $FILE)
redis_supervised=$(jq -r ".software_config.redis_supervised" $FILE)
redis_databases=$(jq -r ".software_config.redis_databases" $FILE)
redis_always_show_logo=$(jq -r ".software_config.redis_always_show_logo" $FILE)
redis_stop_writes_on_bgsave_error=$(jq -r ".software_config.redis_stop_writes_on_bgsave_error" $FILE)
Installation_mode=$(jq -r ".Installation_mode" $FILE)
redis_masterIP=$(jq -r ".redis_master.redis_ip" $FILE)
redis_replicaof=$(jq -r ".redis_slave.redis_replicaof" $FILE)
redis_masterauth=$(jq -r ".redis_slave.redis_masterauth" $FILE)

sentinel_port=$(jq -r ".sentinel_config.sentinel_port" $FILE)
sentinel_deny_scripts_reconfig=$(jq -r ".sentinel_config.sentinel_deny_scripts_reconfig" $FILE)
sentinel_monitor=$(jq -r ".sentinel_config.sentinel_monitor" $FILE)
sentinel_auth=$(jq -r ".sentinel_config.sentinel_auth" $FILE)
IPADDR=`ip a | grep ${redis_masterIP}`

field_check(){
    local keyword=$1
    local content=$2
    if [ -n "$content" ];then
        echo "$keyword $content" >> ${redis_basedir}/conf/redis-${redis_port}.conf
    fi
}

sentinel_field_check(){
    local keyword=$1
    local content=$2
    if [ -n "$content" ];then
        echo "$keyword $content" >> ${redis_basedir}/conf/sentinel-${sentinel_port}.conf
    fi
}

deploy_redis(){
    #判断系统中是否存在redis用户和redis用户组
    egrep "^${GROUP}" /etc/group >& /dev/null 
    if [ "$?" -ne 0 ];then
        groupadd ${GROUP}
    fi
    id ${USER} >& /dev/null 
    if [ "$?" -ne 0 ];then
        useradd -g ${GROUP} ${USER}
    fi
    [ ! -d ${redis_basedir} ] && mkdir -p $redis_basedir
    [ ! -d "$redis_dir" ] && mkdir -p $redis_dir
    chown -R ${USER}:${GROUP} $redis_dir
    chown -R ${USER}:${GROUP} $redis_basedir


    #安装redis所需要的依赖并安装redis
    yum -y install gcc make gcc-c++  ruby ruby-devel rubygems rpm-build
    if [ "$?" -ne 0 ];then
        echo "@###############################################@"
        echo "success: false"
        echo "message: yum install redis relay faild"
        echo "#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#"
    fi
    tar xf redis-${version}.tar.gz && mv redis-${version}/* ${redis_basedir}/
    mkdir -p ${redis_basedir}/{bin,conf,logs}
    cd ${redis_basedir} && make && cd ${redis_basedir}/src/ && make install && mv mkreleasehdr.sh redis-benchmark redis-check-aof redis-cli redis-server redis-sentinel ${redis_basedir}/bin/
    cd $CurrentDir
    redis_api
}

redis_api(){
    if [[ "${Installation_mode}" == "stand" ]];then
        redis_stand
        redis_start
    elif [[ "${Installation_mode}" == "master" ]];then
        redis_stand
        redis_master_slave
    elif [[ "${Installation_mode}" == "sentinel" ]];then
        redis_stand
        redis_master_slave
        redis_sentinel
    else
        echo "false"
    fi
}

redis_stand(){
    if [ -e ${redis_basedir}/conf/redis-${redis_port}.conf ];then
        rm -f ${redis_basedir}/conf/redis-${redis_port}.conf && touch ${redis_basedir}/conf/redis-${redis_port}.conf
    fi
    field_check daemonize $redis_daemonize
    # field_check pidfile $redis_pidfile
    echo "pidfile ${redis_basedir}/redis-${redis_port}.pid" >> ${redis_basedir}/conf/redis-${redis_port}.conf
    field_check dir ${redis_dir}
    field_check port $redis_port
    field_check bind $redis_bind
    field_check timeout $redis_timeout
    field_check "tcp-keepalive" $redis_tcp_keepalive
    # field_check logfile $redis_logfile
    echo "logfile ${redis_basedir}/logs/redis-${redis_port}.log"
    field_check "databases"  $redis_databases
    echo  "# Advanced" >> ${redis_basedir}/conf/redis-${redis_port}.conf
    echo "save 900 1" >> ${redis_basedir}/conf/redis-${redis_port}.conf
    echo "save 300 10" >> ${redis_basedir}/conf/redis-${redis_port}.conf
    echo "save 60 10000" >> ${redis_basedir}/conf/redis-${redis_port}.conf
    field_check "stop-writes-on-bgsave-error" $redis_stop_writes_on_bgsave_error
    field_check "rdbcompression" $redis_rdbcompression
    field_check "rdbchecksum" $redis_rdbchecksum
    field_check "dbfilename" $redis_db_filename
    echo "" >> ${redis_basedir}/conf/redis-${redis_port}.conf
    echo "# Security"  >> ${redis_basedir}/conf/redis-${redis_port}.conf
    field_check "requirepass" $redis_password
    echo "# Append Only Mode" >> ${redis_basedir}/conf/redis-${redis_port}.conf
    field_check "appendonly" $redis_appendonly
    field_check "replica-serve-stale-data" ${redis_replica_serve_stale_data}
    field_check "replica-read-only" ${redis_replica_read_only}
    field_check "repl-diskless-sync" ${redis_repl_diskless_sync}
    field_check "repl-diskless-sync-delay" ${redis_repl_diskless_sync_delay}
    field_check "repl-disable-tcp-nodelay" ${redis_repl_disable_tcp_nodelay}
    field_check "protected-mode" ${redis_protected_mode}
    field_check "tcp-backlog" ${redis_tcp_backlog}
    field_check "tcp-keepalive" ${redis_tcp_keepalive}
    field_check "supervised" ${redis_supervised}
    field_check "databases" ${redis_databases}
    field_check "always-show-logo" ${redis_always_show_logo}
}

redis_master_slave(){
    field_check "masterauth" ${redis_masterauth}
    if [[ ! -n ${IPADDR}  ]];then
        field_check "replicaof" "${redis_replicaof}"
    fi
    redis_start
}

redis_sentinel(){
    if [ -e ${redis_basedir}/conf/sentinel-${sentinel_port}.conf ];then
        rm -f ${redis_basedir}/conf/sentinel-${sentinel_port}.conf && touch ${redis_basedir}/conf/sentinel-${sentinel_port}.conf
    fi
    sentinel_field_check "daemonize" ${redis_daemonize}
    echo "logfile ${redis_basedir}/logs/sentinel-${sentinel_port}.log" >> ${redis_basedir}/conf/sentinel-${sentinel_port}.conf
    echo "pidfile ${redis_basedir}/sentinel-${sentinel_port}.pid" >> ${redis_basedir}/conf/sentinel-${sentinel_port}.conf
    sentinel_field_check "protected-mode" ${redis_protected_mode}
    sentinel_field_check "dir" ${redis_dir}
    sentinel_field_check "sentinel deny-scripts-reconfig" ${sentinel_deny_scripts_reconfig}
    sentinel_field_check "sentinel monitor" "${sentinel_monitor}"
    sentinel_field_check "sentinel auth-pass" "${sentinel_auth}"
    redis_sentinel_start
}


redis_start(){
    chown -R ${USER}:${GROUP} ${redis_basedir}
    su ${USER} -c " ${redis_basedir}/bin/redis-server ${redis_basedir}/conf/redis-${redis_port}.conf"
}
redis_sentinel_start(){
    chown -R ${USER}:${GROUP} ${redis_basedir}
    sleep 5
    su  ${USER} -c "${redis_basedir}/bin/redis-sentinel ${redis_basedir}/conf/sentinel-${sentinel_port}.conf"
}

main(){
    deploy_redis;
    if [ "$?" -eq 0 ];then
    echo "@###############################################@"
    echo "success: true"
    echo "message: redis deploied success"
    echo "#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#"
    else
    echo "@###############################################@"
    echo "success: false"
    echo "message: redis config file error"
    echo "#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#"
    fi
}

main
