#!/usr/bin/env bash
# 获取ServerName
# ServerName通过get_ServerName.py文件获取
# 获取运行ServerName的运行时间
sys_uptime=$(cat /proc/uptime | cut -d  " " -f1)
user_hz=$(getconf CLK_TCK)
base_name=$(basename $BASH_SOURCE)
log_dir="/root/test/.output.log"
NAME=$(egrep -w "ServerName" ${log_dir})

for i in ${NAME[*]};do
    servername=$(echo $i | cut -d : -f2)
    PID=$(ps -ef | grep weblogic | grep ${servername} | grep -v grep | awk '{print $2'})
    if [[ ! -z ${PID} && -f /proc/${PID}/stat ]];then
        up_time=$(cat /proc/${pid}/stat | cut -d " " -f22)
        run_time=$((${sys_uptime%.*}-${up_time}/${user_hz}))
        let run_hour=$((${run_time}/60/60))
        echo "${servername}_runtime:${run_hour}h"
    fi
done