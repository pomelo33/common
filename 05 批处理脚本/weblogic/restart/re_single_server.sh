#!/usr/bin/env bash
DATE=`date +%Y%m%d%H%M%S`
servername=$1  # Sever name
adminUrl=${2:-} #控制台IP地址#
adminPort=${3:-}  #控制台端口#
user=${4:-weblogic}

pid=$(ps -ef | grep weblogic | grep AdminServer | grep -v grep | awk '{print $2}')
domainBase=$(pwdx ${pid} | awk '{print $2}')

if [ "$user" = "root" ]; then
    echo "root 不能执行此操作"
else
    pid=`ps -ef|grep "Name=$servername"|grep -v grep|awk '{print $2}'`
    if [ $pid ];then
        echo "service still active, killing..."
        kill -9 $pid    
    else            
        echo "sevice stopped."
    fi

    cd $domainBase/bin
    nohup ./startManagedWebLogic.sh $servername $adminUrl:$adminPort &
fi

