#!/usr/bin/env bash
DATE=`date +%Y%m%d%H%M%S`
adminUrl=${1:-} #控制台IP地址
adminPort=${2:-}  #控制台端口
user=${3:-weblogic} # 用户
log_dir="${HOME}/.serverName.log"

# domain所在路径
pid=$(ps -ef | grep weblogic | grep AdminServer | grep -v grep | awk '{print $2}')
domainBase=$(pwdx ${pid} | awk '{print $2}')

# 获取Server_Name
NAME=$(egrep -w "ServerName" ${log_dir})
for i in ${NAME[*]};do
    servername=$(echo $i | cut -d : -f2)
    if [[ ${servername} != "AdminServer" ]];then
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

            cd ${domainBase}/bin
            nohup ./startManagedWebLogic.sh $servername $adminUrl:$adminPort &
        fi
        echo $servername
    else
        echo "AdminServer Exists"
    fi
done
