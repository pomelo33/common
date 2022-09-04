#!/usr/bin/env bash
# 备份boot.properties文件
# 更新boot.properties文件中用户和密码
DATE=`date +%Y%m%d%H%M%S`
properties="${HOME}/.boot.properties"
# 获取工作目录
pid=$(ps -ef |grep weblogic | grep AdminServer | grep -v grep | awk '{print $2}')
domainBase=$(pwdx ${pid} | awk '{print $2}')

# 获取Server_Name,并复制boot.properties
NAME=$(egrep -w "ServerName" ~/.change_admin_pwd.log)
for i in ${NAME[*]};do
    servername=$(echo $i | cut -d : -f2)
    if [ ${servername} ];then
        mv ${domainBase}/servers/${servername}/security/boot.properties ${domainBase}/servers/${servername}/security/boot.properties_${DATE}
        cp ${properties} ${domainBase}/${servername}/servers/${servername}/security/boot.properties
        echo $servername
    else
        echo "The parameter is empty"
    fi
done
