#!/usr/bin/env bash
DATE=`date +%Y%m%d%H%M%S`      
user=${1:-weblogic}
serverName=AdminServer
pid=$(ps -ef | grep weblogic | grep AdminServer | grep -v grep | awk '{print $2}')
domainBase=$(pwdx ${pid} | awk '{print $2}')

restart(){
    if [ "$user" = "root" ]; then
        echo "root 不能执行此操作"
    else
        pid=`ps -ef|grep "Name=$serverName"|grep -v grep|awk '{print $2}'`
        if [ $pid ] ; then
                echo "service still active, killing..."
                kill -9 $pid    
        else            
                echo "sevice stopped."
        fi
        
        cd ${domainBase}/bin
        nohup ./startWebLogic.sh &
    fi
}

main(){
    backpwd
    restart
}

main 